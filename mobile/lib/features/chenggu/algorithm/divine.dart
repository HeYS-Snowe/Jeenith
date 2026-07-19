// Copyright (c) 2026 Qore
import 'package:lunar/lunar.dart';

import '../data/chenggu_data.dart';

const _ganChars = '甲乙丙丁戊己庚辛壬癸';
const _zhiChars = '子丑寅卯辰巳午未申酉戌亥';

/// 60 甲子序号（0=甲子 … 59=癸亥）：给定干支索引求序号。
int _ganzhiSeq(int ganIdx, int zhiIdx) {
  for (var i = 0; i < 60; i++) {
    if (i % 10 == ganIdx && i % 12 == zhiIdx) return i;
  }
  return 0;
}

/// 称骨算命结果。
class ChengguResult {
  final String lunarDisplay;
  final String bazi;
  final int yearQian;
  final int monthQian;
  final int dayQian;
  final int hourQian;
  final int totalQian;     // 总骨重（钱）
  final ChengguFate fate;  // 对应命格

  const ChengguResult({
    required this.lunarDisplay,
    required this.bazi,
    required this.yearQian,
    required this.monthQian,
    required this.dayQian,
    required this.hourQian,
    required this.totalQian,
    required this.fate,
  });

  /// 中文重量 label（如「三两九钱」）。
  String get weightLabel => chengguWeightLabel(totalQian);
}

/// 称骨算命：公历生辰 → 年月日时四骨重 → 总骨重 → 命格。
///
/// 年柱按 60 甲子查重量；农历月（闰月取绝对值，依「上半月算本月」传统）；
/// 农历日；时辰按 12 时支。四者相加得总骨重，对照称骨歌定命格。
ChengguResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  // 年柱 → 60 甲子序号 → 年重量
  final yearGz = ec.getYear();
  final ganIdx = _ganChars.indexOf(yearGz[0]);
  final zhiIdx = _zhiChars.indexOf(yearGz[1]);
  final seq = _ganzhiSeq(ganIdx, zhiIdx);
  final yearQian = chengguYearWeight[seq];

  // 农历月（闰月取绝对值，称骨闰月上半月算本月）
  final czMonth = lunar.getMonth().abs();
  final monthQian = chengguMonthWeight[czMonth - 1];

  // 农历日
  final czDay = lunar.getDay();
  final dayQian = chengguDayWeight[czDay - 1];

  // 时支
  final hourZhi = lunar.getTimeZhiIndex();
  final hourQian = chengguHourWeight[hourZhi];

  final total = yearQian + monthQian + dayQian + hourQian;

  // 查命格（兜底取最接近的，理论上 21~72 全覆盖）
  ChengguFate fate = chengguFates.last;
  for (final f in chengguFates) {
    if (f.qian == total) {
      fate = f;
      break;
    }
  }
  // 超出范围兜底（极端组合）：clamp 到 21~72
  if (fate.qian != total) {
    final clamped = total.clamp(21, 72);
    for (final f in chengguFates) {
      if (f.qian == clamped) {
        fate = f;
        break;
      }
    }
  }

  return ChengguResult(
    lunarDisplay: '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    bazi: '${ec.getYear()} ${ec.getMonth()} ${ec.getDay()} ${ec.getTime()}',
    yearQian: yearQian,
    monthQian: monthQian,
    dayQian: dayQian,
    hourQian: hourQian,
    totalQian: total,
    fate: fate,
  );
}
