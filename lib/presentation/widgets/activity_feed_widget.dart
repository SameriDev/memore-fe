import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/activity_feed_manager.dart';

class ActivityFeedWidget extends StatefulWidget {
  final int itemsPerPage;
  final bool showHeader;
  final VoidCallback? onActivityTap;

  const ActivityFeedWidget({
    super.key,
    this.itemsPerPage = 20,
    this.showHeader = true,
    this.onActivityTap,
  });

  @override
  State<ActivityFeedWidget> createState() => _ActivityFeedWidgetState();
}

class _ActivityFeedWidgetState extends State<ActivityFeedWidget> {
  final _activityManager = ActivityFeedManager.instance;
  final _scrollController = ScrollController();

  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _scrollController.addListener(_onScroll);
  }

  void _loadActivities({bool loadMore = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final page = loadMore ? _currentPage + 1 : 0;
      final result = _activityManager.getActivityFeedPaginated(
        page: page,
        itemsPerPage: widget.itemsPerPage,
      );

      final newActivities = List<Map<String, dynamic>>.from(result['activities']);

      setState(() {
        if (loadMore) {
          _activities.addAll(newActivities);
          _currentPage = page;
        } else {
          _activities = newActivities;
          _currentPage = 0;
        }
        _hasMore = result['hasMore'] as bool;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoading) {
        _loadActivities(loadMore: true);
      }
    }
  }

  void _refreshFeed() {
    _loadActivities();
  }

  Future<void> _markAllAsRead() async {
    await _activityManager.markAllActivitiesAsRead();
    setState(() {
      for (var activity in _activities) {
        activity['isRead'] = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showHeader) _buildHeader(),
        Expanded(
          child: _activities.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async => _refreshFeed(),
                  color: const Color(0xFF8B4513),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _activities.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _activities.length) {
                        return _buildLoadingItem();
                      }
                      return _buildActivityItem(_activities[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final unreadCount = _activityManager.getUnreadActivitiesCount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Recent Activity',
            style: GoogleFonts.inika(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3E2723),
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                unreadCount.toString(),
                style: GoogleFonts.inika(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.inika(
                  color: const Color(0xFF8B4513),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          IconButton(
            onPressed: _refreshFeed,
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF8B4513),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No activities yet',
            style: GoogleFonts.inika(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activity from your friends will appear here',
            style: GoogleFonts.inika(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _refreshFeed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Refresh',
              style: GoogleFonts.inika(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final timestamp = DateTime.parse(activity['timestamp']);
    final timeAgo = _getTimeAgo(timestamp);
    final isRead = activity['isRead'] as bool? ?? false;
    final metadata = activity['metadata'] as Map<String, dynamic>? ?? {};

    return GestureDetector(
      onTap: () async {
        if (!isRead) {
          await _activityManager.markActivityAsRead(activity['id']);
          setState(() {
            activity['isRead'] = true;
          });
        }
        widget.onActivityTap?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: !isRead
              ? Border.all(
                  color: const Color(0xFF8B4513).withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isRead ? 0.05 : 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(activity['actorAvatar']),
                  backgroundColor: const Color(0xFF8B4513),
                ),
                if (!isRead)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message
                  Text(
                    activity['message'],
                    style: GoogleFonts.inika(
                      fontSize: 14,
                      color: const Color(0xFF3E2723),
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Timestamp
                  Text(
                    timeAgo,
                    style: GoogleFonts.inika(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  // Photo preview for photo activities
                  if (metadata['photoUrl'] != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(metadata['photoUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Activity type icon
            _buildActivityIcon(activity['type']),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(String activityType) {
    IconData icon;
    Color color;

    switch (activityType) {
      case 'photo_upload':
        icon = Icons.photo_camera;
        color = const Color(0xFF4CAF50);
        break;
      case 'photo_like':
        icon = Icons.favorite;
        color = const Color(0xFFE91E63);
        break;
      case 'photo_comment':
        icon = Icons.chat_bubble;
        color = const Color(0xFF2196F3);
        break;
      case 'friend_joined':
        icon = Icons.person_add;
        color = const Color(0xFF9C27B0);
        break;
      case 'album_created':
        icon = Icons.photo_album;
        color = const Color(0xFFFF9800);
        break;
      case 'friend_activity':
        icon = Icons.group;
        color = const Color(0xFF607D8B);
        break;
      default:
        icon = Icons.notifications;
        color = const Color(0xFF8B4513);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  final _activityManager = ActivityFeedManager.instance;

  @override
  void initState() {
    super.initState();
    // Start activity simulation when screen is opened
    _activityManager.startActivitySimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Activity Feed',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
        actions: [
          IconButton(
            onPressed: () {
              // Show activity summary bottom sheet
              _showActivitySummary();
            },
            icon: const Icon(Icons.analytics_outlined),
          ),
        ],
      ),
      body: const ActivityFeedWidget(),
    );
  }

  void _showActivitySummary() {
    final summary = _activityManager.getTodayActivitySummary();
    final activeFriends = _activityManager.getMostActiveFriends();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5DC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Activity Summary',
                  style: GoogleFonts.inika(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Today's activity
            Text(
              'Today\'s Activity',
              style: GoogleFonts.inika(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),

            if (summary.isEmpty)
              Text(
                'No activity today yet',
                style: GoogleFonts.inika(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            else
              ...summary.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${entry.value}',
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getActivityTypeLabel(entry.key),
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
              )),

            const SizedBox(height: 24),

            // Most active friends
            Text(
              'Most Active Friends',
              style: GoogleFonts.inika(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),

            if (activeFriends.isEmpty)
              Text(
                'No friend activity yet',
                style: GoogleFonts.inika(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            else
              ...activeFriends.map((friend) => ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(friend['avatarUrl']),
                  backgroundColor: const Color(0xFF8B4513),
                ),
                title: Text(
                  friend['name'],
                  style: GoogleFonts.inika(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3E2723),
                  ),
                ),
                trailing: Text(
                  '${friend['count']} activities',
                  style: GoogleFonts.inika(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              )),
          ],
        ),
      ),
    );
  }

  String _getActivityTypeLabel(String type) {
    switch (type) {
      case 'photo_upload':
        return 'photos uploaded';
      case 'photo_like':
        return 'likes given';
      case 'photo_comment':
        return 'comments made';
      case 'friend_joined':
        return 'friends joined';
      case 'album_created':
        return 'albums created';
      case 'friend_activity':
        return 'friend activities';
      default:
        return 'activities';
    }
  }
}