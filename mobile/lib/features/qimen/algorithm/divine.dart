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

/// 奇门遁甲排盘结果（v1：阴阳遁 + 局数 + 节气 + 八字；天地人神盘留 v2）。
class QimenResult {
  final String lunarDisplay;
  final String bazi;
  final String dunType;  // '阳遁' / '阴遁'
  final int ju;          // 局数 1-9
  final String jieqi;    // 当前节气

  const QimenResult({
    required this.lunarDisplay,
    required this.bazi,
    required this.dunType,
    required this.ju,
    required this.jieqi,
  });
}

/// 奇门排盘：时辰 → 阴阳遁 + 局数。
QimenResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  // 当前节气（lunar 返回最近节气）
  final jqObj = lunar.getCurrentJieQi();
  final jq = jqObj?.getName() ?? '';

  String dunType;
  int ju;
  if (_yangJieqi.containsKey(jq)) {
    dunType = '阳遁';
    ju = _yangJieqi[jq]!;
  } else if (_yinJieqi.containsKey(jq)) {
    dunType = '阴遁';
    ju = _yinJieqi[jq]!;
  } else {
    // 节气间默认（简化：按月份粗判）
    final m = month;
    final isYang = m >= 12 || m <= 6; // 冬至(12)~夏至(6)阳遁
    dunType = isYang ? '阳遁' : '阴遁';
    ju = isYang ? 1 : 9;
  }

  return QimenResult(
    lunarDisplay: '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    bazi: '${ec.getYear()} ${ec.getMonth()} ${ec.getDay()} ${ec.getTime()}',
    dunType: dunType,
    ju: ju,
    jieqi: jq,
  );
}
