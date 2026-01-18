import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';

/// Widget Demo Screen that shows users how to add the memore widget to their home screen
/// Displays a step-by-step tutorial with phone mockups and instructions
class WidgetDemoScreen extends StatefulWidget {
  const WidgetDemoScreen({super.key});

  @override
  State<WidgetDemoScreen> createState() => _WidgetDemoScreenState();
}

class _WidgetDemoScreenState extends State<WidgetDemoScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeDemo() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Skip button
                  TextButton(
                    onPressed: _completeDemo,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content with PageView
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [_buildStep1(), _buildStep2(), _buildStep3()],
                ),
              ),
            ),

            // Bottom section with page indicators and navigation
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_totalPages, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : const Color(0xFF404040),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppSizes.spacingLg),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightSm,
                    child: ElevatedButton(
                      onPressed: _currentPage == _totalPages - 1
                          ? _completeDemo
                          : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == _totalPages - 1
                            ? const Color(0xFF404040)
                            : Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: _currentPage == _totalPages - 1
                            ? null
                            : const BorderSide(color: Color(0xFF404040)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1
                            ? "I've enabled the widget"
                            : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Title
          const Text(
            'Finally, add the widget\nto your home screen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          const Spacer(flex: 2),

          // Phone mockup for step 1 - Hold down on any app
          PhoneWidgetMockup(
            step: 1,
            height: MediaQuery.of(context).size.height * 0.35,
          ),

          const Spacer(flex: 1),

          // Instruction
          const Text(
            'Hold down on any app\nto edit your Home Screen',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, height: 1.4),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Title
          const Text(
            'Finally, add the widget\nto your home screen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          const Spacer(flex: 2),

          // Phone mockup for step 2 - Tap the Plus button
          PhoneWidgetMockup(
            step: 2,
            height: MediaQuery.of(context).size.height * 0.35,
          ),

          const Spacer(flex: 1),

          // Instruction
          const Text(
            'Tap the Plus button\nin the top left corner',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, height: 1.4),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Title
          const Text(
            'Finally, add the widget\nto your home screen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          const Spacer(flex: 2),

          // Phone mockup for step 3 - Search for memore
          PhoneWidgetMockup(
            step: 3,
            height: MediaQuery.of(context).size.height * 0.35,
          ),

          const Spacer(flex: 1),

          // Instruction
          const Text(
            'Search for memore\nand add the widget',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, height: 1.4),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

/// Phone mockup widget that shows different steps of widget setup
class PhoneWidgetMockup extends StatelessWidget {
  final int step;
  final double height;

  const PhoneWidgetMockup({super.key, required this.step, this.height = 400});

  @override
  Widget build(BuildContext context) {
    final width = height * 0.48;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: const Color(0xFF404040), width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: Container(
          color: const Color(0xFF000000),
          child: Column(
            children: [
              // Status bar area
              const SizedBox(height: 32),

              // Content based on step
              Expanded(child: _buildStepContent()),

              // Home indicator
              Container(
                width: 120,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 1:
        return _buildStep1Content();
      case 2:
        return _buildStep2Content();
      case 3:
        return _buildStep3Content();
      default:
        return Container();
    }
  }

  Widget _buildStep1Content() {
    // Step 1: Home screen with apps in edit mode
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 18,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF404040),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // App icon placeholder
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF404040),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Wiggle effect indicator (small minus sign)
                if (index % 3 == 0)
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF666666),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep2Content() {
    // Step 2: Home screen with plus button highlighted
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top bar with plus button
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 18),
              ),
              const Spacer(),
              const Text(
                'Done',
                style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Grid of apps
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF404040),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Content() {
    // Step 3: Widget selection screen
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFFB3B3B3), size: 16),
                SizedBox(width: 8),
                Text(
                  'memore',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // memore widget preview
          Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
            ),
            child: Row(
              children: [
                // Widget icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Widget info
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'memore Widget',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Share live moments',
                        style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
