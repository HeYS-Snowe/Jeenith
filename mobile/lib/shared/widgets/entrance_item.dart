// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

/// 入场子项：按 [interval] 从 [animation] 取进度，做淡入 + 上浮。
///
/// 用于结果区/列表的错落入场。各处复用同一个 [animation] 控制器即可联动，
/// 调用方只需为每项指定不同的 [interval] 错开时序。
class EntranceItem extends StatelessWidget {
  final Animation<double> animation;
  final Interval interval;
  final double slide; // 上浮像素
  final Widget child;

  const EntranceItem({
    super.key,
    required this.animation,
    required this.interval,
    this.slide = 20,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final raw = interval.transform(animation.value).clamp(0.0, 1.0);
          final t = Curves.easeOutCubic.transform(raw);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * slide),
              child: child,
            ),
          );
        },
      );
}
