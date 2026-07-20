// Copyright (c) 2026 Qore
import 'dart:math';

import 'package:lunar/lunar.dart';

import '../../../data/yijing/hexagrams.dart';
import '../../../data/yijing/trigrams.dart';
import '../data/najia_data.dart';
import '../data/bagong_data.dart';

/// 原始一爻（摇卦所得）：阳/阴 + 是否动爻。
typedef RawLine = ({bool yang, bool changing});

/// 一爻（含纳甲、六亲、六神）。
class Yao {
  final bool yang; // 阳爻
  final bool changing; // 动爻（老阴老阳）
  final String gan; // 纳甲天干
  final String zhi; // 纳甲地支
  final String liuqin; // 六亲
  final String shenshou; // 六神
  const Yao({
    required this.yang,
    required this.changing,
    required this.gan,
    required this.zhi,
    required this.liuqin,
    required this.shenshou,
  });
}

/// 六爻纳甲排盘结果。
class LiuyaoResult {
  final String benName; // 本卦名
  final String? bianName; // 变卦名（无动爻则 null）
  final String upperName; // 本卦上卦
  final String lowerName; // 本卦下卦
  final BagongLoc bagong; // 八宫归属
  final String gongWuxing; // 卦宫五行
  final String dayGan; // 日干
  final String dayZhi; // 日支
  final String monthZhi; // 月建地支
  final List<Yao> lines; // 本卦六爻（索引 0=初爻）
  final List<Yao>? bianLines; // 变卦六爻（无动爻则 null）
  final String yongShen; // 用神（六亲名）
  final int? yongPos; // 用神所在爻位（0-5），不上卦为 null
  final String judgment; // 总断
  final List<String> points; // 断卦要点
  final List<String> dayKong; // 日辰旬空地支（两个）
  final bool yongKong; // 用神是否落空亡
  final bool isLiuChong; // 六冲卦
  final bool isLiuHe; // 六合卦

  const LiuyaoResult({
    required this.benName,
    required this.bianName,
    required this.upperName,
    required this.lowerName,
    required this.bagong,
    required this.gongWuxing,
    required this.dayGan,
    required this.dayZhi,
    required this.monthZhi,
    required this.lines,
    required this.bianLines,
    required this.yongShen,
    required this.yongPos,
    required this.judgment,
    required this.points,
    required this.dayKong,
    required this.yongKong,
    required this.isLiuChong,
    required this.isLiuHe,
  });
}

const _posNames = ['初', '二', '三', '四', '五', '上'];

/// 摇一爻：三铜钱之和。6=老阴(变) 7=少阳 8=少阴 9=老阳(变)。
RawLine _tossLine(Random rng) {
  final s = (2 + rng.nextInt(2)) + (2 + rng.nextInt(2)) + (2 + rng.nextInt(2));
  return switch (s) {
    6 => (yang: false, changing: true),
    7 => (yang: true, changing: false),
    8 => (yang: false, changing: false),
    _ => (yang: true, changing: true), // 9
  };
}

/// 摇六爻（金钱卦），返回原始六爻快照。
/// UI 持有快照以便写入历史、支持从历史精确复现同一卦象。
List<RawLine> rollLines([Random? rng]) {
  rng ??= Random.secure();
  return [for (var i = 0; i < 6; i++) _tossLine(rng)];
}

/// 由卦宫五行 + 爻地支 → 六亲。
String _liuqin(String gongWx, String zhi) {
  final zw = zhiWuxing[zhi]!;
  if (zw == gongWx) return '兄弟'; // 同我
  if (shengMap[zw] == gongWx) return '父母'; // 爻生宫
  if (shengMap[gongWx] == zw) return '子孙'; // 宫生爻
  if (keMap[zw] == gongWx) return '官鬼'; // 爻克宫
  if (keMap[gongWx] == zw) return '妻财'; // 宫克爻
  return '兄弟';
}

/// 谁生 [wx]（逆查 shengMap）。
String _shengWo(String wx) {
  for (final e in shengMap.entries) {
    if (e.value == wx) return e.key;
  }
  return wx;
}

