// Copyright (c) 2026 Qore
import 'kangxi_strokes.dart';

/// 五行属性。
enum WuxingAttr {
  metal, // 金
  wood,   // 木
  water,  // 水
  fire,   // 火
  earth,  // 土
}

extension WuxingAttrX on WuxingAttr {
  String get label => switch (this) {
        WuxingAttr.metal => '金',
        WuxingAttr.wood => '木',
        WuxingAttr.water => '水',
        WuxingAttr.fire => '火',
        WuxingAttr.earth => '土',
      };

  String get nature => switch (this) {
        WuxingAttr.metal => '刚毅果断',
        WuxingAttr.wood => '仁慈生长',
        WuxingAttr.water => '智慧灵动',
        WuxingAttr.fire => '热情奋发',
        WuxingAttr.earth => '厚重守信',
      };
}

/// 测字结果。
class CeziResult {
  final String inputChar;       // 用户输入的字
  final int strokes;           // 康熙笔画数
  final WuxingAttr wuxing;      // 五行属性
  final String strokeAnalysis;  // 笔画拆解
  final String poem;            // 断语诗
  final String interpretation;  // 解字
  final String detail;          // 详注
  final DateTime time;

  const CeziResult({
    required this.inputChar,
    required this.strokes,
    required this.wuxing,
    required this.strokeAnalysis,
    required this.poem,
    required this.interpretation,
    required this.detail,
    required this.time,
  });
}

/// 取汉字康熙笔画数。[kangxiStrokes] 覆盖 CJK 基本区约 2 万字；
/// 未收录（扩展区 / 罕见字）按 unicode 哈希估算（稳定但非真实笔画）。
int strokesOf(String char) {
  if (char.isEmpty) return 0;
  final known = kangxiStrokes[char];
  if (known != null) return known;
  // 哈希估算：取字符 unicode 模 28 + 1，落在 [1, 28] 区间
  final code = char.runes.first;
  return (code % 28) + 1;
}

/// 根据笔画尾数取五行。
///
/// 传统约定：1/2 木，3/4 火，5/6 土，7/8 金，9/0 水。
WuxingAttr wuxingByStrokes(int strokes) {
  final r = strokes % 10;
  return switch (r) {
        1 || 2 => WuxingAttr.wood,
        3 || 4 => WuxingAttr.fire,
        5 || 6 => WuxingAttr.earth,
        7 || 8 => WuxingAttr.metal,
        _ => WuxingAttr.water, // 9 或 0
      };
}

/// 测字核心。
///
/// 流程：
/// 1. 解析笔画 → 取五行
/// 2. 拆解字形结构
/// 3. 根据五行+笔画生成断语
CeziResult divine(String inputChar, {DateTime? time}) {
  // 取首字符（支持 BMP 与扩展平面），去空白
  final trimmed = inputChar.trim();
  final clean = trimmed.isEmpty ? '' : String.fromCharCode(trimmed.runes.first);
  final strokes = strokesOf(clean);
  final wx = wuxingByStrokes(strokes);
  final analysis = _strokeAnalysis(clean, strokes);
  final poem = _poemFor(wx, strokes);
  final interp = _interpretation(clean, wx, strokes);
  final detail = _detailFor(wx, strokes);

  return CeziResult(
    inputChar: clean,
    strokes: strokes,
    wuxing: wx,
    strokeAnalysis: analysis,
    poem: poem,
    interpretation: interp,
    detail: detail,
    time: time ?? DateTime.now(),
  );
}

/// 字形拆解描述。
String _strokeAnalysis(String ch, int strokes) {
  final wx = wuxingByStrokes(strokes);
  return '「$ch」字共 $strokes 画，五行属${wx.label}。'
      '${strokes >= 20 ? '笔画繁复，结构复杂，主深思多虑之象。' : strokes >= 10 ? '笔画适中，结构均衡，主稳重平和之象。' : '笔画简练，结构疏朗，主干脆直接之象。'}';
}

/// 断语诗（按五行）。
String _poemFor(WuxingAttr wx, int strokes) {
  return switch (wx) {
        WuxingAttr.metal => '金戈铁马气如虹，\n刚毅果断事可成。\n莫因锐气伤和气，\n柔能克刚道自明。',
        WuxingAttr.wood => '草木逢春生意浓，\n向上生长势不停。\n仁者见仁智者智，\n积德培根自长青。',
        WuxingAttr.water => '水润万物细无声，\n灵动圆转自天成。\n智者乐水心明澈，\n顺势而为事可亨。',
        WuxingAttr.fire => '火光照耀照四方，\n热情奋发不可挡。\n盛极必衰宜知止，\n温而能炎道自长。',
        WuxingAttr.earth => '厚土载物德无疆，\n守信重诺事可昌。\n宜静宜守不宜动，\n积土成山自高岗。',
      };
}

/// 解字（按五行+笔画）。
String _interpretation(String ch, WuxingAttr wx, int strokes) {
  final wxLabel = wx.label;
  final nature = wx.nature;
  final strokeComment = strokes >= 20
      ? '笔画繁复，主事多曲折但终可成；宜耐心细理，不可急躁。'
      : strokes >= 10
          ? '笔画适中，主事稳中有进；宜守正不偏，持之以恒。'
          : '笔画简练，主事干脆直接；宜果断而行，不可犹豫。';
  return '字「$ch」五行属$wxLabel，性$nature。$strokeComment';
}

/// 详注（财运/事业/姻缘/健康简注）。
String _detailFor(WuxingAttr wx, int strokes) {
  return switch (wx) {
        WuxingAttr.metal => '财运：利正财　事业：宜决断　姻缘：宜刚柔并济　健康：留意肺气',
        WuxingAttr.wood => '财运：渐旺　事业：宜进取　姻缘：宜培养　健康：肝气调和',
        WuxingAttr.water => '财运：流动　事业：宜随势　姻缘：宜灵活　健康：肾气充沛',
        WuxingAttr.fire => '财运：暴发　事业：宜奋发　姻缘：宜热情　健康：心火调平',
        WuxingAttr.earth => '财运：守成　事业：宜稳重　姻缘：宜守信　健康：脾胃调和',
      };
}
