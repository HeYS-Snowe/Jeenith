// Copyright (c) 2026 Qore
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../daliuren/algorithm/divine.dart' show azimuthFromMagnetometer;

/// 罗盘读数：方位角（0=北，顺时针 0-360）+ 时间戳。
class CompassReading {
  final double azimuth;
  final DateTime timestamp;

  const CompassReading({required this.azimuth, required this.timestamp});
}

/// 罗盘状态：磁力计订阅 + 方位角更新。
///
/// 仅 Android 平台可用（Windows 桌面端无磁力计硬件）。
/// 调用 [start] 开始订阅，[stop] 取消订阅。组件销毁时自动取消。
class CompassNotifier extends Notifier<CompassReading?> {
  StreamSubscription<MagnetometerEvent>? _sub;

  @override
  CompassReading? build() {
    ref.onDispose(() {
      _sub?.cancel();
      _sub = null;
    });
    return null;
  }

  /// 开始订阅磁力计：每帧（~16ms）取一次读数计算方位角。
  Future<void> start() async {
    await _sub?.cancel();
    _sub = magnetometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      (event) {
        final az = azimuthFromMagnetometer(event.x, event.y, event.z);
        state = CompassReading(azimuth: az, timestamp: DateTime.now());
      },
      onError: (_) {
        // 忽略磁力计错误（设备无磁力计 / 权限缺失）
      },
    );
  }

  /// 停止订阅。
  void stop() {
    _sub?.cancel();
    _sub = null;
    state = null;
  }
}

final compassProvider =
    NotifierProvider<CompassNotifier, CompassReading?>(CompassNotifier.new);
