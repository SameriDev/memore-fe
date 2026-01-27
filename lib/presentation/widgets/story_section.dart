import 'package:flutter/material.dart';
import '../../domain/entities/story.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';

class StorySection extends StatelessWidget {
  final List<Story> stories;
  final VoidCallback? onAddStory;
  final Function(Story)? onStoryTap;

  const StorySection({
    super.key,
    required this.stories,
    this.onAddStory,
    this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.storyAvatarSize + 16,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.horizontalPadding,
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
        child: Container(
          width: AppDimensions.storyAvatarSize,
          height: AppDimensions.storyAvatarSize,
          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.storyAvatarSize,
        height: AppDimensions.storyAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(width: 2, color: Colors.transparent),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(backgroundImage: NetworkImage(story.userAvatar)),
        ),
      ),
    );
  }
}
