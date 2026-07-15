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
import '../../../shared/widgets/entrance_item.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';

class JiaobeiPage extends ConsumerStatefulWidget {
  const JiaobeiPage({super.key});

  @override
  ConsumerState<JiaobeiPage> createState() => _JiaobeiPageState();
}

class _JiaobeiPageState extends ConsumerState<JiaobeiPage>
    with SingleTickerProviderStateMixin {
  JiaoResult? _last;
  final List<JiaoResult> _round = []; // 本轮（默认连掷三筊为一轮）
  int _shengCount = 0; // 累计圣筊数
  bool _busy = false;
  late final AnimationController _flip;
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _flip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  Future<void> _onToss() async {
    if (_busy) return;
    setState(() => _busy = true);
    _flip.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 360)); // 翻转中段出结果
    final r = divine();
    _round.add(r);
    if (r.type == JiaoType.sheng) _shengCount++;
    setState(() {
      _last = r;
      _busy = false;
    });
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'jiaobei',
      techName: '掷筊',
      time: DateTime.now(),
      summary: r.type.name,
      detail: _buildCopyText(),
    )));
  }

  void _onReset() {
    setState(() {
      _last = null;
      _round.clear();
      _shengCount = 0;
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
            Text('掷　筊', style: TextStyle(fontSize: 18)),
            Text('杯 筊 问 事',
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
          SizedBox(
            height: 180,
            child: Center(
              child: AnimatedBuilder(
                animation: _flip,
                builder: (context, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _jiaoPiece(_last?.p1Yang, _flip.value),
                    const SizedBox(width: 28),
                    _jiaoPiece(_last?.p2Yang, _flip.value),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_last != null)
            Center(
              child: Text(_last!.type.name,
                  style: TextStyle(
                      color: _colorFor(_last!.type),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6)),
            ),
          const SizedBox(height: 12),
          GoldButton(text: _busy ? '掷筊中…' : '掷筊', onPressed: _busy ? null : _onToss),
          const SizedBox(height: 8),
          DarkButton(
            text: '重置本轮',
            onPressed: _busy ? null : _onReset,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CopyResultButton(text: _buildCopyText(), enabled: _last != null),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ShareResultButton(
                  boundaryKey: _boundaryKey,
                  enabled: _last != null,
                  fallbackText: _buildCopyText(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RepaintBoundary(
            key: _boundaryKey,
            child: RevealAnimation(
              enabled: ref
                      .watch(configProvider)
                      .valueOrNull
                      ?.isAnimationEnabled('jiaobei', AnimationKind.reveal) ??
                  true,
              hero: DecorativePanel(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('本轮',
                            style: TextStyle(
                                color: AppColors.textSubtitle, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text('${_round.length} 筊',
                            style: const TextStyle(
                                color: AppColors.goldBright,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        const Text('圣筊',
                            style: TextStyle(
                                color: AppColors.textSubtitle, fontSize: 12)),
                        const SizedBox(width: 8),
                        Text('$_shengCount',
                            style: const TextStyle(
                                color: AppColors.gradeGreat,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_last != null)
                      Text(_last!.type.meaning,
                          style: const TextStyle(
                              color: AppColors.textBody,
                              fontSize: 12,
                              height: 1.5)),
                    const SizedBox(height: 6),
                    const Text('传统连掷三圣筊为确证。阳面为平面（凸背为阴）。',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (var i = 0; i < _round.length; i++)
                EntranceItem(
                  animation: AlwaysStoppedAnimation(1),
                  interval: const Interval(0, 1),
                  child: _roundChip(_round[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jiaoPiece(bool? yangUp, double flip) {
    // 翻转中：交替正反；落定后显示真实结果
    final showYang = _busy ? (flip * 6).floor().isOdd : (yangUp ?? true);
    return Transform.translate(
      offset: Offset(0, _busy ? -20 * (1 - flip.abs() * 2).abs() : 0),
      child: Container(
        width: 86,
        height: 56,
        decoration: BoxDecoration(
          color: showYang ? const Color(0xFFD4A857) : const Color(0xFF6A4A2A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color(0xFFE8C87A),
              width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          showYang ? '阳' : '阴',
          style: TextStyle(
            color: showYang ? const Color(0xFF1A1208) : const Color(0xFFE0BF7E),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _roundChip(JiaoResult r) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _colorFor(r.type).withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _colorFor(r.type).withValues(alpha: 0.5)),
        ),
        child: Text(r.type.name,
            style: TextStyle(color: _colorFor(r.type), fontSize: 12)),
      );

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _last;
    if (r == null) return '';
    final sb = StringBuffer('【掷筊 · 杯筊问事】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln('本次：${r.type.name}（片1${r.p1Yang ? "阳" : "阴"} 片2${r.p2Yang ? "阳" : "阴"}）');
    sb.writeln('释义：${r.type.meaning}');
    sb.writeln('\n本轮：共 ${_round.length} 筊，其中圣筊 $_shengCount');
    sb.writeln('（传统连掷三圣筊为确证）');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Color _colorFor(JiaoType t) => switch (t) {
        JiaoType.sheng => AppColors.gradeGreat,
        JiaoType.xiao => AppColors.goldBright,
        JiaoType.yin => AppColors.gradeBad,
      };
}
