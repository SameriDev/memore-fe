import 'package:flutter/material.dart';
import '../../domain/entities/story.dart';
import '../../core/constants/app_dimensions.dart';

class StorySection extends StatelessWidget {
  final List<Story> stories;
  final VoidCallback? onAddStory;
  final Function(Story)? onStoryTap;
  final VoidCallback? onMoreTap;

  const StorySection({
    super.key,
    required this.stories,
    this.onAddStory,
    this.onStoryTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.storyAvatarSize + 28,
      child: Stack(
        children: [
          ListView.separated(
            padding: EdgeInsets.only(
              left: AppDimensions.horizontalPadding,
              right:
                  AppDimensions.storyAvatarSize +
                  AppDimensions.storySpacing +
                  AppDimensions.horizontalPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppDimensions.storySpacing),
            itemBuilder: (context, index) {
              final story = stories[index];
              return _StoryAvatar(
                story: story,
                onTap: () {
                  if (story.isAddButton && onAddStory != null) {
                    onAddStory!();
                  } else if (onStoryTap != null) {
                    onStoryTap!(story);
                  }
                },
              );
            },
          ),
          Positioned(
            right: AppDimensions.horizontalPadding,
            top: 0,
            bottom: 0,
            child: Container(
              width: AppDimensions.storyAvatarSize + 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFF5F1EB).withOpacity(0),
                    const Color(0xFFF5F1EB),
                    const Color(0xFFF5F1EB),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onMoreTap,
                child: Container(
                  width: AppDimensions.storyAvatarSize,
                  height: AppDimensions.storyAvatarSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -6),
                      child: Text(
                        '...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          height: 1.0,
                        ),
                      ),
                    ),
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

class _StoryAvatar extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const _StoryAvatar({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (story.isAddButton) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.storyAvatarSize,
              height: AppDimensions.storyAvatarSize,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[700]!, width: 2.5),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 12),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.storyAvatarSize,
            height: AppDimensions.storyAvatarSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(1.5),
              child: CircleAvatar(
                backgroundImage: story.userAvatar.isNotEmpty
                    ? NetworkImage(story.userAvatar)
                    : null,
                child: story.userAvatar.isEmpty
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: AppDimensions.storyAvatarSize + 4,
            child: Text(
              story.userName,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
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
