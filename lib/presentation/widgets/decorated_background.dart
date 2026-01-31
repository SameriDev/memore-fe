import 'package:flutter/material.dart';

class DecoratedBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? decorationColor;

  const DecoratedBackground({
    super.key,
    required this.child,
    this.backgroundColor,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? const Color(0xFFF4F2F0),
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
                    (decorationColor ?? const Color(0xFFFCBA03)).withOpacity(
                      0.20,
                    ),
                    (decorationColor ?? const Color(0xFFFCBA03)).withOpacity(
                      0.02,
                    ),
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
                    (decorationColor ?? const Color(0xFFFCBA03)).withOpacity(
                      0.20,
                    ),
                    (decorationColor ?? const Color(0xFFFCBA03)).withOpacity(
                      0.02,
                    ),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Main Content
          child,
        ],
      ),
    );
  }
}
