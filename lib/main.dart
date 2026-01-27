import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  runApp(const MemoreApp());
}

class MemoreApp extends StatelessWidget {
  const MemoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
