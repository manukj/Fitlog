import 'package:flutter/material.dart';

class AppThemedata {
  static const Color surface = Color(0xFF0A0A12);
  static const Color onSuraface = const Color(0xFFE0E0E0);

  static dark() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0A12),
      primaryColor: const Color(0xFF0A0A12),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0A0A12),
        secondary: Color(0xFF0A0A12),
        surface: surface,
        onSurface: onSuraface,
      ),
    );
  }
}
