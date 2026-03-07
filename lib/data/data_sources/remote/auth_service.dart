import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('[AUTH] Calling register: $email / $username');
      final response = await _dio.post('/api/auth/register', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      });
      debugPrint('[AUTH] Register success: ${response.statusCode}');
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('[AUTH] Register DioException: status=${e.response?.statusCode} data=${e.response?.data} type=${e.type}');
      if (e.response?.data is Map<String, dynamic>) {
        return AuthResponse.fromJson(e.response!.data);
      }
      return AuthResponse(success: false, message: 'Không thể kết nối đến server');
    } catch (e) {
      debugPrint('[AUTH] Register unknown error: $e');
      return AuthResponse(success: false, message: 'Lỗi không xác định: $e');
    }
  }

  Future<AuthResponse> loginWithGoogle({required String idToken}) async {
    try {
      final response = await _dio.post('/api/auth/google', data: {
        'idToken': idToken,
      });
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return AuthResponse.fromJson(e.response!.data);
      }
      return AuthResponse(success: false, message: 'Không thể kết nối đến server');
    }
  }

  Future<bool> sendOtp({required String email}) async {
    try {
      await _dio.post('/api/auth/send-otp', data: {'email': email});
      return true;
    } catch (e) {
      debugPrint('[AUTH] sendOtp error: $e');
      return false;
    }
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _dio.post('/api/auth/verify-otp', data: {
        'email': email,
        'otp': otp,
      });
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['success'] == true;
      }
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('[AUTH] verifyOtp error: $e');
      return false;
    }
  }
}
