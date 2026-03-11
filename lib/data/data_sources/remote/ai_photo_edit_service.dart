import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/photo_dto.dart';

class AiEditFailure implements Exception {
  final String errorCode;
  final String message;
  final String? suggestion;

  AiEditFailure({
    required this.errorCode,
    required this.message,
    this.suggestion,
  });

  @override
  String toString() => 'AiEditFailure($errorCode): $message';
}

class AiPhotoEditService {
  static AiPhotoEditService? _instance;
  static AiPhotoEditService get instance => _instance ??= AiPhotoEditService._();

  AiPhotoEditService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<PhotoDto> editPhoto({
    required String photoId,
    required String prompt,
    String? caption,
  }) async {
    try {
      final response = await _dio.post(
        '/api/photos/ai-edit',
        data: {
          'photoId': photoId,
          'prompt': prompt,
          if (caption != null) 'caption': caption,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      return PhotoDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('AI photo edit error: ${e.message}');

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        throw AiEditFailure(
          errorCode: data['error'] as String? ?? 'UNKNOWN',
          message: data['message'] as String? ?? 'Unknown error',
          suggestion: data['suggestion'] as String?,
        );
      }

      throw AiEditFailure(
        errorCode: 'NETWORK_ERROR',
        message: e.message ?? 'Network error occurred',
        suggestion: 'Please check your connection and try again',
      );
    } catch (e) {
      debugPrint('AI photo edit unexpected error: $e');
      if (e is AiEditFailure) rethrow;
      throw AiEditFailure(
        errorCode: 'UNEXPECTED_ERROR',
        message: e.toString(),
        suggestion: 'Please try again',
      );
    }
  }
}
