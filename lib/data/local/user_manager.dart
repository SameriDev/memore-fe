import 'storage_service.dart';

class UserManager {
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  UserManager._();

  final _storage = StorageService.instance;

  /// Login user and save profile locally
  Future<bool> login({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // In a real app, this would call an API
      // For demo, we'll create/load user profile locally

      final userId = _generateUserId(email);

      // Check if user profile exists
      var userProfile = _storage.getUserProfile();

      if (userProfile == null || userProfile['email'] != email) {
        // Create new user profile
        userProfile = {
          'id': userId,
          'email': email,
          'name': name ?? _extractNameFromEmail(email),
          'username': '@${_extractUsernameFromEmail(email)}',
          'avatarUrl': _generateAvatarUrl(email),
          'bio': 'Hello, I\'m using Memore! 📸',
          'friendsCount': 0,
          'photosCount': 0,
          'joinedDate': DateTime.now().toIso8601String(),
          'isOnline': true,
          'lastActiveTime': DateTime.now().toIso8601String(),
          'settings': _getDefaultSettings(),
        };

        await _storage.saveUserProfile(userProfile);
      }

      await _storage.setLoggedIn(true);
      await _storage.setUserId(userId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userId = _generateUserId(email);

      final userProfile = {
        'id': userId,
        'email': email,
        'name': name,
        'username': '@${_extractUsernameFromEmail(email)}',
        'avatarUrl': _generateAvatarUrl(email),
        'bio': 'New to Memore! 🎉',
        'friendsCount': 0,
        'photosCount': 0,
        'joinedDate': DateTime.now().toIso8601String(),
        'isOnline': true,
        'lastActiveTime': DateTime.now().toIso8601String(),
        'settings': _getDefaultSettings(),
        'isFirstTime': true,
      };

      await _storage.saveUserProfile(userProfile);
      await _storage.setLoggedIn(true);
      await _storage.setUserId(userId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _updateUserOnlineStatus(false);
    await _storage.logout();
  }

  /// Get current user profile
  Map<String, dynamic>? getCurrentUser() {
    return _storage.getUserProfile();
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    try {
      final currentProfile = getCurrentUser();
      if (currentProfile == null) return false;

      final updatedProfile = {...currentProfile, ...updates};
      await _storage.saveUserProfile(updatedProfile);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update user avatar
  Future<bool> updateAvatar(String avatarPath) async {
    return await updateProfile({'avatarUrl': avatarPath});
  }

  /// Update user bio
  Future<bool> updateBio(String bio) async {
    return await updateProfile({'bio': bio});
  }

  /// Update user settings
  Future<bool> updateSettings(String key, dynamic value) async {
    try {
      final currentProfile = getCurrentUser();
      if (currentProfile == null) return false;

      final settings = Map<String, dynamic>.from(currentProfile['settings'] ?? {});
      settings[key] = value;

      return await updateProfile({'settings': settings});
    } catch (e) {
      return false;
    }
  }

  /// Get user setting
  T? getSetting<T>(String key, {T? defaultValue}) {
    final profile = getCurrentUser();
    if (profile == null) return defaultValue;

    final settings = Map<String, dynamic>.from(profile['settings'] ?? {});
    return settings[key] as T? ?? defaultValue;
  }

  /// Update online status
  Future<void> _updateUserOnlineStatus(bool isOnline) async {
    await updateProfile({
      'isOnline': isOnline,
      'lastActiveTime': DateTime.now().toIso8601String(),
    });
  }

  /// Set user as active (call this periodically when app is in use)
  Future<void> updateActivity() async {
    await _updateUserOnlineStatus(true);
  }

  /// Increment photo count
  Future<void> incrementPhotoCount() async {
    final profile = getCurrentUser();
    if (profile != null) {
      final currentCount = profile['photosCount'] as int? ?? 0;
      await updateProfile({'photosCount': currentCount + 1});
    }
  }

  /// Increment friends count
  Future<void> incrementFriendsCount() async {
    final profile = getCurrentUser();
    if (profile != null) {
      final currentCount = profile['friendsCount'] as int? ?? 0;
      await updateProfile({'friendsCount': currentCount + 1});
    }
  }

  /// Decrement friends count
  Future<void> decrementFriendsCount() async {
    final profile = getCurrentUser();
    if (profile != null) {
      final currentCount = profile['friendsCount'] as int? ?? 0;
      await updateProfile({'friendsCount': (currentCount - 1).clamp(0, double.infinity).toInt()});
    }
  }

  /// Generate user ID from email
  String _generateUserId(String email) {
    return 'user_${email.hashCode.abs()}';
  }

  /// Extract name from email
  String _extractNameFromEmail(String email) {
    final username = email.split('@')[0];
    return username
        .split('.')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  /// Extract username from email
  String _extractUsernameFromEmail(String email) {
    return email.split('@')[0].replaceAll('.', '_');
  }

  /// Generate avatar URL from email
  String _generateAvatarUrl(String email) {
    // Use a deterministic avatar service
    final hash = email.hashCode.abs();
    return 'https://api.dicebear.com/7.x/avataaars/png?seed=$hash&size=200';
  }

  /// Get default user settings
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'notifications': {
        'pushEnabled': true,
        'friendRequests': true,
        'newPhotos': true,
        'comments': true,
        'likes': true,
      },
      'privacy': {
        'profileVisibility': 'friends',
        'photosVisibility': 'friends',
        'allowFriendRequests': true,
        'showOnlineStatus': true,
      },
      'camera': {
        'defaultCamera': 'back',
        'flashMode': 'auto',
        'saveToGallery': true,
        'imageQuality': 'high',
      },
      'theme': {
        'darkMode': false,
        'accentColor': 'brown',
      },
      'storage': {
        'autoBackup': false,
        'cacheSize': '100MB',
        'clearCache': false,
      }
    };
  }

  /// Check if user is first time user
  bool isFirstTimeUser() {
    final profile = getCurrentUser();
    return profile?['isFirstTime'] == true;
  }

  /// Mark first time setup as completed
  Future<void> completeFirstTimeSetup() async {
    await updateProfile({'isFirstTime': false});
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  bool isValidPassword(String password) {
    // Basic validation: at least 6 characters
    return password.length >= 6;
  }

  /// Get user stats
  Map<String, int> getUserStats() {
    final profile = getCurrentUser();
    if (profile == null) {
      return {'friends': 0, 'photos': 0, 'likes': 0};
    }

    return {
      'friends': profile['friendsCount'] as int? ?? 0,
      'photos': profile['photosCount'] as int? ?? 0,
      'likes': 0, // Would be calculated from liked photos
    };
  }
}