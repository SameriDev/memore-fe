import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/photo_dto.dart';

class PanoramaStitchFailure implements Exception {
  final String errorCode;
  final String message;
  final String? suggestion;

  PanoramaStitchFailure({
    required this.errorCode,
    required this.message,
    this.suggestion,
  });

  String get displayMessage {
    if (suggestion == null || suggestion!.isEmpty) {
      return message;
    }
    return '$message\n$suggestion';
  }
}

class PanoramaService {
  static PanoramaService? _instance;
  static PanoramaService get instance => _instance ??= PanoramaService._();

  PanoramaService._();

  final Dio _dio = ApiClient.instance.dio;

  /// Upload multiple images to server for panorama stitching.
  /// Returns the stitched photo as a PhotoDto with presigned URL.
  Future<PhotoDto> stitchPanorama({
    required List<String> imagePaths,
    String? caption,
  }) async {
    try {
      final files = <MultipartFile>[];
      for (final path in imagePaths) {
        files.add(await MultipartFile.fromFile(path, filename: 'pano_${files.length}.jpg'));
      }

      final formData = FormData.fromMap({
        'images': files,
        if (caption != null) 'caption': caption,
      });

      final response = await _dio.post(
        '/api/photos/panorama/stitch',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      return PhotoDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      String message = 'Khong the ghep anh panorama luc nay';
      String errorCode = 'UNKNOWN_STITCH_FAIL';
      String? suggestion;
      final data = e.response?.data;
      if (data is String && data.isNotEmpty) {
        message = data;
      } else if (data is Map) {
        if (data['errorCode'] != null) {
          errorCode = data['errorCode'].toString();
        }
        if (data['suggestion'] != null) {
          suggestion = data['suggestion'].toString();
        }
        message = (data['error'] ?? data['message'] ?? message).toString();
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }
      debugPrint('Panorama stitch error: $message');
      throw PanoramaStitchFailure(
        errorCode: errorCode,
        message: message,
        suggestion: suggestion,
      );
    } catch (e) {
      debugPrint('Panorama stitch error: $e');
      throw PanoramaStitchFailure(
        errorCode: 'UNKNOWN_STITCH_FAIL',
        message: 'Khong the ghep anh panorama',
      );
    }
  }
}
