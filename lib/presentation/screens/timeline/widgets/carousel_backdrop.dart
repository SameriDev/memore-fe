import 'dart:ui';
import 'package:flutter/material.dart';

class CarouselBackdrop extends StatelessWidget {
  final String currentImage;
  final Widget child;

  const CarouselBackdrop({
    super.key,
    required this.currentImage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background image
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(currentImage),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Base image for blur
                  Image.network(
                    currentImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.black);
                    },
                  ),
                  // Blur effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          child,
        ],
      ),
    );
  }
}