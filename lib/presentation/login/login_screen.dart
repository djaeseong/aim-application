import 'package:aim_application/presentation/sign_up/sign_up_screen.dart';
import 'package:aim_application/ui_packages/base/config.dart';
import 'package:aim_application/ui_packages/base/spacing.dart';
import 'package:aim_application/ui_packages/widgets/aim_logo.dart';
import 'package:aim_application/ui_packages/widgets/aim_text_field.dart';
import 'package:aim_application/ui_packages/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_state.dart';
import 'login_view_model.dart';

final loginViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => LoginViewModel());

class LoginScreen extends ConsumerWidget {
  static const route = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider);
    final state = viewModel.state;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme),
                AimSpacing.vert12,
                _buildEmailField(viewModel, state),
                AimSpacing.vert4,
                _buildPasswordField(viewModel, state),
                AimSpacing.vert2,
                _buildRememberMe(viewModel, state, theme),
                if (state.errorMessage != null) ...[AimSpacing.vert4, _buildErrorMessage(state.errorMessage!, theme)],
                AimSpacing.vert6,
                _buildLoginButton(context, viewModel, state, theme),
                AimSpacing.vert4,
                _buildForgotPassword(theme),
                AimSpacing.vert8,
                _buildDivider(theme),
                AimSpacing.vert8,
                _buildSocialLogins(viewModel, state, theme),
                AimSpacing.vert8,
                _buildSignUp(theme, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        AimLogo(size: AimConfig.space20),
        AimSpacing.vert6,
        Text('다시 오신 것을 환영합니다', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        AimSpacing.vert2,
        Text(
          '계속하려면 로그인하세요',
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Widget _buildEmailField(LoginViewModel viewModel, LoginState state) {
    return AimTextField(
      labelText: 'ID',
      hintText: 'ID를 입력하세요',
      prefixIcon: Icons.person_outline,
      errorText: !state.isEmailValid ? 'ID는 4자 이상이어야 합니다' : null,
      enabled: !state.isLoading,
      keyboardType: TextInputType.text,
      onChanged: viewModel.updateId,
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel, LoginState state) {
    return AimPasswordField(
      labelText: '비밀번호',
      hintText: '비밀번호를 입력하세요',
      errorText: !state.isPasswordValid ? '비밀번호는 6자 이상이어야 합니다' : null,
      enabled: !state.isLoading,
      isPasswordVisible: state.isPasswordVisible,
      onChanged: viewModel.updatePassword,
      onToggleVisibility: viewModel.togglePasswordVisibility,
    );
  }

  Widget _buildRememberMe(LoginViewModel viewModel, LoginState state, ThemeData theme) {
    return Row(
      children: [
        Checkbox(value: state.rememberMe, onChanged: state.isLoading ? null : (_) => viewModel.toggleRememberMe()),
        Text('로그인 정보 저장', style: theme.textTheme.bodyMedium),
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

  Widget _buildLoginButton(BuildContext context, LoginViewModel viewModel, LoginState state, ThemeData theme) {
    return ElevatedButton(
      onPressed: state.canSubmit ? () => viewModel.login(context) : null,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      child: state.isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('로그인'),
    );
  }

  Widget _buildForgotPassword(ThemeData theme) {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to forgot password screen
      },
      child: Text('비밀번호를 잊으셨나요?', style: TextStyle(color: theme.colorScheme.primary)),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '또는',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.2))),
      ],
    );
  }

  Widget _buildSocialLogins(LoginViewModel viewModel, LoginState state, ThemeData theme) {
    return Column(
      children: [
        SocialLoginButton.google(
          onPressed: state.isLoading ? null : viewModel.loginWithGoogle,
          isLoading: state.isLoading,
        ),
        AimSpacing.vert3,
        SocialLoginButton.apple(
          onPressed: state.isLoading ? null : viewModel.loginWithApple,
          isLoading: state.isLoading,
        ),
        AimSpacing.vert3,
        SocialLoginButton.facebook(
          onPressed: state.isLoading ? null : viewModel.loginWithFacebook,
          isLoading: state.isLoading,
        ),
        AimSpacing.vert3,
        SocialLoginButton.kakao(
          onPressed: state.isLoading ? null : viewModel.loginWithKakao,
          isLoading: state.isLoading,
        ),
        AimSpacing.vert3,
        SocialLoginButton.naver(
          onPressed: state.isLoading ? null : viewModel.loginWithNaver,
          isLoading: state.isLoading,
        ),
      ],
    );
  }

  Widget _buildSignUp(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '계정이 없으신가요? ',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () {
            context.pushNamed(SignUpScreen.route);
          },
          child: Text(
            '회원가입',
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
