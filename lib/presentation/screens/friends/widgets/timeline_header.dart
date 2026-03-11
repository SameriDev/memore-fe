import 'package:flutter/material.dart';
import '../../../widgets/universal_avatar.dart';

class TimelineHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onMenuTap;
  final String? username;
  final int? friendsCount;
  final int? imagesCount;

  const TimelineHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    this.onMenuTap,
    this.username,
    this.friendsCount,
    this.imagesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar với viền vàng bằng Universal Avatar Widget
          UniversalAvatar(
            avatarUrl: avatarUrl,
            radius: 50.0, // 100/2
            borderColor: const Color(0xFFD4AF37), // Màu vàng gold
            borderWidth: 4.0,
            fallbackText: name,
          ),
          const SizedBox(width: 16),
          // Thông tin người dùng
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inika',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (username != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '@$username',
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 13,
                      color: Color(0xFF797878),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  isOnline ? 'Đang hoạt động' : 'Không hoạt động',
                  style: TextStyle(
                    fontFamily: 'Inika',
                    fontSize: 14,
                    color: isOnline ? const Color(0xFF4CAF50) : const Color(0xFF797878),
                  ),
                ),
                if (friendsCount != null || imagesCount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (friendsCount != null) '$friendsCount bạn bè',
                      if (imagesCount != null) '$imagesCount ảnh',
                    ].join(' · '),
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 13,
                      color: Color(0xFF797878),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Menu button
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: onMenuTap,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
