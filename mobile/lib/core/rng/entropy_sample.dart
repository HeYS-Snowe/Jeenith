// Copyright (c) 2026 Qore
import 'package:flutter/foundation.dart';

/// 单个熵源的采样结果（用于界面展示「本次真随机采样」详情）。
@immutable
class EntropySourceResult {
  /// 源名称，如「系统熵 Random.secure()」
  final String name;

  /// 展示值，如十六进制片段 /「30 采样点」/「3,5,7...」
  final String display;

  /// 本次采样是否成功
  final bool succeeded;

  const EntropySourceResult({
    required this.name,
    required this.display,
    required this.succeeded,
  });
}

/// 一次真随机生成的完整采样。
@immutable
class EntropySample {
  /// 生成的整数列表（如小六壬三数）
  final List<int> numbers;

  /// 各熵源的采样明细
  final List<EntropySourceResult> sources;

  final DateTime timestamp;

  const EntropySample({
    required this.numbers,
    required this.sources,
    required this.timestamp,
  });
}
