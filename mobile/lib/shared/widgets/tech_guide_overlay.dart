// Copyright (c) 2026 Qore
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 引导步骤（小标题 + 正文）。
class GuideStep {
  final String title;
  final String body;
  const GuideStep(this.title, this.body);
}

/// 单个复杂术数的首次使用引导遮罩（v2.4.4）。
///
/// 与全局 [GuideDialog] 不同，本组件按术数 id 由调用方用 SharedPreferences
/// 控制只弹一次（key：`tech_guide_<id>`）。复用相同入场动画（背景模糊渐入 +
/// 卡片 scale 0.85→1.0 + easeOutBack，280ms）与 3 秒倒计时禁关。
class TechGuideOverlay extends StatefulWidget {
  final String title;
  final List<GuideStep> steps;
  final int countdownSec;

  const TechGuideOverlay({
    super.key,
    required this.title,
    required this.steps,
    this.countdownSec = 3,
  });

  @override
  State<TechGuideOverlay> createState() => _TechGuideOverlayState();
}

class _TechGuideOverlayState extends State<TechGuideOverlay>
    with SingleTickerProviderStateMixin {
  late int _count = widget.countdownSec;
  Timer? _t;
  late final AnimationController _enter;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _count--);
      if (_count <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppClr.of(context);
    final ready = _count <= 0;
    final enterCurve =
        CurvedAnimation(parent: _enter, curve: Curves.easeOutBack);
    return PopScope(
      canPop: ready,
      child: AnimatedBuilder(
        animation: _enter,
        builder: (context, _) {
          final blurT = Curves.easeOutCubic.transform(_enter.value);
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5 * blurT, sigmaY: 5 * blurT),
            child: Container(
              color: Colors.black.withValues(alpha: 0.4 * blurT),
              child: Center(
                child: Transform.scale(
                  scale: 0.85 + 0.15 * enterCurve.value,
                  child: Opacity(
                    opacity: _enter.value.clamp(0.0, 1.0),
                    child: AlertDialog(
                      backgroundColor: c.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: c.goldBorder),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.menu_book, color: c.goldBright, size: 20),
                          const SizedBox(width: 8),
                          Text(widget.title,
                              style: TextStyle(
                                  color: c.goldBright,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2)),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < widget.steps.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              _StepItem(step: widget.steps[i]),
                            ],
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: ready
                              ? () => Navigator.of(context).pop()
                              : null,
                          child: Text(
                            ready ? '我知道了' : '$_count s 后可关闭',
                            style: TextStyle(
                              color: ready ? c.gold : c.textHint,
                              fontWeight:
                                  ready ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final GuideStep step;
  const _StepItem({required this.step});
  @override
  Widget build(BuildContext context) {
    final c = AppClr.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(step.title,
            style: TextStyle(
                color: c.goldBright,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(step.body,
            style: TextStyle(color: c.textBody, fontSize: 13, height: 1.6)),
      ],
    );
  }
}
