// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/config_providers.dart';
import '../../core/theme/animations.dart';
import '../../core/theme/app_theme.dart';

/// 鎏金主按钮（主题感知）。
///
/// v2.0.0 升级：按动 0.95 缩放 + 阴影变化，抬起用 [AppAnimations.pressReleaseCurve]
/// （[Curves.easeOutBack] 变体）弹回——模拟物理弹性，质感来自曲线而非饱和度。
///
/// **v2.10.1 竖线坍塌"根治"修正**（继 v2.3.1/v2.7.1/v2.10.0 后第四次）：
/// v2.10.0 用 `ConstrainedBox(minWidth:88, maxWidth:inf) + SizedBox(width:inf)` 双层嵌套，
/// 反而在 loose(maxWidth=W) 场景下让内层 SizedBox.size=inf，外层 ConstrainedBox.size=
/// clamp(inf, 0, W)=W，按钮被强制撑满整个剩余宽度，导致 Row 后续按钮无空间而消失
/// （周易 _buildActionBar 所有按钮消失 / 小六壬 DarkButton 在 Wrap 中失去宽度约束）。
/// 本次简化：仅保留 `ConstrainedBox(minWidth:88)`，去掉 `maxWidth:inf` 和 `SizedBox(width:inf)`。
/// - tight(W) 下：enforce 后 tight(W)，撑满 W（Expanded / SizedBox(width:88) 包裹场景）
/// - loose(maxWidth=W) 下：enforce 后 (minWidth:88, maxWidth=W)，box 按 intrinsic 测量，
///   minWidth 兜底（DarkButton 在 Wrap 中保持 intrinsic 宽度）
/// - loose unbounded(maxWidth=inf) 下：enforce 后 (minWidth:88, maxWidth:inf)，
///   box 按 intrinsic 测量，minWidth 兜底（SliverPersistentHeader 中不再坍塌为竖线）
/// 详见频发 BUG 文档 `docs/频发BUG/GoldButton竖线坍塌.md`。
///
/// **v2.10.0 主题感知**：颜色全部从 `AppClr.of(context)` 取，浅色模式下自动切换
/// 为深鎏金（保证对比度），深色模式下保持原黑金。
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
    _animEnabled =
        ref.watch(configProvider).valueOrNull?.animationsEnabled ?? true;
    final enabled = widget.onPressed != null;
    final animEnabled = _animEnabled;
    final c = AppClr.of(context);
    // 主题感知色板：浅色取深鎏金（保证对比度），深色取原鎏金
    final labelColor = c.resolve(const Color(0xFF1A1208), const Color(0xFFF6F0E2));
    final gradTop = enabled
        ? c.resolve(const Color(0xFFF0D488), const Color(0xFFB89534))
        : c.resolve(const Color(0xFF6E5C36), const Color(0xFF8A7A55));
    final gradBottom = enabled
        ? c.resolve(const Color(0xFFD4A857), const Color(0xFF9B7A2A))
        : c.resolve(const Color(0xFF5A4A2A), const Color(0xFF6B5A3A));
    final borderColor = enabled
        ? c.resolve(const Color(0xFFE8C87A), const Color(0xFF8A6A1E))
        : c.resolve(const Color(0xFF4A3E26), const Color(0xFF6B5A3A));
    final glowColor = c.gold;

    final label = Text(
      widget.text,
      style: TextStyle(
        color: labelColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    final child = widget.icon == null
        ? label
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: labelColor, size: 18),
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
                  color: glowColor.withValues(alpha: 0.22),
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: child),
    );

    // ★ v2.10.1 竖线坍塌修复修正（继 v2.3.1/v2.7.1/v2.10.0 后第四次）：
    // 仅保留 ConstrainedBox(minWidth:88)，去掉 v2.10.0 错误的 maxWidth:inf + SizedBox(width:inf)
    // 双层嵌套。后者在 loose(maxWidth=W) 下会让内层 SizedBox.size=inf，外层
    // ConstrainedBox.size=clamp(inf,0,W)=W，强制撑满剩余宽度，致 Row 后续按钮无空间。
    // 现在：
    // - tight(W) 下 enforce → tight(W)，撑满 W（Expanded / SizedBox(width:88) 包裹场景）
    // - loose(maxWidth=W) 下 enforce → (minWidth:88, maxWidth:W)，box 按 intrinsic 测量，
    //   minWidth 兜底（DarkButton 在 Wrap 中保持 intrinsic 宽度）
    // - loose unbounded(maxWidth=inf) 下 enforce → (minWidth:88, maxWidth:inf)，
    //   box 按 intrinsic 测量，minWidth 兜底（SliverPersistentHeader 中不再坍塌为竖线）
    // 详见 docs/频发BUG/GoldButton竖线坍塌.md
    final expandedBox = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 88),
      child: box,
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
