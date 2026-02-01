import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'data/local/storage_service.dart';
import 'data/local/photo_storage_manager.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/auth/welcome_screen.dart';
import 'presentation/screens/auth/otp_verification_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/gallery/gallery_screen.dart';

void main() async {
  // Ensure flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize local storage
  try {
    await StorageService.instance.initialize();
    await PhotoStorageManager.instance.initializeStorage();
  } catch (e) {
    debugPrint('Storage initialization failed: $e');
  }

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
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/main': (context) => const MainScreen(),
        '/gallery': (context) => const GalleryScreen(),
      },
    );
  }
}
