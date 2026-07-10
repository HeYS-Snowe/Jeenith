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

  void onPointerMove(PointerMoveEvent event) {
    _samples.addLast(TouchSample(
      event.position.dx,
      event.position.dy,
      DateTime.now().microsecondsSinceEpoch,
    ));
    while (_samples.length > _maxSamples) {
      _samples.removeFirst();
    }
  }

  List<TouchSample> get samples => _samples.toList();

  void clear() => _samples.clear();
}
