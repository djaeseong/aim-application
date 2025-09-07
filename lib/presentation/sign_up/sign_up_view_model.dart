import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../core/injection.dart';
import '../../core/shared_preference.dart';
import 'sign_up_state.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpState _state = const SignUpState();

  SignUpState get state => _state;

  // Constants
  static const _idMinLength = 7;
  static const _passwordMinLength = 10;
  static const _phoneNumberLength = 11;
  static const _signUpDelay = Duration(seconds: 2);
  
  // Validation patterns
  static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final _idRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final _uppercaseRegex = RegExp(r'[A-Z]');
  static final _lowercaseRegex = RegExp(r'[a-z]');
  static final _digitRegex = RegExp(r'[0-9]');
  static final _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final _phoneDigitsRegex = RegExp(r'^[0-9]+$');
  
  static const _validPhonePrefixes = ['010', '011', '016', '017', '018', '019'];

  // Field update methods
  void updateId(String id) {
    final validation = _validateId(id);
    _updateState(
      _state.copyWith(
        id: id,
        isIdValid: validation.isValid,
        idErrorMessage: validation.errorMessage,
        errorMessage: null,
      ),
    );
  }

  void updatePassword(String password) {
    final validation = _validatePassword(password);
    final confirmValidation = _validateConfirmPassword(_state.confirmPassword, password);
    _updateState(
      _state.copyWith(
        password: password,
        isPasswordValid: validation.isValid,
        passwordErrorMessage: validation.errorMessage,
        isConfirmPasswordValid: confirmValidation.isValid,
        confirmPasswordErrorMessage: confirmValidation.errorMessage,
        errorMessage: null,
      ),
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    final validation = _validateConfirmPassword(confirmPassword, _state.password);
    _updateState(
      _state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordValid: validation.isValid,
        confirmPasswordErrorMessage: validation.errorMessage,
        errorMessage: null,
      ),
    );
  }

  void updatePhoneNumber(String phoneNumber) {
    final validation = _validatePhoneNumber(phoneNumber);
    _updateState(
      _state.copyWith(
        phoneNumber: phoneNumber,
        isPhoneNumberValid: validation.isValid,
        phoneNumberErrorMessage: validation.errorMessage,
        errorMessage: null,
      ),
    );
  }

  void updateEmail(String email) {
    final validation = _validateEmail(email);
    _updateState(
      _state.copyWith(
        email: email,
        isEmailValid: validation.isValid,
        emailErrorMessage: validation.errorMessage,
        errorMessage: null,
      ),
    );
  }
  
  // UI state toggles

  void togglePasswordVisibility() {
    _updateState(_state.copyWith(isPasswordVisible: !_state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    _updateState(_state.copyWith(isConfirmPasswordVisible: !_state.isConfirmPasswordVisible));
  }

  void toggleAgreedToTerms() {
    _updateState(_state.copyWith(agreedToTerms: !_state.agreedToTerms));
  }

  // Validation methods
  ValidationResult _validateId(String id) {
    if (id.isEmpty) return ValidationResult.valid();

    if (id.length < _idMinLength) {
      return ValidationResult.invalid('ID는 $_idMinLength자 이상이어야 합니다');
    }

    if (!_idRegex.hasMatch(id)) {
      return ValidationResult.invalid('ID는 영문자와 숫자만 사용 가능합니다');
    }

    return ValidationResult.valid();
  }

  ValidationResult _validatePassword(String password) {
    if (password.isEmpty) return ValidationResult.valid();

    if (password.length < _passwordMinLength) {
      return ValidationResult.invalid('비밀번호는 $_passwordMinLength자 이상이어야 합니다');
    }

    final requirements = [
      (_uppercaseRegex.hasMatch(password), '대문자를 1개 이상 포함해야 합니다'),
      (_lowercaseRegex.hasMatch(password), '소문자를 1개 이상 포함해야 합니다'),
      (_digitRegex.hasMatch(password), '숫자를 1개 이상 포함해야 합니다'),
      (_specialCharRegex.hasMatch(password), '특수문자를 1개 이상 포함해야 합니다'),
    ];

    for (final (isValid, errorMessage) in requirements) {
      if (!isValid) {
        return ValidationResult.invalid(errorMessage);
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult _validateConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) return ValidationResult.valid();

    if (confirmPassword != password) {
      return ValidationResult.invalid('비밀번호가 일치하지 않습니다');
    }

    return ValidationResult.valid();
  }

  ValidationResult _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return ValidationResult.valid();

    final cleanedNumber = phoneNumber.replaceAll('-', '');

    if (!_hasValidPhonePrefix(cleanedNumber)) {
      return ValidationResult.invalid('올바른 휴대폰 번호 형식이 아닙니다');
    }

    if (cleanedNumber.length != _phoneNumberLength) {
      return ValidationResult.invalid('휴대폰 번호는 $_phoneNumberLength자리여야 합니다');
    }

    if (!_phoneDigitsRegex.hasMatch(cleanedNumber)) {
      return ValidationResult.invalid('숫자만 입력 가능합니다');
    }

    return ValidationResult.valid();
  }
  
  bool _hasValidPhonePrefix(String phoneNumber) {
    return _validPhonePrefixes.any((prefix) => phoneNumber.startsWith(prefix));
  }

  ValidationResult _validateEmail(String email) {
    if (email.isEmpty) return ValidationResult.valid();

    if (!_emailRegex.hasMatch(email)) {
      return ValidationResult.invalid('올바른 이메일 형식이 아닙니다');
    }

    return ValidationResult.valid();
  }

  // Public methods
  Future<bool?> signUp() async {
    if (!_state.canSubmit) return null;

    if (!_validateAllFields()) {
      return null;
    }

    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      await _simulateApiCall();
      await _saveUserCredentials();
      
      _updateState(_state.copyWith(isLoading: false));
      return true;
    } catch (error) {
      _handleSignUpError(error);
      return false;
    }
  }
  
  // Private helper methods
  bool _validateAllFields() {
    final validations = [
      ('id', _validateId(_state.id)),
      ('password', _validatePassword(_state.password)),
      ('confirmPassword', _validateConfirmPassword(_state.confirmPassword, _state.password)),
      ('phoneNumber', _validatePhoneNumber(_state.phoneNumber)),
      ('email', _validateEmail(_state.email)),
    ];
    
    final hasErrors = validations.any((v) => !v.$2.isValid);
    
    if (hasErrors) {
      _updateValidationErrors(validations);
      return false;
    }
    
    return true;
  }
  
  void _updateValidationErrors(List<(String, ValidationResult)> validations) {
    final idValidation = validations.firstWhere((v) => v.$1 == 'id').$2;
    final passwordValidation = validations.firstWhere((v) => v.$1 == 'password').$2;
    final confirmPasswordValidation = validations.firstWhere((v) => v.$1 == 'confirmPassword').$2;
    final phoneValidation = validations.firstWhere((v) => v.$1 == 'phoneNumber').$2;
    final emailValidation = validations.firstWhere((v) => v.$1 == 'email').$2;
    
    _updateState(
      _state.copyWith(
        isIdValid: idValidation.isValid,
        idErrorMessage: idValidation.errorMessage,
        isPasswordValid: passwordValidation.isValid,
        passwordErrorMessage: passwordValidation.errorMessage,
        isConfirmPasswordValid: confirmPasswordValidation.isValid,
        confirmPasswordErrorMessage: confirmPasswordValidation.errorMessage,
        isPhoneNumberValid: phoneValidation.isValid,
        phoneNumberErrorMessage: phoneValidation.errorMessage,
        isEmailValid: emailValidation.isValid,
        emailErrorMessage: emailValidation.errorMessage,
      ),
    );
  }
  
  Future<void> _simulateApiCall() async {
    await Future.delayed(_signUpDelay);
  }
  
  Future<void> _saveUserCredentials() async {
    if (GetIt.instance.isRegistered<SharedPreference>()) {
      final sharedPref = dl<SharedPreference>();
      await sharedPref.setUserId(_state.id);
      await sharedPref.setPassword(_state.password);
    }
  }
  
  void _handleSignUpError(Object error) {
    final errorMessage = error.toString().replaceAll('Exception: ', '');
    _updateState(
      _state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      ),
    );
  }

  void clearError() {
    _updateState(_state.copyWith(errorMessage: null));
  }

  void _updateState(SignUpState newState) {
    _state = newState;
    notifyListeners();
  }
}

@immutable
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._(this.isValid, this.errorMessage);
  
  // Factory constructors for better readability
  factory ValidationResult.valid() => const ValidationResult._(true, null);
  factory ValidationResult.invalid(String message) => ValidationResult._(false, message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationResult &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage;
  }
  
  @override
  int get hashCode => Object.hash(isValid, errorMessage);
}
