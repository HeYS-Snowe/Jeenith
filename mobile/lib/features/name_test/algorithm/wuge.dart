// Copyright (c) 2026 Qore. All rights reserved.

import 'strokes_data.dart';

/// Five elements (五行).
enum Wuxing {
  metal, // 金
  wood,   // 木
  water,  // 水
  fire,   // 火
  earth,  // 土
}

extension WuxingX on Wuxing {
  String get label => switch (this) {
        Wuxing.metal => '金',
        Wuxing.wood => '木',
        Wuxing.water => '水',
        Wuxing.fire => '火',
        Wuxing.earth => '土',
      };

  String get nature => switch (this) {
        Wuxing.metal => '刚毅果断',
        Wuxing.wood => '仁慈生长',
        Wuxing.water => '智慧灵动',
        Wuxing.fire => '热情奋发',
        Wuxing.earth => '厚重守信',
      };
}

/// Derive the element from a stroke count by its last digit.
///
/// 1/2→wood, 3/4→fire, 5/6→earth, 7/8→metal, 9/0→water.
Wuxing wuxingOf(int strokes) {
  switch (strokes % 10) {
    case 1:
    case 2:
      return Wuxing.wood;
    case 3:
    case 4:
      return Wuxing.fire;
    case 5:
    case 6:
      return Wuxing.earth;
    case 7:
    case 8:
      return Wuxing.metal;
    default:
      return Wuxing.water;
  }
}

/// Fortune grade of a stroke-count number (81-数理).
class Fortune {
  final int number;
  final String grade; // 大吉 / 吉 / 平 / 凶 / 大凶
  final String desc;   // short phrase

  const Fortune(this.number, this.grade, this.desc);
}

/// Compact 81-数理 table for stroke counts 1..80 (numbers > 80 reduce by mod 80).
///
/// Each entry is "grade|desc".
const List<String> _fortuneTable = [
  '大吉|万物开基', // 1
  '凶|一身孤薄', // 2
  '大吉|福禄长寿', // 3
  '凶|破败凶兆', // 4
  '大吉|福寿双全', // 5
  '吉|安宁自在', // 6
  '吉|刚毅果断', // 7
  '吉|意志坚强', // 8
  '凶|破舟进海', // 9
  '凶|零暗险恶', // 10
  '大吉|稳健吉顺', // 11
  '凶|倦怠无力', // 12
  '大吉|春日牡丹', // 13
  '凶|破兆边缘', // 14
  '大吉|福寿双全', // 15
  '大吉|贵人相助', // 16
  '吉|突破万难', // 17
  '吉|有志竟成', // 18
  '凶|遮云蔽月', // 19
  '凶|屋下藏金', // 20
  '大吉|明月光照', // 21
  '凶|秋草逢霜', // 22
  '大吉|壮丽果敢', // 23
  '大吉|家门余庆', // 24
  '吉|资性英敏', // 25
  '凶|变怪奇异', // 26
  '凶|盛衰交织', // 27
  '凶|家亲缘薄', // 28
  '吉|智谋优秀', // 29
  '凶|浮沉不定', // 30
  '大吉|春日花开', // 31
  '大吉|宝马金鞍', // 32
  '大吉|旭日升天', // 33
  '凶|破家破业', // 34
  '吉|温和平静', // 35
  '凶|侠义风波', // 36
  '大吉|猛虎出林', // 37
  '平|意志薄弱', // 38
  '大吉|富贵荣华', // 39
  '凶|退安享福', // 40
  '大吉|纯阳独秀', // 41
  '凶|寒蝉在柳', // 42
  '凶|邪途散财', // 43
  '凶|破家亡身', // 44
  '大吉|顺风扬帆', // 45
  '凶|载宝沉舟', // 46
  '大吉|开花结子', // 47
  '大吉|青松立鹤', // 48
  '凶|吉凶难分', // 49
  '凶|小草逢春', // 50
  '吉|一盛一衰', // 51
  '吉|达眼通明', // 52
  '凶|忧愁困苦', // 53
  '凶|多难悲愁', // 54
  '吉|外美内苦', // 55
  '凶|浪里行舟', // 56
  '吉|月照春松', // 57
  '吉|晚行遇雨', // 58
  '凶|寒蝉悲风', // 59
  '凶|争名夺利', // 60
  '吉|牡丹芙蓉', // 61
  '凶|衰败寂寞', // 62
  '大吉|万物化育', // 63
  '凶|骨肉分离', // 64
  '大吉|富贵长寿', // 65
  '凶|黑暗不长', // 66
  '吉|顺风通达', // 67
  '吉|兴家立业', // 68
  '凶|非业立破', // 69
  '凶|凄愁悲苦', // 70
  '吉|损力劳神', // 71
  '凶|不能如愿', // 72
  '吉|志高力微', // 73
  '凶|残菊逢霜', // 74
  '吉|退者可安', // 75
  '凶|倾覆离散', // 76
  '吉|先苦后甘', // 77
  '凶|晚境多忧', // 78
  '凶|挽回乏力', // 79
  '凶|乘凶入门', // 80
];

