# Locket Technical Implementation

## Architecture Overview

This document provides the technical foundation for implementing Locket using **Flutter** with **Android-first** development approach. The architecture follows Clean Architecture principles with proper separation of concerns and scalability.

### Technology Stack
- **Frontend**: Flutter (Dart 3.0+)
- **State Management**: Riverpod 2.0+
- **Database**: SQLite (local) + Firebase Firestore (cloud sync)
- **Authentication**: Firebase Authentication
- **Storage**: Firebase Storage for photos
- **Push Notifications**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics
- **Platform**: Android API 21+ (Android 5.0+)

---

## 1. Project Structure

### 1.1 Folder Architecture

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_dimensions.dart
│   │   └── api_endpoints.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── network_info.dart
│   │   └── api_client.dart
│   ├── utils/
│   │   ├── image_utils.dart
│   │   ├── permission_utils.dart
│   │   └── validation_utils.dart
│   └── widgets/
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       └── empty_state_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── camera/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── friends/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── photos/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── models/
│   ├── services/
│   └── repositories/
└── main.dart
```

### 1.2 Feature Architecture

Each feature follows Clean Architecture with three layers:

```
feature/
├── data/
│   ├── datasources/
│   │   ├── local_datasource.dart
│   │   └── remote_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       └── feature_usecase.dart
└── presentation/
    ├── pages/
    │   └── feature_page.dart
    ├── providers/
    │   └── feature_provider.dart
    └── widgets/
        └── feature_widgets.dart
```

---

## 2. Dependencies

### 2.1 Core Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_messaging: ^14.7.10
  firebase_analytics: ^10.7.4

  # Camera & Images
  camera: ^0.10.5+7
  image_picker: ^1.0.5
  image: ^4.1.3
  photo_view: ^0.14.0

  # Local Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2

  # Networking
  dio: ^5.4.0
  connectivity_plus: ^5.0.2

  # UI Components
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0

  # Utilities
  permission_handler: ^11.1.0
  package_info_plus: ^4.2.0
  device_info_plus: ^9.1.1
  path_provider: ^2.1.2

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  # Build Runner
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9

  # Code Generation
  freezed: ^2.4.6
  json_serializable: ^6.7.1

  # Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4

  # Linting
  flutter_lints: ^3.0.1
```

### 2.2 Android Configuration

```kotlin
// android/app/build.gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.locket.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation "androidx.multidex:multidex:2.0.1"
    implementation 'androidx.work:work-runtime-ktx:2.9.0'
}
```

---

## 3. State Management with Riverpod

### 3.1 Provider Architecture

```dart
// Authentication State
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    state = const AuthState.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithPhone(phoneNumber);
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyCode(String code) async {
    try {
      await ref.read(authRepositoryProvider).verifyCode(code);
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

// Camera State
@riverpod
class CameraNotifier extends _$CameraNotifier {
  @override
  CameraState build() {
    return const CameraState.initial();
  }

  Future<void> initializeCamera() async {
    state = const CameraState.loading();
    try {
      final controller = await ref.read(cameraServiceProvider).initialize();
      state = CameraState.ready(controller);
    } catch (e) {
      state = CameraState.error(e.toString());
    }
  }

  Future<void> capturePhoto() async {
    try {
      final photo = await ref.read(cameraServiceProvider).capturePhoto();
      state = state.copyWith(capturedPhoto: photo);
    } catch (e) {
      state = CameraState.error(e.toString());
    }
  }
}

// Photos State
@riverpod
class PhotosNotifier extends _$PhotosNotifier {
  @override
  PhotosState build() {
    _loadPhotos();
    return const PhotosState.loading();
  }

  Future<void> _loadPhotos() async {
    try {
      final photos = await ref.read(photoRepositoryProvider).getRecentPhotos();
      state = PhotosState.loaded(photos);
    } catch (e) {
      state = PhotosState.error(e.toString());
    }
  }

  Future<void> sendPhoto(File photo, List<String> recipientIds) async {
    try {
      await ref.read(photoRepositoryProvider).sendPhoto(photo, recipientIds);
      _loadPhotos(); // Refresh
    } catch (e) {
      state = PhotosState.error(e.toString());
    }
  }
}
```

