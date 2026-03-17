import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../widgets/app_popup.dart';
import '../../widgets/profile_edit_popup.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../data/local/user_manager.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_badges.dart';
import 'widgets/profile_setting_item.dart';
import '../settings/upgrade_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    // Load from local storage first (instant)
    final localProfile = UserManager.instance.toUserProfile();
    if (localProfile != null) {
      setState(() => user = localProfile);
    }

    // Delay API fetch để cho local changes time to settle, use real counts
    Future.delayed(const Duration(milliseconds: 500), () {
      UserManager.instance.fetchProfileWithRealCounts().then((freshProfile) {
        if (freshProfile != null && mounted) {
          setState(() => user = freshProfile);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      body: Stack(
        children: [
          // Decorative Ellipse - Top Right
          Positioned(
            top: -300,
            right: -300,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFCBA03).withOpacity(0.20),
                    const Color(0xFFFCBA03).withOpacity(0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Decorative Ellipse - Bottom Left
          Positioned(
            bottom: -200,
            left: -300,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFCBA03).withOpacity(0.20),
                    const Color(0xFFFCBA03).withOpacity(0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Main Content
          if (user == null)
            const Center(child: CircularProgressIndicator())
          else
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Profile Header
                    Center(child: ProfileHeader(user: user!)),
                    const SizedBox(height: 20),
                    // Badges
                    Center(
                      child: ProfileBadges(
                        badgeLevel: user!.badgeLevel,
                        streakCount: user!.streakCount,
                      ),
                    ),
                    // Subscription badge (only show for SILVER/GOLD)
                    if (user!.subscriptionPlan != 'FREE') ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: user!.subscriptionPlan == 'GOLD'
                                ? const Color(0xFFFCBA03).withValues(alpha: 0.15)
                                : const Color(0xFF90A4AE).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: user!.subscriptionPlan == 'GOLD'
                                  ? const Color(0xFFFCBA03)
                                  : const Color(0xFF90A4AE),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (user!.subscriptionPlan == 'GOLD')
                                const Icon(Icons.star, size: 14, color: Color(0xFFFCBA03)),
                              if (user!.subscriptionPlan == 'GOLD') const SizedBox(width: 4),
                              Text(
                                user!.subscriptionPlan,
                                style: GoogleFonts.inika(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: user!.subscriptionPlan == 'GOLD'
                                      ? const Color(0xFFFCBA03)
                                      : const Color(0xFF90A4AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    // General Section Title
                    const Text(
                      'General',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Settings List
                    ProfileSettingItem(
                      icon: Icons.workspace_premium,
                      title: 'Nâng cấp tài khoản',
                      onTap: () {
                        Navigator.pushNamed(context, '/upgrade');
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () async {
                        if (user != null) {
                          await showAppPopup<void>(
                            context: context,
                            builder: (ctx) => ProfileEditPopup(
                              user: user!,
                              onProfileUpdated: _loadProfile,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      icon: Icons.help_outline,
                      title: 'Get help',
                      onTap: () {
                        debugPrint('Get help tapped');
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () async {
                        // Show confirmation dialog
                        final shouldLogout = await showAppPopup<bool>(
                          context: context,
                          builder: (ctx) => AppPopup(
                            size: AppPopupSize.small,
                            title: 'Đăng xuất',
                            content: Text(
                              'Bạn có chắc chắn muốn đăng xuất?',
                              style: GoogleFonts.inika(color: const Color(0xFF3E2723)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: Text('Hủy', style: GoogleFonts.inika(color: const Color(0xFF8B4513))),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: Text('Đăng xuất', style: GoogleFonts.inika(color: const Color(0xFF8B4513))),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          // Perform logout
                          await UserManager.instance.logout();

                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
