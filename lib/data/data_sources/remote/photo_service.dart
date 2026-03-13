import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_client.dart';
import '../../models/photo_dto.dart';

/// Cache entry cho presigned URLs với TTL management
class CachedPresignedUrl {
  final String url;
  final DateTime cachedAt;
  final Duration ttl;

  CachedPresignedUrl(this.url, this.cachedAt, this.ttl);

  bool get isExpired => DateTime.now().isAfter(cachedAt.add(ttl));
}

/// Photo timeline DTO cho friend timeline loading
class PhotoTimelineDto {
  final String id;
  final String ownerId;
  final String ownerName;
  final String? ownerAvatarUrl;
  final String s3Key;
  final String? s3ThumbnailKey;
  final String presignedUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? location;
  final List<String>? tags;
  final int? likeCount;
  final int? commentCount;
  final bool? isLiked;
  final bool? isShared;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? albumId;
  final String? albumName;
  final String? cacheStatus;

  PhotoTimelineDto({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    this.ownerAvatarUrl,
    required this.s3Key,
    this.s3ThumbnailKey,
    required this.presignedUrl,
    this.thumbnailUrl,
    this.caption,
    this.location,
    this.tags,
    this.likeCount,
    this.commentCount,
    this.isLiked,
    this.isShared,
    required this.createdAt,
    required this.updatedAt,
    this.albumId,
    this.albumName,
    this.cacheStatus,
  });

