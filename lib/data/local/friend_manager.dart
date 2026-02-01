import 'storage_service.dart';
import 'user_manager.dart';
import '../../domain/entities/friend.dart';

class FriendManager {
  static FriendManager? _instance;
  static FriendManager get instance => _instance ??= FriendManager._();

  FriendManager._();

  final _storage = StorageService.instance;
  final _userManager = UserManager.instance;

  /// Get user's friend list from local storage
  List<Friend> getFriendsList() {
    try {
      final allFriends = _storage.getAllFriends();

      return allFriends.map((friendData) {
        return Friend(
          id: friendData['id'] as String,
          name: friendData['name'] as String,
          avatarUrl: friendData['avatarUrl'] as String,
          isOnline: friendData['isOnline'] as bool? ?? false,
          lastActiveTime: friendData['lastActiveTime'] as String? ?? DateTime.now().toIso8601String(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add friend to local list
  Future<bool> addFriend(Friend friend) async {
    try {
      // Check if friend already exists
      final existingFriend = _storage.getFriend(friend.id);
      if (existingFriend != null) {
        return false; // Friend already exists
      }

      // Add friend with additional local data
      final friendData = {
        'id': friend.id,
        'name': friend.name,
        'avatarUrl': friend.avatarUrl,
        'isOnline': friend.isOnline,
        'lastActiveTime': friend.lastActiveTime,
        'addedDate': DateTime.now().toIso8601String(),
        'isLocalFriend': true,
        'interaction': {
          'lastMessageTime': null,
          'photosShared': 0,
          'mutualLikes': 0,
          'chatHistory': <Map<String, dynamic>>[],
        }
      };

      await _storage.saveFriend(friend.id, friendData);
      await _userManager.incrementFriendsCount();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove friend from local list
  Future<bool> removeFriend(String friendId) async {
    try {
      final existingFriend = _storage.getFriend(friendId);
      if (existingFriend == null) {
        return false; // Friend not found
      }

      await _storage.removeFriend(friendId);
      await _userManager.decrementFriendsCount();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is friend
  bool isFriend(String friendId) {
    return _storage.getFriend(friendId) != null;
  }

  /// Get friend by ID
  Friend? getFriend(String friendId) {
    try {
      final friendData = _storage.getFriend(friendId);
      if (friendData == null) return null;

      return Friend(
        id: friendData['id'] as String,
        name: friendData['name'] as String,
        avatarUrl: friendData['avatarUrl'] as String,
        isOnline: friendData['isOnline'] as bool? ?? false,
        lastActiveTime: friendData['lastActiveTime'] as String? ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Update friend data
  Future<bool> updateFriend(String friendId, Map<String, dynamic> updates) async {
    try {
      final existingFriend = _storage.getFriend(friendId);
      if (existingFriend == null) return false;

      final updatedFriend = {...existingFriend, ...updates};
      await _storage.saveFriend(friendId, updatedFriend);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Send friend request (simulate using settings box)
  Future<bool> sendFriendRequest(String targetUserId, String message) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      // Use settings box for friend requests
      final requestsKey = 'friend_requests_$userId';
      final existingRequests = _storage.getSetting<List<dynamic>>(requestsKey, defaultValue: []) ?? [];
      final userRequests = List<Map<String, dynamic>>.from(
        existingRequests.map((e) => Map<String, dynamic>.from(e))
      );

      // Add outgoing request
      final request = {
        'id': 'req_${DateTime.now().millisecondsSinceEpoch}',
        'targetUserId': targetUserId,
        'message': message,
        'status': 'pending',
        'sentDate': DateTime.now().toIso8601String(),
        'type': 'outgoing',
      };

      userRequests.add(request);
      await _storage.saveSetting(requestsKey, userRequests);

      // Simulate incoming request for demo
      await _simulateIncomingRequest(targetUserId, message);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get friend requests
  List<Map<String, dynamic>> getFriendRequests({String type = 'incoming'}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final requestsKey = 'friend_requests_$userId';
      final existingRequests = _storage.getSetting<List<dynamic>>(requestsKey, defaultValue: []) ?? [];
      final userRequests = List<Map<String, dynamic>>.from(
        existingRequests.map((e) => Map<String, dynamic>.from(e))
      );

      return userRequests.where((req) => req['type'] == type && req['status'] == 'pending').toList();
    } catch (e) {
      return [];
    }
  }

  /// Accept friend request
  Future<bool> acceptFriendRequest(String requestId, String senderId) async {
    try {
      // Update request status
      await _updateRequestStatus(requestId, 'accepted');

      // Create friend from request data
      final mockFriend = Friend(
        id: senderId,
        name: 'New Friend',
        avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=$senderId&size=200',
        isOnline: true,
        lastActiveTime: DateTime.now().toIso8601String(),
      );

      await addFriend(mockFriend);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Decline friend request
  Future<bool> declineFriendRequest(String requestId) async {
    return await _updateRequestStatus(requestId, 'declined');
  }

  /// Update request status
  Future<bool> _updateRequestStatus(String requestId, String status) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final requestsKey = 'friend_requests_$userId';
      final existingRequests = _storage.getSetting<List<dynamic>>(requestsKey, defaultValue: []) ?? [];
      final userRequests = List<Map<String, dynamic>>.from(
        existingRequests.map((e) => Map<String, dynamic>.from(e))
      );

      final requestIndex = userRequests.indexWhere((req) => req['id'] == requestId);
      if (requestIndex != -1) {
        userRequests[requestIndex]['status'] = status;
        userRequests[requestIndex]['updatedDate'] = DateTime.now().toIso8601String();
        await _storage.saveSetting(requestsKey, userRequests);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Simulate incoming friend request for demo
  Future<void> _simulateIncomingRequest(String fromUserId, String message) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final requestsKey = 'friend_requests_$userId';

      // Delay simulation
      Future.delayed(const Duration(seconds: 2), () async {
        final existingRequests = _storage.getSetting<List<dynamic>>(requestsKey, defaultValue: []) ?? [];
        final userRequests = List<Map<String, dynamic>>.from(
          existingRequests.map((e) => Map<String, dynamic>.from(e))
        );

        // Simulate an incoming request
        final incomingRequest = {
          'id': 'req_incoming_${DateTime.now().millisecondsSinceEpoch}',
          'senderId': fromUserId,
          'senderName': 'Alex Demo',
          'senderAvatar': 'https://api.dicebear.com/7.x/avataaars/png?seed=alex&size=200',
          'message': 'Hi! I\'d like to connect with you on Memore!',
          'status': 'pending',
          'receivedDate': DateTime.now().toIso8601String(),
          'type': 'incoming',
        };

        userRequests.add(incomingRequest);
        await _storage.saveSetting(requestsKey, userRequests);
      });
    } catch (e) {
      // Ignore simulation errors
    }
  }

  /// Search friends
  List<Friend> searchFriends(String query) {
    final friends = getFriendsList();
    if (query.isEmpty) return friends;

    final searchTerm = query.toLowerCase();
    return friends.where((friend) {
      return friend.name.toLowerCase().contains(searchTerm);
    }).toList();
  }

  /// Update friend interaction data
  Future<void> updateInteraction(String friendId, {
    int? photosShared,
    int? mutualLikes,
    Map<String, dynamic>? chatMessage,
  }) async {
    try {
      final existingFriend = _storage.getFriend(friendId);
      if (existingFriend == null) return;

      final currentInteraction = existingFriend['interaction'] as Map<String, dynamic>? ?? {};

      final updates = <String, dynamic>{};
      updates['interaction'] = {
        ...currentInteraction,
        'lastMessageTime': chatMessage != null ? DateTime.now().toIso8601String() : currentInteraction['lastMessageTime'],
        'photosShared': photosShared ?? currentInteraction['photosShared'] ?? 0,
        'mutualLikes': mutualLikes ?? currentInteraction['mutualLikes'] ?? 0,
        'chatHistory': chatMessage != null
          ? [...(currentInteraction['chatHistory'] as List<dynamic>? ?? []), chatMessage]
          : currentInteraction['chatHistory'] ?? <Map<String, dynamic>>[],
      };

      await updateFriend(friendId, updates);
    } catch (e) {
      // Ignore interaction update errors
    }
  }

  /// Get friends count
  int getFriendsCount() {
    return getFriendsList().length;
  }

  /// Get online friends count
  int getOnlineFriendsCount() {
    return getFriendsList().where((friend) => friend.isOnline).length;
  }

  /// Get recent interactions
  List<Map<String, dynamic>> getRecentInteractions({int limit = 10}) {
    final friends = getFriendsList();
    final interactions = <Map<String, dynamic>>[];

    for (final friend in friends) {
      // This would be expanded to include actual interaction data
      interactions.add({
        'friendId': friend.id,
        'friendName': friend.name,
        'friendAvatar': friend.avatarUrl,
        'type': 'friend_activity',
        'message': '${friend.name} shared a new photo',
        'timestamp': DateTime.now().subtract(Duration(hours: interactions.length)).toIso8601String(),
      });
    }

    interactions.sort((a, b) =>
      DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));

    return interactions.take(limit).toList();
  }

  /// Initialize sample friends for demo
  Future<void> initializeSampleFriends() async {
    try {
      final existingFriends = getFriendsList();
      if (existingFriends.isNotEmpty) return; // Already has friends

      final sampleFriends = [
        Friend(
          id: 'friend_1',
          name: 'Sarah Johnson',
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=sarah&size=200',
          isOnline: true,
          lastActiveTime: DateTime.now().toIso8601String(),
        ),
        Friend(
          id: 'friend_2',
          name: 'Mike Chen',
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=mike&size=200',
          isOnline: false,
          lastActiveTime: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        ),
        Friend(
          id: 'friend_3',
          name: 'Emma Davis',
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=emma&size=200',
          isOnline: true,
          lastActiveTime: DateTime.now().toIso8601String(),
        ),
      ];

      for (final friend in sampleFriends) {
        await addFriend(friend);
      }
    } catch (e) {
      // Ignore initialization errors
    }
  }
}