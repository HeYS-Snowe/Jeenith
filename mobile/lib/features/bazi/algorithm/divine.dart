// Copyright (c) 2026 Qore
import 'package:lunar/lunar.dart';

import 'shensha.dart';

// -- Five-element helpers ------------------------------------------------

/// Branch → primary five-element (本气五行).
const Map<String, String> zhiWuxing = {
  '子': '水', '丑': '土',
  '寅': '木', '卯': '木',
  '辰': '土', '巳': '火',
  '午': '火', '未': '土',
  '申': '金', '酉': '金',
  '戌': '土', '亥': '水',
};

/// Hidden-stem weights: 本气 1.0, 中气 0.5, 余气 0.3.
const List<double> hideGanWeights = [1.0, 0.5, 0.3];

const List<String> wuxingNames = ['木', '火', '土', '金', '水'];

const Map<String, String> wuxingColorLabel = {
  '木': '青', '火': '赤', '土': '黄', '金': '白', '水': '黑',
};

// -- Data models ---------------------------------------------------------

/// A single pillar (year/month/day/time) with all derived attributes.
class PillarInfo {
  final String label;       // 年柱 / 月柱 / 日柱 / 时柱
  final String ganZhi;      // e.g. 甲子
  final String gan;         // 甲
  final String zhi;         // 子
  final String wuxing;      // gan-zhi elements, e.g. 木水
  final String nayin;       // 海中金
  final String shishenGan;  // ten-god of the stem (日主 for day pillar)
  final List<String> hideGan;
  final List<String> shishenZhi; // ten-gods of hidden stems
  final String dishi;       // 12-stage position (长生/沐浴/...)

  const PillarInfo({
    required this.label,
    required this.ganZhi,
    required this.gan,
    required this.zhi,
    required this.wuxing,
    required this.nayin,
    required this.shishenGan,
    required this.hideGan,
    required this.shishenZhi,
    required this.dishi,
  });
}

/// One decade pillar (大运).
class DaYunInfo {
  final String ganZhi;
  final int startYear;
  final int endYear;
  final int startAge;
  final int endAge;
  final String shishenGan;
  final bool isCurrent;

  const DaYunInfo({
    required this.ganZhi,
    required this.startYear,
    required this.endYear,
    required this.startAge,
    required this.endAge,
    required this.shishenGan,
    required this.isCurrent,
  });
}

/// Current annual pillar (流年).
class LiuNianInfo {
  final int year;
  final int age;
  final String ganZhi;
  final String shishenGan;

  const LiuNianInfo({
    required this.year,
    required this.age,
    required this.ganZhi,
    required this.shishenGan,
  });
}

/// Five-element distribution entry.
class WuxingCount {
  final String element;
  final double score;

  const WuxingCount(this.element, this.score);
}

/// Full Ba-Zi divination result.
class BaziResult {
  final String solarDisplay;    // e.g. 1990年5月15日
  final String lunarDisplay;    // e.g. 农历庚午年四月廿一
  final String genderLabel;     // 男 / 女
  final List<PillarInfo> pillars; // 3 (no time) or 4 pillars
  final String dayGan;          // day master stem
  final String dayGanWuxing;    // day master element
  final bool hasTime;           // whether time pillar exists

  /// Decade pillars (大运). Empty when [hasTime] is false.
  final List<DaYunInfo> daYuns;
  final String? startYunDisplay; // 起运年龄描述
  final bool yunForward;        // 顺排/逆排

  /// Current annual pillar. Always computed.
  final LiuNianInfo currentLiuNian;

  final List<ShenShaHit> shenshas;
  final List<WuxingCount> wuxingDistribution;
  final String wuxingAnalysis;  // five-element strength analysis
  final String mingGe;          // destiny assessment
  final String jieShu;          // caution / warning text

  final DateTime divineTime;

  const BaziResult({
    required this.solarDisplay,
    required this.lunarDisplay,
    required this.genderLabel,
    required this.pillars,
    required this.dayGan,
    required this.dayGanWuxing,
    required this.hasTime,
    required this.daYuns,
    required this.startYunDisplay,
    required this.yunForward,
    required this.currentLiuNian,
    required this.shenshas,
    required this.wuxingDistribution,
    required this.wuxingAnalysis,
    required this.mingGe,
    required this.jieShu,
    required this.divineTime,
  });
}

