// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

import '../../core/config/platform_info.dart';
import '../../core/theme/app_theme.dart';

/// 可 hover 的图标按钮（v2.3.1 Phase 5）。
///
/// 桌面端 hover 时：图标旋转 5° + 颜色变金（鎏金 #D4A857），200ms。
/// 按下时：scale 0.9 + 反弹，150ms。
/// 移动端：保持原生 IconButton 行为，无 hover。
///
/// 适用于首页的「历史」「使用手册」「设置」按钮等。
class HoverableIconButton extends StatefulWidget {
  final Widget icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? hoverColor;

  const HoverableIconButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.size = 24,
    this.color,
    this.hoverColor,
  });

  @override
  State<HoverableIconButton> createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<HoverableIconButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final baseColor = widget.color ?? AppColors.textSubtitle;
    final hoverColor = widget.hoverColor ?? AppColors.gold;
    final isDesktop = PlatformInfo.isDesktop;

    // 计算当前颜色：hover 时变金
    final currentColor = _hover && enabled ? hoverColor : baseColor;
    // 计算 rotation：hover 时旋转 5° (0.0872 rad)
    final rotation = _hover && isDesktop && enabled ? 0.0872 : 0.0;
    // 计算 scale：按下时 0.9
    final scale = _pressed ? 0.9 : 1.0;

    final content = GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              if (!mounted) return;
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () {
        if (!mounted) return;
        setState(() => _pressed = false);
      },
      child: AnimatedRotation(
        turns: rotation / (2 * 3.141592653589793),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(color: currentColor),
            child: IconTheme(
              data: IconThemeData(color: currentColor, size: widget.size),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );

    // 桌面端包裹 MouseRegion 提供 hover
    final withHover = isDesktop
        ? MouseRegion(
            onEnter: enabled ? (_) => setState(() => _hover = true) : null,
            onExit: (_) => setState(() => _hover = false),
            cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
            child: content,
          )
        : content;

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: withHover);
    }
    return withHover;
  }
}
