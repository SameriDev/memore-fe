import '../../domain/entities/user_profile.dart';

class MockUserProfile {
  static UserProfile getCurrentUser() {
    return UserProfile(
      id: '1',
      name: 'Nguyen Hong Nha',
      username: '@nha.nguyen24',
      avatarUrl: 'https://i.pravatar.cc/300?img=1',
      friendsCount: 36,
      imagesCount: 36,
      badgeLevel: 'GOLD',
      streakCount: 36,
      email: 'nha.nguyen24@example.com',
      birthday: DateTime(1998, 5, 15),
    );
  }
}
