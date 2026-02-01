import 'storage_service.dart';
import 'user_manager.dart';
import 'friend_manager.dart';

class PhotoSharingManager {
  static PhotoSharingManager? _instance;
  static PhotoSharingManager get instance => _instance ??= PhotoSharingManager._();

  PhotoSharingManager._();

  final _storage = StorageService.instance;
  final _userManager = UserManager.instance;
  final _friendManager = FriendManager.instance;

  /// Share photo with specific friends
  Future<bool> sharePhotoWithFriends(String photoId, List<String> friendIds, {String? message}) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final currentUser = _userManager.getCurrentUser();
      if (currentUser == null) return false;

      // Get photo data
      final photoData = _storage.getPhoto(photoId);
      if (photoData == null) return false;

      // Create share record for each friend
      for (final friendId in friendIds) {
        await _createShareRecord(
          photoId: photoId,
          photoData: photoData,
          fromUserId: userId,
          fromUserName: currentUser['name'],
          fromUserAvatar: currentUser['avatarUrl'],
          toUserId: friendId,
          message: message,
        );

        // Update friend interaction stats
        await _friendManager.updateInteraction(
          friendId,
          photosShared: 1,
        );
      }

      // Update photo metadata
      await _updatePhotoShareCount(photoId, friendIds.length);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create share record for tracking
  Future<void> _createShareRecord({
    required String photoId,
    required Map<String, dynamic> photoData,
    required String fromUserId,
    required String fromUserName,
    required String fromUserAvatar,
    required String toUserId,
    String? message,
  }) async {
    try {
      // Store in receiver's shared photos
      final sharesKey = 'shared_photos_$toUserId';
      final existingShares = _storage.getSetting<List<dynamic>>(sharesKey, defaultValue: []) ?? [];
      final userShares = List<Map<String, dynamic>>.from(
        existingShares.map((e) => Map<String, dynamic>.from(e))
      );

      final shareRecord = {
        'id': 'share_${DateTime.now().millisecondsSinceEpoch}',
        'originalPhotoId': photoId,
        'photoData': photoData,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'fromUserAvatar': fromUserAvatar,
        'toUserId': toUserId,
        'message': message,
        'sharedAt': DateTime.now().toIso8601String(),
        'isViewed': false,
        'isLiked': false,
        'comments': <Map<String, dynamic>>[],
      };

      userShares.insert(0, shareRecord); // Add to beginning (most recent first)
      await _storage.saveSetting(sharesKey, userShares);

      // Also store in sender's outgoing shares for tracking
      final outgoingKey = 'outgoing_shares_$fromUserId';
      final existingOutgoing = _storage.getSetting<List<dynamic>>(outgoingKey, defaultValue: []) ?? [];
      final userOutgoing = List<Map<String, dynamic>>.from(
        existingOutgoing.map((e) => Map<String, dynamic>.from(e))
      );

      userOutgoing.insert(0, shareRecord);
      await _storage.saveSetting(outgoingKey, userOutgoing);
    } catch (e) {
      // Ignore share record creation errors
    }
  }

