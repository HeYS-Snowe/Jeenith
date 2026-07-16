// Copyright (c) 2026 Qore

// Shen-sha (神煞) lookup tables and detection.
//
// Implements 8 commonly used auspicious/inauspicious stars:
// 天乙贵人, 文昌, 太极贵人, 华盖, 驿马, 桃花, 将星, 亡神.
//
// All tables follow the traditional rules used in standard Si-Zhu
// (Four Pillars) practice.

// -- Heavenly stem five-element and yin/yang -----------------------------

const Map<String, String> ganWuxing = {
  '甲': '木', '乙': '木',
  '丙': '火', '丁': '火',
  '戊': '土', '己': '土',
  '庚': '金', '辛': '金',
  '壬': '水', '癸': '水',
};

const Map<String, bool> ganIsYang = {
  '甲': true, '乙': false,
  '丙': true, '丁': false,
  '戊': true, '己': false,
  '庚': true, '辛': false,
  '壬': true, '癸': false,
};

// -- Ten gods (十神) -----------------------------------------------------

/// Five-element generation cycle: key generates value.
const Map<String, String> wuxingSheng = {
  '木': '火', '火': '土', '土': '金', '金': '水', '水': '木',
};

/// Five-element control cycle: key controls value.
const Map<String, String> wuxingKe = {
  '木': '土', '土': '水', '水': '火', '火': '金', '金': '木',
};

/// Compute the ten-god (十神) of [otherGan] relative to the day master [dayGan].
String shishenOf(String dayGan, String otherGan) {
  final dayWx = ganWuxing[dayGan]!;
  final otherWx = ganWuxing[otherGan]!;
  final samePolarity = ganIsYang[dayGan]! == ganIsYang[otherGan]!;

  if (dayWx == otherWx) {
    return samePolarity ? '比肩' : '劫财';
  }
  if (wuxingSheng[otherWx] == dayWx) {
    // other generates day → resource (印)
    return samePolarity ? '偏印' : '正印';
  }
  if (wuxingSheng[dayWx] == otherWx) {
    // day generates other → output (食伤)
    return samePolarity ? '食神' : '伤官';
  }
  if (wuxingKe[otherWx] == dayWx) {
    // other controls day → officer (官杀)
    return samePolarity ? '七杀' : '正官';
  }
  // day controls other → wealth (财)
  return samePolarity ? '偏财' : '正财';
}

// -- Shen-sha tables -----------------------------------------------------

/// 天乙贵人 — by day stem.
const Map<String, List<String>> tianYiGuiRen = {
  '甲': ['丑', '未'], '戊': ['丑', '未'], '庚': ['丑', '未'],
  '乙': ['子', '申'], '己': ['子', '申'],
  '丙': ['亥', '酉'], '丁': ['亥', '酉'],
  '壬': ['卯', '巳'], '癸': ['卯', '巳'],
  '辛': ['寅', '午'],
};

/// 文昌 — by day stem.
const Map<String, String> wenChang = {
  '甲': '巳', '乙': '午',
  '丙': '申', '戊': '申',
  '丁': '酉', '己': '酉',
  '庚': '亥', '辛': '子',
  '壬': '寅', '癸': '卯',
};

/// 太极贵人 — by year stem.
const Map<String, List<String>> taiJiGuiRen = {
  '甲': ['子', '午'], '乙': ['子', '午'],
  '丙': ['卯', '酉'], '丁': ['卯', '酉'],
  '戊': ['辰', '戌', '丑', '未'], '己': ['辰', '戌', '丑', '未'],
  '庚': ['寅', '亥'], '辛': ['寅', '亥'],
  '壬': ['巳', '申'], '癸': ['巳', '申'],
};

/// 三合局 → 华盖 (by year/day branch).
const Map<String, String> huaGai = {
  '申': '辰', '子': '辰', '辰': '辰',
  '巳': '丑', '酉': '丑', '丑': '丑',
  '亥': '未', '卯': '未', '未': '未',
  '寅': '戌', '午': '戌', '戌': '戌',
};

/// 三合局 → 驿马 (by year/day branch).
const Map<String, String> yiMa = {
  '申': '寅', '子': '寅', '辰': '寅',
  '巳': '亥', '酉': '亥', '丑': '亥',
  '亥': '巳', '卯': '巳', '未': '巳',
  '寅': '申', '午': '申', '戌': '申',
};

