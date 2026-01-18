import 'package:uuid/uuid.dart';

/// Friend relationship model representing friendship status and interactions
/// Contains all friend-related data with placeholder structure for frontend-only implementation
class FriendModel {
  final String id;
  final String userId;
  final String friendId;
  final FriendshipStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final String? requestMessage;
  final bool isBlocked;
  final DateTime? lastInteraction;

  const FriendModel({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.requestMessage,
    this.isBlocked = false,
    this.lastInteraction,
  });

  /// Create a copy with updated fields
  FriendModel copyWith({
    String? id,
    String? userId,
    String? friendId,
    FriendshipStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    String? requestMessage,
    bool? isBlocked,
    DateTime? lastInteraction,
  }) {
    return FriendModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      requestMessage: requestMessage ?? this.requestMessage,
      isBlocked: isBlocked ?? this.isBlocked,
      lastInteraction: lastInteraction ?? this.lastInteraction,
    );
  }

  /// Accept friend request
  FriendModel accept() {
    return copyWith(
      status: FriendshipStatus.accepted,
      acceptedAt: DateTime.now(),
    );
  }

  /// Decline friend request
  FriendModel decline() {
    return copyWith(status: FriendshipStatus.declined);
  }

  /// Block friend
  FriendModel block() {
    return copyWith(status: FriendshipStatus.blocked, isBlocked: true);
  }

  /// Unblock friend
  FriendModel unblock() {
    return copyWith(isBlocked: false);
  }

  /// Update last interaction
  FriendModel updateLastInteraction() {
    return copyWith(lastInteraction: DateTime.now());
  }

  /// Check if friendship is active (accepted and not blocked)
  bool get isActive => status == FriendshipStatus.accepted && !isBlocked;

  /// Check if this is a pending request sent by user
  bool get isPendingSent => status == FriendshipStatus.pending;

  /// Check if this is a pending request received by user
  bool get isPendingReceived => status == FriendshipStatus.pending;

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'friendId': friendId,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'requestMessage': requestMessage,
      'isBlocked': isBlocked,
      'lastInteraction': lastInteraction?.toIso8601String(),
    };
  }

  /// Create from JSON (for future API integration)
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      friendId: json['friendId'] as String,
      status: FriendshipStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => FriendshipStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      requestMessage: json['requestMessage'] as String?,
      isBlocked: json['isBlocked'] as bool? ?? false,
      lastInteraction: json['lastInteraction'] != null
          ? DateTime.parse(json['lastInteraction'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FriendModel{id: $id, userId: $userId, friendId: $friendId, status: $status}';
  }
}

/// Friendship status enum
enum FriendshipStatus { pending, accepted, declined, blocked }

/// Friend request model for managing incoming and outgoing requests
class FriendRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? message;
  final DateTime createdAt;
  final FriendRequestStatus status;

  const FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.message,
    required this.createdAt,
    required this.status,
  });

  FriendRequest copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? message,
    DateTime? createdAt,
    FriendRequestStatus? status,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString(),
    };
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => FriendRequestStatus.pending,
      ),
    );
  }
}

/// Friend request status enum
enum FriendRequestStatus { pending, accepted, declined }

/// Mock data class for testing and development
class MockFriends {
  static const _uuid = Uuid();

