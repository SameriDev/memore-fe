import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../providers/auth_provider.dart';

/// Splash screen that displays the app logo and handles initial routing
/// Shows for 2-3 seconds while checking authentication state
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _handleInitialRouting();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  void _handleInitialRouting() {
    // Wait for minimum splash screen duration and auth state to load
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final authState = ref.read(authProvider);

      // Navigate based on auth state
      if (authState.isAuthenticated) {
        if (authState.hasCompletedOnboarding) {
          // User is authenticated and onboarded - go to home
          context.go(AppRoutes.home);
        } else {
          // User is authenticated but hasn't completed onboarding
          context.go(AppRoutes.onboarding);
        }
      } else {
        // User is not authenticated - go to welcome/onboarding
        context.go(AppRoutes.welcome);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Handle auth state changes during splash if needed
      if (next.error != null) {
        // If there's an auth error during splash, proceed to welcome
        context.go(AppRoutes.welcome);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo with animations
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: AppSizes.logoSize,
                          height: AppSizes.logoSize,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: AppSizes.iconSizeXl + 16,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spacingLg),

                // App name with fade animation
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            AppStrings.memoreAppName,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacingSm),
                          Text(
                            'Share moments with friends',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSizes.spacing3xl),

                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: AppSizes.loadingIndicatorSize,
                            height: AppSizes.loadingIndicatorSize,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacingMd),
                          Text(
                            AppStrings.loading,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Alternative minimalist splash screen for faster loading
class MinimalSplashScreen extends StatelessWidget {
  const MinimalSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Icon(
          Icons.camera_alt_rounded,
          size: AppSizes.iconSizeXl + 16,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}