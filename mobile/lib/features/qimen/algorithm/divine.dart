// Copyright (c) 2026 Qore. All rights reserved.
import 'package:lunar/lunar.dart';

/// 阳遁节气 → 上元局数（每节气上/中/下三元，v1 取上元简化）
const _yangJieqi = {
  '冬至': 1, '小寒': 2, '大寒': 3, '立春': 8, '雨水': 9, '惊蛰': 1,
  '春分': 3, '清明': 4, '谷雨': 5, '立夏': 4, '小满': 5, '芒种': 6,
};

/// 阴遁节气 → 上元局数
const _yinJieqi = {
  '夏至': 9, '小暑': 8, '大暑': 7, '立秋': 2, '处暑': 1, '白露': 9,
  '秋分': 7, '寒露': 6, '霜降': 5, '立冬': 6, '小雪': 5, '大雪': 4,
};

/// 洛书九宫：1坎 2坤 3震 4巽 5中 6乾 7兑 8艮 9离
const palaceNames = ['坎', '坤', '震', '巽', '中', '乾', '兑', '艮', '离'];

/// 九星地盘本位（按宫 1-9 顺序，索引 0=坎1宫）。
const starByPalace = ['天蓬', '天芮', '天冲', '天辅', '天禽', '天心', '天柱', '天任', '天英'];

/// 八门地盘本位（按宫 1-9 顺序，中宫 5 空）。
const menByPalace = ['休门', '死门', '伤门', '杜门', '', '开门', '惊门', '生门', '景门'];

/// 八神顺序（直符起，阳遁顺布、阴遁逆布）。
const shenOrder = ['直符', '螣蛇', '太阴', '六合', '白虎', '玄武', '九地', '九天'];

/// 六仪顺序。
const _liuYi = ['戊', '己', '庚', '辛', '壬', '癸'];

/// 三奇顺序（阳遁逆布、阴遁顺布）。
const _sanQi = ['丁', '丙', '乙'];

/// 天干字符。
const ganChars = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

/// 地支字符。
const zhiChars = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

/// 60 甲子索引（0-59）：给定干支索引返回其在 60 甲子中的序号。
int _ganzhiIndex(int ganIdx, int zhiIdx) {
  for (var i = 0; i < 60; i++) {
    if (i % 10 == ganIdx && i % 12 == zhiIdx) return i;
  }
  return 0;
}

/// 顺飞取下一宫（1-9：1→2→…→9→1）。
int _nextPalace(int palace) => (palace % 9) + 1;

/// 逆飞取下一宫（1-9：1→9→8→…→2→1）。
int _prevPalace(int palace) => ((palace - 2 + 9) % 9) + 1;

/// 沿飞行路径（阳遁顺、阴遁逆）从 from 走到 to 的步数。
int _palaceDistance(int from, int to, bool isYang) {
  if (from == to) return 0;
  var palace = from;
  for (var i = 1; i <= 8; i++) {
    palace = isYang ? _nextPalace(palace) : _prevPalace(palace);
    if (palace == to) return i;
  }
  return 0;
}

/// 奇门遁甲四盘排盘结果（v2：天地人神四盘 + 值符值使）。
class QimenPlate {
  /// '阳遁' / '阴遁'
  final String dunType;
  /// 局数 1-9
  final int ju;
  /// 当前节气
  final String jieqi;
  /// 八字
  final String bazi;
  /// 农历显示
  final String lunarDisplay;

  /// 地盘九干（按宫 1-9 顺序，索引 0=坎1宫）
  final List<String> diPanGan;
  /// 天盘九星（按宫 1-9 顺序）
  final List<String> tianPanXing;
  /// 人盘八门（按宫 1-9 顺序，中宫空字符串）
  final List<String> renPanMen;
  /// 神盘八神（按宫 1-9 顺序，中宫空字符串）
  final List<String> shenPanShen;

