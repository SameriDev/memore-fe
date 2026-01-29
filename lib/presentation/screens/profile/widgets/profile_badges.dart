import 'package:flutter/material.dart';
import 'gold_badge_with_effects.dart';

class ProfileBadges extends StatelessWidget {
  final String badgeLevel;
  final int streakCount;

  const ProfileBadges({
    super.key,
    required this.badgeLevel,
    required this.streakCount,
  });

  @override
  Widget build(BuildContext context) {
    final streakString = streakCount.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Enhanced GOLD Badge with effects
        GoldBadgeWithEffects(badgeLevel: badgeLevel),
        const SizedBox(width: 12),
        // Streak Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFF8026), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16, height: 1)),
              const SizedBox(width: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  streakString.length,
                  (index) => Transform.translate(
                    offset: Offset(0, index == 0 ? 0 : -2),
                    child: Text(
                      streakString[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF8026),
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
