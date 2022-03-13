import 'package:flutter/material.dart';

class CustomColorScheme {
  static const colorScheme = ColorScheme(
      primary: CustomColorScheme.primary,
      secondary: CustomColorScheme.secondary,
      surface: CustomColorScheme.surface,
      background: CustomColorScheme.background,
      error: CustomColorScheme.error,
      onPrimary: CustomColorScheme.onPrimary,
      onSecondary: CustomColorScheme.onSecondary,
      onSurface: CustomColorScheme.onSurface,
      onBackground: CustomColorScheme.onBackground,
      onError: CustomColorScheme.onError,
      brightness: Brightness.light);
  static const Color primary = Color(0xff444444);
  static const Color secondary = Color(0x6a828282);
  static const Color surface = Color(0xff89a9d0);
  static const Color background = Color(0xffffffff);
  static const Color error = Color(0xffF96060);
  static const Color onPrimary = Color(0xffffffff);
  static const Color onSecondary = Color(0xff365B87);
  static const Color onSurface = Color(0xff828282);
  static const Color onBackground = Color(0xff444444);
  static const Color onError = Color(0xffffffff);

  static const Color success = Color.fromARGB(255, 28, 78, 185);
}
