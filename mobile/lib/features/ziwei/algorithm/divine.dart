// Copyright (c) 2026 Qore. All rights reserved.
import 'package:lunar/lunar.dart';

const _dizhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
const _tiangan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

/// 十二宫名（从命宫逆时针）
const palaceNames = ['命宫', '兄弟', '夫妻', '子女', '财帛', '疾厄', '迁移', '交友', '官禄', '田宅', '福德', '父母'];

/// 五虎遁：年干 → 正月（寅）天干 index
const _wuhuTun = {'甲': 2, '己': 2, '乙': 4, '庚': 4, '丙': 6, '辛': 6, '丁': 8, '壬': 8, '戊': 0, '癸': 0};

/// 60 甲子纳音 → 五行
const _nayin = {
  '甲子': '金', '乙丑': '金', '丙寅': '火', '丁卯': '火', '戊辰': '木', '己巳': '木',
  '庚午': '土', '辛未': '土', '壬申': '金', '癸酉': '金', '甲戌': '火', '乙亥': '火',
  '丙子': '水', '丁丑': '水', '戊寅': '土', '己卯': '土', '庚辰': '金', '辛巳': '金',
  '壬午': '木', '癸未': '木', '甲申': '水', '乙酉': '水', '丙戌': '土', '丁亥': '土',
  '戊子': '火', '己丑': '火', '庚寅': '木', '辛卯': '木', '壬辰': '水', '癸巳': '水',
  '甲午': '金', '乙未': '金', '丙申': '火', '丁酉': '火', '戊戌': '木', '己亥': '木',
  '庚子': '土', '辛丑': '土', '壬寅': '金', '癸卯': '金', '甲辰': '火', '乙巳': '火',
  '丙午': '水', '丁未': '水', '戊申': '土', '己酉': '土', '庚戌': '金', '辛亥': '金',
  '壬子': '木', '癸丑': '木', '甲寅': '水', '乙卯': '水', '丙辰': '土', '丁巳': '土',
  '戊午': '火', '己未': '火', '庚申': '木', '辛酉': '木', '壬戌': '水', '癸亥': '水',
};

const _juName = {'金': '金四局', '火': '火六局', '木': '木三局', '土': '土五局', '水': '水二局'};

/// 紫微斗数排盘结果（v1：命身宫 + 12宫 + 五行局 + 八字；星曜排盘留 v2）。
class ZiweiResult {
  final String lunarDisplay;    // 农历
  final String bazi;            // 八字
  final int mingGong;           // 命宫地支位 0-11
  final int shenGong;           // 身宫地支位
  final String mingGanZhi;      // 命宫干支
  final String wuxingJu;        // 五行局
  /// 按地支 0-11 排列的宫名索引（0=命宫,1=兄弟...），-1 表示无（不应出现）
  final List<int> gongAtZhi;

  const ZiweiResult({
    required this.lunarDisplay,
    required this.bazi,
    required this.mingGong,
    required this.shenGong,
    required this.mingGanZhi,
    required this.wuxingJu,
    required this.gongAtZhi,
  });
}

/// 紫微排盘：公历生辰 → 命身宫 + 12宫 + 五行局。
ZiweiResult divine(int year, int month, int day, int hour) {
  final solar = Solar.fromYmdHms(year, month, day, hour, 0, 0);
  final lunar = solar.getLunar();
  final ec = lunar.getEightChar();

  final czMonth = lunar.getMonth().abs();
  final czHour = lunar.getTimeZhiIndex();

  // 命宫：从寅（正月）起顺数到生月，再从生月宫起子时逆数到生时
  final monthGong = (czMonth + 1) % 12; // 正月=寅=2
  final mingGong = ((monthGong - czHour) % 12 + 12) % 12;
  // 身宫：从生月宫起子时顺数到生时
  final shenGong = (monthGong + czHour) % 12;

  // 命宫天干：五虎遁从年干起正月，顺数到命宫地支
  final yearGan = ec.getYear()[0];
  final startGanIdx = _wuhuTun[yearGan]!;
  final mingGanIdx = (startGanIdx + (mingGong - 2 + 12) % 12) % 10;
  final mingGanZhi = '${_tiangan[mingGanIdx]}${_dizhi[mingGong]}';
  final wuxing = _nayin[mingGanZhi] ?? '金';
  final ju = _juName[wuxing]!;

  // 12宫按地支排列（命宫逆时针：命兄夫子财疾迁交官田福父）
  final gongAtZhi = List<int>.filled(12, -1);
  for (var i = 0; i < 12; i++) {
    final zhi = ((mingGong - i) % 12 + 12) % 12;
    gongAtZhi[zhi] = i;
  }

  return ZiweiResult(
    lunarDisplay: '农历${lunar.getMonthInChinese()}月${lunar.getDayInChinese()}',
    bazi: '${ec.getYear()} ${ec.getMonth()} ${ec.getDay()} ${ec.getTime()}',
    mingGong: mingGong,
    shenGong: shenGong,
    mingGanZhi: mingGanZhi,
    wuxingJu: ju,
    gongAtZhi: gongAtZhi,
  );
}
