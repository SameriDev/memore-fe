import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'storage_service.dart';
import 'user_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoStorageManager {
  static PhotoStorageManager? _instance;
  static PhotoStorageManager get instance =>
      _instance ??= PhotoStorageManager._();

  PhotoStorageManager._();

  final _storage = StorageService.instance;
  final _userManager = UserManager.instance;
  final _uuid = const Uuid();

  /// Request storage permission for saving photos
  Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), we need different permissions
        final androidInfo = await Permission.storage.status;

        if (androidInfo.isDenied) {
          final result = await Permission.storage.request();
          if (result.isDenied) {
            // Try requesting manage external storage for Android 11+
            final manageResult = await Permission.manageExternalStorage.request();
            return manageResult.isGranted;
          }
          return result.isGranted;
        }
        return androidInfo.isGranted;
      }

      // For iOS, no special permission needed for app documents
      return true;
    } catch (e) {
      // If permission handling fails, allow saving to fallback location
      return true;
    }
  }

  /// Save captured photo to external storage (public memore folder)
  Future<String?> savePhoto({
    required String imagePath,
    String? caption,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return null;

      // Request storage permission
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) return null;

      // Generate unique photo ID
      final photoId =
          'photo_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}';

      // Get external storage directory for public access
      Directory? photosDir;

      if (Platform.isAndroid) {
        // Try to get external storage directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Navigate to public storage: /storage/emulated/0/memore
          final pathParts = externalDir.path.split('/');
          final androidIndex = pathParts.indexOf('Android');
          if (androidIndex > 0) {
            final publicPath = pathParts.sublist(0, androidIndex).join('/');
            photosDir = Directory('$publicPath/memore');
          }
        }
      }

      // Fallback to downloads directory
      if (photosDir == null) {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          photosDir = Directory('${downloadsDir.path}/memore');
        }
      }

      // Final fallback to app documents directory
      if (photosDir == null) {
        final appDir = await getApplicationDocumentsDirectory();
        photosDir = Directory('${appDir.path}/memore');
      }

      // Create photos directory if it doesn't exist
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Read original image file
      final originalFile = File(imagePath);
      if (!await originalFile.exists()) {
        return null;
      }

      // Copy to app storage with new filename
      final extension = imagePath.split('.').last;
      final newFileName = '$photoId.$extension';
      final newFilePath = '${photosDir.path}/$newFileName';
      await originalFile.copy(newFilePath);

      // Create photo metadata
      final photoMetadata = {
        'id': photoId,
        'originalPath': imagePath,
        'storagePath': newFilePath,
        'fileName': newFileName,
        'caption': caption ?? '',
        'ownerId': userId,
        'ownerName': _userManager.getCurrentUser()?['name'] ?? 'You',
        'ownerAvatar':
            _userManager.getCurrentUser()?['avatarUrl'] ??
            'https://api.dicebear.com/7.x/avataaars/png?seed=user',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'createdAt': DateTime.now().toIso8601String(),
        'size': await originalFile.length(),
        'likesCount': 0,
        'commentsCount': 0,
        'sharesCount': 0,
        'isLiked': false,
        'metadata': metadata ?? {},
      };

      // Save photo metadata to storage
      await _savePhotoMetadata(photoId, photoMetadata);

      // Add to user's photos list
      await _addToUserPhotosList(photoId);

      return photoId;
    } catch (e) {
      return null;
    }
  }

  /// Save photo metadata to storage
  Future<void> _savePhotoMetadata(
    String photoId,
    Map<String, dynamic> metadata,
  ) async {
    await _storage.savePhoto(photoId, metadata);
  }

  /// Add photo to user's photos list
  Future<void> _addToUserPhotosList(String photoId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final photosKey = 'user_photos_$userId';
      final existingPhotos =
          _storage.getSetting<List<dynamic>>(photosKey, defaultValue: []) ?? [];
      final userPhotos = List<String>.from(existingPhotos);

      // Add new photo to beginning of list
      userPhotos.insert(0, photoId);

      // Keep only last 1000 photos
      if (userPhotos.length > 1000) {
        userPhotos.removeRange(1000, userPhotos.length);
      }

      await _storage.saveSetting(photosKey, userPhotos);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get photo metadata by ID
  Map<String, dynamic>? getPhotoMetadata(String photoId) {
    try {
      return _storage.getPhoto(photoId);
    } catch (e) {
      return null;
    }
  }

  /// Get photo file path
  String? getPhotoPath(String photoId) {
    final metadata = getPhotoMetadata(photoId);
    return metadata?['storagePath'] as String?;
  }

  /// Get all user's photos
  List<Map<String, dynamic>> getUserPhotos({int limit = 50}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final photosKey = 'user_photos_$userId';
      final photoIds =
          _storage.getSetting<List<dynamic>>(photosKey, defaultValue: []) ?? [];
      final userPhotoIds = List<String>.from(photoIds);

      final photos = <Map<String, dynamic>>[];
      for (final photoId in userPhotoIds.take(limit)) {
        final metadata = getPhotoMetadata(photoId);
        if (metadata != null) {
          // Check if photo file still exists
          final photoPath = metadata['storagePath'] as String?;
          if (photoPath != null && File(photoPath).existsSync()) {
            photos.add(metadata);
          }
        }
      }

      return photos;
    } catch (e) {
      return [];
    }
  }

  /// Get recent photos (last 24 hours)
  List<Map<String, dynamic>> getRecentPhotos({int limit = 20}) {
    final allPhotos = getUserPhotos(limit: limit * 2);
    final dayAgo = DateTime.now().subtract(const Duration(days: 1));

    return allPhotos
        .where((photo) {
          final timestamp = photo['timestamp'] as int?;
          if (timestamp == null) return false;
          final photoDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
          return photoDate.isAfter(dayAgo);
        })
        .take(limit)
        .toList();
  }

  /// Delete photo
  Future<bool> deletePhoto(String photoId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      // Get photo metadata
      final metadata = getPhotoMetadata(photoId);
      if (metadata == null) return false;

      // Delete physical file
      final photoPath = metadata['storagePath'] as String?;
      if (photoPath != null) {
        final file = File(photoPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove from metadata storage
      await _storage.deletePhoto(photoId);

      // Remove from user's photos list
      final photosKey = 'user_photos_$userId';
      final existingPhotos =
          _storage.getSetting<List<dynamic>>(photosKey, defaultValue: []) ?? [];
      final userPhotos = List<String>.from(existingPhotos);
      userPhotos.remove(photoId);
      await _storage.saveSetting(photosKey, userPhotos);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get photos count
  int getUserPhotosCount() {
    final photos = getUserPhotos();
    return photos.length;
  }

  /// Get storage usage in bytes
  Future<int> getStorageUsage() async {
    try {
      final photos = getUserPhotos(limit: 10000);
      int totalSize = 0;

      for (final photo in photos) {
        final size = photo['size'] as int? ?? 0;
        totalSize += size;
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Get storage usage in human readable format
  Future<String> getStorageUsageFormatted() async {
    final bytes = await getStorageUsage();

    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Clean up old photos (keep last N photos)
  Future<int> cleanupOldPhotos({int keepCount = 500}) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return 0;

      final photosKey = 'user_photos_$userId';
      final existingPhotos =
          _storage.getSetting<List<dynamic>>(photosKey, defaultValue: []) ?? [];
      final userPhotos = List<String>.from(existingPhotos);

      if (userPhotos.length <= keepCount) return 0;

      // Get photos to delete
      final photosToDelete = userPhotos.skip(keepCount).toList();
      int deletedCount = 0;

      for (final photoId in photosToDelete) {
        final success = await deletePhoto(photoId);
        if (success) deletedCount++;
      }

      return deletedCount;
    } catch (e) {
      return 0;
    }
  }

  /// Check if photo exists
  bool photoExists(String photoId) {
    final metadata = getPhotoMetadata(photoId);
    if (metadata == null) return false;

    final photoPath = metadata['storagePath'] as String?;
    if (photoPath == null) return false;

    return File(photoPath).existsSync();
  }

  /// Get photo file
  File? getPhotoFile(String photoId) {
    final photoPath = getPhotoPath(photoId);
    if (photoPath == null) return null;

    final file = File(photoPath);
    return file.existsSync() ? file : null;
  }

  /// Initialize photos directory in external storage
  Future<void> initializeStorage() async {
    try {
      // Request storage permission first
      await _requestStoragePermission();

      // Get external storage directory for public access
      Directory? photosDir;

      if (Platform.isAndroid) {
        // Try to get external storage directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Navigate to public storage: /storage/emulated/0/memore
          final pathParts = externalDir.path.split('/');
          final androidIndex = pathParts.indexOf('Android');
          if (androidIndex > 0) {
            final publicPath = pathParts.sublist(0, androidIndex).join('/');
            photosDir = Directory('$publicPath/memore');
          }
        }
      }

      // Fallback to downloads directory
      if (photosDir == null) {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          photosDir = Directory('${downloadsDir.path}/memore');
        }
      }

      // Final fallback to app documents directory
      if (photosDir == null) {
        final appDir = await getApplicationDocumentsDirectory();
        photosDir = Directory('${appDir.path}/memore');
      }

      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
    } catch (e) {
      // Ignore initialization errors
    }
  }

  /// Clear all photos data (for testing/reset)
  Future<void> clearAllPhotos() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      // Get all photo IDs
      final photosKey = 'user_photos_$userId';
      final existingPhotos =
          _storage.getSetting<List<dynamic>>(photosKey, defaultValue: []) ?? [];
      final userPhotos = List<String>.from(existingPhotos);

      // Delete each photo
      for (final photoId in userPhotos) {
        await deletePhoto(photoId);
      }

      // Clear photos list
      await _storage.saveSetting(photosKey, <String>[]);
    } catch (e) {
      // Ignore errors
    }
  }
}
