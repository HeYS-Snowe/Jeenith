// Copyright (c) 2026 Qore
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Divination-themed loading indicator.
///
/// Replaces the default [CircularProgressIndicator] with a Chinese-style
/// spinning hexagram ring + central trigram + gold glow breathing.
///
/// v2.2.0: designed for use during random.org fetch, history export,
/// share-image generation, etc.
class DivinationLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const DivinationLoadingIndicator({
    super.key,
    this.size = 48.0,
    this.color,
  });

  @override
  State<DivinationLoadingIndicator> createState() =>
      _DivinationLoadingIndicatorState();
}

class _DivinationLoadingIndicatorState extends State<DivinationLoadingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _spin;
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spin.dispose();
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.gold;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_spin, _breath]),
        builder: (context, _) {
          return CustomPaint(
            painter: _LoadingPainter(
              spin: _spin.value,
              breath: _breath.value,
              color: color,
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final double spin;
  final double breath;
  final Color color;

  _LoadingPainter({
    required this.spin,
    required this.breath,
    required this.color,
  });

  @override
  bool shouldRepaint(covariant _LoadingPainter old) =>
      old.spin != spin || old.breath != breath;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final R = math.min(size.width, size.height) * 0.46;

    // 1. Breathing halo (radial glow)
    final haloAlpha = (0.15 + breath * 0.25).clamp(0.0, 1.0);
    final haloR = R * (1.0 + breath * 0.15);
    canvas.drawCircle(
      Offset(cx, cy),
      haloR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: haloAlpha),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: haloR)),
    );

    // 2. Spinning hexagram ring (six short arcs)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(spin * 2 * math.pi);
    for (var i = 0; i < 6; i++) {
      final a0 = i * math.pi / 3;
      final a1 = a0 + math.pi / 6;
      final rect = Rect.fromCircle(center: Offset.zero, radius: R);
      // Alternate alpha so the ring looks like a moving dashed circle
      final alpha = 0.35 + 0.4 * ((i + 1) / 6);
      canvas.drawArc(
        rect,
        a0,
        a1 - a0,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withValues(alpha: alpha)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();

    // 3. Counter-rotating inner trigram ring (8 dots)
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-spin * 2 * math.pi * 1.5);
    final innerR = R * 0.62;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final px = innerR * math.cos(a);
      final py = innerR * math.sin(a);
      canvas.drawCircle(
        Offset(px, py),
        1.6,
        Paint()..color = AppColors.goldBright.withValues(alpha: 0.55),
      );
    }
    canvas.restore();

    // 4. Central pulsing dot
    final pulseR = 3.0 + breath * 1.5;
    canvas.drawCircle(
      Offset(cx, cy),
      pulseR,
      Paint()..color = AppColors.goldBright,
    );
  }
}
