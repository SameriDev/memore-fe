import 'package:uuid/uuid.dart';

/// Photo model representing a shared photo in the memore clone app
/// Contains all photo-related data with placeholder structure for frontend-only implementation
class PhotoModel {
  final String id;
  final String senderId;
  final List<String> recipientIds;
  final String imageUrl;
  final String? localImagePath;
  final DateTime timestamp;
  final String? musicTrack;
  final String? musicArtist;
  final PhotoStatus status;
  final Map<String, DateTime> viewedBy;
  final bool isFromTimeTravel;
  final DateTime? originalTimestamp;

  const PhotoModel({
    required this.id,
    required this.senderId,
    required this.recipientIds,
    required this.imageUrl,
    this.localImagePath,
    required this.timestamp,
    this.musicTrack,
    this.musicArtist,
    required this.status,
    required this.viewedBy,
    this.isFromTimeTravel = false,
    this.originalTimestamp,
  });

  /// Create a copy with updated fields
  PhotoModel copyWith({
    String? id,
    String? senderId,
    List<String>? recipientIds,
    String? imageUrl,
    String? localImagePath,
    DateTime? timestamp,
    String? musicTrack,
    String? musicArtist,
    PhotoStatus? status,
    Map<String, DateTime>? viewedBy,
    bool? isFromTimeTravel,
    DateTime? originalTimestamp,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recipientIds: recipientIds ?? this.recipientIds,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      timestamp: timestamp ?? this.timestamp,
      musicTrack: musicTrack ?? this.musicTrack,
      musicArtist: musicArtist ?? this.musicArtist,
      status: status ?? this.status,
      viewedBy: viewedBy ?? this.viewedBy,
      isFromTimeTravel: isFromTimeTravel ?? this.isFromTimeTravel,
      originalTimestamp: originalTimestamp ?? this.originalTimestamp,
    );
  }

  /// Mark photo as viewed by a user
  PhotoModel markAsViewed(String userId) {
    final newViewedBy = Map<String, DateTime>.from(viewedBy);
    newViewedBy[userId] = DateTime.now();
    return copyWith(viewedBy: newViewedBy);
  }

  /// Check if photo was viewed by a specific user
  bool wasViewedBy(String userId) {
    return viewedBy.containsKey(userId);
  }

  /// Get formatted music info
  String get musicInfo {
    if (musicTrack == null) return '';
    if (musicArtist == null) return musicTrack!;
    return '$musicTrack - $musicArtist';
  }

  /// Check if photo has music
  bool get hasMusic => musicTrack != null && musicTrack!.isNotEmpty;

  /// Convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientIds': recipientIds,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'timestamp': timestamp.toIso8601String(),
      'musicTrack': musicTrack,
      'musicArtist': musicArtist,
      'status': status.toString(),
      'viewedBy': viewedBy.map((k, v) => MapEntry(k, v.toIso8601String())),
      'isFromTimeTravel': isFromTimeTravel,
      'originalTimestamp': originalTimestamp?.toIso8601String(),
    };
  }

  /// Create from JSON (for future API integration)
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      recipientIds: List<String>.from(json['recipientIds'] as List),
      imageUrl: json['imageUrl'] as String,
      localImagePath: json['localImagePath'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      musicTrack: json['musicTrack'] as String?,
      musicArtist: json['musicArtist'] as String?,
      status: PhotoStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => PhotoStatus.delivered,
      ),
      viewedBy: (json['viewedBy'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, DateTime.parse(v as String)),
      ),
      isFromTimeTravel: json['isFromTimeTravel'] as bool? ?? false,
      originalTimestamp: json['originalTimestamp'] != null
          ? DateTime.parse(json['originalTimestamp'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PhotoModel{id: $id, senderId: $senderId, timestamp: $timestamp, status: $status}';
  }
}

/// Photo status enum
enum PhotoStatus { sending, delivered, failed }

/// Photo interaction model for likes, saves, etc.
class PhotoInteraction {
  final String photoId;
  final String userId;
  final PhotoInteractionType type;
  final DateTime timestamp;

