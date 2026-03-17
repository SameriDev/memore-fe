import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'friends/friends_tab.dart';
import 'camera/camera_screen.dart';
import 'profile/profile_screen.dart';
import 'timeline/timeline_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../animations/camera_transition_controller.dart';
import '../routes/camera_page_route.dart';
import '../../data/local/storage_service.dart';
import '../../data/local/user_manager.dart';
import '../../data/data_sources/remote/notification_service.dart';
import '../widgets/ai_bubble/ai_floating_bubble.dart';
import '../widgets/app_popup.dart';
import '../../core/utils/show_app_popup.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPremiumWelcomeIfNeeded());
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

  void _showPremiumWelcomeIfNeeded() {
    final user = UserManager.instance.toUserProfile();
    if (user == null) return;
    final plan = user.subscriptionPlan;
    if (plan == 'FREE') return;
    showAppPopup(
      context: context,
      builder: (ctx) => _PremiumWelcomePopup(ctx, plan),
    );
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
          const AiFloatingBubble(),
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

class _PremiumWelcomePopup extends StatelessWidget {
  final BuildContext dialogContext;
  final String plan;

  const _PremiumWelcomePopup(this.dialogContext, this.plan);

  @override
  Widget build(BuildContext context) {
    final isGold = plan == 'GOLD';
    final planColor = isGold ? const Color(0xFFFCBA03) : const Color(0xFF90A4AE);
    final title = isGold
        ? 'Chào mừng trở lại, Gold Member! ⭐'
        : 'Chào mừng trở lại, Silver Member!';
    final description = isGold
        ? 'Bạn đang dùng gói Gold — chỉnh ảnh bằng AI không giới hạn. Tận hưởng trải nghiệm premium nhé!'
        : 'Bạn đang dùng gói Silver — chỉnh ảnh bằng AI tối đa 20 lần mỗi ngày.';

    return AppPopup(
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: planColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inika(
              fontSize: 14,
              color: const Color(0xFF555555),
              height: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          style: TextButton.styleFrom(
            foregroundColor: planColor,
            textStyle: GoogleFonts.inika(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Bắt đầu'),
        ),
      ],
    );
  }
}
