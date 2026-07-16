// Copyright (c) 2026 Qore
import 'dart:math';

import '../../../data/yijing/hexagrams.dart';
import '../../../data/yijing/trigrams.dart';

/// 先天八卦序（数 1..8 → 经卦名）：乾 兑 离 震 巽 坎 艮 坤。
const _xiantian = ['乾', '兑', '离', '震', '巽', '坎', '艮', '坤'];

/// 经卦名 → 3 爻二进制（bin8ToName 的反查）。
const _nameToBin = {
  '坤': 0, '震': 1, '坎': 2, '兑': 3,
  '艮': 4, '离': 5, '巽': 6, '乾': 7,
};

/// 梅花易数结果。
class MeihuaResult {
  final String benName;   // 本卦名
  final String bianName;  // 变卦名
  final String upName;    // 本卦上卦
  final String loName;    // 本卦下卦
  final String bianUp;    // 变卦上卦
  final String bianLo;    // 变卦下卦
  final int dong;         // 动爻 1..6（1=初爻）
  final bool dongInUpper; // 动爻是否在上卦（决定体用：动爻所在为用卦，另一为体卦）

  const MeihuaResult({
    required this.benName,
    required this.bianName,
    required this.upName,
    required this.loName,
    required this.bianUp,
    required this.bianLo,
    required this.dong,
    required this.dongInUpper,
  });

  /// 体卦名（不动之卦）。
  String get tiName => dongInUpper ? loName : upName;

  /// 用卦名（动爻所在卦）。
  String get yongName => dongInUpper ? upName : loName;

  /// 动爻的位序（0..5，0=初爻，自下而上）。
  int get dongPos => dong - 1;

  /// 动爻的阴阳（true=阳爻）。
  /// 从本卦动爻所在经卦的二进制值中提取对应位。
  bool get dongYang {
    final bin = _nameToBin[dongInUpper ? upName : loName]!;
    final bit = dongInUpper ? (dong - 4) : (dong - 1);
    return ((bin >> bit) & 1) == 1;
  }
}

/// 梅花易数：以两个数起卦。
///   上卦 = 数一，按先天八卦取（数一 % 8，0 当 8 即坤）
///   下卦 = 数二
///   动爻 = (数一 + 数二) % 6 + 1
MeihuaResult divine(int n1, int n2) {
  if (n1 < 1) n1 = 1;
  if (n2 < 1) n2 = 1;
  final upName = _xiantian[(n1 - 1) % 8];
  final loName = _xiantian[(n2 - 1) % 8];
  final dong = ((n1 + n2) % 6) + 1;
  final benName = gua64[(upName, loName)]!;

  String bianUp = upName, bianLo = loName;
  final dongInUpper = dong > 3;
  if (dongInUpper) {
    final ub = _nameToBin[upName]! ^ (1 << (dong - 4));
    bianUp = bin8ToName[ub]!;
  } else {
    final lb = _nameToBin[loName]! ^ (1 << (dong - 1));
    bianLo = bin8ToName[lb]!;
  }
  final bianName = gua64[(bianUp, bianLo)]!;

  return MeihuaResult(
    benName: benName,
    bianName: bianName,
    upName: upName,
    loName: loName,
    bianUp: bianUp,
    bianLo: bianLo,
    dong: dong,
    dongInUpper: dongInUpper,
  );
}

/// 随机取两个数（真随机），便于「随机起卦」。
(MeihuaResult, int n1, int n2) divineRandom([Random? rng]) {
  rng ??= Random.secure();
  final n1 = rng.nextInt(100) + 1;
  final n2 = rng.nextInt(100) + 1;
  return (divine(n1, n2), n1, n2);
}
