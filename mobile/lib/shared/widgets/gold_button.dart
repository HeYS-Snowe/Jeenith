// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/config_providers.dart';
import '../../core/theme/animations.dart';

/// 鎏金主按钮。
///
/// v2.0.0 升级：按动 0.95 缩放 + 阴影变化，抬起用 [AppAnimations.pressReleaseCurve]
/// （[Curves.easeOutBack] 变体）弹回——模拟物理弹性，质感来自曲线而非饱和度。
/// 配色遵循 oklch 思路（黑金低饱和度），不引入光污染。
///
/// 内部自动读 [AppConfig.animationsEnabled]，开关关闭时降级为静态按钮。
class GoldButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double radius;

  const GoldButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.radius = 10,
  });

  @override
  ConsumerState<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends ConsumerState<GoldButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  bool _down = false;
  // 最近一次 build 时确定的动画开关，供 tap 回调安全读取（避免在非 build
  // 上下文调用 ref.watch）。在 build 中通过 ref.watch 订阅以即时重建。
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
    // 立即触发 onPressed，弹回动画与功能执行并行。
    // 旧实现用 _press.reverse().then(...) 等 260ms 弹回完成才回调，快速点击时
    // reverse 会被下一次 forward 中断，then 不触发，导致 onPressed 丢失、状态错乱
    // （表现为"按几下才有反应"）。改为并行后视觉缩放仍由 controller 驱动，体验一致。
    _press.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    if (!_animEnabled) return;
    setState(() => _down = false);
    _press.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // 订阅全局配置：设置页切换开关时即时重建，动画/静态形态无缝切换
    _animEnabled =
        ref.watch(configProvider).valueOrNull?.animationsEnabled ?? true;
    final enabled = widget.onPressed != null;
    final animEnabled = _animEnabled;
    final label = Text(
      widget.text,
      style: const TextStyle(
        color: Color(0xFF1A1208),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    final child = widget.icon == null
        ? label
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: const Color(0xFF1A1208), size: 18),
              const SizedBox(width: 6),
              label,
            ],
          );

    final box = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: enabled
              ? const [Color(0xFFF0D488), Color(0xFFD4A857)]
              : const [Color(0xFF6E5C36), Color(0xFF5A4A2A)],
        ),
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: enabled
              ? const Color(0xFFE8C87A)
              : const Color(0xFF4A3E26),
        ),
        boxShadow: _down
            ? [
                BoxShadow(
                  color: const Color(0xFFD4A857).withValues(alpha: 0.22),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: child),
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
                child: box,
              );
            },
          )
        : box;

    return GestureDetector(
      onTapDown: enabled ? _onTapDown : null,
      onTapUp: enabled ? _onTapUp : null,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: inner,
    );
  }
}
