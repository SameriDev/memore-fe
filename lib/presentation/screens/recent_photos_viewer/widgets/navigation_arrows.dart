import 'package:flutter/material.dart';

class NavigationArrows extends StatelessWidget {
  final int currentIndex;
  final int totalPhotos;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationArrows({
    super.key,
    required this.currentIndex,
    required this.totalPhotos,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    // Không hiển thị arrows nếu chỉ có 1 ảnh
    if (totalPhotos <= 1) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left arrow
            AnimatedOpacity(
              opacity: currentIndex > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: currentIndex == 0,
                child: _ArrowButton(
                  icon: Icons.chevron_left,
                  onTap: onPrevious,
                ),
              ),
            ),

            // Right arrow
            AnimatedOpacity(
              opacity: currentIndex < totalPhotos - 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: currentIndex == totalPhotos - 1,
                child: _ArrowButton(icon: Icons.chevron_right, onTap: onNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.black87, size: 28),
        ),
      ),
    );
  }
}
