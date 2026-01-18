import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'providers/auth_provider.dart';
import 'presentation/screens/onboarding/splash_screen.dart';
import 'presentation/screens/onboarding/welcome_screen.dart';
import 'presentation/screens/onboarding/widget_demo_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/main_screen.dart';
import 'presentation/screens/camera/camera_screen.dart';
import 'presentation/screens/camera/photo_preview_screen.dart';
import 'presentation/screens/camera/friend_select_screen.dart';
import 'presentation/screens/auth/email_input_screen.dart';
import 'presentation/screens/auth/password_setup_screen.dart';
import 'presentation/screens/auth/name_setup_screen.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/auth/sign_in_screen.dart';
import 'presentation/screens/friends/add_friend_screen.dart';
import 'presentation/screens/friends/friends_list_screen.dart';
import 'presentation/screens/friends/friend_profile_screen.dart';
import 'presentation/screens/friends/friend_requests_screen.dart';
import 'presentation/screens/photos/photo_feed_screen.dart';
import 'presentation/screens/photos/photo_view_screen.dart';
import 'presentation/screens/photos/time_travel_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/settings/profile_screen.dart';
import 'presentation/screens/settings/edit_profile_screen.dart';
import 'presentation/screens/settings/notifications_screen.dart';
import 'presentation/screens/settings/privacy_screen.dart';
import 'presentation/screens/settings/blocked_users_screen.dart';
import 'presentation/screens/settings/storage_screen.dart';
import 'presentation/screens/settings/about_screen.dart';
import 'presentation/screens/messages/messages_screen.dart';
import 'presentation/screens/messages/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MemoreApp()));
}

/// Main application widget for Memore (memore clone)
/// Integrates Riverpod for state management and GoRouter for navigation
class MemoreApp extends ConsumerWidget {
  const MemoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppStrings.memoreAppName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // TODO: Add theme mode provider later
      // Router configuration
      routerConfig: router,

      // Localization (for future implementation)
      // locale: const Locale('en', 'US'),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', 'US'),
      // ],
    );
  }
}

/// GoRouter configuration with authentication-based routing
final routerProvider = Provider<GoRouter>((ref) {
  final authGuard = ref.watch(authGuardProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final currentLocation = state.uri.path;

      // Allow access to splash screen always
      if (currentLocation == AppRoutes.splash) {
        return null;
      }

      // Check if user can access the route
      if (!authGuard.canAccess(currentLocation)) {
        return authGuard.getRedirectRoute(currentLocation);
      }

      return null;
    },
    routes: [
      // Splash screen route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome/Onboarding routes
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: 'widget-demo',
            name: 'widget-demo',
            builder: (context, state) => const WidgetDemoScreen(),
          ),
        ],
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: 'email-input',
            name: 'email-input',
            builder: (context, state) => const EmailInputScreen(),
          ),
          GoRoute(
            path: 'password-setup',
            name: 'password-setup',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return PasswordSetupScreen(email: email);
            },
          ),
          GoRoute(
            path: 'name-setup',
            name: 'name-setup',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              final password = state.uri.queryParameters['password'] ?? '';
              return NameSetupScreen(email: email, password: password);
            },
          ),
          GoRoute(
            path: 'sign-in',
            name: 'sign-in',
            builder: (context, state) => const SignInScreen(),
          ),
        ],
      ),

      // Main app routes
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),

      GoRoute(
        path: AppRoutes.camera,
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
        routes: [
          GoRoute(
            path: 'photo-preview',
            name: 'photo-preview',
            builder: (context, state) {
              final photoPath = state.uri.queryParameters['photoPath'] ?? '';
              return PhotoPreviewScreen(photoPath: photoPath);
            },
          ),
          GoRoute(
            path: 'friend-select',
            name: 'friend-select',
            builder: (context, state) {
              final photoPath = state.uri.queryParameters['photoPath'] ?? '';
              return FriendSelectScreen(photoPath: photoPath);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.friends,
        name: 'friends',
        builder: (context, state) => const FriendsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-friend',
            builder: (context, state) => const AddFriendScreen(),
          ),
          GoRoute(
            path: 'profile',
            name: 'friend-profile',
            builder: (context, state) {
              final friendId = state.uri.queryParameters['friendId'] ?? '';
              return FriendProfileScreen(friendId: friendId);
            },
          ),
          GoRoute(
            path: 'requests',
            name: 'friend-requests',
            builder: (context, state) => const FriendRequestsScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.photoFeed,
        name: 'photo-feed',
        builder: (context, state) => const PhotoFeedScreen(),
        routes: [
          GoRoute(
            path: 'view',
            name: 'photo-view',
            builder: (context, state) {
              final photoId = state.uri.queryParameters['photoId'] ?? '';
              return PhotoViewScreen(photoId: photoId);
            },
          ),
          GoRoute(
            path: 'time-travel',
            name: 'time-travel',
            builder: (context, state) => const TimeTravelScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.messages,
        name: 'messages',
        builder: (context, state) => const MessagesScreen(),
        routes: [
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (context, state) {
              final userId = state.uri.queryParameters['userId'] ?? '';
              final userName = state.uri.queryParameters['userName'] ?? 'User';
              return ChatScreen(userId: userId, userName: userName);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
            routes: [
              GoRoute(
                path: 'blocked',
                name: 'blocked-users',
                builder: (context, state) => const BlockedUsersScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'storage',
            name: 'storage',
            builder: (context, state) => const StorageScreen(),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
