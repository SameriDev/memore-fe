class Story {
  final String id;
  final String userId;
  final String userAvatar;
  final String userName;
  final bool isAddButton;

  Story({
    required this.id,
    required this.userId,
    required this.userAvatar,
    required this.userName,
    this.isAddButton = false,
  });
}
