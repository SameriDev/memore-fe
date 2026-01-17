import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

/// Enhanced Friends List Screen for managing friends
/// Shows all friends with their status, search functionality, and friend management
class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({super.key});

  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
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
          'Friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.addFriend);
            },
            icon: const Icon(
              Icons.person_add_outlined,
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search section
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _searchFocusNode.hasFocus
                            ? const Color(0xFFFFD700)
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
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF666666),
                          size: 20,
                        ),
                        suffixIcon: _isSearching
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF666666),
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
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (_isSearching)
                        Text(
                          'Search results',
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
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
                        return _buildEnhancedFriendTile(friend, index);
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
        backgroundColor: const Color(0xFFFFD700),
        elevation: 8,
        child: const Icon(
          Icons.person_add,
          color: Colors.black,
          size: 28,
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
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person_search,
              color: Color(0xFF666666),
              size: 40,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          Text(
            _isSearching ? 'No friends found' : 'No friends yet',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSm),

          Text(
            _isSearching
                ? 'Try searching with a different name'
                : 'Add friends to see them here',
            style: const TextStyle(
              color: Color(0xFF666666),
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
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
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

  Widget _buildEnhancedFriendTile(UserModel friend, int index) {
    final isOnline = index % 3 == 0; // Mock online status pattern
    final lastSeen = isOnline
        ? 'Online'
        : index % 2 == 0
            ? '2 hours ago'
            : 'Yesterday';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSm),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
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
              radius: 26,
              backgroundColor: _getAvatarColor(index),
              child: Text(
                friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
                style: const TextStyle(
                  color: Colors.black,
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
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF00),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF000000),
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
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          lastSeen,
          style: TextStyle(
            color: isOnline
                ? const Color(0xFF00FF00)
                : const Color(0xFF666666),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message button
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.message_outlined,
                  color: Color(0xFFFFD700),
                  size: 18,
                ),
                onPressed: () {
                  // Handle message action
                },
              ),
            ),
            const SizedBox(width: AppSizes.spacingSm),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF666666),
              size: 20,
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
      const Color(0xFFFFD700), // Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
    ];
    return colors[index % colors.length];
  }
}