class UserProfile {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final int friendsCount;
  final int imagesCount;
  final String badgeLevel;
  final int streakCount;
  final String email;
  final DateTime? birthday;
  final String subscriptionPlan;
  final DateTime? subscriptionExpiresAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.friendsCount,
    required this.imagesCount,
    required this.badgeLevel,
    required this.streakCount,
    required this.email,
    this.birthday,
    this.subscriptionPlan = 'FREE',
    this.subscriptionExpiresAt,
  });
}
