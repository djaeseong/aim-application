import 'package:flutter/material.dart';

enum Env { dev, staging, prod }

class AppConfig {
  final Env flavor;
  final String baseUrl;
  final String s3Url;

  static AppConfig? _instance;

  factory AppConfig({required Env flavor, required String baseUrl, required String s3Url}) {
    _instance ??= AppConfig._internal(flavor, baseUrl, s3Url);
    return _instance!;
  }

  AppConfig._internal(this.flavor, this.baseUrl, this.s3Url);

  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static ValueNotifier<bool> current = ValueNotifier(false);

  static AppConfig? get instance => _instance;

  static bool isDev() => _instance!.flavor == Env.dev;

  static bool isStaging() => _instance!.flavor == Env.staging;

  static bool isProd() => _instance!.flavor == Env.prod;

  static Env get getFlavor => _instance!.flavor;

  static String get getBaseUrl => _instance!.baseUrl;

  static String get getS3Url => _instance!.s3Url;

  static void setThemeMode(bool isDark) {
    if (isDark) {
      themeMode.value = ThemeMode.dark;
      current.value = true;
    } else {
      themeMode.value = ThemeMode.light;
      current.value = false;
    }
  }

  static void changeThemeMode() {
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        current.value = true;
        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        current.value = false;
        break;
      default:
    }
  }
}
