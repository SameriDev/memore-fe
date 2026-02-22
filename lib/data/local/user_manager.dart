import 'storage_service.dart';
import '../data_sources/remote/auth_service.dart';
import '../data_sources/remote/user_service.dart';
import '../../domain/entities/user_profile.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

class UserManager {
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  UserManager._();

  final _storage = StorageService.instance;
  final _authService = AuthService.instance;
  final _userService = UserService.instance;

  /// Login user via BE API
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.success && response.accessToken != null && response.user != null) {
        await _storage.setAccessToken(response.accessToken!);
        await _storage.saveUserProfile(response.user!.toStorageMap());
        await _storage.setLoggedIn(true);
        await _storage.setUserId(response.user!.id);
        return AuthResult(success: true);
      }

      return AuthResult(
        success: false,
        errorMessage: response.message ?? 'Đăng nhập thất bại',
      );
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Không thể kết nối đến server');
    }
  }

  /// Register new user via BE API
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final username = email.split('@')[0].replaceAll('.', '_');

      final response = await _authService.register(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      if (response.success && response.accessToken != null && response.user != null) {
        await _storage.setAccessToken(response.accessToken!);
        await _storage.saveUserProfile(response.user!.toStorageMap());
        await _storage.setLoggedIn(true);
        await _storage.setUserId(response.user!.id);
        return AuthResult(success: true);
      }

      return AuthResult(
        success: false,
        errorMessage: response.message ?? 'Đăng ký thất bại',
      );
    } catch (e) {
      return AuthResult(success: false, errorMessage: 'Không thể kết nối đến server');
    }
  }

  /// Logout user
  Future<void> logout() async {
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

      // Fire-and-forget: sync to BE
      final userId = _storage.userId;
      if (userId != null && userId.isNotEmpty) {
        _userService.updateUser(userId, updates).ignore();
      }

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

  /// Set user as active
  Future<void> updateActivity() async {
    await updateProfile({
      'isOnline': true,
      'lastActiveTime': DateTime.now().toIso8601String(),
    });
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

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  bool isValidPassword(String password) {
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
      'likes': 0,
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

  /// Convert stored profile map to UserProfile entity
  UserProfile? toUserProfile() {
    final profile = getCurrentUser();
    if (profile == null) return null;

    return UserProfile(
      id: profile['id'] as String? ?? '',
      name: profile['name'] as String? ?? '',
      username: profile['username'] as String? ?? '',
      avatarUrl: profile['avatarUrl'] as String? ?? '',
      friendsCount: profile['friendsCount'] as int? ?? 0,
      imagesCount: profile['photosCount'] as int? ?? 0,
      badgeLevel: profile['badgeLevel'] as String? ?? 'BRONZE',
      streakCount: profile['streakCount'] as int? ?? 0,
      email: profile['email'] as String? ?? '',
      birthday: profile['birthday'] != null
          ? DateTime.tryParse(profile['birthday'] as String)
          : null,
    );
  }

  /// Fetch fresh profile from API and update local storage
  Future<UserProfile?> fetchAndUpdateProfile() async {
    try {
      final userId = _storage.userId;
      if (userId == null || userId.isEmpty) return null;

      final userDto = await _userService.getUserById(userId);
      await _storage.saveUserProfile(userDto.toStorageMap());

      return toUserProfile();
    } catch (e) {
      return null;
    }
  }
}
