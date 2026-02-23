import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';

class AlbumHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onAddTap;
  final int pendingInviteCount;
  final VoidCallback? onInvitesTap;
  final int unreadNotificationCount;
  final VoidCallback? onNotificationTap;

  const AlbumHeader({
    super.key,
    this.onSearchTap,
    this.onAddTap,
    this.pendingInviteCount = 0,
    this.onInvitesTap,
    this.unreadNotificationCount = 0,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
        vertical: AppDimensions.verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Albums',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              // Invite badge
              if (pendingInviteCount > 0)
                GestureDetector(
                  onTap: onInvitesTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mail_outline,
                            size: 18, color: Colors.brown),
                        const SizedBox(width: 4),
                        Text(
                          '$pendingInviteCount',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (pendingInviteCount > 0) const SizedBox(width: 8),
              // Notification bell
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(Icons.notifications_outlined, size: 26),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  if (unreadNotificationCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadNotificationCount > 9
                              ? '9+'
                              : '$unreadNotificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onSearchTap,
                icon: const Icon(Icons.search, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.darkBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
