// Copyright (c) 2026 Qore

import '../../../data/kangxi_strokes.dart';

/// 五格剖象法的康熙笔画查表。
///
/// 共享数据源 [kangxiStrokes]（data/kangxi_strokes.dart，CJK 基本区约 2 万字，
/// 源自 breezyreeds/kangxi-strokecount，MIT）。五格剖象按康熙字典部首原形计画
/// （如 氵→4、忄→4、扌→4），与传统姓名学约定一致。
///
/// v2.4.3：原内置 ~490 字表替换为共享 2 万字康熙数据，覆盖率与准确性双升
/// （修正了原表若干简体计画错误，如「生」4→5）。未收录字符（扩展区 / 罕见字）
/// 按 unicode 估算（5..22），UI 会警告可能不准。

/// Returns the Kangxi stroke count for [ch].
///
/// When the character is absent from [kangxiStrokes], a deterministic estimate
/// is derived from the unicode code point (range 5..22). Prefer [hasStrokeData]
/// to detect coverage and warn the user.
int strokeOf(String ch) {
  final v = kangxiStrokes[ch];
  if (v != null) return v;
  return 5 + (ch.runes.first % 18);
}

/// Whether [ch] is covered by the built-in stroke table.
bool hasStrokeData(String ch) => kangxiStrokes.containsKey(ch);
