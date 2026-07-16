// Copyright (c) 2026 Qore
import 'dart:math' as math;

import 'package:lunar/lunar.dart';

/// 天干字符（索引：甲0 乙1 丙2 丁3 戊4 己5 庚6 辛7 壬8 癸9）。
const ganChars = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

/// 地支字符（索引：子0 丑1 寅2 卯3 辰4 巳5 午6 未7 申8 酉9 戌10 亥11）。
const zhiChars = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

/// 地支对应的方位（角度，0=北，顺时针）。
const zhiDegrees = {
  '子': 0.0, '癸': 15.0, '丑': 30.0, '艮': 45.0, '寅': 60.0, '甲': 75.0,
  '卯': 90.0, '乙': 105.0, '辰': 120.0, '巽': 135.0, '巳': 150.0, '丙': 165.0,
  '午': 180.0, '丁': 195.0, '未': 210.0, '坤': 225.0, '申': 240.0, '庚': 255.0,
  '酉': 270.0, '辛': 285.0, '戌': 300.0, '乾': 315.0, '亥': 330.0, '壬': 345.0,
};

/// 日干寄宫（按 12 地支本位序号）。
/// 甲寄寅、乙寄辰、丙戊寄巳、丁己寄未、庚寄申、辛寄酉、壬寄亥、癸寄子。
const _ganJiGong = {
  '甲': 2, '乙': 4, '丙': 5, '戊': 5,
  '丁': 7, '己': 7, '庚': 8, '辛': 9,
  '壬': 11, '癸': 0,
};

/// 月将表（中气后月将）：键为中气名，值为月将地支序号。
/// 大寒后子（0），雨水后亥（11），春分后戌（10），谷雨后酉（9），
/// 小满后申（8），夏至后未（7），大暑后午（6），处暑后巳（5），
/// 秋分后辰（4），霜降后卯（3），小雪后寅（2），冬至后丑（1）。
const _yueJiangByZhongQi = {
  '大寒': 0, '雨水': 11, '春分': 10, '谷雨': 9,
  '小满': 8, '夏至': 7, '大暑': 6, '处暑': 5,
  '秋分': 4, '霜降': 3, '小雪': 2, '冬至': 1,
};

/// 十二天将顺序（贵人起，按昼夜顺逆布）。
const tianJiangOrder = [
  '贵人', '螣蛇', '朱雀', '六合', '勾陈', '青龙',
  '天空', '白虎', '太常', '玄武', '太阴', '天后',
];

/// 日干 → 昼贵 / 夜贵（地支序号）。
/// 贵人歌诀：甲戊庚牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸兔蛇藏，六辛逢马虎。
const _guiRen = {
  '甲': {'day': 1, 'night': 7},
  '戊': {'day': 1, 'night': 7},
  '庚': {'day': 1, 'night': 7},
  '乙': {'day': 0, 'night': 8},
  '己': {'day': 0, 'night': 8},
  '丙': {'day': 11, 'night': 9},
  '丁': {'day': 11, 'night': 9},
  '壬': {'day': 3, 'night': 5},
  '癸': {'day': 3, 'night': 5},
  '辛': {'day': 6, 'night': 2},
};

/// 五行枚举。
enum Wuxing { metal, wood, water, fire, earth }

extension WuxingX on Wuxing {
  String get label => switch (this) {
        Wuxing.metal => '金',
        Wuxing.wood => '木',
        Wuxing.water => '水',
        Wuxing.fire => '火',
        Wuxing.earth => '土',
      };
}

/// 天干阴阳：阳干甲丙戊庚壬，阴干乙丁己辛癸。
bool _isYangGan(String gan) => '甲丙戊庚壬'.contains(gan);

/// 地支五行。
Wuxing _zhiWuxing(String zhi) => switch (zhi) {
      '子' || '亥' => Wuxing.water,
      '寅' || '卯' => Wuxing.wood,
      '巳' || '午' => Wuxing.fire,
      '申' || '酉' => Wuxing.metal,
      _ => Wuxing.earth,
    };