### 3.2 State Models

```dart
// State Classes using Freezed
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

@freezed
class CameraState with _$CameraState {
  const factory CameraState.initial() = _Initial;
  const factory CameraState.loading() = _Loading;
  const factory CameraState.ready(CameraController controller) = _Ready;
  const factory CameraState.error(String message) = _Error;

  const factory CameraState.photoCapture({
    required CameraController controller,
    XFile? capturedPhoto,
  }) = _PhotoCapture;
}

@freezed
class PhotosState with _$PhotosState {
  const factory PhotosState.loading() = _Loading;
  const factory PhotosState.loaded(List<PhotoMessage> photos) = _Loaded;
  const factory PhotosState.error(String message) = _Error;
}
```

---

## 4. Data Models

### 4.1 Core Entities

```dart
// User Entity
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String phoneNumber,
    required String username,
    required String displayName,
    String? profilePhotoUrl,
    String? bio,
    required DateTime createdAt,
    required DateTime lastActive,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Photo Message Entity
@freezed
class PhotoMessage with _$PhotoMessage {
  const factory PhotoMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String photoUrl,
    String? caption,
    required List<String> recipientIds,
    required DateTime sentAt,
    required PhotoStatus status,
    List<PhotoReaction>? reactions,
  }) = _PhotoMessage;

  factory PhotoMessage.fromJson(Map<String, dynamic> json) => _$PhotoMessageFromJson(json);
}

// Friend Entity
@freezed
class Friend with _$Friend {
  const factory Friend({
    required String id,
    required String userId,
    required String friendId,
    required String friendName,
    String? friendPhotoUrl,
    required DateTime connectedAt,
    required bool isOnline,
    DateTime? lastSeen,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}

// Friend Request Entity
@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required String id,
    required String fromUserId,
    required String fromUserName,
    required String toUserId,
    required String message,
    required DateTime sentAt,
    required FriendRequestStatus status,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
}

// Enums
enum PhotoStatus { sending, sent, delivered, failed }
enum FriendRequestStatus { pending, accepted, declined, expired }
```

---

## 5. Repository Pattern

### 5.1 Repository Interfaces

```dart
// Abstract Repositories
abstract class AuthRepository {
  Future<void> signInWithPhone(String phoneNumber);
  Future<void> verifyCode(String code);
  Future<User?> getCurrentUser();
  Future<void> signOut();
  Stream<User?> authStateChanges();
}

abstract class PhotoRepository {
  Future<void> sendPhoto(File photo, List<String> recipientIds, {String? caption});
  Future<List<PhotoMessage>> getRecentPhotos({int limit = 20});
  Future<void> markPhotoAsRead(String photoId);
  Future<void> reactToPhoto(String photoId, ReactionType reaction);
  Stream<List<PhotoMessage>> photoStream();
}

abstract class FriendRepository {
  Future<void> sendFriendRequest(String phoneNumber, {String? message});
  Future<void> acceptFriendRequest(String requestId);
  Future<void> declineFriendRequest(String requestId);
  Future<List<Friend>> getFriends();
  Future<List<FriendRequest>> getPendingRequests();
  Future<void> removeFriend(String friendId);
}
```

### 5.2 Repository Implementations

