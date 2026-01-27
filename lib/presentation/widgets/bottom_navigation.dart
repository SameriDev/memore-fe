import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavigation({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.75, sigmaY: 3.75),
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: const Color(0x75DADADA),
                        borderRadius: BorderRadius.circular(55),
                        border: Border.all(
                          color: const Color(0x29E2E2E2),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                _SlidingIndicator(currentIndex: currentIndex),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavItem(
                          icon: Icons.home_outlined,
                          isActive: currentIndex == 0,
                          onTap: () => onTap?.call(0),
                        ),
                        _NavItem(
                          icon: Icons.image_outlined,
                          isActive: currentIndex == 1,
                          onTap: () => onTap?.call(1),
                        ),
                        const SizedBox(width: 80),
                        _NavItem(
                          icon: Icons.grid_view_outlined,
                          isActive: currentIndex == 3,
                          onTap: () => onTap?.call(3),
                        ),
                        _NavItem(
                          icon: Icons.person_outline,
                          isActive: currentIndex == 4,
                          onTap: () => onTap?.call(4),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _CenterButton(
                      isActive: currentIndex == 2,
                      onTap: () => onTap?.call(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidingIndicator extends StatelessWidget {
  final int currentIndex;

  const _SlidingIndicator({required this.currentIndex});

  double _getLeftPosition(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - 24.0;
    final centerGap = 80.0;
    final sidePadding = 4.0;
    final availableForItems = navBarWidth - sidePadding * 2 - centerGap;
    final itemWidth = availableForItems / 4;

    switch (index) {
      case 0:
        return sidePadding;
      case 1:
        return sidePadding + itemWidth;
      case 3:
        return navBarWidth - sidePadding - itemWidth - 60;
      case 4:
        return navBarWidth - sidePadding - 60;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex == 2) return const SizedBox.shrink();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      left: _getLeftPosition(context, currentIndex),
      top: 2.5,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(currentIndex),
        duration: const Duration(milliseconds: 150),
        tween: Tween(begin: 0.8, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        child: Center(
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.black,
            size: isActive ? 26 : 24,
          ),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _CenterButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFA500), width: 6),
          color: Colors.white,
        ),
      ),
    );
  }
}
