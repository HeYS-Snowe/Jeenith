// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// 金边半透明深底面板容器。
class DecorativePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const DecorativePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: const Color.fromRGBO(212, 168, 87, 0.24)),
        ),
        padding: padding,
        child: child,
      );
}
