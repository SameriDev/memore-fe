import 'package:uuid/uuid.dart';

/// User model representing a user in the Locket clone app
/// Contains all user-related data with placeholder structure for frontend-only implementation
class UserModel {
  final String id;
  final String phoneNumber;
  final String? displayName;
  final String? profilePicture;
  final List<String> friendIds;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final bool isOnline;
  final UserSettings settings;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.displayName,
    this.profilePicture,
    required this.friendIds,
    required this.createdAt,
    this.lastSeenAt,
    required this.isOnline,
    required this.settings,
  });

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? displayName,
    String? profilePicture,
    List<String>? friendIds,
    DateTime? createdAt,
    DateTime? lastSeenAt,
    bool? isOnline,
    UserSettings? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      profilePicture: profilePicture ?? this.profilePicture,
      friendIds: friendIds ?? this.friendIds,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isOnline: isOnline ?? this.isOnline,
      settings: settings ?? this.settings,
    );
  }

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'friendIds': friendIds,
      'createdAt': createdAt.toIso8601String(),
      'lastSeenAt': lastSeenAt?.toIso8601String(),
      'isOnline': isOnline,
      'settings': settings.toJson(),
    };
  }

  /// Create from JSON (for future API integration)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      displayName: json['displayName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      friendIds: List<String>.from(json['friendIds'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.parse(json['lastSeenAt'] as String)
          : null,
      isOnline: json['isOnline'] as bool,
      settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $id, displayName: $displayName, phoneNumber: $phoneNumber, isOnline: $isOnline}';
  }
}

/// User settings model for privacy and notification preferences
class UserSettings {
  final bool pushNotificationsEnabled;
  final bool photoNotificationsEnabled;
  final bool friendNotificationsEnabled;
  final WhoCanAddMe whoCanAddMe;
  final List<String> blockedUserIds;

  const UserSettings({
    required this.pushNotificationsEnabled,
    required this.photoNotificationsEnabled,
    required this.friendNotificationsEnabled,
    required this.whoCanAddMe,
    required this.blockedUserIds,
  });

  UserSettings copyWith({
    bool? pushNotificationsEnabled,
    bool? photoNotificationsEnabled,
    bool? friendNotificationsEnabled,
    WhoCanAddMe? whoCanAddMe,
    List<String>? blockedUserIds,
  }) {
    return UserSettings(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      photoNotificationsEnabled: photoNotificationsEnabled ?? this.photoNotificationsEnabled,
      friendNotificationsEnabled: friendNotificationsEnabled ?? this.friendNotificationsEnabled,
      whoCanAddMe: whoCanAddMe ?? this.whoCanAddMe,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'photoNotificationsEnabled': photoNotificationsEnabled,
      'friendNotificationsEnabled': friendNotificationsEnabled,
      'whoCanAddMe': whoCanAddMe.toString(),
      'blockedUserIds': blockedUserIds,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool,
      photoNotificationsEnabled: json['photoNotificationsEnabled'] as bool,
      friendNotificationsEnabled: json['friendNotificationsEnabled'] as bool,
      whoCanAddMe: WhoCanAddMe.values.firstWhere(
        (e) => e.toString() == json['whoCanAddMe'],
        orElse: () => WhoCanAddMe.everyone,
      ),
      blockedUserIds: List<String>.from(json['blockedUserIds'] as List),
    );
  }

  /// Default settings for new users
  static const UserSettings defaultSettings = UserSettings(
    pushNotificationsEnabled: true,
    photoNotificationsEnabled: true,
    friendNotificationsEnabled: true,
    whoCanAddMe: WhoCanAddMe.everyone,
    blockedUserIds: [],
  );
}

/// Enum for who can add the user as a friend
enum WhoCanAddMe {
  everyone,
  friendsOfFriends,
  noOne,
}

/// Mock data class for testing and development
class MockUsers {
  static const _uuid = Uuid();

  /// Current user (placeholder)
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    phoneNumber: '+1234567890',
    displayName: 'You',
    profilePicture: null,
    friendIds: ['friend_001', 'friend_002', 'friend_003'],
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastSeenAt: DateTime.now(),
    isOnline: true,
    settings: UserSettings.defaultSettings,
  );

  /// Sample friends for testing
  static final List<UserModel> sampleFriends = [
    UserModel(
      id: 'friend_001',
      phoneNumber: '+1987654321',
      displayName: 'Danny D',
      profilePicture: null,
      friendIds: ['user_001', 'friend_002'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastSeenAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
      settings: UserSettings.defaultSettings,
    ),
    UserModel(
      id: 'friend_002',
      phoneNumber: '+1234567891',
      displayName: 'Sarah K',
      profilePicture: null,
      friendIds: ['user_001', 'friend_001', 'friend_003'],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      lastSeenAt: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: false,
      settings: UserSettings.defaultSettings,
    ),
    UserModel(
      id: 'friend_003',
      phoneNumber: '+1555666777',
      displayName: 'Mike R',
      profilePicture: null,
      friendIds: ['user_001', 'friend_002'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      lastSeenAt: DateTime.now().subtract(const Duration(days: 1)),
      isOnline: false,
      settings: UserSettings.defaultSettings,
    ),
  ];

  /// Generate a random user for testing
  static UserModel generateRandomUser() {
    final names = ['Alex', 'Jordan', 'Taylor', 'Casey', 'Riley', 'Morgan'];
    final name = names[DateTime.now().millisecond % names.length];

    return UserModel(
      id: _uuid.v4(),
      phoneNumber: '+1${DateTime.now().millisecondsSinceEpoch}',
      displayName: '$name ${String.fromCharCode(65 + (DateTime.now().second % 26))}',
      profilePicture: null,
      friendIds: [],
      createdAt: DateTime.now().subtract(
        Duration(days: DateTime.now().millisecond % 365),
      ),
      lastSeenAt: DateTime.now().subtract(
        Duration(minutes: DateTime.now().second % 120),
      ),
      isOnline: DateTime.now().second % 2 == 0,
      settings: UserSettings.defaultSettings,
    );
  }

  /// Get user by ID
  static UserModel? getUserById(String id) {
    if (id == currentUser.id) return currentUser;

    for (final friend in sampleFriends) {
      if (friend.id == id) return friend;
    }

    return null;
  }

  /// Get all users (current + friends)
  static List<UserModel> getAllUsers() {
    return [currentUser, ...sampleFriends];
  }
}