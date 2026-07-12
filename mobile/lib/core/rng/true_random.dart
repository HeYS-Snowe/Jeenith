// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../divination/divination_result.dart';
import 'entropy_source.dart';

/// 多源 SHA256 混合真随机引擎（移植自 Python TrueRandom）。
/// 移动端裁剪为 3 源：系统熵 + 触摸轨迹 + 在线大气噪声
/// （删去 RDRAND/温度/磁盘/内存/CPU抖动等移动端不可用源）。
class TrueRandom {
  final List<EntropyCollector> sources;
  TrueRandom(this.sources);

  /// 生成 count 个 [1, vmax] 整数，附带各源采样详情。
  Future<EntropySample> generate({int count = 3, int vmax = 9}) async {
    final results = <EntropySourceResult>[];
    final parts = <Uint8List>[];

    for (final src in sources) {
      if (!src.isAvailable) {
        results.add(EntropySourceResult(
            name: src.name, display: '未启用 / 不可用', succeeded: false));
        continue;
      }
      try {
        final r = await src.sample();
        results.add(EntropySourceResult(
            name: src.name, display: r.display, succeeded: true));
        if (r.bytes.isNotEmpty) parts.add(r.bytes);
      } catch (_) {
        results.add(EntropySourceResult(
            name: src.name, display: '采样失败', succeeded: false));
      }
    }

    // 多源 SHA256 混合
    var digest = sha256.convert(<int>[]).bytes;
    for (final b in parts) {
      digest = sha256.convert([...digest, ...b]).bytes;
    }
    // 收尾：时间戳 + 系统熵
    digest = sha256.convert([
      ...digest,
      ...utf8.encode(DateTime.now().microsecondsSinceEpoch.toString()),
      ..._secureBytes(16),
    ]).bytes;

    // 链式 SHA256 扩展为 count 个数（避免简单切片相关性）
    final nums = <int>[];
    var cur = digest;
    for (var i = 0; i < count; i++) {
      cur = sha256.convert([...cur, i]).bytes;
      final hex = cur.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      final big = BigInt.parse(hex, radix: 16);
      nums.add((big % BigInt.from(vmax)).toInt() + 1);
    }
    return EntropySample(
        numbers: nums, sources: results, timestamp: DateTime.now());
  }

  Uint8List _secureBytes(int n) {
    final rng = Random.secure();
    final b = Uint8List(n);
    for (var i = 0; i < n; i++) {
      b[i] = rng.nextInt(256);
    }
    return b;
  }
}
