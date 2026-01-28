import 'package:flutter/material.dart';
import '../../domain/entities/story.dart';
import 'story_carousel.dart';

class StoryOverlay extends StatefulWidget {
  final Story story;
  final VoidCallback onDismiss;

  const StoryOverlay({super.key, required this.story, required this.onDismiss});

  @override
  State<StoryOverlay> createState() => _StoryOverlayState();
}

class _StoryOverlayState extends State<StoryOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.story.images.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDismiss();
      });
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _handleDismiss,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 300) {
            _handleDismiss();
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              color: Colors.black.withOpacity(0.6 * _fadeAnimation.value),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: () {},
                    child: StoryCarousel(
                      images: widget.story.images,
                      userName: widget.story.userName,
                      onClose: _handleDismiss,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
