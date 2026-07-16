// Copyright (c) 2026 Qore

/// 掐指推算结果。
class DivineResult {
  final List<int> path;          // 游走路径（每步经过的宫位索引）
  final List<int> lands;         // 三个落点索引
  final List<int> landPositions; // 落点在 path 中的下标
  const DivineResult({
    required this.path,
    required this.lands,
    required this.landPositions,
  });
}

/// 掐指推算（1:1 移植自 Python main.py divine）。
/// 从大安(0)起数，每段 land=(cur+n-1)%6，三段串联。
/// 确定性纯函数，不含随机。
DivineResult divine(List<int> nums) {
  final path = <int>[];
  final lands = <int>[];
  final landPos = <int>[];
  var cur = 0; // 大安起数
  for (final n in nums) {
    final steps = n < 1 ? 1 : n;
    for (var step = 1; step <= steps; step++) {
      path.add((cur + step - 1) % 6);
    }
    final land = (cur + steps - 1) % 6;
    lands.add(land);
    landPos.add(path.length - 1);
    cur = land;
  }
  return DivineResult(path: path, lands: lands, landPositions: landPos);
}
