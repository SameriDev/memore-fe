import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import '../../../data/local/user_manager.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisible = true;
  bool _photosPublic = false;
  bool _allowTagging = true;
  bool _locationSharing = true;
  bool _showOnlineStatus = true;
  bool _allowFriendRequests = true;
  bool _albumInvitePermission = true;
  String _whoCanSeeProfile = 'friends'; // friends, everyone, private
  String _whoCanSeePhotos = 'friends'; // friends, everyone, private
  String _whoCanMessage = 'friends'; // friends, everyone, nobody
  bool _dataAnalytics = false;
  bool _personalization = true;
  bool _crashReports = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  void _loadPrivacySettings() {
    final user = UserManager.instance.getCurrentUser();
    if (user != null && user['privacySettings'] != null) {
      final settings = user['privacySettings'] as Map<String, dynamic>;
      setState(() {
        _profileVisible = settings['profileVisible'] ?? true;
        _photosPublic = settings['photosPublic'] ?? false;
        _allowTagging = settings['allowTagging'] ?? true;
        _locationSharing = settings['locationSharing'] ?? true;
        _showOnlineStatus = settings['showOnlineStatus'] ?? true;
        _allowFriendRequests = settings['allowFriendRequests'] ?? true;
        _albumInvitePermission = settings['albumInvitePermission'] ?? true;
        _whoCanSeeProfile = settings['whoCanSeeProfile'] ?? 'friends';
        _whoCanSeePhotos = settings['whoCanSeePhotos'] ?? 'friends';
        _whoCanMessage = settings['whoCanMessage'] ?? 'friends';
        _dataAnalytics = settings['dataAnalytics'] ?? false;
        _personalization = settings['personalization'] ?? true;
        _crashReports = settings['crashReports'] ?? true;
      });
    }
  }

  Future<void> _saveSettings() async {
    final privacySettings = {
      'profileVisible': _profileVisible,
      'photosPublic': _photosPublic,
      'allowTagging': _allowTagging,
      'locationSharing': _locationSharing,
      'showOnlineStatus': _showOnlineStatus,
      'allowFriendRequests': _allowFriendRequests,
      'albumInvitePermission': _albumInvitePermission,
      'whoCanSeeProfile': _whoCanSeeProfile,
      'whoCanSeePhotos': _whoCanSeePhotos,
      'whoCanMessage': _whoCanMessage,
      'dataAnalytics': _dataAnalytics,
      'personalization': _personalization,
      'crashReports': _crashReports,
    };

    try {
      await UserManager.instance.updateProfile({
        'privacySettings': privacySettings,
      });

      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Đã lưu cài đặt quyền riêng tư');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Lỗi khi lưu cài đặt: $e');
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

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required List<String> labels,
    required Function(String?) onChanged,
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
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        style: GoogleFonts.inika(
          fontSize: 14,
          color: const Color(0xFF8B4513),
          fontWeight: FontWeight.w600,
        ),
        items: options.asMap().entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.value,
            child: Text(labels[entry.key]),
          );
        }).toList(),
        onChanged: onChanged,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Quyền riêng tư',
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
            // Profile Visibility
            _buildSectionHeader('Hồ sơ cá nhân'),
            _buildDropdownTile(
              icon: Icons.person_outline,
              title: 'Ai có thể xem hồ sơ',
              subtitle: 'Kiểm soát ai có thể nhìn thấy thông tin của bạn',
              value: _whoCanSeeProfile,
              options: ['friends', 'everyone', 'private'],
              labels: ['Bạn bè', 'Mọi người', 'Chỉ tôi'],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _whoCanSeeProfile = value);
                }
              },
            ),
            _buildSwitchTile(
              icon: Icons.visibility_outlined,
              title: 'Hiển thị trạng thái online',
              subtitle: 'Cho phép bạn bè thấy khi bạn đang online',
              value: _showOnlineStatus,
              onChanged: (value) {
                setState(() => _showOnlineStatus = value);
              },
            ),

            // Photo Privacy
            _buildSectionHeader('Ảnh và nội dung'),
            _buildDropdownTile(
              icon: Icons.photo_outlined,
              title: 'Ai có thể xem ảnh',
              subtitle: 'Kiểm soát ai có thể nhìn thấy ảnh của bạn',
              value: _whoCanSeePhotos,
              options: ['friends', 'everyone', 'private'],
              labels: ['Bạn bè', 'Mọi người', 'Chỉ tôi'],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _whoCanSeePhotos = value);
                }
              },
            ),
            _buildSwitchTile(
              icon: Icons.local_offer_outlined,
              title: 'Cho phép được tag',
              subtitle: 'Bạn bè có thể tag bạn trong ảnh và bình luận',
              value: _allowTagging,
              onChanged: (value) {
                setState(() => _allowTagging = value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.location_on_outlined,
              title: 'Chia sẻ vị trí',
              subtitle: 'Hiển thị vị trí khi đăng ảnh',
              value: _locationSharing,
              onChanged: (value) {
                setState(() => _locationSharing = value);
              },
            ),

            // Social Interactions
            _buildSectionHeader('Tương tác xã hội'),
            _buildSwitchTile(
              icon: Icons.person_add_outlined,
              title: 'Cho phép lời mời kết bạn',
              subtitle: 'Người khác có thể gửi lời mời kết bạn',
              value: _allowFriendRequests,
              onChanged: (value) {
                setState(() => _allowFriendRequests = value);
              },
            ),
            _buildDropdownTile(
              icon: Icons.message_outlined,
              title: 'Ai có thể nhắn tin',
              subtitle: 'Kiểm soát ai có thể gửi tin nhắn cho bạn',
              value: _whoCanMessage,
              options: ['friends', 'everyone', 'nobody'],
              labels: ['Bạn bè', 'Mọi người', 'Không ai'],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _whoCanMessage = value);
                }
              },
            ),
            _buildSwitchTile(
              icon: Icons.photo_album_outlined,
              title: 'Lời mời album',
              subtitle: 'Cho phép bạn bè mời bạn vào album',
              value: _albumInvitePermission,
              onChanged: (value) {
                setState(() => _albumInvitePermission = value);
              },
            ),

            // Data & Analytics
            _buildSectionHeader('Dữ liệu và phân tích'),
            _buildSwitchTile(
              icon: Icons.analytics_outlined,
              title: 'Phân tích dữ liệu',
              subtitle: 'Cho phép thu thập dữ liệu để cải thiện ứng dụng',
              value: _dataAnalytics,
              onChanged: (value) {
                setState(() => _dataAnalytics = value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.tune_outlined,
              title: 'Cá nhân hóa',
              subtitle: 'Sử dụng dữ liệu để cá nhân hóa trải nghiệm',
              value: _personalization,
              onChanged: (value) {
                setState(() => _personalization = value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.bug_report_outlined,
              title: 'Báo cáo lỗi',
              subtitle: 'Tự động gửi báo cáo lỗi để cải thiện ứng dụng',
              value: _crashReports,
              onChanged: (value) {
                setState(() => _crashReports = value);
              },
            ),

            // Account Management
            _buildSectionHeader('Quản lý tài khoản'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.download_outlined,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Tải xuống dữ liệu',
                      style: GoogleFonts.inika(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    subtitle: Text(
                      'Tải xuống bản sao dữ liệu cá nhân',
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: const Color(0xFF6D4C41),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      SnackBarHelper.showInfo(context, 'Tính năng tải xuống dữ liệu đang được phát triển');
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Xóa tài khoản',
                      style: GoogleFonts.inika(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      'Xóa vĩnh viễn tài khoản và dữ liệu',
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: const Color(0xFF6D4C41),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.red,
                    ),
                    onTap: () {
                      _showDeleteAccountDialog();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xóa tài khoản',
            style: GoogleFonts.inika(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3E2723),
            ),
          ),
          content: Text(
            'Bạn có chắc muốn xóa tài khoản? Hành động này không thể hoàn tác và tất cả dữ liệu sẽ bị mất vĩnh viễn.',
            style: GoogleFonts.inika(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: GoogleFonts.inika(
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                SnackBarHelper.showInfo(context, 'Tính năng xóa tài khoản đang được phát triển');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Xóa tài khoản',
                style: GoogleFonts.inika(),
              ),
            ),
          ],
        );
      },
    );
  }
}