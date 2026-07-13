// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/config/platform_info.dart';
import '../../../core/history/history_store.dart';
import '../../../data/yijing/hexagram_texts.dart';
import '../../../data/yijing/trigrams.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/entrance_item.dart';
import '../../../shared/widgets/gold_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
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
  final GlobalKey _boundaryKey = GlobalKey();

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

  /// 交互区（摇卦/重置/复制/分享）—— pinned header 内容，移动/桌面共用。
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
            const SizedBox(width: 8),
            ShareResultButton(
              boundaryKey: _boundaryKey,
              enabled: r != null,
              fallbackText: _buildCopyText(),
            ),
          ],
        ),
      );

  /// 结果列表 sliver —— 移动/桌面共用。
  /// 包裹 RepaintBoundary 以支持截图分享。
  Widget _buildResultSliver(ZhouyiResult? r) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        sliver: SliverToBoxAdapter(
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _resultItems(r),
            ),
          ),
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
      // —— 本卦卦辞 ——
      const SizedBox(height: 12),
      EntranceItem(
        animation: _anim,
        interval: const Interval(0.54, 0.80),
        child: _buildGuaCiCard(
          title: '本卦卦辞 · ${r.benName}',
          guaName: r.benName,
          titleColor: AppColors.gold,
        ),
      ),
      // —— 变爻爻辞列表 ——
      for (final i in r.changing)
        EntranceItem(
          animation: _anim,
          interval: Interval((0.62 + i * 0.04).clamp(0.0, 0.92),
              (0.86 + i * 0.02).clamp(0.0, 1.0)),
          child: _buildYaoCiCard(r, i),
        ),
      // —— 变卦卦辞 ——
      if (r.bianName != null) ...[
        const SizedBox(height: 12),
        EntranceItem(
          animation: _anim,
          interval: const Interval(0.70, 0.92),
          child: _buildGuaCiCard(
            title: '之卦卦辞 · ${r.bianName}',
            guaName: r.bianName!,
            titleColor: AppColors.changing,
          ),
        ),
      ],
    ];
  }

  /// 卦辞卡片（标题 + 原文 + 白话注解）。
  Widget _buildGuaCiCard({
    required String title,
    required String guaName,
    required Color titleColor,
  }) {
    final ci = HexagramTexts.guaCi(guaName) ?? '';
    final note = HexagramTexts.guaCiNote(guaName) ?? '';
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          if (ci.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(ci,
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 14, height: 1.6)),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(note,
                style: const TextStyle(
                    color: AppColors.textSubtitle, fontSize: 12, height: 1.5)),
          ],
        ],
      ),
    );
  }

  /// 单个变爻爻辞卡片。
  Widget _buildYaoCiCard(ZhouyiResult r, int index) {
    final line = r.lines[index];
    final posName = HexagramTexts.posName(index, line.yang);
    final ci = HexagramTexts.yaoCi(r.benName, posName) ?? '';
    final note = HexagramTexts.yaoCiNote(r.benName, posName) ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: DecorativePanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('变爻 · $posName',
                style: const TextStyle(
                    color: AppColors.changing,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            if (ci.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(ci,
                  style: const TextStyle(
                      color: AppColors.textBody, fontSize: 14, height: 1.6)),
            ],
            if (note.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(note,
                  style: const TextStyle(
                      color: AppColors.textSubtitle, fontSize: 12, height: 1.5)),
            ],
          ],
        ),
      ),
    );
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
    // 卦辞爻辞
    final benCi = HexagramTexts.guaCi(r.benName);
    if (benCi != null && benCi.isNotEmpty) {
      sb.writeln('\n—— 本卦卦辞 ——');
      sb.writeln(benCi);
      final benNote = HexagramTexts.guaCiNote(r.benName);
      if (benNote != null && benNote.isNotEmpty) sb.writeln('注：$benNote');
    }
    for (final i in r.changing) {
      final line = r.lines[i];
      final posName = HexagramTexts.posName(i, line.yang);
      final ci = HexagramTexts.yaoCi(r.benName, posName);
      if (ci != null && ci.isNotEmpty) {
        sb.writeln('\n—— 变爻 $posName ——');
        sb.writeln(ci);
        final note = HexagramTexts.yaoCiNote(r.benName, posName);
        if (note != null && note.isNotEmpty) sb.writeln('注：$note');
      }
    }
    if (r.bianName != null) {
      final bianCi = HexagramTexts.guaCi(r.bianName!);
      if (bianCi != null && bianCi.isNotEmpty) {
        sb.writeln('\n—— 之卦卦辞 ——');
        sb.writeln(bianCi);
        final bianNote = HexagramTexts.guaCiNote(r.bianName!);
        if (bianNote != null && bianNote.isNotEmpty) sb.writeln('注：$bianNote');
      }
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
