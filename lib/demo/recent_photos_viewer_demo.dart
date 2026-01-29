import 'package:flutter/material.dart';
import '../data/mock/mock_user_profile.dart';
import '../presentation/screens/recent_photos_viewer/recent_photos_viewer_screen.dart';

/// Demo screen để test RecentPhotosViewerScreen
/// Bạn có thể navigate đến màn này để xem recent photos viewer hoạt động
class RecentPhotosViewerDemo extends StatelessWidget {
  const RecentPhotosViewerDemo({super.key});

  void _openPhotoViewer(BuildContext context, int initialIndex) {
    final userId = '123';
    final photos = MockUserProfile.getRecentPhotos(userId);
    final userInfo = MockUserProfile.getUserInfo(userId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecentPhotosViewerScreen(
          userId: userId,
          initialIndex: initialIndex,
          photos: photos,
          userName: userInfo['name'] as String,
          userAvatar: userInfo['avatar'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = MockUserProfile.getRecentPhotos('123');

    return Scaffold(
      backgroundColor: const Color(0xFFECE8E1),
      appBar: AppBar(
        title: const Text(
          'Recent Photos Demo',
          style: TextStyle(fontFamily: 'Inika'),
        ),
        backgroundColor: const Color(0xFFECE8E1),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _openPhotoViewer(context, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(photos[index].imageUrl, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
