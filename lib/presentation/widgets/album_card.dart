import 'package:flutter/material.dart';
import '../../domain/entities/album.dart';
import '../../core/constants/app_dimensions.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const AlbumCard({
    super.key,
    required this.album,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.albumCardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.albumCardRadius,
                    ),
                    child: Image.network(
                      album.coverImageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          album.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: album.isFavorite
                              ? Colors.red
                              : Colors.grey[600],
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '${album.filesCount} files',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                album.timeAgo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      _ParticipantAvatars(
                        avatars: album.participantAvatars,
                        additionalCount: album.additionalParticipants,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantAvatars extends StatelessWidget {
  final List<String> avatars;
  final int additionalCount;

  const _ParticipantAvatars({
    required this.avatars,
    required this.additionalCount,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = avatars.length.clamp(0, 2);
    final totalWidth =
        (displayCount * AppDimensions.participantAvatarSize * 0.7) +
        (additionalCount > 0 ? AppDimensions.participantAvatarSize * 0.7 : 0) +
        AppDimensions.participantAvatarSize * 0.3;

    return SizedBox(
      width: totalWidth,
      height: AppDimensions.participantAvatarSize,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * AppDimensions.participantAvatarSize * 0.6,
              child: Container(
                width: AppDimensions.participantAvatarSize,
                height: AppDimensions.participantAvatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: AppDimensions.participantAvatarSize / 2,
                  backgroundImage: NetworkImage(avatars[i]),
                ),
              ),
            ),
          if (additionalCount > 0)
            Positioned(
              left: displayCount * AppDimensions.participantAvatarSize * 0.6,
              child: Container(
                width: AppDimensions.participantAvatarSize,
                height: AppDimensions.participantAvatarSize,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$additionalCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