// -- Main entry ----------------------------------------------------------

/// Compute a Ba-Zi (Four Pillars) reading.
///
/// [year]/[month]/[day] — solar (Gregorian) birth date.
/// [hourIndex] — 0-11 for 子-亥, or null when the birth hour is unknown.
///   When null the time pillar and decade pillars (大运) are skipped.
/// [gender] — 1 = male, 0 = female.
BaziResult divine({
  required int year,
  required int month,
  required int day,
  int? hourIndex,
  required int gender,
}) {
  final hasTime = hourIndex != null;
  // Use a neutral noon hour when birth time is unknown so the day pillar
  // is unaffected; the time pillar simply won't be displayed.
  final hour = hasTime ? hourIndex * 2 : 12;

  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  final dayGan = ec.getDayGan();
  final dayGanWx = ganWuxing[dayGan]!;
  final yearGan = ec.getYearGan();
  final yearZhi = ec.getYearZhi();

  // -- Build pillar list ------------------------------------------------
  final pillarSpecs = [
    ('年柱', ec.getYear(), ec.getYearGan(), ec.getYearZhi(),
        ec.getYearWuXing(), ec.getYearNaYin(), ec.getYearShiShenGan(),
        ec.getYearHideGan(), ec.getYearShiShenZhi(), ec.getYearDiShi()),
    ('月柱', ec.getMonth(), ec.getMonthGan(), ec.getMonthZhi(),
        ec.getMonthWuXing(), ec.getMonthNaYin(), ec.getMonthShiShenGan(),
        ec.getMonthHideGan(), ec.getMonthShiShenZhi(), ec.getMonthDiShi()),
    ('日柱', ec.getDay(), ec.getDayGan(), ec.getDayZhi(),
        ec.getDayWuXing(), ec.getDayNaYin(), '日主',
        ec.getDayHideGan(), ec.getDayShiShenZhi(), ec.getDayDiShi()),
  ];

  final pillars = <PillarInfo>[];
  for (final s in pillarSpecs) {
    pillars.add(PillarInfo(
      label: s.$1,
      ganZhi: s.$2,
      gan: s.$3,
      zhi: s.$4,
      wuxing: s.$5,
      nayin: s.$6,
      shishenGan: s.$7,
      hideGan: s.$8,
      shishenZhi: s.$9,
      dishi: s.$10,
    ));
  }

  if (hasTime) {
    pillars.add(PillarInfo(
      label: '时柱',
      ganZhi: ec.getTime(),
      gan: ec.getTimeGan(),
      zhi: ec.getTimeZhi(),
      wuxing: ec.getTimeWuXing(),
      nayin: ec.getTimeNaYin(),
      shishenGan: ec.getTimeShiShenGan(),
      hideGan: ec.getTimeHideGan(),
      shishenZhi: ec.getTimeShiShenZhi(),
      dishi: ec.getTimeDiShi(),
    ));
  }

  // -- Decade pillars (大运) — only when hour is known -------------------
  final daYuns = <DaYunInfo>[];
  String? startYunDisplay;
  var yunForward = true;

  if (hasTime) {
    final yun = ec.getYun(gender, 1);
    yunForward = yun.isForward();
    final startSolar = yun.getStartSolar();
    startYunDisplay =
        '${yun.getStartYear()}年${yun.getStartMonth()}月${yun.getStartDay()}天起运'
        '（${startSolar.getYear()}年${startSolar.getMonth()}月${startSolar.getDay()}日）';

    final allDaYun = yun.getDaYunBy(9); // index 0 = pre-luck period
    final nowYear = DateTime.now().year;

    for (var i = 1; i < allDaYun.length; i++) {
      final dy = allDaYun[i];
      final gz = dy.getGanZhi();
      if (gz.isEmpty) continue;
      final gan = gz[0];
      daYuns.add(DaYunInfo(
        ganZhi: gz,
        startYear: dy.getStartYear(),
        endYear: dy.getEndYear(),
        startAge: dy.getStartAge(),
        endAge: dy.getEndAge(),
        shishenGan: shishenOf(dayGan, gan),
        isCurrent: nowYear >= dy.getStartYear() && nowYear <= dy.getEndYear(),
      ));
    }
  }

  // -- Current annual pillar (流年) — always computed --------------------
  final nowLunar = Lunar.fromDate(DateTime.now());
  final currentYearGz = nowLunar.getYearInGanZhiExact();
  final currentYear = DateTime.now().year;
  final birthYear = solar.getYear();
  final currentAge = currentYear - birthYear + 1; // 虚岁

  final currentLiuNian = LiuNianInfo(
    year: currentYear,
    age: currentAge,
    ganZhi: currentYearGz,
    shishenGan: shishenOf(dayGan, currentYearGz[0]),
  );

  // -- Shen-sha ---------------------------------------------------------
  final pillarMap = <String, String>{};
  for (final p in pillars) {
    pillarMap[p.label] = p.zhi;
  }
  final shenshas = detectShenShas(
    pillars: pillarMap,
    yearGan: yearGan,
    dayGan: dayGan,
    yearZhi: yearZhi,
  );

  // -- Five-element distribution ----------------------------------------
  final wxScores = <String, double>{
    '木': 0, '火': 0, '土': 0, '金': 0, '水': 0,
  };

  for (final p in pillars) {
    // Stem contributes 1.0
    wxScores[ganWuxing[p.gan]!] = wxScores[ganWuxing[p.gan]!]! + 1.0;
    // Hidden stems contribute weighted
    for (var i = 0; i < p.hideGan.length; i++) {
      final wx = ganWuxing[p.hideGan[i]]!;
      final w = i < hideGanWeights.length ? hideGanWeights[i] : 0.3;
      wxScores[wx] = wxScores[wx]! + w;
    }
  }

  final wuxingDistribution = wuxingNames.map((e) {
    return WuxingCount(e, wxScores[e]!);
  }).toList()
    ..sort((a, b) => b.score.compareTo(a.score));

  // -- Five-element analysis --------------------------------------------
  final analysis = _buildWuxingAnalysis(
    dayGan: dayGan,
    dayGanWx: dayGanWx,
    monthZhi: ec.getMonthZhi(),
    wxScores: wxScores,
    pillars: pillars,
  );

  // -- Destiny assessment & caution -------------------------------------
  final mingGe = _buildMingGe(
    dayGan: dayGan,
    dayGanWx: dayGanWx,
    monthZhi: ec.getMonthZhi(),
    pillars: pillars,
    analysis: analysis,
  );

  final jieShu = _buildJieShu(
    pillars: pillars,
    shenshas: shenshas,
    wxScores: wxScores,
    dayGanWx: dayGanWx,
  );

  return BaziResult(
    solarDisplay: '$year年$month月$day日'
        '${hasTime ? ' ${shichenLabel(hourIndex)}' : ''}',
    lunarDisplay: '农历${lunar.getYearInChinese()}年'
        '${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    genderLabel: gender == 1 ? '男' : '女',
    pillars: pillars,
    dayGan: dayGan,
    dayGanWuxing: dayGanWx,
    hasTime: hasTime,
    daYuns: daYuns,
    startYunDisplay: startYunDisplay,
    yunForward: yunForward,
    currentLiuNian: currentLiuNian,
    shenshas: shenshas,
    wuxingDistribution: wuxingDistribution,
    wuxingAnalysis: analysis,
    mingGe: mingGe,
    jieShu: jieShu,
    divineTime: DateTime.now(),
  );
}

