// Copyright (c) 2026 Qore. All rights reserved.
import '../../../core/divination/divination_result.dart';
import '../algorithm/divine.dart';
import '../algorithm/verdict.dart';
import '../data/palaces.dart';

const _orders = ['一', '二', '三'];

/// 把掐指结果组装为统一 [DivinationResult]（三张落宫卡 + 综合分级 + 采样详情）。
DivinationResult buildXiaoliurenResult({
  required List<int> nums,
  required DivineResult divine,
  EntropySample? entropy,
}) {
  final cards = <ResultCardData>[];
  for (var k = 0; k < divine.lands.length; k++) {
    final p = palaces[divine.lands[k]];
    cards.add(ResultCardData(
      order: _orders[k],
      title: p.name,
      subtitle: '${p.wuxing} · ${p.shen} · ${p.fangwei}',
      badge: p.jixiong,
      badgeColor: p.glow,
      poem: p.poem,
      meaning: p.meaning,
      details: detailKeys
          .map((key) => DetailDimension(key, p.detail[key]!))
          .toList(),
      accentColor: p.glow,
    ));
  }
  final last = palaces[divine.lands.last];
  return DivinationResult(
    techId: 'xiaoliuren',
    primaryName: last.name,
    primarySubtitle: '${last.wuxing}·${last.fangwei}',
    cards: cards,
    verdict: overallVerdict(divine.lands),
    inputNumbers: nums,
    entropy: entropy,
    timestamp: DateTime.now(),
    raw: divine,
  );
}
