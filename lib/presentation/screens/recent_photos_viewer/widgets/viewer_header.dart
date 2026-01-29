import 'package:flutter/material.dart';

class ViewerHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final VoidCallback onClose;

  const ViewerHeader({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 40.0,
        bottom: 12.0,
      ),
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(userAvatar),
            backgroundColor: Colors.grey[300],
          ),

          const SizedBox(width: 12),

          // User name
          Expanded(
            child: Text(
              userName,
              style: const TextStyle(
                fontFamily: 'Inika',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 12),

          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
