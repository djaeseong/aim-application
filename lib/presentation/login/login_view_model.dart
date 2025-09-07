import 'package:aim_application/presentation/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/injection.dart';
import '../../core/shared_preference.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  LoginState _state = const LoginState();

  LoginState get state => _state;

  void updateId(String id) {
    final isValid = _validateId(id);
    _updateState(_state.copyWith(email: id, isEmailValid: isValid, errorMessage: null));
  }

  void updatePassword(String password) {
    final isValid = _validatePassword(password);
    _updateState(_state.copyWith(password: password, isPasswordValid: isValid, errorMessage: null));
  }

  void togglePasswordVisibility() {
    _updateState(_state.copyWith(isPasswordVisible: !_state.isPasswordVisible));
  }

  void toggleRememberMe() {
    _updateState(_state.copyWith(rememberMe: !_state.rememberMe));
  }

  bool _validateId(String id) {
    if (id.isEmpty) return true; // Don't show error for empty field
    // ID validation: at least 4 characters, alphanumeric only
    if (id.length < 4) return false;
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) return true; // Don't show error for empty field
    return password.length >= 6; // Minimum password length
  }

  Future<void> login(BuildContext context) async {
    if (!_state.canSubmit) return;

    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get stored credentials from SharedPreferences
      String storedUserId = '';
      String storedPassword = '';

      try {
        if (GetIt.instance.isRegistered<SharedPreference>()) {
          final sharedPref = dl<SharedPreference>();
          storedUserId = await sharedPref.getUserId();
          storedPassword = await sharedPref.getPassword();
        }
      } catch (e) {
        print('Error accessing SharedPreferences: $e');
      }

      // Check if there are stored credentials
      bool loginSuccess = false;

      if (storedUserId.isNotEmpty && storedPassword.isNotEmpty) {
        // Compare with stored credentials
        if (_state.email == storedUserId && _state.password == storedPassword) {
          loginSuccess = true;
        }
      } else {
        // For demo purposes, allow test credentials if no stored credentials exist
        if (_state.email == 'testuser' && _state.password == 'password123') {
          loginSuccess = true;

          // Save credentials for future logins
          if (_state.rememberMe && GetIt.instance.isRegistered<SharedPreference>()) {
            final sharedPref = dl<SharedPreference>();
            await sharedPref.setUserId(_state.email);
            await sharedPref.setPassword(_state.password);
          }
        }
      }

      if (loginSuccess) {
        // Save credentials if remember me is checked
        if (_state.rememberMe && GetIt.instance.isRegistered<SharedPreference>()) {
          final sharedPref = dl<SharedPreference>();
          await sharedPref.setUserId(_state.email);
          await sharedPref.setPassword(_state.password);
        }

        _updateState(_state.copyWith(isLoading: false));

        // Navigate to main screen
        // Navigation will be handled by the screen
        context.goNamed(MainScreen.route);
      } else {
        throw Exception('Invalid ID or password');
      }
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: error.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithGoogle() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(isLoading: false));

      // Navigate to main screen
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: 'Google sign-in failed'));
    }
  }

  Future<void> loginWithApple() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement Apple Sign-In
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(isLoading: false));

      // Navigate to main screen
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: 'Apple sign-in failed'));
    }
  }

  Future<void> loginWithNaver() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement Apple Sign-In
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(isLoading: false));

      // Navigate to main screen
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: 'Apple sign-in failed'));
    }
  }

  Future<void> loginWithFacebook() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement Apple Sign-In
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(isLoading: false));

      // Navigate to main screen
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: 'Apple sign-in failed'));
    }
  }

  Future<void> loginWithKakao() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // TODO: Implement Apple Sign-In
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(isLoading: false));

      // Navigate to main screen
    } catch (error) {
      _updateState(_state.copyWith(isLoading: false, errorMessage: 'Apple sign-in failed'));
    }
  }

  void clearError() {
    _updateState(_state.copyWith(errorMessage: null));
  }

  void _updateState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }
}