// -- Helpers -------------------------------------------------------------

/// Convert hour index (0-11) to Chinese shichen label.
String shichenLabel(int hourIndex) {
  const labels = ['子时', '丑时', '寅时', '卯时', '辰时', '巳时',
      '午时', '未时', '申时', '酉时', '戌时', '亥时'];
  if (hourIndex < 0 || hourIndex > 11) return '';
  return labels[hourIndex];
}

/// Determine whether the month branch supports the day master.
/// Returns: 1 (得令), -1 (失令), 0 (中性).
int _monthSupport(String dayGanWx, String monthZhi) {
  final monthWx = zhiWuxing[monthZhi]!;
  if (dayGanWx == monthWx) return 1;            // same element — 比劫当令
  if (wuxingSheng[monthWx] == dayGanWx) return 1; // month generates day — 印当令
  if (wuxingKe[monthWx] == dayGanWx) return -1;   // month controls day — 官杀当令
  if (wuxingSheng[dayGanWx] == monthWx) return -1; // day generates month — 耗
  if (wuxingKe[dayGanWx] == monthWx) return -1;   // day controls month — 泄
  return 0;
}

String _buildWuxingAnalysis({
  required String dayGan,
  required String dayGanWx,
  required String monthZhi,
  required Map<String, double> wxScores,
  required List<PillarInfo> pillars,
}) {
  final buf = StringBuffer();

  // Day master strength
  final monthSup = _monthSupport(dayGanWx, monthZhi);
  var supportScore = monthSup * 2.0;

  // Count roots in other branches
  for (final p in pillars) {
    if (p.label == '月柱') continue;
    for (final hg in p.hideGan) {
      if (ganWuxing[hg] == dayGanWx) {
        supportScore += 0.5;
      }
      // Resource element also helps
      if (wuxingSheng[ganWuxing[hg]!] == dayGanWx) {
        supportScore += 0.3;
      }
    }
  }

  // Count peer/resource in other stems
  for (final p in pillars) {
    if (p.label == '日柱') continue;
    final pWx = ganWuxing[p.gan]!;
    if (pWx == dayGanWx) supportScore += 0.5;
    if (wuxingSheng[pWx] == dayGanWx) supportScore += 0.3;
  }

  final isStrong = supportScore > 2.5;
  final isWeak = supportScore < 1.0;

  buf.write('日主$dayGan（$dayGanWx），');
  if (isStrong) {
    buf.write('生于$monthZhi月得令，四柱帮扶有力，属身强之命。');
    buf.write('宜以官杀制身、食伤泄秀、财星耗身为用。');
  } else if (isWeak) {
    buf.write('生于$monthZhi月失令，四柱帮扶不足，属身弱之命。');
    buf.write('宜以印星生身、比劫帮身为用，忌官杀财星过重。');
  } else {
    buf.write('生于$monthZhi月，四柱五行较为均衡，身命中和。');
    buf.write('宜随大运流年取用，趋吉避凶。');
  }

  // Element distribution
  final sorted = wuxingNames.map((e) => WuxingCount(e, wxScores[e]!)).toList()
    ..sort((a, b) => b.score.compareTo(a.score));
  final most = sorted.first;
  final least = sorted.last;

  buf.write('\n五行分布：');
  for (final e in sorted) {
    buf.write('${e.element}(${e.score.toStringAsFixed(1)}) ');
  }
  buf.write('\n${most.element}最旺（${wuxingColorLabel[most.element]}），'
      '${least.element}最弱（${wuxingColorLabel[least.element]}）。');

  if (least.score < 0.5) {
    buf.write('${least.element}极弱，需注意对应脏腑调养。');
  }

  return buf.toString();
}

