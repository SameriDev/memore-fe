import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'friends/friends_list_screen.dart';
import 'common/placeholder_screen.dart';
import 'camera/camera_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../animations/camera_transition_controller.dart';
import '../routes/camera_page_route.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int currentIndex = 1;
  int previousIndex = 1;

  late CameraTransitionController _transitionController;

  final List<Widget> screens = [
    const FriendsListScreen(),
    const HomeScreen(),
    const SizedBox.shrink(), // Camera handled separately
    const PlaceholderScreen(title: 'Timeline'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = CameraTransitionController();
    _transitionController.initialize(this);
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  Future<void> _handleNavTap(int index) async {
    if (index == 2) {
      // Camera tab tapped
      await _openCamera();
    } else {
      setState(() {
        previousIndex = currentIndex;
        currentIndex = index;
      });
    }
  }

  Future<void> _openCamera() async {
    // Start nav icons fade out animation
    await _transitionController.startCameraTransition();

    // Navigate to camera with custom route
    if (mounted) {
      await Navigator.of(
        context,
      ).push(CameraPageRoute(child: const CameraScreen()));

      // When returned from camera, reverse animation
      await _transitionController.reverseCameraTransition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(currentIndex > previousIndex ? 1.0 : -1.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: KeyedSubtree(
              key: ValueKey(currentIndex),
              child: screens[currentIndex],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _transitionController.navIconsAnimation,
              builder: (context, child) {
                return BottomNavigation(
                  currentIndex: currentIndex,
                  onTap: _handleNavTap,
                  navItemsAnimation: _transitionController.navIconsAnimation,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
