# Repository Guidelines

## Project Structure & Module Organization
This is a Flutter app. Key locations:
- `lib/` is the main Dart/Flutter source code (entry points, features, UI).
- `assets/` holds images/fonts referenced in `pubspec.yaml`.
- `test/` contains Flutter tests (currently empty).
- Platform targets live in `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`.
- Project config lives in `pubspec.yaml` and lint rules in `analysis_options.yaml`.

## Build, Test, and Development Commands
Run these from the repository root:
- `flutter pub get` installs dependencies.
- `flutter run` launches the app on a connected device/emulator.
- `flutter test` runs unit/widget tests in `test/`.
- `flutter analyze` runs static analysis using `analysis_options.yaml`.
- `dart format .` formats Dart code (use before commits).
- `flutter build apk` or `flutter build appbundle` creates Android release builds.

## Coding Style & Naming Conventions
- Use Dart formatting (`dart format .`) and adhere to `flutter_lints`.
- Indentation: 2 spaces (Dart standard).
- File names: `snake_case.dart`.
- Types/classes: `UpperCamelCase`; functions/variables: `lowerCamelCase`.
- Tests: name files `*_test.dart` and keep one logical group per file.

## Testing Guidelines
- Use the default Flutter test framework (`flutter_test`).
- Place tests under `test/` and run with `flutter test`.
- No coverage target is documented; add tests for new features and bug fixes.

## Commit & Pull Request Guidelines
- Commit messages follow a conventional style seen in history:
  `feat: ...`, `fix: ...`, `build: ...` (lowercase type + colon + short summary).
- PRs should include:
  - A short summary of changes and rationale.
  - Linked issue/ticket if applicable.
  - Screenshots or a short recording for UI changes.
  - Platforms tested (e.g., Android emulator, iOS simulator).
