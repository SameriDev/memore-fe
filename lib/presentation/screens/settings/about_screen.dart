import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';

/// About Screen
/// Displays app information, version, and legal links
class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // App info
  final String _appVersion = '1.0.0';
  final String _buildNumber = '100';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showWebView(String title, String url) {
    // TODO: Implement web view or launch URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $title...'),
        backgroundColor: const Color(0xFF2A2A2A),
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'Memore',
      applicationVersion: 'Version $_appVersion',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFFFD700),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.photo_camera,
          color: Colors.black,
          size: 30,
        ),
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
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              children: [
                const SizedBox(height: AppSizes.spacingXl),

                // App logo and info
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                  child: _buildAppInfo(),
                ),

                const SizedBox(height: AppSizes.spacingXl * 2),

                // Links section
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                  child: _buildLinksSection(),
                ),

                const SizedBox(height: AppSizes.spacingXl),

                // Developer section
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 0.5),
                    child: child,
                  ),
                  child: _buildDeveloperSection(),
                ),

                const SizedBox(height: AppSizes.spacingXl * 2),

                // Footer
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) => Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  ),
                  child: _buildFooter(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        // App icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.photo_camera,
            color: Colors.black,
            size: 60,
          ),
        ),

        const SizedBox(height: AppSizes.spacingLg),

        // App name
        const Text(
          'Memore',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: AppSizes.spacingSm),

        // Version
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Version $_appVersion (Build $_buildNumber)',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: AppSizes.spacingLg),

        // Tagline
        const Text(
          'Share Moments with Your Loved Ones',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLinksSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
        ),
      ),
      child: Column(
        children: [
          _buildLinkTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () => _showWebView('Terms of Service', 'https://memore.app/terms'),
          ),
          _buildDivider(),
          _buildLinkTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showWebView('Privacy Policy', 'https://memore.app/privacy'),
          ),
          _buildDivider(),
          _buildLinkTile(
            icon: Icons.article_outlined,
            title: 'Open Source Licenses',
            onTap: _showLicenses,
          ),
          _buildDivider(),
          _buildLinkTile(
            icon: Icons.help_outline,
            title: 'Support Center',
            onTap: () => _showWebView('Support Center', 'https://memore.app/support'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
        ),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.code,
                color: Color(0xFFFFD700),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Made with Love',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.favorite,
                color: Color(0xFFEF4444),
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: AppSizes.spacingMd),

          const Text(
            'Memore is a photo sharing app inspired by Locket, built with Flutter for a seamless cross-platform experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Social links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.language,
                onTap: () => _showWebView('Website', 'https://memore.app'),
              ),
              const SizedBox(width: AppSizes.spacingMd),
              _buildSocialButton(
                icon: Icons.mail_outline,
                onTap: () => _showWebView('Contact', 'mailto:contact@memore.app'),
              ),
              const SizedBox(width: AppSizes.spacingMd),
              _buildSocialButton(
                icon: Icons.star_outline,
                onTap: () => _showWebView('Rate Us', 'https://memore.app/rate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          '© 2024 Memore Inc.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'All rights reserved',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: AppSizes.spacingLg),

        // Special thanks
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF404040),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD700),
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                'Thank you for using Memore!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD700),
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFFD700),
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
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF666666),
        size: 24,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF404040),
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFFD700),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFF404040).withValues(alpha: 0.3),
    );
  }
}