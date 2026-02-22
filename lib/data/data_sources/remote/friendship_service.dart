import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/friendship_dto.dart';

class FriendshipService {
  static FriendshipService? _instance;
  static FriendshipService get instance => _instance ??= FriendshipService._();

  FriendshipService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<List<FriendshipDto>> getUserFriends(String userId) async {
    try {
      final response = await _dio.get('/api/friendships/user/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => FriendshipDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get user friends error: ${e.message}');
      return [];
    }
  }

  Future<List<FriendshipDto>> getPendingRequests(String userId) async {
    try {
      final response = await _dio.get('/api/friendships/pending/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => FriendshipDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get pending requests error: ${e.message}');
      return [];
    }
  }

  Future<FriendshipDto?> sendRequest(String userId, String friendId) async {
    try {
      final response = await _dio.post('/api/friendships', data: {
        'userId': userId,
        'friendId': friendId,
      });
      return FriendshipDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Send friend request error: ${e.message}');
      return null;
    }
  }

  Future<FriendshipDto?> acceptRequest(String friendshipId) async {
    try {
      final response = await _dio.put('/api/friendships/$friendshipId/accept');
      return FriendshipDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Accept friend request error: ${e.message}');
      return null;
    }
  }
}
