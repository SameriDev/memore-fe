import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/album_dto.dart';
import '../../models/album_participant_dto.dart';

class AlbumService {
  static AlbumService? _instance;
  static AlbumService get instance => _instance ??= AlbumService._();

  AlbumService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<List<AlbumDto>> getUserAlbums(String userId) async {
    try {
      final response = await _dio.get('/api/albums/user/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AlbumDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get user albums error: ${e.message}');
      return [];
    }
  }

  Future<AlbumDto?> getAlbumById(String albumId) async {
    try {
      final response = await _dio.get('/api/albums/$albumId');
      return AlbumDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Get album by id error: ${e.message}');
      return null;
    }
  }

  Future<AlbumDto?> createAlbum({
    required String name,
    required String creatorId,
    String? description,
    String? coverImageUrl,
    List<String>? inviteFriendIds,
  }) async {
    try {
      final response = await _dio.post('/api/albums', data: {
        'name': name,
        'creatorId': creatorId,
        'description': description,
        'coverImageUrl': coverImageUrl,
        'inviteFriendIds': inviteFriendIds,
      });
      return AlbumDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Create album error: ${e.message}');
      return null;
    }
  }

  Future<AlbumParticipantDto?> inviteToAlbum({
    required String albumId,
    required String userId,
    required String inviterId,
  }) async {
    try {
      final response = await _dio.post('/api/albums/$albumId/participants', data: {
        'userId': userId,
        'inviterId': inviterId,
      });
      return AlbumParticipantDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Invite to album error: ${e.message}');
      return null;
    }
  }

  Future<AlbumParticipantDto?> acceptInvite({
    required String albumId,
    required String userId,
  }) async {
    try {
      final response = await _dio.put('/api/albums/$albumId/participants/accept', data: {
        'userId': userId,
      });
      return AlbumParticipantDto.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Accept invite error: ${e.message}');
      return null;
    }
  }

  Future<bool> declineInvite({
    required String albumId,
    required String userId,
  }) async {
    try {
      await _dio.put('/api/albums/$albumId/participants/decline', data: {
        'userId': userId,
      });
      return true;
    } on DioException catch (e) {
      debugPrint('Decline invite error: ${e.message}');
      return false;
    }
  }

  Future<bool> leaveAlbum({
    required String albumId,
    required String userId,
  }) async {
    try {
      await _dio.delete('/api/albums/$albumId/participants/$userId');
      return true;
    } on DioException catch (e) {
      debugPrint('Leave album error: ${e.message}');
      return false;
    }
  }

  Future<bool> deleteAlbum(String albumId) async {
    try {
      await _dio.delete('/api/albums/$albumId');
      return true;
    } on DioException catch (e) {
      debugPrint('Delete album error: ${e.message}');
      return false;
    }
  }

  Future<bool> kickMember({
    required String albumId,
    required String userId,
    required String requesterId,
  }) async {
    try {
      await _dio.delete(
        '/api/albums/$albumId/participants/$userId',
        queryParameters: {'requesterId': requesterId},
      );
      return true;
    } on DioException catch (e) {
      debugPrint('Kick member error: ${e.message}');
      return false;
    }
  }

  Future<List<AlbumDto>> getPendingInvites(String userId) async {
    try {
      final response = await _dio.get('/api/albums/invites/$userId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AlbumDto.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get pending invites error: ${e.message}');
      return [];
    }
  }
}
