import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'storage_service.dart';
import '../data_sources/remote/photo_service.dart';

class PhotoManager {
  static PhotoManager? _instance;
  static PhotoManager get instance => _instance ??= PhotoManager._();

  PhotoManager._();

  final _uuid = const Uuid();
  final _storage = StorageService.instance;
  final _photoService = PhotoService.instance;

  /// Save a photo locally and upload to server
  Future<String?> savePhoto({
    required Uint8List imageBytes,
    String? caption,
    List<String>? tags,
    String? location,
  }) async {
    try {
      final photoId = _uuid.v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Save locally first
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${directory.path}/photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      final filePath = '${photosDir.path}/$photoId.jpg';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Save local metadata
      final now = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final photoData = {
        'id': photoId,
        'filePath': filePath,
        'timestamp': timestamp,
        'caption': caption ?? '',
        'tags': tags ?? <String>[],
        'location': location ?? '',
        'createdAt': now.toIso8601String(),
        'dateString': '${now.day}/${now.month}/${now.year}',
        'timeString': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'dayOfWeek': _getDayOfWeek(now.weekday),
        'fileSize': imageBytes.lengthInBytes,
        'source': 'camera',
        'quality': 'high',
      };
      await _storage.savePhoto(photoId, photoData);

      // Upload to server
      final userId = _storage.userId;
      if (userId != null) {
        final result = await _photoService.uploadPhoto(
          localFilePath: filePath,
          userId: userId,
          caption: caption,
        );
        if (result != null) {
          await _storage.savePhoto(photoId, {
            ...photoData,
            'remoteId': result.id,
            's3Key': result.s3Key,
            'uploaded': true,
          });
        }
      }

      return photoId;
    } catch (e) {
      debugPrint('Error saving photo: $e');
      return null;
    }
  }

  /// Get all photos - fetch from API with local fallback
  Future<List<Map<String, dynamic>>> getAllPhotos() async {
    try {
      final userId = _storage.userId;
      if (userId != null) {
        final remotePhotos = await _photoService.getUserPhotos(userId);
        if (remotePhotos.isNotEmpty) {
          return remotePhotos.map((dto) => dto.toJson()).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching remote photos: $e');
    }
    // Fallback to local
    return _storage.getAllPhotos();
  }

  /// Get all photos from local storage only (sync)
  List<Map<String, dynamic>> getLocalPhotos() {
    return _storage.getAllPhotos();
  }

  /// Get a specific photo
  Map<String, dynamic>? getPhoto(String photoId) {
    return _storage.getPhoto(photoId);
  }

  /// Update photo data
  Future<bool> updatePhoto(String photoId, Map<String, dynamic> updates) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto == null) return false;

      final updatedPhoto = {...existingPhoto, ...updates};
      await _storage.savePhoto(photoId, updatedPhoto);
      return true;
    } catch (e) {
      debugPrint('Error updating photo: $e');
      return false;
    }
  }

  /// Delete a photo locally and from server
  Future<bool> deletePhoto(String photoId) async {
    try {
      final photo = _storage.getPhoto(photoId);
      if (photo == null) return false;

      // Delete local files
      final filePath = photo['filePath'] as String?;
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Delete from server if uploaded
      final remoteId = photo['remoteId'] as String?;
      if (remoteId != null) {
        await _photoService.deletePhoto(remoteId);
      }

      await _storage.deletePhoto(photoId);
      return true;
    } catch (e) {
      debugPrint('Error deleting photo: $e');
      return false;
    }
  }

  /// Get photos by date range
  List<Map<String, dynamic>> getPhotosByDateRange(DateTime startDate, DateTime endDate) {
    final allPhotos = _storage.getAllPhotos();
    return allPhotos.where((photo) {
      final timestamp = photo['timestamp'] as int? ?? 0;
      final photoDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return photoDate.isAfter(startDate) && photoDate.isBefore(endDate);
    }).toList();
  }

  /// Get photos with specific tags
  List<Map<String, dynamic>> getPhotosByTags(List<String> tags) {
    final allPhotos = _storage.getAllPhotos();
    return allPhotos.where((photo) {
      final photoTags = List<String>.from(photo['tags'] ?? []);
      return tags.any((tag) => photoTags.contains(tag));
    }).toList();
  }

  /// Get photo count
  int getPhotoCount() {
    return _storage.getAllPhotos().length;
  }

  String _getDayOfWeek(int weekday) {
    const days = [
      'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm',
      'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
    ];
    return days[weekday - 1];
  }
}
