import 'dart:ui';
import 'package:flutter/material.dart';

class StoryStackCard extends StatelessWidget {
  final String imageUrl;
  final bool isMain;
  final double rotation;
  final double scale;
  final String? placeholderText;

  const StoryStackCard({
    super.key,
    required this.imageUrl,
    this.isMain = true,
    this.rotation = 0,
    this.scale = 1.0,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isMain ? 22 : 21),
          boxShadow: isMain
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.61),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMain ? 22 : 21),
          child: isMain
              ? Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Text(
                      placeholderText ?? imageUrl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1.75, sigmaY: 1.75),
                  child: Container(
                    color: Colors.grey[700],
                    child: Center(
                      child: Text(
                        placeholderText ?? imageUrl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
