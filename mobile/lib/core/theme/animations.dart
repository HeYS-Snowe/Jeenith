// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/animation.dart';

/// 全局动效常量与工具。
///
/// 所有微交互的时长、曲线、错峰间隔集中于此，便于一致性调优与设置页统一关闭。
/// 配色遵循 oklch 思路（黑金低饱和度），不在此处定义颜色——颜色仍由 [AppColors] 提供。
class AppAnimations {
  AppAnimations._();

  // —— 时长（ms）——
  static const int pressDown = 110;      // 按下塌缩
  static const int pressRelease = 260;   // 抬起弹回（更长，带 easeOutBack 余韵）
  static const int iconRotate = 240;     // 图标 + ↔ x 旋转
  static const int iconScale = 140;      // 图标点击呼吸
  static const int cardStagger = 90;     // 错峰间隔基数
  static const int cardRise = 420;       // 卡片上浮总时长
  static const int panelExpand = 260;   // 面板展开/收起

  // —— 仪式动画时长（ms）——
  static const int ritualZhouyi = 5000;  // 周易铜钱抛落
  static const int ritualZiwei = 6000;   // 紫微命盘展开
  static const int ritualQimen = 5000;   // 奇门九宫飞布
  static const int ritualDaliuren = 5000; // 大六壬双盘旋转
  static const int ritualLuopan = 4000;  // 风水罗盘扫描
  static const int ritualMeihua = 4000;  // 梅花数字撞击
  static const int ritualJiaobei = 3000; // 掷筊抛落
  static const int ritualCezi = 5000;    // 测字字形浮现+五行染色
  static const int ritualChouqian = 5000; // 抽签卷轴展开
  static const int skipButtonDelay = 3000; // 跳过按钮延迟显示

  // —— 曲线 ——
  /// 按下：稍快线性回缩，模拟"按下即响应"。
  static const Curve pressDownCurve = Curves.easeIn;

  /// 抬起：[Curves.easeOutBack] 略带回弹，模拟物理弹性，是按钮"质感"的核心。
  /// 0.4 的 back 偏移避免过冲太大显得廉价。
  static const Curve pressReleaseCurve = Cubic(0.34, 1.56, 0.64, 1);

  /// 图标旋转：标准 easeOut，干净不拖沓。
  static const Curve iconRotateCurve = Curves.easeOutCubic;

  /// 卡片错峰上浮：与 [InteractableCard] 现有曲线对齐。
  static const Curve cardRiseCurve = Curves.easeOutCubic;

  /// 面板展开：与 ExpansionTile 默认曲线风格协调。
  static const Curve panelExpandCurve = Curves.easeInOutCubic;

  // —— 错峰工具 ——
  /// 生成 N 个错峰 [Interval]，每个卡片入场占 0.42 区间，相邻错开 [cardStagger]ms 等价比例。
  ///
  /// 用法：
  /// ```dart
  /// final intervals = AppAnimations.staggeredIntervals(items.length);
  /// for (var i = 0; i < items.length; i++) {
  ///   EntranceItem(interval: intervals[i], ...);
  /// }
  /// ```
  static List<Interval> staggeredIntervals(int count,
      {double stepRatio = 0.08, double durationRatio = 0.42}) {
    if (count <= 0) return const [];
    if (count == 1) return const [Interval(0.0, 1.0)];
    return [
      for (var i = 0; i < count; i++)
        Interval(
          i * stepRatio,
          (i * stepRatio + durationRatio).clamp(0.0, 1.0),
          curve: cardRiseCurve,
        ),
    ];
  }
}