String _buildMingGe({
  required String dayGan,
  required String dayGanWx,
  required String monthZhi,
  required List<PillarInfo> pillars,
  required String analysis,
}) {
  final buf = StringBuffer();

  // Month-based格局 hint
  final monthHideGan = pillars.firstWhere((p) => p.label == '月柱').hideGan;
  final monthMainShishen = shishenOf(dayGan, monthHideGan.first);

  buf.write('日主$dayGan$dayGanWx生于$monthZhi月，');
  buf.write('月令本气${monthHideGan.first}为「$monthMainShishen」，');

  // Simplified格局 naming
  switch (monthMainShishen) {
    case '正官':
      buf.write('正官格。主为人端正，行事有规有矩，利于仕途功名。');
      break;
    case '七杀':
      buf.write('七杀格。主性情刚毅，有开创之能，喜食伤制杀或印化杀。');
      break;
    case '正印':
      buf.write('正印格。主聪慧仁慈，学业有成，受长辈荫庇。');
      break;
    case '偏印':
      buf.write('偏印格。主才思独特，喜偏门学问，性情多思。');
      break;
    case '正财':
      buf.write('正财格。主勤勉理财，为人务实，财源稳定。');
      break;
    case '偏财':
      buf.write('偏财格。主慷慨多情，财来财去，利于经营投机。');
      break;
    case '食神':
      buf.write('食神格。主温和有礼，衣食丰足，才艺过人。');
      break;
    case '伤官':
      buf.write('伤官格。主才华横溢，桀骜不驯，喜佩印制约。');
      break;
    case '比肩':
      buf.write('建禄格。主独立自主，刚健不屈，喜财官并用。');
      break;
    case '劫财':
      buf.write('羊刃格。主争强好胜，刚烈果断，喜官杀制刃。');
      break;
    default:
      buf.write('格局待定。');
  }

  // Personality hint from day master element
  buf.write('\n$dayGanWx性之人，');
  switch (dayGanWx) {
    case '木':
      buf.write('如木之向上，仁慈正直，有进取心，然易固执。');
      break;
    case '火':
      buf.write('如火之炎上，热情有礼，精力充沛，然易急躁。');
      break;
    case '土':
      buf.write('如土之厚重，诚实守信，包容力强，然易保守。');
      break;
    case '金':
      buf.write('如金之刚毅，果断重义，做事利落，然易刚愎。');
      break;
    case '水':
      buf.write('如水之智慧，灵活多谋，善于变通，然易动摇。');
      break;
  }

  return buf.toString();
}

