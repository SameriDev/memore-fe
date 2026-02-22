import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../models/auth_response.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return AuthResponse.fromJson(e.response!.data);
      }
      return AuthResponse(success: false, message: 'Không thể kết nối đến server');
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/api/auth/register', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return AuthResponse.fromJson(e.response!.data);
      }
      return AuthResponse(success: false, message: 'Không thể kết nối đến server');
    }
  }
}
