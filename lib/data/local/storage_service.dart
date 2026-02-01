import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  SharedPreferences? _prefs;
  Box? _userBox;
  Box? _photosBox;
  Box? _friendsBox;
  Box? _settingsBox;

  static const String _userBoxName = 'user_data';
  static const String _photosBoxName = 'photos_data';
  static const String _friendsBoxName = 'friends_data';
  static const String _settingsBoxName = 'settings_data';

  // Keys for SharedPreferences
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyFirstLaunch = 'first_launch';

  /// Initialize all storage systems
  Future<void> initialize() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Initialize Hive
    await Hive.initFlutter();

    // Open Hive boxes
    _userBox = await Hive.openBox(_userBoxName);
    _photosBox = await Hive.openBox(_photosBoxName);
    _friendsBox = await Hive.openBox(_friendsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // === SharedPreferences Methods ===

  bool get isLoggedIn => _prefs?.getBool(keyIsLoggedIn) ?? false;

  Future<bool> setLoggedIn(bool value) async {
    return await _prefs?.setBool(keyIsLoggedIn, value) ?? false;
  }

  String? get userId => _prefs?.getString(keyUserId);

  Future<bool> setUserId(String userId) async {
    return await _prefs?.setString(keyUserId, userId) ?? false;
  }

  bool get isFirstLaunch => _prefs?.getBool(keyFirstLaunch) ?? true;

  Future<bool> setFirstLaunch(bool value) async {
    return await _prefs?.setBool(keyFirstLaunch, value) ?? false;
  }

  // === Hive Box Methods ===

  Box get userBox => _userBox!;
  Box get photosBox => _photosBox!;
  Box get friendsBox => _friendsBox!;
  Box get settingsBox => _settingsBox!;

  // === User Data Methods ===

  Future<void> saveUserProfile(Map<String, dynamic> userProfile) async {
    await _userBox?.put('profile', userProfile);
    // Also save to SharedPreferences for quick access
    await _prefs?.setString(keyUserProfile, jsonEncode(userProfile));
  }

  Map<String, dynamic>? getUserProfile() {
    // Try to get from Hive first
    final hiveProfile = _userBox?.get('profile');
    if (hiveProfile != null) {
      return Map<String, dynamic>.from(hiveProfile);
    }

    // Fallback to SharedPreferences
    final prefsProfile = _prefs?.getString(keyUserProfile);
    if (prefsProfile != null) {
      try {
        return jsonDecode(prefsProfile) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  // === Photo Data Methods ===

  Future<void> savePhoto(String photoId, Map<String, dynamic> photoData) async {
    await _photosBox?.put(photoId, photoData);
  }

  Map<String, dynamic>? getPhoto(String photoId) {
    final data = _photosBox?.get(photoId);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  List<Map<String, dynamic>> getAllPhotos() {
    final photos = <Map<String, dynamic>>[];
    for (var key in _photosBox?.keys ?? []) {
      final photo = _photosBox?.get(key);
      if (photo != null) {
        final photoMap = Map<String, dynamic>.from(photo);
        photoMap['id'] = key;
        photos.add(photoMap);
      }
    }
    // Sort by timestamp (newest first)
    photos.sort((a, b) {
      final timeA = a['timestamp'] as int? ?? 0;
      final timeB = b['timestamp'] as int? ?? 0;
      return timeB.compareTo(timeA);
    });
    return photos;
  }

  Future<void> deletePhoto(String photoId) async {
    await _photosBox?.delete(photoId);
  }

  // === Friends Data Methods ===

  Future<void> saveFriend(String friendId, Map<String, dynamic> friendData) async {
    await _friendsBox?.put(friendId, friendData);
  }

  Map<String, dynamic>? getFriend(String friendId) {
    final data = _friendsBox?.get(friendId);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  List<Map<String, dynamic>> getAllFriends() {
    final friends = <Map<String, dynamic>>[];
    for (var key in _friendsBox?.keys ?? []) {
      final friend = _friendsBox?.get(key);
      if (friend != null) {
        final friendMap = Map<String, dynamic>.from(friend);
        friendMap['id'] = key;
        friends.add(friendMap);
      }
    }
    return friends;
  }

  Future<void> removeFriend(String friendId) async {
    await _friendsBox?.delete(friendId);
  }

  // === Settings Methods ===

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox?.get(key, defaultValue: defaultValue) as T?;
  }

  // === Utility Methods ===

  Future<void> clearAllData() async {
    await _prefs?.clear();
    await _userBox?.clear();
    await _photosBox?.clear();
    await _friendsBox?.clear();
    await _settingsBox?.clear();
  }

  Future<void> logout() async {
    await setLoggedIn(false);
    await setUserId('');
    await _userBox?.clear();
    // Keep photos and friends for demo purposes
    // await _photosBox?.clear();
    // await _friendsBox?.clear();
  }
}