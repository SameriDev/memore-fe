import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'storage_service.dart';

class PhotoManager {
  static PhotoManager? _instance;
  static PhotoManager get instance => _instance ??= PhotoManager._();

  PhotoManager._();

  final _uuid = const Uuid();
  final _storage = StorageService.instance;

  /// Save a photo to local storage
  Future<String?> savePhoto({
    required Uint8List imageBytes,
    String? caption,
    List<String>? tags,
    String? location,
  }) async {
    try {
      // Generate unique photo ID
      final photoId = _uuid.v4();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${directory.path}/photos');

      // Create photos directory if it doesn't exist
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Save image file
      final filePath = '${photosDir.path}/$photoId.jpg';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Create thumbnail
      final thumbnailPath = await _createThumbnail(imageBytes, photoId);

      // Save photo metadata with enhanced information
      final now = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final photoData = {
        'id': photoId,
        'filePath': filePath,
        'thumbnailPath': thumbnailPath,
        'timestamp': timestamp,
        'caption': caption ?? '',
        'tags': tags ?? <String>[],
        'location': location ?? '',
        'isLiked': false,
        'likeCount': 0,
        'commentCount': 0,
        'isShared': false,
        'createdAt': now.toIso8601String(),
        'dateString': '${now.day}/${now.month}/${now.year}',
        'timeString': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'dayOfWeek': _getDayOfWeek(now.weekday),
        'fileSize': imageBytes.lengthInBytes,
        'source': 'camera',
        'quality': 'high',
      };

      await _storage.savePhoto(photoId, photoData);

      return photoId;
    } catch (e) {
      print('Error saving photo: $e');
      return null;
    }
  }

  /// Create a thumbnail for the photo
  Future<String?> _createThumbnail(Uint8List originalBytes, String photoId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final thumbnailsDir = Directory('${directory.path}/thumbnails');

      if (!await thumbnailsDir.exists()) {
        await thumbnailsDir.create(recursive: true);
      }

      final thumbnailPath = '${thumbnailsDir.path}/${photoId}_thumb.jpg';

      // For now, just save the same image as thumbnail
      // In a real app, you'd resize it to a smaller size
      final file = File(thumbnailPath);
      await file.writeAsBytes(originalBytes);

      return thumbnailPath;
    } catch (e) {
      print('Error creating thumbnail: $e');
      return null;
    }
  }

  /// Get all photos from local storage
  List<Map<String, dynamic>> getAllPhotos() {
    return _storage.getAllPhotos();
  }

  /// Get a specific photo
  Map<String, dynamic>? getPhoto(String photoId) {
    return _storage.getPhoto(photoId);
  }

  /// Update photo data (like, caption, etc.)
  Future<bool> updatePhoto(String photoId, Map<String, dynamic> updates) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto == null) return false;

      final updatedPhoto = {...existingPhoto, ...updates};
      await _storage.savePhoto(photoId, updatedPhoto);
      return true;
    } catch (e) {
      print('Error updating photo: $e');
      return false;
    }
  }

  /// Toggle like on a photo
  Future<bool> toggleLike(String photoId) async {
    try {
      final photo = _storage.getPhoto(photoId);
      if (photo == null) return false;

      final isLiked = photo['isLiked'] as bool? ?? false;
      final likeCount = photo['likeCount'] as int? ?? 0;

      await updatePhoto(photoId, {
        'isLiked': !isLiked,
        'likeCount': !isLiked ? likeCount + 1 : likeCount - 1,
      });

      return !isLiked;
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  /// Add a comment to a photo
  Future<bool> addComment(String photoId, String comment) async {
    try {
      final photo = _storage.getPhoto(photoId);
      if (photo == null) return false;

      final comments = List<Map<String, dynamic>>.from(photo['comments'] ?? []);
      final commentCount = photo['commentCount'] as int? ?? 0;

      comments.add({
        'id': _uuid.v4(),
        'text': comment,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userId': _storage.userId ?? 'current_user',
        'userName': 'You',
      });

      await updatePhoto(photoId, {
        'comments': comments,
        'commentCount': commentCount + 1,
      });

      return true;
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }

  /// Delete a photo
  Future<bool> deletePhoto(String photoId) async {
    try {
      final photo = _storage.getPhoto(photoId);
      if (photo == null) return false;

      // Delete files
      final filePath = photo['filePath'] as String?;
      final thumbnailPath = photo['thumbnailPath'] as String?;

      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      if (thumbnailPath != null) {
        final thumbnailFile = File(thumbnailPath);
        if (await thumbnailFile.exists()) {
          await thumbnailFile.delete();
        }
      }

      // Delete from storage
      await _storage.deletePhoto(photoId);
      return true;
    } catch (e) {
      print('Error deleting photo: $e');
      return false;
    }
  }

  /// Get photos by date range
  List<Map<String, dynamic>> getPhotosByDateRange(DateTime startDate, DateTime endDate) {
    final allPhotos = getAllPhotos();
    return allPhotos.where((photo) {
      final timestamp = photo['timestamp'] as int? ?? 0;
      final photoDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return photoDate.isAfter(startDate) && photoDate.isBefore(endDate);
    }).toList();
  }

  /// Get photos with specific tags
  List<Map<String, dynamic>> getPhotosByTags(List<String> tags) {
    final allPhotos = getAllPhotos();
    return allPhotos.where((photo) {
      final photoTags = List<String>.from(photo['tags'] ?? []);
      return tags.any((tag) => photoTags.contains(tag));
    }).toList();
  }

  /// Get liked photos
  List<Map<String, dynamic>> getLikedPhotos() {
    final allPhotos = getAllPhotos();
    return allPhotos.where((photo) => photo['isLiked'] == true).toList();
  }

  /// Get photo count
  int getPhotoCount() {
    return getAllPhotos().length;
  }

  /// Get day of week in Vietnamese
  String _getDayOfWeek(int weekday) {
    const days = [
      'Thứ Hai',   // Monday
      'Thứ Ba',    // Tuesday
      'Thứ Tư',    // Wednesday
      'Thứ Năm',   // Thursday
      'Thứ Sáu',   // Friday
      'Thứ Bảy',   // Saturday
      'Chủ Nhật',  // Sunday
    ];
    return days[weekday - 1];
  }

  /// Create a mock photo album
  Future<void> createMockPhotos() async {
    // This method can be used to create some demo photos for testing
    // It would download some sample images and save them as user photos
    // Currently disabled to avoid creating empty photos in demo

    // In the future, implement actual photo download and creation here

    // Example implementation would be:
    // 1. Download sample images from Unsplash/Picsum
    // 2. Convert to Uint8List
    // 3. Call savePhoto() for each sample

    print('Mock photo creation not implemented yet');
  }
}