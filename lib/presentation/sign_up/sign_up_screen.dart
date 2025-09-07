import 'package:aim_application/presentation/login/login_screen.dart';
import 'package:aim_application/ui_packages/base/spacing.dart';
import 'package:aim_application/ui_packages/widgets/aim_logo.dart';
import 'package:aim_application/ui_packages/widgets/aim_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sign_up_state.dart';
import 'sign_up_view_model.dart';

final signUpViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => SignUpViewModel());

class SignUpScreen extends ConsumerWidget {
  static const route = '/sign-up';

  static const _passwordMinLength = 10;
  static const _idMinLength = 7;
  static const _phoneNumberMaxLength = 13;

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signUpViewModelProvider);
    final state = viewModel.state;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme),
              AimSpacing.vert8,
              _buildIdField(viewModel, state),
              AimSpacing.vert4,
              _buildPasswordField(viewModel, state),
              AimSpacing.vert4,
              _buildConfirmPasswordField(viewModel, state),
              AimSpacing.vert4,
              _buildPhoneNumberField(viewModel, state),
              AimSpacing.vert4,
              _buildEmailField(viewModel, state),
              AimSpacing.vert6,
              _buildTermsCheckbox(viewModel, state, theme),
              if (state.errorMessage != null) ...[AimSpacing.vert4, _buildErrorMessage(state.errorMessage!, theme)],
              AimSpacing.vert8,
              _buildSignUpButton(context, viewModel, state, theme),
              AimSpacing.vert4,
              _buildAlreadyHaveAccount(theme, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        const AimLogo(size: 60),
        AimSpacing.vert4,
        Text('계정 만들기', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        AimSpacing.vert2,
        Text(
          '아래 정보를 입력하여 회원가입을 완료하세요',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Widget _buildIdField(SignUpViewModel viewModel, SignUpState state) {
    return AimTextField(
      labelText: 'ID',
      hintText: '영문, 숫자 $_idMinLength자 이상',
      prefixIcon: Icons.person_outline,
      errorText: state.idErrorMessage,
      helperText: _buildIdHelperText(state),
      helperStyle: TextStyle(color: state.isIdValid ? Colors.green : null),
      enabled: !state.isLoading,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
      onChanged: viewModel.updateId,
    );
  }

  String? _buildIdHelperText(SignUpState state) {
    if (state.id.isEmpty) return null;
    return '${state.id.length}자';
  }

  Widget _buildPasswordField(SignUpViewModel viewModel, SignUpState state) {
    return AimPasswordField(
      labelText: '비밀번호',
      hintText: '대소문자, 숫자, 특수문자 포함 $_passwordMinLength자 이상',
      errorText: state.passwordErrorMessage,
      helperText: _buildPasswordHelperText(state.password),
      helperMaxLines: 2,
      enabled: !state.isLoading,
      isPasswordVisible: state.isPasswordVisible,
      onChanged: viewModel.updatePassword,
      onToggleVisibility: viewModel.togglePasswordVisibility,
    );
  }

  Widget _buildConfirmPasswordField(SignUpViewModel viewModel, SignUpState state) {
    return AimPasswordField(
      labelText: '비밀번호 확인',
      hintText: '비밀번호를 다시 입력하세요',
      errorText: state.confirmPasswordErrorMessage,
      enabled: !state.isLoading,
      isPasswordVisible: state.isConfirmPasswordVisible,
      onChanged: viewModel.updateConfirmPassword,
      onToggleVisibility: viewModel.toggleConfirmPasswordVisibility,
    );
  }

  Widget _buildPhoneNumberField(SignUpViewModel viewModel, SignUpState state) {
    return AimTextField(
      labelText: '휴대폰 번호',
      hintText: '010-0000-0000',
      prefixIcon: Icons.phone_android,
      errorText: state.phoneNumberErrorMessage,
      enabled: !state.isLoading,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
        LengthLimitingTextInputFormatter(_phoneNumberMaxLength),
        _PhoneNumberFormatter(),
      ],
      onChanged: viewModel.updatePhoneNumber,
    );
  }

  Widget _buildEmailField(SignUpViewModel viewModel, SignUpState state) {
    return AimTextField(
      labelText: '이메일',
      hintText: 'example@email.com',
      prefixIcon: Icons.email_outlined,
      errorText: state.emailErrorMessage,
      enabled: !state.isLoading,
      keyboardType: TextInputType.emailAddress,
      onChanged: viewModel.updateEmail,
    );
  }

  Widget _buildTermsCheckbox(SignUpViewModel viewModel, SignUpState state, ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: state.agreedToTerms,
          onChanged: state.isLoading ? null : (_) => viewModel.toggleAgreedToTerms(),
        ),
        Expanded(
          child: GestureDetector(
            onTap: state.isLoading ? null : viewModel.toggleAgreedToTerms,
            child: Text('이용약관 및 개인정보처리방침에 동의합니다', style: theme.textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          AimSpacing.horiz2,
          Expanded(
            child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, SignUpViewModel viewModel, SignUpState state, ThemeData theme) {
    return ElevatedButton(
      onPressed: state.canSubmit ? () => _handleSignUp(context, viewModel, state) : null,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      child: state.isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('회원가입'),
    );
  }

  Future<void> _handleSignUp(BuildContext context, SignUpViewModel viewModel, SignUpState state) async {
    final result = await viewModel.signUp();

    if (!context.mounted) return;

    if (result == true) {
      _showSuccessSnackBar(context);
      context.goNamed(LoginScreen.route);
    } else {
      _showErrorSnackBar(context, state.errorMessage);
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('회원가입이 완료되었습니다!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
    );
  }

  void _showErrorSnackBar(BuildContext context, String? errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage ?? '회원가입에 실패했습니다'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이미 계정이 있으신가요? ',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            '로그인',
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String? _buildPasswordHelperText(String password) {
    if (password.isEmpty) return null;

    final requirements = _getPasswordRequirements(password);
    return requirements.join(' ');
  }

  List<String> _getPasswordRequirements(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= _passwordMinLength;

    return [
      _formatRequirement('대문자', hasUppercase),
      _formatRequirement('소문자', hasLowercase),
      _formatRequirement('숫자', hasDigit),
      _formatRequirement('특수문자', hasSpecialChar),
      _formatRequirement('$_passwordMinLength자 이상', hasMinLength),
    ];
  }

  String _formatRequirement(String label, bool isMet) {
    return isMet ? '✓ $label' : '✗ $label';
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  static const _maxDigits = 11;
  static const _firstHyphenPosition = 3;
  static const _secondHyphenPosition = 7;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = _extractDigits(newValue.text);
    final limitedDigits = _limitDigits(digitsOnly);

    if (newValue.selection.baseOffset < 0) {
      return _formatWithoutCursor(limitedDigits);
    }

    return _formatWithCursor(newValue, limitedDigits);
  }

  String _extractDigits(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  String _limitDigits(String digits) {
    return digits.length > _maxDigits ? digits.substring(0, _maxDigits) : digits;
  }

  TextEditingValue _formatWithoutCursor(String digits) {
    final formatted = _formatPhoneNumber(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  TextEditingValue _formatWithCursor(TextEditingValue newValue, String digits) {
    final digitsBeforeCursor = _countDigitsBeforeCursor(newValue);
    final formatted = _formatPhoneNumber(digits);
    final cursorPosition = _calculateCursorPosition(digitsBeforeCursor, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  int _countDigitsBeforeCursor(TextEditingValue value) {
    int count = 0;
    final limit = value.selection.baseOffset.clamp(0, value.text.length);

    for (int i = 0; i < limit; i++) {
      if (RegExp(r'\d').hasMatch(value.text[i])) {
        count++;
      }
    }

    return count;
  }

  String _formatPhoneNumber(String digits) {
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == _firstHyphenPosition || i == _secondHyphenPosition) {
        buffer.write('-');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  int _calculateCursorPosition(int digitsBeforeCursor, int maxLength) {
    int position = digitsBeforeCursor;

    if (digitsBeforeCursor > _firstHyphenPosition) position++;
    if (digitsBeforeCursor > _secondHyphenPosition) position++;

    return position.clamp(0, maxLength);
  }
}
