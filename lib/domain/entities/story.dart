class Story {
  final String id;
  final String userId;
  final String userAvatar;
  final String userName;
  final String? photoUrl;
  final String? content;
  final String? createdAt;
  final String? expiresAt;
  final int viewCount;
  final bool isAddButton;

  Story({
    required this.id,
    required this.userId,
    required this.userAvatar,
    required this.userName,
    this.photoUrl,
    this.content,
    this.createdAt,
    this.expiresAt,
    this.viewCount = 0,
    this.isAddButton = false,
  });
}
