import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

/// Modern Friends List Screen for managing friends
/// Shows all friends with their status, search functionality, and friend management
class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({super.key});

  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<UserModel> _filteredFriends = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _filteredFriends = MockUsers.sampleFriends;
    _searchController.addListener(_onSearchChanged);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFriends = MockUsers.sampleFriends;
        _isSearching = false;
      } else {
        _filteredFriends = MockUsers.sampleFriends
            .where((friend) =>
                friend.displayName?.toLowerCase().contains(query) == true)
            .toList();
        _isSearching = true;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _filteredFriends = MockUsers.sampleFriends;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Friends',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.addFriend);
            },
            icon: Icon(
              Icons.person_add_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Search section
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      border: Border.all(
                        color: _searchFocusNode.hasFocus
                            ? AppColors.primary
                            : AppColors.outline,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        hintStyle: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        suffixIcon: _isSearching
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: _clearSearch,
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingMd),

                  // Friends count and status
                  Row(
                    children: [
                      Text(
                        '${_filteredFriends.length} friends',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (_isSearching)
                        Text(
                          'Search results',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Friends list
            Expanded(
              child: _filteredFriends.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                      ),
                      itemCount: _filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = _filteredFriends[index];
                        return _buildModernFriendTile(friend, index);
                      },
                    ),
            ),
          ],
        ),
      ),

      // Floating add friend button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.addFriend);
        },
        backgroundColor: AppColors.primary,
        elevation: 8,
        child: const Icon(
          Icons.person_add,
          color: AppColors.onPrimary,
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.outline,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.person_search,
              color: AppColors.onSurfaceVariant,
              size: 40,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          Text(
            _isSearching ? 'No friends found' : 'No friends yet',
            style: TextStyle(
              color: AppColors.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSm),

          Text(
            _isSearching
                ? 'Try searching with a different name'
                : 'Add friends to see them here',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: AppSizes.spacingXl),

          if (!_isSearching)
            ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.addFriend);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Add Friends',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernFriendTile(UserModel friend, int index) {
    final isOnline = index % 3 == 0; // Mock online status pattern
    final lastSeen = isOnline
        ? 'Online'
        : index % 2 == 0
            ? '2 hours ago'
            : 'Yesterday';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black25,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingSm,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: _getAvatarColor(index),
              child: Text(
                friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Online indicator
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.friendOnline,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          friend.displayName ?? 'Friend',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          lastSeen,
          style: TextStyle(
            color: isOnline
                ? AppColors.friendOnline
                : AppColors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.message_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
                onPressed: () {
                  // Handle message action
                },
              ),
            ),
            const SizedBox(width: AppSizes.spacingSm),
            Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
        onTap: () {
          context.push('${AppRoutes.friends}/profile?friendId=${friend.id}');
        },
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.primary, // Blue
      AppColors.primaryVariant, // Blue 700
      AppColors.primaryLight, // Blue 100
      AppColors.accentBlue, // Teal accent
      AppColors.warning, // Amber
      AppColors.success, // Green
    ];
    return colors[index % colors.length].withOpacity(0.8);
  }
}