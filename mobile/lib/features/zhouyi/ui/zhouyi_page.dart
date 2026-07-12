// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/config/platform_info.dart';
import '../../../core/history/history_store.dart';
import '../../../data/yijing/trigrams.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/entrance_item.dart';
import '../../../shared/widgets/gold_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../algorithm/divine.dart';
import 'hexagram_view.dart';

class ZhouyiPage extends StatefulWidget {
  const ZhouyiPage({super.key});

  @override
  State<ZhouyiPage> createState() => _ZhouyiPageState();
}

class _ZhouyiPageState extends State<ZhouyiPage>
    with SingleTickerProviderStateMixin {
  ZhouyiResult? _result;
  bool _busy = false;
  late final AnimationController _anim;
  ScrollController? _sheetCtrl;
  // 桌面端无 DraggableScrollableSheet，自建 controller；移动端复用 sheet 的。
  ScrollController? _ownCtrl;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    if (PlatformInfo.isDesktop) {
      _ownCtrl = ScrollController();
      _sheetCtrl = _ownCtrl; // 桌面端把自建 controller 暴露给 reset 复用
    }
  }

  @override
  void dispose() {
    _ownCtrl?.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _onToss() {
    setState(() {
      _result = divine();
      _busy = true;
    });
    _anim.value = 0;
    if (_sheetCtrl?.hasClients ?? false) _sheetCtrl!.jumpTo(0);
  }

  void _onReset() {
    setState(() {
      _result = null;
      _busy = false;
    });
    _anim.value = 0;
    if (_sheetCtrl?.hasClients ?? false) _sheetCtrl!.jumpTo(0);
  }

  void _onRevealed() {
    setState(() => _busy = false);
    _anim.forward(from: 0);
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'zhouyi',
      techName: '周易',
      time: DateTime.now(),
      summary: _result?.benName ?? '',
      detail: _buildCopyText(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Column(
          children: [
            Text('周　易', style: TextStyle(fontSize: 18)),
            Text('金 钱 卦',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSubtitle,
                    letterSpacing: 4)),
          ],
        ),
      ),
      body: PlatformInfo.isDesktop
          ? _buildDesktopBody(r)
          : Stack(
              children: [
                // —— 卜算可视化（底层固定，位置上移完整可见）——
                Transform.translate(
                  offset: const Offset(0, -80),
                  child: HexagramView(lines: r?.lines, onDone: _onRevealed),
                ),
                // —— 交互与结果（上层，可拖拽覆盖；交互粘顶吸附）——
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
                              delegate:
                                  _PinHeaderDelegate(child: _buildActionBar(r)),
                            ),
                            _buildResultSliver(r),
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

  /// 交互区（摇卦/重置/复制）—— pinned header 内容，移动/桌面共用。
  Widget _buildActionBar(ZhouyiResult? r) => Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        color: AppColors.bg.withValues(alpha: 0.92),
        constraints: const BoxConstraints(minHeight: 80),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: GoldButton(
                text: _busy ? '摇卦中…' : '摇卦',
                onPressed: _busy ? null : _onToss,
              ),
            ),
            const SizedBox(width: 8),
            DarkButton(
              icon: const SvgIcon('refresh'),
              text: '重置',
              onPressed: _busy ? null : _onReset,
            ),
            const SizedBox(width: 8),
            CopyResultButton(text: _buildCopyText(), enabled: r != null),
          ],
        ),
      );

  /// 结果列表 sliver —— 移动/桌面共用。
  Widget _buildResultSliver(ZhouyiResult? r) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        sliver: SliverList(
          delegate: SliverChildListDelegate(_resultItems(r)),
        ),
      );

  /// 桌面端布局：可视化（固定）+ 交互结果（滚轮滚动）。
  /// 桌面端鼠标拖拽不灵，弃用 DraggableScrollableSheet，改上下分栏。
  Widget _buildDesktopBody(ZhouyiResult? r) => Column(
        children: [
          SizedBox(
            height: 280,
            child: Center(
              child: HexagramView(lines: r?.lines, onDone: _onRevealed),
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
                  delegate: _PinHeaderDelegate(child: _buildActionBar(r)),
                ),
                _buildResultSliver(r),
              ],
            ),
          ),
        ],
      );

  List<Widget> _resultItems(ZhouyiResult? r) {
    if (r == null) {
      return const [
        SizedBox(height: 40),
        Center(
          child: Text('点击「摇卦」以金钱卦起占',
              style: TextStyle(color: AppColors.textHint)),
        ),
      ];
    }
    final benXiang = '${xiang[r.upperName]}${xiang[r.lowerName]}';
    return [
      EntranceItem(
        animation: _anim,
        interval: const Interval(0.0, 0.30),
        child: Center(
          child: Text(r.benName,
              style: const TextStyle(
                  color: AppColors.goldBright,
                  fontSize: 72,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(height: 6),
      EntranceItem(
        animation: _anim,
        interval: const Interval(0.10, 0.36),
        child: Center(
          child: Text('$benXiang${r.benName}',
              style: const TextStyle(
                  color: AppColors.gold, fontSize: 18, letterSpacing: 4)),
        ),
      ),
      const SizedBox(height: 12),
      EntranceItem(
        animation: _anim,
        interval: const Interval(0.22, 0.48),
        child: DecorativePanel(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _trigramChip('上卦', r.upperName),
              const SizedBox(width: 24),
              _trigramChip('下卦', r.lowerName),
            ],
          ),
        ),
      ),
      if (r.bianName != null) ...[
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.38, 0.66),
          child: DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('变爻 ${r.changing.map((i) => _posLabel(i)).join("、")} → 之卦 ${r.bianName}',
                    style: const TextStyle(
                        color: AppColors.changing,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('老阴(6)/老阳(9)为变爻，阴极生阳、阳极生阴，得之卦。',
                    style: TextStyle(color: AppColors.textBody, fontSize: 11, height: 1.5)),
              ],
            ),
          ),
        ),
      ] else ...[
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.38, 0.66),
          child: const DecorativePanel(
            padding: EdgeInsets.all(12),
            child: Text('无变爻，以本卦卦象为占。',
                style: TextStyle(color: AppColors.textBody, fontSize: 12)),
          ),
        ),
      ],
    ];
  }

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _result;
    if (r == null) return '';
    final sb = StringBuffer('【周易 · 金钱卦】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln('本卦：${r.benName}（${xiang[r.upperName]}${xiang[r.lowerName]}${r.benName}）');
    sb.writeln('上卦：${r.upperName}${xiang[r.upperName]}  下卦：${r.lowerName}${xiang[r.lowerName]}');
    sb.writeln('\n—— 六爻 ——');
    const pos = ['初', '二', '三', '四', '五', '上'];
    for (var i = 0; i < 6; i++) {
      final line = r.lines[i];
      final type = line.yang ? '阳' : '阴';
      final ch = line.changing ? '（变）' : '';
      sb.writeln('${pos[i]}爻：$type$ch');
    }
    if (r.bianName != null) {
      sb.writeln('\n变爻：${r.changing.map((i) => pos[i]).join("、")} → 之卦：${r.bianName}');
    } else {
      sb.writeln('\n无变爻，以本卦为占。');
    }
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _trigramChip(String label, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.textSubtitle, fontSize: 11)),
        const SizedBox(height: 2),
        Text('$name${xiang[name]}',
            style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _posLabel(int i) => const ['初', '二', '三', '四', '五', '上'][i];
}

/// 交互区粘顶 delegate（pinned，固定高度）。
class _PinHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _PinHeaderDelegate({required this.child});

  @override
  double get minExtent => 90;
  @override
  double get maxExtent => 90;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) => child;
  @override
  bool shouldRebuild(_) => false;
}
