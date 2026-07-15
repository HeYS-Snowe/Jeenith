// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animation/reveal/reveal_animation.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/history/history_store.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';
import '../algorithm/star_placement.dart';
import '../data/stars.dart';
import 'star_chart_painter.dart';

class ZiweiPage extends ConsumerStatefulWidget {
  const ZiweiPage({super.key});
  @override
  ConsumerState<ZiweiPage> createState() => _ZiweiPageState();
}

class _ZiweiPageState extends ConsumerState<ZiweiPage>
    with TickerProviderStateMixin {
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _hour = TextEditingController();
  ZiweiResult? _r;
  final GlobalKey _boundaryKey = GlobalKey();
  final GlobalKey _chartKey = GlobalKey();

  // Star chart rotation state.
  double _rotationAngle = 0.0;
  double _lastAngle = 0.0;
  Offset? _chartCenter;
  Offset _lastLocalPosition = Offset.zero;
  AnimationController? _inertiaCtrl;
  FrictionSimulation? _frictionSim;

  // Star chart progressive draw animation (v2.3.1 Phase 3).
  // 1.2s, drives StarChartPainter.progress 0.0→1.0.
  late final AnimationController _chartAnim;

  @override
  void initState() {
    super.initState();
    _chartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _inertiaCtrl?.dispose();
    _chartAnim.dispose();
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
    // 触发命盘绘制过程动画
    _chartAnim.forward(from: 0);
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

  // === Star chart rotation gestures ===

  void _onPanStart(DragStartDetails details) {
    // Cancel any running inertia.
    _inertiaCtrl?.stop();
    _inertiaCtrl = null;
    _frictionSim = null;
    // Resolve the chart center from the gesture target's render box.
    final box = _chartKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      _chartCenter = Offset(box.size.width / 2, box.size.height / 2);
    }
    final center = _chartCenter;
    if (center == null) return;
    final dx = details.localPosition.dx - center.dx;
    final dy = details.localPosition.dy - center.dy;
    _lastAngle = math.atan2(dy, dx);
    _lastLocalPosition = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final center = _chartCenter;
    if (center == null) return;
    final dx = details.localPosition.dx - center.dx;
    final dy = details.localPosition.dy - center.dy;
    final angle = math.atan2(dy, dx);
    var delta = angle - _lastAngle;
    // Normalize delta to [-π, π] to avoid jumps across the ±π boundary.
    if (delta > math.pi) {
      delta -= 2 * math.pi;
    } else if (delta < -math.pi) {
      delta += 2 * math.pi;
    }
    setState(() {
      _rotationAngle += delta;
      _lastAngle = angle;
      _lastLocalPosition = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final center = _chartCenter;
    if (center == null) return;
    final v = details.velocity.pixelsPerSecond;
    final dx = _lastLocalPosition.dx - center.dx;
    final dy = _lastLocalPosition.dy - center.dy;
    final r2 = dx * dx + dy * dy;
    if (r2 < 1) return;
    // Angular velocity matching the _rotationAngle convention (rad/s):
    // ω = d(atan2(dy, dx))/dt = (dx·v.dy - dy·v.dx) / r².
    final omega = (dx * v.dy - dy * v.dx) / r2;
    if (omega.abs() < 0.05) return;
    // Friction drag 0.45: enough inertia to feel silky without spinning too long.
    const drag = 0.45;
    _frictionSim = FrictionSimulation(drag, _rotationAngle, omega);
    // Estimate stop time from the exponential decay of velocity; clamp so the
    // animation never starts too short nor runs too long.
    var stopSeconds = math.log(omega.abs() / 0.05) / drag;
    if (stopSeconds < 0.3) stopSeconds = 0.3;
    if (stopSeconds > 3.0) stopSeconds = 3.0;
    final durationSeconds = stopSeconds;
    _inertiaCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (durationSeconds * 1000).round()),
    )
      ..addListener(() {
        final sim = _frictionSim;
        final ctrl = _inertiaCtrl;
        if (sim == null || ctrl == null) return;
        setState(() {
          _rotationAngle = sim.x(durationSeconds * ctrl.value);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _inertiaCtrl?.dispose();
          _inertiaCtrl = null;
          _frictionSim = null;
        }
      })
      ..forward();
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
                Row(
                  children: [
                    Expanded(
                      child: CopyResultButton(text: _buildCopyText(), enabled: _r != null),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShareResultButton(
                        boundaryKey: _boundaryKey,
                        enabled: _r != null,
                        fallbackText: _buildCopyText(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_r != null)
            RepaintBoundary(key: _boundaryKey, child: _buildResult(_r!)),
          const SizedBox(height: 10),
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
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('ziwei') ??
        true;
    return RevealAnimation(
      enabled: enabled,
      hero: DecorativePanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.lunarDisplay,
                style: const TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('八字：${r.bazi}',
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('命宫：${r.mingGanZhi}（${dz[r.mingGong]}）',
                    style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Text('身宫：${dz[r.shenGong]}',
                    style: const TextStyle(
                        color: AppColors.waterDeepGlow,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(r.wuxingJu,
                    style: const TextStyle(
                        color: AppColors.fireGlow,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      sections: [
        const Text('◆ 命盘星图',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 380,
            child: GestureDetector(
              key: _chartKey,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: ClipRect(
                // Clip overflow so rotated text is smoothly cut at the edge.
                child: Transform.rotate(
                  angle: _rotationAngle,
                  // v2.3.1: 命盘绘制过程动画（progress 0→1 驱动）
                  child: AnimatedBuilder(
                    animation: _chartAnim,
                    builder: (context, _) {
                      return RepaintBoundary(
                        child: CustomPaint(
                          painter: StarChartPainter(
                            mingGong: r.mingGong,
                            shenGong: r.shenGong,
                            gongAtZhi: r.gongAtZhi,
                            mingGanZhi: r.mingGanZhi,
                            wuxingJu: r.wuxingJu,
                            chart: r.stars,
                            progress: _chartAnim.value,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const Text('指尖拖拽可旋转命盘',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textHint, fontSize: 11)),
        const Text('◆ 宫位详情',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var zhi = 0; zhi < 12; zhi++)
              _buildGongDetailRow(zhi, dz[zhi], r.gongAtZhi[zhi], r.mingGong,
                  r.shenGong, r.stars.gongStars[zhi]),
          ],
        ),
      ],
    );
  }

  /// 单行宫位详情：地支 + 宫名 + 主星 + 吉星 + 煞星 + 神煞。
  Widget _buildGongDetailRow(int zhi, String zhiName, int gongIdx, int ming, int shen, List<StarPlacement> stars) {
    final isMing = zhi == ming;
    final isShen = zhi == shen;
    final gongName = (gongIdx >= 0 && gongIdx < palaceNames.length) ? palaceNames[gongIdx] : '';

    String joinByCategory(StarCategory cat) =>
        stars.where((s) => s.category == cat).map((s) => s.name).join(' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isMing
            ? AppColors.gold.withValues(alpha: 0.12)
            : (isShen ? AppColors.waterDeep.withValues(alpha: 0.12) : AppColors.card),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isMing
                ? AppColors.goldBorder
                : (isShen ? AppColors.waterDeepGlow : const Color.fromRGBO(212, 168, 87, 0.18)),
            width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(zhiName,
                        style: TextStyle(
                            color: isMing ? AppColors.goldBright : AppColors.textMeta,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    if (isMing || isShen)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(isMing ? '命' : '身',
                            style: TextStyle(
                                color: isMing ? AppColors.gold : AppColors.waterDeepGlow,
                                fontSize: 10)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(gongName,
                    style: TextStyle(
                        color: isMing ? AppColors.gold : AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (joinByCategory(StarCategory.main).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(joinByCategory(StarCategory.main),
                        style: const TextStyle(color: AppColors.goldBright, fontSize: 12, fontWeight: FontWeight.bold, height: 1.4)),
                  ),
                if (joinByCategory(StarCategory.auspicious).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('吉：${joinByCategory(StarCategory.auspicious)}',
                        style: const TextStyle(color: AppColors.woodGlow, fontSize: 11, height: 1.4)),
                  ),
                if (joinByCategory(StarCategory.malefic).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('煞：${joinByCategory(StarCategory.malefic)}',
                        style: const TextStyle(color: AppColors.fireGlow, fontSize: 11, height: 1.4)),
                  ),
                if (joinByCategory(StarCategory.boshishen).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(joinByCategory(StarCategory.boshishen),
                        style: const TextStyle(color: AppColors.textSubtitle, fontSize: 10, height: 1.4)),
                  ),
                if (joinByCategory(StarCategory.shensha).isNotEmpty)
                  Text(joinByCategory(StarCategory.shensha),
                      style: const TextStyle(color: AppColors.earthGlow, fontSize: 10, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
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
    sb.writeln('\n—— 十二宫星曜 ——');
    for (var zhi = 0; zhi < 12; zhi++) {
      final g = r.gongAtZhi[zhi];
      final gongName = (g >= 0 && g < palaceNames.length) ? palaceNames[g] : '—';
      final stars = r.stars.gongStars[zhi];
      final main = stars.where((s) => s.category == StarCategory.main).map((s) => s.name).join(' ');
      final aus = stars.where((s) => s.category == StarCategory.auspicious).map((s) => s.name).join(' ');
      final mal = stars.where((s) => s.category == StarCategory.malefic).map((s) => s.name).join(' ');
      final bos = stars.where((s) => s.category == StarCategory.boshishen).map((s) => s.name).join(' ');
      final sha = stars.where((s) => s.category == StarCategory.shensha).map((s) => s.name).join(' ');
      sb.writeln('${dz[zhi]}宫（$gongName）：');
      if (main.isNotEmpty) sb.writeln('  主星：$main');
      if (aus.isNotEmpty) sb.writeln('  吉星：$aus');
      if (mal.isNotEmpty) sb.writeln('  煞星：$mal');
      if (bos.isNotEmpty) sb.writeln('  博士：$bos');
      if (sha.isNotEmpty) sb.writeln('  神煞：$sha');
    }
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }
}
