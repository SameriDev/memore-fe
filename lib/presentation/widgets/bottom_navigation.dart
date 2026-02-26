import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool hideNavItems;
  final Animation<double>? navItemsAnimation;
  const BottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.hideNavItems = false,
    this.navItemsAnimation,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
                _SlidingIndicator(currentIndex: widget.currentIndex),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _AnimatedNavItem(
                          icon: Icons.people_outline,
                          isActive: widget.currentIndex == 0,
                          onTap: () => widget.onTap?.call(0),
                          hideAnimation: widget.navItemsAnimation,
                        ),
                        _AnimatedNavItem(
                          icon: Icons.image_outlined,
                          isActive: widget.currentIndex == 1,
                          onTap: () => widget.onTap?.call(1),
                          hideAnimation: widget.navItemsAnimation,
                        ),
                        const SizedBox(width: 80),
                        _AnimatedNavItem(
                          icon: Icons.grid_view_outlined,
                          isActive: widget.currentIndex == 3,
                          onTap: () => widget.onTap?.call(3),
                          hideAnimation: widget.navItemsAnimation,
                        ),
                        _AnimatedNavItem(
                          icon: Icons.person_outline,
                          isActive: widget.currentIndex == 4,
                          onTap: () => widget.onTap?.call(4),
                          hideAnimation: widget.navItemsAnimation,
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
                      isActive: widget.currentIndex == 2,
                      onTap: () => widget.onTap?.call(2),
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

class _AnimatedNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Animation<double>? hideAnimation;

  const _AnimatedNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.hideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (hideAnimation != null) {
      return AnimatedBuilder(
        animation: hideAnimation!,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - hideAnimation!.value,
            child: Transform.scale(
              scale: 1.0 - (hideAnimation!.value * 0.5),
              child: child,
            ),
          );
        },
        child: _NavItem(icon: icon, isActive: isActive, onTap: onTap),
      );
    }

    return _NavItem(icon: icon, isActive: isActive, onTap: onTap);
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 60,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.black,
                size: isActive ? 26 : 24,
              ),
            ],
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
      behavior: HitTestBehavior.opaque,
      child: Hero(
        tag: 'camera_button',
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFA500), width: 6),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
