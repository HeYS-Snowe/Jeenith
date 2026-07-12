// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:ui';
import 'package:flutter/foundation.dart';

/// 单维断辞（如 求谋/失物/出行 等）。
@immutable
class DetailDimension {
  final String label;   // '求谋'
  final String content; // '可成，宜稳进，贵人扶助。'
  const DetailDimension(this.label, this.content);
}

/// 整体吉凶分级。
@immutable
class Verdict {
  final String grade;        // '大吉之象'
  final Color tone;          // 分级主题色
  final String description;  // 断语
  const Verdict(this.grade, this.tone, this.description);
}

/// 变位（周易变爻 / 未来其他术的变位）。
@immutable
class ChangingPosition {
  final int index;       // 0-based
  final String label;    // '初'/'二'/.../'上'
  const ChangingPosition(this.index, this.label);
}

/// 单张结果卡的数据（小六壬落宫 / 周易卦象）。
@immutable
class ResultCardData {
  final String order;        // '一'/'二'/'三' 或 '本'/'变'
  final String title;        // '大安' / '乾'
  final String? subtitle;    // '木 · 青龙 · 东方'
  final String? badge;       // '大吉'
  final Color? badgeColor;
  final String? poem;        // 诗诀
  final String? meaning;     // 含义长文
  final List<DetailDimension>? details;  // 多维断辞（小六壬七维）
  final Color? accentColor;  // 卡片主色

  const ResultCardData({
    required this.order,
    required this.title,
    this.subtitle,
    this.badge,
    this.badgeColor,
    this.poem,
    this.meaning,
    this.details,
    this.accentColor,
  });
}

/// 真随机采样详情（RNG 各源采样结果，供 UI 展示）。
@immutable
class EntropySourceResult {
  final String name;
  final String display;
  final bool succeeded;
  const EntropySourceResult({
    required this.name,
    required this.display,
    required this.succeeded,
  });
}

@immutable
class EntropySample {
  final List<int> numbers;
  final List<EntropySourceResult> sources;
  final DateTime timestamp;
  const EntropySample({
    required this.numbers,
    required this.sources,
    required this.timestamp,
  });
}

/// 统一结果模型 —— 兼容小六壬（三宫+七维+分级）与周易（本卦+变卦+变爻）。
@immutable
class DivinationResult {
  final String techId;

  // —— 核心展示 ——
  final String primaryName;              // 小六壬: 末宫名 / 周易: 本卦名
  final String? primarySubtitle;         // '木·东方' 或 '天'
  final String? secondaryName;           // 变卦名（周易）/ null
  final String? secondarySubtitle;

  // —— 结构化数据 ——
  final List<ChangingPosition>? changingPositions;  // 变爻位
  final Verdict? verdict;                            // 综合断语
  final List<DetailDimension>? details;              // 顶层多维断辞

  /// 多元素结构化卡片（小六壬 3 张落宫卡 / 周易 1~2 张卦卡）。
  final List<ResultCardData> cards;

  // —— 元信息 ——
  final List<int>? inputNumbers;
  final EntropySample? entropy;
  final DateTime timestamp;

  /// 术特定原始数据（escape hatch，保证灵活）。
  final Object? raw;

  const DivinationResult({
    required this.techId,
    required this.primaryName,
    required this.cards,
    required this.timestamp,
    this.primarySubtitle,
    this.secondaryName,
    this.secondarySubtitle,
    this.changingPositions,
    this.verdict,
    this.details,
    this.inputNumbers,
    this.entropy,
    this.raw,
  });
}
