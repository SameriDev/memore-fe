import 'package:uuid/uuid.dart';

/// Notification model representing in-app notifications and push notifications
/// Contains all notification-related data with placeholder structure for frontend-only implementation
class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool isRead;
  final bool isPush;
  final String? imageUrl;
  final String? actionUrl;
  final DateTime? expiresAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    required this.isRead,
    this.isPush = false,
    this.imageUrl,
    this.actionUrl,
    this.expiresAt,
  });

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isRead,
    bool? isPush,
    String? imageUrl,
    String? actionUrl,
    DateTime? expiresAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isPush: isPush ?? this.isPush,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Mark notification as read
  NotificationModel markAsRead() {
    return copyWith(isRead: true);
  }

  /// Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if notification is still valid
  bool get isValid => !isExpired;

  /// Get time ago string
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString(),
      'title': title,
      'body': body,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'isPush': isPush,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  /// Create from JSON (for future API integration)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.general,
      ),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      isPush: json['isPush'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NotificationModel{id: $id, type: $type, title: $title, isRead: $isRead}';
  }
}

/// Notification types enum
enum NotificationType {
  friendRequest,
  friendAccepted,
  photoReceived,
  photoViewed,
  timeTravel,
  general,
  system,
}

/// Notification settings model
class NotificationSettings {
  final bool pushNotificationsEnabled;
  final bool photoNotificationsEnabled;
  final bool friendNotificationsEnabled;
  final bool timeTravelNotificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final List<NotificationType> mutedTypes;
  final TimeOfDay? quietHoursStart;
  final TimeOfDay? quietHoursEnd;