  /// Get shared photos received by current user
  List<Map<String, dynamic>> getSharedPhotos({int limit = 50}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final sharesKey = 'shared_photos_$userId';
      final existingShares = _storage.getSetting<List<dynamic>>(sharesKey, defaultValue: []) ?? [];
      final userShares = List<Map<String, dynamic>>.from(
        existingShares.map((e) => Map<String, dynamic>.from(e))
      );

      // Sort by shared date (newest first)
      userShares.sort((a, b) {
        final dateA = DateTime.parse(a['sharedAt']);
        final dateB = DateTime.parse(b['sharedAt']);
        return dateB.compareTo(dateA);
      });

      return userShares.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get photos shared by current user
  List<Map<String, dynamic>> getOutgoingShares({int limit = 50}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final outgoingKey = 'outgoing_shares_$userId';
      final existingOutgoing = _storage.getSetting<List<dynamic>>(outgoingKey, defaultValue: []) ?? [];
      final userOutgoing = List<Map<String, dynamic>>.from(
        existingOutgoing.map((e) => Map<String, dynamic>.from(e))
      );

      // Sort by shared date (newest first)
      userOutgoing.sort((a, b) {
        final dateA = DateTime.parse(a['sharedAt']);
        final dateB = DateTime.parse(b['sharedAt']);
        return dateB.compareTo(dateA);
      });

      return userOutgoing.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Mark shared photo as viewed
  Future<bool> markSharedPhotoAsViewed(String shareId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final sharesKey = 'shared_photos_$userId';
      final existingShares = _storage.getSetting<List<dynamic>>(sharesKey, defaultValue: []) ?? [];
      final userShares = List<Map<String, dynamic>>.from(
        existingShares.map((e) => Map<String, dynamic>.from(e))
      );

      final shareIndex = userShares.indexWhere((share) => share['id'] == shareId);
      if (shareIndex != -1) {
        userShares[shareIndex]['isViewed'] = true;
        userShares[shareIndex]['viewedAt'] = DateTime.now().toIso8601String();
        await _storage.saveSetting(sharesKey, userShares);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get unviewed shared photos count
  int getUnviewedSharedPhotosCount() {
    final sharedPhotos = getSharedPhotos();
    return sharedPhotos.where((share) => !(share['isViewed'] as bool? ?? false)).length;
  }

  /// Get friends who haven't been shared with recently
  List<Map<String, dynamic>> getSuggestedFriendsForSharing(String photoId) {
    final friends = _friendManager.getFriendsList();
    final outgoingShares = getOutgoingShares(limit: 20);

    // Find friends who haven't been shared with in the last 5 shares
    final recentlySharedWith = <String>{};
    for (final share in outgoingShares.take(5)) {
      recentlySharedWith.add(share['toUserId'] as String);
    }

    final suggestedFriends = friends.where((friend) {
      return !recentlySharedWith.contains(friend.id);
    }).map((friend) => {
      'id': friend.id,
      'name': friend.name,
      'avatarUrl': friend.avatarUrl,
      'isOnline': friend.isOnline,
    }).toList();

    return suggestedFriends;
  }

  /// Update photo share count
  Future<void> _updatePhotoShareCount(String photoId, int additionalShares) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto != null) {
        final currentShares = existingPhoto['sharesCount'] as int? ?? 0;
        existingPhoto['sharesCount'] = currentShares + additionalShares;
        existingPhoto['lastShared'] = DateTime.now().toIso8601String();
        await _storage.savePhoto(photoId, existingPhoto);
      }
    } catch (e) {
      // Ignore update errors
    }
  }

  /// Get photo sharing statistics
  Map<String, dynamic> getPhotoSharingStats(String photoId) {
    final outgoingShares = getOutgoingShares();
    final photoShares = outgoingShares.where((share) => share['originalPhotoId'] == photoId).toList();

    return {
      'totalShares': photoShares.length,
      'uniqueFriends': photoShares.map((s) => s['toUserId']).toSet().length,
      'recentShares': photoShares.take(5).toList(),
      'lastSharedAt': photoShares.isNotEmpty ? photoShares.first['sharedAt'] : null,
    };
  }

  /// Create album and share with friends
  Future<String?> createSharedAlbum({
    required String title,
    required String description,
    required List<String> photoIds,
    required List<String> friendIds,
  }) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return null;

      final currentUser = _userManager.getCurrentUser();
      if (currentUser == null) return null;

      final albumId = 'album_${DateTime.now().millisecondsSinceEpoch}';

      // Create album data
      final albumData = {
        'id': albumId,
        'title': title,
        'description': description,
        'photoIds': photoIds,
        'createdBy': userId,
        'createdByName': currentUser['name'],
        'createdByAvatar': currentUser['avatarUrl'],
        'createdAt': DateTime.now().toIso8601String(),
        'sharedWith': friendIds,
        'isShared': friendIds.isNotEmpty,
        'totalPhotos': photoIds.length,
      };

      // Save album
      final albumsKey = 'shared_albums_$userId';
      final existingAlbums = _storage.getSetting<List<dynamic>>(albumsKey, defaultValue: []) ?? [];
      final userAlbums = List<Map<String, dynamic>>.from(
        existingAlbums.map((e) => Map<String, dynamic>.from(e))
      );

      userAlbums.insert(0, albumData);
      await _storage.saveSetting(albumsKey, userAlbums);

      // Share with friends
      for (final friendId in friendIds) {
        final friendAlbumsKey = 'shared_albums_$friendId';
        final friendAlbums = _storage.getSetting<List<dynamic>>(friendAlbumsKey, defaultValue: []) ?? [];
        final friendAlbumsList = List<Map<String, dynamic>>.from(
          friendAlbums.map((e) => Map<String, dynamic>.from(e))
        );

        friendAlbumsList.insert(0, {
          ...albumData,
          'isOwner': false,
          'sharedAt': DateTime.now().toIso8601String(),
        });

        await _storage.saveSetting(friendAlbumsKey, friendAlbumsList);
      }

      return albumId;
    } catch (e) {
      return null;
    }
  }

  /// Get shared albums
  List<Map<String, dynamic>> getSharedAlbums({bool onlyOwned = false}) {
    try {
      final userId = _storage.userId;
      if (userId == null) return [];

      final albumsKey = 'shared_albums_$userId';
      final existingAlbums = _storage.getSetting<List<dynamic>>(albumsKey, defaultValue: []) ?? [];
      final userAlbums = List<Map<String, dynamic>>.from(
        existingAlbums.map((e) => Map<String, dynamic>.from(e))
      );

      if (onlyOwned) {
        return userAlbums.where((album) => album['createdBy'] == userId).toList();
      }

      return userAlbums;
    } catch (e) {
      return [];
    }
  }

  /// Simulate friend sharing activity for demo
  Future<void> simulateFriendSharingActivity() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      final friends = _friendManager.getFriendsList();
      if (friends.isEmpty) return;

      // Simulate receiving shares from friends
      final sharesKey = 'shared_photos_$userId';
      final existingShares = _storage.getSetting<List<dynamic>>(sharesKey, defaultValue: []) ?? [];
      final userShares = List<Map<String, dynamic>>.from(
        existingShares.map((e) => Map<String, dynamic>.from(e))
      );

      // Create some simulated shares from friends
      for (int i = 0; i < 3 && i < friends.length; i++) {
        final friend = friends[i];

        final simulatedShare = {
          'id': 'share_demo_${DateTime.now().millisecondsSinceEpoch}_$i',
          'originalPhotoId': 'demo_photo_$i',
          'photoData': {
            'id': 'demo_photo_$i',
            'imageUrl': 'https://picsum.photos/400/600?random=${100 + i}',
            'caption': 'Check out this amazing view! 📸',
            'ownerId': friend.id,
            'timestamp': DateTime.now().subtract(Duration(hours: i + 1)).millisecondsSinceEpoch,
          },
          'fromUserId': friend.id,
          'fromUserName': friend.name,
          'fromUserAvatar': friend.avatarUrl,
          'toUserId': userId,
          'message': i == 0 ? 'Thought you\'d love this!' : null,
          'sharedAt': DateTime.now().subtract(Duration(hours: i + 1)).toIso8601String(),
          'isViewed': i > 1, // First two are unviewed
          'isLiked': false,
          'comments': <Map<String, dynamic>>[],
        };

        userShares.insert(0, simulatedShare);
      }

      await _storage.saveSetting(sharesKey, userShares);
    } catch (e) {
      // Ignore simulation errors
    }
  }

  /// Clear all sharing data
  Future<void> clearAllSharingData() async {
    try {
      final userId = _storage.userId;
      if (userId == null) return;

      await _storage.saveSetting('shared_photos_$userId', <Map<String, dynamic>>[]);
      await _storage.saveSetting('outgoing_shares_$userId', <Map<String, dynamic>>[]);
      await _storage.saveSetting('shared_albums_$userId', <Map<String, dynamic>>[]);
    } catch (e) {
      // Ignore clear errors
    }
  }
}