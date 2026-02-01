import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_edit_screen.dart';
import 'notifications_settings_screen.dart';
import 'privacy_settings_screen.dart';
import '../../../data/local/user_manager.dart';
import '../../routes/custom_route_transitions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      currentUser = UserManager.instance.getCurrentUser();
    });
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      leading: Container(
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
      ),
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
      trailing: showArrow
          ? const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF8B4513),
            )
          : null,
      onTap: onTap,
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

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Đăng xuất',
            style: GoogleFonts.inika(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3E2723),
            ),
          ),
          content: Text(
            'Bạn có chắc muốn đăng xuất khỏi Memore?',
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
              onPressed: () async {
                Navigator.of(context).pop();
                await UserManager.instance.logout();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/welcome',
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Đăng xuất',
                style: GoogleFonts.inika(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Cài đặt',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            if (currentUser != null) ...[
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF8B4513),
                      child: Text(
                        (currentUser!['name'] as String).substring(0, 1).toUpperCase(),
                        style: GoogleFonts.inika(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser!['name'] ?? 'Người dùng',
                            style: GoogleFonts.inika(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentUser!['email'] ?? 'email@example.com',
                            style: GoogleFonts.inika(
                              fontSize: 14,
                              color: const Color(0xFF6D4C41),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Account Settings
            _buildSectionHeader('Tài khoản'),
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: 'Chỉnh sửa hồ sơ',
              subtitle: 'Thay đổi thông tin cá nhân',
              onTap: () {
                context.pushSlideRight(const ProfileEditScreen()).then((_) => _loadUserData());
              },
            ),

            // Privacy & Security
            _buildSectionHeader('Quyền riêng tư & Bảo mật'),
            _buildSettingsItem(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              subtitle: 'Quản lý cài đặt thông báo',
              onTap: () {
                context.pushSlideRight(const NotificationsSettingsScreen());
              },
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Quyền riêng tư',
              subtitle: 'Kiểm soát ai có thể xem nội dung của bạn',
              onTap: () {
                context.pushSlideRight(const PrivacySettingsScreen());
              },
            ),

            // App Settings
            _buildSectionHeader('Ứng dụng'),
            _buildSettingsItem(
              icon: Icons.photo_library_outlined,
              title: 'Thư viện ảnh',
              subtitle: 'Xem và quản lý ảnh đã lưu',
              onTap: () {
                Navigator.pushNamed(context, '/gallery');
              },
            ),
            _buildSettingsItem(
              icon: Icons.storage_outlined,
              title: 'Dữ liệu & Bộ nhớ',
              subtitle: 'Quản lý dung lượng lưu trữ',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tính năng đang được phát triển',
                      style: GoogleFonts.inika(),
                    ),
                    backgroundColor: const Color(0xFF8B4513),
                  ),
                );
              },
            ),

            // Support
            _buildSectionHeader('Hỗ trợ'),
            _buildSettingsItem(
              icon: Icons.help_outline,
              title: 'Trợ giúp & Hỗ trợ',
              subtitle: 'FAQ và liên hệ hỗ trợ',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tính năng đang được phát triển',
                      style: GoogleFonts.inika(),
                    ),
                    backgroundColor: const Color(0xFF8B4513),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              icon: Icons.info_outline,
              title: 'Về Memore',
              subtitle: 'Phiên bản 1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Memore',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF8B4513),
                    size: 48,
                  ),
                  children: [
                    Text(
                      'Ứng dụng chia sẻ ảnh trong nhóm bạn bè thân thiết',
                      style: GoogleFonts.inika(),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Đăng xuất',
                  style: GoogleFonts.inika(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}