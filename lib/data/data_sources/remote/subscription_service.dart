import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class SubscriptionInfo {
  final String effectivePlan;
  final DateTime? expiresAt;
  final bool isExpired;
  final int aiRequestsToday;
  final int? aiDailyLimit; // null = unlimited
  final int aiRequestsRemaining; // -1 = unlimited

  SubscriptionInfo({
    required this.effectivePlan,
    this.expiresAt,
    required this.isExpired,
    required this.aiRequestsToday,
    this.aiDailyLimit,
    required this.aiRequestsRemaining,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      effectivePlan: json['effectivePlan'] as String? ?? 'FREE',
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      isExpired: json['isExpired'] as bool? ?? false,
      aiRequestsToday: json['aiRequestsToday'] as int? ?? 0,
      aiDailyLimit: json['aiDailyLimit'] as int?,
      aiRequestsRemaining: json['aiRequestsRemaining'] as int? ?? 0,
    );
  }
}

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionService get instance => _instance ??= SubscriptionService._();

  SubscriptionService._();

  final Dio _dio = ApiClient.instance.dio;

  Future<SubscriptionInfo> getMySubscription() async {
    final response = await _dio.get('/api/users/me/subscription');
    return SubscriptionInfo.fromJson(response.data as Map<String, dynamic>);
  }
}