  /// 值符所在宫 1-9（地盘本位）
  final int zhiFuGong;
  /// 值使所在宫 1-9（转动后）
  final int zhiShiGong;
  /// 值符星名
  final String zhiFu;
  /// 值使门名
  final String zhiShi;

  const QimenPlate({
    required this.dunType,
    required this.ju,
    required this.jieqi,
    required this.bazi,
    required this.lunarDisplay,
    required this.diPanGan,
    required this.tianPanXing,
    required this.renPanMen,
    required this.shenPanShen,
    required this.zhiFuGong,
    required this.zhiShiGong,
    required this.zhiFu,
    required this.zhiShi,
  });
}

/// 奇门排盘结果（v2：v1 基础信息 + QimenPlate 四盘）。
class QimenResult {
  final String lunarDisplay;
  final String bazi;
  final String dunType;
  final int ju;
  final String jieqi;
  final QimenPlate plate;

  const QimenResult({
    required this.lunarDisplay,
    required this.bazi,
    required this.dunType,
    required this.ju,
    required this.jieqi,
    required this.plate,
  });
}

/// 奇门排盘：时辰 → 阴阳遁 + 局数 + 四盘（天地人神 + 值符值使）。
QimenResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  // 时辰干支
  final timeGanZhi = ec.getTime();
  final timeGanChar = timeGanZhi[0];
  final timeZhiChar = timeGanZhi[1];
  final timeGanIdx = ganChars.indexOf(timeGanChar);
  final timeZhiIdx = zhiChars.indexOf(timeZhiChar);
  final timeGzIdx = _ganzhiIndex(timeGanIdx, timeZhiIdx);
  final xunIdx = timeGzIdx ~/ 10; // 0-5，旬序号
  final posInXun = timeGzIdx % 10; // 0-9，时辰在旬中的序号

  // 节气定阴阳遁 + 局数
  final jqObj = lunar.getCurrentJieQi();
  final jq = jqObj?.getName() ?? '';
  bool isYang;
  int ju;
  if (_yangJieqi.containsKey(jq)) {
    isYang = true;
    ju = _yangJieqi[jq]!;
  } else if (_yinJieqi.containsKey(jq)) {
    isYang = false;
    ju = _yinJieqi[jq]!;
  } else {
    final m = month;
    isYang = m >= 12 || m <= 6;
    ju = isYang ? 1 : 9;
  }

  final bazi = '${ec.getYear()} ${ec.getMonth()} ${ec.getDay()} ${ec.getTime()}';
  final lunarDisplay = '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}';

  final plate = _buildPlate(
    isYang: isYang,
    ju: ju,
    jieqi: jq,
    bazi: bazi,
    lunarDisplay: lunarDisplay,
    xunIdx: xunIdx,
    posInXun: posInXun,
    timeGanIdx: timeGanIdx,
  );

  return QimenResult(
    lunarDisplay: lunarDisplay,
    bazi: bazi,
    dunType: isYang ? '阳遁' : '阴遁',
    ju: ju,
    jieqi: jq,
    plate: plate,
  );
}

