// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/yijing/trigrams.dart';
import '../../../data/yijing/hexagram_texts.dart';
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
        // —— 本卦卦辞 ——
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.54, 0.80),
          child: _buildGuaCiCard(
            title: '本卦卦辞 · ${r.benName}',
            guaName: r.benName,
            titleColor: AppColors.gold,
          ),
        ),
        // —— 动爻爻辞 ——
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.62, 0.86),
          child: _buildDongYaoCiCard(r),
        ),
        // —— 变卦卦辞 ——
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.70, 0.92),
          child: _buildGuaCiCard(
            title: '之卦卦辞 · ${r.bianName}',
            guaName: r.bianName,
            titleColor: AppColors.changing,
          ),
        ),
      ],
    );
  }

  /// 卦辞卡片（标题 + 原文 + 白话注解）。
  Widget _buildGuaCiCard({
    required String title,
    required String guaName,
    required Color titleColor,
  }) {
    final ci = HexagramTexts.guaCi(guaName) ?? '';
    final note = HexagramTexts.guaCiNote(guaName) ?? '';
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          if (ci.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(ci,
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 14, height: 1.6)),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(note,
                style: const TextStyle(
                    color: AppColors.textSubtitle, fontSize: 12, height: 1.5)),
          ],
        ],
      ),
    );
  }

  /// 动爻爻辞卡片（梅花动爻只一爻）。
  Widget _buildDongYaoCiCard(MeihuaResult r) {
    final posName = HexagramTexts.posName(r.dongPos, r.dongYang);
    final ci = HexagramTexts.yaoCi(r.benName, posName) ?? '';
    final note = HexagramTexts.yaoCiNote(r.benName, posName) ?? '';
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('动爻 · $posName',
              style: const TextStyle(
                  color: AppColors.changing,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          if (ci.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(ci,
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 14, height: 1.6)),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(note,
                style: const TextStyle(
                    color: AppColors.textSubtitle, fontSize: 12, height: 1.5)),
          ],
        ],
      ),
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
    // 卦辞爻辞
    final benCi = HexagramTexts.guaCi(r.benName);
    if (benCi != null && benCi.isNotEmpty) {
      sb.writeln('\n—— 本卦卦辞 ——');
      sb.writeln(benCi);
      final benNote = HexagramTexts.guaCiNote(r.benName);
      if (benNote != null && benNote.isNotEmpty) sb.writeln('注：$benNote');
    }
    final posName = HexagramTexts.posName(r.dongPos, r.dongYang);
    final dongCi = HexagramTexts.yaoCi(r.benName, posName);
    if (dongCi != null && dongCi.isNotEmpty) {
      sb.writeln('\n—— 动爻 $posName ——');
      sb.writeln(dongCi);
      final dongNote = HexagramTexts.yaoCiNote(r.benName, posName);
      if (dongNote != null && dongNote.isNotEmpty) sb.writeln('注：$dongNote');
    }
    final bianCi = HexagramTexts.guaCi(r.bianName);
    if (bianCi != null && bianCi.isNotEmpty) {
      sb.writeln('\n—— 之卦卦辞 ——');
      sb.writeln(bianCi);
      final bianNote = HexagramTexts.guaCiNote(r.bianName);
      if (bianNote != null && bianNote.isNotEmpty) sb.writeln('注：$bianNote');
    }
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
