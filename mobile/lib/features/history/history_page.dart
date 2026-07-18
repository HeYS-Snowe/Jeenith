// Copyright (c) 2026 Qore
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/history/history_store.dart';
import '../../core/history/history_export.dart';
import '../../shared/widgets/decorative_panel.dart';
import '../../shared/widgets/divination_loading_indicator.dart';

/// 历史记录页：列表 + 详情 + 备注 + 删除。
///
/// v2.4.2：全面主题感知（浅色模式适配）。
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryEntry> _list = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final list = await HistoryStore.load();
    if (!mounted) return;
    setState(() {
      _list = list;
      _loading = false;
    });
  }

  /// 复制一条历史记录到剪贴板，含术数名、摘要、时间、详情与备注。
  Future<void> _copyEntry(HistoryEntry e) async {
    final buf = StringBuffer()
      ..writeln('【${e.techName}】${e.summary}')
      ..writeln('时间：${e.time.toString().substring(0, 19)}')
      ..writeln()
      ..writeln(e.detail);
    if (e.note != null && e.note!.isNotEmpty) {
      buf
        ..writeln()
        ..writeln('备注：${e.note}');
    }
    await Clipboard.setData(ClipboardData(text: buf.toString().trimRight()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('已复制到剪贴板'),
        backgroundColor: AppClr.of(context).card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openDetail(HistoryEntry e) {
    final c = AppClr.of(context);
    final gradeBad = c.resolve(AppColors.gradeBad, AppColorsLight.gradeBad);
    final noteCtrl = TextEditingController(text: e.note ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.card,
        title: Text('${e.techName} · ${e.summary}',
            style: TextStyle(
                color: c.goldBright,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('时间：${e.time.toString().substring(0, 19)}',
                  style: TextStyle(color: c.textMeta, fontSize: 12)),
              const SizedBox(height: 8),
              Text(e.detail,
                  style: TextStyle(color: c.textBody, fontSize: 12, height: 1.5)),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '添加备注…',
                  hintStyle: TextStyle(color: c.textHint),
                ),
                style: TextStyle(color: c.textPrimary, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async => _copyEntry(e),
            child: Text('复制', style: TextStyle(color: c.goldBright)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryStore.remove(e.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: Text('删除', style: TextStyle(color: gradeBad)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryStore.updateNote(e.id,
                  noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim());
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: Text('保存备注', style: TextStyle(color: c.gold)),
          ),
        ],
      ),
    );
  }

  void _confirmClear() {
    final c = AppClr.of(context);
    final gradeBad = c.resolve(AppColors.gradeBad, AppColorsLight.gradeBad);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.card,
        title: Text('清空全部历史',
            style: TextStyle(
                color: c.goldBright,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        content: Text('此操作不可撤销，确定清空所有卜算历史记录？',
            style: TextStyle(color: c.textBody, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('取消', style: TextStyle(color: c.textSubtitle)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryStore.clear();
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: Text('清空', style: TextStyle(color: gradeBad)),
          ),
        ],
      ),
    );
  }

  Future<void> _export(String format) async {
    final list = await HistoryStore.load();
    if (!mounted) return;
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('暂无历史记录可导出'),
          backgroundColor: AppClr.of(context).card,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    File file;
    switch (format) {
      case 'json':
        file = await HistoryExport.exportJson(list);
        break;
      case 'md':
        file = await HistoryExport.exportMarkdown(list);
        break;
      case 'csv':
        file = await HistoryExport.exportCsv(list);
        break;
      default:
        return;
    }
    await Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    final c = AppClr.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('历 史 记 录'),
        actions: [
          if (_list.isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(Icons.ios_share, color: c.gold),
              tooltip: '导出历史',
              onSelected: _export,
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'json', child: Text('导出为 JSON')),
                PopupMenuItem(value: 'md', child: Text('导出为 Markdown')),
                PopupMenuItem(value: 'csv', child: Text('导出为 CSV')),
              ],
            ),
          if (_list.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep,
                  color: c.resolve(AppColors.gradeBad, AppColorsLight.gradeBad)),
              tooltip: '清空全部历史',
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: DivinationLoadingIndicator(size: 56))
          : _list.isEmpty
              ? Center(
                  child: Text('暂无历史记录',
                      style: TextStyle(color: c.textHint)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: _list.length,
                  itemBuilder: (context, i) {
                    final e = _list[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DecorativePanel(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text('${e.techName} · ${e.summary}',
                              style: TextStyle(
                                  color: c.goldBright,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(e.time.toString().substring(0, 19),
                                  style: TextStyle(
                                      color: c.textMeta, fontSize: 11)),
                              if (e.note != null && e.note!.isNotEmpty)
                                Text('备注：${e.note}',
                                    style: TextStyle(
                                        color: c.textBody, fontSize: 12)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy_all,
                                    color: c.textSubtitle, size: 20),
                                tooltip: '复制',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 36, minHeight: 36),
                                onPressed: () => _copyEntry(e),
                              ),
                              Icon(Icons.chevron_right, color: c.textSubtitle),
                            ],
                          ),
                          onTap: () => _openDetail(e),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
