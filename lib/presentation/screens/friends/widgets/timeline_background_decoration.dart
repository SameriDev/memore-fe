import 'package:flutter/material.dart';

class TimelineBackgroundDecoration extends StatelessWidget {
  const TimelineBackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Các hình tròn decor
        // Top right - small gray
        Positioned(
          right: 40,
          top: 220,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.5),
            ),
          ),
        ),
        // Top left - medium gray
        Positioned(
          left: 80,
          top: 250,
          child: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.4),
            ),
          ),
        ),
        // Left small
        Positioned(
          left: 17,
          top: 278,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.6),
            ),
          ),
        ),
        // Middle left - medium
        Positioned(
          left: 28,
          top: 400,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.3),
            ),
          ),
        ),
        // Middle - small
        Positioned(
          left: 115,
          top: 540,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.5),
            ),
          ),
        ),
        // Bottom left - large orange
        Positioned(
          left: -32,
          top: 752,
          child: Container(
            width: 113,
            height: 113,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD4A3).withOpacity(0.6),
            ),
          ),
        ),
        // Right side decorations
        Positioned(
          right: 10,
          top: 380,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD9D9D9).withOpacity(0.4),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 650,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE5E5E5).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
