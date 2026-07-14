// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

final configProvider = AsyncNotifierProvider<ConfigNotifier, AppConfig>(
  ConfigNotifier.new,
);

class ConfigNotifier extends AsyncNotifier<AppConfig> {
  static const String _kAnimPrefix = 'anim_';

  @override
  Future<AppConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    // Read all animation settings whose key starts with `anim_`.
    final raw = <String, bool>{};
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_kAnimPrefix)) {
        final id = key.substring(_kAnimPrefix.length);
        raw[id] = prefs.getBool(key) ?? true;
      }
    }
    return AppConfig(
      showDetails: prefs.getBool('showDetails') ?? true,
      useOnline: prefs.getBool('useOnline') ?? true,
      animationsEnabled: prefs.getBool('animationsEnabled') ?? true,
      animationSettings: raw,
      themeMode: _parseThemeMode(prefs.getString('themeMode')),
    );
  }

  Future<void> setShowDetails(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDetails', v);
    final current = await future;
    state = AsyncData(current.copyWith(showDetails: v));
  }

  Future<void> setUseOnline(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useOnline', v);
    final current = await future;
    state = AsyncData(current.copyWith(useOnline: v));
  }

  Future<void> setAnimationsEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationsEnabled', v);
    final current = await future;
    state = AsyncData(current.copyWith(animationsEnabled: v));
  }

  /// Toggle the animation setting for a single tech.
  Future<void> setAnimationSetting(String techId, bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_kAnimPrefix$techId', v);
    final current = await future;
    final next = Map<String, bool>.from(current.animationSettings);
    next[techId] = v;
    state = AsyncData(current.copyWith(animationSettings: next));
  }

  /// One-click bulk toggle: enable or disable animations for all given techs.
  Future<void> setAllAnimations(List<String> techIds, bool v) async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in techIds) {
      await prefs.setBool('$_kAnimPrefix$id', v);
    }
    final current = await future;
    final next = Map<String, bool>.from(current.animationSettings);
    for (final id in techIds) {
      next[id] = v;
    }
    state = AsyncData(current.copyWith(animationSettings: next));
  }

  Future<void> setThemeMode(ThemeMode v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _stringifyThemeMode(v));
    final current = await future;
    state = AsyncData(current.copyWith(themeMode: v));
  }

  static ThemeMode _parseThemeMode(String? s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  static String _stringifyThemeMode(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
