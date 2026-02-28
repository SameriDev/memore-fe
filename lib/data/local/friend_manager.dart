import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../../domain/entities/friend.dart';
import '../data_sources/remote/friendship_service.dart';
import '../../data/models/friendship_dto.dart';

class FriendManager {
  static FriendManager? _instance;
  static FriendManager get instance => _instance ??= FriendManager._();

  FriendManager._();

  final _storage = StorageService.instance;
  final _friendshipService = FriendshipService.instance;

  /// Get user's friend list - fetch from API and cache locally
  Future<List<Friend>> getFriendsList() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return _getCachedFriends();

      final friendships = await _friendshipService.getUserFriends(userId);
      final friends = friendships.map((dto) => _dtoToFriend(dto, userId)).toList();

      // Cache locally
      for (final friend in friends) {
        await _storage.saveFriend(friend.id, {
          'id': friend.id,
          'name': friend.name,
          'avatarUrl': friend.avatarUrl,
          'isOnline': friend.isOnline,
          'lastActiveTime': friend.lastActiveTime,
        });
      }

      return friends;
    } catch (e) {
      debugPrint('Error fetching friends: $e');
      return _getCachedFriends();
    }
  }

  /// Get cached friends from local storage (offline fallback)
  List<Friend> _getCachedFriends() {
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

  /// Convert FriendshipDto to Friend entity
  Friend _dtoToFriend(FriendshipDto dto, String currentUserId) {
    return dto.toEntity(currentUserId);
  }

  /// Send friend request via API
  Future<bool> sendFriendRequest(String targetUserId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final result = await _friendshipService.sendRequest(userId, targetUserId);
      return result != null;
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      return false;
    }
  }

  /// Get pending friend requests via API
  Future<List<FriendshipDto>> getFriendRequests() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      return await _friendshipService.getPendingRequests(userId);
    } catch (e) {
      debugPrint('Error getting friend requests: $e');
      return [];
    }
  }

  /// Accept friend request via API
  Future<bool> acceptFriendRequest(String friendshipId) async {
    try {
      final result = await _friendshipService.acceptRequest(friendshipId);
      return result != null;
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
      return false;
    }
  }

  /// Check if user is friend (from local cache)
  bool isFriend(String friendId) {
    return _storage.getFriend(friendId) != null;
  }

  /// Get friend by ID (from local cache)
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

  /// Search friends (filter local cache)
  List<Friend> searchFriends(String query) {
    final friends = _getCachedFriends();
    if (query.isEmpty) return friends;

    final searchTerm = query.toLowerCase();
    return friends.where((friend) {
      return friend.name.toLowerCase().contains(searchTerm);
    }).toList();
  }

  /// Remove friend from local cache
  Future<bool> removeFriend(String friendId) async {
    try {
      await _storage.removeFriend(friendId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get friends count from cache
  int getFriendsCount() {
    return _getCachedFriends().length;
  }
}
