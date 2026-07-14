// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

/// 应用配置（真随机熵源开关 + 展示开关 + 微交互动效总开关 + 按术数分类的动画设置 + 主题模式）。
///
/// v2.3.0: 把原本分散的 `xiaoliurenCinematic` / `ritualAnimationsEnabled` /
/// `painterAnimationsEnabled` / `revealAnimationsEnabled` / `transitionsEnabled`
/// 合并为 `animationSettings: Map<String, bool>`，Key 为各术 id（如
/// `xiaoliuren`/`zhouyi`/`bazi` 等），统一控制该术的仪式动画、绘制过程、
/// 结果揭示与路由转场。Value 默认全 true。
class AppConfig {
  final bool showDetails;                  // 起卦后展示采样详情
  final bool useOnline;                    // 在线大气噪声 random.org
  final bool animationsEnabled;            // 微交互动效总开关（按钮缩放/图标旋转/卡片错峰等）
  final Map<String, bool> animationSettings; // 按术数分类的动画开关（key = tech id）
  final ThemeMode themeMode;               // 主题模式：system/light/dark

  const AppConfig({
    required this.showDetails,
    required this.useOnline,
    this.animationsEnabled = true,
    this.animationSettings = const {},
    this.themeMode = ThemeMode.dark,
  });

  /// 默认配置：所有术的动画开关都为 true。
  /// 新增术时，注册表中对应 id 默认视为 true（通过 `isAnimationEnabled` 读取）。
  static const defaults = AppConfig(
    showDetails: true,
    useOnline: true,
    animationsEnabled: true,
    animationSettings: {},
    themeMode: ThemeMode.dark,
  );

  /// 读取某术的动画开关。未在 Map 中显式记录时默认为 true（向前兼容）。
  bool isAnimationEnabled(String techId) =>
      animationSettings[techId] ?? true;

  AppConfig copyWith({
    bool? showDetails,
    bool? useOnline,
    bool? animationsEnabled,
    Map<String, bool>? animationSettings,
    ThemeMode? themeMode,
  }) =>
      AppConfig(
        showDetails: showDetails ?? this.showDetails,
        useOnline: useOnline ?? this.useOnline,
        animationsEnabled: animationsEnabled ?? this.animationsEnabled,
        animationSettings: animationSettings ?? this.animationSettings,
        themeMode: themeMode ?? this.themeMode,
      );
}