```dart
// Photo Repository Implementation
class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource _remoteDataSource;
  final PhotoLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  PhotoRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<void> sendPhoto(File photo, List<String> recipientIds, {String? caption}) async {
    try {
      // Compress and prepare photo
      final compressedPhoto = await ImageUtils.compressImage(photo);

      // Upload to storage
      final photoUrl = await _remoteDataSource.uploadPhoto(compressedPhoto);

      // Create photo message
      final photoMessage = PhotoMessage(
        id: const Uuid().v4(),
        senderId: await _getCurrentUserId(),
        senderName: await _getCurrentUserName(),
        photoUrl: photoUrl,
        caption: caption,
        recipientIds: recipientIds,
        sentAt: DateTime.now(),
        status: PhotoStatus.sending,
      );

      // Save locally first
      await _localDataSource.savePhoto(photoMessage);

      // Send to server
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.sendPhoto(photoMessage);
        await _localDataSource.updatePhotoStatus(photoMessage.id, PhotoStatus.sent);
      }
    } catch (e) {
      throw PhotoSendFailure(e.toString());
    }
  }

  @override
  Future<List<PhotoMessage>> getRecentPhotos({int limit = 20}) async {
    try {
      // Try to get from network first
      if (await _networkInfo.isConnected) {
        final remotePhotos = await _remoteDataSource.getRecentPhotos(limit: limit);
        await _localDataSource.cachePhotos(remotePhotos);
        return remotePhotos;
      } else {
        // Fallback to local cache
        return await _localDataSource.getCachedPhotos(limit: limit);
      }
    } catch (e) {
      // Always fallback to local cache
      return await _localDataSource.getCachedPhotos(limit: limit);
    }
  }

  @override
  Stream<List<PhotoMessage>> photoStream() {
    return _remoteDataSource.photoStream();
  }
}
```

---

## 6. Services Layer

### 6.1 Camera Service

```dart
class CameraService {
  CameraController? _controller;

  Future<CameraController> initialize() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      return _controller!;
    } catch (e) {
      throw CameraException('Failed to initialize camera: $e');
    }
  }

  Future<XFile> capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw CameraException('Camera not initialized');
    }

    try {
      return await _controller!.takePicture();
    } catch (e) {
      throw CameraException('Failed to capture photo: $e');
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.setFlashMode(mode);
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
```

### 6.2 Notification Service

```dart
class NotificationService {
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'locket_photos',
    'Photo Notifications',
    description: 'Notifications for new photos from friends',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        id: message.hashCode,
        title: notification.title ?? 'New Photo',
        body: notification.body ?? 'You received a new photo',
        payload: message.data,
      );
    }
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'locket_photos',
      'Photo Notifications',
      channelDescription: 'Notifications for new photos from friends',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    await FlutterLocalNotificationsPlugin().show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: jsonEncode(payload),
    );
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background notification logic
}
```

### 6.3 Storage Service

```dart
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPhoto(File photo, String userId) async {
    try {
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('photos').child(fileName);

      final uploadTask = ref.putFile(photo);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        // Update UI with progress
      });

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload photo: $e');
    }
  }

  Future<File> downloadPhoto(String url, String fileName) async {
    try {
      final ref = _storage.refFromURL(url);
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/$fileName');

      await ref.writeToFile(file);
      return file;
    } catch (e) {
      throw StorageException('Failed to download photo: $e');
    }
  }

  Future<void> deletePhoto(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      throw StorageException('Failed to delete photo: $e');
    }
  }
}
```

---

## 7. Database Layer

