import 'package:flutter/material.dart';

enum SocialLoginType {
  google,
  apple,
  facebook,
  kakao,
  naver,
}

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? customText;
  final double verticalPadding;
  final double horizontalPadding;

  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
    this.customText,
    this.verticalPadding = 12,
    this.horizontalPadding = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(),
        label: Text(customText ?? _getDefaultText()),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case SocialLoginType.google:
        return Icon(
          Icons.g_mobiledata,
          color: isLoading ? null : Colors.red,
        );
      case SocialLoginType.apple:
        return Icon(
          Icons.apple,
          color: isLoading ? null : Colors.black,
        );
      case SocialLoginType.facebook:
        return Icon(
          Icons.facebook,
          color: isLoading ? null : Colors.blue[700],
        );
      case SocialLoginType.kakao:
        return Icon(
          Icons.chat_bubble,
          color: isLoading ? null : Colors.yellow[700],
        );
      case SocialLoginType.naver:
        return Icon(
          Icons.chat_bubble,
          color: isLoading ? null : Colors.green,
        );
    }
  }

  String _getDefaultText() {
    switch (type) {
      case SocialLoginType.google:
        return 'Google로 계속하기';
      case SocialLoginType.apple:
        return 'Apple로 계속하기';
      case SocialLoginType.facebook:
        return 'Facebook으로 계속하기';
      case SocialLoginType.kakao:
        return '카카오로 계속하기';
      case SocialLoginType.naver:
        return '네이버로 계속하기';
    }
  }

  // Factory constructors for convenience
  factory SocialLoginButton.google({
    required VoidCallback? onPressed,
    bool isLoading = false,
    String? customText,
  }) {
    return SocialLoginButton(
      type: SocialLoginType.google,
      onPressed: onPressed,
      isLoading: isLoading,
      customText: customText,
    );
  }

  factory SocialLoginButton.apple({
    required VoidCallback? onPressed,
    bool isLoading = false,
    String? customText,
  }) {
    return SocialLoginButton(
      type: SocialLoginType.apple,
      onPressed: onPressed,
      isLoading: isLoading,
      customText: customText,
    );
  }

  factory SocialLoginButton.facebook({
    required VoidCallback? onPressed,
    bool isLoading = false,
    String? customText,
  }) {
    return SocialLoginButton(
      type: SocialLoginType.facebook,
      onPressed: onPressed,
      isLoading: isLoading,
      customText: customText,
    );
  }

  factory SocialLoginButton.kakao({
    required VoidCallback? onPressed,
    bool isLoading = false,
    String? customText,
  }) {
    return SocialLoginButton(
      type: SocialLoginType.kakao,
      onPressed: onPressed,
      isLoading: isLoading,
      customText: customText,
    );
  }

  factory SocialLoginButton.naver({
    required VoidCallback? onPressed,
    bool isLoading = false,
    String? customText,
  }) {
    return SocialLoginButton(
      type: SocialLoginType.naver,
      onPressed: onPressed,
      isLoading: isLoading,
      customText: customText,
    );
  }
}