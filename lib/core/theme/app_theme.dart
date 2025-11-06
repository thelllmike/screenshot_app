import 'package:flutter/material.dart';

final class AppTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}