import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/user_model.dart';

/// Friend Requests Screen
/// Displays pending friend requests with accept/decline options
class FriendRequestsScreen extends ConsumerStatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  ConsumerState<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends ConsumerState<FriendRequestsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  List<FriendRequest> _pendingRequests = [];
  bool _isLoading = true;
  final Map<String, bool> _processingRequests = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFriendRequests();
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

  Future<void> _loadFriendRequests() async {
    // TODO: Load actual friend requests from provider
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    setState(() {
      _pendingRequests = List.generate(
        5,
        (index) => FriendRequest(
          id: 'request_$index',
          from: UserModel(
            id: 'user_req_$index',
            phoneNumber: '+1555000${1000 + index}',
            displayName: 'New Friend ${index + 1}',
            friendIds: [],
            settings: UserSettings.defaultSettings,
            createdAt: DateTime.now().subtract(Duration(days: index + 1)),
            isOnline: index % 2 == 0,
          ),
          timestamp: DateTime.now().subtract(Duration(hours: index * 3 + 1)),
          message: index % 2 == 0
              ? 'Hey! I found you on Memore. Let\'s share photos!'
              : null,
        ),
      );
      _isLoading = false;
    });
  }

  Future<void> _handleRequest(String requestId, bool accept) async {
    setState(() {
      _processingRequests[requestId] = true;
    });

    // TODO: Implement actual request handling
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _pendingRequests.removeWhere((req) => req.id == requestId);
        _processingRequests.remove(requestId);
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept ? 'Friend request accepted!' : 'Friend request declined',
          ),
          backgroundColor: accept
              ? AppColors.success
              : AppColors.darkSurface,
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
            color: AppColors.darkOnBackground,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Friend Requests',
          style: TextStyle(
            color: AppColors.darkOnBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentGold,
                  ),
                )
              : _pendingRequests.isEmpty
                  ? _buildEmptyState()
                  : _buildRequestsList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animated scale
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.darkSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_disabled,
                    color: AppColors.textSecondary,
                    size: 48,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSizes.spacingLg),

          const Text(
            'No Friend Requests',
            style: TextStyle(
              color: AppColors.darkOnBackground,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSm),

          const Text(
            'When someone wants to add you,\ntheir request will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSizes.spacingXl),

          // Share code button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.textSecondary,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.share_outlined,
                  color: AppColors.accentGold,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Share your code',
                  style: TextStyle(
                    color: AppColors.darkOnBackground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    return RefreshIndicator(
      onRefresh: _loadFriendRequests,
      color: AppColors.accentGold,
      backgroundColor: AppColors.darkSurface,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        itemCount: _pendingRequests.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacingLg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_pendingRequests.length}',
                      style: const TextStyle(
                        color: AppColors.darkBackground,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Pending Requests',
                    style: TextStyle(
                      color: AppColors.darkOnBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          final request = _pendingRequests[index - 1];
          return AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _slideAnimation.value * index * 0.1),
              child: child,
            ),
            child: _buildRequestCard(request),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(FriendRequest request) {
    final isProcessing = _processingRequests[request.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(request.from.id),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      request.from.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: AppColors.darkBackground,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.spacingMd),

                // Name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.from.displayName ?? 'New Friend',
                        style: const TextStyle(
                          color: AppColors.darkOnBackground,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTimeAgo(request.timestamp),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Online indicator
                if (request.from.isOnline)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.friendOnline,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),

            // Message if available
            if (request.message != null) ...[
              const SizedBox(height: AppSizes.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.message!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSizes.spacingMd),

            // Action buttons
            Row(
              children: [
                // Decline button
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: isProcessing
                          ? null
                          : () => _handleRequest(request.id, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(
                          color: AppColors.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.spacingSm),

                // Accept button
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () => _handleRequest(request.id, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        foregroundColor: AppColors.darkBackground,
                        disabledBackgroundColor: AppColors.accentGold.withValues(alpha: 0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.darkBackground,
                                ),
                              ),
                            )
                          : const Text(
                              'Accept',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  Color _getAvatarColor(String id) {
    final colors = [
      AppColors.accentGold, // Brown-gold
      AppColors.primary, // SaddleBrown
      AppColors.primaryVariant, // Sienna
      AppColors.primaryLight, // Peru
      AppColors.primaryDark, // DarkBrown
      AppColors.textSecondary, // Medium brown
    ];
    final index = id.hashCode % colors.length;
    return colors[index];
  }
}

/// Model for friend request
class FriendRequest {
  final String id;
  final UserModel from;
  final DateTime timestamp;
  final String? message;

  const FriendRequest({
    required this.id,
    required this.from,
    required this.timestamp,
    this.message,
  });
}