/// Look up the fortune for a stroke number (>80 wraps by mod 80).
Fortune fortuneOf(int strokes) {
  final k = ((strokes - 1) % 80) + 1; // 1..80
  final parts = _fortuneTable[k - 1].split('|');
  return Fortune(k, parts[0], parts[1]);
}

/// A single grid result (one of the five grids).
class GeResult {
  final String name;     // 天格 / 人格 / 地格 / 总格 / 外格
  final String role;     // 主运 / 副运 etc.
  final int strokes;
  final Wuxing wuxing;
  final Fortune fortune;

  const GeResult(this.name, this.role, this.strokes, this.wuxing, this.fortune);
}

/// Aggregate five-grid analysis result.
class WugeResult {
  final String fullName;
  final List<String> chars;     // each character
  final List<int> strokes;      // each character's Kangxi strokes
  final List<bool> missing;     // whether each char was estimated (not in table)
  final bool compoundSurname;  // 复姓?
  final GeResult tian;          // 天格
  final GeResult ren;           // 人格 (主运)
  final GeResult di;            // 地格 (前运)
  final GeResult zong;          // 总格 (晚运)
  final GeResult wai;           // 外格 (副运)
  final String summary;         // 综合批断
  final DateTime time;

  const WugeResult({
    required this.fullName,
    required this.chars,
    required this.strokes,
    required this.missing,
    required this.compoundSurname,
    required this.tian,
    required this.ren,
    required this.di,
    required this.zong,
    required this.wai,
    required this.summary,
    required this.time,
  });

  /// Whether any character lacked stroke data (UI uses this to warn).
  bool get hasMissing => missing.any((m) => m);

  /// Five-element distribution across the five grids.
  Map<Wuxing, int> get wuxingCount {
    final m = <Wuxing, int>{};
    for (final w in Wuxing.values) {
      m[w] = 0;
    }
    for (final g in [tian, ren, di, zong, wai]) {
      m[g.wuxing] = m[g.wuxing]! + 1;
    }
    return m;
  }
}

/// Score a grade for summary synthesis.
int _gradeScore(String grade) => switch (grade) {
      '大吉' => 2,
      '吉' => 1,
      '平' => 0,
      '凶' => -1,
      '大凶' => -2,
      _ => 0,
    };

