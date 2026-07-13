// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/calendar/lunar_service.dart';
import '../../../core/config/platform_info.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/divination/divination_result.dart';
import '../../../core/history/history_store.dart';
import '../../../core/rng/rng_providers.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/entrance_item.dart';
import '../../../shared/widgets/gold_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../algorithm/divine.dart';
import '../state/xiaoliuren_providers.dart';
import 'divination_wheel.dart';
import 'palace_result_card.dart';

class XiaoliurenPage extends ConsumerStatefulWidget {
  const XiaoliurenPage({super.key});

  @override
  ConsumerState<XiaoliurenPage> createState() => _XiaoliurenPageState();
}

class _XiaoliurenPageState extends ConsumerState<XiaoliurenPage>
    with SingleTickerProviderStateMixin {
  final _inputCtrl = TextEditingController();
  final _wheelKey = GlobalKey<DivinationWheelState>();
  ScrollController? _sheetCtrl;
  // 桌面端无 DraggableScrollableSheet，自建 controller；移动端复用 sheet 的。
  ScrollController? _ownCtrl;
  late final AnimationController _resultAnim;
  final GlobalKey _boundaryKey = GlobalKey();
  List<int>? _nums;
  DivineResult? _divine;
  EntropySample? _entropy;
  DivinationResult? _result;
  bool _busy = false;
  bool _sampling = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resultAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (PlatformInfo.isDesktop) {
      _ownCtrl = ScrollController();
      _sheetCtrl = _ownCtrl; // 桌面端把自建 controller 暴露给 reset 复用
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _ownCtrl?.dispose();
    _resultAnim.dispose();
    super.dispose();
  }

  (List<int>, String?) _parseInput() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return (<int>[], '请输入数字');
    var tokens = RegExp(r'\d+').allMatches(text).map((m) => m.group(0)!).toList();
    if (tokens.length < 3) {
      final digits = RegExp(r'\d').allMatches(text).map((m) => m.group(0)!).toList();
      if (digits.length >= 3) tokens = digits;
    }
    if (tokens.length < 3) return (<int>[], '请至少输入三个数字');
    final nums = tokens
        .take(3)
        .map((s) => int.tryParse(s) ?? 6)
        .map((n) => n == 0 ? 6 : n)
        .toList();
    return (nums, null);
  }

  void _divineWith(List<int> nums, EntropySample? entropy) {
    FocusScope.of(context).unfocus();
    setState(() {
      _nums = nums;
      _divine = divine(nums);
      _entropy = entropy;
      _result = null; // 清空结果
      _busy = true;
      _sampling = false;
      _error = null;
    });
    _inputCtrl.text = nums.join(' ');
    // 交互与结果面板滚回起始位置（按钮复位）
    if (_sheetCtrl?.hasClients ?? false) _sheetCtrl!.jumpTo(0);
    _wheelKey.currentState?.start(nums);
  }

  void _onDivine() {
    final (nums, err) = _parseInput();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    _divineWith(nums, null);
  }

  Future<void> _onRandom() async {
    setState(() => _sampling = true);
    final entropy =
        await ref.read(trueRandomProvider).generate(count: 3, vmax: 9);
    if (!mounted) return;
    _divineWith(entropy.numbers, entropy);
  }

  void _onTime() {
    final now = DateTime.now();
    final md = LunarService.nowLunarMonthDay();
    final zhi = ((now.hour + 1) ~/ 2) % 12 + 1;
    _divineWith([md.month, md.day, zhi], null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('时辰起卦 · 农历${md.display}'),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onReset() {
    _wheelKey.currentState?.reset();
    setState(() {
      _nums = null;
      _divine = null;
      _entropy = null;
      _result = null;
      _busy = false;
      _error = null;
      _inputCtrl.clear();
    });
    _resultAnim.value = 0;
    if (_sheetCtrl?.hasClients ?? false) _sheetCtrl!.jumpTo(0);
  }

  void _onWheelDone() {
    if (_nums == null || _divine == null) return;
    setState(() {
      _result =
          buildXiaoliurenResult(nums: _nums!, divine: _divine!, entropy: _entropy);
      _busy = false;
    });
    _resultAnim.forward(from: 0);
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'xiaoliuren',
      techName: '小六壬',
      time: DateTime.now(),
      summary: _result?.cards.map((c) => c.title).join('·') ?? '',
      detail: _buildCopyText(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Column(
          children: [
            Text('小　六　壬', style: TextStyle(fontSize: 18)),
            Text('掐 指 神 课',
                style: TextStyle(
                    fontSize: 10, color: AppColors.textSubtitle, letterSpacing: 4)),
          ],
        ),
      ),
      body: PlatformInfo.isDesktop
          ? _buildDesktopBody()
          : Stack(
              children: [
                // —— 卜算可视化（底层固定，位置上移完整可见）——
                Transform.translate(
                  offset: const Offset(0, -80),
                  child: DivinationWheel(key: _wheelKey, onDone: _onWheelDone),
                ),
                // —— 交互与结果（上层，可拖拽覆盖圆盘；交互粘顶吸附）——
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.35,
                    minChildSize: 0.3,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      _sheetCtrl = scrollController;
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.bg.withValues(alpha: 0.95),
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(16)),
                          border: const Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(212, 168, 87, 0.5))),
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverToBoxAdapter(child: _buildDragHandle()),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _PinHeaderDelegate(child: _buildActionBar()),
                            ),
                            _buildResultSliver(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  /// 拖拽把手（仅移动端 sheet 用）。
  Widget _buildDragHandle() => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(212, 168, 87, 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  /// 交互区（输入/起卦/操作）—— pinned header 内容，移动/桌面共用。
  Widget _buildActionBar() => Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
        color: AppColors.bg.withValues(alpha: 0.92),
        constraints: const BoxConstraints(minHeight: 150),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInputRow(),
            const SizedBox(height: 8),
            _buildButtons(),
          ],
        ),
      );

  /// 结果列表 sliver —— 移动/桌面共用。
  /// 包裹 RepaintBoundary 以支持截图分享。
  Widget _buildResultSliver() => SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 28),
        sliver: SliverToBoxAdapter(
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _resultItems(),
            ),
          ),
        ),
      );

  /// 桌面端布局：可视化（固定）+ 交互结果（滚轮滚动）。
  /// 桌面端鼠标拖拽不灵，弃用 DraggableScrollableSheet，改上下分栏。
  Widget _buildDesktopBody() => Column(
        children: [
          SizedBox(
            height: 320,
            child: Center(
              child: DivinationWheel(key: _wheelKey, onDone: _onWheelDone),
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(212, 168, 87, 0.5),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _sheetCtrl,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinHeaderDelegate(child: _buildActionBar()),
                ),
                _buildResultSliver(),
              ],
            ),
          ),
        ],
      );

  Widget _buildInputRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '输入三位数字，如 2 8 9',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  errorText: _error,
                ),
                onSubmitted: (_) => _onDivine(),
              ),
            ),
            const SizedBox(width: 8),
            GoldButton(text: '起卦', onPressed: _busy ? null : _onDivine),
          ],
        ),
      );

  Widget _buildButtons() => Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          DarkButton(icon: const SvgIcon('casino'), text: _sampling ? '采样中…' : '随机', onPressed: (_busy || _sampling) ? null : _onRandom),
          DarkButton(icon: const SvgIcon('schedule'), text: '时辰', onPressed: _busy ? null : _onTime),
          DarkButton(icon: const SvgIcon('refresh'), text: '重置', onPressed: _onReset),
          CopyResultButton(text: _buildCopyText(), enabled: _result != null),
          ShareResultButton(
            boundaryKey: _boundaryKey,
            enabled: _result != null,
            fallbackText: _buildCopyText(),
          ),
        ],
      );

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _result;
    if (r == null) return '';
    final sb = StringBuffer('【小六壬 · 掐指神课】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln('取数：${r.inputNumbers?.join(" ")}');
    sb.writeln('落宫：${r.cards.map((c) => c.title).join(" · ")}');
    if (r.entropy != null) {
      sb.writeln('\n—— 真随机采样 ——');
      for (final s in r.entropy!.sources) {
        sb.writeln('${s.name}：${s.display}');
      }
    }
    sb.writeln('\n—— 宫位详解 ——');
    for (final c in r.cards) {
      sb.writeln('第${c.order}宫 ${c.title}（${c.subtitle ?? ""}）${c.badge != null ? "· ${c.badge}" : ""}');
      if (c.poem != null) sb.writeln('  诗诀：${c.poem}');
      if (c.meaning != null) sb.writeln('  含义：${c.meaning}');
      if (c.details != null) {
        for (final d in c.details!) {
          sb.writeln('  ${d.label}：${d.content}');
        }
      }
    }
    if (r.verdict != null) {
      sb.writeln('\n—— 综合断语 ——');
      sb.writeln('${r.verdict!.grade}：${r.verdict!.description}');
    }
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  List<Widget> _resultItems() {
    final r = _result;
    if (r == null) {
      return const [
        SizedBox(height: 40),
        Center(
          child: Text('输入数字、随机取数或以时辰起卦',
              style: TextStyle(color: AppColors.textHint)),
        ),
      ];
    }
    return [
      EntranceItem(
        animation: _resultAnim,
        interval: const Interval(0.0, 0.22),
        child: DecorativePanel(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '取数 ${r.inputNumbers?.join(" ")}　→　${r.cards.map((c) => c.title).join(" · ")}',
            style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      if (r.entropy != null) ...[
        const SizedBox(height: 10),
        EntranceItem(
          animation: _resultAnim,
          interval: const Interval(0.12, 0.36),
          child: _entropyCard(r.entropy!),
        ),
      ],
      const SizedBox(height: 10),
      for (var i = 0; i < r.cards.length; i++) ...[
        EntranceItem(
          animation: _resultAnim,
          interval: Interval(
            (0.28 + i * 0.1).clamp(0.0, 1.0),
            (0.52 + i * 0.1).clamp(0.0, 1.0),
          ),
          child: PalaceResultCard(data: r.cards[i]),
        ),
        const SizedBox(height: 10),
      ],
      if (r.verdict != null)
        EntranceItem(
          animation: _resultAnim,
          interval: const Interval(0.64, 0.94),
          child: DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('◆ ${r.verdict!.grade}',
                    style: TextStyle(
                        color: r.verdict!.tone,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                const SizedBox(height: 4),
                Text(r.verdict!.description,
                    style: const TextStyle(
                        color: AppColors.textBody, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ),
    ];
  }

  Widget _entropyCard(EntropySample e) {
    return DecorativePanel(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('◆ 本次真随机采样',
              style: TextStyle(
                  color: Color(0xFF74BCE4),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
          const SizedBox(height: 6),
          for (final s in e.sources)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                      child: Text(s.name,
                          style: const TextStyle(
                              color: AppColors.textBody, fontSize: 11))),
                  Text(s.display,
                      style: TextStyle(
                          color: s.succeeded
                              ? const Color(0xFF7FE3AD)
                              : AppColors.textSubtitle,
                          fontSize: 11)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 交互区粘顶 delegate（pinned，固定高度）。
class _PinHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _PinHeaderDelegate({required this.child});

  @override
  double get minExtent => 200;
  @override
  double get maxExtent => 200;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) => child;
  @override
  bool shouldRebuild(_) => false;
}