/// 五行相克：a 克 b。
bool _ke(Wuxing a, Wuxing b) {
  return (a == Wuxing.metal && b == Wuxing.wood) ||
      (a == Wuxing.wood && b == Wuxing.earth) ||
      (a == Wuxing.earth && b == Wuxing.water) ||
      (a == Wuxing.water && b == Wuxing.fire) ||
      (a == Wuxing.fire && b == Wuxing.metal);
}

/// 单课：含上神（天盘加临）与下神（地盘本位）。
class Ke {
  final String top;
  final String bottom;
  const Ke({required this.top, required this.bottom});

  @override
  String toString() => '$top/$bottom';
}

/// 单传：神（地支）+ 天将。
class Chuan {
  final String shen;
  final String tianJiang;
  const Chuan({required this.shen, required this.tianJiang});

  @override
  String toString() => '$shen（$tianJiang）';
}

/// 大六壬排盘结果。
class DaliurenResult {
  /// 日柱干支（如 "甲子"）。
  final String dayGanZhi;
  /// 时柱干支（如 "丙寅"）。
  final String timeGanZhi;
  /// 农历显示文本。
  final String lunarDisplay;
  /// 月将名（如 "亥"）。
  final String yueJiang;
  /// 四课（按一→四课顺序）。
  final List<Ke> siKe;
  /// 三传（初传→末传）。
  final List<Chuan> sanChuan;
  /// 天盘 12 支（按地盘子位起顺序）。
  final List<String> tianPan;
  /// 地盘 12 支（固定）。
  final List<String> diPan;
  /// 十二天将加临（按地盘子位起顺序，索引 0=子位）。
  final List<String> tianJiangOnTian;
  /// 九宗门名。
  final String zongMen;
  /// 贵人类型：'day' 或 'night'。
  final String guiRenType;
  /// 贵人所在地支。
  final String guiRenZhi;

  const DaliurenResult({
    required this.dayGanZhi,
    required this.timeGanZhi,
    required this.lunarDisplay,
    required this.yueJiang,
    required this.siKe,
    required this.sanChuan,
    required this.tianPan,
    required this.diPan,
    required this.tianJiangOnTian,
    required this.zongMen,
    required this.guiRenType,
    required this.guiRenZhi,
  });
}

/// 取月将序号：优先按最近的中气，否则按公历月份粗略取。
int _getYueJiang(Lunar lunar) {
  final jq = lunar.getCurrentJieQi()?.getName() ?? '';
  if (_yueJiangByZhongQi.containsKey(jq)) {
    return _yueJiangByZhongQi[jq]!;
  }
  final m = lunar.getMonth();
  return switch (m) {
        1 => 0, 2 => 11, 3 => 10, 4 => 9, 5 => 8, 6 => 7,
        7 => 6, 8 => 5, 9 => 4, 10 => 3, 11 => 2, 12 => 1,
        _ => 0,
      };
}

