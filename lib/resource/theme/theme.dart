import 'package:flutter/material.dart';

class AppThemedata {
  static const Color surface = Color(0XFF172927);
  static const Color onSuraface = Color(0xFFE0E0E0);
  static const Color primary = Color(0xFF91E1D6);
  static const Color shadowColor = Color(0xFF0A0A12);

  static dark() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF172927),
      primaryColor: const Color(0xFF0A0A12),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF0A0A12),
        surface: surface,
        onSurface: onSuraface,
      ),
    );
  }
}
