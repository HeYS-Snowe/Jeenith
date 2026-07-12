// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 统一的 SVG 矢量图标组件：从 `assets/icons/$name.svg` 加载并按 [color] 染色。
///
/// 新增图标只需把 `.svg` 文件丢进 `assets/icons/` 目录，再用 `SvgIcon('名称')` 引用，
/// 无需改动本组件——扩展成本为零。
///
/// 默认尺寸/颜色取自 [IconTheme]，因此可像内置 [Icon] 一样被父级（如按钮）统一控色。
class SvgIcon extends StatelessWidget {
  final String name;
  final double? size;
  final Color? color;
  const SvgIcon(this.name, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final s = size ?? theme.size ?? 24;
    final c = color ?? theme.color ?? const Color(0xFFF0E6CF);
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: s,
      height: s,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
  }
}
