import 'dart:ui';
import 'package:flutter/material.dart';
import 'widgets/viewer_header.dart';
import 'widgets/tinder_card_viewer.dart';

class RecentPhotosViewerScreen extends StatefulWidget {
  final String userId;
  final int initialIndex;
  final List<PhotoItem> photos;
  final String userName;
  final String userAvatar;

  const RecentPhotosViewerScreen({
    super.key,
    required this.userId,
    required this.initialIndex,
    required this.photos,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<RecentPhotosViewerScreen> createState() =>
      _RecentPhotosViewerScreenState();
}

class _RecentPhotosViewerScreenState extends State<RecentPhotosViewerScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPhoto = widget.photos[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Blurred backdrop
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Image.network(currentPhoto.imageUrl, fit: BoxFit.cover),
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 120)),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                ViewerHeader(
                  userName: widget.userName,
                  userAvatar: widget.userAvatar,
                  onClose: () => Navigator.pop(context),
                ),

                // Tinder card viewer
                Expanded(
                  child: ClipRect(
                    clipBehavior: Clip.none,
                    child: TinderCardViewer(
                      photos: widget.photos,
                      initialIndex: _currentIndex,
                      onIndexChanged: _onIndexChanged,
                    ),
                  ),
                ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(bottom: 180.0),
                  child: Text(
                    _formatTimestamp(currentPhoto.uploadedAt),
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 14,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Model class cho photo item
class PhotoItem {
  final String imageUrl;
  final DateTime uploadedAt;

  const PhotoItem({required this.imageUrl, required this.uploadedAt});
}