/// 三合局 → 桃花 (by year/day branch).
const Map<String, String> taoHua = {
  '申': '酉', '子': '酉', '辰': '酉',
  '巳': '午', '酉': '午', '丑': '午',
  '亥': '子', '卯': '子', '未': '子',
  '寅': '卯', '午': '卯', '戌': '卯',
};

/// 三合局 → 将星 (by year/day branch).
const Map<String, String> jiangXing = {
  '申': '子', '子': '子', '辰': '子',
  '巳': '酉', '酉': '酉', '丑': '酉',
  '亥': '卯', '卯': '卯', '未': '卯',
  '寅': '午', '午': '午', '戌': '午',
};

/// 三合局 → 亡神 (by year/day branch).
const Map<String, String> wangShen = {
  '申': '亥', '子': '亥', '辰': '亥',
  '巳': '申', '酉': '申', '丑': '申',
  '亥': '寅', '卯': '寅', '未': '寅',
  '寅': '巳', '午': '巳', '戌': '巳',
};

/// Human-readable descriptions for each shen-sha.
const Map<String, String> shenshaDescriptions = {
  '天乙贵人': '至尊吉神，逢凶化吉，贵人相助。',
  '文昌': '主聪慧好学，文采出众，利于科考。',
  '太极贵人': '主聪明好学，有钻劲，喜文史宗教。',
  '华盖': '主孤高才华，性灵聪慧，利艺术修行。',
  '驿马': '主奔波走动，外出远行，变动不居。',
  '桃花': '主异性缘佳，风流文采，人缘广阔。',
  '将星': '主权柄威严，领导才能，果敢决断。',
  '亡神': '主心机谋略，喜怒不形于色，亦主暗损。',
};

/// A detected shen-sha instance tied to a specific pillar.
class ShenShaHit {
  final String name;
  final String pillarLabel; // 年/月/日/时
  final String branch;      // the branch where the star lands

  const ShenShaHit({
    required this.name,
    required this.pillarLabel,
    required this.branch,
  });
}

/// Detect all shen-sha across the given pillars.
///
/// [pillars] maps a label (年/月/日/时) to its branch character.
/// [yearGan] is the year stem (for 太极贵人).
/// [dayGan] is the day stem (for 天乙贵人 and 文昌).
/// [yearZhi] is the year branch (for 三合-based stars).
List<ShenShaHit> detectShenShas({
  required Map<String, String> pillars,
  required String yearGan,
  required String dayGan,
  required String yearZhi,
}) {
  final hits = <ShenShaHit>[];

  // Helper: check if any pillar's branch matches target(s).
  void check(String name, List<String> targets) {
    for (final entry in pillars.entries) {
      if (targets.contains(entry.value)) {
        hits.add(ShenShaHit(
          name: name,
          pillarLabel: entry.key,
          branch: entry.value,
        ));
      }
    }
  }

  // 天乙贵人 — by day stem
  if (tianYiGuiRen.containsKey(dayGan)) {
    check('天乙贵人', tianYiGuiRen[dayGan]!);
  }

  // 文昌 — by day stem
  if (wenChang.containsKey(dayGan)) {
    check('文昌', [wenChang[dayGan]!]);
  }

  // 太极贵人 — by year stem
  if (taiJiGuiRen.containsKey(yearGan)) {
    check('太极贵人', taiJiGuiRen[yearGan]!);
  }

  // 三合-based stars — by year branch
  if (huaGai.containsKey(yearZhi)) {
    check('华盖', [huaGai[yearZhi]!]);
  }
  if (yiMa.containsKey(yearZhi)) {
    check('驿马', [yiMa[yearZhi]!]);
  }
  if (taoHua.containsKey(yearZhi)) {
    check('桃花', [taoHua[yearZhi]!]);
  }
  if (jiangXing.containsKey(yearZhi)) {
    check('将星', [jiangXing[yearZhi]!]);
  }
  if (wangShen.containsKey(yearZhi)) {
    check('亡神', [wangShen[yearZhi]!]);
  }

  return hits;
}
