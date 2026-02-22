import 'user_dto.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final UserDto? user;
  final String? accessToken;
  final String? tokenType;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.accessToken,
    this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      user: json['user'] != null
          ? UserDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      accessToken: json['accessToken'] as String?,
      tokenType: json['tokenType'] as String?,
    );
  }
}
