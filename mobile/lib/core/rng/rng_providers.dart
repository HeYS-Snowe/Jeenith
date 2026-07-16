// Copyright (c) 2026 Qore
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../config/config_providers.dart';
import 'online_entropy_source.dart';
import 'system_entropy_source.dart';
import 'touch_entropy_source.dart';
import 'touch_tracker.dart';
import 'true_random.dart';

final touchTrackerProvider = Provider<TouchTracker>((ref) => TouchTracker());

/// 真随机引擎：系统熵 + 触摸轨迹 + 在线大气噪声（按配置开关）。
final trueRandomProvider = Provider<TrueRandom>((ref) {
  final config = ref.watch(configProvider).valueOrNull ?? AppConfig.defaults;
  final tracker = ref.watch(touchTrackerProvider);
  return TrueRandom([
    SystemEntropySource(),
    TouchEntropySource(tracker),
    OnlineEntropySource(config.useOnline),
  ]);
});
