import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/story_dto.dart';

class StoryService {
  static StoryService? _instance;
  static StoryService get instance => _instance ??= StoryService._();

  StoryService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<List<StoryDto>> getActiveStories() async {
    try {
      final response = await _dio.get('/api/stories/active');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => StoryDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get active stories error: ${e.message}');
      return [];
    }
  }

  Future<List<StoryDto>> getUserStories(String userId) async {
    try {
      final response = await _dio.get('/api/stories/user/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => StoryDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get user stories error: ${e.message}');
      return [];
    }
  }
}
