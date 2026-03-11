import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../../widgets/universal_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar với Universal Avatar Widget
        UniversalAvatar.large(
          avatarUrl: user.avatarUrl,
          fallbackText: user.name,
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          user.name,
          style: const TextStyle(
            fontFamily: 'Inika',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        // Username
        Text(
          user.username,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        // Stats
        Text(
          '${user.friendsCount} Friends • ${user.imagesCount} Images',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
