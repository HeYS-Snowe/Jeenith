// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animation/reveal/reveal_animation.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/history/history_store.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/wuge.dart';

class NameTestPage extends ConsumerStatefulWidget {
  const NameTestPage({super.key});

  @override
  ConsumerState<NameTestPage> createState() => _NameTestPageState();
}

class _NameTestPageState extends ConsumerState<NameTestPage> {
  final _ctrl = TextEditingController();
  WugeResult? _last;
  String? _error;
  final GlobalKey _boundaryKey = GlobalKey();
  static final _hanRegex = RegExp(r'^[\u4e00-\u9fa5]{2,4}$');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDivine() {
    FocusScope.of(context).unfocus();
    final raw = _ctrl.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = '请输入中文姓名');
      return;
    }
    if (!_hanRegex.hasMatch(raw)) {
      setState(() => _error = '请输入 2-4 个汉字（仅支持简繁体汉字）');
      return;
    }
    final result = divineName(raw);
    setState(() {
      _last = result;
      _error = null;
    });
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'name_test',
      techName: '测名字',
      time: DateTime.now(),
      summary: '「$raw」人格${result.ren.strokes}画·${result.ren.wuxing.label}·${result.ren.fortune.grade}',
      detail: _buildCopyText(result),
    )));
  }

  void _onReset() {
    setState(() {
      _last = null;
      _error = null;
      _ctrl.clear();
    });
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
            Text('测　名　字', style: TextStyle(fontSize: 18)),
            Text('五 格 剖 象',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSubtitle,
                    letterSpacing: 4)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          DecorativePanel(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(Icons.badge, color: AppColors.goldBright, size: 16),
                    SizedBox(width: 6),
                    Text('请输入中文姓名（2-4 字）',
                        style: TextStyle(
                            color: AppColors.goldBright,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _ctrl,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                  ),
                  decoration: const InputDecoration(
                    hintText: '姓名',
                    counterText: '',
                  ),
                  onSubmitted: (_) => _onDivine(),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: AppColors.gradeBad, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GoldButton(text: '测名', onPressed: _onDivine),
          const SizedBox(height: 8),
          DarkButton(text: '清空', onPressed: _onReset),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CopyResultButton(
                  text: _buildCopyText(_last),
                  enabled: _last != null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ShareResultButton(
                  boundaryKey: _boundaryKey,
                  enabled: _last != null,
                  fallbackText: _buildCopyText(_last),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_last != null)
            RepaintBoundary(
              key: _boundaryKey,
              child: _buildResult(_last!),
            ),
          const SizedBox(height: 12),
          const DecorativePanel(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('◆ 测名要诀',
                    style: TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                SizedBox(height: 6),
                Text('1. 凝神静气，默念姓名主人之事。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                Text('2. 输入完整姓名（2 字为单姓单名，3 字为单姓双名，4 字按复姓双名计）。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                Text('3. 依康熙字典笔画计算五格，定五行吉凶。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                SizedBox(height: 6),
                Text('注：笔画按康熙字典体计；未收录字按 unicode 估算，结果仅供参断。',
                    style: TextStyle(color: AppColors.textHint, fontSize: 10, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(WugeResult r) {
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('name_test', AnimationKind.reveal) ??
        true;
    return DecorativePanel(
      padding: const EdgeInsets.all(16),
      child: RevealAnimation(
        enabled: enabled,
        hero: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgMid.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.goldBorder, width: 1.5),
            ),
            child: Text(
              r.fullName.split('').join(' '),
              style: const TextStyle(
                color: AppColors.textHighlight,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
        sections: [
          if (r.hasMissing)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gradeBad.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.gradeBad.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.gradeBad, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '部分汉字笔画数据缺失（${_missingChars(r)}），已按估算推算，结果可能不准。',
                      style: const TextStyle(
                          color: AppColors.gradeBad,
                          fontSize: 11,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          // Stroke breakdown
          _sectionLabel('康熙笔画'),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (var i = 0; i < r.chars.length; i++)
                _strokeChip(r.chars[i], r.strokes[i], r.missing[i]),
            ],
          ),
          // Five-grid table
          _sectionLabel('五格数理'),
          _buildGridTable(r),
          // Wuxing distribution
          _sectionLabel('五行分布'),
          _buildWuxingDistribution(r),
          // Verdict
          _sectionLabel('综合批断'),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.bgMid.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Text(
              r.summary,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.8,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Center(
            child: Text(
              '${r.time.toString().substring(0, 19)} 测得',
              style:
                  const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  String _missingChars(WugeResult r) {
    final list = <String>[];
    for (var i = 0; i < r.chars.length; i++) {
      if (r.missing[i]) list.add(r.chars[i]);
    }
    return list.join('、');
  }

  Widget _strokeChip(String ch, int strokes, bool missing) {
    final color = missing ? AppColors.gradeBad : AppColors.goldBright;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(ch,
              style: const TextStyle(
                  color: AppColors.textHighlight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Text('$strokes 画',
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGridTable(WugeResult r) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgMid.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Column(
        children: [
          _gridHeader(),
          _gridRow(r.tian),
          _gridRow(r.ren, highlight: true),
          _gridRow(r.di),
          _gridRow(r.zong),
          _gridRow(r.wai, isLast: true),
        ],
      ),
    );
  }

  Widget _gridHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.bgInner,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('格',
              style: TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('笔画',
              style: TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('五行',
              style: TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('吉凶',
              style: TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _gridRow(GeResult g, {bool highlight = false, bool isLast = false}) {
    final gradeColor = _colorForGrade(g.fortune.grade);
    final wxColor = _colorForWuxing(g.wuxing);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.gold.withValues(alpha: 0.08)
            : Colors.transparent,
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: AppColors.goldBorder.withValues(alpha: 0.25)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(g.name,
                style: TextStyle(
                    color: highlight ? AppColors.goldBright : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text('${g.strokes}',
                style: const TextStyle(
                    color: AppColors.textHighlight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text(g.wuxing.label,
                style: TextStyle(color: wxColor, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text('${g.fortune.grade} · ${g.fortune.desc}',
                style: TextStyle(color: gradeColor, fontSize: 11, height: 1.3)),
          ),
        ],
      ),
    );
  }

  Widget _buildWuxingDistribution(WugeResult r) {
    final count = r.wuxingCount;
    const order = [Wuxing.metal, Wuxing.wood, Wuxing.water, Wuxing.fire, Wuxing.earth];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final w in order) _wuxingChip(w, count[w] ?? 0),
      ],
    );
  }

  Widget _wuxingChip(Wuxing w, int count) {
    final color = _colorForWuxing(w);
    return Column(
      children: [
        Text(w.label,
            style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Text('$count',
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 2),
        Text(w.nature,
            style: const TextStyle(color: AppColors.textMeta, fontSize: 9)),
      ],
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Container(width: 3, height: 14, color: AppColors.gold),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );

  /// Generate the detailed text for copy / share.
  String _buildCopyText(WugeResult? r) {
    if (r == null) return '';
    final sb = StringBuffer('【测名字 · 五格剖象】\n');
    sb.writeln('时间：${r.time.toString().substring(0, 19)}');
    sb.writeln('姓名：「${r.fullName}」');
    sb.writeln('康熙笔画：${r.chars.asMap().entries.map((e) => '${e.value}=${r.strokes[e.key]}画').join(' ')}');
    sb.writeln('姓氏：${r.compoundSurname ? "复姓" : "单姓"}');
    if (r.hasMissing) {
      sb.writeln('（注：${_missingChars(r)} 笔画数据缺失，已估算）');
    }
    sb.writeln('\n—— 五格数理 ——');
    for (final g in [r.tian, r.ren, r.di, r.zong, r.wai]) {
      sb.writeln('${g.name}（${g.role}）：${g.strokes}画 · ${g.wuxing.label} · ${g.fortune.grade} · ${g.fortune.desc}');
    }
    sb.writeln('\n—— 五行分布 ——');
    final count = r.wuxingCount;
    for (final w in [Wuxing.metal, Wuxing.wood, Wuxing.water, Wuxing.fire, Wuxing.earth]) {
      sb.writeln('${w.label}（${w.nature}）：${count[w] ?? 0}');
    }
    sb.writeln('\n—— 综合批断 ——');
    sb.writeln(r.summary);
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Color _colorForWuxing(Wuxing w) => switch (w) {
        Wuxing.metal => AppColors.metal,
        Wuxing.wood => AppColors.wood,
        Wuxing.water => AppColors.waterDeep,
        Wuxing.fire => AppColors.fire,
        Wuxing.earth => AppColors.earth,
      };

  Color _colorForGrade(String grade) => switch (grade) {
        '大吉' => AppColors.gradeGreat,
        '吉' => AppColors.gradeGood,
        '平' => AppColors.gradeSteady,
        '凶' => AppColors.gradeRough,
        '大凶' => AppColors.gradeBad,
        _ => AppColors.textBody,
      };
}
