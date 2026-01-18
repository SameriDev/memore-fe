import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../providers/auth_provider.dart';

/// Welcome screen that introduces users to memore/Memore
/// Matches the memore design with dark background, phone mockup, and call-to-action buttons
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _phoneAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _phoneAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
              ),
              child: Column(
                children: [
                  // Top spacing
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // Phone mockup with widget demonstration
                  AnimatedBuilder(
                    animation: _phoneAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.7 + (0.3 * _phoneAnimation.value),
                        child: Opacity(
                          opacity: _phoneAnimation.value,
                          child: PhoneMockup(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // Logo and branding section
                  AnimatedBuilder(
                    animation: _contentAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                        child: Opacity(
                          opacity: _contentAnimation.value,
                          child: Column(
                            children: [
                              // memore logo and title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFFD700,
                                      ), // Yellow/gold
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFFD700,
                                          ).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacingMd),
                                  const Text(
                                    'memore',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: AppSizes.spacingMd),

                              // Tagline
                              const Text(
                                'Live pics from your friends,\\non your home screen',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFB3B3B3),
                                  height: 1.4,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: AppSizes.spacingXl),

                              // Create account button
                              SizedBox(
                                width: double.infinity,
                                height: AppSizes.buttonHeightSm,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.go('/auth/email-input');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD700),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const Text(
                                    'Create an account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSizes.spacingMd),

                              // Sign in button
                              TextButton(
                                onPressed: () async {
                                  // Bypass auth - set user as authenticated
                                  await ref
                                      .read(authProvider.notifier)
                                      .signIn(
                                        phoneNumber: '+1234567890',
                                        password: 'dummy',
                                      );
                                  ref
                                      .read(authProvider.notifier)
                                      .completeOnboarding();

                                  if (mounted) {
                                    context.go(AppRoutes.home);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFB3B3B3),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingLg,
                                    vertical: AppSizes.paddingMd,
                                  ),
                                ),
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Bottom spacing
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone mockup widget showing memore widget demonstration
class PhoneMockup extends StatelessWidget {
  final double height;

  const PhoneMockup({super.key, this.height = 580});

  @override
  Widget build(BuildContext context) {
    final width = height * 0.48; // Maintain aspect ratio

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: const Color(0xFF404040), width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          color: const Color(0xFF000000),
          child: Column(
            children: [
              // Status bar area
              const SizedBox(height: 40),

              // Home screen area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      // Highlight the memore widget (position 4)
                      if (index == 4) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFFD700),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              color: const Color(0xFF1A1A1A),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFFFFD700),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // Regular app icons
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF404040),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Home indicator
              Container(
                width: 150,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
