import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/models/user_model.dart';

/// Photo Feed Screen for displaying shared photos
/// Shows recent photos from friends with interactive elements matching Locket design
class PhotoFeedScreen extends ConsumerStatefulWidget {
  const PhotoFeedScreen({super.key});

  @override
  ConsumerState<PhotoFeedScreen> createState() => _PhotoFeedScreenState();
}

class _PhotoFeedScreenState extends ConsumerState<PhotoFeedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heartAnimation;

  final PageController _pageController = PageController();
  int _currentPhotoIndex = 0;

  // Mock photos data
  final List<PhotoFeedItem> _mockPhotos = [
    PhotoFeedItem(
      id: 'photo_001',
      senderName: 'Danny',
      senderProfileColor: const Color(0xFF8B5CF6),
      timeAgo: '1m',
      imageUrl: 'assets/images/sample_photo_1.jpg',
      reactions: ['🧡', '🔥', '😍', '⚡'],
      timestamp: '3:58 PM',
      isLiked: false,
    ),
    PhotoFeedItem(
      id: 'photo_002',
      senderName: 'Sarah',
      senderProfileColor: const Color(0xFF10B981),
      timeAgo: '5m',
      imageUrl: 'assets/images/sample_photo_2.jpg',
      reactions: ['🧡', '🔥', '😍'],
      timestamp: '3:54 PM',
      isLiked: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      _mockPhotos[index].isLiked = !_mockPhotos[index].isLiked;
    });

    // Animate heart
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _openCamera() {
    context.push('/camera');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopBar(),

            // Main photo feed content
            Expanded(
              child: _mockPhotos.isNotEmpty
                ? _buildPhotoFeed()
                : _buildEmptyState(),
            ),

            // Bottom navigation with camera button
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF404040)),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20,
            ),
          ),

          // Filter dropdown
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingXs,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Everyone',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),

          // Messages button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.message_outlined,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoFeed() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPhotoIndex = index;
        });
      },
      itemCount: _mockPhotos.length,
      itemBuilder: (context, index) {
        final photo = _mockPhotos[index];
        return _buildPhotoCard(photo, index);
      },
    );
  }

  Widget _buildPhotoCard(PhotoFeedItem photo, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: Column(
        children: [
          // Photo container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF2A2A2A),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Photo placeholder (would be actual image)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            photo.senderProfileColor.withOpacity(0.3),
                            photo.senderProfileColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white38,
                          size: 64,
                        ),
                      ),
                    ),

                    // Floating hearts animation
                    ...List.generate(8, (i) => _buildFloatingHeart(i)),

                    // Timestamp overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              photo.timestamp,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Sender info
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: photo.senderProfileColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    photo.senderName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                photo.senderName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                photo.timeAgo,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Reaction bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingXs,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Send message...',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
                ...photo.reactions.map((emoji) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(emoji, style: const TextStyle(fontSize: 16)),
                )),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),
        ],
      ),
    );
  }

  Widget _buildFloatingHeart(int index) {
    final hearts = ['🧡', '💛', '🧡', '💛', '🧡', '💛', '🧡', '💛'];
    final positions = [
      const Offset(0.2, 0.3),
      const Offset(0.8, 0.2),
      const Offset(0.1, 0.7),
      const Offset(0.9, 0.6),
      const Offset(0.3, 0.5),
      const Offset(0.7, 0.8),
      const Offset(0.5, 0.2),
      const Offset(0.6, 0.9),
    ];

    return Positioned(
      left: MediaQuery.of(context).size.width * positions[index].dx,
      top: MediaQuery.of(context).size.height * positions[index].dy,
      child: Text(
        hearts[index],
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            color: Color(0xFF666666),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No photos yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Share your first photo\nwith friends',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Grid view button
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          // Camera capture button
          GestureDetector(
            onTap: _openCamera,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFD700),
                  width: 4,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Share/Upload button
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.upload,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

/// Model for photo feed items
class PhotoFeedItem {
  final String id;
  final String senderName;
  final Color senderProfileColor;
  final String timeAgo;
  final String imageUrl;
  final List<String> reactions;
  final String timestamp;
  bool isLiked;

  PhotoFeedItem({
    required this.id,
    required this.senderName,
    required this.senderProfileColor,
    required this.timeAgo,
    required this.imageUrl,
    required this.reactions,
    required this.timestamp,
    required this.isLiked,
  });
}