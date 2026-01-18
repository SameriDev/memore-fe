import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/models/user_model.dart';

/// Time Travel Screen
/// Browse photos from different time periods like memories
class TimeTravelScreen extends ConsumerStatefulWidget {
  const TimeTravelScreen({super.key});

  @override
  ConsumerState<TimeTravelScreen> createState() => _TimeTravelScreenState();
}

class _TimeTravelScreenState extends ConsumerState<TimeTravelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  Map<String, List<PhotoModel>> _photosByPeriod = {};
  bool _isLoading = true;
  String _selectedPeriod = 'all';

  final List<String> _periods = [
    'all',
    'today',
    'yesterday',
    'thisWeek',
    'thisMonth',
    'older',
  ];

  final Map<String, String> _periodLabels = {
    'all': 'All Time',
    'today': 'Today',
    'yesterday': 'Yesterday',
    'thisWeek': 'This Week',
    'thisMonth': 'This Month',
    'older': 'Older',
  };

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

  Future<void> _loadPhotos() async {
    // TODO: Load actual photos from provider
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - organize photos by time period
    final allPhotos = MockPhotos.getAllPhotos();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekStart = today.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    setState(() {
      _photosByPeriod = {
        'all': allPhotos,
        'today': allPhotos.where((p) => p.timestamp.isAfter(today)).toList(),
        'yesterday': allPhotos.where((p) =>
          p.timestamp.isAfter(yesterday) && p.timestamp.isBefore(today)
        ).toList(),
        'thisWeek': allPhotos.where((p) =>
          p.timestamp.isAfter(weekStart) && p.timestamp.isBefore(yesterday)
        ).toList(),
        'thisMonth': allPhotos.where((p) =>
          p.timestamp.isAfter(monthStart) && p.timestamp.isBefore(weekStart)
        ).toList(),
        'older': allPhotos.where((p) => p.timestamp.isBefore(monthStart)).toList(),
      };
      _isLoading = false;
    });
  }

  void _navigateToPhotoView(String photoId) {
    context.push(
      '${AppRoutes.photoView}/$photoId?source=timetravel',
    );
  }

  void _showMemoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Time Travel Memories',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Relive your favorite moments! Memore automatically resurfaces photos from this day in previous years, helping you cherish memories that might otherwise be forgotten.',
          style: TextStyle(
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
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
          'Time Travel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 24,
            ),
            onPressed: _showMemoryDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Period selector
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
                  itemCount: _periods.length,
                  itemBuilder: (context, index) {
                    final period = _periods[index];
                    final isSelected = _selectedPeriod == period;

                    return AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(_slideAnimation.value * index * 2, 0),
                        child: child,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSizes.spacingSm),
                        child: FilterChip(
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedPeriod = period;
                            });
                          },
                          label: Text(
                            _periodLabels[period]!,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: const Color(0xFF2A2A2A),
                          selectedColor: const Color(0xFFFFD700),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF404040),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingSm,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFD700),
                        ),
                      )
                    : _buildPhotoContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoContent() {
    final photos = _photosByPeriod[_selectedPeriod] ?? [];

    if (photos.isEmpty) {
      return _buildEmptyState();
    }

    // Special layout for "all" view - show memories and recent
    if (_selectedPeriod == 'all') {
      return _buildAllTimeView();
    }

    // Grid view for specific periods
    return _buildPhotoGrid(photos);
  }

  Widget _buildAllTimeView() {
    final memories = MockPhotos.getTimeTravelPhotos(MockUsers.currentUser.id);
    final recent = MockPhotos.getRecentPhotos(MockUsers.currentUser.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memories section
          if (memories.isNotEmpty) ...[
            _buildSectionHeader(
              'Memories from the Past',
              icon: Icons.auto_awesome,
              iconColor: const Color(0xFFFFD700),
            ),
            const SizedBox(height: AppSizes.spacingMd),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  final photo = memories[index];
                  return AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _slideAnimation.value * index * 0.2),
                      child: child,
                    ),
                    child: _buildMemoryCard(photo),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.spacingXl),
          ],

          // Recent photos section
          _buildSectionHeader(
            'Recent Photos',
            icon: Icons.schedule,
            iconColor: const Color(0xFF666666),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: recent.length,
            itemBuilder: (context, index) {
              final photo = recent[index];
              return _buildPhotoTile(photo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon, Color? iconColor}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryCard(PhotoModel photo) {
    final sender = MockUsers.getUserById(photo.senderId);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: AppSizes.spacingMd),
      child: GestureDetector(
        onTap: () => _navigateToPhotoView(photo.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo container
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFD700),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      photo.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Icon(
                            Icons.image,
                            color: Color(0xFF666666),
                            size: 40,
                          ),
                        );
                      },
                    ),
                    // Memory overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                    // Memory badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.black,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getMemoryAge(photo.originalTimestamp!),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 8),
            // Info
            Text(
              sender?.displayName ?? 'Friend',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatMemoryDate(photo.originalTimestamp!),
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

  Widget _buildPhotoGrid(List<PhotoModel> photos) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _slideAnimation.value * (index % 3) * 0.1),
            child: child,
          ),
          child: _buildPhotoTile(photo),
        );
      },
    );
  }

  Widget _buildPhotoTile(PhotoModel photo) {
    return GestureDetector(
      onTap: () => _navigateToPhotoView(photo.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xFF2A2A2A),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
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
              // Date overlay for regular photos
              if (!photo.isFromTimeTravel)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatPhotoDate(photo.timestamp),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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
          // Icon with animation
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
                    color: Color(0xFF2A2A2A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF666666),
                    size: 48,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSizes.spacingLg),

          Text(
            'No Photos ${_periodLabels[_selectedPeriod]!}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingSm),

          const Text(
            'Photos from this time period\nwill appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getMemoryAge(DateTime originalDate) {
    final now = DateTime.now();
    final years = now.year - originalDate.year;
    if (years > 1) return '${years}y ago';
    if (years == 1) return '1 year';

    final months = now.month - originalDate.month + (years * 12);
    if (months > 1) return '${months}mo ago';

    final days = now.difference(originalDate).inDays;
    return '${days}d ago';
  }

  String _formatMemoryDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatPhotoDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d';

    return '${date.day}/${date.month}';
  }
}
