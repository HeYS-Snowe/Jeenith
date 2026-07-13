// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/history/history_store.dart';
import '../../core/history/history_export.dart';
import '../../shared/widgets/decorative_panel.dart';

/// 历史记录页：列表 + 详情 + 备注 + 删除。
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

  void _openDetail(HistoryEntry e) {
    final noteCtrl = TextEditingController(text: e.note ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('${e.techName} · ${e.summary}',
            style: const TextStyle(color: AppColors.goldBright, fontSize: 15, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('时间：${e.time.toString().substring(0, 19)}',
                  style: const TextStyle(color: AppColors.textMeta, fontSize: 12)),
              const SizedBox(height: 8),
              Text(e.detail,
                  style: const TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.5)),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: '添加备注…',
                  hintStyle: TextStyle(color: AppColors.textHint),
                ),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await HistoryStore.remove(e.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: const Text('删除', style: TextStyle(color: AppColors.gradeBad)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryStore.updateNote(e.id, noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim());
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: const Text('保存备注', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('清空全部历史',
            style: TextStyle(color: AppColors.goldBright, fontSize: 15, fontWeight: FontWeight.bold)),
        content: const Text('此操作不可撤销，确定清空所有卜算历史记录？',
            style: TextStyle(color: AppColors.textBody, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AppColors.textSubtitle)),
          ),
          TextButton(
            onPressed: () async {
              await HistoryStore.clear();
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              _reload();
            },
            child: const Text('清空', style: TextStyle(color: AppColors.gradeBad)),
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
        const SnackBar(
          content: Text('暂无历史记录可导出'),
          backgroundColor: AppColors.card,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
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
              icon: const Icon(Icons.ios_share, color: AppColors.gold),
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
              icon: const Icon(Icons.delete_sweep, color: AppColors.gradeBad),
              tooltip: '清空全部历史',
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _list.isEmpty
              ? const Center(
                  child: Text('暂无历史记录', style: TextStyle(color: AppColors.textHint)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: _list.length,
                  itemBuilder: (context, i) {
                    final e = _list[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DecorativePanel(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('${e.techName} · ${e.summary}',
                              style: const TextStyle(
                                  color: AppColors.goldBright,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(e.time.toString().substring(0, 19),
                                  style: const TextStyle(color: AppColors.textMeta, fontSize: 11)),
                              if (e.note != null && e.note!.isNotEmpty)
                                Text('备注：${e.note}',
                                    style: const TextStyle(color: AppColors.textBody, fontSize: 12)),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textSubtitle),
                          onTap: () => _openDetail(e),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
