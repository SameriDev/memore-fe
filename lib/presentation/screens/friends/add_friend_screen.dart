import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/friend_model.dart';

/// Add Friend Screen for discovering and adding new friends
/// Features username search, suggested friends, and friend requests
class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _searchController.addListener(_onSearchChanged);
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
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
    final query = _searchController.text.trim();
    if (query.length >= 2) {
      setState(() {
        _isLoading = true;
        _isSearching = true;
      });

      // Simulate search delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _searchResults = _performSearch(query);
            _isLoading = false;
          });
        }
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _performSearch(String query) {
    // Mock search results
    return [
      {
        'id': 'search_result_001',
        'displayName': 'Danny D',
        'phoneNumber': '+1555987654',
        'profilePicture': null,
        'mutualFriends': 2,
      },
      {
        'id': 'search_result_002',
        'displayName': 'Alex M',
        'phoneNumber': '+1555123456',
        'profilePicture': null,
        'mutualFriends': 0,
      },
    ].where((user) =>
        (user['displayName'] as String).toLowerCase().contains(query.toLowerCase()) ||
        (user['phoneNumber'] as String).contains(query)).toList();
  }

  void _sendFriendRequest(Map<String, dynamic> user) {
    // Mock friend request action
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Friend Request Sent!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Friend request sent to ${user['displayName']}',
          style: const TextStyle(
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
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
          'Add Friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search section
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Container(
                    height: 48,
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
                        hintText: 'Search by username...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF666666),
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
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

                  // Search tips
                  if (!_isSearching)
                    const Text(
                      'Search for friends by their username',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Search results or suggestions
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFD700),
          strokeWidth: 2,
        ),
      );
    }

    if (_isSearching) {
      return _buildSearchResults();
    }

    return _buildSuggestedFriends();
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
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

            const Text(
              'No users found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: AppSizes.spacingSm),

            const Text(
              'Try searching with a different username',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildSuggestedFriends() {
    final suggestions = [
      {
        'id': 'suggestion_001',
        'displayName': 'Sarah K',
        'phoneNumber': '+1555987654',
        'mutualFriends': 3,
        'profilePicture': null,
      },
      {
        'id': 'suggestion_002',
        'displayName': 'Mike T',
        'phoneNumber': '+1555456789',
        'mutualFriends': 1,
        'profilePicture': null,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggested friends header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Text(
            'Suggested Friends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spacingMd),

        // Suggestions list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final user = suggestions[index];
              return _buildUserTile(user, isSuggestion: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user, {bool isSuggestion = false}) {
    final mutualFriends = user['mutualFriends'] as int? ?? 0;

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
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: _getAvatarColor(user['id'].hashCode),
          child: Text(
            (user['displayName'] as String).substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user['displayName'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSuggestion && mutualFriends > 0) ...[
              Text(
                '$mutualFriends mutual friend${mutualFriends > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
              ),
            ] else ...[
              Text(
                user['phoneNumber'] as String,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _sendFriendRequest(user),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Add',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(int hashCode) {
    final colors = [
      const Color(0xFFFFD700), // Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
    ];
    return colors[hashCode.abs() % colors.length];
  }
}