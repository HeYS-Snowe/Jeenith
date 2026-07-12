// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/history/history_store.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';

class QimenPage extends StatefulWidget {
  const QimenPage({super.key});
  @override
  State<QimenPage> createState() => _QimenPageState();
}

class _QimenPageState extends State<QimenPage> {
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _hour = TextEditingController();
  QimenResult? _r;

  @override
  void dispose() {
    for (final c in [_year, _month, _day, _hour]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onDivine() {
    final y = int.tryParse(_year.text) ?? 0;
    final m = int.tryParse(_month.text) ?? 0;
    final d = int.tryParse(_day.text) ?? 0;
    final h = int.tryParse(_hour.text) ?? -1;
    if (y < 1900 || y > 2100 || m < 1 || m > 12 || d < 1 || d > 31 || h < 0 || h > 23) return;
    setState(() => _r = divine(y, m, d, h));
    FocusScope.of(context).unfocus();
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'qimen',
      techName: '奇门遁甲',
      time: DateTime.now(),
      summary: _r == null ? '' : '${_r!.dunType}第${_r!.ju}局',
      detail: _buildCopyText(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Column(
          children: [
            Text('奇门遁甲', style: TextStyle(fontSize: 18)),
            Text('时 家 奇 门',
                style: TextStyle(
                    fontSize: 10, color: AppColors.textSubtitle, letterSpacing: 4)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('公历时辰（年 月 日 时 0-23）',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _f(_year, '年')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_month, '月')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_day, '日')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_hour, '时')),
                  ],
                ),
                const SizedBox(height: 10),
                GoldButton(text: '排盘', onPressed: _onDivine),
                const SizedBox(height: 8),
                CopyResultButton(text: _buildCopyText(), enabled: _r != null),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_r != null) _buildResult(_r!),
          const SizedBox(height: 10),
          const Text('※ v1 基础排盘：阴阳遁 / 局数 / 节气 / 八字。天地人神四盘（值符值使、八门、九星、八神）留待 v2 深化。',
              style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _r;
    if (r == null) return '';
    final sb = StringBuffer('【奇门遁甲 · 时家奇门】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln(r.lunarDisplay);
    sb.writeln('八字：${r.bazi}');
    sb.writeln('节气：${r.jieqi}');
    sb.writeln('遁型：${r.dunType}  局数：第 ${r.ju} 局');
    sb.writeln('\n※ v1 基础排盘，天地人神四盘待 v2 深化');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _f(TextEditingController c, String hint) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: hint, isDense: true),
      );

  Widget _buildResult(QimenResult r) {
    // 9 宫位（3×3，中宫为太极）
    const gong = ['巽', '离', '坤', '震', '中', '兑', '艮', '坎', '乾'];
    final dunColor = r.dunType == '阳遁' ? AppColors.gold : AppColors.waterDeepGlow;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecorativePanel(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.lunarDisplay,
                  style: const TextStyle(color: AppColors.goldBright, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('八字：${r.bazi}',
                  style: const TextStyle(color: AppColors.textBody, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(r.dunType,
                      style: TextStyle(color: dunColor, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  const SizedBox(width: 16),
                  Text('第 ${r.ju} 局',
                      style: const TextStyle(color: AppColors.fireGlow, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (r.jieqi.isNotEmpty)
                    Text(r.jieqi,
                        style: const TextStyle(color: AppColors.textMeta, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text('◆ 局盘九宫', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1.3,
          children: [
            for (var i = 0; i < 9; i++)
              Container(
                decoration: BoxDecoration(
                  color: i == 4 ? AppColors.gold.withValues(alpha: 0.12) : AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: i == 4 ? AppColors.gold : const Color.fromRGBO(212, 168, 87, 0.2)),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(gong[i],
                        style: TextStyle(
                            color: i == 4 ? AppColors.goldBright : AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(i == 4 ? '太极' : '（v2）',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
