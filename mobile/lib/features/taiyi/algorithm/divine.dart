// Copyright (c) 2026 Qore
import 'package:lunar/lunar.dart';

import '../data/taiyi_data.dart';

const _zhiChars = '子丑寅卯辰巳午未申酉戌亥';

/// 太乙神数排盘结果（年家太乙：积年→入局→太乙落宫→文昌/计神/始击→主客算→主客将）。
class TaiyiResult {
  final String lunarDisplay;
  final String bazi;
  final int jinian;       // 太乙积年数
  final bool isYang;      // 阳遁/阴遁
  final int ju;           // 局数 1-72
  final int taiyiGong;    // 太乙所在宫数（1-9，非5）
  final int taiyiJc;      // 太乙所在间辰索引（正位）
  final int wenchangJc;   // 文昌（天目）间辰索引
  final int jishenJc;     // 计神间辰索引
  final int shijiJc;      // 始击（地目）间辰索引
  final int mainSuan;     // 主算
  final int guestSuan;    // 客算
  final int mainDajiang;  // 主大将宫数
  final int mainCanjiang; // 主参将宫数
  final int guestDajiang; // 客大将宫数
  final int guestCanjiang;// 客参将宫数

  const TaiyiResult({
    required this.lunarDisplay,
    required this.bazi,
    required this.jinian,
    required this.isYang,
    required this.ju,
    required this.taiyiGong,
    required this.taiyiJc,
    required this.wenchangJc,
    required this.jishenJc,
    required this.shijiJc,
    required this.mainSuan,
    required this.guestSuan,
    required this.mainDajiang,
    required this.mainCanjiang,
    required this.guestDajiang,
    required this.guestCanjiang,
  });

  /// 宫数 → 将帅所在间辰索引（正位；中5宫返回 -1 表示中宫）。
  int gongToJc(int gong) => gong == 5 ? -1 : (taiyiZhengwei[gong] ?? 0);
}

/// 是否阳遁：冬至（12/22）后至夏至（6/21）前为阳遁，其余阴遁。
bool _isYangDun(int month, int day) {
  if (month >= 1 && month <= 5) return true;
  if (month == 6 && day <= 21) return true;
  if (month == 12 && day >= 22) return true;
  return false;
}

/// 算数（主算/客算通用）：从 fromJc 顺时针途经宫数（去重）累加，到太乙宫前止；
/// fromJc 落间位（非正位）则 +1。
int _suan(int fromJc, int taiyiGong) {
  final gongs = <int>[];
  var idx = fromJc;
  for (var step = 0; step < 16; step++) {
    final g = taiyiGongOfJianchen[idx];
    if (step > 0 && g == taiyiGong) break;
    if (gongs.isEmpty || gongs.last != g) gongs.add(g);
    idx = (idx + 1) % 16;
  }
  var sum = gongs.fold(0, (a, b) => a + b);
  // fromJc 若为间位（非该宫正位），算数 +1
  if (taiyiZhengwei[taiyiGongOfJianchen[fromJc]] != fromJc) sum += 1;
  return sum;
}

/// 大将宫数：算数个位；个位 0 则除以 9 取余（仍 0 取 9）。
int _dajiangGong(int suan) {
  final g = suan % 10;
  if (g != 0) return g;
  final g9 = suan % 9;
  return g9 == 0 ? 9 : g9;
}

/// 太乙排盘：公历年月日时 → 年家太乙盘。
///
/// 阴阳遁按节气（夏至前阳遁/夏至后阴遁）；积年 = 10153917 + 公元年；
/// 局数 = 积年 %360 %72；太乙三年一宫、24 年一周、不入中五。
TaiyiResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();
  final yearGz = ec.getYear();
  final yearZhiIdx = _zhiChars.indexOf(yearGz[1]);

  final jinian = taiyiJinianBase + year;
  final isYang = _isYangDun(month, day);

  // 局数：积年 %360 余数再 %72，0 则 72
  final mod360 = jinian % 360;
  final juRaw = mod360 % 72;
  final ju = juRaw == 0 ? 72 : juRaw;

  // 太乙落宫：局数 %24 → R24(1-24)，每 3 年一宫
  final r24 = ((ju - 1) % 24) + 1;
  final orderIdx = (r24 - 1) ~/ 3; // 0-7
  final gongSeq = isYang ? taiyiGongOrder : [9, 8, 7, 6, 4, 3, 2, 1];
  final taiyiGong = gongSeq[orderIdx];
  final taiyiJc = taiyiZhengwei[taiyiGong]!;

  // 文昌（天目）：积年 %18，阳遁从武德起 / 阴遁从吕申起（扩展序列）
  final m = jinian % 18;
  final slot = m == 0 ? 18 : m;
  final wenchangSeq = isYang ? taiyiWenchangSeqYang : taiyiWenchangSeqYin;
  final wenchangJc = wenchangSeq[slot - 1];

  // 合神 = 年支六合地支 → 间辰；计神 = 合神顺时针下一间辰
  final heZhi = taiyiLiuhe[yearZhiIdx]!;
  final heJc = taiyiZhiToJianchen[heZhi]!;
  final jishenJc = (heJc + 1) % 16;

  // 始击（地目）：计神到艮（和德）顺时针距离 d，文昌顺时针走 d 步
  final d = (4 - jishenJc + 16) % 16;
  final shijiJc = (wenchangJc + d) % 16;

  // 主算 / 客算
  final mainSuan = _suan(wenchangJc, taiyiGong);
  final guestSuan = _suan(shijiJc, taiyiGong);

  // 主客大将 / 参将
  final mainDajiang = _dajiangGong(mainSuan);
  final mainCanjiang = (mainDajiang * 3) % 10;
  final guestDajiang = _dajiangGong(guestSuan);
  final guestCanjiang = (guestDajiang * 3) % 10;

  return TaiyiResult(
    lunarDisplay: '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    bazi: '${ec.getYear()} ${ec.getMonth()} ${ec.getDay()} ${ec.getTime()}',
    jinian: jinian,
    isYang: isYang,
    ju: ju,
    taiyiGong: taiyiGong,
    taiyiJc: taiyiJc,
    wenchangJc: wenchangJc,
    jishenJc: jishenJc,
    shijiJc: shijiJc,
    mainSuan: mainSuan,
    guestSuan: guestSuan,
    mainDajiang: mainDajiang,
    mainCanjiang: mainCanjiang,
    guestDajiang: guestDajiang,
    guestCanjiang: guestCanjiang,
  );
}
