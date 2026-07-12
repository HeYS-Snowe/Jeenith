// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:math';

/// 杯筊三结果。
enum JiaoType {
  sheng, // 圣筊（一正一反）
  xiao,  // 笑筊（两阳面朝上）
  yin,   // 阴筊（两阴面朝上）
}

extension JiaoTypeX on JiaoType {
  String get name => switch (this) {
        JiaoType.sheng => '圣筊',
        JiaoType.xiao => '笑筊',
        JiaoType.yin => '阴筊',
      };
  String get meaning => switch (this) {
        JiaoType.sheng => '一正一反，神明允诺，所问之事可行。',
        JiaoType.xiao => '两阳面朝上，神明嬉笑，问题未明或无须过问，可再思。',
        JiaoType.yin => '两阴面朝上，神明不允，所问不宜，宜止。',
      };
}

/// 一次掷筊结果。
class JiaoResult {
  final bool p1Yang; // 片1阳面（平面）朝上
  final bool p2Yang; // 片2阳面（平面）朝上
  final JiaoType type;

  const JiaoResult(this.p1Yang, this.p2Yang, this.type);
}

/// 掷筊：两片杯筊，真随机。
JiaoResult divine([Random? rng]) {
  rng ??= Random.secure();
  final p1 = rng.nextBool();
  final p2 = rng.nextBool();
  final t = (p1 != p2)
      ? JiaoType.sheng
      : (p1 ? JiaoType.xiao : JiaoType.yin);
  return JiaoResult(p1, p2, t);
}
