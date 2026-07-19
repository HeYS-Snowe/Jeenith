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

    // box 内层 SizedBox(width: double.infinity)：根治 Transform.scale 在 Row/Expanded
    // 中阻断 intrinsic 宽度导致按钮坍塌为竖线（v2.3.1 仅修小六壬，此处根治所有用法）。
    // 所有调用点均在 tight 宽度环境（Column stretch / Expanded / SizedBox 固定宽），
    // double.infinity 在 bounded tight 下取最大宽度，撑满。
    final expandedBox = SizedBox(width: double.infinity, child: box);

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

    // 手势：Listener 处理 pointer down/up（缩放），立即响应、不参与 gesture arena，
    // 绕过 DraggableScrollableSheet 等滚动容器的 tap-vs-scroll 竞争（旧实现 onTapDown
    // 被 arena 延迟，表现为"多按才有缩放"）；onTap 处理功能触发。
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        if (!enabled || !animEnabled || widget.onPressed == null) return;
        setState(() => _down = true);
        _press.forward();
      },
      onPointerUp: (_) {
        if (!animEnabled) return;
        setState(() => _down = false);
        _press.reverse();
      },
      onPointerCancel: (_) {
        if (!animEnabled) return;
        setState(() => _down = false);
        _press.reverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: enabled ? widget.onPressed : null,
        child: inner,
      ),
    );
  }
}