/// 构建四盘。
QimenPlate _buildPlate({
  required bool isYang,
  required int ju,
  required String jieqi,
  required String bazi,
  required String lunarDisplay,
  required int xunIdx,
  required int posInXun,
  required int timeGanIdx,
}) {
  // 1. 地盘九干：戊起局数宫
  final diPanGan = List<String>.filled(9, '');
  // 六仪：阳遁顺布、阴遁逆布
  for (var i = 0; i < 6; i++) {
    var palace = ju;
    for (var step = 0; step < i; step++) {
      palace = isYang ? _nextPalace(palace) : _prevPalace(palace);
    }
    diPanGan[palace - 1] = _liuYi[i];
  }
  // 三奇：阳遁逆布、阴遁顺布（从戊起 6 步后开始）
  for (var i = 0; i < 3; i++) {
    var palace = ju;
    for (var step = 0; step < 6 + i; step++) {
      palace = isYang ? _prevPalace(palace) : _nextPalace(palace);
    }
    diPanGan[palace - 1] = _sanQi[i];
  }

  // 2. 旬首遁干定位 → 值符宫（甲遁在六仪下，旬首遁干 = _liuYi[xunIdx]）
  final xunShouGan = _liuYi[xunIdx];
  var zhiFuGong = diPanGan.indexOf(xunShouGan) + 1;
  if (zhiFuGong == 0) zhiFuGong = 5; // 兜底：中宫

  // 值符星 / 值使门（地盘本位）
  final zhiFu = starByPalace[zhiFuGong - 1];
  final zhiShi = menByPalace[zhiFuGong - 1];

  // 3. 时干所在宫（用于天盘转动）
  final timeGanChar = ganChars[timeGanIdx];
  int tianGanPalace;
  if (timeGanChar == '甲') {
    // 甲遁在六仪下，所在宫即值符宫
    tianGanPalace = zhiFuGong;
  } else {
    tianGanPalace = diPanGan.indexOf(timeGanChar) + 1;
  }

  // 4. 天盘九星：值符星移到时干所在宫，其他星同步偏移
  final tianShift = _palaceDistance(zhiFuGong, tianGanPalace, isYang);
  final tianPanXing = List<String>.filled(9, '');
  for (var srcPalace = 1; srcPalace <= 9; srcPalace++) {
    var newPalace = srcPalace;
    for (var i = 0; i < tianShift; i++) {
      newPalace = isYang ? _nextPalace(newPalace) : _prevPalace(newPalace);
    }
    tianPanXing[newPalace - 1] = starByPalace[srcPalace - 1];
  }

  // 5. 人盘八门：值使门从本位转动 posInXun 步
  final renPanMen = List<String>.filled(9, '');
  var zhiShiCurrentPalace = zhiFuGong;
  for (var i = 0; i < posInXun; i++) {
    zhiShiCurrentPalace =
        isYang ? _nextPalace(zhiShiCurrentPalace) : _prevPalace(zhiShiCurrentPalace);
  }
  for (var srcPalace = 1; srcPalace <= 9; srcPalace++) {
    // 中宫无门
    if (menByPalace[srcPalace - 1].isEmpty) continue;
    var newPalace = srcPalace;
    for (var i = 0; i < posInXun; i++) {
      newPalace = isYang ? _nextPalace(newPalace) : _prevPalace(newPalace);
    }
    if (newPalace == 5) {
      // 中宫寄二宫
      renPanMen[1] = menByPalace[srcPalace - 1];
    } else {
      renPanMen[newPalace - 1] = menByPalace[srcPalace - 1];
    }
  }

  // 6. 神盘八神：直符起于值符天盘位置，阳遁顺布、阴遁逆布
  final shenPanShen = List<String>.filled(9, '');
  // 值符星现在所在宫 = 时干所在宫（天盘转动后）
  final shenStartPalace = tianGanPalace == 0 ? 1 : tianGanPalace;
  for (var i = 0; i < 8; i++) {
    var palace = shenStartPalace;
    for (var step = 0; step < i; step++) {
      palace = isYang ? _nextPalace(palace) : _prevPalace(palace);
    }
    if (palace == 5) {
      // 中宫寄二宫
      shenPanShen[1] = shenOrder[i];
    } else {
      shenPanShen[palace - 1] = shenOrder[i];
    }
  }

  return QimenPlate(
    dunType: isYang ? '阳遁' : '阴遁',
    ju: ju,
    jieqi: jieqi,
    bazi: bazi,
    lunarDisplay: lunarDisplay,
    diPanGan: diPanGan,
    tianPanXing: tianPanXing,
    renPanMen: renPanMen,
    shenPanShen: shenPanShen,
    zhiFuGong: zhiFuGong,
    zhiShiGong: zhiShiCurrentPalace == 5 ? 2 : zhiShiCurrentPalace,
    zhiFu: zhiFu,
    zhiShi: zhiShi,
  );
}
