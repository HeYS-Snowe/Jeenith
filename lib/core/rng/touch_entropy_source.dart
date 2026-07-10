// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'entropy_source.dart';
import 'touch_tracker.dart';

/// 触摸轨迹熵源 —— 对应 Python 的鼠标轨迹源，移动端采集手指微动。
class TouchEntropySource implements EntropyCollector {
  final TouchTracker tracker;
  TouchEntropySource(this.tracker);

  @override
  String get name => '触摸轨迹（手部微动）';

  @override
  bool get isAvailable => true;

  @override
  Future<({String display, Uint8List bytes})> sample() async {
    final s = tracker.samples;
    if (s.isEmpty) {
      return (display: '无触摸', bytes: Uint8List(0));
    }
    final data = s.map((p) => '${p.x},${p.y},${p.t}').join('|');
    final digest = sha256.convert(utf8.encode(data));
    return (
      display: '${s.length} 采样点 → ${digest.toString().substring(0, 10)}',
      bytes: Uint8List.fromList(digest.bytes),
    );
  }
}
