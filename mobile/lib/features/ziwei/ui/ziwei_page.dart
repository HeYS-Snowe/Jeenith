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

class ZiweiPage extends StatefulWidget {
  const ZiweiPage({super.key});
  @override
  State<ZiweiPage> createState() => _ZiweiPageState();
}

class _ZiweiPageState extends State<ZiweiPage> {
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _hour = TextEditingController();
  ZiweiResult? _r;

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
      techId: 'ziwei',
      techName: '紫微斗数',
      time: DateTime.now(),
      summary: _r?.wuxingJu ?? '',
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
            Text('紫微斗数', style: TextStyle(fontSize: 18)),
            Text('命 盘 排 盘',
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
                const Text('公历生辰（年 月 日 时 0-23）',
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
          const Text('※ v1 基础排盘：命身宫 / 十二宫 / 五行局 / 八字。星曜安星（14主星+辅星）排盘留待 v2 深化。',
              style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }

  Widget _f(TextEditingController c, String hint) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: hint, isDense: true),
      );

  Widget _buildResult(ZiweiResult r) {
    const dz = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
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
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('命宫：${r.mingGanZhi}（${dz[r.mingGong]}）',
                      style: const TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Text('身宫：${dz[r.shenGong]}',
                      style: const TextStyle(color: AppColors.waterDeepGlow, fontSize: 13, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(r.wuxingJu,
                      style: const TextStyle(color: AppColors.fireGlow, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text('◆ 命盘十二宫', style: TextStyle(color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1.1,
          children: [
            for (var zhi = 0; zhi < 12; zhi++)
              _palaceCell(zhi, dz[zhi], r.gongAtZhi[zhi], r.mingGong, r.shenGong),
          ],
        ),
      ],
    );
  }

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _r;
    if (r == null) return '';
    const dz = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    final sb = StringBuffer('【紫微斗数 · 命盘排盘】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln(r.lunarDisplay);
    sb.writeln('八字：${r.bazi}');
    sb.writeln('命宫：${r.mingGanZhi}（${dz[r.mingGong]}）  身宫：${dz[r.shenGong]}  ${r.wuxingJu}');
    sb.writeln('\n—— 十二宫 ——');
    for (var zhi = 0; zhi < 12; zhi++) {
      final g = r.gongAtZhi[zhi];
      if (g >= 0) sb.writeln('${dz[zhi]}宫：${palaceNames[g]}');
    }
    sb.writeln('\n※ v1 基础排盘，星曜安星待 v2 深化');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _palaceCell(int zhi, String zhiName, int gongIdx, int ming, int shen) {
    final isMing = zhi == ming;
    final isShen = zhi == shen;
    final gongName = gongIdx >= 0 ? palaceNames[gongIdx] : '';
    return Container(
      decoration: BoxDecoration(
        color: isMing
            ? AppColors.gold.withValues(alpha: 0.18)
            : (isShen ? AppColors.waterDeep.withValues(alpha: 0.18) : AppColors.card),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isMing
                ? AppColors.gold
                : (isShen ? AppColors.waterDeepGlow : const Color.fromRGBO(212, 168, 87, 0.2)),
            width: isMing || isShen ? 1.5 : 1),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(zhiName, style: TextStyle(color: AppColors.textMeta, fontSize: 11)),
          const SizedBox(height: 2),
          Text(gongName,
              style: TextStyle(
                  color: isMing ? AppColors.goldBright : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          if (isMing || isShen)
            Text(isMing ? '命' : '身',
                style: TextStyle(
                    color: isMing ? AppColors.gold : AppColors.waterDeepGlow, fontSize: 10)),
        ],
      ),
    );
  }
}
