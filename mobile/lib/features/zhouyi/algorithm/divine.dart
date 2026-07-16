// Copyright (c) 2026 Qore
import 'dart:math';

import '../../../data/yijing/hexagrams.dart';
import '../../../data/yijing/trigrams.dart';

/// 一爻：(yang) 是否阳爻，(changing) 是否变爻。
typedef Line = ({bool yang, bool changing});

/// 周易金钱卦结果。
class ZhouyiResult {
  final String benName;     // 本卦名
  final String? bianName;   // 变卦名（无变爻则 null）
  final String upperName;   // 本卦上卦名
  final String lowerName;   // 本卦下卦名
  final List<int> changing; // 变爻位（0=初爻，自下而上）
  final List<Line> lines;   // 6 爻（索引 0=初爻）

  const ZhouyiResult({
    required this.benName,
    required this.bianName,
    required this.upperName,
    required this.lowerName,
    required this.changing,
    required this.lines,
  });
}

/// 摇一爻：三铜钱之和。
/// 6=老阴(变) 7=少阳 8=少阴 9=老阳(变)
Line _tossLine(Random rng) {
  final s = (2 + rng.nextInt(2)) + (2 + rng.nextInt(2)) + (2 + rng.nextInt(2));
  return switch (s) {
    6 => (yang: false, changing: true),
    7 => (yang: true, changing: false),
    8 => (yang: false, changing: false),
    _ => (yang: true, changing: true), // 9
  };
}

/// 金钱卦：摇六爻得本卦，老阴老阳变爻翻转得变卦。
/// 传入 [rng]（默认 Random.secure() 真随机），便于测试时注入。
ZhouyiResult divine([Random? rng]) {
  rng ??= Random.secure();
  final lines = [for (var i = 0; i < 6; i++) _tossLine(rng)];

  var benBits = 0;
  for (var i = 0; i < 6; i++) {
    if (lines[i].yang) benBits |= (1 << i);
  }
  final changing = [for (var i = 0; i < 6; i++) if (lines[i].changing) i];

  // 下卦 = 低 3 位，上卦 = 高 3 位
  final lower = benBits & 7;
  final upper = (benBits >> 3) & 7;
  final upName = bin8ToName[upper]!;
  final loName = bin8ToName[lower]!;
  final benName = gua64[(upName, loName)]!;

  String? bianName;
  if (changing.isNotEmpty) {
    var b = benBits;
    for (final i in changing) {
      b ^= (1 << i);
    }
    final bl = b & 7;
    final bu = (b >> 3) & 7;
    bianName = gua64[(bin8ToName[bu]!, bin8ToName[bl]!)];
  }

  return ZhouyiResult(
    benName: benName,
    bianName: bianName,
    upperName: upName,
    lowerName: loName,
    changing: changing,
    lines: lines,
  );
}
