import 'package:flutter/material.dart';
import '../../../../domain/entities/friend.dart';
import '../../../widgets/universal_avatar.dart';

class FriendGridItem extends StatelessWidget {
  final Friend friend;
  final VoidCallback? onTap;

  const FriendGridItem({super.key, required this.friend, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar với Universal Avatar Widget
          UniversalAvatar(
            avatarUrl: friend.avatarUrl,
            radius: 34.0, // 68/2
            borderColor: friend.isOnline ? const Color(0xFF4A90E2) : null,
            borderWidth: friend.isOnline ? 2.0 : 0.0,
            fallbackText: friend.name,
          ),
          const SizedBox(height: 6),
          // Name
          Flexible(
            child: Text(
              friend.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 1),
          // Status
          Flexible(
            child: Text(
              friend.lastActiveTime,
              style: const TextStyle(fontSize: 11, color: Color(0xFF797878)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
