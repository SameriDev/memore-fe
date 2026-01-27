import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'common/placeholder_screen.dart';
import '../widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1;
  int previousIndex = 1;

  final List<Widget> screens = [
    const PlaceholderScreen(title: 'Home Feed'),
    const HomeScreen(),
    const PlaceholderScreen(title: 'Camera'),
    const PlaceholderScreen(title: 'Timeline'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(currentIndex > previousIndex ? 1.0 : -1.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            child: KeyedSubtree(
              key: ValueKey(currentIndex),
              child: screens[currentIndex],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigation(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  previousIndex = currentIndex;
                  currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
