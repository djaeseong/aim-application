import 'package:aim_application/presentation/main/main_screen.dart';
import 'package:aim_application/ui_packages/base/spacing.dart';
import 'package:aim_application/ui_packages/widgets/aim_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'splash_state.dart';
import 'splash_view_model.dart';

final splashViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => SplashViewModel());

class SplashScreen extends HookConsumerWidget {
  static const route = '/';

  // Animation constants
  static const _animationDuration = Duration(milliseconds: 500);
  static const _logoSpacing = 48.0;
  static const _errorIconSize = 64.0;
  static const _errorPadding = 32.0;

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(splashViewModelProvider);
    final state = viewModel.state;
    final theme = Theme.of(context);

    _useInitialization(viewModel, context);

    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(duration: _animationDuration, child: _buildContent(context, state, viewModel, theme)),
      ),
    );
  }

  void _useInitialization(SplashViewModel viewModel, BuildContext context) {
    useEffect(() {
      viewModel.onInit(context);
      return null;
    }, const []);
  }

  Widget _buildContent(BuildContext context, SplashState state, SplashViewModel viewModel, ThemeData theme) {
    if (state.errorMessage != null) {
      return _buildErrorView(context: context, errorMessage: state.errorMessage!, viewModel: viewModel, theme: theme);
    }

    if (state.isLoading) {
      return _buildLoadingView(theme);
    }

    return const MainScreen();
  }

  Widget _buildLoadingView(ThemeData theme) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(theme),
        SizedBox(height: _logoSpacing),
        _buildProgressIndicator(theme),
        AimSpacing.vert6,
        _buildLoadingText(theme),
      ],
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary));
  }

  Widget _buildLoadingText(ThemeData theme) {
    return Text(
      'Initializing...',
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
    );
  }

  Widget _buildErrorView({
    required BuildContext context,
    required String errorMessage,
    required SplashViewModel viewModel,
    required ThemeData theme,
  }) {
    return Column(
      key: const ValueKey('error'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildErrorIcon(theme),
        AimSpacing.vert6,
        _buildErrorTitle(theme),
        AimSpacing.vert2,
        _buildErrorMessage(errorMessage, theme),
        AimSpacing.vert8,
        _buildRetryButton(context, viewModel),
      ],
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return Icon(Icons.error_outline, size: _errorIconSize, color: theme.colorScheme.error);
  }

  Widget _buildErrorTitle(ThemeData theme) {
    return Text('Something went wrong', style: theme.textTheme.headlineSmall);
  }

  Widget _buildErrorMessage(String message, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _errorPadding),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, SplashViewModel viewModel) {
    return ElevatedButton(onPressed: () => viewModel.onInit(context), child: const Text('Retry'));
  }

  Widget _buildLogo(ThemeData theme) {
    return Column(
      key: const ValueKey('logo'),
      mainAxisSize: MainAxisSize.min,
      children: [const AimLogo(), AimSpacing.vert6, _buildAppTitle(theme)],
    );
  }

  Widget _buildAppTitle(ThemeData theme) {
    return Text('AIM Application', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600));
  }
}
