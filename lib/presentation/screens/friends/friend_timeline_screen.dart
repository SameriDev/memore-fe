import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../widgets/app_popup.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/data_sources/remote/user_service.dart';
import '../../../data/models/user_dto.dart';
import '../../../domain/entities/friend.dart';
import '../../../domain/entities/timeline_photo.dart';
import 'widgets/timeline_header.dart';
import 'widgets/timeline_photo_card.dart';
import 'widgets/timeline_background_decoration.dart';

class FriendTimelineScreen extends StatefulWidget {
  final Friend friend;

  const FriendTimelineScreen({super.key, required this.friend});

  @override
  State<FriendTimelineScreen> createState() => _FriendTimelineScreenState();
}

class _FriendTimelineScreenState extends State<FriendTimelineScreen> {
  // Enhanced timeline management
  List<PhotoTimelineDto> _timelinePhotos = [];
  List<TimelinePhoto> _displayPhotos = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMorePhotos = true;
  UserDto? _userProfile;

  // Pagination
  int _currentPage = 0;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  // Performance tracking
  int _totalPhotosLoaded = 0;
  final Stopwatch _loadStopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _loadInitialData();
    _preloadFriendTimeline();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 500 &&
          !_isLoadingMore &&
          _hasMorePhotos) {
        _loadMorePhotos();
      }
    });
  }

  Future<void> _loadInitialData() async {
    debugPrint('🔄 Loading initial timeline data cho friend: ${widget.friend.name}');
    _loadStopwatch.start();

    // Load user profile và photos song song
    await Future.wait([
      _loadUserProfile(),
      _loadTimelinePhotos(refresh: true),
    ]);

    _loadStopwatch.stop();
    debugPrint('⚡ Initial load completed trong ${_loadStopwatch.elapsedMilliseconds}ms');
  }

  Future<void> _preloadFriendTimeline() async {
    try {
      debugPrint('🚀 Starting preload cho friend: ${widget.friend.name} (${widget.friend.id})');
      await PhotoService.instance.preloadFriendTimeline(widget.friend.id);
      debugPrint('✅ Preload completed cho friend: ${widget.friend.name}');
    } catch (e) {
      debugPrint('❌ Preload failed cho friend: ${widget.friend.name} - Error: $e');
      // Preload failure shouldn't block the UI
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await UserService.instance.getUserById(widget.friend.id);
      if (mounted) {
        setState(() => _userProfile = user);
      }
    } catch (e) {
      debugPrint('❌ Load user profile error: $e');
    }
  }

  Future<void> _loadTimelinePhotos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMorePhotos = true;
      setState(() => _isLoading = true);
    } else {
      setState(() => _isLoadingMore = true);
    }

    try {
      // Check quyền xem timeline trước
      final canView = await PhotoService.instance.canViewFriendTimeline(widget.friend.id);
      if (!canView) {
        debugPrint('❌ Không có quyền xem timeline của ${widget.friend.name}');
        _setErrorState('Bạn không có quyền xem timeline này');
        return;
      }

      // Load timeline photos với enhanced PhotoService
      final photos = await PhotoService.instance.getFriendTimelinePhotos(
        widget.friend.id,
        page: _currentPage,
        size: _pageSize,
      );

      if (photos.length < _pageSize) {
        _hasMorePhotos = false;
      }

      if (mounted) {
        setState(() {
          if (refresh) {
            _timelinePhotos = photos;
          } else {
            _timelinePhotos.addAll(photos);
          }

          // Regroup toàn bộ ảnh theo ngày sau mỗi lần load
          _displayPhotos = _groupPhotosByDate(_timelinePhotos);
          _totalPhotosLoaded = _timelinePhotos.length;
          _isLoading = false;
          _isLoadingMore = false;
          _currentPage++;
        });

        debugPrint('📸 Loaded ${photos.length} photos (Total: $_totalPhotosLoaded)');
      }
    } catch (e) {
      debugPrint('❌ Load timeline photos error: $e');
      _setErrorState('Lỗi khi tải timeline');
    }
  }

  Future<void> _loadMorePhotos() async {
    if (!_hasMorePhotos || _isLoadingMore) return;
    debugPrint('📄 Loading more photos - page $_currentPage');
    await _loadTimelinePhotos();
  }

  List<TimelinePhoto> _groupPhotosByDate(List<PhotoTimelineDto> photos) {
    final Map<String, List<PhotoTimelineDto>> groups = {};
    for (final photo in photos) {
      final dt = photo.createdAt;
      final key =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(photo);
    }

    // Sắp xếp ngày mới nhất lên đầu
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return sortedKeys.map((dateKey) {
      final dayPhotos = groups[dateKey]!;
      final dt = DateTime.parse(dateKey);
      return TimelinePhoto(
        id: dayPhotos.first.id,
        imageUrls: dayPhotos.map((p) => p.displayUrl).toList(),
        time: _formatDate(dt),
        season: '${dayPhotos.length} ảnh',
        description: dayPhotos.first.caption ?? '',
      );
    }).toList();
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  void _setErrorState(String message) {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _onMenuTap() {
    showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.small,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block),
              title: Text('Chặn người dùng', style: GoogleFonts.inika()),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: Text('Báo cáo', style: GoogleFonts.inika()),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const TimelineBackgroundDecoration(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _displayPhotos.isEmpty
                  ? _buildEmptyState()
                  : _buildTimelineContent(),
          Positioned(
            right: 29,
            top: -500,
            height: 2000,
            child: Container(width: 2, color: const Color(0xFF464646)),
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
          TimelineHeader(
            name: _userProfile?.name ?? widget.friend.name,
            avatarUrl: _userProfile?.avatarUrl ?? widget.friend.avatarUrl,
            isOnline: _userProfile?.isOnline ?? widget.friend.isOnline,
            onMenuTap: _onMenuTap,
            username: _userProfile?.username,
            friendsCount: _userProfile?.friendsCount,
            imagesCount: _userProfile?.imagesCount,
          ),
          const SizedBox(height: 60),
          const Icon(Icons.photo_library_outlined,
              size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No photos yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Timeline Header
          TimelineHeader(
            name: _userProfile?.name ?? widget.friend.name,
            avatarUrl: _userProfile?.avatarUrl ?? widget.friend.avatarUrl,
            isOnline: _userProfile?.isOnline ?? widget.friend.isOnline,
            onMenuTap: _onMenuTap,
            username: _userProfile?.username,
            friendsCount: _userProfile?.friendsCount,
            imagesCount: _userProfile?.imagesCount,
          ),
          const SizedBox(height: 20),

          // Performance info (debug only)
          if (mounted && _totalPhotosLoaded > 0)
            _buildDebugInfo(),

          // Timeline Photos
          ..._displayPhotos.asMap().entries.map((entry) {
            return TimelinePhotoCard(
              photo: entry.value,
              index: entry.key,
            );
          }),

          // Load more indicator
          if (_isLoadingMore) _buildLoadMoreIndicator(),

          // End of timeline indicator
          if (!_hasMorePhotos && _displayPhotos.isNotEmpty)
            _buildEndOfTimelineIndicator(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDebugInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '📊 $_totalPhotosLoaded photos loaded | Page $_currentPage',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text(
            'Loading more photos...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndOfTimelineIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
            size: 32,
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'ve seen all photos',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$_totalPhotosLoaded total photos',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _onRefresh() async {
    debugPrint('🔄 Refreshing friend timeline');
    await _loadTimelinePhotos(refresh: true);

    // Print cache statistics
    final stats = PhotoService.instance.getCacheStatistics();
    debugPrint('📊 Cache Stats: ${stats['hitRatioPercentage']} hit ratio, ${stats['cacheSize']} entries');
  }
}
