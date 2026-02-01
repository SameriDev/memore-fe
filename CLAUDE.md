# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Memore is a Flutter photo-sharing app that allows users to share authentic moments within a small circle of friends and family. The app focuses on intimate, real-time photo sharing with albums, timeline features, and camera integration, emphasizing authentic connections over public validation.

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

### Actual Project Structure
```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants and configuration
│   │   ├── app_constants.dart      # Global constants
│   │   ├── app_dimensions.dart     # UI dimensions and spacing
│   │   └── app_routes.dart         # Route definitions
│   ├── errors/                     # Error handling
│   │   ├── exceptions.dart         # Custom exceptions
│   │   └── failures.dart           # Failure models
│   ├── network/                    # Network utilities
│   │   └── network_info.dart       # Network status checking
│   ├── theme/                      # App theming
│   │   ├── app_colors.dart         # Brown/tan color palette
│   │   └── app_theme.dart          # Material Design 3 theme
│   └── utils/                      # Utilities and type definitions
│       └── typedef.dart            # Common type definitions
├── data/                           # Data layer
│   └── mock/                       # Mock data for development
│       ├── mock_albums_data.dart   # Sample album data
│       ├── mock_friends_data.dart  # Sample friend data
│       └── mock_user_profile.dart  # Sample user data
├── domain/                         # Business logic layer
│   ├── entities/                   # Core business entities
│   │   ├── album.dart              # Album entity
│   │   ├── friend.dart             # Friend entity
│   │   ├── story.dart              # Story entity
│   │   ├── timeline_photo.dart     # Timeline photo entity
│   │   └── user_profile.dart       # User profile entity
│   └── usecases/                   # Business use cases
│       └── usecase.dart            # Base use case interface
├── presentation/                   # UI layer
│   ├── animations/                 # Custom animations
│   ├── routes/                     # Custom route handling
│   ├── screens/                    # Screen implementations
│   │   ├── auth/                   # Authentication flow
│   │   ├── camera/                 # Photo capture
│   │   ├── friends/                # Friends management
│   │   ├── home/                   # Home screen
│   │   ├── profile/                # User profile
│   │   ├── recent_photos_viewer/   # Photo viewing
│   │   ├── splash/                 # Splash screen
│   │   └── timeline/               # Timeline features
│   └── widgets/                    # Reusable UI components
└── main.dart                       # App entry point
```

### Tech Stack
- **Frontend**: Flutter with Material Design 3
- **State Management**: Currently using basic StatefulWidget (Riverpod planned)
- **Navigation**: MaterialApp with named routes (GoRouter planned)
- **Camera**: Camera package for photo capture
- **Image Handling**: image_picker, cached_network_image, photo_view
- **UI Components**: flutter_svg, figma_squircle, google_fonts
- **Utilities**: intl, uuid, dartz for functional programming
- **Backend**: Firebase integration planned

### Design System

**Color Palette** (Brown/Tan Theme):
- Primary: Brown tones for main brand colors
- Warm, earth-tone color palette throughout the app
- Colors defined in `lib/core/theme/app_colors.dart`

**Key Constants**:
- All colors defined in `lib/core/theme/app_colors.dart`
- Dimensions and spacing in `lib/core/constants/app_dimensions.dart`
- App-wide constants in `lib/core/constants/app_constants.dart`
- Routes in `lib/core/constants/app_routes.dart`

### Current Implementation Architecture

**Entity-Driven Design**:
- Business entities in `lib/domain/entities/` (Album, Friend, Story, UserProfile, etc.)
- Mock data providers in `lib/data/mock/` for development
- Clean separation between domain, data, and presentation layers

**Navigation**:
- Currently using MaterialApp with named routes in `main.dart`
- Routes: `/welcome`, `/login`, `/register`, `/otp`, `/main`, `/home`
- Custom page route animations in `lib/presentation/routes/`

**UI Components**:
- Reusable widgets in `lib/presentation/widgets/`
- Screen-specific widgets organized in widget folders within each screen
- Custom animations and transitions

### Current Implementation Status

**Completed Screens**:
- **Auth Flow**: WelcomeScreen, LoginScreen, RegisterScreen, OtpVerificationScreen
- **Main App**: MainScreen, SplashScreen
- **Camera**: CameraScreen with full camera functionality
- **Friends**: Multiple friend-related screens including timeline
- **Profile**: ProfileScreen with user profile features
- **Recent Photos**: Photo viewer with navigation and animations
- **Timeline**: Timeline features with album carousel

**Core Features Implemented**:
- Camera integration with photo capture
- Photo viewing with custom animations
- Friends management and timeline
- User profile system
- Navigation between screens
- Mock data integration

### Key Dependencies and Usage

**Major Packages**:
- `flutter_riverpod: ^2.4.9` - State management (planned integration)
- `go_router: ^12.1.3` - Navigation (not yet integrated)
- `camera: ^0.10.5+5` - Camera functionality
- `image_picker: ^1.0.4` - Photo selection
- `flutter_svg: ^2.0.9` - SVG icon support
- `cached_network_image: ^3.3.0` - Image caching
- `google_fonts: ^6.1.0` - Typography
- `photo_view: ^0.15.0` - Photo viewing with zoom
- `figma_squircle: ^0.6.3` - Custom rounded rectangles

### Development Guidelines

**Code Organization Patterns**:
1. Follow the domain-data-presentation architecture currently in place
2. Use existing constants from `lib/core/constants/` and `lib/core/theme/` files
3. Create entity models in `lib/domain/entities/` for new features
4. Add mock data in `lib/data/mock/` for development
5. Keep screen-specific widgets in widget subfolders within each screen directory
6. Use the existing brown/tan color scheme from `app_colors.dart`

**Navigation Patterns**:
- Currently using MaterialApp with named routes
- Route definitions in main.dart routes map
- Custom transitions in `lib/presentation/routes/` for complex animations
- Use `Navigator.pushNamed()` for navigation between screens

**Widget Architecture**:
- Break complex screens into smaller widget components
- Use StatefulWidget for screens requiring state management
- Organize widgets in dedicated folders per screen
- Leverage existing reusable widgets from `lib/presentation/widgets/`

**Error Handling**:
- Custom exceptions defined in `lib/core/errors/exceptions.dart`
- Failure models in `lib/core/errors/failures.dart`
- Network status checking utilities available in `lib/core/network/`

### Migration Plan

The project is currently in transition with several modern Flutter patterns planned:
- **State Management**: Riverpod integration planned (flutter_riverpod already added)
- **Navigation**: GoRouter migration planned (go_router already added)
- **Backend**: Firebase integration for authentication and data storage

### Development Notes

**Working with Mock Data**:
- Use existing mock data files in `lib/data/mock/` for development
- Mock albums, friends, and user data available for testing features
- Update mock data when adding new entity properties

**Camera Integration**:
- Camera functionality implemented in `lib/presentation/screens/camera/`
- Custom camera controls and viewfinder widgets available
- Photo capture and message input features working

**Styling Consistency**:
- Use `AppTheme.lightTheme` and `AppTheme.darkTheme` from `app_theme.dart`
- Color constants available in `app_colors.dart`
- Dimension constants in `app_dimensions.dart` for consistent spacing

This architecture follows clean architecture principles while maintaining flexibility for the ongoing development of a photo-sharing social app.