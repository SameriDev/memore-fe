import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/comment_bottom_sheet.dart';

/// Photo View Screen
/// Full screen photo viewer with pinch-to-zoom and swipe between photos
class PhotoViewScreen extends ConsumerStatefulWidget {
  final String photoId;
  final String? source; // 'feed', 'profile', 'timetravel'

  const PhotoViewScreen({
    required this.photoId,
    this.source,
    super.key,
  });

  @override
  ConsumerState<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends ConsumerState<PhotoViewScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _reactionAnimationController;
  late Animation<double> _reactionScale;

  PhotoModel? _currentPhoto;
  List<PhotoModel> _photos = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showDetails = true;
  late PageController _pageController;
  String? _userReaction;
  bool _hasLiked = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadPhotos();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _reactionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _reactionScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _reactionAnimationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reactionAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos() async {
    // TODO: Load actual photos from provider based on source
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    setState(() {
      _photos = MockPhotos.getAllPhotos();

      // Find initial photo index
      _currentIndex = _photos.indexWhere((p) => p.id == widget.photoId);
      if (_currentIndex == -1) _currentIndex = 0;

      _currentPhoto = _photos[_currentIndex];
      _pageController = PageController(initialPage: _currentIndex);
      _isLoading = false;
    });
  }

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  void _showReactionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildReactionBottomSheet(),
    );
  }

  Widget _buildReactionBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),

          const Text(
            'React to this photo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Reaction options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildReactionOption('❤️', 'Love'),
              _buildReactionOption('😂', 'Haha'),
              _buildReactionOption('😮', 'Wow'),
              _buildReactionOption('😢', 'Sad'),
              _buildReactionOption('👍', 'Like'),
            ],
          ),

          const SizedBox(height: AppSizes.spacingXl),
        ],
      ),
    );
  }

  Widget _buildReactionOption(String emoji, String label) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _sendReaction(emoji);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendReaction(String reaction) {
    setState(() {
      _userReaction = reaction;
      _hasLiked = true;
    });

    // Animate the reaction
    _reactionAnimationController.forward(from: 0.0);

    // Show animated reaction overlay
    _showReactionAnimation(reaction);

    // TODO: Send reaction to backend
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reacted with $reaction'),
            backgroundColor: const Color(0xFF2A2A2A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _showReactionAnimation(String reaction) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: ScaleTransition(
          scale: _reactionScale,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                reaction,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove overlay after animation
    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry?.remove();
    });
  }

  void _savePhoto() {
    // TODO: Implement photo saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo saved to gallery'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _sharePhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildShareBottomSheet(),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(
        photoId: _currentPhoto?.id ?? '',
        onClose: () {
          // Refresh photo view if needed
        },
      ),
    );
  }

  Widget _buildShareBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),

          const Text(
            'Share Photo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Share options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(
                icon: Icons.people_outline,
                label: 'Friends',
                onTap: () {
                  Navigator.pop(context);
                  _shareToFriends();
                },
              ),
              _buildShareOption(
                icon: Icons.copy,
                label: 'Copy',
                onTap: () {
                  Navigator.pop(context);
                  _copyPhotoLink();
                },
              ),
              _buildShareOption(
                icon: Icons.share_outlined,
                label: 'More',
                onTap: () {
                  Navigator.pop(context);
                  _shareToOtherApps();
                },
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingXl),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF404040),
                ),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFFD700),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareToFriends() {
    // Navigate to friend selection screen for sharing
    context.push(
      '/camera/friend-select?photoPath=${_currentPhoto?.imageUrl}&isSharing=true',
    );
  }

  void _copyPhotoLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo link copied to clipboard'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _shareToOtherApps() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening share menu...'),
        backgroundColor: Color(0xFF2A2A2A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFD700),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Photo gallery
            GestureDetector(
              onTap: _toggleDetails,
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _photos.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _currentPhoto = _photos[index];
                  });
                },
                itemBuilder: (context, index) {
                  final photo = _photos[index];
                  return InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: Hero(
                        tag: photo.id,
                        child: Image.asset(
                          photo.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF2A2A2A),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Color(0xFF666666),
                                  size: 64,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top overlay with details
            if (_showDetails)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Row(
                        children: [
                          // Back button
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => context.pop(),
                          ),

                          // User info
                          Expanded(
                            child: _buildUserInfo(),
                          ),

                          // Options button
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: _showOptionsMenu,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom overlay with actions
            if (_showDetails)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Music info if available
                        if (_currentPhoto?.hasMusic == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMd,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  color: Color(0xFFFFD700),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentPhoto!.musicInfo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: AppSizes.spacingSm),

                        // User reaction display
                        if (_userReaction != null)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'You reacted ',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _userReaction!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: AppSizes.spacingSm),

                        // Action buttons
                        Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: _hasLiked ? Icons.favorite : Icons.favorite_border,
                                onTap: _showReactionMenu,
                                color: _hasLiked ? const Color(0xFFEF4444) : null,
                              ),
                              _buildActionButton(
                                icon: Icons.comment_outlined,
                                onTap: _showComments,
                              ),
                              _buildActionButton(
                                icon: Icons.download_outlined,
                                onTap: _savePhoto,
                              ),
                              _buildActionButton(
                                icon: Icons.share_outlined,
                                onTap: _sharePhoto,
                              ),
                            ],
                          ),
                        ),

                        // Page indicators
                        if (_photos.length > 1)
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _photos.length,
                                  (index) => Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      color: index == _currentIndex
                                          ? const Color(0xFFFFD700)
                                          : const Color(0xFF666666),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final sender = MockUsers.getUserById(_currentPhoto!.senderId);
    if (sender == null) return const SizedBox();

    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 18,
          backgroundColor: _getAvatarColor(sender.id),
          child: Text(
            sender.displayName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: AppSizes.spacingSm),

        // Name and time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sender.displayName ?? 'Friend',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _getTimeAgo(_currentPhoto!.timestamp),
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A).withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color ?? Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOptionsBottomSheet(),
    );
  }

  Widget _buildOptionsBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),

          // Options
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 24,
            ),
            title: const Text(
              'Photo Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showPhotoDetails();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.flag_outlined,
              color: Colors.white,
              size: 24,
            ),
            title: const Text(
              'Report Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _reportPhoto();
            },
          ),
          if (_currentPhoto?.senderId == MockUsers.currentUser.id)
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF4444),
                size: 24,
              ),
              title: const Text(
                'Delete Photo',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _deletePhoto();
              },
            ),

          const SizedBox(height: AppSizes.spacingMd),
        ],
      ),
    );
  }

  void _showPhotoDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Photo Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Sent', _formatDate(_currentPhoto!.timestamp)),
            if (_currentPhoto!.viewedBy.isNotEmpty)
              _buildDetailRow(
                'Viewed by',
                '${_currentPhoto!.viewedBy.length} friends',
              ),
            if (_currentPhoto!.isFromTimeTravel)
              _buildDetailRow(
                'Original date',
                _formatDate(_currentPhoto!.originalTimestamp!),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _reportPhoto() {
    // TODO: Implement report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo reported'),
        backgroundColor: Color(0xFF2A2A2A),
      ),
    );
  }

  void _deletePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Delete Photo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this photo? This action cannot be undone.',
          style: TextStyle(
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement deletion
              context.pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getAvatarColor(String id) {
    final colors = [
      const Color(0xFFFFD700), // Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
    ];
    final index = id.hashCode % colors.length;
    return colors[index];
  }
}