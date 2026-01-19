# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Memore is a Flutter photo-sharing widget app that allows users to share authentic moments within a small circle of up to 20 friends/family. The app focuses on intimate, real-time photo sharing that appears directly on home screen widgets, emphasizing authentic connections over public validation.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run the app in development
flutter run

# Run on specific device
flutter run -d windows
flutter run -d android

# Clean and rebuild
flutter clean
flutter pub get

# Code analysis
flutter analyze
flutter analyze --suppress-analytics

# Build for release
flutter build apk --release
flutter build appbundle --release
```

### Testing and Quality
```bash
# Run tests
flutter test

# Analyze specific files
flutter analyze lib/presentation/screens/camera/ --suppress-analytics

# Build with dry-run for validation
flutter build apk --dry-run
timeout 30 flutter build apk --debug --target-platform android-arm64
```

## Architecture and Code Organization

### Project Structure
```
lib/
├── core/                    # Core functionality and constants
│   ├── constants/          # App-wide constants
│   │   ├── app_colors.dart      # Brown/tan theme color palette
│   │   ├── app_routes.dart      # Route definitions and navigation
│   │   ├── app_sizes.dart       # Spacing and size constants
│   │   └── app_strings.dart     # Text constants
│   └── theme/              # Theming configuration
│       ├── app_theme.dart       # Material Design 3 theme setup
│       └── text_styles.dart     # Typography definitions
├── data/                   # Data layer
│   └── models/            # Data models
│       ├── user_model.dart      # User data structure
│       ├── friend_model.dart    # Friend relationship model
│       ├── photo_model.dart     # Photo metadata model
│       └── notification_model.dart
├── providers/              # Riverpod state management
│   └── auth_provider.dart      # Authentication state management
├── presentation/           # UI layer
│   ├── screens/           # Screen implementations
│   │   ├── auth/         # Authentication flow (5 screens)
│   │   ├── camera/       # Photo capture flow (3 screens)
│   │   ├── friends/      # Friends management (4 screens)
│   │   ├── home/         # Main navigation screen
│   │   ├── messages/     # Chat functionality (2 screens)
│   │   ├── onboarding/   # App introduction (4 screens)
│   │   ├── photos/       # Photo viewing and feed (3 screens)
│   │   └── settings/     # User settings (8 screens)
│   └── widgets/          # Reusable UI components
└── main.dart              # App entry point with routing
```

### Tech Stack
- **Frontend**: Flutter with Material Design 3
- **State Management**: Riverpod (flutter_riverpod)
- **Navigation**: GoRouter with declarative routing
- **Camera**: Camera package for photo capture
- **Image Handling**: image_picker, cached_network_image
- **Backend**: Firebase (Auth, Firestore, Storage, FCM)
- **Planned Analytics**: Firebase Analytics, Crashlytics

### Design System

**Color Palette** (Brown/Tan Theme):
- Primary: `#8B4513` (SaddleBrown) - main brand color
- Background: `#FDF5E6` (OldLace) - warm white
- Surface: `#F5DEB3` (Wheat) - light tan
- Text: `#3E2723` (Dark brown) for main text
- Accent Gold: `#CD853F` (Peru) for highlights

**Key Constants**:
- All colors defined in `lib/core/constants/app_colors.dart`
- Spacing/sizing in `lib/core/constants/app_sizes.dart`
- Routes in `lib/core/constants/app_routes.dart`
- Text strings in `lib/core/constants/app_strings.dart`

### State Management Patterns

**Riverpod Architecture**:
- Use `ConsumerWidget` or `ConsumerStatefulWidget` for screens
- Read state with `ref.watch()` in build methods
- Modify state with `ref.read().notifier` in event handlers
- Auth state managed through `AuthProvider` with `AuthState` model

**Navigation Patterns**:
- Use `context.go()` for route replacement
- Use `context.push()` for stack-based navigation
- Use `context.pop()` to go back
- Route helpers in `AppRoutes` class for consistent navigation

### Current Implementation Status

**Completed Screens (11/28)**:
- Authentication: EmailInputScreen, PasswordSetupScreen, NameSetupScreen
- Camera: CameraScreen
- Friends: FriendsListScreen, AddFriendScreen
- Settings: SettingsScreen
- Onboarding: SplashScreen, WelcomeScreen, WidgetDemoScreen

**Key Remaining Screens**:
- Complete auth flow (AuthScreen, SignInScreen)
- Photo flow (PhotoFeedScreen, PhotoViewScreen, TimeTravelScreen)
- Camera flow completion (PhotoPreviewScreen, FriendSelectScreen)
- Settings completion (7 remaining screens)

### Firebase Integration (Planned)

**Services to Integrate**:
- **Firebase Auth**: Email/password authentication
- **Firestore**: User profiles, friend relationships, photo metadata
- **Cloud Storage**: Photo file storage with compression
- **Cloud Functions**: Image processing, push notifications
- **FCM**: Real-time photo delivery notifications

### Development Guidelines

**Code Patterns to Follow**:
1. Use existing constants from `lib/core/constants/` files
2. Follow brown/tan color scheme consistently
3. Implement proper error handling and loading states
4. Use Material Design 3 components and theming
5. Keep widgets focused and reusable
6. Follow existing folder structure and naming conventions

**Navigation Rules**:
- All routes defined in `AppRoutes` class
- Use route helpers for parameterized routes
- Maintain route groups for better organization
- Check auth requirements using `AppRoutes.requiresAuth()`

**State Management Rules**:
- Create providers for each major feature area
- Use immutable state models with copyWith methods
- Handle loading and error states consistently
- Separate business logic from UI components

### Testing Strategy

**Flutter Testing**:
- Widget tests for custom components
- Integration tests for user flows
- Unit tests for providers and models
- Golden tests for UI consistency

### Deployment Pipeline

**Release Process**:
1. Code analysis with `flutter analyze`
2. Build validation with `flutter build apk --dry-run`
3. Release build with `flutter build appbundle --release`
4. Google Play Store deployment
5. Firebase project configuration for backend features

This architecture supports the app's goal of creating intimate photo-sharing experiences while maintaining clean, scalable code structure.