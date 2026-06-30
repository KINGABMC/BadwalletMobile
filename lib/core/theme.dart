import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF005C66),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005C66),
        primary: const Color(0xFF005C66),
        secondary: const Color(0xFF00A896),
      ),
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF005C66),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}