/// 谁克 [wx]（逆查 keMap）。
String _keWo(String wx) {
  for (final e in keMap.entries) {
    if (e.value == wx) return e.key;
  }
  return wx;
}

/// 五行 → 六亲（在卦宫 [gongWx] 体系下）。
String _wxToLiuqin(String gongWx, String wx) {
  if (wx == gongWx) return '兄弟';
  if (shengMap[wx] == gongWx) return '父母';
  if (shengMap[gongWx] == wx) return '子孙';
  if (keMap[wx] == gongWx) return '官鬼';
  if (keMap[gongWx] == wx) return '妻财';
  return '兄弟';
}

/// 用神爻地支在月建/日辰下的旺衰。
/// 返回 '旺' / '平' / '衰'。
String _wangShuai(String zhi, String monthZhi, String dayZhi) {
  final zw = zhiWuxing[zhi]!;
  final mw = zhiWuxing[monthZhi]!;
  final dw = zhiWuxing[dayZhi]!;
  var s = 0;
  if (mw == zw || shengMap[mw] == zw) s++; // 月比或月生
  if (dw == zw || shengMap[dw] == zw) s++; // 日比或日生
  if (keMap[mw] == zw) s--; // 月克
  if (keMap[dw] == zw) s--; // 日克
  if (s >= 1) return '旺';
  if (s <= -1) return '衰';
  return '平';
}

/// 在 [lines] 中定位用神爻位。
/// 优先：持世 > 发动 > 首个。
int? _findYong(List<Yao> lines, String yongShen, int shi) {
  final matches = [
    for (var i = 0; i < 6; i++) if (lines[i].liuqin == yongShen) i,
  ];
  if (matches.isEmpty) return null;
  if (matches.contains(shi)) return shi;
  for (final i in matches) {
    if (lines[i].changing) return i;
  }
  return matches.first;
}

/// 日柱干支所在旬的旬头（甲子/甲戌/甲申/甲午/甲辰/甲寅）。
String _xunTou(String dayGz) {
  final ganIdx = ganChars.indexOf(dayGz[0]);
  final zhiIdx = zhiChars.indexOf(dayGz[1]);
  var seq = 0;
  for (var i = 0; i < 60; i++) {
    if (i % 10 == ganIdx && i % 12 == zhiIdx) {
      seq = i;
      break;
    }
  }
  final xt = (seq ~/ 10) * 10;
  return '${ganChars[xt % 10]}${zhiChars[xt % 12]}';
}

/// 日辰旬空地支（两个）。
List<String> _dayKongOf(String dayGz) => xunKong[_xunTou(dayGz)]!;

/// 六冲卦：初冲四、二冲五、三冲上（本卦六爻地支两两冲）。
bool _isLiuChong(List<Yao> lines) =>
    chongMap[lines[0].zhi] == lines[3].zhi &&
    chongMap[lines[1].zhi] == lines[4].zhi &&
    chongMap[lines[2].zhi] == lines[5].zhi;

/// 六合卦：初合四、二合五、三合上。
bool _isLiuHe(List<Yao> lines) =>
    liuHeMap[lines[0].zhi] == lines[3].zhi &&
    liuHeMap[lines[1].zhi] == lines[4].zhi &&
    liuHeMap[lines[2].zhi] == lines[5].zhi;

/// 飞伏：用神不上卦时，从本宫八纯卦寻伏神。
/// 伏神 = 本宫八纯卦中用神六亲所在爻；飞神 = 本卦同位爻（压伏神）。
({String fuZhi, int fuPos, String feiZhi, String feiLiuqin})? _findFuFei(
    List<Yao> lines, String yongShen, String gong, String gwx) {
  final benGong = baguaNajia[gong]!; // 本宫八纯卦 6 爻 (gan, zhi)
  for (var i = 0; i < 6; i++) {
    if (_liuqin(gwx, benGong[i].$2) == yongShen) {
      return (
        fuZhi: benGong[i].$2,
        fuPos: i,
        feiZhi: lines[i].zhi,
        feiLiuqin: lines[i].liuqin,
      );
    }
  }
  return null;
}