/// 计算三传（简化九宗门：贼克 + 比用 + 涉害）。
///
/// 返回 (三传地支, 宗门名)。
(List<String>, String) _calcSanChuan(
    List<Ke> siKe, String dayGan, List<String> tianPan) {
  // 找四课中所有克关系
  final shangKeXia = <int>[]; // 上克下：上神克下神
  final xiaKeShang = <int>[]; // 下克上：下神克上神

  for (var i = 0; i < siKe.length; i++) {
    final ke = siKe[i];
    final topWx = _zhiWuxing(ke.top);
    final botWx = _zhiWuxing(ke.bottom);
    if (_ke(topWx, botWx)) shangKeXia.add(i);
    if (_ke(botWx, topWx)) xiaKeShang.add(i);
  }
  final allKe = [...shangKeXia, ...xiaKeShang];

  // 工具：取某神在天盘中的上神（递推天盘加临）
  String nextChuan(String shen) => tianPan[zhiChars.indexOf(shen)];

  // 无克 - 简化版用别责法：取一课上神为初传
  if (allKe.isEmpty) {
    final c1 = siKe[0].top;
    final c2 = nextChuan(c1);
    final c3 = nextChuan(c2);
    return ([c1, c2, c3], '别责');
  }

  // 唯一克 - 贼克
  if (allKe.length == 1) {
    final idx = allKe[0];
    final ke = siKe[idx];
    final isShangKe = shangKeXia.contains(idx);
    // 重审（下克上）：初传取下神；元首（上克下）：初传取上神
    final c1 = isShangKe ? ke.top : ke.bottom;
    final c2 = nextChuan(c1);
    final c3 = nextChuan(c2);
    return ([c1, c2, c3], isShangKe ? '元首' : '重审');
  }

  // 多克 - 比用：取与日干同阴阳者
  final isYang = _isYangGan(dayGan);
  final biHeKe = <int>[];
  for (final idx in allKe) {
    final ke = siKe[idx];
    final zhi = shangKeXia.contains(idx) ? ke.top : ke.bottom;
    final zhiIdx = zhiChars.indexOf(zhi);
    // 子0阳 丑1阴 寅2阳... 地支序号偶为阳
    final zhiIsYang = zhiIdx % 2 == 0;
    if (zhiIsYang == isYang) biHeKe.add(idx);
  }

  if (biHeKe.length == 1) {
    final idx = biHeKe[0];
    final ke = siKe[idx];
    final c1 = shangKeXia.contains(idx) ? ke.top : ke.bottom;
    final c2 = nextChuan(c1);
    final c3 = nextChuan(c2);
    return ([c1, c2, c3], '比用');
  }

  // 多比和或全不比和 - 涉害：取涉害深者（简化：用地支序号代表涉害深度）
  final candidates = biHeKe.isNotEmpty ? biHeKe : allKe;
  int maxSheHai = -1;
  int bestIdx = candidates[0];
  for (final idx in candidates) {
    final ke = siKe[idx];
    final zhi = shangKeXia.contains(idx) ? ke.top : ke.bottom;
    final depth = zhiChars.indexOf(zhi);
    if (depth > maxSheHai) {
      maxSheHai = depth;
      bestIdx = idx;
    }
  }
  final ke = siKe[bestIdx];
  final c1 = shangKeXia.contains(bestIdx) ? ke.top : ke.bottom;
  final c2 = nextChuan(c1);
  final c3 = nextChuan(c2);
  return ([c1, c2, c3], '涉害');
}

