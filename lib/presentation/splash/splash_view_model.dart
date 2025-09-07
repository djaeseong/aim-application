import 'package:aim_application/core/injection.dart';
import 'package:aim_application/presentation/login/login_screen.dart';
import 'package:aim_application/presentation/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/shared_preference.dart';
import 'splash_state.dart';

enum NavigationDestination { login, main }

class SplashViewModel extends ChangeNotifier {
  SplashState _state = SplashState.initial();
  NavigationDestination? _navigationDestination;

  SplashState get state => _state;
  NavigationDestination? get navigationDestination => _navigationDestination;

  // Constants
  static const _initializationDelay = Duration(seconds: 2);
  static const _debugMode = false;

  // Public methods
  Future<void> onInit(BuildContext context) async {
    // Use Future.delayed to avoid calling setState during build
    await Future.delayed(Duration.zero);
    await _initializeApp(context);
  }

  void retry(BuildContext context) {
    _resetState();
    onInit(context);
  }

  // Private methods
  Future<void> _initializeApp(BuildContext context) async {
    _updateState(_state.toLoading());

    try {
      await _performInitializationTasks();
      final userId = await _checkUserAuthentication();
      _navigateBasedOnAuth(context, userId);
      _updateState(_state.toReady());
    } catch (error) {
      _handleInitializationError(error);
    }
  }

  Future<void> _performInitializationTasks() async {
    // Simulate app initialization tasks (e.g., loading configs, checking updates)
    await Future.delayed(_initializationDelay);
  }

  Future<String> _checkUserAuthentication() async {
    try {
      if (GetIt.instance.isRegistered<SharedPreference>()) {
        final sharedPref = dl<SharedPreference>();
        return await sharedPref.getUserId();
      }
    } catch (e) {
      _logDebug('SharedPreferences not initialized or error: $e');
    }
    return '';
  }

  void _navigateBasedOnAuth(BuildContext context, String userId) {
    if (!context.mounted) return;

    if (userId.isNotEmpty) {
      _navigationDestination = NavigationDestination.main;
      context.goNamed(MainScreen.route);
    } else {
      _navigationDestination = NavigationDestination.login;
      context.goNamed(LoginScreen.route);
    }
  }

  void _handleInitializationError(Object error) {
    final errorMessage = _formatErrorMessage(error);
    _updateState(_state.withError(errorMessage));
  }

  String _formatErrorMessage(Object error) {
    return error.toString().replaceAll('Exception: ', '');
  }

  void _resetState() {
    _navigationDestination = null;
    _updateState(SplashState.initial());
  }

  void _logDebug(String message) {
    if (_debugMode) {
      debugPrint('[SplashViewModel] $message');
    }
  }

  void _updateState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
