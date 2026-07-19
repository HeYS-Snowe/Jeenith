// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';

/// 结果揭示动画统一封装。
///
/// 将多个结果段落按序揭示：
/// 1. 主图（[hero]）用墨晕开（[InkSpread]）显现
/// 2. 主标题（[title]）用打字机（[TypewriterText]）逐字显示
/// 3. 段落列表（[sections]）按序错峰淡入上浮（[StaggeredReveal]）
/// 4. 完成后回调 [onComplete]
///
/// 关闭动效（[enabled] = false）时，所有内容直接静态显示。
class RevealAnimation extends StatefulWidget {
  /// 主图：墨晕开揭示（如卦象、签诗主图）。可为 null 表示无主图。
  final Widget? hero;

  /// 主标题：打字机揭示（如「大安」「乾为天」）。可为 null。
  final String? title;

  /// 主标题样式。
  final TextStyle? titleStyle;

  /// 段落详情：错峰淡入上浮。每项一段。
  final List<Widget> sections;

  /// 段落错峰间隔。
  final Duration sectionStagger;

  /// 段落单条入场时长。
  final Duration sectionDuration;

  /// 段落之间的固定间距（不参与动画，仅做视觉分隔）。
  /// 0 表示不插入间距。
  final double sectionSpacing;

  /// 主图墨晕开时长。
  final Duration heroDuration;

  /// 主标题打字机每字间隔。
  final Duration titleSpeed;

  /// 是否启用揭示动画（受 `AppConfig.isAnimationEnabled` 控制）。
  /// false 时所有内容静态显示。
  final bool enabled;

  /// 全部揭示完成后回调。
  final VoidCallback? onComplete;

  /// 重放触发键（v2.4.3）：当此值变化时重新播放揭示动画。
  ///
  /// RevealAnimation 是 StatefulWidget，第二次起卦时 widget rebuild 但 State
  /// 持久、controller 不会重置，导致结果瞬间显示而无动画。各术传入每次起卦
  /// 都会变化的标识（通常是结果对象本身），didUpdateWidget 检测到变化即重放。
  final Object? replayKey;

  const RevealAnimation({
    super.key,
    this.hero,
    this.title,
    this.titleStyle,
    this.sections = const [],
    this.sectionStagger = const Duration(milliseconds: 200),
    this.sectionDuration = const Duration(milliseconds: 500),
    this.sectionSpacing = 10.0,
    this.heroDuration = const Duration(milliseconds: 800),
    this.titleSpeed = const Duration(milliseconds: 60),
    this.enabled = true,
    this.onComplete,
    this.replayKey,
  });

  @override
  State<RevealAnimation> createState() => _RevealAnimationState();
}