  const PhotoInteraction({
    required this.photoId,
    required this.userId,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'photoId': photoId,
      'userId': userId,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PhotoInteraction.fromJson(Map<String, dynamic> json) {
    return PhotoInteraction(
      photoId: json['photoId'] as String,
      userId: json['userId'] as String,
      type: PhotoInteractionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Photo interaction types
enum PhotoInteractionType { viewed, saved, reported, copied }

/// Mock data class for testing and development
class MockPhotos {
  static const _uuid = Uuid();

  /// Sample photos for testing
  static final List<PhotoModel> samplePhotos = [
    PhotoModel(
      id: 'photo_001',
      senderId: 'friend_001',
      recipientIds: ['user_001'],
      imageUrl: 'assets/images/sample_photo_1.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      musicTrack: 'Good 4 U',
      musicArtist: 'Olivia Rodrigo',
      status: PhotoStatus.delivered,
      viewedBy: {},
    ),
    PhotoModel(
      id: 'photo_002',
      senderId: 'friend_002',
      recipientIds: ['user_001', 'friend_001'],
      imageUrl: 'assets/images/sample_photo_2.jpg',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: PhotoStatus.delivered,
      viewedBy: {'user_001': DateTime.now().subtract(const Duration(hours: 4))},
    ),
    PhotoModel(
      id: 'photo_003',
      senderId: 'user_001',
      recipientIds: ['friend_001', 'friend_002'],
      imageUrl: 'assets/images/sample_photo_3.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      musicTrack: 'Blinding Lights',
      musicArtist: 'The Weeknd',
      status: PhotoStatus.delivered,
      viewedBy: {
        'friend_001': DateTime.now().subtract(const Duration(hours: 20)),
        'friend_002': DateTime.now().subtract(const Duration(hours: 18)),
      },
    ),
    PhotoModel(
      id: 'photo_004',
      senderId: 'friend_003',
      recipientIds: ['user_001'],
      imageUrl: 'assets/images/sample_photo_4.jpg',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: PhotoStatus.delivered,
      viewedBy: {},
    ),
  ];

  /// Time travel photos (memories from past)
  static final List<PhotoModel> timeTravelPhotos = [
    PhotoModel(
      id: 'photo_tt_001',
      senderId: 'friend_001',
      recipientIds: ['user_001'],
      imageUrl: 'assets/images/memory_1.jpg',
      timestamp: DateTime.now(),
      originalTimestamp: DateTime.now().subtract(const Duration(days: 365)),
      isFromTimeTravel: true,
      status: PhotoStatus.delivered,
      viewedBy: {},
    ),
    PhotoModel(
      id: 'photo_tt_002',
      senderId: 'user_001',
      recipientIds: ['friend_002'],
      imageUrl: 'assets/images/memory_2.jpg',
      timestamp: DateTime.now(),
      originalTimestamp: DateTime.now().subtract(const Duration(days: 30)),
      isFromTimeTravel: true,
      musicTrack: 'Memories',
      musicArtist: 'Maroon 5',
      status: PhotoStatus.delivered,
      viewedBy: {},
    ),
  ];

  /// Generate a random photo for testing
  static PhotoModel generateRandomPhoto({
    required String senderId,
    required List<String> recipientIds,
  }) {
    final sampleImageUrls = [
      'assets/images/sample_1.jpg',
      'assets/images/sample_2.jpg',
      'assets/images/sample_3.jpg',
      'assets/images/sample_4.jpg',
    ];

    final sampleTracks = [
      {'track': 'Watermelon Sugar', 'artist': 'Harry Styles'},
      {'track': 'Levitating', 'artist': 'Dua Lipa'},
      {'track': 'Circles', 'artist': 'Post Malone'},
      {'track': 'Sunflower', 'artist': 'Post Malone & Swae Lee'},
    ];

    final hasMusic = DateTime.now().second % 3 == 0;
    final music = hasMusic
        ? sampleTracks[DateTime.now().millisecond % sampleTracks.length]
        : null;

    return PhotoModel(
      id: _uuid.v4(),
      senderId: senderId,
      recipientIds: recipientIds,
      imageUrl:
          sampleImageUrls[DateTime.now().millisecond % sampleImageUrls.length],
      timestamp: DateTime.now().subtract(
        Duration(
          hours: DateTime.now().second % 24,
          minutes: DateTime.now().minute % 60,
        ),
      ),
      musicTrack: music?['track'],
      musicArtist: music?['artist'],
      status: PhotoStatus.delivered,
      viewedBy: {},
    );
  }

  /// Get photos for a specific user (received photos)
  static List<PhotoModel> getPhotosForUser(String userId) {
    return samplePhotos
        .where((photo) => photo.recipientIds.contains(userId))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get photos sent by a specific user
  static List<PhotoModel> getPhotosSentByUser(String userId) {
    return samplePhotos.where((photo) => photo.senderId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get photo by ID
  static PhotoModel? getPhotoById(String id) {
    try {
      return samplePhotos.firstWhere((photo) => photo.id == id);
    } catch (e) {
      // Check time travel photos too
      try {
        return timeTravelPhotos.firstWhere((photo) => photo.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  /// Get recent photos (last 24 hours)
  static List<PhotoModel> getRecentPhotos(String userId) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return getPhotosForUser(
      userId,
    ).where((photo) => photo.timestamp.isAfter(yesterday)).toList();
  }

  /// Get photos from a specific time period
  static List<PhotoModel> getPhotosFromPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return getPhotosForUser(userId)
        .where(
          (photo) =>
              photo.timestamp.isAfter(start) && photo.timestamp.isBefore(end),
        )
        .toList();
  }

  /// Get all photos (for testing)
  static List<PhotoModel> getAllPhotos() {
    return [...samplePhotos, ...timeTravelPhotos]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get time travel photos for a user
  static List<PhotoModel> getTimeTravelPhotos(String userId) {
    return timeTravelPhotos
        .where(
          (photo) =>
              photo.recipientIds.contains(userId) || photo.senderId == userId,
        )
        .toList()
      ..sort((a, b) => b.originalTimestamp!.compareTo(a.originalTimestamp!));
  }
}