  /// Sample friend relationships
  static final List<FriendModel> sampleFriendships = [
    FriendModel(
      id: 'friendship_001',
      userId: 'user_001',
      friendId: 'friend_001',
      status: FriendshipStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      acceptedAt: DateTime.now().subtract(const Duration(days: 14)),
      lastInteraction: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FriendModel(
      id: 'friendship_002',
      userId: 'user_001',
      friendId: 'friend_002',
      status: FriendshipStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      acceptedAt: DateTime.now().subtract(const Duration(days: 44)),
      lastInteraction: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    FriendModel(
      id: 'friendship_003',
      userId: 'user_001',
      friendId: 'friend_003',
      status: FriendshipStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      acceptedAt: DateTime.now().subtract(const Duration(days: 19)),
      lastInteraction: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  /// Sample friend requests
  static final List<FriendRequest> sampleFriendRequests = [
    FriendRequest(
      id: 'request_001',
      fromUserId: 'potential_friend_001',
      toUserId: 'user_001',
      message: 'Hi! Let\'s be friends on memore!',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: FriendRequestStatus.pending,
    ),
    FriendRequest(
      id: 'request_002',
      fromUserId: 'potential_friend_002',
      toUserId: 'user_001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: FriendRequestStatus.pending,
    ),
  ];

  /// Sample sent requests (from current user)
  static final List<FriendRequest> sampleSentRequests = [
    FriendRequest(
      id: 'sent_request_001',
      fromUserId: 'user_001',
      toUserId: 'potential_friend_003',
      message: 'Hey! Want to be friends?',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      status: FriendRequestStatus.pending,
    ),
  ];

  /// Get friends for a specific user
  static List<FriendModel> getFriendsForUser(String userId) {
    return sampleFriendships
        .where(
          (friendship) =>
              (friendship.userId == userId || friendship.friendId == userId) &&
              friendship.isActive,
        )
        .toList()
      ..sort(
        (a, b) => (b.lastInteraction ?? b.createdAt).compareTo(
          a.lastInteraction ?? a.createdAt,
        ),
      );
  }

  /// Get pending friend requests for a user (incoming)
  static List<FriendRequest> getPendingRequests(String userId) {
    return sampleFriendRequests
        .where(
          (request) =>
              request.toUserId == userId &&
              request.status == FriendRequestStatus.pending,
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get sent friend requests from a user (outgoing)
  static List<FriendRequest> getSentRequests(String userId) {
    return sampleSentRequests
        .where(
          (request) =>
              request.fromUserId == userId &&
              request.status == FriendRequestStatus.pending,
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Check if users are friends
  static bool areFriends(String userId1, String userId2) {
    return sampleFriendships.any(
      (friendship) =>
          ((friendship.userId == userId1 && friendship.friendId == userId2) ||
              (friendship.userId == userId2 &&
                  friendship.friendId == userId1)) &&
          friendship.isActive,
    );
  }

  /// Check if there's a pending request between users
  static bool hasPendingRequest(String fromUserId, String toUserId) {
    return sampleFriendRequests.any(
      (request) =>
          request.fromUserId == fromUserId &&
          request.toUserId == toUserId &&
          request.status == FriendRequestStatus.pending,
    );
  }

  /// Get friendship relationship between two users
  static FriendModel? getFriendship(String userId1, String userId2) {
    try {
      return sampleFriendships.firstWhere(
        (friendship) =>
            (friendship.userId == userId1 && friendship.friendId == userId2) ||
            (friendship.userId == userId2 && friendship.friendId == userId1),
      );
    } catch (e) {
      return null;
    }
  }

  /// Create a new friend request
  static FriendRequest createFriendRequest({
    required String fromUserId,
    required String toUserId,
    String? message,
  }) {
    return FriendRequest(
      id: _uuid.v4(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      message: message,
      createdAt: DateTime.now(),
      status: FriendRequestStatus.pending,
    );
  }

  /// Accept a friend request and create friendship
  static FriendModel acceptFriendRequest(FriendRequest request) {
    return FriendModel(
      id: _uuid.v4(),
      userId: request.toUserId,
      friendId: request.fromUserId,
      status: FriendshipStatus.accepted,
      createdAt: request.createdAt,
      acceptedAt: DateTime.now(),
      requestMessage: request.message,
    );
  }

  /// Get blocked users for a user
  static List<FriendModel> getBlockedUsers(String userId) {
    return sampleFriendships
        .where(
          (friendship) =>
              (friendship.userId == userId || friendship.friendId == userId) &&
              friendship.isBlocked,
        )
        .toList();
  }

  /// Get friend count for a user
  static int getFriendCount(String userId) {
    return getFriendsForUser(userId).length;
  }

  /// Search for potential friends by username or phone
  static List<Map<String, dynamic>> searchUsers(String query) {
    // Mock search results
    return [
          {
            'id': 'search_result_001',
            'displayName': 'Danny D',
            'phoneNumber': '+1987654321',
            'profilePicture': null,
            'mutualFriends': 2,
          },
          {
            'id': 'search_result_002',
            'displayName': 'Alex M',
            'phoneNumber': '+1555123456',
            'profilePicture': null,
            'mutualFriends': 0,
          },
        ]
        .where(
          (user) =>
              (user['displayName'] as String).toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (user['phoneNumber'] as String).contains(query),
        )
        .toList();
  }

  /// Get mutual friends between two users
  static List<String> getMutualFriends(String userId1, String userId2) {
    final user1Friends = getFriendsForUser(
      userId1,
    ).map((f) => f.userId == userId1 ? f.friendId : f.userId).toSet();
    final user2Friends = getFriendsForUser(
      userId2,
    ).map((f) => f.userId == userId2 ? f.friendId : f.userId).toSet();

    return user1Friends.intersection(user2Friends).toList();
  }

  /// Get friend suggestions based on mutual friends
  static List<Map<String, dynamic>> getFriendSuggestions(String userId) {
    // Mock friend suggestions
    return [
      {
        'id': 'suggestion_001',
        'displayName': 'Emma W',
        'phoneNumber': '+1666777888',
        'profilePicture': null,
        'mutualFriends': 2,
        'reason': 'Friends with Danny D and Sarah K',
      },
      {
        'id': 'suggestion_002',
        'displayName': 'Jake L',
        'phoneNumber': '+1777888999',
        'profilePicture': null,
        'mutualFriends': 1,
        'reason': 'Friends with Mike R',
      },
    ];
  }
}
