import 'package:flutter/foundation.dart';

@immutable
class SplashState {
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;

  const SplashState({this.isLoading = true, this.isInitialized = false, this.errorMessage});

  // Computed properties
  bool get hasError => errorMessage != null;
  bool get isReady => isInitialized && !isLoading && !hasError;

  // Factory constructors for common states
  factory SplashState.initial() => const SplashState();

  factory SplashState.loading() => const SplashState(isLoading: true, isInitialized: false);

  factory SplashState.ready() => const SplashState(isLoading: false, isInitialized: true);

  factory SplashState.error(String message) =>
      SplashState(isLoading: false, isInitialized: false, errorMessage: message);

  SplashState copyWith({bool? isLoading, bool? isInitialized, String? errorMessage, bool clearError = false}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Creates a copy with error cleared
  SplashState clearError() {
    return copyWith(clearError: true);
  }

  /// Creates a copy in loading state
  SplashState toLoading() {
    return copyWith(isLoading: true, clearError: true);
  }

  /// Creates a copy in ready state
  SplashState toReady() {
    return copyWith(isLoading: false, isInitialized: true, clearError: true);
  }

  /// Creates a copy with error
  SplashState withError(String message) {
    return copyWith(isLoading: false, errorMessage: message);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SplashState &&
        other.isLoading == isLoading &&
        other.isInitialized == isInitialized &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(isLoading, isInitialized, errorMessage);

  @override
  String toString() {
    return 'SplashState('
        'isLoading: $isLoading, '
        'isInitialized: $isInitialized, '
        'errorMessage: $errorMessage'
        ')';
  }
}
