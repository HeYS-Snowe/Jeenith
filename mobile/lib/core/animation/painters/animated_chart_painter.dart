// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 带绘制进度驱动的 CustomPainter 基类。
///
/// 子类实现 [paintChart]，根据 [progress]（0.0→1.0）决定绘制哪些元素，
/// 实现「从无到有」的笔触动画。
///
/// 调用方用 AnimationController + AnimatedBuilder 包裹，progress = controller.value。
abstract class AnimatedChartPainter extends CustomPainter {
  /// 绘制进度 0.0→1.0。
  final double progress;

  const AnimatedChartPainter({required this.progress});

  /// 子类实现：根据 progress 绘制内容。
  void paintChart(Canvas canvas, Size size, double progress);

  @override
  void paint(Canvas canvas, Size size) => paintChart(canvas, size, progress);

  // —— 进度工具 ——

  /// 取某段 [start, end] 内的局部进度 0..1。
  double seg(double start, double end) =>
      ((progress - start) / (end - start)).clamp(0.0, 1.0);

  /// easeOut：先快后慢。
  double easeOut(double t) {
    final x = t.clamp(0.0, 1.0);
    return 1 - (1 - x) * (1 - x) * (1 - x);
  }

  /// easeInOut：两头慢中间快。
  double easeInOut(double t) {
    final x = t.clamp(0.0, 1.0);
    return x < 0.5 ? 4 * x * x * x : 1 - (-2 * x + 2) * (-2 * x + 2) * (-2 * x + 2) / 2;
  }

  /// easeOutBack：带回弹（用于星曜降落等）。
  double easeOutBack(double t) {
    final x = t.clamp(0.0, 1.0);
    const c1 = 1.70158;
    const c3 = c1 + 1;
    return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2);
  }

  /// 线性插值角度（弧度）。
  double lerpAngle(double a, double b, double t) => a + (b - a) * t;

  /// 线性插值 double。
  double lerp(double a, double b, double t) => a + (b - a) * t;
}
