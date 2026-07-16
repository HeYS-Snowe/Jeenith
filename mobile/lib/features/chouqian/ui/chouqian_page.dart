// Copyright (c) 2026 Qore
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animation/reveal/reveal_animation.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/history/history_store.dart';
import '../../../core/rng/rng_providers.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';

class ChouqianPage extends ConsumerStatefulWidget {
  const ChouqianPage({super.key});

  @override
  ConsumerState<ChouqianPage> createState() => _ChouqianPageState();
}

class _ChouqianPageState extends ConsumerState<ChouqianPage>
    with TickerProviderStateMixin {
  ChouqianResult? _last;
  bool _busy = false;
  late final AnimationController _shake;
  late final AnimationController _fall;
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fall = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _shake.dispose();
    _fall.dispose();
    super.dispose();
  }

  Future<void> _onDraw() async {
    if (_busy) return;
    setState(() => _busy = true);
    _shake.forward(from: 0);
    // 摇签中段出签
    await Future.delayed(const Duration(milliseconds: 760));
    final entropy = await ref.read(trueRandomProvider).generate(count: 1, vmax: stickCount);
    if (!mounted) return;
    final result = divine(entropy.numbers.first);
    setState(() {
      _last = result;
      _busy = false;
    });
    _fall.forward(from: 0);
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'chouqian',
      techName: '抽签',
      time: DateTime.now(),
      summary: '第${result.stick.number}签 · ${result.stick.title} · ${result.stick.grade.label}',
      detail: _buildCopyText(result),
    )));
  }

  void _onReset() {
    setState(() {
      _last = null;
      _busy = false;
    });
    _shake.value = 0;
    _fall.value = 0;
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
            Text('抽　签', style: TextStyle(fontSize: 18)),
            Text('百 签 问 运',
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
            height: 220,
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_shake, _fall]),
                builder: (context, _) => _buildHolder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_last != null)
            Center(
              child: Text(
                '第 ${_last!.stick.number} 签',
                style: const TextStyle(
                  color: AppColors.goldBright,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          const SizedBox(height: 12),
          GoldButton(
            text: _busy ? '摇签中…' : '摇签',
            onPressed: _busy ? null : _onDraw,
          ),
          const SizedBox(height: 8),
          DarkButton(
            text: '再抽一签',
            onPressed: _busy ? null : _onReset,
          ),
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
        ],
      ),
    );
  }

  /// 竹签筒：摇动时左右摆动，落签时一根竹签从筒中升起。
  Widget _buildHolder() {
    // 摇摆：sin(8π * t) * (1 - t) 阻尼振荡
    final t = _shake.value;
    final swing = _busy ? math.sin(t * math.pi * 8) * (1 - t) * 0.18 : 0.0;
    // 落签：fall.value 0→1
    final fallProgress = _last != null ? _fall.value : 0.0;

    return Transform.rotate(
      angle: swing,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 筒身
          Container(
            width: 110,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFF6A4A2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8C87A), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _SticksPainter(fallProgress: fallProgress, busy: _busy),
              size: const Size(110, 170),
            ),
          ),
          // 筒口装饰
          Positioned(
            top: 0,
            child: Container(
              width: 110,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF8A6A3A),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: const Color(0xFFE8C87A), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ChouqianResult r) {
    final stick = r.stick;
    final gradeColor = _colorForGrade(stick.grade);
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('chouqian', AnimationKind.reveal) ??
        true;
    return DecorativePanel(
      padding: const EdgeInsets.all(16),
      child: RevealAnimation(
        enabled: enabled,
        hero: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: gradeColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: gradeColor.withValues(alpha: 0.6)),
            ),
            child: Text(
              stick.grade.label,
              style: TextStyle(
                color: gradeColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
          ),
        ),
        sections: [
          Center(
            child: Text(
              stick.title,
              style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.bgMid.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Text(
              stick.poem,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.8,
                letterSpacing: 1,
              ),
            ),
          ),
          _sectionLabel('解曰'),
          Text(
            stick.interpretation,
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          _sectionLabel('详注'),
          Text(
            stick.detail,
            style: const TextStyle(
              color: AppColors.textMeta,
              fontSize: 12,
              height: 1.6,
              letterSpacing: 1,
            ),
          ),
          Center(
            child: Text(
              '${r.time.toString().substring(0, 19)} 抽得',
              style:
                  const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ),
        ],
      ),
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
  String _buildCopyText(ChouqianResult? r) {
    if (r == null) return '';
    final s = r.stick;
    final sb = StringBuffer('【抽签 · 百签问运】\n');
    sb.writeln('时间：${r.time.toString().substring(0, 19)}');
    sb.writeln('签号：第 ${s.number} 签');
    sb.writeln('签题：${s.title}');
    sb.writeln('等级：${s.grade.label}');
    sb.writeln('\n签诗：');
    sb.writeln(s.poem);
    sb.writeln('\n解曰：${s.interpretation}');
    sb.writeln('详注：${s.detail}');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Color _colorForGrade(StickGrade g) => switch (g) {
        StickGrade.shangShang => AppColors.gradeGreat,
        StickGrade.shang => AppColors.gradeGood,
        StickGrade.zhong => AppColors.gradeSteady,
        StickGrade.xia => AppColors.gradeRough,
        StickGrade.xiaXia => AppColors.gradeBad,
      };
}

/// 签筒内竹签绘制：忙碌时摇晃，落签时一支升起。
class _SticksPainter extends CustomPainter {
  final double fallProgress;
  final bool busy;

  const _SticksPainter({required this.fallProgress, required this.busy});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // 签筒内的竹签（背景一束）
    final stickPaint = Paint()
      ..color = const Color(0xFFD4A857)
      ..style = PaintingStyle.fill;
    final tipPaint = Paint()
      ..color = const Color(0xFFE8C87A)
      ..style = PaintingStyle.fill;

    // 后排多根签
    final backSticks = [
      Offset(w * 0.25, h * 0.18),
      Offset(w * 0.40, h * 0.12),
      Offset(w * 0.55, h * 0.10),
      Offset(w * 0.70, h * 0.16),
      Offset(w * 0.85, h * 0.22),
    ];
    for (final p in backSticks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: p, width: 6, height: 90),
          const Radius.circular(3),
        ),
        stickPaint,
      );
      canvas.drawCircle(p + Offset(0, -48), 3.5, tipPaint);
    }

    // 前排落出的那一根签
    if (fallProgress > 0) {
      final rise = fallProgress * 60; // 升起 60 像素
      final frontX = w * 0.5;
      final frontY = h * 0.3 - rise;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(frontX, frontY), width: 8, height: 110),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFE8C87A),
      );
      // 签头红色装饰
      canvas.drawCircle(Offset(frontX, frontY - 58), 5, Paint()..color = const Color(0xFFE85A3C));
      // 签号
      final tp = TextPainter(
        text: TextSpan(
          text: '签',
          style: TextStyle(color: const Color(0xFF1A1208), fontSize: 9, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(frontX - tp.width / 2, frontY - 62));
      tp.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant _SticksPainter old) =>
      fallProgress != old.fallProgress || busy != old.busy;
}
