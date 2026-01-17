import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';

/// Storage Screen
/// Manages app storage and cache settings
class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;

  // Storage data
  double _totalStorage = 0;
  double _usedStorage = 0;
  double _photosSize = 0;
  double _cacheSize = 0;
  double _otherSize = 0;

  // Settings
  String _photoQuality = 'high';
  bool _autoDownload = true;
  bool _saveToCameraRoll = true;

  bool _isLoading = true;
  bool _isClearingCache = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadStorageInfo();
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

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadStorageInfo() async {
    // TODO: Load actual storage information
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      // Mock data in MB
      _totalStorage = 5120; // 5 GB
      _photosSize = 1843.2; // 1.8 GB
      _cacheSize = 256.7; // 256 MB
      _otherSize = 102.4; // 102 MB
      _usedStorage = _photosSize + _cacheSize + _otherSize;
      _isLoading = false;
    });
  }

  Future<void> _clearCache() async {
    setState(() {
      _isClearingCache = true;
    });

    // TODO: Implement actual cache clearing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _cacheSize = 0;
      _usedStorage = _photosSize + _otherSize;
      _isClearingCache = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared successfully'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Clear Cache',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will clear ${_formatSize(_cacheSize)} of cached data. Your photos and personal data will not be affected.',
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
              _clearCache();
            },
            child: const Text(
              'Clear',
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

  void _showPhotoQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Photo Quality',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQualityOption('high', 'High Quality', 'Best quality, uses more storage'),
            _buildQualityOption('medium', 'Medium Quality', 'Good quality, balanced storage'),
            _buildQualityOption('low', 'Low Quality', 'Lower quality, saves storage'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(String value, String label, String description) {
    final isSelected = _photoQuality == value;
    return InkWell(
      onTap: () {
        setState(() {
          _photoQuality = value;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF666666),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          'Storage',
          style: TextStyle(
            color: Colors.white,
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
                    color: Color(0xFFFFD700),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Storage overview
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_slideAnimation.value),
                          child: child,
                        ),
                        child: _buildStorageOverview(),
                      ),

                      const SizedBox(height: AppSizes.spacingLg),

                      // Storage breakdown
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_slideAnimation.value * 0.8),
                          child: child,
                        ),
                        child: _buildStorageBreakdown(),
                      ),

                      const SizedBox(height: AppSizes.spacingLg),

                      // Storage settings
                      const Text(
                        'Storage Settings',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: AppSizes.spacingMd),

                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_slideAnimation.value * 0.6),
                          child: child,
                        ),
                        child: _buildStorageSettings(),
                      ),

                      const SizedBox(height: AppSizes.spacingXl),

                      // Clear cache button
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_slideAnimation.value * 0.4),
                          child: child,
                        ),
                        child: _buildClearCacheButton(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStorageOverview() {
    final percentUsed = _usedStorage / _totalStorage;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Storage Usage',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(percentUsed * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentUsed * _progressAnimation.value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppSizes.spacingMd),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatSize(_usedStorage)} used',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
              Text(
                '${_formatSize(_totalStorage - _usedStorage)} free',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageBreakdown() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
        ),
      ),
      child: Column(
        children: [
          _buildStorageItem(
            icon: Icons.photo,
            label: 'Photos',
            size: _photosSize,
            color: const Color(0xFFFFD700),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          _buildStorageItem(
            icon: Icons.cached,
            label: 'Cache',
            size: _cacheSize,
            color: const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: AppSizes.spacingMd),
          _buildStorageItem(
            icon: Icons.storage,
            label: 'Other',
            size: _otherSize,
            color: const Color(0xFF06B6D4),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem({
    required IconData icon,
    required String label,
    required double size,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSizes.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatSize(size),
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageSettings() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Photo Quality',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              _getPhotoQualityText(),
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Color(0xFF666666),
              size: 24,
            ),
            onTap: _showPhotoQualityDialog,
          ),
          _buildDivider(),
          SwitchListTile(
            title: const Text(
              'Auto-Download',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Download photos automatically',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _autoDownload,
            onChanged: (value) {
              setState(() {
                _autoDownload = value;
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
          _buildDivider(),
          SwitchListTile(
            title: const Text(
              'Save to Camera Roll',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Save received photos to your gallery',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _saveToCameraRoll,
            onChanged: (value) {
              setState(() {
                _saveToCameraRoll = value;
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }

  Widget _buildClearCacheButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isClearingCache || _cacheSize == 0
            ? null
            : _showClearCacheDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          disabledBackgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isClearingCache
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                _cacheSize == 0
                    ? 'Cache is Empty'
                    : 'Clear Cache (${_formatSize(_cacheSize)})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFF404040).withValues(alpha: 0.3),
    );
  }

  String _formatSize(double sizeInMB) {
    if (sizeInMB < 1) {
      return '${(sizeInMB * 1024).toStringAsFixed(0)} KB';
    } else if (sizeInMB < 1024) {
      return '${sizeInMB.toStringAsFixed(1)} MB';
    } else {
      return '${(sizeInMB / 1024).toStringAsFixed(2)} GB';
    }
  }

  String _getPhotoQualityText() {
    switch (_photoQuality) {
      case 'high':
        return 'High Quality';
      case 'medium':
        return 'Medium Quality';
      case 'low':
        return 'Low Quality';
      default:
        return 'High Quality';
    }
  }
}