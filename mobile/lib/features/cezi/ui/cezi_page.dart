// Copyright (c) 2026 Qore
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
import '../algorithm/divine.dart';

class CeziPage extends ConsumerStatefulWidget {
  const CeziPage({super.key});

  @override
  ConsumerState<CeziPage> createState() => _CeziPageState();
}

class _CeziPageState extends ConsumerState<CeziPage> {
  final _ctrl = TextEditingController();
  CeziResult? _last;
  String? _error;
  final GlobalKey _boundaryKey = GlobalKey();
  static final _hanRegex = RegExp(r'^[\u4e00-\u9fa5]$');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDivine() {
    FocusScope.of(context).unfocus();
    final raw = _ctrl.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = '请输入一个汉字');
      return;
    }
    final ch = raw.isEmpty ? '' : String.fromCharCode(raw.runes.first);
    if (!_hanRegex.hasMatch(ch)) {
      setState(() => _error = '请输入单个汉字（仅支持简繁体汉字）');
      return;
    }
    final result = divine(ch);
    setState(() {
      _last = result;
      _error = null;
    });
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'cezi',
      techName: '测字',
      time: DateTime.now(),
      summary: '「$ch」${result.strokes}画 · ${result.wuxing.label}',
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
            Text('测　字', style: TextStyle(fontSize: 18)),
            Text('一 字 一 玄 机',
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
                    Icon(Icons.edit, color: AppColors.goldBright, size: 16),
                    SizedBox(width: 6),
                    Text('请输入一个汉字',
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
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: '字',
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
          GoldButton(text: '测字', onPressed: _onDivine),
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
                Text('◆ 测字要诀',
                    style: TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                SizedBox(height: 6),
                Text('1. 凝神静气，默念所问之事。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                Text('2. 心中浮现一个字，输入此字。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                Text('3. 拆字笔画 → 五行属性 → 断语吉凶。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.6)),
                SizedBox(height: 6),
                Text('注：笔画按传统康熙字典体计；未收录字按 unicode 哈希估算。',
                    style: TextStyle(color: AppColors.textHint, fontSize: 10, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(CeziResult r) {
    final wxColor = _colorForWuxing(r.wuxing);
    final enabled =
        ref.watch(configProvider).valueOrNull?.isAnimationEnabled('cezi', AnimationKind.reveal) ?? true;
    return DecorativePanel(
      padding: const EdgeInsets.all(16),
      child: RevealAnimation(
        enabled: enabled,
        hero: Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.bgMid.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: wxColor.withValues(alpha: 0.6), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              r.inputChar,
              style: const TextStyle(
                color: AppColors.textHighlight,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        sections: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _attrChip('笔画', '${r.strokes} 画', AppColors.goldBright),
              _attrChip('五行', r.wuxing.label, wxColor),
              _attrChip('性情', r.wuxing.nature, AppColors.textBody),
            ],
          ),
          _sectionLabel('字形拆解'),
          Text(
            r.strokeAnalysis,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          _sectionLabel('断语诗'),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.bgMid.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Text(
              r.poem,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.8,
                letterSpacing: 1,
              ),
            ),
          ),
          _sectionLabel('解字'),
          Text(
            r.interpretation,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          _sectionLabel('详注'),
          Text(
            r.detail,
            style: const TextStyle(
              color: AppColors.textMeta,
              fontSize: 12,
              height: 1.6,
              letterSpacing: 1,
            ),
          ),
          Center(
            child: Text(
              '${r.time.toString().substring(0, 19)} 测得',
              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attrChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSubtitle, fontSize: 11, letterSpacing: 2),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
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

  /// 生成详细结果文本（供复制）。
  String _buildCopyText(CeziResult? r) {
    if (r == null) return '';
    final sb = StringBuffer('【测字 · 一字一玄机】\n');
    sb.writeln('时间：${r.time.toString().substring(0, 19)}');
    sb.writeln('字：「${r.inputChar}」');
    sb.writeln('笔画：${r.strokes} 画');
    sb.writeln('五行：${r.wuxing.label}（${r.wuxing.nature}）');
    sb.writeln('\n拆解：${r.strokeAnalysis}');
    sb.writeln('\n断语诗：');
    sb.writeln(r.poem);
    sb.writeln('\n解字：${r.interpretation}');
    sb.writeln('详注：${r.detail}');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Color _colorForWuxing(WuxingAttr w) => switch (w) {
        WuxingAttr.metal => AppColors.metal,
        WuxingAttr.wood => AppColors.wood,
        WuxingAttr.water => AppColors.waterDeep,
        WuxingAttr.fire => AppColors.fire,
        WuxingAttr.earth => AppColors.earth,
      };
}
