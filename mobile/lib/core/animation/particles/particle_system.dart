// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 粒子爆发动画组件。
///
/// 在 [center] 位置生成 [count] 个粒子，向外辐射扩散并淡出。
/// 用于仪式动画中的中心爆光、星曜降落光尾等场景。
///
/// 用法：
/// ```dart
/// ParticleBurst(
///   center: Offset(cx, cy),
///   count: 24,
///   color: AppColors.gold,
///   maxRadius: 120,
///   duration: const Duration(milliseconds: 800),
/// )
/// ```
class ParticleBurst extends StatefulWidget {
  /// 爆发中心点（相对于自身坐标系）。
  final Offset center;

  /// 粒子数量。
  final int count;

  /// 粒子颜色。
  final Color color;

  /// 最大辐射半径。
  final double maxRadius;

  /// 动画时长。
  final Duration duration;

  /// 粒子大小范围 [minSize, maxSize]。
  final double minSize;
  final double maxSize;

  /// 是否自动播放（false 时需手动调用 controller.forward）。
  final bool autoStart;

  /// 动画完成回调。
  final VoidCallback? onComplete;

  const ParticleBurst({
    super.key,
    required this.center,
    this.count = 20,
    this.color = AppColors.gold,
    this.maxRadius = 100,
    this.duration = const Duration(milliseconds: 800),
    this.minSize = 2,
    this.maxSize = 5,
    this.autoStart = true,
    this.onComplete,
  });

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _particles = _generateParticles();
    if (widget.autoStart) {
      _ctrl.forward().then((_) => widget.onComplete?.call());
    }
  }

  List<_Particle> _generateParticles() {
    final rng = math.Random();
    return List.generate(widget.count, (_) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final speed = 0.4 + rng.nextDouble() * 0.6; // 0.4..1.0
      return _Particle(
        angle: angle,
        speed: speed,
        size:
            widget.minSize +
            rng.nextDouble() * (widget.maxSize - widget.minSize),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => CustomPaint(
        painter: _ParticlePainter(
          particles: _particles,
          progress: _ctrl.value,
          center: widget.center,
          maxRadius: widget.maxRadius,
          color: widget.color,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  _Particle({required this.angle, required this.speed, required this.size});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Offset center;
  final double maxRadius;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
    required this.maxRadius,
    required this.color,
  });

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final fadeOut = 1.0 - progress; // 1→0
    for (final p in particles) {
      final dist = maxRadius * p.speed * progress;
      final dx = center.dx + dist * math.cos(p.angle);
      final dy = center.dy + dist * math.sin(p.angle);
      final alpha = fadeOut * p.speed; // 远处粒子淡得更快
      final r = p.size * (1 - progress * 0.3); // 略缩

      canvas.drawCircle(
        Offset(dx, dy),
        r,
        Paint()
          ..shader =
              RadialGradient(
                colors: [
                  color.withValues(alpha: alpha),
                  color.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCircle(center: Offset(dx, dy), radius: r * 2),
              ),
      );
    }
  }
}

/// 金光线段——用于星曜降落时的光尾效果。
///
/// 在 [start] 到 [end] 之间画一条带渐变淡出的线，随 [progress] 从 0→1 延伸。
class LightTrail extends StatelessWidget {
  final Offset start;
  final Offset end;
  final double progress;
  final Color color;
  final double width;

  const LightTrail({
    super.key,
    required this.start,
    required this.end,
    required this.progress,
    this.color = AppColors.gold,
    this.width = 2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LightTrailPainter(
        start: start,
        end: end,
        progress: progress,
        color: color,
        width: width,
      ),
      size: Size.infinite,
    );
  }
}

class _LightTrailPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double progress;
  final Color color;
  final double width;

  _LightTrailPainter({
    required this.start,
    required this.end,
    required this.progress,
    required this.color,
    required this.width,
  });

  @override
  bool shouldRepaint(covariant _LightTrailPainter old) =>
      old.progress != progress;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0);
    if (p <= 0) return;

    final current = Offset(
      start.dx + (end.dx - start.dx) * p,
      start.dy + (end.dy - start.dy) * p,
    );

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(current.dx, current.dy);
    final rect = path.getBounds();
    // Guard against zero-size rect (vertical/horizontal line).
    final w = rect.width == 0 ? 1.0 : rect.width;
    final h = rect.height == 0 ? 1.0 : rect.height;
    final gradient = LinearGradient(
      begin: Alignment(
        ((start.dx - rect.left) / w) * 2 - 1,
        ((start.dy - rect.top) / h) * 2 - 1,
      ),
      end: Alignment(
        ((current.dx - rect.left) / w) * 2 - 1,
        ((current.dy - rect.top) / h) * 2 - 1,
      ),
      colors: [
        color.withValues(alpha: 0),
        color.withValues(alpha: 0.4),
        color.withValues(alpha: 0.8),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }
}