/// 卦中三合局（六爻含某三合局三支）。返回 (五行, 三支)。
MapEntry<String, List<String>>? _findSanHeIn(List<Yao> lines) {
  final zhis = lines.map((y) => y.zhi).toSet();
  for (final e in sanHe.entries) {
    if (e.value.every((z) => zhis.contains(z))) return e;
  }
  return null;
}

/// 卦中三刑（六爻含三刑组合，或自刑同支重复）。
List<String>? _findSanXingIn(List<Yao> lines) {
  final zhis = lines.map((y) => y.zhi).toSet();
  for (final xing in sanXing) {
    if (xing.every((z) => zhis.contains(z))) return xing;
  }
  final counts = <String, int>{};
  for (final y in lines) {
    counts[y.zhi] = (counts[y.zhi] ?? 0) + 1;
  }
  for (final e in counts.entries) {
    if (ziXing.contains(e.key) && e.value >= 2) return [e.key, e.key];
  }
  return null;
}

/// 断卦：综合用神旺衰、动静、原忌神发动、持世，输出总断 + 要点。
({String judgment, List<String> points}) _judge({
  required List<Yao> lines,
  required String yongShen,
  required int? yongPos,
  required String monthZhi,
  required String dayZhi,
  required String gongWx,
  required String gong,
  required int shi,
  required List<String> dayKong,
  required bool isLiuChong,
  required bool isLiuHe,
}) {
  final pts = <String>[];

  // 卦象格局：六冲主散、六合主合。
  if (isLiuChong) {
    pts.add('卦逢六冲（六爻两两相冲），主散、主变、事多反复，测散事吉、测聚事凶。');
  } else if (isLiuHe) {
    pts.add('卦逢六合（六爻两两相合），主合、主聚、事多缓成，测聚事吉、测散事凶。');
  }

  // 三合局 / 三刑（卦级格局）。
  final sh = _findSanHeIn(lines);
  if (sh != null) {
    pts.add('卦中${sh.value.join("")}三合${sh.key}局，${sh.key}气齐整，相关谋为得助。');
  }
  final sx = _findSanXingIn(lines);
  if (sx != null) {
    pts.add('卦中见${sx.join("")}三刑，主刑伤、口舌、阻滞，须防纠纷。');
  }

  if (yongPos == null) {
    pts.add('卦中不见「$yongShen」（用神不上卦），所求缘浅，主事难成。');
    final ff = _findFuFei(lines, yongShen, gong, gongWx);
    if (ff != null) {
      pts.add('伏神「$yongShen${ff.fuZhi}」伏于${_posNames[ff.fuPos]}爻飞神'
          '「${ff.feiLiuqin}${ff.feiZhi}」之下，须待飞神发动或日月生扶伏神方现。');
    }
    return (judgment: '用神伏藏不现，事多蹇滞。', points: pts);
  }

  final yong = lines[yongPos];
  final ws = _wangShuai(yong.zhi, monthZhi, dayZhi);
  final chiShi = yongPos == shi;
  final dong = yong.changing;
  final kong = dayKong.contains(yong.zhi); // 用神落旬空

  // 原神 = 生用神者；忌神 = 克用神者。先由六亲反推用神五行。
  final yongWx = _liuqinWuxingOf(gongWx, yongShen);
  final yuanLiuqin = _wxToLiuqin(gongWx, _shengWo(yongWx));
  final jiLiuqin = _wxToLiuqin(gongWx, _keWo(yongWx));
  final yuanDong = lines.any((y) => y.liuqin == yuanLiuqin && y.changing);
  final jiDong = lines.any((y) => y.liuqin == jiLiuqin && y.changing);

  if (chiShi) {
    pts.add('用神「$yongShen」持世（${_posNames[yongPos]}爻 ${yong.zhi}），'
        '自身得力，事可亲为，主动则成。');
  } else {
    pts.add('用神「$yongShen」在${_posNames[yongPos]}爻（${yong.liuqin}${yong.gan}${yong.zhi}），'
        '不持世。');
  }
  pts.add('用神${yong.zhi}（${zhiWuxing[yong.zhi]}）于月$monthZhi日$dayZhi「$ws」。');

  if (kong) {
    pts.add('用神${yong.zhi}落旬空（日空${dayKong.join("")}），暂时无力，'
        '${dong ? "动而空，出空则应" : "静而空，须待出空或冲空之日方有作为"}。');
  }

  // 月破（冲月建）/ 日冲 / 暗动（静爻被日冲）
  final yuePo = chongMap[yong.zhi] == monthZhi;
  final riChong = chongMap[yong.zhi] == dayZhi;
  if (yuePo) {
    pts.add('用神${yong.zhi}逢月破（冲月建$monthZhi），月内虚耗无力，出月方有转机。');
  }
  if (riChong && !dong) {
    pts.add('用神${yong.zhi}静爻被日辰$dayZhi冲为暗动，虽静犹动，暗中已有动向。');
  } else if (riChong && dong) {
    pts.add('用神发动又被日辰$dayZhi冲，冲散受伤，谋为反复。');
  }

  if (dong) {
    pts.add('用神发动（${yong.yang ? "老阳○" : "老阴×"}），事已有动向，宜顺势求变。');
  } else {
    pts.add('用神安静未动，稳而待时。');
  }
  if (yuanDong) pts.add('原神「$yuanLiuqin」发动生扶用神，有贵人助力，吉。');
  if (jiDong) pts.add('忌神「$jiLiuqin」发动克伤用神，阻力显现，须防破耗。');

  var score = (ws == '旺' ? 1 : ws == '衰' ? -1 : 0) +
      (yuanDong ? 1 : 0) -
      (jiDong ? 1 : 0) +
      (chiShi ? 1 : 0);
  if (kong) score -= 1; // 用神空亡减分（旺相可解）
  if (yuePo) score -= 1; // 月破减分

  final String judgment;
  if (score >= 2) {
    judgment = '用神有力，诸事和顺，大吉之象。';
  } else if (score >= 1) {
    judgment = '用神得地，谋为可成，吉。';
  } else if (score >= 0) {
    judgment = '用神不弱不旺，事可图而须待时，平。';
  } else if (score >= -1) {
    judgment = '用神受制，谋为费力，须谨守待机。';
  } else {
    judgment = '用神衰弱受克，事多不顺，宜止不宜行。';
  }
  return (judgment: judgment, points: pts);
}

