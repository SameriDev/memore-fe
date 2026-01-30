import 'package:flutter/material.dart';
import '../../../../domain/entities/friend.dart';

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
          // Avatar
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: friend.isOnline
                  ? Border.all(color: const Color(0xFF4A90E2), width: 2)
                  : null,
            ),
            child: ClipOval(
              child: Image.network(
                friend.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Name
          Text(
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
          const SizedBox(height: 2),
          // Status
          Text(
            friend.lastActiveTime,
            style: const TextStyle(fontSize: 11, color: Color(0xFF797878)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