/// 大六壬起课：公历年月日时 → 排盘结果。
///
/// [year]/[month]/[day] 公历日期，[hour] 0-23。
DaliurenResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  // 日时干支
  final dayGanZhi = ec.getDay();
  final timeGanZhi = ec.getTime();
  final dayGan = dayGanZhi[0];
  final dayZhi = dayGanZhi[1];
  final timeZhi = timeGanZhi[1];

  final dayZhiIdx = zhiChars.indexOf(dayZhi);
  final timeZhiIdx = zhiChars.indexOf(timeZhi);

  // 月将
  final yueJiangIdx = _getYueJiang(lunar);
  final yueJiang = zhiChars[yueJiangIdx];

  // 天盘偏移：地盘 d 位对应天盘 (d + shift) % 12 位
  // 月将加占时：天盘月将位对准地盘占时位 → shift = (timeZhi - yueJiang) mod 12
  final shift = ((timeZhiIdx - yueJiangIdx) % 12 + 12) % 12;
  final tianPan = List<String>.generate(12, (i) => zhiChars[(i + shift) % 12]);
  final diPan = List<String>.generate(12, (i) => zhiChars[i]);

  // 日干寄宫
  final ganGongIdx = _ganJiGong[dayGan] ?? 0;

  // 四课
  final siKe = <Ke>[];
  // 一课（干课）：下神 = 干寄宫支，上神 = 天盘加临干寄宫位
  final ke1Bottom = zhiChars[ganGongIdx];
  final ke1Top = tianPan[ganGongIdx];
  siKe.add(Ke(top: ke1Top, bottom: ke1Bottom));

  // 二课：下神 = 一课上神，上神 = 天盘加临该位
  final ke2BottomIdx = zhiChars.indexOf(ke1Top);
  final ke2Top = tianPan[ke2BottomIdx];
  siKe.add(Ke(top: ke2Top, bottom: ke1Top));

  // 三课（支课）：下神 = 日支，上神 = 天盘加临日支位
  final ke3Top = tianPan[dayZhiIdx];
  siKe.add(Ke(top: ke3Top, bottom: dayZhi));

  // 四课：下神 = 三课上神，上神 = 天盘加临
  final ke4BottomIdx = zhiChars.indexOf(ke3Top);
  final ke4Top = tianPan[ke4BottomIdx];
  siKe.add(Ke(top: ke4Top, bottom: ke3Top));

  // 三传
  final (chuanShen, zongMen) = _calcSanChuan(siKe, dayGan, tianPan);

  // 贵人定位：卯辰巳午未申为昼，酉戌亥子丑寅为夜
  final isDayTime = timeZhiIdx >= 3 && timeZhiIdx <= 8;
  final guiRenType = isDayTime ? 'day' : 'night';
  final guiRenIdx = _guiRen[dayGan]?[guiRenType] ?? 1;
  final guiRenZhi = zhiChars[guiRenIdx];

  // 十二天将顺逆布：昼贵顺布，夜贵逆布
  final isShun = isDayTime;
  final tianJiangOnTian = List<String>.filled(12, '');
  for (var i = 0; i < 12; i++) {
    final pos = isShun
        ? (guiRenIdx + i) % 12
        : ((guiRenIdx - i) % 12 + 12) % 12;
    tianJiangOnTian[pos] = tianJiangOrder[i];
  }

  // 三传天将（取初/中/末传神所在天盘位的天将）
  final sanChuan = <Chuan>[];
  for (final shen in chuanShen) {
    final shenIdx = zhiChars.indexOf(shen);
    sanChuan.add(Chuan(shen: shen, tianJiang: tianJiangOnTian[shenIdx]));
  }

  final lunarDisplay =
      '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}日 $timeGanZhi时';

  return DaliurenResult(
    dayGanZhi: dayGanZhi,
    timeGanZhi: timeGanZhi,
    lunarDisplay: lunarDisplay,
    yueJiang: yueJiang,
    siKe: siKe,
    sanChuan: sanChuan,
    tianPan: tianPan,
    diPan: diPan,
    tianJiangOnTian: tianJiangOnTian,
    zongMen: zongMen,
    guiRenType: guiRenType,
    guiRenZhi: guiRenZhi,
  );
}

/// 24 山字符（顺时针：壬子癸丑艮寅甲卯乙辰巽巳丙午丁未坤申庚酉辛戌乾亥）。
const shan24 = [
  '壬', '子', '癸', '丑', '艮', '寅', '甲', '卯', '乙', '辰', '巽', '巳',
  '丙', '午', '丁', '未', '坤', '申', '庚', '酉', '辛', '戌', '乾', '亥',
];

/// 把磁力计读数转为方位角（0=北，顺时针 0-360）。
///
/// [x]/[y]/[z] 为磁力计三轴原始值（μT）。
/// 简化版未做倾角补偿，建议用户保持设备水平。
double azimuthFromMagnetometer(double x, double y, double z) {
  var azimuth = math.atan2(y, x) * 180 / math.pi;
  if (azimuth < 0) azimuth += 360;
  return azimuth;
}
