import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Full-screen camera interface matching memore design
/// Features camera preview, controls, and capture functionality
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _captureAnimation;
  late Animation<double> _pulseAnimation;

  bool _isFlashOn = false;
  bool _isCapturing = false;
  String _timerMode = '1x';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _captureAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  void _toggleTimer() {
    setState(() {
      _timerMode = _timerMode == '1x' ? '3x' : '1x';
    });
  }

  void _capturePhoto() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    // Animate capture button
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Simulate capture delay
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isCapturing = false;
    });

    // Navigate to photo preview (placeholder for now)
    // context.push('/camera/preview');
  }

  void _switchCamera() {
    // Handle camera switching logic (visual feedback only for now)
    setState(() {
      // Visual feedback for camera switch
    });
  }

  void _openHistory() {
    // Navigate to photo history
    // context.push('/photos/history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cameraBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview area (mock)
            Positioned.fill(
              child: Container(
                color: AppColors.cameraBackground,
                child: const Center(
                  child: Text(
                    'Camera Preview',
                    style: TextStyle(color: Color(0xFF333333), fontSize: 18),
                  ),
                ),
              ),
            ),

            // Top controls
            Positioned(top: 0, left: 0, right: 0, child: _buildTopControls()),

            // Timer indicator (center)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  _timerMode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flash control
          GestureDetector(
            onTap: _toggleFlash,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isFlashOn ? AppColors.darkSurface : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outline, width: 1),
              ),
              child: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Friend selection button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'n Friend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Messages/Close button
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outline, width: 1),
              ),
              child: const Icon(
                Icons.message_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLg,
        vertical: AppSizes.paddingMd,
      ),
      child: Column(
        children: [
          // Main control row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Flash toggle
              GestureDetector(
                onTap: _toggleFlash,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.flash_on, color: Colors.white, size: 28),
                ),
              ),

              // Capture button
              GestureDetector(
                onTap: _capturePhoto,
                child: AnimatedBuilder(
                  animation: _captureAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isCapturing ? _captureAnimation.value : 1.0,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentGold,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Camera switch
              GestureDetector(
                onTap: _switchCamera,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cameraswitch_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingSm),

          // History button
          GestureDetector(
            onTap: _openHistory,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd,
                vertical: AppSizes.paddingXs,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spacingXs),

          // Swipe indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