  const NotificationSettings({
    required this.pushNotificationsEnabled,
    required this.photoNotificationsEnabled,
    required this.friendNotificationsEnabled,
    required this.timeTravelNotificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.mutedTypes,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  NotificationSettings copyWith({
    bool? pushNotificationsEnabled,
    bool? photoNotificationsEnabled,
    bool? friendNotificationsEnabled,
    bool? timeTravelNotificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    List<NotificationType>? mutedTypes,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationSettings(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      photoNotificationsEnabled: photoNotificationsEnabled ?? this.photoNotificationsEnabled,
      friendNotificationsEnabled: friendNotificationsEnabled ?? this.friendNotificationsEnabled,
      timeTravelNotificationsEnabled: timeTravelNotificationsEnabled ?? this.timeTravelNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      mutedTypes: mutedTypes ?? this.mutedTypes,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  /// Check if a notification type is enabled
  bool isTypeEnabled(NotificationType type) {
    if (!pushNotificationsEnabled) return false;
    if (mutedTypes.contains(type)) return false;

    switch (type) {
      case NotificationType.photoReceived:
      case NotificationType.photoViewed:
        return photoNotificationsEnabled;
      case NotificationType.friendRequest:
      case NotificationType.friendAccepted:
        return friendNotificationsEnabled;
      case NotificationType.timeTravel:
        return timeTravelNotificationsEnabled;
      case NotificationType.general:
      case NotificationType.system:
        return true;
    }
  }

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (quietHoursStart == null || quietHoursEnd == null) return false;

    final now = TimeOfDay.now();
    final start = quietHoursStart!;
    final end = quietHoursEnd!;

    // Handle overnight quiet hours (e.g., 22:00 - 06:00)
    if (start.hour > end.hour) {
      return (now.hour >= start.hour || now.hour <= end.hour);
    }
    // Handle same-day quiet hours (e.g., 12:00 - 14:00)
    else {
      return (now.hour >= start.hour && now.hour <= end.hour);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'photoNotificationsEnabled': photoNotificationsEnabled,
      'friendNotificationsEnabled': friendNotificationsEnabled,
      'timeTravelNotificationsEnabled': timeTravelNotificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'mutedTypes': mutedTypes.map((e) => e.toString()).toList(),
      'quietHoursStart': quietHoursStart != null
          ? '${quietHoursStart!.hour}:${quietHoursStart!.minute}'
          : null,
      'quietHoursEnd': quietHoursEnd != null
          ? '${quietHoursEnd!.hour}:${quietHoursEnd!.minute}'
          : null,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTimeOfDay(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return NotificationSettings(
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool,
      photoNotificationsEnabled: json['photoNotificationsEnabled'] as bool,
      friendNotificationsEnabled: json['friendNotificationsEnabled'] as bool,
      timeTravelNotificationsEnabled: json['timeTravelNotificationsEnabled'] as bool,
      soundEnabled: json['soundEnabled'] as bool,
      vibrationEnabled: json['vibrationEnabled'] as bool,
      mutedTypes: (json['mutedTypes'] as List)
          .map((e) => NotificationType.values.firstWhere((type) => type.toString() == e))
          .toList(),
      quietHoursStart: parseTimeOfDay(json['quietHoursStart'] as String?),
      quietHoursEnd: parseTimeOfDay(json['quietHoursEnd'] as String?),
    );
  }

  /// Default notification settings
  static const NotificationSettings defaultSettings = NotificationSettings(
    pushNotificationsEnabled: true,
    photoNotificationsEnabled: true,
    friendNotificationsEnabled: true,
    timeTravelNotificationsEnabled: true,
    soundEnabled: true,
    vibrationEnabled: true,
    mutedTypes: [],
  );
}

/// Time of day helper class
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  static TimeOfDay now() {
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Mock data class for testing and development
class MockNotifications {
  static const _uuid = Uuid();

  /// Sample notifications for testing
  static final List<NotificationModel> sampleNotifications = [
    NotificationModel(
      id: 'notif_001',
      userId: 'user_001',
      type: NotificationType.photoReceived,
      title: 'New photo from Danny D',
      body: 'Danny D shared a photo with you',
      data: {
        'photoId': 'photo_001',
        'senderId': 'friend_001',
        'senderName': 'Danny D',
      },
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      isPush: true,
      imageUrl: 'assets/images/sample_photo_1.jpg',
      actionUrl: '/photos/view?photoId=photo_001',
    ),
    NotificationModel(
      id: 'notif_002',
      userId: 'user_001',
      type: NotificationType.friendRequest,
      title: 'New friend request',
      body: 'Alex M wants to be your friend',
      data: {
        'fromUserId': 'potential_friend_001',
        'fromUserName': 'Alex M',
        'requestId': 'request_001',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      isPush: true,
      actionUrl: '/friends/requests',
    ),
    NotificationModel(
      id: 'notif_003',
      userId: 'user_001',
      type: NotificationType.photoViewed,
      title: 'Photo viewed',
      body: 'Sarah K viewed your photo',
      data: {
        'photoId': 'photo_003',
        'viewerId': 'friend_002',
        'viewerName': 'Sarah K',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      isPush: false,
    ),
    NotificationModel(
      id: 'notif_004',
      userId: 'user_001',
      type: NotificationType.timeTravel,
      title: 'Memory from last year',
      body: 'A photo you shared with Danny D one year ago',
      data: {
        'photoId': 'photo_tt_001',
        'originalDate': DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      },
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      isPush: true,
      imageUrl: 'assets/images/memory_1.jpg',
      actionUrl: '/photos/time-travel',
    ),
    NotificationModel(
      id: 'notif_005',
      userId: 'user_001',
      type: NotificationType.friendAccepted,
      title: 'Friend request accepted',
      body: 'Sarah K accepted your friend request',
      data: {
        'friendId': 'friend_002',
        'friendName': 'Sarah K',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      isPush: true,
      actionUrl: '/friends',
    ),
  ];

  /// Get notifications for a specific user
  static List<NotificationModel> getNotificationsForUser(String userId) {
    return sampleNotifications
        .where((notification) => notification.userId == userId && notification.isValid)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get unread notifications for a user
  static List<NotificationModel> getUnreadNotifications(String userId) {
    return getNotificationsForUser(userId)
        .where((notification) => !notification.isRead)
        .toList();
  }

  /// Get unread count for a user
  static int getUnreadCount(String userId) {
    return getUnreadNotifications(userId).length;
  }

  /// Get notifications by type
  static List<NotificationModel> getNotificationsByType(
    String userId,
    NotificationType type,
  ) {
    return getNotificationsForUser(userId)
        .where((notification) => notification.type == type)
        .toList();
  }

  /// Get recent notifications (last 24 hours)
  static List<NotificationModel> getRecentNotifications(String userId) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return getNotificationsForUser(userId)
        .where((notification) => notification.createdAt.isAfter(yesterday))
        .toList();
  }

  /// Create a new notification
  static NotificationModel createNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    bool isPush = false,
    String? imageUrl,
    String? actionUrl,
    Duration? expiresIn,
  }) {
    return NotificationModel(
      id: _uuid.v4(),
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data ?? {},
      createdAt: DateTime.now(),
      isRead: false,
      isPush: isPush,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      expiresAt: expiresIn != null ? DateTime.now().add(expiresIn) : null,
    );
  }

  /// Create photo received notification
  static NotificationModel createPhotoReceivedNotification({
    required String userId,
    required String photoId,
    required String senderName,
    required String senderId,
    String? imageUrl,
  }) {
    return createNotification(
      userId: userId,
      type: NotificationType.photoReceived,
      title: 'New photo from $senderName',
      body: '$senderName shared a photo with you',
      data: {
        'photoId': photoId,
        'senderId': senderId,
        'senderName': senderName,
      },
      isPush: true,
      imageUrl: imageUrl,
      actionUrl: '/photos/view?photoId=$photoId',
    );
  }

  /// Create friend request notification
  static NotificationModel createFriendRequestNotification({
    required String userId,
    required String fromUserId,
    required String fromUserName,
    required String requestId,
  }) {
    return createNotification(
      userId: userId,
      type: NotificationType.friendRequest,
      title: 'New friend request',
      body: '$fromUserName wants to be your friend',
      data: {
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'requestId': requestId,
      },
      isPush: true,
      actionUrl: '/friends/requests',
    );
  }

  /// Create time travel notification
  static NotificationModel createTimeTravelNotification({
    required String userId,
    required String photoId,
    required DateTime originalDate,
    String? imageUrl,
  }) {
    final timeAgo = DateTime.now().difference(originalDate).inDays;
    final timeAgoText = timeAgo < 365 ? '$timeAgo days ago' : '${(timeAgo / 365).round()} year${(timeAgo / 365).round() > 1 ? 's' : ''} ago';

    return createNotification(
      userId: userId,
      type: NotificationType.timeTravel,
      title: 'Memory from $timeAgoText',
      body: 'A photo you shared $timeAgoText',
      data: {
        'photoId': photoId,
        'originalDate': originalDate.toIso8601String(),
      },
      isPush: true,
      imageUrl: imageUrl,
      actionUrl: '/photos/time-travel',
    );
  }

  /// Clear all notifications for a user
  static void clearAllNotifications(String userId) {
    sampleNotifications.removeWhere((notification) => notification.userId == userId);
  }

  /// Mark all notifications as read
  static void markAllAsRead(String userId) {
    for (int i = 0; i < sampleNotifications.length; i++) {
      if (sampleNotifications[i].userId == userId) {
        sampleNotifications[i] = sampleNotifications[i].markAsRead();
      }
    }
  }
}