String _buildJieShu({
  required List<PillarInfo> pillars,
  required List<ShenShaHit> shenshas,
  required Map<String, double> wxScores,
  required String dayGanWx,
}) {
  final warnings = <String>[];

  // Check for strong 七杀 without control
  var qishaCount = 0;
  var shishenCount = 0;
  for (final p in pillars) {
    if (p.shishenGan == '七杀') qishaCount++;
    if (p.shishenGan == '食神') shishenCount++;
    for (final ss in p.shishenZhi) {
      if (ss == '七杀') qishaCount++;
      if (ss == '食神') shishenCount++;
    }
  }
  if (qishaCount >= 2 && shishenCount == 0) {
    warnings.add('七杀重而无食神制化，需防事业压力及小人是非，宜修忍辱。');
  }

  // Check for strong 伤官
  var shangGuanCount = 0;
  for (final p in pillars) {
    if (p.shishenGan == '伤官') shangGuanCount++;
    if (p.shishenZhi.contains('伤官')) shangGuanCount++;
  }
  if (shangGuanCount >= 2) {
    warnings.add('伤官重则克官，需防人际关系冲突及感情波折，宜佩印修身。');
  }

  // Check for 桃花 + 伤官
  final hasTaoHua = shenshas.any((s) => s.name == '桃花');
  if (hasTaoHua && shangGuanCount >= 1) {
    warnings.add('桃花逢伤官，异性缘旺而易生感情纠葛，需自持定力。');
  }

  // Five-element severe imbalance
  final maxScore = wxScores.values.reduce((a, b) => a > b ? a : b);
  final minScore = wxScores.values.reduce((a, b) => a < b ? a : b);
  if (maxScore > 4.0 && minScore < 0.5) {
    final lacking = wuxingNames.firstWhere((e) => wxScores[e] == minScore);
    warnings.add('五行$lacking极弱，需注意${_organHint(lacking)}调养，'
        '大运流年遇$lacking旺时需防失衡之患。');
  }

  // Check for 亡神
  final hasWangShen = shenshas.any((s) => s.name == '亡神');
  if (hasWangShen) {
    warnings.add('命带亡神，主谋略深沉亦易暗耗心神，宜防口舌是非。');
  }

  if (warnings.isEmpty) {
    return '四柱五行较为调和，无显著劫数预警。宜行善积德，顺势而为。';
  }
  return warnings.join('\n');
}

/// TCM organ association for each five-element.
String _organHint(String wx) {
  switch (wx) {
    case '木':
      return '肝胆';
    case '火':
      return '心血';
    case '土':
      return '脾胃';
    case '金':
      return '肺大肠';
    case '水':
      return '肾膀胱';
    default:
      return '身体';
  }
}
