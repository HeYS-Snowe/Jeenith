// Copyright (c) 2026 Qore
import 'package:lunar/lunar.dart';

/// 农历服务：公历 → 农历转换，供传统卜算（小六壬 / 紫微 / 奇门）共用取数。
///
/// 底层为"寿星天文历"（6tail/lunar，MIT），覆盖公历 1900–2100，
/// 同时支持干支、节气、星宿、八字等，后续命理功能可直接复用本服务。
class LunarService {
  LunarService._();

  /// 当前时刻对应的农历月、日。
  /// - [month] 农历月数字：正月=1 … 腊月=12（闰月按月份序号取数）。
  /// - [day] 农历日数字：初一=1 … 三十=30。
  /// - [display] 中文农历日期，如"五月十八"/"闰六月廿一"，用于 UI 提示。
  static ({int month, int day, String display}) nowLunarMonthDay() {
    final lunar = Lunar.fromDate(DateTime.now());
    return (
      month: lunar.getMonth(),
      day: lunar.getDay(),
      display: '${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    );
  }
}
