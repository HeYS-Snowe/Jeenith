// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'history_store.dart';

/// 历史记录导出工具：将 [HistoryEntry] 列表导出为 JSON / Markdown / CSV 文件。
///
/// 所有方法返回写入临时目录的 [File]，调用方可走 [Share.shareXFiles] 分享。
class HistoryExport {
  HistoryExport._();

  /// 导出为 JSON（完整保真，可直接重导入）。
  static Future<File> exportJson(List<HistoryEntry> list) async {
    final tmpDir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tmpDir.path}/jeenith_history_$ts.json');
    final encoded = const JsonEncoder.withIndent('  ').convert(
      list.map((e) => e.toJson()).toList(),
    );
    await file.writeAsString(encoded);
    return file;
  }

  /// 导出为 Markdown（人类可读表格 + 详情块）。
  static Future<File> exportMarkdown(List<HistoryEntry> list) async {
    final tmpDir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tmpDir.path}/jeenith_history_$ts.md');
    final sb = StringBuffer('# 志极 Jeenith · 卜算历史\n\n');
    sb.writeln('导出时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln('记录总数：${list.length}\n');
    sb.writeln('| # | 时间 | 术 | 摘要 | 备注 |');
    sb.writeln('|---|------|----|------|------|');
    for (var i = 0; i < list.length; i++) {
      final e = list[i];
      sb.writeln('| ${i + 1} | ${e.time.toString().substring(0, 19)} | '
          '${e.techName} | ${_mdEscape(e.summary)} | ${_mdEscape(e.note ?? '')} |');
    }
    sb.writeln('\n---\n');
    for (var i = 0; i < list.length; i++) {
      final e = list[i];
      sb.writeln('## ${i + 1}. ${e.techName} · ${e.summary}\n');
      sb.writeln('**时间**：${e.time.toString().substring(0, 19)}\n');
      if (e.note != null && e.note!.isNotEmpty) {
        sb.writeln('**备注**：${e.note}\n');
      }
      sb.writeln('**详情**：\n\n```\n${e.detail}\n```\n');
    }
    await file.writeAsString(sb.toString());
    return file;
  }

  /// 导出为 CSV（Excel 可打开）。
  static Future<File> exportCsv(List<HistoryEntry> list) async {
    final tmpDir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tmpDir.path}/jeenith_history_$ts.csv');
    final sb = StringBuffer('\uFEFF'); // BOM for Excel UTF-8
    sb.writeln('时间,术,摘要,详情,备注');
    for (final e in list) {
      sb.writeln([
        e.time.toString().substring(0, 19),
        _csvEscape(e.techName),
        _csvEscape(e.summary),
        _csvEscape(e.detail),
        _csvEscape(e.note ?? ''),
      ].join(','));
    }
    await file.writeAsString(sb.toString());
    return file;
  }

  static String _csvEscape(String s) {
    final needsQuote = s.contains(',') ||
        s.contains('"') ||
        s.contains('\n') ||
        s.contains('\r');
    if (!needsQuote) return s;
    return '"${s.replaceAll('"', '""')}"';
  }

  static String _mdEscape(String s) =>
      s.replaceAll('|', '\\|').replaceAll('\n', ' ');
}
