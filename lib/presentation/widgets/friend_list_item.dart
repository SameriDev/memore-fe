import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/friend.dart';
import 'universal_avatar.dart';

class FriendListItem extends StatelessWidget {
  final Friend friend;
  final VoidCallback? onMessageTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onTap;

  const FriendListItem({
    super.key,
    required this.friend,
    this.onMessageTap,
    this.onMoreTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Avatar với Universal Avatar Widget
            UniversalAvatar.medium(
              avatarUrl: friend.avatarUrl,
              showOnlineStatus: true,
              isOnline: friend.isOnline,
              borderColor: friend.isOnline ? const Color(0xFF4A90E2) : null,
              fallbackText: friend.name,
              onTap: onTap,
            ),
            const SizedBox(width: 12),
            // Name and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    friend.lastActiveTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF797878),
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/uil_message.svg',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onMessageTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 24),
                  onPressed: onMoreTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
