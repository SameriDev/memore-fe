import 'storage_service.dart';
import 'user_manager.dart';
import 'friend_manager.dart';

class PhotoInteractionManager {
  static PhotoInteractionManager? _instance;
  static PhotoInteractionManager get instance => _instance ??= PhotoInteractionManager._();

  PhotoInteractionManager._();

  final _storage = StorageService.instance;
  final _userManager = UserManager.instance;
  final _friendManager = FriendManager.instance;

  /// Get current user ID
  String? get currentUserId => _storage.userId;

  /// Like a photo
  Future<bool> likePhoto(String photoId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      // Get or create photo likes data
      final likesKey = 'photo_likes_$photoId';
      final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
      final photoLikes = List<String>.from(existingLikes);

      // Check if already liked
      if (photoLikes.contains(userId)) {
        return false; // Already liked
      }

      // Add like
      photoLikes.add(userId);
      await _storage.saveSetting(likesKey, photoLikes);

      // Update photo metadata
      await _updatePhotoLikeCount(photoId, photoLikes.length);

      // Track interaction with photo owner
      await _trackPhotoInteraction(photoId, 'like');

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Unlike a photo
  Future<bool> unlikePhoto(String photoId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      // Get photo likes data
      final likesKey = 'photo_likes_$photoId';
      final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
      final photoLikes = List<String>.from(existingLikes);

      // Check if liked
      if (!photoLikes.contains(userId)) {
        return false; // Not liked
      }

      // Remove like
      photoLikes.remove(userId);
      await _storage.saveSetting(likesKey, photoLikes);

      // Update photo metadata
      await _updatePhotoLikeCount(photoId, photoLikes.length);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if photo is liked by current user
  bool isPhotoLiked(String photoId) {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final likesKey = 'photo_likes_$photoId';
      final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
      final photoLikes = List<String>.from(existingLikes);

      return photoLikes.contains(userId);
    } catch (e) {
      return false;
    }
  }

  /// Get photo likes count
  int getPhotoLikesCount(String photoId) {
    try {
      final likesKey = 'photo_likes_$photoId';
      final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
      return existingLikes.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get users who liked the photo
  List<Map<String, dynamic>> getPhotoLikers(String photoId) {
    try {
      final likesKey = 'photo_likes_$photoId';
      final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
      final photoLikes = List<String>.from(existingLikes);

      final likers = <Map<String, dynamic>>[];
      final friends = _friendManager.getFriendsList();
      final currentUser = _userManager.getCurrentUser();

      for (final likerId in photoLikes) {
        if (likerId == _storage.userId) {
          // Current user
          likers.add({
            'id': likerId,
            'name': currentUser?['name'] ?? 'You',
            'avatarUrl': currentUser?['avatarUrl'] ?? '',
            'isCurrentUser': true,
          });
        } else {
          // Find friend
          final friend = friends.where((f) => f.id == likerId).firstOrNull;
          if (friend != null) {
            likers.add({
              'id': friend.id,
              'name': friend.name,
              'avatarUrl': friend.avatarUrl,
              'isCurrentUser': false,
            });
          } else {
            // Mock user for demo
            likers.add({
              'id': likerId,
              'name': 'Friend',
              'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/png?seed=$likerId&size=200',
              'isCurrentUser': false,
            });
          }
        }
      }

      return likers;
    } catch (e) {
      return [];
    }
  }

  /// Add comment to photo
  Future<String?> addComment(String photoId, String commentText) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return null;

      final currentUser = _userManager.getCurrentUser();
      if (currentUser == null) return null;

      // Get or create photo comments data
      final commentsKey = 'photo_comments_$photoId';
      final existingComments = _storage.getSetting<List<dynamic>>(commentsKey, defaultValue: []) ?? [];
      final photoComments = List<Map<String, dynamic>>.from(
        existingComments.map((e) => Map<String, dynamic>.from(e))
      );

      // Create comment
      final commentId = 'comment_${DateTime.now().millisecondsSinceEpoch}';
      final comment = {
        'id': commentId,
        'photoId': photoId,
        'userId': userId,
        'userName': currentUser['name'],
        'userAvatar': currentUser['avatarUrl'],
        'text': commentText,
        'timestamp': DateTime.now().toIso8601String(),
        'likes': 0,
        'likedBy': <String>[],
      };

      photoComments.add(comment);
      await _storage.saveSetting(commentsKey, photoComments);

      // Update photo metadata
      await _updatePhotoCommentCount(photoId, photoComments.length);

      // Track interaction with photo owner
      await _trackPhotoInteraction(photoId, 'comment');

      return commentId;
    } catch (e) {
      return null;
    }
  }

  /// Get photo comments
  List<Map<String, dynamic>> getPhotoComments(String photoId) {
    try {
      final commentsKey = 'photo_comments_$photoId';
      final existingComments = _storage.getSetting<List<dynamic>>(commentsKey, defaultValue: []) ?? [];
      final photoComments = List<Map<String, dynamic>>.from(
        existingComments.map((e) => Map<String, dynamic>.from(e))
      );

      // Sort by timestamp (oldest first for comments)
      photoComments.sort((a, b) {
        final timeA = DateTime.parse(a['timestamp']);
        final timeB = DateTime.parse(b['timestamp']);
        return timeA.compareTo(timeB);
      });

      return photoComments;
    } catch (e) {
      return [];
    }
  }

  /// Get photo comments count
  int getPhotoCommentsCount(String photoId) {
    return getPhotoComments(photoId).length;
  }

  /// Like a comment
  Future<bool> likeComment(String photoId, String commentId) async {
    try {
      final userId = _storage.userId;
      if (userId == null) return false;

      final commentsKey = 'photo_comments_$photoId';
      final existingComments = _storage.getSetting<List<dynamic>>(commentsKey, defaultValue: []) ?? [];
      final photoComments = List<Map<String, dynamic>>.from(
        existingComments.map((e) => Map<String, dynamic>.from(e))
      );

      final commentIndex = photoComments.indexWhere((c) => c['id'] == commentId);
      if (commentIndex == -1) return false;

      final comment = photoComments[commentIndex];
      final likedBy = List<String>.from(comment['likedBy'] ?? []);

      if (likedBy.contains(userId)) {
        // Unlike comment
        likedBy.remove(userId);
      } else {
        // Like comment
        likedBy.add(userId);
      }

      photoComments[commentIndex]['likedBy'] = likedBy;
      photoComments[commentIndex]['likes'] = likedBy.length;

      await _storage.saveSetting(commentsKey, photoComments);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update photo like count in photo data
  Future<void> _updatePhotoLikeCount(String photoId, int likesCount) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto != null) {
        existingPhoto['likesCount'] = likesCount;
        existingPhoto['lastInteraction'] = DateTime.now().toIso8601String();
        await _storage.savePhoto(photoId, existingPhoto);
      }
    } catch (e) {
      // Ignore update errors
    }
  }

