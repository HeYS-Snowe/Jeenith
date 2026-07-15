// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animation/reveal/reveal_animation.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/history/history_store.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';

/// 洛书九宫在 3×3 网格中的展示顺序（行优先：上→中→下）。
/// 4巽 9离 2坤 / 3震 5中 7兑 / 8艮 1坎 6乾
const _luoshuDisplay = [4, 9, 2, 3, 5, 7, 8, 1, 6];

class QimenPage extends ConsumerStatefulWidget {
  const QimenPage({super.key});
  @override
  ConsumerState<QimenPage> createState() => _QimenPageState();
}

class _QimenPageState extends ConsumerState<QimenPage> {
  final _year = TextEditingController();
  final _month = TextEditingController();
  final _day = TextEditingController();
  final _hour = TextEditingController();
  QimenResult? _r;
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void dispose() {
    for (final c in [_year, _month, _day, _hour]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onDivine() {
    final y = int.tryParse(_year.text) ?? 0;
    final m = int.tryParse(_month.text) ?? 0;
    final d = int.tryParse(_day.text) ?? 0;
    final h = int.tryParse(_hour.text) ?? -1;
    if (y < 1900 || y > 2100 || m < 1 || m > 12 || d < 1 || d > 31 || h < 0 || h > 23) return;
    setState(() => _r = divine(y, m, d, h));
    FocusScope.of(context).unfocus();
    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'qimen',
      techName: '奇门遁甲',
      time: DateTime.now(),
      summary: _r == null ? '' : '${_r!.dunType}第${_r!.ju}局',
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
            Text('奇门遁甲', style: TextStyle(fontSize: 18)),
            Text('时 家 奇 门',
                style: TextStyle(
                    fontSize: 10, color: AppColors.textSubtitle, letterSpacing: 4)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          DecorativePanel(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('公历时辰（年 月 日 时 0-23）',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _f(_year, '年')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_month, '月')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_day, '日')),
                    const SizedBox(width: 6),
                    Expanded(child: _f(_hour, '时')),
                  ],
                ),
                const SizedBox(height: 10),
                GoldButton(text: '排盘', onPressed: _onDivine),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CopyResultButton(text: _buildCopyText(), enabled: _r != null),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShareResultButton(
                        boundaryKey: _boundaryKey,
                        enabled: _r != null,
                        fallbackText: _buildCopyText(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_r != null)
            RepaintBoundary(key: _boundaryKey, child: _buildResult(_r!)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _f(TextEditingController c, String hint) => TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: hint, isDense: true),
      );

  /// 生成详细结果文本（供复制）。
  String _buildCopyText() {
    final r = _r;
    if (r == null) return '';
    final p = r.plate;
    final sb = StringBuffer('【奇门遁甲 · 时家奇门 v2 四盘】\n');
    sb.writeln('时间：${DateTime.now().toString().substring(0, 19)}');
    sb.writeln(p.lunarDisplay);
    sb.writeln('八字：${p.bazi}');
    sb.writeln('节气：${p.jieqi}');
    sb.writeln('遁型：${p.dunType}  局数：第 ${p.ju} 局');
    sb.writeln('值符：${p.zhiFu}（第${p.zhiFuGong}宫）  值使：${p.zhiShi}（第${p.zhiShiGong}宫）');
    sb.writeln('\n—— 九宫四盘 ——');
    for (var i = 0; i < 9; i++) {
      final palace = _luoshuDisplay[i];
      final name = palaceNames[palace - 1];
      final xing = p.tianPanXing[palace - 1];
      final gan = p.diPanGan[palace - 1];
      final men = p.renPanMen[palace - 1];
      final shen = p.shenPanShen[palace - 1];
      sb.writeln('第$palace宫（$name）：'
          '天盘「$xing」  地盘「$gan」  '
          '${men.isEmpty ? "" : "人盘「$men」  "} '
          '${shen.isEmpty ? "" : "神盘「$shen」"}');
    }
    sb.writeln('\n—— 四盘详表 ——');
    sb.writeln('天盘九星：${p.tianPanXing.asMap().entries.map((e) => "${palaceNames[e.key]}:${e.value}").join("  ")}');
    sb.writeln('地盘九干：${p.diPanGan.asMap().entries.map((e) => "${palaceNames[e.key]}:${e.value}").join("  ")}');
    sb.writeln('人盘八门：${p.renPanMen.asMap().entries.where((e) => e.value.isNotEmpty).map((e) => "${palaceNames[e.key]}:${e.value}").join("  ")}');
    sb.writeln('神盘八神：${p.shenPanShen.asMap().entries.where((e) => e.value.isNotEmpty).map((e) => "${palaceNames[e.key]}:${e.value}").join("  ")}');
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }

  Widget _buildResult(QimenResult r) {
    final p = r.plate;
    final dunColor =
        r.dunType == '阳遁' ? AppColors.gold : AppColors.waterDeepGlow;
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('qimen', AnimationKind.reveal) ??
        true;
    return RevealAnimation(
      enabled: enabled,
      hero: DecorativePanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.lunarDisplay,
                style: const TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('八字：${p.bazi}',
                style: const TextStyle(
                    color: AppColors.textBody, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(r.dunType,
                    style: TextStyle(
                        color: dunColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4)),
                const SizedBox(width: 16),
                Text('第 ${r.ju} 局',
                    style: const TextStyle(
                        color: AppColors.fireGlow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                if (p.jieqi.isNotEmpty)
                  Text(p.jieqi,
                      style: const TextStyle(
                          color: AppColors.textMeta, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.goldBorder, width: 1),
              ),
              child: Row(
                children: [
                  const Text('值符',
                      style: TextStyle(
                          color: AppColors.textMeta, fontSize: 11)),
                  const SizedBox(width: 6),
                  Text('${p.zhiFu}·${palaceNames[p.zhiFuGong - 1]}宫',
                      style: const TextStyle(
                          color: AppColors.goldBright,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  const Text('值使',
                      style: TextStyle(
                          color: AppColors.textMeta, fontSize: 11)),
                  const SizedBox(width: 6),
                  Text('${p.zhiShi}·${palaceNames[p.zhiShiGong - 1]}宫',
                      style: const TextStyle(
                          color: AppColors.woodGlow,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      sections: [
        const Text('◆ 局盘九宫（天地人神四盘叠加）',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        DecorativePanel(
          padding: const EdgeInsets.all(8),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.78,
            children: [
              for (var i = 0; i < 9; i++)
                _buildPalaceCell(_luoshuDisplay[i], p),
            ],
          ),
        ),
        const Text('◆ 四盘详表',
            style: TextStyle(
                color: AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        _buildPanTable('天盘九星', p.tianPanXing, AppColors.goldBright),
        _buildPanTable('地盘九干', p.diPanGan, AppColors.textPrimary),
        _buildPanTable('人盘八门', p.renPanMen, AppColors.woodGlow,
            skipEmpty: true),
        _buildPanTable('神盘八神', p.shenPanShen, AppColors.waterDeepGlow,
            skipEmpty: true),
      ],
    );
  }

  /// 9 宫格单格：显示天盘星 + 地盘干 + 人盘门 + 神盘神四层叠加。
  Widget _buildPalaceCell(int palace, QimenPlate p) {
    final name = palaceNames[palace - 1];
    final xing = p.tianPanXing[palace - 1];
    final gan = p.diPanGan[palace - 1];
    final men = p.renPanMen[palace - 1];
    final shen = p.shenPanShen[palace - 1];
    final isZhiFu = palace == p.zhiFuGong;
    final isZhiShi = palace == p.zhiShiGong;
    final isCenter = palace == 5;

    final border = isZhiFu
        ? AppColors.gold
        : (isZhiShi ? AppColors.woodGlow : const Color.fromRGBO(212, 168, 87, 0.2));
    final borderWidth = (isZhiFu || isZhiShi) ? 1.8 : 1.0;
    final bg = isCenter
        ? AppColors.gold.withValues(alpha: 0.10)
        : (isZhiFu
            ? AppColors.gold.withValues(alpha: 0.08)
            : (isZhiShi ? AppColors.wood.withValues(alpha: 0.08) : AppColors.card));

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: borderWidth),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 顶部：宫名 + 标识
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name,
                  style: TextStyle(
                      color: isZhiFu
                          ? AppColors.goldBright
                          : (isZhiShi ? AppColors.woodGlow : AppColors.textMeta),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              if (isZhiFu || isZhiShi)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(isZhiFu ? '符' : '使',
                      style: TextStyle(
                          color: isZhiFu ? AppColors.gold : AppColors.woodGlow,
                          fontSize: 9)),
                ),
            ],
          ),
          const Divider(height: 1, color: Color.fromRGBO(212, 168, 87, 0.18)),
          // 天盘星
          Text(xing,
              style: const TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold, height: 1.3)),
          // 地盘干
          Text(gan,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, height: 1.3)),
          // 人盘门
          if (men.isNotEmpty)
            Text(men,
                style: const TextStyle(color: AppColors.woodGlow, fontSize: 10, height: 1.3)),
          // 神盘神
          if (shen.isNotEmpty)
            Text(shen,
                style: const TextStyle(color: AppColors.waterDeepGlow, fontSize: 10, height: 1.3)),
        ],
      ),
    );
  }

  /// 单盘详表（横向 9 宫，按洛书顺序）。
  Widget _buildPanTable(String title, List<String> values, Color valueColor,
      {bool skipEmpty = false}) {
    return DecorativePanel(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (var palace = 1; palace <= 9; palace++)
                if (!skipEmpty || values[palace - 1].isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.bgInner.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.15)),
                    ),
                    child: Text(
                      '${palaceNames[palace - 1]}:${values[palace - 1]}',
                      style: TextStyle(color: valueColor, fontSize: 11),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
