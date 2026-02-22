import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../models/user_dto.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<UserDto> getUserById(String userId) async {
    final response = await _dio.get('/api/users/$userId');
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<UserDto>> searchByUsername(String username) async {
    try {
      final response = await _dio.get('/api/users/search', queryParameters: {'username': username});
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => UserDto.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserDto> updateUser(String userId, Map<String, dynamic> updates) async {
    final response = await _dio.put('/api/users/$userId', data: updates);
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }
}
