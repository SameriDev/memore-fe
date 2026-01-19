import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../providers/auth_provider.dart';

/// Main screen with side navigation drawer
/// Serves as the primary entry point after authentication
/// Contains navigation menu with photos, friends, messages, and settings
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PhotoFeedScreenContent(), // Photos feed
    const FriendsListScreenContent(), // Friends
    const MessagesScreenContent(), // Messages
    const SettingsScreenContent(), // Settings
  ];

  final List<String> _titles = [
    'Photos',
    'Friends',
    'Messages',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        actions: [
          if (_selectedIndex == 0) // Show camera icon only on photos page
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                context.push(AppRoutes.camera);
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(currentUserProvider);
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.onPrimary,
                      child: Text(
                        user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(currentUserProvider);
                    return Text(
                      user?.displayName ?? 'User',
                      style: const TextStyle(
                        color: AppColors.onPrimary,
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
                      style: TextStyle(
                        color: AppColors.onPrimary.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Drawer menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.photo_library,
                  title: 'Photos',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onDrawerItemSelected(0),
                ),
                _buildDrawerItem(
                  icon: Icons.people,
                  title: 'Friends',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onDrawerItemSelected(1),
                ),
                _buildDrawerItem(
                  icon: Icons.message,
                  title: 'Messages',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onDrawerItemSelected(2),
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onDrawerItemSelected(3),
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  isSelected: false,
                  onTap: () {
                    // Handle help
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  isSelected: false,
                  onTap: () {
                    // Handle feedback
                  },
                ),
              ],
            ),
          ),

          // Sign out button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showSignOutDialog,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onError,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      onTap: onTap,
    );
  }

  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
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
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Photo feed screen content
class PhotoFeedScreenContent extends StatelessWidget {
  const PhotoFeedScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Quick stats
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Photos', '128', Icons.photo),
                _buildStatCard('Shared', '42', Icons.share),
                _buildStatCard('Friends', '8', Icons.people),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Photo grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSizes.spacingXs,
                mainAxisSpacing: AppSizes.spacingXs,
              ),
              itemCount: 9, // Mock data
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                    child: Image.network(
                      'https://picsum.photos/seed/${index + 1}/300/300',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.broken_image,
                            color: AppColors.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black25,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: AppSizes.spacingXs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Friends list screen content
class FriendsListScreenContent extends StatelessWidget {
  const FriendsListScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        children: [
          // Friends list header
          Row(
            children: [
              const Text(
                'Friends',
                style: TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.push(AppRoutes.addFriend);
                },
                icon: Icon(
                  Icons.person_add_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXs),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search friends...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary,
          child: Text(
            friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.displayName ?? 'Friend',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Last seen recently',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.friendOnline,
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          context.push('${AppRoutes.friends}/profile?friendId=${friend.id}');
        },
      ),
    );
  }
}

/// Messages screen content
class MessagesScreenContent extends StatelessWidget {
  const MessagesScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        children: [
          // Messages header
          Row(
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  color: AppColors.onBackground,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Handle new message
                },
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMd),

          // Mock conversations list
          Expanded(
            child: ListView.builder(
              itemCount: MockUsers.sampleFriends.length,
              itemBuilder: (context, index) {
                final friend = MockUsers.sampleFriends[index];
                return _buildConversationTile(friend, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(UserModel friend, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary,
          child: Text(
            friend.displayName?.substring(0, 1).toUpperCase() ?? 'F',
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.displayName ?? 'Friend',
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Hey there! How are you doing?',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '10:30 AM',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '3',
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          context.push('${AppRoutes.messages}/chat?userId=${friend.id}&userName=${friend.displayName}');
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
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      child: Column(
        children: [
          // Profile section
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            ),
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(currentUserProvider);
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
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
                              color: AppColors.onSurface,
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
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.push('${AppRoutes.settings}/edit');
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Settings options
          Expanded(
            child: ListView(
              children: [
                _buildSettingsTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Account',
                  onTap: () {
                    context.push('${AppRoutes.settings}/profile');
                  },
                ),
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingXs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
