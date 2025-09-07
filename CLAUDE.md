# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AIM Application is a Flutter investment portfolio management app with MVVM architecture pattern. The app displays portfolio assets (stocks, bonds, cash) with visualizations and detailed information. All UI text is in Korean.

## Development Commands

### Core Commands
- `flutter run` - Run the app on connected device/emulator
- `flutter run -d chrome` - Run on Chrome browser  
- `flutter run -d macos` - Run on macOS desktop
- `flutter test` - Run all widget tests
- `flutter analyze` - Run static analysis (check for linting issues)
- `flutter pub get` - Install/update dependencies
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires Mac with Xcode)
- `flutter build web` - Build for web deployment

### Hot Reload/Restart
During `flutter run`:
- Press `r` for hot reload (maintains state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

### Code Generation
- `flutter pub run build_runner build` - Generate code for freezed/json_serializable
- `flutter pub run build_runner watch` - Watch mode for code generation

## Architecture & Patterns

### MVVM Pattern Structure
Each screen follows this structure:
```
lib/presentation/[screen_name]/
├── [screen_name]_screen.dart    # View (ConsumerWidget/HookConsumerWidget)
├── [screen_name]_view_model.dart # ViewModel (ChangeNotifier)
└── [screen_name]_state.dart     # State (immutable with copyWith)
```

### State Management
- **Riverpod** with `ChangeNotifierProvider.autoDispose` for ViewModels
- **State classes** are immutable with `copyWith()` methods
- **GetIt** for dependency injection (SharedPreferences, services)

### Navigation
- **GoRouter** for declarative routing
- Routes defined with static `route` constants in each screen
- Navigation through `context.goNamed()` or `context.pushNamed()`

### Dependency Flow
1. **main.dart** → Initializes GetIt dependencies via `injection.dart`
2. **SharedPreference** service registered in GetIt for auth state
3. **SplashScreen** checks auth → navigates to Login or Main
4. **Screens** use Riverpod providers for state management

### UI Components Organization
```
lib/ui_packages/
├── base/
│   ├── spacing.dart      # AimSpacing widgets (use instead of SizedBox)
│   └── config.dart       # UI configuration constants
└── widgets/
    ├── aim_text_field.dart    # Custom text input widgets
    ├── aim_logo.dart          # App logo component
    ├── pie_chart.dart         # Custom pie chart widget
    └── social_login_button.dart # Social login buttons
```

## Key Implementation Details

### Authentication Flow
- **SplashViewModel** checks `SharedPreference.getUserId()`
- Routes to `LoginScreen` if no user, `MainScreen` if authenticated
- Login credentials stored in SharedPreferences (ID and password)

### Mock Data Structure
- All portfolio data in `lib/utils/mock_data.dart`
- Asset types: 'stock', 'bond', 'etc' (cash)
- Each asset contains: symbol, name, description, quantity, ratio, type

### Form Validation Patterns
Sign-up validation requirements:
- **ID**: 7+ alphanumeric characters
- **Password**: 10+ chars with uppercase, lowercase, numbers, special chars
- **Phone**: Korean format (010-XXXX-XXXX)
- **Email**: Standard email format

### Screen-Specific Notes

**MainScreen**: 
- Dark theme (#2B3038 background)
- Pie chart visualization of portfolio distribution
- Assets grouped by type with color coding

**StockDetailScreen**:
- Mint background (#93D9D9)
- Shows all assets grouped by category
- Mock change percentages for each asset

## Important Conventions

### UI Spacing
**Never use SizedBox directly**. Use `AimSpacing` components from `lib/ui_packages/base/spacing.dart`:
- `AimSpacing.vert1` through `AimSpacing.vert20` for vertical spacing
- `AimSpacing.horiz1` through `AimSpacing.horiz20` for horizontal spacing

### Error Handling
- Always check `context.mounted` after async operations before using context
- Use `GetIt.instance.isRegistered<T>()` before accessing GetIt services
- Wrap SharedPreferences access in try-catch blocks

### Korean UI Text
All user-facing text should be in Korean. Common terms:
- 로그인 (Login)
- 회원가입 (Sign Up)
- 포트폴리오 (Portfolio)
- 주식형 자산 (Stock Assets)
- 채권형 자산 (Bond Assets)
- 기타 자산 (Other Assets)

## Environment Requirements

- Flutter SDK: ^3.8.1
- Dart SDK: Compatible with Flutter version
- Platforms: Android, iOS, Web, macOS, Linux, Windows