/// 某六亲对应的五行（在卦宫 [gongWx] 体系下）。
String _liuqinWuxingOf(String gongWx, String liuqin) {
  switch (liuqin) {
    case '父母':
      return _shengWo(gongWx);
    case '子孙':
      return shengMap[gongWx]!;
    case '官鬼':
      return _keWo(gongWx);
    case '妻财':
      return keMap[gongWx]!;
    case '兄弟':
      return gongWx;
    default:
      return gongWx;
  }
}

/// 由下卦名、上卦名组装六爻纳甲（地支天干），返回 6 爻的 (gan, zhi)。
List<(String, String)> _assembleNajia(String lower, String upper) {
  // 下卦取其内卦三爻（索引 0-2），上卦取其外卦三爻（索引 3-5）。
  final lo = baguaNajia[lower]!;
  final up = baguaNajia[upper]!;
  return [lo[0], lo[1], lo[2], up[3], up[4], up[5]];
}

/// 六爻纳甲排盘。
///
/// - [yongShen]：用神六亲名（由所测之事决定）。
/// - [rng]：随机源（默认真随机），便于测试注入。
/// - [now]：起卦时间（默认当前），用于取日干支与月建。
/// - [rawLines]：历史恢复用——传入既有六爻快照以复现同一卦象。
LiuyaoResult divine({
  required String yongShen,
  Random? rng,
  DateTime? now,
  List<RawLine>? rawLines,
}) {
  rng ??= Random.secure();
  now ??= DateTime.now();
  final raw = rawLines ?? [for (var i = 0; i < 6; i++) _tossLine(rng)];

  // 本卦 bits。
  var benBits = 0;
  for (var i = 0; i < 6; i++) {
    if (raw[i].yang) benBits |= (1 << i);
  }
  final changing = [for (var i = 0; i < 6; i++) if (raw[i].changing) i];
  final lower = benBits & 7;
  final upper = (benBits >> 3) & 7;
  final upName = bin8ToName[upper]!;
  final loName = bin8ToName[lower]!;
  final benName = gua64[(upName, loName)]!;

  // 八宫 + 宫五行。
  final bg = locateBagong(benBits);
  final gwx = gongWuxing[bg.gong]!;

  // 日干支、月建（节气月）。
  final solar = Solar.fromDate(now);
  final lunar = solar.getLunar();
  final dayGz = lunar.getDayInGanZhi();
  final monthGz = lunar.getMonthInGanZhiExact();
  final dayGan = dayGz[0];
  final dayZhi = dayGz[1];
  final monthZhi = monthGz[1];

  // 六神初爻起点。
  final shenStart = dayGanLiuShenStart[dayGan]!;

  // 组装本卦六爻。
  final yaoGz = _assembleNajia(loName, upName);
  final lines = <Yao>[];
  for (var i = 0; i < 6; i++) {
    final (gan, zhi) = yaoGz[i];
    lines.add(Yao(
      yang: raw[i].yang,
      changing: raw[i].changing,
      gan: gan,
      zhi: zhi,
      liuqin: _liuqin(gwx, zhi),
      shenshou: liushenOrder[(shenStart + i) % 6],
    ));
  }

  // 变卦（六亲仍按本卦宫五行——传统「变不换宫」）。
  List<Yao>? bianLines;
  String? bianName;
  if (changing.isNotEmpty) {
    var bb = benBits;
    for (final i in changing) {
      bb ^= (1 << i);
    }
    final bl = bb & 7;
    final bu = (bb >> 3) & 7;
    final bup = bin8ToName[bu]!;
    final blo = bin8ToName[bl]!;
    bianName = gua64[(bup, blo)];
    final bianGz = _assembleNajia(blo, bup);
    bianLines = [
      for (var i = 0; i < 6; i++)
        Yao(
          yang: ((bb >> i) & 1) == 1,
          changing: false,
          gan: bianGz[i].$1,
          zhi: bianGz[i].$2,
          liuqin: _liuqin(gwx, bianGz[i].$2),
          shenshou: liushenOrder[(shenStart + i) % 6],
        ),
    ];
  }

  // 卦象格局（六冲/六合）+ 日辰旬空。
  final isLiuChong = _isLiuChong(lines);
  final isLiuHe = _isLiuHe(lines);
  final dayKong = _dayKongOf(dayGz);

  // 用神 + 断辞。
  final yongPos = _findYong(lines, yongShen, bg.shi);
  final yongKong = yongPos != null && dayKong.contains(lines[yongPos].zhi);
  final j = _judge(
    lines: lines,
    yongShen: yongShen,
    yongPos: yongPos,
    monthZhi: monthZhi,
    dayZhi: dayZhi,
    gongWx: gwx,
    gong: bg.gong,
    shi: bg.shi,
    dayKong: dayKong,
    isLiuChong: isLiuChong,
    isLiuHe: isLiuHe,
  );

  return LiuyaoResult(
    benName: benName,
    bianName: bianName,
    upperName: upName,
    lowerName: loName,
    bagong: bg,
    gongWuxing: gwx,
    dayGan: dayGan,
    dayZhi: dayZhi,
    monthZhi: monthZhi,
    lines: lines,
    bianLines: bianLines,
    yongShen: yongShen,
    yongPos: yongPos,
    judgment: j.judgment,
    points: j.points,
    dayKong: dayKong,
    yongKong: yongKong,
    isLiuChong: isLiuChong,
    isLiuHe: isLiuHe,
  );
}
