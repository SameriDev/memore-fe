import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

/// Enhanced Settings Screen for app preferences and account management
/// Provides comprehensive settings interface matching memore design
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = MockUsers.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.spacingMd),

              // Profile Section
              _buildProfileSection(currentUser),

              const SizedBox(height: AppSizes.spacingXl),

              // Settings Sections
              _buildSettingsSection('Account', [
                _buildSettingItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Change your name and avatar',
                  onTap: () => _navigateToProfileEdit(),
                ),
                _buildSettingItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy & Security',
                  subtitle: 'Control who can add you and see your content',
                  onTap: () => _navigateToPrivacy(),
                ),
                _buildSettingItem(
                  icon: Icons.block,
                  title: 'Blocked Users',
                  subtitle:
                      '${currentUser.settings.blockedUserIds.length} blocked',
                  onTap: () => _navigateToBlockedUsers(),
                ),
              ]),

              const SizedBox(height: AppSizes.spacingXl),

              _buildSettingsSection('Preferences', [
                _buildSettingToggle(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Get notified about new photos and friends',
                  value: currentUser.settings.pushNotificationsEnabled,
                  onChanged: (value) => _toggleNotifications(value),
                ),
                _buildSettingToggle(
                  icon: Icons.photo_camera_outlined,
                  title: 'Photo Notifications',
                  subtitle: 'Get notified when friends share photos',
                  value: currentUser.settings.photoNotificationsEnabled,
                  onChanged: (value) => _togglePhotoNotifications(value),
                ),
                _buildSettingToggle(
                  icon: Icons.people_outline,
                  title: 'Friend Notifications',
                  subtitle: 'Get notified about friend requests',
                  value: currentUser.settings.friendNotificationsEnabled,
                  onChanged: (value) => _toggleFriendNotifications(value),
                ),
              ]),

              const SizedBox(height: AppSizes.spacingXl),

              _buildSettingsSection('Storage & Data', [
                _buildSettingItem(
                  icon: Icons.storage_outlined,
                  title: 'Storage Management',
                  subtitle: 'Manage photo cache and app data',
                  onTap: () => _navigateToStorage(),
                ),
                _buildSettingItem(
                  icon: Icons.download_outlined,
                  title: 'Download Options',
                  subtitle: 'Photo quality and auto-download settings',
                  onTap: () => _showDownloadOptions(),
                ),
              ]),

              const SizedBox(height: AppSizes.spacingXl),

              _buildSettingsSection('Support & About', [
                _buildSettingItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact support',
                  onTap: () => _navigateToSupport(),
                ),
                _buildSettingItem(
                  icon: Icons.info_outline,
                  title: 'About memore',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _navigateToAbout(),
                ),
                _buildSettingItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Privacy',
                  subtitle: 'Read our terms and privacy policy',
                  onTap: () => _showTermsAndPrivacy(),
                ),
              ]),

              const SizedBox(height: AppSizes.spacingXl),

              // Sign Out Button
              _buildSignOutButton(),

              const SizedBox(height: AppSizes.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFF2A2A2A), width: 2),
            ),
            child: Center(
              child: Text(
                user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSizes.spacingMd),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phoneNumber,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user.isOnline
                            ? const Color(0xFF00FF00)
                            : const Color(0xFF666666),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: user.isOnline
                            ? const Color(0xFF00FF00)
                            : const Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            onPressed: () => _navigateToProfileEdit(),
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMd),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      leading: Icon(icon, color: const Color(0xFFFFD700), size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF666666),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSettingToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingSm,
      ),
      leading: Icon(icon, color: const Color(0xFFFFD700), size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF666666), fontSize: 14),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFD700),
        activeTrackColor: const Color(0xFFFFD700).withOpacity(0.3),
        inactiveTrackColor: const Color(0xFF2A2A2A),
        inactiveThumbColor: const Color(0xFF666666),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF404040), width: 1),
      ),
      child: TextButton(
        onPressed: () => _showSignOutDialog(),
        child: const Text(
          'Sign Out',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Navigation Methods
  void _navigateToProfileEdit() {
    // TODO: Navigate to profile edit screen
    _showComingSoon('Profile Edit');
  }

  void _navigateToPrivacy() {
    // TODO: Navigate to privacy settings screen
    _showComingSoon('Privacy & Security');
  }

  void _navigateToBlockedUsers() {
    // TODO: Navigate to blocked users screen
    _showComingSoon('Blocked Users');
  }

  void _navigateToStorage() {
    // TODO: Navigate to storage management screen
    _showComingSoon('Storage Management');
  }

  void _navigateToSupport() {
    // TODO: Navigate to help & support screen
    _showComingSoon('Help & Support');
  }

  void _navigateToAbout() {
    // TODO: Navigate to about screen
    _showComingSoon('About');
  }

  // Action Methods
  void _toggleNotifications(bool value) {
    // TODO: Update user settings
    setState(() {
      // This would typically update the user model through a provider
    });
  }

  void _togglePhotoNotifications(bool value) {
    // TODO: Update photo notification settings
    setState(() {
      // This would typically update the user model through a provider
    });
  }

  void _toggleFriendNotifications(bool value) {
    // TODO: Update friend notification settings
    setState(() {
      // This would typically update the user model through a provider
    });
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF666666),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),

            const Text(
              'Download Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),

            const Text(
              'Configure how photos are downloaded and stored',
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            ),
            const SizedBox(height: AppSizes.spacingXl),
          ],
        ),
      ),
    );
  }

  void _showTermsAndPrivacy() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF666666),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),

            const Text(
              'Legal Documents',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),

            ListTile(
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.open_in_new, color: Color(0xFFFFD700)),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.open_in_new, color: Color(0xFFFFD700)),
              onTap: () {},
            ),

            const SizedBox(height: AppSizes.spacingXl),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(0xFF666666)),
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
              context.go('/welcome');
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          feature,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'This feature is coming soon!',
          style: TextStyle(color: Color(0xFF666666)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
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
}
