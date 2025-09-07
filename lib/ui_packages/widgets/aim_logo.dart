import 'package:aim_application/ui_packages/base/config.dart';
import 'package:flutter/material.dart';

class AimLogo extends StatelessWidget {
  final double? size;
  const AimLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size ?? AimConfig.space32,
      height: size ?? AimConfig.space32,
      decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
      child: Center(
        child: Text(
          'AIM',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
