import 'package:flutter/material.dart';
import '../../../data/mock/mock_user_profile.dart';
import '../../../domain/entities/user_profile.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_badges.dart';
import 'widgets/profile_setting_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile user;

  @override
  void initState() {
    super.initState();
    user = MockUserProfile.getCurrentUser();
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
                    Center(child: ProfileHeader(user: user)),
                    const SizedBox(height: 20),
                    // Badges
                    Center(
                      child: ProfileBadges(
                        badgeLevel: user.badgeLevel,
                        streakCount: user.streakCount,
                      ),
                    ),
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
                      svgAsset: 'assets/icons/ix_user-profile-filled.svg',
                      title: 'Edit profile picture',
                      onTap: () {
                        debugPrint('Edit profile picture tapped');
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      svgAsset: 'assets/icons/tdesign_rename-filled.svg',
                      title: 'Edit profile name',
                      onTap: () {
                        debugPrint('Edit profile name tapped');
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      icon: Icons.cake,
                      title: 'Edit birthday',
                      onTap: () {
                        debugPrint('Edit birthday tapped');
                      },
                    ),
                    const SizedBox(height: 8),
                    ProfileSettingItem(
                      icon: Icons.mail,
                      title: 'Change mail address',
                      onTap: () {
                        debugPrint('Change mail address tapped');
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
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/welcome', (route) => false);
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
