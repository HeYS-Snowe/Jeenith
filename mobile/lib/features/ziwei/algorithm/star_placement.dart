// Copyright (c) 2026 Qore

import '../data/stars.dart';

/// 单颗星曜在宫位中的占位。
class StarPlacement {
  final String name;
  final StarCategory category;
  /// 四化标记（仅年干所化的 4 颗星有值，其余为 null）。
  final SiHua? sihua;
  const StarPlacement(this.name, this.category, {this.sihua});

  @override
  bool operator ==(Object other) =>
      other is StarPlacement &&
      other.name == name &&
      other.category == category &&
      other.sihua == sihua;

  @override
  int get hashCode => Object.hash(name, category, sihua);
}

/// 完整的紫微斗数星盘：12 宫（按地支 0-11 索引）每宫的星曜列表。
///
/// 宫内星曜已按 [StarCategory] 排序：主→吉→煞→博→神。
class StarChart {
  final List<List<StarPlacement>> gongStars;
  const StarChart(this.gongStars);

  factory StarChart.empty() => StarChart(List.generate(12, (_) => const <StarPlacement>[]));

  /// 两个星盘是否一致（用于 shouldRepaint）。
  @override
  bool operator ==(Object other) {
    if (other is! StarChart) return false;
    if (gongStars.length != other.gongStars.length) return false;
    for (var i = 0; i < gongStars.length; i++) {
      if (gongStars[i].length != other.gongStars[i].length) return false;
      for (var j = 0; j < gongStars[i].length; j++) {
        if (gongStars[i][j] != other.gongStars[i][j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(gongStars.expand((e) => e));
}

/// 安星算法：根据生辰参数定位 14 主星 + 六吉六煞 + 博士十二神 + 神煞。
///
/// 参数：
/// - [yearGan]：年干（'甲'..'癸'）
/// - [yearZhi]：年支索引 0..11（子..亥）
/// - [month]：农历月 1..12
/// - [day]：农历日 1..30
/// - [hour]：时支索引 0..11（子=0）
/// - [ju]：五行局数 2/3/4/5/6
StarChart placeStars({
  required String yearGan,
  required int yearZhi,
  required int month,
  required int day,
  required int hour,
  required int ju,
}) {
  final gong = List<List<StarPlacement>>.generate(12, (_) => <StarPlacement>[]);

  void place(int zhi, StarPlacement star) {
    gong[zhi].add(star);
  }

  // === 14 主星 ===
  // 紫微星定位：ziweiPos = (2 + (day-1) ~/ ju) % 12（寅=2）
  final ziweiPos = (2 + (day - 1) ~/ ju) % 12;
  // 天府星定位：关于寅申轴对称，tianfuPos = (4 - ziweiPos + 12) % 12
  final tianfuPos = (4 - ziweiPos + 12) % 12;

  // 紫微系 6 星
  for (final entry in ziweiXiOffset.entries) {
    final pos = (ziweiPos + entry.value + 12) % 12;
    place(pos, StarPlacement(entry.key, StarCategory.main));
  }
  // 天府系 8 星
  for (final entry in tianfuXiOffset.entries) {
    final pos = (tianfuPos + entry.value + 12) % 12;
    place(pos, StarPlacement(entry.key, StarCategory.main));
  }

  // === 六吉星 ===
  // 左辅：从辰（3）起顺数到生月
  final zuoFu = (3 + month) % 12;
  place(zuoFu, StarPlacement('左辅', StarCategory.auspicious));
  // 右弼：从戌（23%12=11）起逆数到生月
  final youBi = (23 - month) % 12;
  place(youBi, StarPlacement('右弼', StarCategory.auspicious));
  // 文昌：从戌（10）起逆数到生时
  final wenChang = (10 + hour) % 12;
  place(wenChang, StarPlacement('文昌', StarCategory.auspicious));
  // 文曲：从辰（4）起顺数到生时
  final wenQu = (4 - hour + 12) % 12;
  place(wenQu, StarPlacement('文曲', StarCategory.auspicious));
  // 天魁：年干查表
  final tianKui = tianKuiByGan[yearGan]!;
  place(tianKui, StarPlacement('天魁', StarCategory.auspicious));
  // 天钺：年干查表
  final tianYue = tianYueByGan[yearGan]!;
  place(tianYue, StarPlacement('天钺', StarCategory.auspicious));

  // === 六煞星 ===
  // 擎羊：年干查表
  final qingYang = qingYangByGan[yearGan]!;
  place(qingYang, StarPlacement('擎羊', StarCategory.malefic));
  // 陀罗：年干查表
  final tuoLuo = tuoLuoByGan[yearGan]!;
  place(tuoLuo, StarPlacement('陀罗', StarCategory.malefic));
  // 火星：年支三合起 + 时支
  final huoStart = huoXingStartByZhi[yearZhi]!;
  final huoXing = (huoStart + hour) % 12;
  place(huoXing, StarPlacement('火星', StarCategory.malefic));
  // 铃星：年支三合起 + 时支
  final lingStart = lingXingStartByZhi[yearZhi]!;
  final lingXing = (lingStart + hour) % 12;
  place(lingXing, StarPlacement('铃星', StarCategory.malefic));
  // 地空：地支逆行，从亥（11）起逆数到生时
  final diKong = (11 - hour + 12) % 12;
  place(diKong, StarPlacement('地空', StarCategory.malefic));
  // 地劫：地支顺行，从亥（11）起顺数到生时
  final diJie = (11 + hour) % 12;
  place(diJie, StarPlacement('地劫', StarCategory.malefic));

  // === 博士十二神 ===
  // 从年干查起始宫位，顺布 12 宫
  final boShiStart = boShiStartByGan[yearGan]!;
  for (var i = 0; i < 12; i++) {
    final pos = (boShiStart + i) % 12;
    place(pos, StarPlacement(boShiShen[i], StarCategory.boshishen));
  }

  // === 神煞 ===
  // 天马：年支三合查表
  final tianMa = tianMaByZhi[yearZhi]!;
  place(tianMa, StarPlacement('天马', StarCategory.shensha));
  // 华盖：年支三合查表
  final huaGai = huaGaiByZhi[yearZhi]!;
  place(huaGai, StarPlacement('华盖', StarCategory.shensha));
  // 桃花：年支三合查表
  final taoHua = taoHuaByZhi[yearZhi]!;
  place(taoHua, StarPlacement('桃花', StarCategory.shensha));
  // 红鸾：从卯（3）起逆数到年支
  final hongLuan = (3 - yearZhi + 12) % 12;
  place(hongLuan, StarPlacement('红鸾', StarCategory.shensha));
  // 天喜：红鸾对宫
  final tianXi = (hongLuan + 6) % 12;
  place(tianXi, StarPlacement('天喜', StarCategory.shensha));

  // === 补充神煞 ===
  // 天刑：正月起酉（9）顺数生月
  final tianXing = (9 + month - 1) % 12;
  place(tianXing, StarPlacement('天刑', StarCategory.shensha));
  // 天姚：正月起丑（1）顺数生月
  final tianYao = (1 + month - 1) % 12;
  place(tianYao, StarPlacement('天姚', StarCategory.shensha));
  // 天官：年干查表
  final tianGuan = tianGuanByGan[yearGan]!;
  place(tianGuan, StarPlacement('天官', StarCategory.shensha));
  // 天福：年干查表
  final tianFu = tianFuByGan[yearGan]!;
  place(tianFu, StarPlacement('天福', StarCategory.shensha));
  // 天巫：年支三合查表
  final tianWu = tianWuByZhi[yearZhi]!;
  place(tianWu, StarPlacement('天巫', StarCategory.shensha));
  // 孤辰：年支季节组查表
  final guChen = guChenByZhi[yearZhi]!;
  place(guChen, StarPlacement('孤辰', StarCategory.shensha));
  // 寡宿：年支季节组查表
  final guaSu = guaSuByZhi[yearZhi]!;
  place(guaSu, StarPlacement('寡宿', StarCategory.shensha));
  // 截空：年干查表（两宫同标）
  final jieKong = jieKongByGan[yearGan]!;
  place(jieKong[0], StarPlacement('截空', StarCategory.shensha));
  place(jieKong[1], StarPlacement('截空', StarCategory.shensha));

  // 每宫星曜按 category.index 排序（主→吉→煞→博→神）
  for (var i = 0; i < 12; i++) {
    gong[i].sort((a, b) => a.category.index.compareTo(b.category.index));
  }

  // === 四化：年干 → 化禄/权/科/忌，给对应星曜打标 ===
  final sihua = sihuaByGan[yearGan]!;
  for (var i = 0; i < 12; i++) {
    final rebuilt = <StarPlacement>[];
    for (final sp in gong[i]) {
      SiHua? sh;
      if (sp.name == sihua.lu) {
        sh = SiHua.lu;
      } else if (sp.name == sihua.quan) {
        sh = SiHua.quan;
      } else if (sp.name == sihua.ke) {
        sh = SiHua.ke;
      } else if (sp.name == sihua.ji) {
        sh = SiHua.ji;
      }
      rebuilt.add(sh == null ? sp : StarPlacement(sp.name, sp.category, sihua: sh));
    }
    gong[i] = rebuilt;
  }

  return StarChart(gong);
}
