import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/user_model.dart';

/// Notifications Screen
/// Manages notification preferences for the app
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Notification settings
  bool _pushNotificationsEnabled = true;
  bool _photoNotificationsEnabled = true;
  bool _friendNotificationsEnabled = true;
  bool _memoryNotificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Quiet hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);

  UserSettings? _userSettings;
  bool _hasChanges = false;

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
    // TODO: Load actual notification settings from provider
    _userSettings = MockUsers.currentUser.settings;
    setState(() {
      _pushNotificationsEnabled = _userSettings!.pushNotificationsEnabled;
      _photoNotificationsEnabled = _userSettings!.photoNotificationsEnabled;
      _friendNotificationsEnabled = _userSettings!.friendNotificationsEnabled;
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
          content: Text('Notification settings saved'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      setState(() {
        _hasChanges = false;
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietHoursStart : _quietHoursEnd,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFD700),
              onPrimary: Colors.black,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietHoursStart = picked;
        } else {
          _quietHoursEnd = picked;
        }
        _onSettingChanged();
      });
    }
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
          'Notifications',
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
                // Main toggle
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_slideAnimation.value),
                    child: child,
                  ),
                  child: Container(
                    color: const Color(0xFF1A1A1A),
                    child: SwitchListTile(
                      title: const Text(
                        'Push Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Receive notifications for new photos and updates',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      value: _pushNotificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _pushNotificationsEnabled = value;
                          if (!value) {
                            // Disable all sub-notifications
                            _photoNotificationsEnabled = false;
                            _friendNotificationsEnabled = false;
                            _memoryNotificationsEnabled = false;
                          }
                          _onSettingChanged();
                        });
                      },
                      activeThumbColor: const Color(0xFFFFD700),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.spacingLg),

                // Notification types
                if (_pushNotificationsEnabled) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, -_slideAnimation.value * 0.8),
                        child: child,
                      ),
                      child: const Text(
                        'Notification Types',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -_slideAnimation.value * 0.6),
                      child: child,
                    ),
                    child: _buildNotificationSection(),
                  ),

                  const SizedBox(height: AppSizes.spacingLg),

                  // Sound & Vibration
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, -_slideAnimation.value * 0.4),
                        child: child,
                      ),
                      child: const Text(
                        'Sound & Vibration',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -_slideAnimation.value * 0.2),
                      child: child,
                    ),
                    child: _buildSoundSection(),
                  ),

                  const SizedBox(height: AppSizes.spacingLg),

                  // Quiet Hours
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    child: Text(
                      'Quiet Hours',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  _buildQuietHoursSection(),
                ],

                const SizedBox(height: AppSizes.spacingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
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
          _buildNotificationTile(
            title: 'Photo Notifications',
            subtitle: 'When friends send you photos',
            icon: Icons.photo,
            value: _photoNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _photoNotificationsEnabled = value;
                _onSettingChanged();
              });
            },
          ),
          _buildDivider(),
          _buildNotificationTile(
            title: 'Friend Notifications',
            subtitle: 'Friend requests and new connections',
            icon: Icons.person_add,
            value: _friendNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _friendNotificationsEnabled = value;
                _onSettingChanged();
              });
            },
          ),
          _buildDivider(),
          _buildNotificationTile(
            title: 'Memory Notifications',
            subtitle: 'Photos from this day in the past',
            icon: Icons.auto_awesome,
            value: _memoryNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _memoryNotificationsEnabled = value;
                _onSettingChanged();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSection() {
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
          _buildNotificationTile(
            title: 'Sound',
            subtitle: 'Play sound for notifications',
            icon: Icons.volume_up,
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
                _onSettingChanged();
              });
            },
          ),
          _buildDivider(),
          _buildNotificationTile(
            title: 'Vibration',
            subtitle: 'Vibrate for notifications',
            icon: Icons.vibration,
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
                _onSettingChanged();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursSection() {
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
              'Enable Quiet Hours',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Pause notifications during set hours',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            value: _quietHoursEnabled,
            onChanged: (value) {
              setState(() {
                _quietHoursEnabled = value;
                _onSettingChanged();
              });
            },
            activeThumbColor: const Color(0xFFFFD700),
          ),
          if (_quietHoursEnabled) ...[
            _buildDivider(),
            ListTile(
              title: const Text(
                'Start Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => _selectTime(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _quietHoursStart.format(context),
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            _buildDivider(),
            ListTile(
              title: const Text(
                'End Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => _selectTime(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _quietHoursEnd.format(context),
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: value ? const Color(0xFFFFD700) : const Color(0xFF666666),
        size: 24,
      ),
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
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 14,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFFFFD700),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 72),
      color: const Color(0xFF404040).withValues(alpha: 0.3),
    );
  }
}