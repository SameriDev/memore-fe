import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';

/// Modern Settings Screen for app preferences and account management
/// Provides comprehensive settings interface with clean, organized layout
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SlideTransition(
        position: _slideAnimation,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black25,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(
              child: Text(
                user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 28,
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
                    color: AppColors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phoneNumber,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
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
                            ? AppColors.success
                            : AppColors.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: user.isOnline
                            ? AppColors.success
                            : AppColors.onSurfaceVariant,
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
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
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
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.spacingMd),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            boxShadow: [
              BoxShadow(
                color: AppColors.black25,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.onSurfaceVariant,
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
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withOpacity(0.3),
        inactiveTrackColor: AppColors.surfaceVariant,
        inactiveThumbColor: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black25,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => _showSignOutDialog(),
        child: Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.error,
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
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
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
                color: AppColors.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),

            const Text(
              'Download Options',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),

            const Text(
              'Configure how photos are downloaded and stored',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
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
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
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
                color: AppColors.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLg),

            const Text(
              'Legal Documents',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.spacingMd),

            ListTile(
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: AppColors.onSurface),
              ),
              trailing: Icon(Icons.open_in_new, color: AppColors.primary),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: AppColors.onSurface),
              ),
              trailing: Icon(Icons.open_in_new, color: AppColors.primary),
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
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
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
                color: AppColors.error,
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
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        ),
        title: Text(
          feature,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'This feature is coming soon!',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