### 7.1 Local Database (SQLite)

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'locket.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        phone_number TEXT NOT NULL,
        username TEXT NOT NULL,
        display_name TEXT NOT NULL,
        profile_photo_url TEXT,
        bio TEXT,
        created_at INTEGER NOT NULL,
        last_active INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE photos (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        sender_name TEXT NOT NULL,
        photo_url TEXT NOT NULL,
        caption TEXT,
        recipient_ids TEXT NOT NULL,
        sent_at INTEGER NOT NULL,
        status INTEGER NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE friends (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        friend_id TEXT NOT NULL,
        friend_name TEXT NOT NULL,
        friend_photo_url TEXT,
        connected_at INTEGER NOT NULL,
        is_online INTEGER NOT NULL DEFAULT 0,
        last_seen INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE friend_requests (
        id TEXT PRIMARY KEY,
        from_user_id TEXT NOT NULL,
        from_user_name TEXT NOT NULL,
        to_user_id TEXT NOT NULL,
        message TEXT,
        sent_at INTEGER NOT NULL,
        status INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades
  }
}

// Photo Local Data Source
class PhotoLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> savePhoto(PhotoMessage photo) async {
    final db = await _dbHelper.database;
    await db.insert(
      'photos',
      {
        'id': photo.id,
        'sender_id': photo.senderId,
        'sender_name': photo.senderName,
        'photo_url': photo.photoUrl,
        'caption': photo.caption,
        'recipient_ids': jsonEncode(photo.recipientIds),
        'sent_at': photo.sentAt.millisecondsSinceEpoch,
        'status': photo.status.index,
        'is_read': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PhotoMessage>> getCachedPhotos({int limit = 20}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'photos',
      orderBy: 'sent_at DESC',
      limit: limit,
    );

    return maps.map((map) => PhotoMessage(
      id: map['id'] as String,
      senderId: map['sender_id'] as String,
      senderName: map['sender_name'] as String,
      photoUrl: map['photo_url'] as String,
      caption: map['caption'] as String?,
      recipientIds: List<String>.from(jsonDecode(map['recipient_ids'] as String)),
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sent_at'] as int),
      status: PhotoStatus.values[map['status'] as int],
    )).toList();
  }

  Future<void> markPhotoAsRead(String photoId) async {
    final db = await _dbHelper.database;
    await db.update(
      'photos',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [photoId],
    );
  }
}
```

### 7.2 Cloud Database (Firestore)

```dart
class PhotoRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendPhoto(PhotoMessage photo) async {
    try {
      await _firestore.collection('photos').doc(photo.id).set({
        'senderId': photo.senderId,
        'senderName': photo.senderName,
        'photoUrl': photo.photoUrl,
        'caption': photo.caption,
        'recipientIds': photo.recipientIds,
        'sentAt': Timestamp.fromDate(photo.sentAt),
        'status': photo.status.name,
      });

      // Create notification documents for each recipient
      for (final recipientId in photo.recipientIds) {
        await _firestore.collection('notifications').add({
          'userId': recipientId,
          'type': 'photo_received',
          'photoId': photo.id,
          'senderId': photo.senderId,
          'senderName': photo.senderName,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      throw RemoteDataException('Failed to send photo: $e');
    }
  }

  Future<List<PhotoMessage>> getRecentPhotos({int limit = 20}) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('photos')
          .where('recipientIds', arrayContains: currentUserId)
          .orderBy('sentAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PhotoMessage(
          id: doc.id,
          senderId: data['senderId'],
          senderName: data['senderName'],
          photoUrl: data['photoUrl'],
          caption: data['caption'],
          recipientIds: List<String>.from(data['recipientIds']),
          sentAt: (data['sentAt'] as Timestamp).toDate(),
          status: PhotoStatus.values.firstWhere(
            (status) => status.name == data['status'],
            orElse: () => PhotoStatus.delivered,
          ),
        );
      }).toList();
    } catch (e) {
      throw RemoteDataException('Failed to get photos: $e');
    }
  }

  Stream<List<PhotoMessage>> photoStream() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      return Stream.error('User not authenticated');
    }

    return _firestore
        .collection('photos')
        .where('recipientIds', arrayContains: currentUserId)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return PhotoMessage(
            id: doc.id,
            senderId: data['senderId'],
            senderName: data['senderName'],
            photoUrl: data['photoUrl'],
            caption: data['caption'],
            recipientIds: List<String>.from(data['recipientIds']),
            sentAt: (data['sentAt'] as Timestamp).toDate(),
            status: PhotoStatus.values.firstWhere(
              (status) => status.name == data['status'],
              orElse: () => PhotoStatus.delivered,
            ),
          );
        }).toList());
  }
}
```

---

## 8. Error Handling

### 8.1 Exception Classes

```dart
// Base Exception Class
abstract class LocketException implements Exception {
  final String message;
  const LocketException(this.message);

