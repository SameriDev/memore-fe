import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'storage_service.dart';
import '../data_sources/remote/auth_service.dart';
import '../data_sources/remote/user_service.dart';
import '../data_sources/remote/photo_service.dart';
import '../data_sources/remote/friendship_service.dart';
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
  final _photoService = PhotoService.instance;
  final _friendshipService = FriendshipService.instance;

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

  /// Login with Google
  Future<AuthResult> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: '98078357098-pknisf1ub7kg5nop658jpeo31clhid2f.apps.googleusercontent.com',
      );

      // Sign out trước để đảm bảo token hoàn toàn mới, không bị cache cũ
      await googleSignIn.signOut();

      final account = await googleSignIn.signIn();
      if (account == null) {
        return AuthResult(success: false, errorMessage: 'Đăng nhập Google bị hủy');
      }

      // Lấy serverAuthCode (fresh, không cache) để backend exchange
      final serverAuthCode = account.serverAuthCode;
      String? idToken;
      try {
        final auth = await account.authentication;
        idToken = auth.idToken;
      } catch (_) {
        // Bỏ qua nếu authentication fail, backend sẽ dùng serverAuthCode
      }

      if (serverAuthCode == null && idToken == null) {
        return AuthResult(success: false, errorMessage: 'Không lấy được token từ Google');
      }

      debugPrint('[AUTH] serverAuthCode: $serverAuthCode');
      debugPrint('[AUTH] idToken null: ${idToken == null}');
      debugPrint('[AUTH] Google token obtained, calling BE...');
      final response = await _authService.loginWithGoogle(
        idToken: idToken,
        serverAuthCode: serverAuthCode,
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
        errorMessage: response.message ?? 'Đăng nhập Google thất bại',
      );
    } catch (e, stack) {
      debugPrint('[AUTH] loginWithGoogle error type: ${e.runtimeType}');
      debugPrint('[AUTH] loginWithGoogle error: $e');
      debugPrint('[AUTH] loginWithGoogle stack: $stack');
      if (e is PlatformException) {
        debugPrint('[AUTH] PlatformException code: ${e.code}');
        debugPrint('[AUTH] PlatformException message: ${e.message}');
        debugPrint('[AUTH] PlatformException details: ${e.details}');
      }
      return AuthResult(success: false, errorMessage: 'Lỗi đăng nhập Google: $e');
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

  /// Update user avatar via S3 upload
  Future<bool> updateAvatar(String localFilePath) async {
    try {
      final userId = _storage.userId;
      if (userId == null || userId.isEmpty) return false;

      // Step 1: Upload avatar to S3
      final s3Key = await _photoService.uploadAvatar(
        localFilePath: localFilePath,
        userId: userId,
      );
      if (s3Key == null) return false;

      // Step 2: Save S3 key to BE
      await _userService.updateUser(userId, {'avatarUrl': s3Key});

      // Step 3: Fetch fresh profile (BE returns presigned URL) and update local cache
      await fetchAndUpdateProfile();

      return true;
    } catch (e) {
      debugPrint('Update avatar error: $e');
      return false;
    }
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

  /// Fetch fresh profile with real counts from backend APIs
  Future<UserProfile?> fetchProfileWithRealCounts() async {
    try {
      final userId = _storage.userId;
      if (userId == null || userId.isEmpty) return null;

      debugPrint('🔄 Fetching profile with real counts for user: $userId');

      // Try to fetch all data in parallel for better performance
      try {
        final futures = await Future.wait([
          _userService.getUserById(userId),
          _photoService.getPhotoCountByUserId(userId),
          _friendshipService.getFriendsCount(userId),
        ]);

        final userDto = futures[0] as dynamic;
        final photosCount = futures[1] as int;
        final friendsCount = futures[2] as int;

        debugPrint('📊 Real counts - Photos: $photosCount, Friends: $friendsCount');

        // Update local storage with real counts
        final updatedProfile = userDto.toStorageMap();
        updatedProfile['photosCount'] = photosCount;
        updatedProfile['friendsCount'] = friendsCount;

        await _storage.saveUserProfile(updatedProfile);
        return toUserProfile();
      } catch (countingError) {
        debugPrint('⚠️ Counting APIs failed: $countingError');

        // Try to at least get user profile without counts
        final userDto = await _userService.getUserById(userId);
        await _storage.saveUserProfile(userDto.toStorageMap());
        return toUserProfile();
      }
    } catch (e) {
      debugPrint('❌ Error fetching profile with real counts: $e');
      // Fallback to normal fetch
      return await fetchAndUpdateProfile();
    }
  }

  /// Force refresh profile data with real backend counts
  Future<void> refreshProfileCounts() async {
    await fetchProfileWithRealCounts();
  }
}
