import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/models/user_model.dart';

/// Privacy Screen
/// Manages privacy settings for user data and interactions
class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Privacy settings
  WhoCanAddMe _whoCanAddMe = WhoCanAddMe.everyone;
  bool _showOnlineStatus = true;
  bool _readReceipts = true;
  bool _shareLocation = false;
  bool _analyticsEnabled = true;
  bool _personalizedAds = false;

  UserSettings? _userSettings;
  bool _hasChanges = false;
  int _blockedUsersCount = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSettings();
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSettings() {
    // TODO: Load actual privacy settings from provider
    _userSettings = MockUsers.currentUser.settings;
    setState(() {
      _whoCanAddMe = _userSettings!.whoCanAddMe;
      _blockedUsersCount = _userSettings!.blockedUserIds.length;
    });
  }

  void _onSettingChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _saveSettings() async {
    // TODO: Implement actual settings save
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Privacy settings saved'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      setState(() {
        _hasChanges = false;
      });
    }
  }

  void _navigateToBlockedUsers() {
    context.push(AppRoutes.blockedUsers);
  }

  void _showPrivacyInfo(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
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
          'Privacy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveSettings,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Friend Requests
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                    vertical: AppSizes.paddingSm,
                  ),
                  child: Text(
                    'Friend Requests',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value),
                    child: child,
                  ),
                  child: _buildFriendRequestsSection(),
                ),

                const SizedBox(height: AppSizes.spacingLg),

                // Visibility
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                    vertical: AppSizes.paddingSm,
                  ),
                  child: Text(
                    'Visibility',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value * 0.8),
                    child: child,
                  ),
                  child: _buildVisibilitySection(),
                ),

                const SizedBox(height: AppSizes.spacingLg),

                // Data & Personalization
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                    vertical: AppSizes.paddingSm,
                  ),
                  child: Text(
                    'Data & Personalization',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value * 0.6),
                    child: child,
                  ),
                  child: _buildDataSection(),
                ),

                const SizedBox(height: AppSizes.spacingLg),

                // Blocked Users
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value * 0.4),
                    child: child,
                  ),
                  child: _buildBlockedUsersSection(),
                ),

                const SizedBox(height: AppSizes.spacingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
          bottom: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Who can add me',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              _getWhoCanAddMeText(),
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
            onTap: _showWhoCanAddMeDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
          bottom: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Show Online Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Let friends see when you\'re active',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _showOnlineStatus,
            onChanged: (value) {
              setState(() {
                _showOnlineStatus = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
          _buildDivider(),
          SwitchListTile(
            title: const Text(
              'Read Receipts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Let friends see when you view their photos',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _readReceipts,
            onChanged: (value) {
              setState(() {
                _readReceipts = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
          _buildDivider(),
          SwitchListTile(
            title: const Text(
              'Share Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Add location to your photos',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _shareLocation,
            onChanged: (value) {
              setState(() {
                _shareLocation = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
          bottom: BorderSide(
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Help improve Memore with usage data',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _analyticsEnabled,
            onChanged: (value) {
              setState(() {
                _analyticsEnabled = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
            secondary: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Color(0xFF666666),
                size: 20,
              ),
              onPressed: () => _showPrivacyInfo(
                'Analytics',
                'We collect anonymous usage data to improve app performance and user experience. No personal information or photo content is shared.',
              ),
            ),
          ),
          _buildDivider(),
          SwitchListTile(
            title: const Text(
              'Personalized Ads',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'See ads based on your interests',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _personalizedAds,
            onChanged: (value) {
              setState(() {
                _personalizedAds = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
            secondary: IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Color(0xFF666666),
                size: 20,
              ),
              onPressed: () => _showPrivacyInfo(
                'Personalized Ads',
                'When enabled, we may show ads tailored to your interests based on your app usage. You can opt out anytime.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUsersSection() {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: ListTile(
        leading: const Icon(
          Icons.block,
          color: Color(0xFFEF4444),
          size: 24,
        ),
        title: const Text(
          'Blocked Users',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _blockedUsersCount == 0
              ? 'No blocked users'
              : '$_blockedUsersCount blocked user${_blockedUsersCount > 1 ? 's' : ''}',
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
        onTap: _navigateToBlockedUsers,
      ),
    );
  }

  void _showWhoCanAddMeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Who can add me as a friend',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WhoCanAddMe.values.map((option) {
            final isSelected = _whoCanAddMe == option;
            return InkWell(
              onTap: () {
                setState(() {
                  _whoCanAddMe = option;
                  _onSettingChanged();
                });
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                            _getWhoCanAddMeLabel(option),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getWhoCanAddMeDescription(option),
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getWhoCanAddMeText() {
    return _getWhoCanAddMeLabel(_whoCanAddMe);
  }

  String _getWhoCanAddMeLabel(WhoCanAddMe option) {
    switch (option) {
      case WhoCanAddMe.everyone:
        return 'Everyone';
      case WhoCanAddMe.friendsOfFriends:
        return 'Friends of Friends';
      case WhoCanAddMe.noOne:
        return 'No One';
    }
  }

  String _getWhoCanAddMeDescription(WhoCanAddMe option) {
    switch (option) {
      case WhoCanAddMe.everyone:
        return 'Anyone with your phone number can add you';
      case WhoCanAddMe.friendsOfFriends:
        return 'Only mutual friends can add you';
      case WhoCanAddMe.noOne:
        return 'Nobody can send you friend requests';
    }
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 16),
      color: const Color(0xFF404040).withValues(alpha: 0.3),
    );
  }
}