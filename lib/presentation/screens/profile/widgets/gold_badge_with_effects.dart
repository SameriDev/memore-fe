import 'package:flutter/material.dart';
import 'dart:math' as math;

class GoldBadgeWithEffects extends StatelessWidget {
  final String badgeLevel;

  const GoldBadgeWithEffects({super.key, required this.badgeLevel});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: SizedBox(
        width: 92,
        height: 42,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Container(
                width: 92,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFBF04),
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            Positioned(
              left: -32,
              top: -32,
              child: Transform.rotate(
                angle: 50 * math.pi / 180,
                child: Container(
                  width: 35,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFEFBF04),
                        Colors.white.withOpacity(0.65),
                        Color(0xFFEFBF04),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: -4,
              child: Transform.rotate(
                angle: 50 * math.pi / 180,
                child: Container(
                  width: 35,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFEFBF04),
                        Colors.white.withOpacity(0.65),
                        Color(0xFFEFBF04),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: SizedBox(
                width: 92,
                height: 42,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.black, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        badgeLevel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242424),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
