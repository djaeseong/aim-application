import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AimTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final TextStyle? helperStyle;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSuffixIconPressed;

  const AimTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.helperStyle,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        errorText: errorText,
        helperText: helperText,
        helperStyle: helperStyle,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}

class AimPasswordField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final TextStyle? helperStyle;
  final int? helperMaxLines;
  final bool enabled;
  final bool isPasswordVisible;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleVisibility;

  const AimPasswordField({
    super.key,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.enabled = true,
    this.isPasswordVisible = false,
    this.onChanged,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return AimTextField(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility),
        onPressed: enabled ? onToggleVisibility : null,
      ),
      errorText: errorText,
      helperText: helperText,
      helperStyle: helperStyle,
      enabled: enabled,
      obscureText: !isPasswordVisible,
      onChanged: onChanged,
    );
  }
}
