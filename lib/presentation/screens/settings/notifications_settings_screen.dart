import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/local/user_manager.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _friendRequests = true;
  bool _photoUploads = true;
  bool _comments = true;
  bool _likes = false;
  bool _mentions = true;
  bool _albumInvites = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _emailNotifications = false;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() {
    // Load notification preferences from local storage
    final user = UserManager.instance.getCurrentUser();
    if (user != null && user['notificationSettings'] != null) {
      final settings = user['notificationSettings'] as Map<String, dynamic>;
      setState(() {
        _pushNotifications = settings['pushNotifications'] ?? true;
        _friendRequests = settings['friendRequests'] ?? true;
        _photoUploads = settings['photoUploads'] ?? true;
        _comments = settings['comments'] ?? true;
        _likes = settings['likes'] ?? false;
        _mentions = settings['mentions'] ?? true;
        _albumInvites = settings['albumInvites'] ?? true;
        _soundEnabled = settings['soundEnabled'] ?? true;
        _vibrationEnabled = settings['vibrationEnabled'] ?? true;
        _emailNotifications = settings['emailNotifications'] ?? false;
        _quietHoursStart = settings['quietHoursStart'] ?? '22:00';
        _quietHoursEnd = settings['quietHoursEnd'] ?? '08:00';
      });
    }
  }

  Future<void> _saveSettings() async {
    final notificationSettings = {
      'pushNotifications': _pushNotifications,
      'friendRequests': _friendRequests,
      'photoUploads': _photoUploads,
      'comments': _comments,
      'likes': _likes,
      'mentions': _mentions,
      'albumInvites': _albumInvites,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'emailNotifications': _emailNotifications,
      'quietHoursStart': _quietHoursStart,
      'quietHoursEnd': _quietHoursEnd,
    };

    try {
      await UserManager.instance.updateProfile({
        'notificationSettings': notificationSettings,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã lưu cài đặt thông báo',
              style: GoogleFonts.inika(),
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lỗi khi lưu cài đặt: $e',
              style: GoogleFonts.inika(),
            ),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    }
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool)? onChanged,
    IconData? icon,
  }) {
    return ListTile(
      leading: icon != null
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8B4513),
                size: 20,
              ),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.inika(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3E2723),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inika(
          fontSize: 14,
          color: const Color(0xFF6D4C41),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF8B4513),
        activeTrackColor: const Color(0xFF8B4513).withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.inika(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF3E2723),
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String time,
    required Function(String) onTimeSelected,
  }) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.inika(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3E2723),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: GoogleFonts.inika(
              fontSize: 16,
              color: const Color(0xFF8B4513),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.access_time,
            color: Color(0xFF8B4513),
            size: 20,
          ),
        ],
      ),
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(time.split(':')[0]),
            minute: int.parse(time.split(':')[1]),
          ),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: const Color(0xFF8B4513),
                    ),
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
          onTimeSelected(formattedTime);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Cài đặt thông báo',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'Lưu',
              style: GoogleFonts.inika(
                color: const Color(0xFF8B4513),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Push Notifications Section
            _buildSectionHeader('Thông báo đẩy'),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: 'Bật thông báo đẩy',
              subtitle: 'Nhận thông báo trên thiết bị của bạn',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),

            // Activity Notifications
            _buildSectionHeader('Hoạt động'),
            _buildSwitchTile(
              icon: Icons.person_add_outlined,
              title: 'Lời mời kết bạn',
              subtitle: 'Thông báo khi có người gửi lời mời kết bạn',
              value: _friendRequests,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _friendRequests = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.photo_camera_outlined,
              title: 'Ảnh mới',
              subtitle: 'Thông báo khi bạn bè đăng ảnh mới',
              value: _photoUploads,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _photoUploads = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.comment_outlined,
              title: 'Bình luận',
              subtitle: 'Thông báo khi có người bình luận ảnh của bạn',
              value: _comments,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _comments = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.favorite_outline,
              title: 'Lượt thích',
              subtitle: 'Thông báo khi có người thích ảnh của bạn',
              value: _likes,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _likes = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.alternate_email,
              title: 'Được nhắc đến',
              subtitle: 'Thông báo khi được tag trong ảnh hoặc bình luận',
              value: _mentions,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _mentions = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.photo_album_outlined,
              title: 'Lời mời album',
              subtitle: 'Thông báo khi được mời tham gia album',
              value: _albumInvites,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _albumInvites = value)
                  : null,
            ),

            // Sound & Vibration
            _buildSectionHeader('Âm thanh & Rung'),
            _buildSwitchTile(
              icon: Icons.volume_up_outlined,
              title: 'Âm thanh thông báo',
              subtitle: 'Phát âm thanh khi có thông báo',
              value: _soundEnabled,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _soundEnabled = value)
                  : null,
            ),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'Rung',
              subtitle: 'Rung thiết bị khi có thông báo',
              value: _vibrationEnabled,
              onChanged: _pushNotifications
                  ? (value) => setState(() => _vibrationEnabled = value)
                  : null,
            ),

            // Quiet Hours
            _buildSectionHeader('Giờ yên lặng'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Không nhận thông báo trong khoảng thời gian này',
                    style: GoogleFonts.inika(
                      fontSize: 14,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeSelector(
                    label: 'Bắt đầu',
                    time: _quietHoursStart,
                    onTimeSelected: (time) {
                      setState(() => _quietHoursStart = time);
                    },
                  ),
                  const Divider(),
                  _buildTimeSelector(
                    label: 'Kết thúc',
                    time: _quietHoursEnd,
                    onTimeSelected: (time) {
                      setState(() => _quietHoursEnd = time);
                    },
                  ),
                ],
              ),
            ),

            // Email Notifications
            _buildSectionHeader('Email'),
            _buildSwitchTile(
              icon: Icons.email_outlined,
              title: 'Thông báo email',
              subtitle: 'Nhận thông báo qua email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}