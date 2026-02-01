import 'dart:async';
import 'dart:math' as math;
import 'storage_service.dart';
import 'user_manager.dart';
import 'friend_manager.dart';
import 'photo_interaction_manager.dart';

class ActivityFeedManager {
  static ActivityFeedManager? _instance;
  static ActivityFeedManager get instance => _instance ??= ActivityFeedManager._();

  ActivityFeedManager._();

  final _storage = StorageService.instance;
  final _userManager = UserManager.instance;
  final _friendManager = FriendManager.instance;
  final _interactionManager = PhotoInteractionManager.instance;

  Timer? _simulationTimer;
  bool _isSimulationRunning = false;

  /// Start simulating friend activities
  void startActivitySimulation() {
    if (_isSimulationRunning) return;

    _isSimulationRunning = true;
    _simulationTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _simulateRandomActivity();
    });

    // Create initial activities
    _createInitialActivities();
  }

  /// Stop activity simulation
  void stopActivitySimulation() {
    _isSimulationRunning = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  /// Get activity feed
  List<Map<String, dynamic>> getActivityFeed({int limit = 50}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final activitiesKey = 'activity_feed_$userId';
      final existingActivities = _storage.getSetting<List<dynamic>>(activitiesKey, defaultValue: []) ?? [];
      final userActivities = List<Map<String, dynamic>>.from(
        existingActivities.map((e) => Map<String, dynamic>.from(e))
      );

      // Sort by timestamp (newest first)
      userActivities.sort((a, b) {
        final timeA = DateTime.parse(a['timestamp']);
        final timeB = DateTime.parse(b['timestamp']);
        return timeB.compareTo(timeA);
      });

      return userActivities.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add activity to feed
  Future<void> addActivity({
    required String type,
    required String actorId,
    required String actorName,
    required String actorAvatar,
    required String message,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final activitiesKey = 'activity_feed_$userId';
      final existingActivities = _storage.getSetting<List<dynamic>>(activitiesKey, defaultValue: []) ?? [];
      final userActivities = List<Map<String, dynamic>>.from(
        existingActivities.map((e) => Map<String, dynamic>.from(e))
      );

      final activity = {
        'id': 'activity_${DateTime.now().millisecondsSinceEpoch}',
        'type': type,
        'actorId': actorId,
        'actorName': actorName,
        'actorAvatar': actorAvatar,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'metadata': metadata ?? {},
      };

      userActivities.insert(0, activity); // Add to beginning

      // Keep only last 100 activities
      if (userActivities.length > 100) {
        userActivities.removeRange(100, userActivities.length);
      }

      await _storage.saveSetting(activitiesKey, userActivities);
    } catch (e) {
      // Ignore activity creation errors
    }
  }

  /// Mark activity as read
  Future<void> markActivityAsRead(String activityId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final activitiesKey = 'activity_feed_$userId';
      final existingActivities = _storage.getSetting<List<dynamic>>(activitiesKey, defaultValue: []) ?? [];
      final userActivities = List<Map<String, dynamic>>.from(
        existingActivities.map((e) => Map<String, dynamic>.from(e))
      );

      final activityIndex = userActivities.indexWhere((activity) => activity['id'] == activityId);
      if (activityIndex != -1) {
        userActivities[activityIndex]['isRead'] = true;
        await _storage.saveSetting(activitiesKey, userActivities);
      }
    } catch (e) {
      // Ignore mark read errors
    }
  }

  /// Mark all activities as read
  Future<void> markAllActivitiesAsRead() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final activitiesKey = 'activity_feed_$userId';
      final existingActivities = _storage.getSetting<List<dynamic>>(activitiesKey, defaultValue: []) ?? [];
      final userActivities = List<Map<String, dynamic>>.from(
        existingActivities.map((e) => Map<String, dynamic>.from(e))
      );

      for (var activity in userActivities) {
        activity['isRead'] = true;
      }

      await _storage.saveSetting(activitiesKey, userActivities);
    } catch (e) {
      // Ignore mark all read errors
    }
  }

  /// Get unread activities count
  int getUnreadActivitiesCount() {
    final activities = getActivityFeed();
    return activities.where((activity) => !(activity['isRead'] as bool? ?? false)).length;
  }

  /// Create initial activities for demo
  Future<void> _createInitialActivities() async {
    final friends = _friendManager.getFriendsList();
    if (friends.isEmpty) return;

    final activityTypes = [
      {
        'type': 'photo_upload',
        'messages': [
          'uploaded a new photo',
          'shared a beautiful moment',
          'posted a new memory',
        ]
      },
      {
        'type': 'friend_joined',
        'messages': [
          'joined Memore',
          'is now on Memore',
        ]
      },
      {
        'type': 'album_created',
        'messages': [
          'created a new album',
          'started a new photo collection',
        ]
      },
    ];

    // Create 3-5 initial activities
    for (int i = 0; i < math.min(5, friends.length); i++) {
      final friend = friends[i];
      final activityType = activityTypes[i % activityTypes.length];
      final messages = activityType['messages'] as List<String>;
      final message = messages[math.Random().nextInt(messages.length)];

      await addActivity(
        type: activityType['type'] as String,
        actorId: friend.id,
        actorName: friend.name,
        actorAvatar: friend.avatarUrl,
        message: '${friend.name} $message',
        metadata: {
          'photoUrl': activityType['type'] == 'photo_upload'
              ? 'https://picsum.photos/400/600?random=${100 + i}'
              : null,
        },
      );

      // Delay between activities
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Simulate random friend activity
  Future<void> _simulateRandomActivity() async {
    final friends = _friendManager.getFriendsList();
    if (friends.isEmpty) return;

    final random = math.Random();
    final friend = friends[random.nextInt(friends.length)];

    final activityTypes = [
      {
        'type': 'photo_upload',
        'weight': 40,
        'messages': [
          'uploaded a new photo',
          'shared a beautiful moment',
          'captured a special memory',
          'posted from their day',
        ]
      },
      {
        'type': 'photo_like',
        'weight': 25,
        'messages': [
          'liked your photo',
          'reacted to your post',
          'loved your recent photo',
        ]
      },
      {
        'type': 'photo_comment',
        'weight': 20,
        'messages': [
          'commented on your photo',
          'left a comment on your post',
          'replied to your photo',
        ]
      },
      {
        'type': 'friend_activity',
        'weight': 10,
        'messages': [
          'is now friends with Sarah',
          'joined a new album',
          'updated their profile',
        ]
      },
      {
        'type': 'album_activity',
        'weight': 5,
        'messages': [
          'created a new album',
          'added photos to their album',
          'shared an album with you',
        ]
      },
    ];

    // Weighted random selection
    final totalWeight = activityTypes.fold<int>(0, (sum, type) => sum + (type['weight'] as int));
    final randomWeight = random.nextInt(totalWeight);

    int currentWeight = 0;
    Map<String, dynamic>? selectedType;

    for (final activityType in activityTypes) {
      currentWeight += activityType['weight'] as int;
      if (randomWeight < currentWeight) {
        selectedType = activityType;
        break;
      }
    }

    if (selectedType != null) {
      final messages = selectedType['messages'] as List<String>;
      final message = messages[random.nextInt(messages.length)];

      final metadata = <String, dynamic>{};

      if (selectedType['type'] == 'photo_upload') {
        metadata['photoUrl'] = 'https://picsum.photos/400/600?random=${random.nextInt(1000)}';
      } else if (selectedType['type'] == 'photo_like' || selectedType['type'] == 'photo_comment') {
        metadata['photoId'] = 'demo_photo_${random.nextInt(10)}';
      }

      await addActivity(
        type: selectedType['type'] as String,
        actorId: friend.id,
        actorName: friend.name,
        actorAvatar: friend.avatarUrl,
        message: '${friend.name} $message',
        metadata: metadata,
      );
    }
  }

  /// Get activity summary for today
  Map<String, int> getTodayActivitySummary() {
    final activities = getActivityFeed();
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final todayActivities = activities.where((activity) {
      final activityTime = DateTime.parse(activity['timestamp']);
      return activityTime.isAfter(todayStart);
    }).toList();

    final summary = <String, int>{};
    for (final activity in todayActivities) {
      final type = activity['type'] as String;
      summary[type] = (summary[type] ?? 0) + 1;
    }

    return summary;
  }

  /// Get friends who have been most active
  List<Map<String, dynamic>> getMostActiveFriends({int limit = 5}) {
    final activities = getActivityFeed();
    final friendActivityCount = <String, Map<String, dynamic>>{};

    for (final activity in activities) {
      final actorId = activity['actorId'] as String;
      final actorName = activity['actorName'] as String;
      final actorAvatar = activity['actorAvatar'] as String;

      if (friendActivityCount.containsKey(actorId)) {
        friendActivityCount[actorId]!['count'] = (friendActivityCount[actorId]!['count'] as int) + 1;
      } else {
        friendActivityCount[actorId] = {
          'id': actorId,
          'name': actorName,
          'avatarUrl': actorAvatar,
          'count': 1,
        };
      }
    }

    final sortedFriends = friendActivityCount.values.toList();
    sortedFriends.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    return sortedFriends.take(limit).toList();
  }

  /// Clear all activities
  Future<void> clearAllActivities() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final activitiesKey = 'activity_feed_$userId';
      await _storage.saveSetting(activitiesKey, <Map<String, dynamic>>[]);
    } catch (e) {
      // Ignore clear errors
    }
  }

  /// Log user action as activity (for own feed history)
  Future<void> logUserAction({
    required String type,
    required String message,
    Map<String, dynamic>? metadata,
  }) async {
    final currentUser = _userManager.getCurrentUser();
    if (currentUser == null) return;

    await addActivity(
      type: 'user_$type',
      actorId: currentUser['id'],
      actorName: 'You',
      actorAvatar: currentUser['avatarUrl'],
      message: message,
      metadata: metadata,
    );
  }

  /// Get activity feed with pagination
  Map<String, dynamic> getActivityFeedPaginated({
    int page = 0,
    int itemsPerPage = 20,
  }) {
    final allActivities = getActivityFeed();
    final startIndex = page * itemsPerPage;
    final endIndex = math.min(startIndex + itemsPerPage, allActivities.length);

    if (startIndex >= allActivities.length) {
      return {
        'activities': <Map<String, dynamic>>[],
        'hasMore': false,
        'totalCount': allActivities.length,
        'currentPage': page,
      };
    }

    final pageActivities = allActivities.sublist(startIndex, endIndex);

    return {
      'activities': pageActivities,
      'hasMore': endIndex < allActivities.length,
      'totalCount': allActivities.length,
      'currentPage': page,
    };
  }

  /// Initialize activity feed for new users
  Future<void> initializeForNewUser() async {
    // Wait for friends to be initialized
    await Future.delayed(const Duration(milliseconds: 500));

    await _createInitialActivities();
    startActivitySimulation();
  }

  /// Dispose manager
  void dispose() {
    stopActivitySimulation();
  }
}