/// Build the comprehensive verdict from the five grids.
String _buildSummary(
  String fullName,
  List<int> strokes,
  GeResult tian,
  GeResult ren,
  GeResult di,
  GeResult zong,
  GeResult wai,
) {
  // Weighted score: 人格(主运) is primary, 总格(晚运) & 地格(前运) secondary.
  final score = _gradeScore(ren.fortune.grade) * 3 +
      _gradeScore(zong.fortune.grade) * 2 +
      _gradeScore(di.fortune.grade) * 2 +
      _gradeScore(wai.fortune.grade) +
      _gradeScore(tian.fortune.grade);

  final buf = StringBuffer();
  buf.writeln('姓名「$fullName」，共 ${strokes.reduce((a, b) => a + b)} 画（康熙）。');

  buf.write('人格（主运）${ren.strokes}画·${ren.wuxing.label}·${ren.fortune.grade}');
  buf.write('，主导一生性格与中年运程，${ren.fortune.desc}。');
  buf.writeln();

  buf.write('地格（前运）${di.strokes}画·${di.fortune.grade}，主青少年至中年前夕，${di.fortune.desc}；');
  buf.write('总格（晚运）${zong.strokes}画·${zong.fortune.grade}，主晚年归宿，${zong.fortune.desc}。');
  buf.writeln();

  buf.write('外格（副运）${wai.strokes}画·${wai.fortune.grade}，主外人缘与外在助力。');
  buf.writeln();

  if (score >= 9) {
    buf.write('综合而论，五格配置上吉，数理通达，主一生根基稳固、福禄绵长。');
  } else if (score >= 5) {
    buf.write('综合而论，五格配置尚佳，虽有微瑕而无大碍，主平顺安康。');
  } else if (score >= -1) {
    buf.write('综合而论，五格配置平常，吉凶参半，宜修德养性以趋吉避凶。');
  } else if (score >= -6) {
    buf.write('综合而论，五格配置偏弱，数理有缺，宜谨慎行事、积德培福。');
  } else {
    buf.write('综合而论，五格配置多凶，数理乖违，恐多波折，宜改名或持善以化解。');
  }

  return buf.toString().trim();
}

/// Run the five-grid analysis on a full Chinese name (2-4 characters).
///
/// Name splitting convention:
///   - 2 chars → 单姓单名 (1 + 1)
///   - 3 chars → 单姓双名 (1 + 2)
///   - 4 chars → 复姓双名 (2 + 2)
WugeResult divineName(String fullName) {
  final chars = fullName.split('');
  final strokes = chars.map(strokeOf).toList();
  final missing = chars.map((c) => !hasStrokeData(c)).toList();

  final n = chars.length;
  final bool compound = n == 4; // 4-char names treated as compound surname + double name
  final surnameLen = compound ? 2 : 1;
  final givenLen = n - surnameLen;

  final surnameStrokes =
      strokes.sublist(0, surnameLen).reduce((a, b) => a + b);
  final givenStrokes =
      strokes.sublist(surnameLen).reduce((a, b) => a + b);

  // 天格: compound → sum of surname strokes; single → surname strokes + 1
  final tianStrokes = compound ? surnameStrokes : surnameStrokes + 1;
  // 人格: last surname char + first given char
  final renStrokes =
      strokes[surnameLen - 1] + strokes[surnameLen];
  // 地格: double name → sum of given strokes; single name → given strokes + 1
  final diStrokes = givenLen == 2 ? givenStrokes : givenStrokes + 1;
  // 总格: all strokes
  final zongStrokes = surnameStrokes + givenStrokes;
  // 外格: 总格 - 人格 + 1
  final waiStrokes = zongStrokes - renStrokes + 1;

  final tian = GeResult('天格', '祖上运', tianStrokes, wuxingOf(tianStrokes),
      fortuneOf(tianStrokes));
  final ren = GeResult('人格', '主运', renStrokes, wuxingOf(renStrokes),
      fortuneOf(renStrokes));
  final di = GeResult('地格', '前运', diStrokes, wuxingOf(diStrokes),
      fortuneOf(diStrokes));
  final zong = GeResult('总格', '晚运', zongStrokes, wuxingOf(zongStrokes),
      fortuneOf(zongStrokes));
  final wai = GeResult('外格', '副运', waiStrokes, wuxingOf(waiStrokes),
      fortuneOf(waiStrokes));

  final now = DateTime.now();
  return WugeResult(
    fullName: fullName,
    chars: chars,
    strokes: strokes,
    missing: missing,
    compoundSurname: compound,
    tian: tian,
    ren: ren,
    di: di,
    zong: zong,
    wai: wai,
    summary: _buildSummary(fullName, strokes, tian, ren, di, zong, wai),
    time: now,
  );
}
