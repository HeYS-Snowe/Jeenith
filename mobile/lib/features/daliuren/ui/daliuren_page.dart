// Copyright (c) 2026 Qore. All rights reserved.
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
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';

class DaliurenPage extends ConsumerStatefulWidget {
  const DaliurenPage({super.key});
  @override
  ConsumerState<DaliurenPage> createState() => _DaliurenPageState();
}

class _DaliurenPageState extends ConsumerState<DaliurenPage> {
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _hour = TextEditingController();
  DaliurenResult? _r;
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year.text = now.year.toString();
    _month.text = now.month.toString();
    _day.text = now.day.toString();
    _hour.text = now.hour.toString();
  }

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
    if (y < 1900 || y > 2100 || m < 1 || m > 12 || d < 1 || d > 31 || h < 0 || h > 23) {
      return;
    }
    setState(() => _r = divine(y, m, d, h));
    FocusScope.of(context).unfocus();
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'daliuren',
      techName: '大六壬',
      time: DateTime.now(),
      summary: _r == null ? '' : '${_r!.zongMen} ${_r!.sanChuan.first.shen}传',
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
            Text('大六壬', style: TextStyle(fontSize: 18)),
            Text('三 传 四 课',
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
                GoldButton(text: '起课', onPressed: _onDivine),
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

  String _buildCopyText() {
    final r = _r;
    if (r == null) return '';
    final sb = StringBuffer('【大六壬 · 三传四课】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln(r.lunarDisplay);
    sb.writeln('日柱：${r.dayGanZhi}  时柱：${r.timeGanZhi}');
    sb.writeln('月将：${r.yueJiang}  贵人：${r.guiRenType == "day" ? "昼贵" : "夜贵"}（${r.guiRenZhi}）');
    sb.writeln('九宗门：${r.zongMen}');
    sb.writeln('\n—— 四课 ——');
    final labels = ['一课', '二课', '三课', '四课'];
    for (var i = 0; i < 4; i++) {
      sb.writeln('${labels[i]}：上神 ${r.siKe[i].top}  下神 ${r.siKe[i].bottom}');
    }
    sb.writeln('\n—— 三传 ——');
    final chuanLabels = ['初传', '中传', '末传'];
    for (var i = 0; i < 3; i++) {
      sb.writeln('${chuanLabels[i]}：${r.sanChuan[i].shen}（${r.sanChuan[i].tianJiang}）');
    }
    sb.writeln('\n—— 天盘 ——');
    for (var i = 0; i < 12; i++) {
      sb.writeln('地${r.diPan[i]} → 天${r.tianPan[i]}  （${r.tianJiangOnTian[i]}）');
    }
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _buildResult(DaliurenResult r) {
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('daliuren', AnimationKind.reveal) ??
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
            const SizedBox(height: 6),
            Text('日柱 ${r.dayGanZhi}  ·  时柱 ${r.timeGanZhi}',
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildChip('月将', r.yueJiang, AppColors.goldBright),
                _buildChip('宗门', r.zongMen, AppColors.fireGlow),
                _buildChip(r.guiRenType == 'day' ? '昼贵' : '夜贵',
                    r.guiRenZhi, AppColors.woodGlow),
              ],
            ),
          ],
        ),
      ),
      sections: [
        const Text('◆ 四课',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(child: _buildKeCell(i + 1, r.siKe[i])),
                if (i < 3) const SizedBox(width: 6),
              ]
            ],
          ),
        ),
        const Text('◆ 三传',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                Expanded(child: _buildChuanCell(i, r.sanChuan[i])),
                if (i < 2) const SizedBox(width: 6),
              ]
            ],
          ),
        ),
        const Text('◆ 天盘加临图',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(8),
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _TianPanPainter(r: r),
              size: Size.infinite,
            ),
          ),
        ),
        const Text('◆ 十二天将加临',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < 12; i++)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgInner.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: const Color.fromRGBO(212, 168, 87, 0.15)),
                  ),
                  child: Text(
                    '${r.diPan[i]}:${r.tianJiangOnTian[i]}',
                    style: const TextStyle(
                        color: AppColors.waterDeepGlow, fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.goldBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMeta, fontSize: 11)),
          const SizedBox(width: 4),
          Text(value,
              style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildKeCell(int index, Ke ke) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.bgInner.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.25)),
      ),
      child: Column(
        children: [
          Text('$index 课',
              style: const TextStyle(color: AppColors.textMeta, fontSize: 10)),
          const SizedBox(height: 4),
          Text(ke.top,
              style: const TextStyle(
                  color: AppColors.goldBright, fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(height: 6, color: Color.fromRGBO(212, 168, 87, 0.3)),
          Text(ke.bottom,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildChuanCell(int index, Chuan chuan) {
    final labels = ['初传', '中传', '末传'];
    final colors = [AppColors.fireGlow, AppColors.goldBright, AppColors.waterDeepGlow];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.bgInner.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors[index].withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        children: [
          Text(labels[index],
              style: const TextStyle(color: AppColors.textMeta, fontSize: 11)),
          const SizedBox(height: 6),
          Text(chuan.shen,
              style: TextStyle(
                  color: colors[index], fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(chuan.tianJiang,
              style: const TextStyle(color: AppColors.textBody, fontSize: 11)),
        ],
      ),
    );
  }
}

/// 天盘 12 支环形图：外圈地盘固定，内圈天盘旋转，天将标于天盘位。
class _TianPanPainter extends CustomPainter {
  final DaliurenResult r;
  _TianPanPainter({required this.r});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width * 0.46;
    final diR = size.width * 0.40;
    final tianR = size.width * 0.30;
    final innerR = size.width * 0.18;

    // 同心圆
    final ringPaint = Paint()
      ..color = AppColors.goldBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, outerR, ringPaint);
    canvas.drawCircle(center, diR, ringPaint);
    canvas.drawCircle(center, tianR, ringPaint);
    canvas.drawCircle(center, innerR, ringPaint);

    // 12 等分放射线
    final linePaint = Paint()
      ..color = const Color.fromRGBO(212, 168, 87, 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final x1 = center.dx + outerR * math.cos(angle);
      final y1 = center.dy + outerR * math.sin(angle);
      final x2 = center.dx + innerR * math.cos(angle);
      final y2 = center.dy + innerR * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    // 外圈：地盘 12 支（固定）
    final diTp = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final x = center.dx + (outerR + diR) / 2 * math.cos(angle);
      final y = center.dy + (outerR + diR) / 2 * math.sin(angle);
      diTp.text = TextSpan(
        text: r.diPan[i],
        style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
      );
      diTp.layout();
      diTp.paint(canvas, Offset(x - diTp.width / 2, y - diTp.height / 2));
    }
    diTp.dispose();

    // 内圈：天盘 12 支（旋转）
    final tianTp = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final x = center.dx + (tianR + innerR) / 2 * math.cos(angle);
      final y = center.dy + (tianR + innerR) / 2 * math.sin(angle);
      tianTp.text = TextSpan(
        text: r.tianPan[i],
        style: const TextStyle(
            color: AppColors.goldBright, fontSize: 12, fontWeight: FontWeight.bold),
      );
      tianTp.layout();
      tianTp.paint(canvas, Offset(x - tianTp.width / 2, y - tianTp.height / 2));
    }
    tianTp.dispose();

    // 中心：贵人
    final centerTp = TextPainter(textDirection: TextDirection.ltr);
    centerTp.text = TextSpan(
      text: '贵\n${r.guiRenZhi}',
      style: const TextStyle(color: AppColors.earthGlow, fontSize: 10, height: 1.4),
    );
    centerTp.layout();
    centerTp.paint(
        canvas, Offset(center.dx - centerTp.width / 2, center.dy - centerTp.height / 2));
    centerTp.dispose();

    // 顶部指针
    final pointerPaint = Paint()
      ..color = AppColors.fire
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(center.dx, center.dy - outerR - 8)
      ..lineTo(center.dx - 5, center.dy - outerR + 4)
      ..lineTo(center.dx + 5, center.dy - outerR + 4)
      ..close();
    canvas.drawPath(path, pointerPaint);
  }

  @override
  bool shouldRepaint(_TianPanPainter old) => r != old.r;
}
