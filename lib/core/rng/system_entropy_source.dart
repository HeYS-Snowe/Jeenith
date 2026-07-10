// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:math';
import 'dart:typed_data';

import 'entropy_source.dart';

/// 系统熵池 —— 对应 Python 的 os.urandom，移动端用 Random.secure()。
class SystemEntropySource implements EntropyCollector {
  @override
  String get name => '系统熵 Random.secure()';

  @override
  bool get isAvailable => true;

  @override
  Future<({String display, Uint8List bytes})> sample() async {
    final rng = Random.secure();
    final bytes = Uint8List(32);
    for (var i = 0; i < 32; i++) {
      bytes[i] = rng.nextInt(256);
    }
    final hex = bytes
        .sublist(0, 10)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return (display: '$hex…', bytes: bytes);
  }
}
