import 'package:flutter/material.dart';

class CustomRouteTransitions {
  // Slide transition from right to left (default)
  static Route<T> slideFromRight<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Slide transition from bottom to top (modal style)
  static Route<T> slideFromBottom<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Fade transition
  static Route<T> fadeTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        var tween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Scale transition (for modals and overlays)
  static Route<T> scaleTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeOutBack;

        var scaleTween = Tween(begin: 0.8, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeOut),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  // Rotation and scale transition (for special effects)
  static Route<T> rotationScaleTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        var scaleTween = Tween(begin: 0.6, end: 1.0).chain(
          CurveTween(curve: curve),
        );
        var rotationTween = Tween(begin: 0.1, end: 0.0).chain(
          CurveTween(curve: curve),
        );
        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeOut),
        );

        return RotationTransition(
          turns: animation.drive(rotationTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // Shared axis transition (Material Design)
  static Route<T> sharedAxisTransition<T extends Object?>(Widget page, {bool isForward = true}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        final direction = isForward ? 1.0 : -1.0;

        // Primary transition
        var primarySlide = Tween(
          begin: Offset(0.3 * direction, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        var primaryFade = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
        );

        // Secondary transition (exit animation)
        if (secondaryAnimation.status == AnimationStatus.forward) {
          var secondarySlide = Tween(
            begin: Offset.zero,
            end: Offset(-0.3 * direction, 0.0),
          ).chain(CurveTween(curve: curve));

          var secondaryFade = Tween(begin: 1.0, end: 0.0).chain(
            CurveTween(curve: const Interval(0.4, 1.0, curve: Curves.easeIn)),
          );

          return SlideTransition(
            position: secondaryAnimation.drive(secondarySlide),
            child: FadeTransition(
              opacity: secondaryAnimation.drive(secondaryFade),
              child: SlideTransition(
                position: animation.drive(primarySlide),
                child: FadeTransition(
                  opacity: animation.drive(primaryFade),
                  child: child,
                ),
              ),
            ),
          );
        }

        return SlideTransition(
          position: animation.drive(primarySlide),
          child: FadeTransition(
            opacity: animation.drive(primaryFade),
            child: child,
          ),
        );
      },
    );
  }

  // Bounce transition (playful effect)
  static Route<T> bounceTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scaleTween = Tween(begin: 0.3, end: 1.0).chain(
          CurveTween(curve: Curves.elasticOut),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }
}

// Extension to make navigation easier
extension NavigationExtensions on BuildContext {
  // Navigate with slide from right (standard)
  Future<T?> pushSlideRight<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.slideFromRight<T>(page),
    );
  }

  // Navigate with slide from bottom (modal style)
  Future<T?> pushSlideBottom<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.slideFromBottom<T>(page),
    );
  }

  // Navigate with fade transition
  Future<T?> pushFade<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.fadeTransition<T>(page),
    );
  }

  // Navigate with scale transition
  Future<T?> pushScale<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.scaleTransition<T>(page),
    );
  }

  // Navigate with shared axis transition
  Future<T?> pushSharedAxis<T extends Object?>(Widget page, {bool isForward = true}) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.sharedAxisTransition<T>(page, isForward: isForward),
    );
  }

  // Navigate with bounce transition
  Future<T?> pushBounce<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      CustomRouteTransitions.bounceTransition<T>(page),
    );
  }

  // Replace with slide transition
  Future<T?> pushReplacementSlideRight<T extends Object?, TO extends Object?>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      CustomRouteTransitions.slideFromRight<T>(page),
    );
  }

  // Replace with fade transition
  Future<T?> pushReplacementFade<T extends Object?, TO extends Object?>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      CustomRouteTransitions.fadeTransition<T>(page),
    );
  }
}