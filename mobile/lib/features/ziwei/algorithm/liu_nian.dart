// Copyright (c) 2026 Qore
import '../data/stars.dart';
import 'star_placement.dart';

const _dizhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
const _tiangan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

/// 流年 / 小限信息（v2.12.0）。
///
/// 紫微斗数流年盘以「值年地支」为流年命宫，十二宫逆布方向同本命；
/// 流年天干决定流年四化；小限从生年支起一岁，逐年顺行一位（不分性别）。
class LiuNianInfo {
  /// 流年公历年。
  final int year;

  /// 流年干支（如 "丙午"）。
  final String ganZhi;

  /// 流年天干索引 0..9。
  final int ganIdx;

  /// 流年地支索引 0..11（即流年命宫所在宫）。
  final int zhiIdx;

  /// 虚岁。
  final int xuSui;

  /// 小限所在宫地支索引 0..11。
  final int xiaoXianZhi;

  /// 流年四化（禄/权/科/忌四星名）。
  final SiHuaSet sihua;

  /// 流年命宫三方四正地支（命 / 财帛 / 官禄 / 迁移）。
  final List<int> sanFangZhi;

  const LiuNianInfo({
    required this.year,
    required this.ganZhi,
    required this.ganIdx,
    required this.zhiIdx,
    required this.xuSui,
    required this.xiaoXianZhi,
    required this.sihua,
    required this.sanFangZhi,
  });

  /// 流年四化星名 → 化的映射（便于查某星是否被流年所化）。
  Map<String, SiHua> get sihuaMap => {
        sihua.lu: SiHua.lu,
        sihua.quan: SiHua.quan,
        sihua.ke: SiHua.ke,
        sihua.ji: SiHua.ji,
      };

  /// 该星是否被流年所化；若是返回化类型，否则 null。
  SiHua? sihuaOf(String starName) => sihuaMap[starName];
}

/// 计算某流年的流年/小限信息。
///
/// - [birthYear]：出生公历年（用于虚岁与小限起算）。
/// - [liuNianYear]：欲推的流年公历年。
///
/// 虚岁按公历年差近似（= liuNianYear - birthYear + 1），跨农历年岁末可能差一岁，
/// 用户可按实际虚岁微调流年年份。
LiuNianInfo computeLiuNian({
  required int birthYear,
  required int liuNianYear,
}) {
  final ganIdx = (liuNianYear - 4) % 10;
  final zhiIdx = (liuNianYear - 4) % 12;
  final ganZhi = '${_tiangan[ganIdx]}${_dizhi[zhiIdx]}';

  final xuSui = liuNianYear - birthYear + 1;

  // 小限：生年支起一岁，逐年顺行一位。
  final birthZhiIdx = (birthYear - 4) % 12;
  final xiaoXianZhi = (birthZhiIdx + (xuSui - 1)) % 12;

  final sihua = sihuaByGan[_tiangan[ganIdx]]!;

  // 三方四正：命(流年支) + 财帛(支-4) + 官禄(支-8) + 迁移对宫(支-6)。
  // 十二宫逆布：命0 兄1 夫2 子3 财4 ... 官8 ... 迁6（对宫）。
  final sanFangZhi = <int>[
    zhiIdx,
    (zhiIdx - 4 + 12) % 12,
    (zhiIdx - 8 + 12) % 12,
    (zhiIdx - 6 + 12) % 12,
  ];

  return LiuNianInfo(
    year: liuNianYear,
    ganZhi: ganZhi,
    ganIdx: ganIdx,
    zhiIdx: zhiIdx,
    xuSui: xuSui,
    xiaoXianZhi: xiaoXianZhi,
    sihua: sihua,
    sanFangZhi: sanFangZhi,
  );
}

/// 生成流年断辞要点（基于流年命宫三方四正星曜 + 流年四化）。
///
/// 返回简洁要点列表，供结果页展示。
List<String> liuNianPoints(LiuNianInfo ln, StarChart chart) {
  final points = <String>[];

  // 流年命宫主星
  final mingMain = chart.gongStars[ln.zhiIdx]
      .where((s) => s.category == StarCategory.main)
      .map((s) => s.name)
      .toList();
  points.add(mingMain.isEmpty
      ? '流年命宫无主星坐守，借对宫迁移星曜——变动、外出之年。'
      : '流年命宫坐 ${mingMain.join("、")}，为此年运势基调。');

  // 流年四化落宫
  final smap = ln.sihuaMap;
  for (final entry in smap.entries) {
    final star = entry.key;
    final hua = entry.value;
    // 查该星在本命盘何宫
    var gong = -1;
    for (var z = 0; z < 12; z++) {
      if (chart.gongStars[z].any((s) => s.name == star)) {
        gong = z;
        break;
      }
    }
    final dzChar = _dizhi[gong < 0 ? 0 : gong];
    final huaName = hua == SiHua.lu
        ? '禄（机遇收获）'
        : hua == SiHua.quan
            ? '权（主动掌控）'
            : hua == SiHua.ke
                ? '科（名声贵人）'
                : '忌（阻碍执着）';
    points.add('流年$star 化$huaName，落 $dzChar 宫。');
  }

  // 小限
  final xxMain = chart.gongStars[ln.xiaoXianZhi]
      .where((s) => s.category == StarCategory.main)
      .map((s) => s.name)
      .toList();
  points.add(xxMain.isEmpty
      ? '小限宫（${_dizhi[ln.xiaoXianZhi]}）无主星，心境浮动。'
      : '小限走 ${_dizhi[ln.xiaoXianZhi]} 宫（${xxMain.join("、")}），主导 ${ln.xuSui} 岁心境。');

  return points;
}
