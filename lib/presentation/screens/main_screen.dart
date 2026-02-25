import 'dart:async';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'friends/friends_tab.dart';
import 'camera/camera_screen.dart';
import 'profile/profile_screen.dart';
import 'timeline/timeline_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../animations/camera_transition_controller.dart';
import '../routes/camera_page_route.dart';
import '../../data/local/storage_service.dart';
import '../../data/data_sources/remote/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int currentIndex = 1;
  int previousIndex = 1;
  int _unreadNotificationCount = 0;
  StreamSubscription<int>? _unseenCountSubscription;

  late CameraTransitionController _transitionController;

  final List<Widget> screens = [
    const FriendsTab(),
    const HomeScreen(),
    const SizedBox.shrink(), // Camera handled separately
    const TimelineScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = CameraTransitionController();
    _transitionController.initialize(this);
    _configureNotifications();
  }

  @override
  void dispose() {
    _unseenCountSubscription?.cancel();
    _transitionController.dispose();
    super.dispose();
  }

  void _configureNotifications() {
    final userId = StorageService.instance.userId;
    if (userId == null) return;
    if (!NotificationService.instance.isConfigured) {
      NotificationService.instance.configure(
        apiKey: 'cb846fd2d85f202e97ad87e096cbe570',
        subscriberId: userId,
      );
    }
    _loadUnreadCount();
    _unseenCountSubscription =
        NotificationService.instance.onUnseenCountChanged.listen((count) {
      if (mounted) setState(() => _unreadNotificationCount = count);
    });
  }

  Future<void> _loadUnreadCount() async {
    final count = await NotificationService.instance.getUnreadCount();
    if (mounted) setState(() => _unreadNotificationCount = count);
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
                  friendBadgeCount: _unreadNotificationCount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
