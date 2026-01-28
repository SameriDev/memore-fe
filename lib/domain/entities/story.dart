class Story {
  final String id;
  final String userId;
  final String userAvatar;
  final String userName;
  final bool isAddButton;
  final List<String> images;
  final DateTime? createdAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.userId,
    required this.userAvatar,
    required this.userName,
    this.isAddButton = false,
    this.images = const [],
    this.createdAt,
    this.isViewed = false,
  });
}
