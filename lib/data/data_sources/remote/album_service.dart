import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../models/album_dto.dart';

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
}
