// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:collection';

import 'package:flutter/gestures.dart';

class TouchSample {
  final double x;
  final double y;
  final int t; // microsecondsSinceEpoch
  const TouchSample(this.x, this.y, this.t);
}

/// 全局触摸轨迹采样器（对应 Python 的 MouseTracker，移动端改用 PointerMove）。
/// 挂在 App 根部 Listener 上，收集最近 64 次触摸移动作为真随机熵源。
class TouchTracker {
  final Queue<TouchSample> _samples = Queue();
  static const int _maxSamples = 64;

  void onPointerMove(PointerMoveEvent event) =>
      _add(event.position.dx, event.position.dy);

  /// 桌面端鼠标自由移动（hover，无按钮按下时）。
  /// 移动端不触发；桌面端无触摸，主要靠此采集鼠标微动轨迹。
  void onPointerHover(PointerHoverEvent event) =>
      _add(event.position.dx, event.position.dy);

  void _add(double dx, double dy) {
    _samples
        .addLast(TouchSample(dx, dy, DateTime.now().microsecondsSinceEpoch));
    while (_samples.length > _maxSamples) {
      _samples.removeFirst();
    }
  }

  List<TouchSample> get samples => _samples.toList();

  void clear() => _samples.clear();
}
