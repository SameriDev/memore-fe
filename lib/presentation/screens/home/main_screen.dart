import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../providers/auth_provider.dart';

/// Main screen with bottom navigation
/// Serves as the primary entry point after authentication
/// Contains camera, friends, and settings tabs
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 1; // Start with camera tab (center)

  final List<Widget> _screens = [
    const FriendsListScreenContent(), // Friends tab
    const CameraScreenContent(), // Camera tab (main)
    const SettingsScreenContent(), // Settings tab
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMd,
                vertical: AppSizes.paddingXs,
              ),
              child: _buildTopNavigationBar(),
            ),

            // Main content with PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _screens,
              ),
            ),

            // Bottom navigation bar
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Settings/Profile button (left)
        GestureDetector(
          onTap: () => _onTabTapped(2), // Settings tab
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _currentIndex == 2
                  ? const Color(0xFF2A2A2A)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: _currentIndex == 2
                  ? null
                  : Border.all(color: const Color(0xFF404040)),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),

        // Center - App title or friend count
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMd,
            vertical: AppSizes.paddingXs,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.people_outline, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                _currentIndex == 0 ? 'Friends' : '1 Friend',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Messages button (right)
        GestureDetector(
          onTap: () {
            context.push(AppRoutes.messages);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF404040)),
            ),
            child: const Icon(
              Icons.message_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Gallery/Grid button
          _buildNavButton(
            icon: Icons.grid_view_rounded,
            isActive: _currentIndex == 0,
            onTap: () => _onTabTapped(0),
          ),

          // Camera capture button (center)
          _buildCameraButton(),

          // Switch camera button
          _buildNavButton(
            icon: Icons.cameraswitch_outlined,
            isActive: false,
            onTap: () {
              // Handle camera switch
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: () {
        // Handle photo capture
        context.push(AppRoutes.camera);
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFD700), width: 4),
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
  }
}

/// Camera screen content
class CameraScreenContent extends StatelessWidget {
  const CameraScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mock camera preview area
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF404040),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF666666),
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Camera preview',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Take a photo to share with friends',
                            style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Flash and timer controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(Icons.flash_off, 'Auto'),
                      const SizedBox(width: 32),
                      _buildControlButton(Icons.timer, '1x'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // History button
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingLg),
            child: GestureDetector(
              onTap: () {
                // Navigate to photo history
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMd,
                  vertical: AppSizes.paddingXs,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF404040),
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
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF404040)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
      ],
    );
  }
}

/// Friends list screen content
class FriendsListScreenContent extends StatelessWidget {
  const FriendsListScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        children: [
          // Friends list header
          Row(
            children: [
              const Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.addFriend);
                },
                icon: const Icon(
                  Icons.person_add_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Mock friends list
          Expanded(
            child: ListView.builder(
              itemCount: MockUsers.sampleFriends.length,
              itemBuilder: (context, index) {
                final friend = MockUsers.sampleFriends[index];
                return _buildFriendTile(friend, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(UserModel friend, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSm),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFFFD700),
          child: Text(
            friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.displayName ?? 'Friend',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: const Text(
          'Online',
          style: TextStyle(color: Color(0xFF00FF00), fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF666666)),
        onTap: () {
          context.push('${AppRoutes.friends}/profile?friendId=${friend.id}');
        },
      ),
    );
  }
}

/// Settings screen content
class SettingsScreenContent extends StatelessWidget {
  const SettingsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFFD700),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(currentUserProvider);
                      return Text(
                        user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final user = ref.watch(currentUserProvider);
                          return Text(
                            user?.displayName ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final user = ref.watch(currentUserProvider);
                          return Text(
                            user?.phoneNumber ?? '+1234567890',
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF666666)),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Settings options
          Expanded(
            child: ListView(
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    context.push('${AppRoutes.settings}/notifications');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  onTap: () {
                    context.push('${AppRoutes.settings}/privacy');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.storage_outlined,
                  title: 'Storage',
                  onTap: () {
                    context.push('${AppRoutes.settings}/storage');
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    context.push('${AppRoutes.settings}/about');
                  },
                ),
                const SizedBox(height: AppSizes.spacingLg),
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: () {
                    _showSignOutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingXs),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isDestructive
            ? null
            : const Icon(Icons.chevron_right, color: Color(0xFF666666)),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(0xFFB3B3B3)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle sign out
              context.go(AppRoutes.welcome);
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
