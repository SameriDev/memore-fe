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
          IndexedStack(index: currentIndex, children: screens),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigation(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
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
