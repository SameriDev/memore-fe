import '../../domain/entities/user_profile.dart';
import '../../presentation/screens/recent_photos_viewer/recent_photos_viewer_screen.dart';

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

  // Mock data cho ảnh gần đây của user
  static List<PhotoItem> getRecentPhotos(String userId) {
    final now = DateTime.now();

    return [
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=1',
        uploadedAt: now.subtract(const Duration(hours: 2)),
      ),
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=2',
        uploadedAt: now.subtract(const Duration(hours: 5)),
      ),
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=3',
        uploadedAt: now.subtract(const Duration(hours: 12)),
      ),
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=4',
        uploadedAt: now.subtract(const Duration(days: 1)),
      ),
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=5',
        uploadedAt: now.subtract(const Duration(days: 2)),
      ),
      PhotoItem(
        imageUrl: 'https://picsum.photos/400/600?random=6',
        uploadedAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  // Mock data cho user khác
  static Map<String, dynamic> getUserInfo(String userId) {
    return {
      'name': 'Nguyen Trong Chien',
      'avatar': 'https://i.pravatar.cc/300?img=5',
    };
  }
}
