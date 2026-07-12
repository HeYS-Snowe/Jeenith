// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/yijing/trigrams.dart';
import '../../../core/history/history_store.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/entrance_item.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../algorithm/divine.dart';

class MeihuaPage extends StatefulWidget {
  const MeihuaPage({super.key});

  @override
  State<MeihuaPage> createState() => _MeihuaPageState();
}

class _MeihuaPageState extends State<MeihuaPage>
    with SingleTickerProviderStateMixin {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  MeihuaResult? _result;
  List<int>? _inputs;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _divine(int n1, int n2) {
    FocusScope.of(context).unfocus();
    setState(() {
      _result = divine(n1, n2);
      _inputs = [n1, n2];
    });
    _anim.forward(from: 0);
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'meihua',
      techName: '梅花易数',
      time: DateTime.now(),
      summary: _result?.benName ?? '',
      detail: _buildCopyText(),
    )));
  }

  void _onDivine() {
    final n1 = int.tryParse(_c1.text.trim()) ?? 0;
    final n2 = int.tryParse(_c2.text.trim()) ?? 0;
    if (n1 < 1 || n2 < 1) return;
    _divine(n1, n2);
  }

  void _onRandom() {
    final (result, n1, n2) = divineRandom();
    setState(() {
      _result = result;
      _inputs = [n1, n2];
    });
    _anim.forward(from: 0);
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'meihua',
      techName: '梅花易数',
      time: DateTime.now(),
      summary: _result?.benName ?? '',
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
            Text('梅花易数', style: TextStyle(fontSize: 18)),
            Text('数 字 起 卦',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSubtitle,
                    letterSpacing: 4)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          DecorativePanel(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('输入两个正整数（任意可见之数：时辰、字数、人数…）',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _numField(_c1, '上卦数')),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('·',
                          style: TextStyle(
                              color: AppColors.gold, fontSize: 20)),
                    ),
                    Expanded(child: _numField(_c2, '下卦数')),
                  ],
                ),
                const SizedBox(height: 12),
                GoldButton(text: '起卦', onPressed: _onDivine),
                const SizedBox(height: 8),
                DarkButton(
                  icon: const SvgIcon('casino'),
                  text: '随机两数',
                  onPressed: _onRandom,
                ),
                const SizedBox(height: 8),
                CopyResultButton(text: _buildCopyText(), enabled: _result != null),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_result != null) _buildResult(_result!),
        ],
      ),
    );
  }

  Widget _numField(TextEditingController c, String hint) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: hint, isDense: true),
        onSubmitted: (_) => _onDivine(),
      );

  Widget _buildResult(MeihuaResult r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_inputs != null)
          EntranceItem(
            animation: _anim,
            interval: const Interval(0.0, 0.22),
            child: DecorativePanel(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text('取数 ${_inputs![0]} · ${_inputs![1]}',
                  style: const TextStyle(
                      color: AppColors.goldBright,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.08, 0.34),
          child: Center(
            child: Text(r.benName,
                style: const TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 60,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.18, 0.42),
          child: Center(
            child: Text('${xiang[r.upName]}${xiang[r.loName]}${r.benName}',
                style: const TextStyle(
                    color: AppColors.gold, fontSize: 16, letterSpacing: 4)),
          ),
        ),
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.28, 0.54),
          child: DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _trigramChip('上卦', r.upName, r.dongInUpper ? '用' : '体'),
                _trigramChip('下卦', r.loName, r.dongInUpper ? '体' : '用'),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('动爻',
                        style: TextStyle(
                            color: AppColors.textSubtitle, fontSize: 11)),
                    Text('第${_posLabel(r.dong)}爻',
                        style: const TextStyle(
                            color: AppColors.changing,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.42, 0.70),
          child: DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('体卦 ${r.tiName}　·　用卦 ${r.yongName}',
                    style: const TextStyle(
                        color: AppColors.textBody, fontSize: 13)),
                const SizedBox(width: 16),
                Text('→ 之卦 ${r.bianName}',
                    style: const TextStyle(
                        color: AppColors.changing,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _result;
    if (r == null) return '';
    final sb = StringBuffer('【梅花易数 · 数字起卦】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    if (_inputs != null) sb.writeln('取数：${_inputs![0]} · ${_inputs![1]}');
    sb.writeln('本卦：${r.benName}（${xiang[r.upName]}${xiang[r.loName]}）');
    sb.writeln('上卦：${r.upName}${xiang[r.upName]}  下卦：${r.loName}${xiang[r.loName]}');
    sb.writeln('动爻：第${const ["", "初", "二", "三", "四", "五", "上"][r.dong]}爻  体卦：${r.tiName}  用卦：${r.yongName}');
    sb.writeln('之卦：${r.bianName}');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _trigramChip(String label, String name, String role) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textSubtitle, fontSize: 11)),
        const SizedBox(height: 2),
        Text('$name${xiang[name]}',
            style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(role,
            style: TextStyle(
                color: role == '用' ? AppColors.changing : AppColors.wood,
                fontSize: 11)),
      ],
    );
  }

  String _posLabel(int i) =>
      const ['', '初', '二', '三', '四', '五', '上'][i];
}
