import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

/// Friend Select Screen
/// Allows users to select friends to share their photo with
class FriendSelectScreen extends ConsumerStatefulWidget {
  final String photoPath;
  final String? caption;

  const FriendSelectScreen({
    required this.photoPath,
    this.caption,
    super.key,
  });

  @override
  ConsumerState<FriendSelectScreen> createState() => _FriendSelectScreenState();
}

class _FriendSelectScreenState extends ConsumerState<FriendSelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<UserModel> _friends = [];
  List<UserModel> _filteredFriends = [];
  final Set<String> _selectedFriendIds = {};
  bool _isLoading = false;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFriends();
    _searchController.addListener(_onSearchChanged);
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadFriends() {
    // TODO: Load actual friends from provider
    // For now, use mock data
    setState(() {
      _friends = MockUsers.sampleFriends;
      _filteredFriends = _friends;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFriends = _friends;
      } else {
        _filteredFriends = _friends
            .where((friend) =>
                friend.displayName?.toLowerCase().contains(query) == true)
            .toList();
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedFriendIds.addAll(_friends.map((f) => f.id));
      } else {
        _selectedFriendIds.clear();
      }
    });
  }

  void _toggleFriendSelection(String friendId) {
    setState(() {
      if (_selectedFriendIds.contains(friendId)) {
        _selectedFriendIds.remove(friendId);
        _selectAll = false;
      } else {
        _selectedFriendIds.add(friendId);
        if (_selectedFriendIds.length == _friends.length) {
          _selectAll = true;
        }
      }
    });
  }

  Future<void> _sendPhoto() async {
    if (_selectedFriendIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one friend'),
          backgroundColor: AppColors.darkSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual photo sending
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Navigate to home
      context.go(AppRoutes.home);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Photo sent to ${_selectedFriendIds.length} friend${_selectedFriendIds.length > 1 ? 's' : ''}!',
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Select Friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _selectAll ? 'Deselect All' : 'Select All',
              style: const TextStyle(
                color: AppColors.accentGold,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMd),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _searchFocusNode.hasFocus
                          ? AppColors.accentGold
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search friends...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // Selected count
              if (_selectedFriendIds.isNotEmpty)
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value),
                    child: child,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    color: AppColors.darkSurface,
                    child: Text(
                      '${_selectedFriendIds.length} friend${_selectedFriendIds.length > 1 ? 's' : ''} selected',
                      style: const TextStyle(
                        color: AppColors.accentGold,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Friends list
              Expanded(
                child: _filteredFriends.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingMd,
                          vertical: AppSizes.paddingSm,
                        ),
                        itemCount: _filteredFriends.length,
                        itemBuilder: (context, index) {
                          final friend = _filteredFriends[index];
                          final isSelected = _selectedFriendIds.contains(friend.id);

                          return AnimatedBuilder(
                            animation: _slideAnimation,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, _slideAnimation.value * (index + 1) * 0.1),
                              child: child,
                            ),
                            child: _buildFriendTile(friend, isSelected),
                          );
                        },
                      ),
              ),

              // Send button
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading || _selectedFriendIds.isEmpty
                          ? null
                          : _sendPhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: AppColors.accentGold.withValues(alpha: 0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Send Photo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person_search,
              color: AppColors.textSecondary,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          const Text(
            'No friends found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          const Text(
            'Try searching with a different name',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(UserModel friend, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSm),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accentGold.withValues(alpha: 0.1)
            : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.accentGold
              : AppColors.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingSm,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _getAvatarColor(friend.id),
              child: Text(
                friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          friend.displayName ?? 'Friend',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          friend.isOnline ? 'Online' : 'Offline',
          style: TextStyle(
            color: friend.isOnline
                ? AppColors.friendOnline
                : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () => _toggleFriendSelection(friend.id),
      ),
    );
  }

  Color _getAvatarColor(String id) {
    final colors = [
      AppColors.accentGold, // Brown-gold
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