  factory PhotoTimelineDto.fromJson(Map<String, dynamic> json) {
    return PhotoTimelineDto(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerAvatarUrl: json['ownerAvatarUrl'] as String?,
      s3Key: json['s3Key'] as String,
      s3ThumbnailKey: json['s3ThumbnailKey'] as String?,
      presignedUrl: json['presignedUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      likeCount: json['likeCount'] as int?,
      commentCount: json['commentCount'] as int?,
      isLiked: json['isLiked'] as bool?,
      isShared: json['isShared'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      albumId: json['albumId'] as String?,
      albumName: json['albumName'] as String?,
      cacheStatus: json['cacheStatus'] as String?,
    );
  }

  /// Lấy display URL (thumbnail nếu có, fallback về full size)
  String get displayUrl => thumbnailUrl ?? presignedUrl;
}

class PhotoService {
  static PhotoService? _instance;
  static PhotoService get instance => _instance ??= PhotoService._();

  PhotoService._();

  final Dio _dio = ApiClient.instance.dio;
  final _uuid = const Uuid();

  // Enhanced caching mechanism cho presigned URLs
  final Map<String, CachedPresignedUrl> _urlCache = {};
  static const Duration _defaultCacheTTL = Duration(hours: 22); // 2h trước khi backend URL expires
  static const int _maxCacheSize = 500;

  // Statistics tracking
  int _cacheHits = 0;
  int _cacheMisses = 0;
  int _totalRequests = 0;

  /// Upload photo to server: upload file + create record
  Future<PhotoDto?> uploadPhoto({
    required String localFilePath,
    required String userId,
    String? caption,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Step 1: Upload file to R2 storage
      final photoName = '${_uuid.v4()}.jpg';
      final s3Key = 'users/$userId/photos/$photoName';

      final file = File(localFilePath);
      final fileSizeBytes = await file.length();
      debugPrint('📤 Uploading photo: ${(fileSizeBytes / 1024 / 1024).toStringAsFixed(2)} MB, path: $localFilePath');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          localFilePath,
          filename: photoName,
        ),
      });

      final uploadResponse = await _dio.post(
        '/api/photos/storage/upload',
        data: formData,
        queryParameters: {'key': s3Key},
        onSendProgress: onProgress,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 300),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      if (uploadResponse.data['success'] != true) {
        debugPrint('Photo upload failed: ${uploadResponse.data}');
        return null;
      }

      final fileSize = uploadResponse.data['size'] as int?;

      // Step 2: Create photo record
      final recordResponse = await _dio.post('/api/photos', data: {
        'ownerId': userId,
        'filePath': s3Key,
        's3Key': s3Key,
        'caption': caption ?? '',
        'quality': 'HIGH',
        'source': 'CAMERA',
        'fileSize': fileSize,
      });

      return PhotoDto.fromJson(recordResponse.data);
    } on DioException catch (e) {
      debugPrint('Photo upload error: ${e.message}');
      debugPrint('Photo upload DioExceptionType: ${e.type}');
      debugPrint('Photo upload inner error: ${e.error}');
      debugPrint('Photo upload stackTrace: ${e.stackTrace}');
      return null;
    } catch (e, stackTrace) {
      debugPrint('Photo upload error: $e');
      debugPrint('Photo upload stackTrace: $stackTrace');
      return null;
    }
  }

  /// Upload avatar to S3 storage (no photo record created)
  Future<String?> uploadAvatar({
    required String localFilePath,
    required String userId,
  }) async {
    try {
      final avatarName = '${_uuid.v4()}.jpg';
      final s3Key = 'users/$userId/avatars/$avatarName';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          localFilePath,
          filename: avatarName,
        ),
      });

      final uploadResponse = await _dio.post(
        '/api/photos/storage/upload',
        data: formData,
        queryParameters: {'key': s3Key},
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 300),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      if (uploadResponse.data['success'] == true) {
        return s3Key;
      }
      debugPrint('Avatar upload failed: ${uploadResponse.data}');
      return null;
    } on DioException catch (e) {
      debugPrint('Avatar upload error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      return null;
    }
  }

  /// Get all photos for a user
  Future<List<PhotoDto>> getUserPhotos(String userId) async {
    try {
      final response = await _dio.get('/api/photos/user/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => PhotoDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get user photos error: ${e.message}');
      return [];
    }
  }

  /// Get single photo by ID
  Future<PhotoDto?> getPhoto(String photoId) async {
    try {
      final response = await _dio.get('/api/photos/$photoId');
      return PhotoDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Get photo error: ${e.message}');
      return null;
    }
  }

  /// Delete photo (record + storage)
  Future<bool> deletePhoto(String photoId) async {
    try {
      await _dio.delete('/api/photos/$photoId');
      return true;
    } on DioException catch (e) {
      debugPrint('Delete photo error: ${e.message}');
      return false;
    }
  }

  /// Get photos by album ID
  Future<List<PhotoDto>> getAlbumPhotos(String albumId) async {
    try {
      final response = await _dio.get('/api/photos/album/$albumId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => PhotoDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get album photos error: ${e.message}');
      return [];
    }
  }

  /// Add a photo to an album by updating its albumId
  Future<bool> addPhotoToAlbum(String photoId, String albumId) async {
    try {
      await _dio.put('/api/photos/$photoId', data: {
        'albumId': albumId,
      });
      return true;
    } on DioException catch (e) {
      debugPrint('Add photo to album error: ${e.message}');
      return false;
    }
  }

  /// Update photo caption and note
  Future<bool> updatePhotoCaption(String photoId, String caption, {String? note}) async {
    try {
      final data = <String, dynamic>{
        'caption': caption,
      };
      if (note != null) {
        data['note'] = note;
      }
      await _dio.put('/api/photos/$photoId', data: data);
      return true;
    } on DioException catch (e) {
      debugPrint('Update photo caption error: ${e.message}');
      return false;
    }
  }

  /// Get presigned URL cho một S3 key với caching
  Future<String?> getPresignedUrl(String s3Key) async {
    _totalRequests++;

    // Check cache trước
    final cached = _urlCache[s3Key];
    if (cached != null && !cached.isExpired) {
      _cacheHits++;
      debugPrint('🎯 Cache hit cho S3 key: ${s3Key.split('/').last}');
      return cached.url;
    }

    _cacheMisses++;

    try {
      final response = await _dio.get(
        '/api/photos/storage/url',
        queryParameters: {'key': s3Key},
      );
      if (response.data['success'] == true) {
        final url = response.data['presignedUrl'] as String;

        // Cache URL với TTL
        _cacheUrl(s3Key, url, _defaultCacheTTL);

        debugPrint('📥 Cached presigned URL cho: ${s3Key.split('/').last}');
        return url;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Get presigned URL error: ${e.message}');
      return null;
    }
  }

  /// Batch get presigned URLs cho multiple S3 keys
  Future<Map<String, String>> batchGetPresignedUrls(List<String> s3Keys) async {
    if (s3Keys.isEmpty) return {};

    final results = <String, String>{};
    final keysToFetch = <String>[];

    // Check cache cho tất cả keys
    for (final key in s3Keys) {
      _totalRequests++;
      final cached = _urlCache[key];
      if (cached != null && !cached.isExpired) {
        _cacheHits++;
        results[key] = cached.url;
        debugPrint('🎯 Batch cache hit cho: ${key.split('/').last}');
      } else {
        _cacheMisses++;
        keysToFetch.add(key);
      }
    }

    if (keysToFetch.isEmpty) {
      debugPrint('📦 All batch URLs từ cache (${s3Keys.length} keys)');
      return results;
    }

    // Fetch URLs for keys không có trong cache
    final futures = keysToFetch.map((key) => _fetchSinglePresignedUrl(key));
    final fetchedUrls = await Future.wait(futures);

    // Combine results
    for (int i = 0; i < keysToFetch.length; i++) {
      final url = fetchedUrls[i];
      if (url != null) {
        results[keysToFetch[i]] = url;
      }
    }

    debugPrint('📦 Batch presigned URLs completed - Cache: ${results.length - fetchedUrls.where((url) => url != null).length}, Fetched: ${fetchedUrls.where((url) => url != null).length}');
    return results;
  }

  /// Private helper để fetch single presigned URL
  Future<String?> _fetchSinglePresignedUrl(String s3Key) async {
    try {
      final response = await _dio.get(
        '/api/photos/storage/url',
        queryParameters: {'key': s3Key},
      );
      if (response.data['success'] == true) {
        final url = response.data['presignedUrl'] as String;
        _cacheUrl(s3Key, url, _defaultCacheTTL);
        return url;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Fetch presigned URL error cho ${s3Key}: ${e.message}');
      return null;
    }
  }

  /// Get photo count for a user (for real-time counting)
  Future<int> getPhotoCountByUserId(String userId) async {
    try {
      final response = await _dio.get('/api/photos/count/user/$userId');
      return response.data as int;
    } on DioException catch (e) {
      debugPrint('Get photo count error: ${e.message}');
      return 0;
    }
  }

  // ===== FRIEND TIMELINE OPERATIONS =====

  /// Lấy friend timeline photos với presigned URLs đã được generate
  Future<List<PhotoTimelineDto>> getFriendTimelinePhotos(
    String friendUserId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/timeline/friend/$friendUserId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final List<dynamic> photosData = response.data['photos'] as List<dynamic>;
        final photos = photosData.map((json) => PhotoTimelineDto.fromJson(json)).toList();

        debugPrint('📸 Friend timeline loaded: ${photos.length} photos for $friendUserId');
        return photos;
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Get friend timeline error: ${e.message}');
      return [];
    }
  }

  /// Lấy friend timeline photos với filters
  Future<List<PhotoTimelineDto>> getFriendTimelinePhotosFiltered(
    String friendUserId, {
    String? albumId,
    String? startDate,
    String? endDate,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (albumId != null) queryParams['albumId'] = albumId;
      if (startDate != null) queryParams['startDate'] = startDate;
      if (endDate != null) queryParams['endDate'] = endDate;

      final response = await _dio.get(
        '/api/timeline/friend/$friendUserId/filtered',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> photosData = response.data['photos'] as List<dynamic>;
        final photos = photosData.map((json) => PhotoTimelineDto.fromJson(json)).toList();

        debugPrint('📸 Filtered timeline loaded: ${photos.length} photos for $friendUserId');
        return photos;
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Get filtered timeline error: ${e.message}');
      return [];
    }
  }

  /// Batch load timeline photos cho multiple friends
  Future<Map<String, List<PhotoTimelineDto>>> batchGetFriendsTimeline(
    List<String> friendIds, {
    int photosPerFriend = 5,
  }) async {
    try {
      final response = await _dio.get(
        '/api/timeline/batch',
        queryParameters: {
          'friendIds': friendIds,
          'photosPerFriend': photosPerFriend,
        },
      );

      if (response.data['success'] == true) {
        final Map<String, dynamic> timelineData = response.data['timelines'] as Map<String, dynamic>;
        final result = <String, List<PhotoTimelineDto>>{};

        timelineData.forEach((friendId, photosJson) {
          final List<dynamic> photosList = photosJson as List<dynamic>;
          result[friendId] = photosList.map((json) => PhotoTimelineDto.fromJson(json)).toList();
        });

        debugPrint('📦 Batch timeline loaded for ${result.length} friends');
        return result;
      }
      return {};
    } on DioException catch (e) {
      debugPrint('Batch timeline error: ${e.message}');
      return {};
    }
  }

  /// Preload friend timeline để caching
  Future<void> preloadFriendTimeline(String friendUserId) async {
    try {
      final response = await _dio.post('/api/timeline/friend/$friendUserId/preload');
      debugPrint('🔄 Timeline preload initiated cho friend: $friendUserId');
      debugPrint('🔄 Preload response: ${response.data}');
    } on DioException catch (e) {
      debugPrint('❌ Timeline preload failed:');
      debugPrint('   Status: ${e.response?.statusCode}');
      debugPrint('   Message: ${e.message}');
      debugPrint('   Error: ${e.error}');
      // Don't throw error - preload is optional
    } catch (e) {
      debugPrint('❌ Timeline preload unexpected error: $e');
    }
  }

  /// Invalidate timeline cache cho friend
  Future<void> invalidateTimelineCache(String friendUserId) async {
    try {
      await _dio.delete('/api/timeline/friend/$friendUserId/cache');
      debugPrint('🗑️ Timeline cache invalidated cho friend: $friendUserId');
    } on DioException catch (e) {
      debugPrint('Timeline cache invalidation error: ${e.message}');
    }
  }

  /// Check quyền xem timeline của friend
  Future<bool> canViewFriendTimeline(String friendUserId) async {
    try {
      final response = await _dio.get('/api/timeline/friend/$friendUserId/permissions');
      if (response.data['success'] == true) {
        return response.data['canView'] as bool;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Check timeline permissions error: ${e.message}');
      return false;
    }
  }

  /// Lấy timeline photo count cho friend
  Future<int> getFriendTimelinePhotoCount(String friendUserId) async {
    try {
      final response = await _dio.get('/api/timeline/friend/$friendUserId/count');
      if (response.data['success'] == true) {
        return response.data['count'] as int;
      }
      return 0;
    } on DioException catch (e) {
      debugPrint('Get timeline photo count error: ${e.message}');
      return 0;
    }
  }

  // ===== CACHE MANAGEMENT =====

  /// Cache một presigned URL với TTL
  void _cacheUrl(String s3Key, String url, Duration ttl) {
    // LRU eviction nếu cache đầy
    if (_urlCache.length >= _maxCacheSize) {
      _evictOldestCacheEntry();
    }

    _urlCache[s3Key] = CachedPresignedUrl(url, DateTime.now(), ttl);
  }

  /// Evict oldest cache entry (simple LRU)
  void _evictOldestCacheEntry() {
    if (_urlCache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _urlCache.entries) {
      if (oldestTime == null || entry.value.cachedAt.isBefore(oldestTime)) {
        oldestTime = entry.value.cachedAt;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _urlCache.remove(oldestKey);
      debugPrint('🗑️ Evicted oldest cache entry: ${oldestKey.split('/').last}');
    }
  }

  /// Clean up expired cache entries
  void cleanupExpiredCache() {
    final beforeSize = _urlCache.length;
    _urlCache.removeWhere((key, cached) => cached.isExpired);
    final removedCount = beforeSize - _urlCache.length;

    if (removedCount > 0) {
      debugPrint('🧹 Cleaned up $removedCount expired cache entries');
    }
  }

  /// Invalidate cache cho specific S3 keys
  void invalidateCache(List<String> s3Keys) {
    for (final key in s3Keys) {
      _urlCache.remove(key);
    }
    debugPrint('🗑️ Invalidated cache cho ${s3Keys.length} S3 keys');
  }

  /// Clear toàn bộ cache
  void clearCache() {
    final size = _urlCache.length;
    _urlCache.clear();
    _cacheHits = 0;
    _cacheMisses = 0;
    _totalRequests = 0;
    debugPrint('🧹 Cleared all cache (${size} entries) và reset statistics');
  }

  /// Lấy cache statistics cho monitoring và debugging
  Map<String, dynamic> getCacheStatistics() {
    cleanupExpiredCache(); // Clean up trước khi report

    final hitRatio = _totalRequests > 0 ? (_cacheHits / _totalRequests) : 0.0;

    return {
      'cacheSize': _urlCache.length,
      'maxCacheSize': _maxCacheSize,
      'cacheHits': _cacheHits,
      'cacheMisses': _cacheMisses,
      'totalRequests': _totalRequests,
      'hitRatio': hitRatio,
      'hitRatioPercentage': '${(hitRatio * 100).toStringAsFixed(1)}%',
      'cacheTtlHours': _defaultCacheTTL.inHours,
    };
  }

  /// Preload presigned URLs cho danh sách S3 keys (background operation)
  Future<void> preloadPresignedUrls(List<String> s3Keys) async {
    if (s3Keys.isEmpty) return;

    debugPrint('🔄 Preloading presigned URLs cho ${s3Keys.length} S3 keys');

    try {
      await batchGetPresignedUrls(s3Keys);
      debugPrint('✅ Preload completed cho ${s3Keys.length} URLs');
    } catch (e) {
      debugPrint('❌ Preload failed: $e');
    }
  }

  /// Helper method để print cache status cho debugging
  void printCacheStatus() {
    final stats = getCacheStatistics();
    debugPrint('📊 Cache Status:');
    debugPrint('   Size: ${stats['cacheSize']}/${stats['maxCacheSize']}');
    debugPrint('   Hit Ratio: ${stats['hitRatioPercentage']}');
    debugPrint('   Total Requests: ${stats['totalRequests']}');
  }
}
