// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/config_providers.dart';
import '../../core/theme/animations.dart';
import '../../core/theme/app_theme.dart';

/// 深色次要按钮（主题感知），可选前置图标（接受任意 Widget：[Icon] / [SvgIcon] / [Image]）。
///
/// v2.0.0 升级：与 [GoldButton] 同款按动 0.95 缩放 + 阴影变化 + 抬起 easeOutBack 弹回。
///
/// **v2.10.0 双重升级**：
/// 1. **主题感知**：浅色模式下改为浅米渐变 + 深鎏金描边，不再保留深色块。
/// 2. **竖线坍塌防御**：与 GoldButton 同款加 `ConstrainedBox(minWidth: 72)`
///    兜底，防止 Transform.scale 阻断 intrinsic 导致坍塌。
///
/// 内部自动读 [AppConfig.animationsEnabled]，开关关闭时降级为静态按钮。
class DarkButton extends ConsumerStatefulWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double radius;

  const DarkButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.radius = 10,
  });

  @override
  ConsumerState<DarkButton> createState() => _DarkButtonState();
}

class _DarkButtonState extends ConsumerState<DarkButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  bool _down = false;
  bool _animEnabled = true;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppAnimations.pressDown),
      reverseDuration: const Duration(milliseconds: AppAnimations.pressRelease),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!_animEnabled || widget.onPressed == null) return;
    setState(() => _down = true);
    _press.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (!_animEnabled) {
      widget.onPressed?.call();
      return;
    }
    setState(() => _down = false);
    _press.reverse().then((_) {
      if (mounted) widget.onPressed?.call();
    });
  }

  void _onTapCancel() {
    if (!_animEnabled) return;
    setState(() => _down = false);
    _press.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _animEnabled =
        ref.watch(configProvider).valueOrNull?.animationsEnabled ?? true;
    final enabled = widget.onPressed != null;
    final animEnabled = _animEnabled;
    final c = AppClr.of(context);
    // 主题感知色板
    // 深色：紫黑渐变 + 鎏金描边（原配色）
    // 浅色：浅米渐变 + 深鎏金描边（与浅色背景协调，不留深色块）
    final labelColor = c.resolve(const Color(0xFFF0E6CF), const Color(0xFF2E2210));
    final gradTop = enabled
        ? c.resolve(const Color(0xFF3A2F4A), const Color(0xFFEBE2CC))
        : c.resolve(const Color(0xFF2A2235), const Color(0xFFD9CBA8));
    final gradBottom = enabled
        ? c.resolve(const Color(0xFF241C30), const Color(0xFFD9CBA8))
        : c.resolve(const Color(0xFF1A1525), const Color(0xFFC9BB98));
    final borderAlpha = enabled ? 0.43 : 0.18;
    final borderColor = c.goldBorder.withValues(alpha: borderAlpha);

    final label = Text(
      widget.text,
      style: TextStyle(
        color: labelColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
    final innerContent = widget.icon == null
        ? label
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme.merge(
                data: IconThemeData(size: 16, color: labelColor),
                child: widget.icon!,
              ),
              const SizedBox(width: 6),
              label,
            ],
          );

    final box = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradTop, gradBottom],
        ),
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: borderColor),
        boxShadow: _down
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: innerContent),
    );

    // ★ v2.10.0 竖线坍塌防御（与 GoldButton 同款方案）：
    // minWidth 兜底防止 Transform.scale 阻断 intrinsic 导致坍塌
    final expandedBox = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 72, maxWidth: double.infinity),
      child: SizedBox(width: double.infinity, child: box),
    );

    final inner = animEnabled
        ? AnimatedBuilder(
            animation: _press,
            builder: (context, _) {
              final t = _press.value;
              final downCurve = AppAnimations.pressDownCurve.transform(t);
              final upCurve = AppAnimations.pressReleaseCurve.transform(1 - t);
              final scale = _down ? 1.0 - 0.05 * downCurve : 0.95 + 0.05 * upCurve;
              return Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: expandedBox,
              );
            },
          )
        : expandedBox;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: inner,
    );
  }
}
