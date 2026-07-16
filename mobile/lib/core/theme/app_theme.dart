// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';

/// 全局色彩常量（从 Python QSS / PALACES 提取，保持视觉一致）。
class AppColors {
  AppColors._();

  // —— 背景 ——
  static const Color bg = Color(0xFF0C0A12);
  static const Color bgInner = Color(0xFF1B1626);
  static const Color bgMid = Color(0xFF120F1A);
  static const Color bgOuter = Color(0xFF0A0810);

  // —— 鎏金系 ——
  static const Color gold = Color(0xFFD4A857);
  static const Color goldBright = Color(0xFFE8C87A);
  static const Color goldLight = Color(0xFFF0D488);
  static const Color goldBorder = Color.fromRGBO(212, 168, 87, 0.43);

  // —— 文字 ——
  static const Color textHighlight = Color(0xFFFDF6E3);
  static const Color textPrimary = Color(0xFFF0E6CF);
  static const Color textBody = Color(0xFFC8BC9E);
  static const Color textMeta = Color(0xFFA89A78);
  static const Color textSubtitle = Color(0xFF8A7A55);
  static const Color textHint = Color(0xFF6A6076);

  // —— 面板 ——
  static const Color panel = Color.fromRGBO(18, 14, 26, 0.78);
  static const Color card = Color.fromRGBO(28, 22, 38, 0.86);
  static const Color buttonTop = Color(0xFF3A2F4A);
  static const Color buttonBottom = Color(0xFF241C30);

  // —— 五行色（小六壬六宫）——
  static const Color wood = Color(0xFF3FAE6F);
  static const Color woodGlow = Color(0xFF7FE3AD);
  static const Color water = Color(0xFF6A8AA6);
  static const Color waterGlow = Color(0xFF9BC0DC);
  static const Color fire = Color(0xFFE85A3C);
  static const Color fireGlow = Color(0xFFFF9077);
  static const Color metal = Color(0xFFC5CDD8);
  static const Color metalGlow = Color(0xFFEEF2F8);
  static const Color waterDeep = Color(0xFF3A86B8);
  static const Color waterDeepGlow = Color(0xFF74BCE4);
  static const Color earth = Color(0xFFB8924E);
  static const Color earthGlow = Color(0xFFE0BF7E);

  // —— 周易爻色 ——
  static const Color yang = Color(0xFFD4A857);
  static const Color yin = Color(0xFF9BC0DC);
  static const Color changing = Color(0xFFE85A3C);

  // —— 断语分级色 ——
  static const Color gradeGreat = Color(0xFF7FE3AD);
  static const Color gradeGood = Color(0xFF9BC0DC);
  static const Color gradeSteady = Color(0xFFD4A857);
  static const Color gradeRough = Color(0xFFE0BF7E);
  static const Color gradeBad = Color(0xFFFF9077);

  /// 明度缩放（对应 Python darker()）。
  static Color darker(Color c, double f) {
    return Color.fromARGB(
      (c.a * 255).round(),
      (c.r * 255 * f).round().clamp(0, 255),
      (c.g * 255 * f).round().clamp(0, 255),
      (c.b * 255 * f).round().clamp(0, 255),
    );
  }
}

/// 浅色主题色彩常量（v1.5.0 新增，与深色保持同等五色系语义）。
class AppColorsLight {
  AppColorsLight._();

  // —— 背景（浅米色）——
  static const Color bg = Color(0xFFF6F0E2);
  static const Color bgInner = Color(0xFFEBE2CC);
  static const Color bgMid = Color(0xFFF1E9D5);
  static const Color bgOuter = Color(0xFFE5D9BD);

  // —— 鎏金系（深一些以保证对比度）——
  static const Color gold = Color(0xFF9B7A2A);
  static const Color goldBright = Color(0xFF8A6A1E);
  static const Color goldLight = Color(0xFFB89534);
  static const Color goldBorder = Color.fromRGBO(155, 122, 42, 0.55);

  // —— 文字 ——
  static const Color textHighlight = Color(0xFF1A1208);
  static const Color textPrimary = Color(0xFF2E2210);
  static const Color textBody = Color(0xFF4A3A1E);
  static const Color textMeta = Color(0xFF6B5A3A);
  static const Color textSubtitle = Color(0xFF8A7A55);
  static const Color textHint = Color(0xFF9B8C6E);

  // —— 面板 ——
  static const Color panel = Color.fromRGBO(245, 238, 220, 0.92);
  static const Color card = Color.fromRGBO(240, 232, 212, 0.95);
  static const Color buttonTop = Color(0xFFEBE2CC);
  static const Color buttonBottom = Color(0xFFD9CBA8);

  // —— 五行色 ——
  static const Color wood = Color(0xFF2D8E54);
  static const Color woodGlow = Color(0xFF1E6B3F);
  static const Color water = Color(0xFF3A6E8E);
  static const Color waterGlow = Color(0xFF2A5670);
  static const Color fire = Color(0xFFC13E1E);
  static const Color fireGlow = Color(0xFFA02E0E);
  static const Color metal = Color(0xFF5A6878);
  static const Color metalGlow = Color(0xFF3E4A58);
  static const Color waterDeep = Color(0xFF1E5A88);
  static const Color waterDeepGlow = Color(0xFF124068);
  static const Color earth = Color(0xFF8A6420);
  static const Color earthGlow = Color(0xFF6A4A14);

  static const Color yang = Color(0xFF9B7A2A);
  static const Color yin = Color(0xFF3A6E8E);
  static const Color changing = Color(0xFFC13E1E);

  static const Color gradeGreat = Color(0xFF1E6B3F);
  static const Color gradeGood = Color(0xFF2A5670);
  static const Color gradeSteady = Color(0xFF8A6A1E);
  static const Color gradeRough = Color(0xFF6A4A14);
  static const Color gradeBad = Color(0xFFA02E0E);
}

/// 字体常量。
class AppFonts {
  AppFonts._();
  /// 思源宋体（如已打包则用宋体；否则回退系统默认）。
  static const String serif = 'SourceHanSerif';
}

/// 中国风深色主题（Material 3）。
ThemeData appTheme({bool isLight = false}) {
  if (isLight) return _lightTheme();
  return _darkTheme();
}

ThemeData _darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
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

ThemeData _lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: AppColorsLight.gold,
      secondary: AppColorsLight.goldBright,
      surface: AppColorsLight.bg,
      onPrimary: Color(0xFFF6F0E2),
      onSurface: AppColorsLight.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColorsLight.goldBright,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 6,
      ),
      iconTheme: IconThemeData(color: AppColorsLight.gold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromRGBO(240, 232, 212, 0.86),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsLight.goldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColorsLight.goldBright),
      ),
      hintStyle: const TextStyle(color: AppColorsLight.textHint),
    ),
  );
}
