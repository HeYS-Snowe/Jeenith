// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../algorithm/divine.dart';
import '../algorithm/star_placement.dart';
import '../data/stars.dart';

/// 紫微斗数环形命盘绘制器。
///
/// 12 宫按地支 0-11 索引（子..亥）排列：子位于底部（6 点钟方向），
/// 逆时针布列（丑→寅→卯...），与紫微斗数传统排盘一致。
class StarChartPainter extends CustomPainter {
  /// 命宫地支索引 0..11。
  final int mingGong;

  /// 身宫地支索引 0..11。
  final int shenGong;

  /// 按地支排列的宫名索引。
  final List<int> gongAtZhi;

  /// 命宫干支（如 "甲子"）。
  final String mingGanZhi;

  /// 五行局（如 "水二局"）。
  final String wuxingJu;

  /// 已排布的星曜分布。
  final StarChart chart;

  const StarChartPainter({
    required this.mingGong,
    required this.shenGong,
    required this.gongAtZhi,
    required this.mingGanZhi,
    required this.wuxingJu,
    required this.chart,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dz = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = math.min(size.width, size.height) / 2 * 0.96;
    final innerR = outerR * 0.34;
    final midR = (innerR + outerR) / 2;

    // === 12 宫扇形 ===
    for (var zhi = 0; zhi < 12; zhi++) {
      // 子位于底部（canvas 角度 π/2，因为 canvas Y 朝下），逆时针布列：zhi+1 在 zi 的逆时针方向（视觉左）
      final centerAngle = math.pi / 2 + zhi * math.pi / 6;
      final halfSweep = math.pi / 12;
      final startAngle = centerAngle - halfSweep;
      final sweep = math.pi / 6;

      final isMing = zhi == mingGong;
      final isShen = zhi == shenGong;

      // 扇形背景
      final path = Path()
        ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: outerR),
            startAngle, sweep)
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: innerR),
            startAngle + sweep, -sweep, false)
        ..close();

      final bgPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isMing
            ? AppColors.gold.withValues(alpha: 0.20)
            : (isShen
                ? AppColors.waterDeep.withValues(alpha: 0.20)
                : AppColors.card);
      canvas.drawPath(path, bgPaint);

      // 描边
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isMing || isShen ? 1.6 : 0.6
        ..color = isMing
            ? AppColors.gold
            : (isShen ? AppColors.waterDeepGlow : AppColors.goldBorder);
      canvas.drawPath(path, borderPaint);

      // Text anchor at the sector radial midpoint.
      final mx = cx + midR * math.cos(centerAngle);
      final my = cy + midR * math.sin(centerAngle);

      // Radial layout: translate to the anchor then rotate so the text stands
      // on the radius. After rotate(centerAngle - π/2), local +y points outward
      // (tail outward) and local -y points to the center (text head inward).
      // This is the standard Ziwei chart convention: all palace text faces the
      // center uniformly; the user rotates the chart to read each palace.
      canvas.save();
      canvas.translate(mx, my);
      canvas.rotate(centerAngle - math.pi / 2);

      // Earthly Branch (head, toward the center, innermost).
      _drawText(
        canvas,
        dz[zhi],
        const Offset(0, -24),
        color: isMing ? AppColors.goldBright : AppColors.textMeta,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      );

      // Palace name (just outside the Earthly Branch).
      final gongIdx = gongAtZhi[zhi];
      if (gongIdx >= 0 && gongIdx < palaceNames.length) {
        _drawText(
          canvas,
          palaceNames[gongIdx],
          const Offset(0, -9),
          color: isMing ? AppColors.gold : AppColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        );
      }

      // Stars (listed from the palace name outward).
      final stars = chart.gongStars[zhi];
      var y = 6.0;
      for (final star in stars) {
        final color = _categoryColor(star.category);
        final fontSize = star.category == StarCategory.main ? 10.5 : 8.5;
        _drawText(
          canvas,
          star.name,
          Offset(0, y),
          color: color,
          fontSize: fontSize,
        );
        y += fontSize + 2;
      }

      canvas.restore();
    }

    // === 内外环 ===
    final outerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.gold;
    canvas.drawCircle(Offset(cx, cy), outerR, outerRingPaint);

    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.goldBorder;
    canvas.drawCircle(Offset(cx, cy), innerR, innerRingPaint);

    // 中央圆背景
    final centerBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.bgInner;
    canvas.drawCircle(Offset(cx, cy), innerR - 1, centerBgPaint);

    // === 中央信息 ===
    // 太极圆点（顶部红、底部黑表示阴阳）
    final taijiR = innerR * 0.18;
    final taijiPaint = Paint()..color = AppColors.goldBright;
    canvas.drawCircle(Offset(cx, cy - innerR * 0.45), taijiR, taijiPaint);
    final taijiBgPaint = Paint()..color = AppColors.bgOuter;
    canvas.drawCircle(
        Offset(cx, cy - innerR * 0.45), taijiR * 0.55, taijiBgPaint);

    // 命宫干支
    _drawText(
      canvas,
      mingGanZhi,
      Offset(cx, cy),
      color: AppColors.goldBright,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    // 五行局
    _drawText(
      canvas,
      wuxingJu,
      Offset(cx, cy + innerR * 0.4),
      color: AppColors.fireGlow,
      fontSize: 11,
    );
  }

  Color _categoryColor(StarCategory cat) {
    switch (cat) {
      case StarCategory.main:
        return AppColors.goldBright;
      case StarCategory.auspicious:
        return AppColors.woodGlow;
      case StarCategory.malefic:
        return AppColors.fireGlow;
      case StarCategory.boshishen:
        return AppColors.textSubtitle;
      case StarCategory.shensha:
        return AppColors.earthGlow;
    }
  }

  /// 绘制居中文本，绘制后立即释放 TextPainter（项目硬约束）。
  void _drawText(
    Canvas canvas,
    String text,
    Offset center, {
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
    tp.dispose();
  }

  @override
  bool shouldRepaint(covariant StarChartPainter old) =>
      old.mingGong != mingGong ||
      old.shenGong != shenGong ||
      old.chart != chart ||
      old.mingGanZhi != mingGanZhi;
}
