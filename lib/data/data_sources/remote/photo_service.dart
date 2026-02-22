import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_client.dart';
import '../../models/photo_dto.dart';

class PhotoService {
  static PhotoService? _instance;
  static PhotoService get instance => _instance ??= PhotoService._();

  PhotoService._();

  final Dio _dio = ApiClient.instance.dio;
  final _uuid = const Uuid();

  /// Upload photo to server: upload file + create record
  Future<PhotoDto?> uploadPhoto({
    required String localFilePath,
    required String userId,
    String? caption,
  }) async {
    try {
      // Step 1: Upload file to R2 storage
      final photoName = '${_uuid.v4()}.jpg';
      final s3Key = 'users/$userId/photos/$photoName';

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
        options: Options(
          contentType: 'multipart/form-data',
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
      return null;
    } catch (e) {
      debugPrint('Photo upload error: $e');
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

  /// Get presigned URL for an S3 key
  Future<String?> getPresignedUrl(String s3Key) async {
    try {
      final response = await _dio.get(
        '/api/photos/storage/url',
        queryParameters: {'key': s3Key},
      );
      if (response.data['success'] == true) {
        return response.data['presignedUrl'] as String?;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Get presigned URL error: ${e.message}');
      return null;
    }
  }
}
