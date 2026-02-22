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

  Future<UserDto> updateUser(String userId, Map<String, dynamic> updates) async {
    final response = await _dio.put('/api/users/$userId', data: updates);
    return UserDto.fromJson(response.data as Map<String, dynamic>);
  }
}
