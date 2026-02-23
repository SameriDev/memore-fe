import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NovuNotification {
  final String id;
  final String? content;
  final String? subject;
  final bool isRead;
  final String? createdAt;
  final Map<String, dynamic>? payload;

  NovuNotification({
    required this.id,
    this.content,
    this.subject,
    this.isRead = false,
    this.createdAt,
    this.payload,
  });

  factory NovuNotification.fromJson(Map<String, dynamic> json) {
    return NovuNotification(
      id: json['_id'] ?? '',
      content: json['content'] as String?,
      subject: json['subject'] as String?,
      isRead: json['read'] == true,
      createdAt: json['createdAt'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }
}

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance =>
      _instance ??= NotificationService._();

  NotificationService._();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.novu.co/v1',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  String? _subscriberId;
  String? _apiKey;

  void configure({required String apiKey, required String subscriberId}) {
    _apiKey = apiKey;
    _subscriberId = subscriberId;
    _dio.options.headers['Authorization'] = 'ApiKey $apiKey';
  }

  bool get isConfigured => _apiKey != null && _subscriberId != null;

  Future<List<NovuNotification>> getNotifications({int page = 0}) async {
    if (!isConfigured) return [];
    try {
      final response = await _dio.get(
        '/subscribers/$_subscriberId/notifications/feed',
        queryParameters: {'page': page},
      );
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => NovuNotification.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get notifications error: ${e.message}');
      return [];
    }
  }

  Future<int> getUnreadCount() async {
    if (!isConfigured) return 0;
    try {
      final response = await _dio.get(
        '/subscribers/$_subscriberId/notifications/unseen',
      );
      final data = response.data['data'];
      return data?['count'] ?? 0;
    } on DioException catch (e) {
      debugPrint('Get unread count error: ${e.message}');
      return 0;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (!isConfigured) return;
    try {
      await _dio.post(
        '/subscribers/$_subscriberId/messages/markAs',
        data: {
          'messageId': notificationId,
          'mark': {'read': true},
        },
      );
    } on DioException catch (e) {
      debugPrint('Mark as read error: ${e.message}');
    }
  }

  Future<void> markAllAsRead() async {
    if (!isConfigured) return;
    try {
      await _dio.post(
        '/subscribers/$_subscriberId/messages/markAs',
        data: {
          'mark': {'read': true},
        },
      );
    } on DioException catch (e) {
      debugPrint('Mark all as read error: ${e.message}');
    }
  }
}
