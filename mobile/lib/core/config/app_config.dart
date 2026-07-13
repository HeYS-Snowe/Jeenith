// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

/// 应用配置（真随机熵源开关 + 展示开关 + 各术动画开关 + 主题模式）。
class AppConfig {
  final bool showDetails;            // 起卦后展示采样详情
  final bool useOnline;              // 在线大气噪声 random.org
  final bool xiaoliurenCinematic;    // 小六壬仪式入场动画（太极生六宫）
  final ThemeMode themeMode;         // 主题模式：system/light/dark

  const AppConfig({
    required this.showDetails,
    required this.useOnline,
    this.xiaoliurenCinematic = true,
    this.themeMode = ThemeMode.dark,
  });

  static const defaults = AppConfig(
    showDetails: true,
    useOnline: true,
    xiaoliurenCinematic: true,
    themeMode: ThemeMode.dark,
  );

  AppConfig copyWith({
    bool? showDetails,
    bool? useOnline,
    bool? xiaoliurenCinematic,
    ThemeMode? themeMode,
  }) =>
      AppConfig(
        showDetails: showDetails ?? this.showDetails,
        useOnline: useOnline ?? this.useOnline,
        xiaoliurenCinematic: xiaoliurenCinematic ?? this.xiaoliurenCinematic,
        themeMode: themeMode ?? this.themeMode,
      );
}

