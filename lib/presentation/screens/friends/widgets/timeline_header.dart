import 'package:flutter/material.dart';

class TimelineHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final VoidCallback? onMenuTap;

  const TimelineHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar với viền vàng
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4AF37), // Màu vàng gold
                width: 4,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  );
                },
              ),
            ),
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
                const SizedBox(height: 4),
                Text(
                  isOnline ? 'Đang hoạt động' : 'Không hoạt động',
                  style: const TextStyle(
                    fontFamily: 'Inika',
                    fontSize: 14,
                    color: Color(0xFF797878),
                  ),
                ),
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
