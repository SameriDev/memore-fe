import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/photo_model.dart';

/// Friend Profile Screen
/// Displays friend's profile information and shared photos
class FriendProfileScreen extends ConsumerStatefulWidget {
  final String friendId;

  const FriendProfileScreen({
    required this.friendId,
    super.key,
  });

  @override
  ConsumerState<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends ConsumerState<FriendProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  UserModel? _friend;
  List<PhotoModel> _sharedPhotos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFriendData();
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

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadFriendData() async {
    // TODO: Load actual friend data from provider
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    setState(() {
      _friend = MockUsers.sampleFriends.firstWhere(
        (f) => f.id == widget.friendId,
        orElse: () => UserModel(
          id: widget.friendId,
          phoneNumber: '+1234567890',
          friendIds: [],
          settings: UserSettings.defaultSettings,
          createdAt: DateTime.now(),
          lastSeenAt: DateTime.now(),
          displayName: 'Friend',
          isOnline: false,
        ),
      );

      // Mock shared photos
      _sharedPhotos = List.generate(
        12,
        (index) => PhotoModel(
          id: 'photo_$index',
          senderId: widget.friendId,
          imageUrl: 'https://picsum.photos/200/300?random=$index',
          timestamp: DateTime.now().subtract(Duration(days: index)),
          recipientIds: [MockUsers.currentUser.id],
          status: PhotoStatus.delivered,
          viewedBy: {},
        ),
      );

      _isLoading = false;
    });
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
          _buildOptionItem(
            icon: Icons.message_outlined,
            title: 'Send Message',
            onTap: () {
              Navigator.pop(context);
              _sendMessage();
            },
          ),
          _buildOptionItem(
            icon: Icons.person_remove_outlined,
            title: 'Remove Friend',
            color: const Color(0xFFEF4444),
            onTap: () {
              Navigator.pop(context);
              _showRemoveFriendDialog();
            },
          ),
          _buildOptionItem(
            icon: Icons.block,
            title: 'Block User',
            color: const Color(0xFFEF4444),
            onTap: () {
              Navigator.pop(context);
              _showBlockUserDialog();
            },
          ),

          const SizedBox(height: AppSizes.spacingMd),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      leading: Icon(
        icon,
        color: color,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _sendMessage() {
    // TODO: Navigate to message screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Messaging feature coming soon'),
        backgroundColor: const Color(0xFF2A2A2A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showRemoveFriendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Remove Friend',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove ${_friend?.displayName ?? 'this friend'}? You won\'t be able to share photos with them anymore.',
          style: const TextStyle(
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
              _removeFriend();
            },
            child: const Text(
              'Remove',
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

  void _showBlockUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Block User',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to block ${_friend?.displayName ?? 'this user'}? They won\'t be able to contact you or share photos with you.',
          style: const TextStyle(
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
              _blockUser();
            },
            child: const Text(
              'Block',
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

  void _removeFriend() {
    // TODO: Implement remove friend functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend removed'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    context.pop();
  }

  void _blockUser() {
    // TODO: Implement block user functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User blocked'),
        backgroundColor: Color(0xFFEF4444),
      ),
    );
    context.pop();
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

    if (_friend == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000000),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'Friend not found',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF000000),
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
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

          // Profile Info
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProfileSection(),
            ),
          ),

          // Photos Grid Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Row(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFFFFD700),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Shared Photos (${_sharedPhotos.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Photos Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _slideAnimation.value * (index % 3) * 0.2),
                      child: child,
                    ),
                    child: _buildPhotoGridItem(_sharedPhotos[index], index),
                  );
                },
                childCount: _sharedPhotos.length,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spacingXl),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _getAvatarColor(),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getAvatarColor().withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _friend!.displayName?.substring(0, 1).toUpperCase() ?? 'F',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Name
          Text(
            _friend!.displayName ?? 'Friend',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSm),

          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _friend!.isOnline
                      ? const Color(0xFF00FF00)
                      : const Color(0xFF666666),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _friend!.isOnline ? 'Online' : 'Last seen recently',
                style: TextStyle(
                  color: _friend!.isOnline
                      ? const Color(0xFF00FF00)
                      : const Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingXl),

          // Action button
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              icon: const Icon(Icons.message, size: 18),
              label: const Text(
                'Send Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGridItem(PhotoModel photo, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to photo view
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            photo.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2A2A2A),
                child: const Icon(
                  Icons.image,
                  color: Color(0xFF666666),
                  size: 32,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    final colors = [
      const Color(0xFFFFD700), // Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
    ];
    final index = widget.friendId.hashCode % colors.length;
    return colors[index];
  }
}