  /// Update photo comment count in photo data
  Future<void> _updatePhotoCommentCount(String photoId, int commentsCount) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto != null) {
        existingPhoto['commentsCount'] = commentsCount;
        existingPhoto['lastInteraction'] = DateTime.now().toIso8601String();
        await _storage.savePhoto(photoId, existingPhoto);
      }
    } catch (e) {
      // Ignore update errors
    }
  }

  /// Track interaction with photo owner (for friend interaction stats)
  Future<void> _trackPhotoInteraction(String photoId, String interactionType) async {
    try {
      final existingPhoto = _storage.getPhoto(photoId);
      if (existingPhoto == null) return;

      final photoOwnerId = existingPhoto['ownerId'] as String?;
      if (photoOwnerId == null || photoOwnerId == _storage.userId) return;

      // Update friend interaction stats
      if (interactionType == 'like') {
        await _friendManager.updateInteraction(
          photoOwnerId,
          mutualLikes: 1,
        );
      } else if (interactionType == 'comment') {
        await _friendManager.updateInteraction(
          photoOwnerId,
          chatMessage: {
            'type': 'photo_comment',
            'photoId': photoId,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (e) {
      // Ignore tracking errors
    }
  }

  /// Get photo interaction summary
  Map<String, dynamic> getPhotoInteractionSummary(String photoId) {
    return {
      'likesCount': getPhotoLikesCount(photoId),
      'commentsCount': getPhotoCommentsCount(photoId),
      'isLiked': isPhotoLiked(photoId),
      'likers': getPhotoLikers(photoId),
      'recentComments': getPhotoComments(photoId).take(3).toList(),
    };
  }

  /// Simulate friend interactions for demo
  Future<void> simulateFriendInteractions(String photoId) async {
    try {
      final friends = _friendManager.getFriendsList();
      if (friends.isEmpty) return;

      // Simulate some likes from friends
      for (int i = 0; i < 2 && i < friends.length; i++) {
        final friend = friends[i];
        final likesKey = 'photo_likes_$photoId';
        final existingLikes = _storage.getSetting<List<dynamic>>(likesKey, defaultValue: []) ?? [];
        final photoLikes = List<String>.from(existingLikes);

        if (!photoLikes.contains(friend.id)) {
          photoLikes.add(friend.id);
          await _storage.saveSetting(likesKey, photoLikes);
        }
      }

      // Simulate a comment from first friend
      if (friends.isNotEmpty) {
        final friend = friends.first;
        final commentsKey = 'photo_comments_$photoId';
        final existingComments = _storage.getSetting<List<dynamic>>(commentsKey, defaultValue: []) ?? [];
        final photoComments = List<Map<String, dynamic>>.from(
          existingComments.map((e) => Map<String, dynamic>.from(e))
        );

        final comment = {
          'id': 'comment_demo_${DateTime.now().millisecondsSinceEpoch}',
          'photoId': photoId,
          'userId': friend.id,
          'userName': friend.name,
          'userAvatar': friend.avatarUrl,
          'text': 'Great photo! 😍',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'likes': 0,
          'likedBy': <String>[],
        };

        photoComments.add(comment);
        await _storage.saveSetting(commentsKey, photoComments);
      }

      // Update photo metadata
      await _updatePhotoLikeCount(photoId, getPhotoLikesCount(photoId));
      await _updatePhotoCommentCount(photoId, getPhotoCommentsCount(photoId));
    } catch (e) {
      // Ignore simulation errors
    }
  }

  /// Clear all interactions for a photo
  Future<void> clearPhotoInteractions(String photoId) async {
    try {
      final likesKey = 'photo_likes_$photoId';
      final commentsKey = 'photo_comments_$photoId';

      await _storage.saveSetting(likesKey, <String>[]);
      await _storage.saveSetting(commentsKey, <Map<String, dynamic>>[]);

      await _updatePhotoLikeCount(photoId, 0);
      await _updatePhotoCommentCount(photoId, 0);
    } catch (e) {
      // Ignore clear errors
    }
  }
}

// Extension for easier access to interaction data
extension PhotoInteractionExtension on Map<String, dynamic> {
  int get likesCount => this['likesCount'] as int? ?? 0;
  int get commentsCount => this['commentsCount'] as int? ?? 0;

  bool get hasInteractions => likesCount > 0 || commentsCount > 0;

  String get interactionSummary {
    if (likesCount == 0 && commentsCount == 0) {
      return 'No interactions yet';
    }

    final parts = <String>[];
    if (likesCount > 0) {
      parts.add('$likesCount ${likesCount == 1 ? 'like' : 'likes'}');
    }
    if (commentsCount > 0) {
      parts.add('$commentsCount ${commentsCount == 1 ? 'comment' : 'comments'}');
    }

    return parts.join(' • ');
  }
}