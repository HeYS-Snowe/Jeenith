// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 可交互卡片：可选入场动画 + 按下缩放 / 光晕交互。
///
/// - **入场**：传入 [entrance] + [interval] 时按序淡入上浮；都不传则无入场。
/// - **交互**：按下缩放至 0.95 并增强边框 / 光晕（按 [color]），松开回弹。
///
/// 卡片内容（[child]）由调用方自定义——视觉因术而异，不在此共享。
class InteractableCard extends StatefulWidget {
  final Animation<double>? entrance;
  final Interval? interval;
  final Color color;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double radius;
  final Widget child;

  const InteractableCard({
    super.key,
    this.entrance,
    this.interval,
    required this.color,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.radius = 18,
    required this.child,
  });

  @override
  State<InteractableCard> createState() => _InteractableCardState();
}

class _InteractableCardState extends State<InteractableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // 内层：按下缩放 / 光晕 + 卡片内容（独立 final 变量，避免被入场闭包自引用）。
    final content = AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          if (!mounted) return;
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withValues(alpha: 0.22),
                AppColors.card,
              ],
            ),
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
                color:
                    widget.color.withValues(alpha: _pressed ? 0.85 : 0.5)),
            boxShadow: [
              BoxShadow(
                color:
                    widget.color.withValues(alpha: _pressed ? 0.42 : 0.14),
                blurRadius: _pressed ? 26 : 10,
                spreadRadius: _pressed ? 2 : 0,
              ),
            ],
          ),
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );

    // 可选叠加入场（淡入上浮）；引用不变的 content，杜绝闭包自引用。
    final entrance = widget.entrance;
    final interval = widget.interval;
    if (entrance != null && interval != null) {
      return AnimatedBuilder(
        animation: entrance,
        builder: (context, _) {
          final raw = interval.transform(entrance.value).clamp(0.0, 1.0);
          final t = Curves.easeOutCubic.transform(raw);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 24),
              child: content,
            ),
          );
        },
      );
    }
    return content;
  }
}
