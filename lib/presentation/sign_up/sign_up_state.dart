import 'package:flutter/foundation.dart';

@immutable
class SignUpState {
  // Form field values
  final String id;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String email;
  
  // UI state
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool agreedToTerms;
  
  // Validation states
  final bool isIdValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isPhoneNumberValid;
  final bool isEmailValid;
  
  // Error messages
  final String? errorMessage;
  final String? idErrorMessage;
  final String? passwordErrorMessage;
  final String? confirmPasswordErrorMessage;
  final String? phoneNumberErrorMessage;
  final String? emailErrorMessage;

  const SignUpState({
    // Form field values
    this.id = '',
    this.password = '',
    this.confirmPassword = '',
    this.phoneNumber = '',
    this.email = '',
    // UI state
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.agreedToTerms = false,
    // Validation states
    this.isIdValid = true,
    this.isPasswordValid = true,
    this.isConfirmPasswordValid = true,
    this.isPhoneNumberValid = true,
    this.isEmailValid = true,
    // Error messages
    this.errorMessage,
    this.idErrorMessage,
    this.passwordErrorMessage,
    this.confirmPasswordErrorMessage,
    this.phoneNumberErrorMessage,
    this.emailErrorMessage,
  });

  bool get canSubmit => _hasAllRequiredFields && _isAllFieldsValid && agreedToTerms && !isLoading;
  
  bool get _hasAllRequiredFields => 
      id.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      email.isNotEmpty;
  
  bool get _isAllFieldsValid =>
      isIdValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      isPhoneNumberValid &&
      isEmailValid;
  
  bool get hasAnyError => 
      idErrorMessage != null ||
      passwordErrorMessage != null ||
      confirmPasswordErrorMessage != null ||
      phoneNumberErrorMessage != null ||
      emailErrorMessage != null ||
      errorMessage != null;

  SignUpState copyWith({
    // Form field values
    String? id,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    String? email,
    // UI state
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? agreedToTerms,
    // Validation states
    bool? isIdValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isPhoneNumberValid,
    bool? isEmailValid,
    // Error messages
    String? errorMessage,
    String? idErrorMessage,
    String? passwordErrorMessage,
    String? confirmPasswordErrorMessage,
    String? phoneNumberErrorMessage,
    String? emailErrorMessage,
  }) {
    return SignUpState(
      // Form field values
      id: id ?? this.id,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      // UI state
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      // Validation states
      isIdValid: isIdValid ?? this.isIdValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      // Error messages - allow null to clear errors
      errorMessage: errorMessage,
      idErrorMessage: idErrorMessage,
      passwordErrorMessage: passwordErrorMessage,
      confirmPasswordErrorMessage: confirmPasswordErrorMessage,
      phoneNumberErrorMessage: phoneNumberErrorMessage,
      emailErrorMessage: emailErrorMessage,
    );
  }
  
  /// Creates a copy with all error messages cleared
  SignUpState clearErrors() {
    return copyWith(
      errorMessage: null,
      idErrorMessage: null,
      passwordErrorMessage: null,
      confirmPasswordErrorMessage: null,
      phoneNumberErrorMessage: null,
      emailErrorMessage: null,
    );
  }
  
  /// Creates a copy with all validation states reset to valid
  SignUpState resetValidation() {
    return copyWith(
      isIdValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isPhoneNumberValid: true,
      isEmailValid: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignUpState &&
        _compareFormFields(other) &&
        _compareUIState(other) &&
        _compareValidationStates(other) &&
        _compareErrorMessages(other);
  }
  
  bool _compareFormFields(SignUpState other) =>
      other.id == id &&
      other.password == password &&
      other.confirmPassword == confirmPassword &&
      other.phoneNumber == phoneNumber &&
      other.email == email;
  
  bool _compareUIState(SignUpState other) =>
      other.isLoading == isLoading &&
      other.isPasswordVisible == isPasswordVisible &&
      other.isConfirmPasswordVisible == isConfirmPasswordVisible &&
      other.agreedToTerms == agreedToTerms;
  
  bool _compareValidationStates(SignUpState other) =>
      other.isIdValid == isIdValid &&
      other.isPasswordValid == isPasswordValid &&
      other.isConfirmPasswordValid == isConfirmPasswordValid &&
      other.isPhoneNumberValid == isPhoneNumberValid &&
      other.isEmailValid == isEmailValid;
  
  bool _compareErrorMessages(SignUpState other) =>
      other.errorMessage == errorMessage &&
      other.idErrorMessage == idErrorMessage &&
      other.passwordErrorMessage == passwordErrorMessage &&
      other.confirmPasswordErrorMessage == confirmPasswordErrorMessage &&
      other.phoneNumberErrorMessage == phoneNumberErrorMessage &&
      other.emailErrorMessage == emailErrorMessage;

  @override
  int get hashCode {
    return Object.hashAll([
      // Form fields
      id,
      password,
      confirmPassword,
      phoneNumber,
      email,
      // UI state
      isLoading,
      isPasswordVisible,
      isConfirmPasswordVisible,
      agreedToTerms,
      // Validation states
      isIdValid,
      isPasswordValid,
      isConfirmPasswordValid,
      isPhoneNumberValid,
      isEmailValid,
      // Error messages
      errorMessage,
      idErrorMessage,
      passwordErrorMessage,
      confirmPasswordErrorMessage,
      phoneNumberErrorMessage,
      emailErrorMessage,
    ]);
  }
}