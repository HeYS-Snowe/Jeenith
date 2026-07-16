// Copyright (c) 2026 Qore
import 'dart:typed_data';

/// 单个熵源接口。各源实现采样，返回展示值 + 用于混合的字节。
abstract class EntropyCollector {
  String get name;
  bool get isAvailable;
  Future<({String display, Uint8List bytes})> sample();
}
