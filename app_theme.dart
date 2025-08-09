import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF6C5CE7);
  static ThemeData light = ThemeData(
    colorSchemeSeed: seed,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static ThemeData dark = ThemeData(
    colorSchemeSeed: seed,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
