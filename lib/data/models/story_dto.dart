import '../../domain/entities/story.dart';

class StoryDto {
  final String id;
  final String? userId;
  final String? userName;
  final String? photoId;
  final String? content;
  final String? expiresAt;
  final String? createdAt;
  final bool isActive;
  final int viewCount;
  final String? userAvatarUrl;
  final String? photoUrl;

  StoryDto({
    required this.id,
    this.userId,
    this.userName,
    this.photoId,
    this.content,
    this.expiresAt,
    this.createdAt,
    this.isActive = true,
    this.viewCount = 0,
    this.userAvatarUrl,
    this.photoUrl,
  });

  factory StoryDto.fromJson(Map<String, dynamic> json) {
    return StoryDto(
      id: json['id'].toString(),
      userId: json['userId']?.toString(),
      userName: json['userName'] as String?,
      photoId: json['photoId']?.toString(),
      content: json['content'] as String?,
      expiresAt: json['expiresAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
      viewCount: json['viewCount'] as int? ?? 0,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'photoId': photoId,
      'content': content,
      'expiresAt': expiresAt,
      'createdAt': createdAt,
      'isActive': isActive,
      'viewCount': viewCount,
      'userAvatarUrl': userAvatarUrl,
      'photoUrl': photoUrl,
    };
  }

  Story toEntity() {
    return Story(
      id: id,
      userId: userId ?? '',
      userAvatar: userAvatarUrl ?? 'https://i.pravatar.cc/150?u=$userId',
      userName: userName ?? 'Unknown',
      photoUrl: photoUrl,
      content: content,
      createdAt: createdAt,
      expiresAt: expiresAt,
      viewCount: viewCount,
    );
  }
}
