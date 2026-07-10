// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../algorithm/divine.dart';
import '../data/palaces.dart';

/// 六宫圆形掐指盘，支持游走点亮动画（移植自 Python DivinationWheel）。
class DivinationWheel extends StatefulWidget {
  final void Function()? onDone;
  const DivinationWheel({super.key, this.onDone});

  @override
  State<DivinationWheel> createState() => DivinationWheelState();
}

class DivinationWheelState extends State<DivinationWheel> {
  static const double _radiusRatio = 0.40;
  static const int _stepDelay = 3;   // 50ms * 3 = 150ms / 步
  static const int _pauseDelay = 7;  // 落点停顿

  int cursor = -1;
  final Set<int> lit = {};
  List<int> resultLands = [];
  List<int> path = [];
  Set<int> landPositions = {};
  int walkI = 0;
  int stepCounter = 0;
  int pulse = 0;
  Timer? _timer;

  void start(List<int> nums) {
    final d = divine(nums);
    path = d.path;
    resultLands = d.lands;
    landPositions = d.landPositions.toSet();
    walkI = 0;
    stepCounter = 0;
    lit.clear();
    cursor = path.isEmpty ? -1 : path.first;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) => _tick());
    setState(() {});
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    cursor = -1;
    lit.clear();
    resultLands = [];
    path = [];
    landPositions = {};
    walkI = 0;
    setState(() {});
  }

  void _tick() {
    pulse++;
    if (walkI < path.length) {
      stepCounter++;
      final need = landPositions.contains(walkI) ? _pauseDelay : _stepDelay;
      if (stepCounter >= need) {
        stepCounter = 0;
        if (landPositions.contains(walkI)) lit.add(path[walkI]);
        walkI++;
        if (walkI < path.length) {
          cursor = path[walkI];
        } else {
          cursor = resultLands.isEmpty ? -1 : resultLands.last;
          _timer?.cancel();
          _timer = null;
          widget.onDone?.call();
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _WheelPainter(this), child: const SizedBox.expand());
}

class _WheelPainter extends CustomPainter {
  final DivinationWheelState s;
  _WheelPainter(this.s);

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h / 2;
    final R = math.min(w, h) * DivinationWheelState._radiusRatio;
    final breath = 0.5 + 0.5 * math.sin(s.pulse * 0.12);

    // —— 背景径向渐变 ——
    final bgRect = Rect.fromCircle(center: Offset(cx, cy), radius: math.max(w, h) * 0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      Paint()
        ..shader = const RadialGradient(colors: [
          Color(0xFF1B1626), Color(0xFF120F1A), Color(0xFF0A0810),
        ]).createShader(bgRect),
    );

    // —— 外装饰金环 ——
    for (final r in [R + 70, R + 52, R + 38]) {
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = const Color.fromRGBO(212, 168, 87, 0.15)
          ..strokeWidth = 1,
      );
    }

    // —— 刻度（外环 48）——
    canvas.save();
    canvas.translate(cx, cy);
    for (var k = 0; k < 48; k++) {
      canvas.rotate(2 * math.pi / 48);
      final major = k % 4 == 0;
      canvas.drawLine(
        Offset(R + 60, 0),
        Offset(R + (major ? 52 : 56), 0),
        Paint()
          ..color = Color.fromRGBO(212, 168, 87, major ? 0.35 : 0.16)
          ..strokeWidth = major ? 2 : 1,
      );
    }
    canvas.restore();

    // —— 连接环（淡金虚线圆，用点近似）——
    canvas.drawCircle(
      Offset(cx, cy),
      R,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color.fromRGBO(212, 168, 87, 0.22)
        ..strokeWidth = 1.5,
    );

    // —— 中心太极 ——
    _drawTaiji(canvas, Offset(cx, cy), R * 0.34);

    // —— 六宫节点 ——
    for (var i = 0; i < 6; i++) {
      final ang = -math.pi / 2 + (2 * math.pi / 6) * i;
      final pos = Offset(cx + R * math.cos(ang), cy + R * math.sin(ang));
      final info = palaces[i];
      final isLit = s.lit.contains(i);
      final isCursor = i == s.cursor;
      double baseR = R * 0.20, r = baseR;
      if (isLit) {
        r = baseR * 1.16;
      } else if (isCursor) {
        r = baseR * (1.05 + 0.05 * breath);
      }

      // 光环
      if (isLit || isCursor) {
        final glowR = r + 22 + 8 * breath;
        canvas.drawCircle(
          pos,
          glowR,
          Paint()
            ..shader = RadialGradient(colors: [
              info.glow.withValues(alpha: isLit ? 0.62 : 0.43),
              info.glow.withValues(alpha: 0),
            ]).createShader(Rect.fromCircle(center: pos, radius: glowR)),
        );
      }

      // 节点渐变填充
      canvas.drawCircle(
        pos,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              isLit ? info.glow : AppColors.darker(info.color, 0.85),
              AppColors.darker(info.color, isLit ? 0.55 : 0.32),
            ],
          ).createShader(Rect.fromCircle(center: pos, radius: r)),
      );
      canvas.drawCircle(
        pos,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = isLit ? info.glow : const Color.fromRGBO(212, 168, 87, 0.47)
          ..strokeWidth = isLit ? 2.2 : 1.4,
      );

      // 宫名 + 五行方位
      _drawText(
        canvas,
        info.name,
        pos + Offset(0, -r * 0.2),
        TextStyle(
          color: isLit ? const Color(0xFFFDF6E3) : const Color(0xFFF0E6CF),
          fontSize: r * 0.46,
          fontWeight: FontWeight.bold,
        ),
      );
      _drawText(
        canvas,
        '${info.wuxing}·${info.fangwei}',
        pos + Offset(0, r * 0.32),
        TextStyle(
          color: const Color.fromRGBO(232, 217, 176, 0.78),
          fontSize: math.max(7.0, r * 0.22),
        ),
      );
    }

    // —— 游走指针 ——
    if (s.cursor != -1) {
      final ang = -math.pi / 2 + (2 * math.pi / 6) * s.cursor;
      final cpos = Offset(cx + R * math.cos(ang), cy + R * math.sin(ang));
      canvas.drawCircle(
        Offset(cx, cy),
        4,
        Paint()..color = const Color(0xFFFFE6A0),
      );
      canvas.drawLine(
        Offset(cx, cy),
        cpos,
        Paint()
          ..color = const Color.fromRGBO(255, 215, 130, 0.55)
          ..strokeWidth = 2,
      );
      canvas.drawCircle(cpos, 5, Paint()..color = const Color(0xFFFFE6A0));
    }
  }

  void _drawText(Canvas canvas, String text, Offset pos, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  /// 太极图（叠加法，与 Python 修复版一致）。
  void _drawTaiji(Canvas canvas, Offset center, double r) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(s.pulse * 0.6 * math.pi / 180);

    const white = Color.fromRGBO(238, 230, 205, 0.94);
    const black = Color.fromRGBO(20, 16, 28, 0.92);
    final rect = Rect.fromCircle(center: Offset.zero, radius: r);

    // 整圆白底
    canvas.drawCircle(Offset.zero, r, Paint()..color = white);
    // 右半圆黑
    final half = Path()
      ..moveTo(0, -r)
      ..arcTo(rect, -math.pi / 2, math.pi, false)
      ..close();
    canvas.drawPath(half, Paint()..color = black);
    // 上小圆白 / 下小圆黑（构成 S 形）
    canvas.drawCircle(Offset(0, -r / 2), r / 2, Paint()..color = white);
    canvas.drawCircle(Offset(0, r / 2), r / 2, Paint()..color = black);
    // 鱼眼
    canvas.drawCircle(Offset(0, -r / 2), r * 0.14, Paint()..color = const Color.fromRGBO(20, 16, 28, 1));
    canvas.drawCircle(Offset(0, r / 2), r * 0.14, Paint()..color = const Color.fromRGBO(238, 230, 205, 1));

    canvas.restore();
  }
}
