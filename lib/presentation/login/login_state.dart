import 'package:flutter/foundation.dart';

@immutable
class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool rememberMe;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.rememberMe = false,
  });

  bool get canSubmit => email.isNotEmpty && password.isNotEmpty && isEmailValid && isPasswordValid && !isLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? rememberMe,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginState &&
        other.email == email &&
        other.password == password &&
        other.isLoading == isLoading &&
        other.isPasswordVisible == isPasswordVisible &&
        other.errorMessage == errorMessage &&
        other.isEmailValid == isEmailValid &&
        other.isPasswordValid == isPasswordValid &&
        other.rememberMe == rememberMe;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        isLoading.hashCode ^
        isPasswordVisible.hashCode ^
        errorMessage.hashCode ^
        isEmailValid.hashCode ^
        isPasswordValid.hashCode ^
        rememberMe.hashCode;
  }
}