  @override
  String toString() => message;
}

// Specific Exception Classes
class NetworkException extends LocketException {
  const NetworkException(super.message);
}

class CameraException extends LocketException {
  const CameraException(super.message);
}

class StorageException extends LocketException {
  const StorageException(super.message);
}

class AuthException extends LocketException {
  const AuthException(super.message);
}

class PhotoSendFailure extends LocketException {
  const PhotoSendFailure(super.message);
}

class RemoteDataException extends LocketException {
  const RemoteDataException(super.message);
}

class LocalDataException extends LocketException {
  const LocalDataException(super.message);
}
```

### 8.2 Error Handler Service

```dart
class ErrorHandler {
  static String getErrorMessage(Exception exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return 'Check your internet connection and try again.';
      case CameraException:
        return 'Camera error occurred. Please try again.';
      case StorageException:
        return 'Failed to upload photo. Please try again.';
      case AuthException:
        return 'Authentication failed. Please sign in again.';
      case PhotoSendFailure:
        return 'Failed to send photo. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  static void handleError(Exception exception) {
    // Log error for debugging
    debugPrint('Error: ${exception.toString()}');

    // Send to crash reporting service
    FirebaseCrashlytics.instance.recordError(exception, null);

    // Show user-friendly error message
    final message = getErrorMessage(exception);
    // Show snackbar or toast with message
  }
}
```

---

## 9. Testing Strategy

### 9.1 Unit Tests

```dart
// Example Unit Test for Photo Repository
class MockPhotoRemoteDataSource extends Mock implements PhotoRemoteDataSource {}
class MockPhotoLocalDataSource extends Mock implements PhotoLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  group('PhotoRepository', () {
    late PhotoRepositoryImpl repository;
    late MockPhotoRemoteDataSource mockRemoteDataSource;
    late MockPhotoLocalDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockRemoteDataSource = MockPhotoRemoteDataSource();
      mockLocalDataSource = MockPhotoLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = PhotoRepositoryImpl(
        mockRemoteDataSource,
        mockLocalDataSource,
        mockNetworkInfo,
      );
    });

    test('should send photo when network is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.uploadPhoto(any)).thenAnswer(
        (_) async => 'https://example.com/photo.jpg',
      );
      when(mockRemoteDataSource.sendPhoto(any)).thenAnswer((_) async {});
      when(mockLocalDataSource.savePhoto(any)).thenAnswer((_) async {});

      // Act
      await repository.sendPhoto(File('test.jpg'), ['user1', 'user2']);

      // Assert
      verify(mockRemoteDataSource.sendPhoto(any)).called(1);
      verify(mockLocalDataSource.savePhoto(any)).called(1);
    });
  });
}
```

### 9.2 Widget Tests

```dart
// Example Widget Test for Camera Screen
void main() {
  group('CameraScreen', () {
    testWidgets('should show camera view when initialized', (tester) async {
      // Arrange
      final mockCameraController = MockCameraController();
      when(mockCameraController.value).thenReturn(
        const CameraValue(
          isInitialized: true,
          previewSize: Size(100, 100),
          aspectRatio: 1.0,
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: CameraScreen(controller: mockCameraController),
        ),
      );

      // Assert
      expect(find.byType(CameraPreview), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });
}
```

### 9.3 Integration Tests

```dart
// Example Integration Test
void main() {
  group('Photo Sharing Flow', () {
    testWidgets('complete photo sharing flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Capture photo
      await tester.tap(find.byIcon(Icons.camera));
      await tester.pumpAndSettle();

      // Select friends
      await tester.tap(find.text('Send to Friends'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();

      // Verify success
      expect(find.text('Photo sent successfully'), findsOneWidget);
    });
  });
}
```

---

## 10. Performance Optimization

### 10.1 Image Optimization

```dart
class ImageUtils {
  static Future<File> compressImage(File image) async {
    final bytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(bytes)!;

    // Resize if too large
    final resized = decodedImage.width > 1080
        ? img.copyResize(decodedImage, width: 1080)
        : decodedImage;

    // Compress with quality
    final compressed = img.encodeJpg(resized, quality: 85);

    // Write to new file
    final compressedFile = File('${image.path}_compressed.jpg');
    await compressedFile.writeAsBytes(compressed);

    return compressedFile;
  }

  static Future<File> createThumbnail(File image, {int size = 150}) async {
    final bytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(bytes)!;
    final thumbnail = img.copyResize(decodedImage, width: size, height: size);
    final thumbnailBytes = img.encodeJpg(thumbnail, quality: 70);

    final thumbnailFile = File('${image.path}_thumb.jpg');
    await thumbnailFile.writeAsBytes(thumbnailBytes);

    return thumbnailFile;
  }
}
```

### 10.2 Memory Management

```dart
class MemoryManager {
  static const int maxCachedImages = 50;
  static final Map<String, Uint8List> _imageCache = {};

  static void cacheImage(String key, Uint8List bytes) {
    if (_imageCache.length >= maxCachedImages) {
      _imageCache.remove(_imageCache.keys.first);
    }
    _imageCache[key] = bytes;
  }

  static Uint8List? getCachedImage(String key) {
    return _imageCache[key];
  }

  static void clearCache() {
    _imageCache.clear();
  }
}
```

### 10.3 Background Processing

```dart
// Background Upload Service
class BackgroundUploadService {
  static const String taskName = 'photoUpload';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> scheduleUpload(String photoPath, List<String> recipientIds) async {
    await Workmanager().registerOneOffTask(
      taskName,
      taskName,
      inputData: {
        'photoPath': photoPath,
        'recipientIds': recipientIds,
      },
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case BackgroundUploadService.taskName:
        await _handlePhotoUpload(inputData!);
        break;
    }
    return Future.value(true);
  });
}

Future<void> _handlePhotoUpload(Map<String, dynamic> inputData) async {
  // Initialize Firebase
  await Firebase.initializeApp();

  final photoPath = inputData['photoPath'] as String;
  final recipientIds = List<String>.from(inputData['recipientIds']);

  // Perform upload in background
  final storageService = StorageService();
  final photoFile = File(photoPath);

  try {
    final photoUrl = await storageService.uploadPhoto(photoFile, 'background');
    // Update database with successful upload
  } catch (e) {
    // Handle upload failure
  }
}
```

---

## 11. Security Implementation

### 11.1 Photo Privacy

```dart
class PhotoSecurity {
  static Future<String> encryptPhoto(Uint8List photoBytes, String key) async {
    final encryptionKey = encrypt.Key.fromBase64(key);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));

    final encrypted = encrypter.encryptBytes(photoBytes, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static Future<Uint8List> decryptPhoto(String encryptedData, String key) async {
    final parts = encryptedData.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedBytes = encrypt.Encrypted.fromBase64(parts[1]);

    final encryptionKey = encrypt.Key.fromBase64(key);
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));

    return Uint8List.fromList(encrypter.decryptBytes(encryptedBytes, iv: iv));
  }

  static Future<void> removeExifData(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image != null) {
      final cleanBytes = img.encodeJpg(image);
      await imageFile.writeAsBytes(cleanBytes);
    }
  }
}
```

### 11.2 API Security

```dart
class ApiSecurity {
  static Map<String, String> getSecureHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getAuthToken()}',
      'X-API-Version': '1.0',
      'X-Client-Version': _getAppVersion(),
    };
  }

  static String _getAuthToken() {
    // Get token from secure storage
    return FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  }

  static String _getAppVersion() {
    // Get app version for API compatibility
    return '1.0.0';
  }
}
```

This comprehensive technical implementation guide provides the foundation for building a complete Locket clone using Flutter with Android-first approach. The architecture is scalable, maintainable, and follows industry best practices for mobile app development.