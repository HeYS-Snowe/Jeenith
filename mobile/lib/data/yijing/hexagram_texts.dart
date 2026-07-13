// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// 单卦的卦辞与爻辞文本集合。
class _HexagramData {
  final String guaCi;
  final String guaCiNote;
  final Map<String, _YaoText> yao;

  const _HexagramData({
    required this.guaCi,
    required this.guaCiNote,
    required this.yao,
  });

  factory _HexagramData.fromJson(Map<String, dynamic> j) {
    final yaoList = j['yao'] as List<dynamic>;
    final yao = <String, _YaoText>{
      for (final e in yaoList)
        (e as Map<String, dynamic>)['pos'] as String: _YaoText(
          ci: e['ci'] as String,
          note: e['note'] as String,
        ),
    };
    return _HexagramData(
      guaCi: j['guaCi'] as String,
      guaCiNote: j['guaCiNote'] as String,
      yao: yao,
    );
  }
}

class _YaoText {
  final String ci;
  final String note;
  const _YaoText({required this.ci, required this.note});
}

/// 64 卦卦辞爻辞加载器（古文 + 白话注解）。
///
/// 数据来源：`assets/yijing/hexagrams.json`，首次调用 [load] 时从 rootBundle
/// 读入并缓存到内存 Map。之后所有查询均为 O(1) 同步访问。
///
/// 爻位称名规则：阳爻称"九"，阴爻称"六"，自下而上为初/二/三/四/五/上。
/// 初位与上位把位置放前（初九、上六），其余把阴阳放前（九二、六三）。
class HexagramTexts {
  static final Map<String, _HexagramData> _cache = {};
  static bool _loaded = false;

  HexagramTexts._();

  /// 预加载全部 64 卦文本到内存。重复调用幂等。
  static Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/yijing/hexagrams.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    for (final entry in map.entries) {
      _cache[entry.key] =
          _HexagramData.fromJson(entry.value as Map<String, dynamic>);
    }
    _loaded = true;
  }

  /// 是否已加载完成。
  static bool get isLoaded => _loaded;

  /// 卦辞原文（如"乾：元亨利贞。"）。未加载或无此卦返回 null。
  static String? guaCi(String name) => _cache[name]?.guaCi;

  /// 卦辞白话注解。未加载或无此卦返回 null。
  static String? guaCiNote(String name) => _cache[name]?.guaCiNote;

  /// 按爻位称名（如"初九"/"六二"）查询爻辞原文。
  static String? yaoCi(String guaName, String yaoPos) =>
      _cache[guaName]?.yao[yaoPos]?.ci;

  /// 按爻位称名查询爻辞白话注解。
  static String? yaoCiNote(String guaName, String yaoPos) =>
      _cache[guaName]?.yao[yaoPos]?.note;

  /// 按位序 + 阴阳生成爻位称名。
  ///
  /// [pos] 0-5 对应初/二/三/四/五/上。[yang] true=阳爻称九，false=阴爻称六。
  /// 返回值如"初九"/"六二"/"上六"。
  static String posName(int pos, bool yang) {
    const posLabels = ['初', '二', '三', '四', '五', '上'];
    final yl = yang ? '九' : '六';
    final pl = posLabels[pos];
    // 初位、上位：位置在前（初九、上六）；其余：阴阳在前（九二、六三）
    return (pos == 0 || pos == 5) ? '$pl$yl' : '$yl$pl';
  }

  /// 乾卦"用九"/坤卦"用六"辞（六爻全变时取用）。非乾坤返回 null。
  static String? yongCi(String guaName) {
    if (guaName == '乾') return _cache['乾']?.yao['用九']?.ci;
    if (guaName == '坤') return _cache['坤']?.yao['用六']?.ci;
    return null;
  }

  /// 乾卦"用九"/坤卦"用六"白话注解。
  static String? yongCiNote(String guaName) {
    if (guaName == '乾') return _cache['乾']?.yao['用九']?.note;
    if (guaName == '坤') return _cache['坤']?.yao['用六']?.note;
    return null;
  }
}