class _RevealAnimationState extends State<RevealAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _heroProgress;
  late final Animation<int> _titleChars;
  late final Animation<double> _titleReveal;
  // 段落 interval 起始值（避免读取内部 Interval.curve）
  late final double _secStart;

  @override
  void initState() {
    super.initState();
    // 总时长 = hero + title + sections 错峰 + 末段时长，最少 1s。
    final heroMs = widget.heroDuration.inMilliseconds;
    final titleMs = (widget.title?.length ?? 0) * widget.titleSpeed.inMilliseconds;
    final sectionsMs = (widget.sections.isNotEmpty
            ? (widget.sections.length - 1) * widget.sectionStagger.inMilliseconds
            : 0) +
        widget.sectionDuration.inMilliseconds;
    final totalMs = (heroMs + titleMs + sectionsMs).clamp(800, 6000);

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    final heroEnd = (heroMs / totalMs).clamp(0.0, 1.0);
    final titleStart = heroEnd * 0.5; // 与 hero 后半段重叠
    final titleEnd = ((heroEnd * totalMs + titleMs) / totalMs).clamp(0.0, 1.0);
    final secStart = titleEnd;

    _secStart = secStart;
    _heroProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(0.0, heroEnd == 0 ? 0.001 : heroEnd,
            curve: Curves.easeOutCubic),
      ),
    );
    _titleReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Interval(titleStart, titleEnd == titleStart ? titleStart + 0.001 : titleEnd,
            curve: Curves.easeOutCubic),
      ),
    );
    _titleChars = StepTween(
      begin: 0,
      end: widget.title?.length ?? 0,
    ).animate(_titleReveal);

    if (widget.enabled) {
      _ctrl.forward().then((_) => widget.onComplete?.call());
    } else {
      _ctrl.value = 1.0; // 静态模式直接完成
    }
  }

  @override
  void didUpdateWidget(covariant RevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // v2.4.3：同一页面第二次起卦时，replayKey 变化 → 重新播放揭示动画
    if (widget.replayKey != oldWidget.replayKey && widget.enabled) {
      _ctrl.forward(from: 0).then((_) => widget.onComplete?.call());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      // 关闭动效：直接静态显示所有内容
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _interleave([
          if (widget.hero != null) widget.hero!,
          if (widget.title != null)
            Text(widget.title!, style: widget.titleStyle),
          ...widget.sections,
        ]),
      );
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // —— 主图：墨晕开 ——
            if (widget.hero != null)
              Opacity(
                opacity: _heroProgress.value,
                child: widget.hero!,
              ),
            if (widget.hero != null && widget.sectionSpacing > 0)
              SizedBox(height: widget.sectionSpacing),
            // —— 主标题：打字机 ——
            if (widget.title != null && widget.title!.isNotEmpty)
              _buildTypewriter(),
            if (widget.title != null &&
                widget.title!.isNotEmpty &&
                widget.sectionSpacing > 0)
              SizedBox(height: widget.sectionSpacing),
            // —— 段落：错峰淡入上浮 ——
            ..._buildSections(),
          ],
        );
      },
    );
  }

  /// 在 items 之间插入 [sectionSpacing] 高度的间距（关闭动效时使用）。
  List<Widget> _interleave(List<Widget> items) {
    if (widget.sectionSpacing <= 0 || items.length < 2) return items;
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(SizedBox(height: widget.sectionSpacing));
      }
    }
    return result;
  }

  Widget _buildTypewriter() {
    final n = _titleChars.value;
    final shown =
        widget.title!.substring(0, n.clamp(0, widget.title!.length));
    final isTyping = n < widget.title!.length;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: shown,
        style: widget.titleStyle,
        children: [
          if (isTyping)
            WidgetSpan(
              child: Opacity(
                opacity: 0.7,
                child: Text('▎', style: widget.titleStyle),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSections() {
    final total = widget.sections.length;
    final staggerMs = widget.sectionStagger.inMilliseconds;
    final itemMs = widget.sectionDuration.inMilliseconds;
    final totalMs = _ctrl.duration!.inMilliseconds;
    final secStart = _secStart;
    final spacing = widget.sectionSpacing;

    final result = <Widget>[];
    for (var i = 0; i < total; i++) {
      result.add(_buildSection(i, secStart, staggerMs, itemMs, totalMs));
      if (i < total - 1 && spacing > 0) {
        result.add(SizedBox(height: spacing));
      }
    }
    return result;
  }

  Widget _buildSection(int i, double secStart, int staggerMs, int itemMs,
      int totalMs) {
    final beginMs = (secStart * totalMs) + i * staggerMs;
    final endMs = beginMs + itemMs;
    final begin = (beginMs / totalMs).clamp(0.0, 1.0);
    final end = (endMs / totalMs).clamp(0.0, 1.0);
    final interval = Interval(begin, end == begin ? begin + 0.001 : end,
        curve: Curves.easeOutCubic);
    final t = interval.transform(_ctrl.value);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, 16 * (1 - t)),
        child: widget.sections[i],
      ),
    );
  }
}
