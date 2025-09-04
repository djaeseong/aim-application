# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AIM Application is a Flutter project that supports Android, iOS, web, and desktop platforms (macOS, Linux, Windows).

## Development Commands

### Core Commands
- `flutter run` - Run the app on connected device/emulator
- `flutter run -d chrome` - Run on Chrome browser
- `flutter run -d macos` - Run on macOS desktop
- `flutter test` - Run all widget tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter analyze` - Run static analysis
- `flutter pub get` - Install/update dependencies
- `flutter pub outdated` - Check for outdated packages
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires Mac with Xcode)
- `flutter build web` - Build for web deployment

### Hot Reload/Restart
During `flutter run`:
- Press `r` for hot reload (maintains state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

## Code Architecture

### Main Application Structure
The app follows standard Flutter architecture:
- **lib/main.dart**: Entry point containing `MyApp` (root widget) and `MyHomePage` (stateful widget example)
- **MaterialApp**: Root configuration for theming, routing, and app-level settings
- **State Management**: Currently uses basic `setState()` for the counter example

### Platform Support
- **Android**: Configuration in `android/` directory, using Gradle build system
- **iOS**: Configuration in `ios/` directory, Xcode project files
- **Web**: Configuration in `web/` directory with index.html and PWA manifest
- **Desktop**: Directories for `macos/`, `linux/`, `windows/` platforms

### Testing
- Widget tests located in `test/` directory
- Tests use `flutter_test` package with `WidgetTester` for UI interaction testing

### Configuration Files
- **pubspec.yaml**: Project dependencies, Flutter SDK version (^3.8.1), and asset declarations
- **analysis_options.yaml**: Dart analyzer configuration using `flutter_lints` package

## Project-Specific Notes

- Flutter SDK requirement: ^3.8.1
- Uses Material Design with customizable color scheme (currently deep purple seed color)
- App title: "AIM Application"
- Linting enabled via `flutter_lints: ^5.0.0`

## Development Workflow

1. Make code changes in `lib/` directory
2. Use hot reload for immediate UI updates during development
3. Run `flutter analyze` before committing to catch potential issues
4. Run tests with `flutter test` to ensure functionality
5. Build for target platform using appropriate `flutter build` command