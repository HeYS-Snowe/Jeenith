// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// 中国风深色主题（Material 3）。
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.goldBright,
      surface: AppColors.bg,
      onPrimary: Color(0xFF1A1208),
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.goldBright,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 6,
      ),
      iconTheme: IconThemeData(color: AppColors.gold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromRGBO(20, 16, 28, 0.86),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.goldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.goldBright),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint),
    ),
  );
}
