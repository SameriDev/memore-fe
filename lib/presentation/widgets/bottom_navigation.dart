import 'package:flutter/material.dart';
import 'dart:ui';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavigation({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
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
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      );
    }

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black, size: 24),
      iconSize: 24,
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
