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
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/copy_result_button.dart';
import '../../../shared/widgets/share_result_button.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';
import '../algorithm/shensha.dart';

// -- Shichen constants ---------------------------------------------------

const _shichenLabels = [
  '子时 (23:00-01:00)',
  '丑时 (01:00-03:00)',
  '寅时 (03:00-05:00)',
  '卯时 (05:00-07:00)',
  '辰时 (07:00-09:00)',
  '巳时 (09:00-11:00)',
  '午时 (11:00-13:00)',
  '未时 (13:00-15:00)',
  '申时 (15:00-17:00)',
  '酉时 (17:00-19:00)',
  '戌时 (19:00-21:00)',
  '亥时 (21:00-23:00)',
];

// -- Five-element → color ------------------------------------------------

Color _wuxingColor(String wx) => switch (wx) {
      '木' => AppColors.wood,
      '火' => AppColors.fire,
      '土' => AppColors.earth,
      '金' => AppColors.metal,
      '水' => AppColors.waterDeep,
      _ => AppColors.textBody,
    };

// -- Page ----------------------------------------------------------------

class BaziPage extends ConsumerStatefulWidget {
  const BaziPage({super.key});

  @override
  ConsumerState<BaziPage> createState() => _BaziPageState();
}

class _BaziPageState extends ConsumerState<BaziPage> {
  DateTime _birthDate = DateTime(1995, 6, 15);
  int? _hourIndex; // null = unknown
  int _gender = 1; // 1 = male, 0 = female
  BaziResult? _r;
  String? _error;
  final GlobalKey _boundaryKey = GlobalKey();

  void _onDivine() {
    FocusScope.of(context).unfocus();
    final y = _birthDate.year;
    final m = _birthDate.month;
    final d = _birthDate.day;

    if (y < 1900 || y > 2100) {
      setState(() => _error = '年份需在 1900–2100 之间');
      return;
    }

    final result = divine(
      year: y,
      month: m,
      day: d,
      hourIndex: _hourIndex,
      gender: _gender,
    );

    setState(() {
      _r = result;
      _error = null;
    });

    unawaited(HistoryStore.add(HistoryEntry(
      id: HistoryStore.generateId(),
      techId: 'bazi',
      techName: '八字推演',
      time: DateTime.now(),
      summary: _buildSummary(result),
      detail: _buildCopyText(result),
    )));
  }

  void _onReset() {
    setState(() {
      _r = null;
      _error = null;
      _hourIndex = null;
      _gender = 1;
      _birthDate = DateTime(1995, 6, 15);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      helpText: '选择阳历生辰',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.gold,
                  onPrimary: const Color(0xFF1A1208),
                  surface: AppColors.bgInner,
                  onSurface: AppColors.textPrimary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
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
            Text('八字推演', style: TextStyle(fontSize: 18)),
            Text('四 柱 命 理',
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSubtitle,
                    letterSpacing: 4)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // -- Input panel --
          DecorativePanel(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(Icons.cake, color: AppColors.goldBright, size: 16),
                    SizedBox(width: 6),
                    Text('阳历生辰',
                        style: TextStyle(
                            color: AppColors.goldBright,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                  ],
                ),
                const SizedBox(height: 10),

                // Date picker row
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(20, 16, 28, 0.86),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: AppColors.gold, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          '${_birthDate.year}年${_birthDate.month}月${_birthDate.day}日',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down,
                            color: AppColors.textHint),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Gender selection
                const Text('性别',
                    style:
                        TextStyle(color: AppColors.textBody, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _genderToggle('男', 1,
                          icon: Icons.male, color: AppColors.waterDeepGlow),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _genderToggle('女', 0,
                          icon: Icons.female, color: AppColors.fireGlow),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Shichen dropdown
                const Text('时辰（可选）',
                    style:
                        TextStyle(color: AppColors.textBody, fontSize: 12)),
                const SizedBox(height: 6),
                _shichenDropdown(),
                const SizedBox(height: 8),

                // Hint text
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.goldBorder.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.gold, size: 14),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '*若时辰未知，可不填写。系统将自动略过时柱与大运推演。*',
                          style: TextStyle(
                              color: AppColors.textMeta,
                              fontSize: 11,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!,
                        style: const TextStyle(
                            color: AppColors.gradeBad, fontSize: 12)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GoldButton(text: '排盘推演', onPressed: _onDivine),
          const SizedBox(height: 8),
          DarkButton(text: '重置', onPressed: _onReset),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CopyResultButton(
                  text: _buildCopyText(_r),
                  enabled: _r != null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ShareResultButton(
                  boundaryKey: _boundaryKey,
                  enabled: _r != null,
                  fallbackText: _buildCopyText(_r),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // -- Result --
          if (_r != null)
            RepaintBoundary(
              key: _boundaryKey,
              child: _buildResult(_r!),
            ),
          const SizedBox(height: 12),

          // -- Help panel --
          const DecorativePanel(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('◆ 八字要诀',
                    style: TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                SizedBox(height: 6),
                Text('1. 输入阳历生辰（年月日），时辰可选。',
                    style: TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                        height: 1.6)),
                Text('2. 年柱以立春为界，月柱以节气为分。',
                    style: TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                        height: 1.6)),
                Text('3. 大运阳男阴女顺排，阴男阳女逆排，每十年一柱。',
                    style: TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                        height: 1.6)),
                Text('4. 神煞查表含天乙贵人、文昌、华盖等八星。',
                    style: TextStyle(
                        color: AppColors.textBody,
                        fontSize: 12,
                        height: 1.6)),
                SizedBox(height: 6),
                Text('注：命格批断基于五行强弱与十神配置，仅供参考。',
                    style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 10,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -- Input widgets ------------------------------------------------------

  Widget _genderToggle(String label, int value,
      {required IconData icon, required Color color}) {
    final selected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.18)
              : const Color.fromRGBO(20, 16, 28, 0.86),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.6) : AppColors.goldBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? color : AppColors.textHint, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  color: selected ? color : AppColors.textBody,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  Widget _shichenDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(20, 16, 28, 0.86),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: _hourIndex,
          isExpanded: true,
          hint: const Text('未知（跳过时柱）',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('未知（跳过时柱）',
                  style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            ),
            for (var i = 0; i < _shichenLabels.length; i++)
              DropdownMenuItem<int?>(
                value: i,
                child: Text(_shichenLabels[i],
                    style:
                        const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
              ),
          ],
          onChanged: (v) => setState(() => _hourIndex = v),
          dropdownColor: AppColors.bgInner,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.gold),
        ),
      ),
    );
  }

  // -- Result widgets -----------------------------------------------------

  Widget _buildResult(BaziResult r) {
    final enabled = ref
            .watch(configProvider)
            .valueOrNull
            ?.isAnimationEnabled('bazi', AnimationKind.reveal) ??
        true;
    return RevealAnimation(
      enabled: enabled,
      hero: _buildHeader(r),
      sections: [
        _buildPillars(r),
        if (r.hasTime) _buildDaYun(r) else _buildNoTimeWarning(),
        _buildLiuNian(r),
        _buildShenShas(r),
        _buildMingGe(r),
        _buildWuxingAnalysis(r),
        _buildJieShu(r),
        Center(
          child: Text(
            '${r.divineTime.toString().substring(0, 19)} 推演',
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: AppColors.goldBright, size: 16),
              const SizedBox(width: 6),
              Text('${r.genderLabel}命 · ${r.solarDisplay}',
                  style: const TextStyle(
                      color: AppColors.goldBright,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(r.lunarDisplay,
              style:
                  const TextStyle(color: AppColors.textBody, fontSize: 13)),
          if (r.startYunDisplay != null) ...[
            const SizedBox(height: 4),
            Text('${r.yunForward ? "顺" : "逆"}排 · ${r.startYunDisplay}',
                style: const TextStyle(color: AppColors.textMeta, fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _buildPillars(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('四柱'),
          const SizedBox(height: 8),
          // Pillar header row
          Row(
            children: [
              for (final p in r.pillars)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.center,
                    child: Text(p.label,
                        style: TextStyle(
                          color: p.label == '日柱'
                              ? AppColors.goldBright
                              : AppColors.textSubtitle,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        )),
                  ),
                ),
            ],
          ),
          // Ganzhi display
          const SizedBox(height: 4),
          Row(
            children: [
              for (final p in r.pillars)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: p.label == '日柱'
                          ? AppColors.gold.withValues(alpha: 0.1)
                          : AppColors.bgMid.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: p.label == '日柱'
                            ? AppColors.goldBorder
                            : const Color.fromRGBO(212, 168, 87, 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(p.gan,
                            style: TextStyle(
                              color: _wuxingColor(
                                  ganWuxing[p.gan]!),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(p.zhi,
                            style: TextStyle(
                              color: _wuxingColor(
                                  zhiWuxing[p.zhi] ?? '土'),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Detail rows
          _pillarDetailRow('纳音', r.pillars.map((p) => p.nayin).toList()),
          _pillarDetailRow('十神',
              r.pillars.map((p) => p.shishenGan).toList()),
          _pillarDetailRow(
              '藏干', r.pillars.map((p) => p.hideGan.join()).toList()),
          _pillarDetailRow('地势', r.pillars.map((p) => p.dishi).toList()),
        ],
      ),
    );
  }

  Widget _pillarDetailRow(String label, List<String> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSubtitle, fontSize: 11)),
          ),
          for (final v in values)
            Expanded(
              child: Text(v,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textBody, fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildNoTimeWarning() {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.gradeRough, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('未输入时辰，将略过时柱与大运推演。',
                style: TextStyle(color: AppColors.textBody, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildDaYun(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('大运'),
          const SizedBox(height: 8),
          for (final dy in r.daYuns)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: dy.isCurrent
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : AppColors.bgMid.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: dy.isCurrent
                      ? AppColors.goldBorder
                      : const Color.fromRGBO(212, 168, 87, 0.15),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(dy.ganZhi,
                        style: TextStyle(
                          color: dy.isCurrent
                              ? AppColors.goldBright
                              : AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Expanded(
                    child: Text(
                        '${dy.startAge}-${dy.endAge}岁 · ${dy.startYear}-${dy.endYear}年',
                        style: const TextStyle(
                            color: AppColors.textBody, fontSize: 11)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _wuxingColor(ganWuxing[dy.ganZhi[0]]!)
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(dy.shishenGan,
                        style: TextStyle(
                          color:
                              _wuxingColor(ganWuxing[dy.ganZhi[0]]!),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  if (dy.isCurrent)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text('当前',
                          style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLiuNian(BaziResult r) {
    final ln = r.currentLiuNian;
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('流年'),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(ln.ganZhi,
                  style: const TextStyle(
                      color: AppColors.goldBright,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Text('${ln.year}年 · 虚岁${ln.age}',
                  style: const TextStyle(
                      color: AppColors.textBody, fontSize: 13)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _wuxingColor(ganWuxing[ln.ganZhi[0]]!)
                      .withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(ln.shishenGan,
                    style: TextStyle(
                      color: _wuxingColor(ganWuxing[ln.ganZhi[0]]!),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShenShas(BaziResult r) {
    if (r.shenshas.isEmpty) {
      return DecorativePanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('神煞'),
            const SizedBox(height: 6),
            const Text('四柱未见显著神煞。',
                style: TextStyle(color: AppColors.textMeta, fontSize: 12)),
          ],
        ),
      );
    }
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('神煞'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: r.shenshas.map((s) {
              final isAuspicious = !['亡神'].contains(s.name);
              final color = isAuspicious ? AppColors.woodGlow : AppColors.fireGlow;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${s.name} · ${s.pillarLabel}（${s.branch}）',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          for (final s in r.shenshas)
            if (shenshaDescriptions.containsKey(s.name))
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                    '${s.name}：${shenshaDescriptions[s.name]}',
                    style: const TextStyle(
                        color: AppColors.textMeta, fontSize: 11, height: 1.5)),
              ),
        ],
      ),
    );
  }

  Widget _buildMingGe(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('命格批断'),
          const SizedBox(height: 6),
          Text(r.mingGe,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.7,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildWuxingAnalysis(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('五行分析'),
          const SizedBox(height: 8),
          // Distribution bar
          Row(
            children: r.wuxingDistribution.map((e) {
              return Expanded(
                child: Column(
                  children: [
                    Text(e.element,
                        style: TextStyle(
                          color: _wuxingColor(e.element),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 3),
                    Text(e.score.toStringAsFixed(1),
                        style: TextStyle(
                          color: _wuxingColor(e.element),
                          fontSize: 10,
                        )),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(r.wuxingAnalysis,
              style: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12,
                  height: 1.7,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildJieShu(BaziResult r) {
    return DecorativePanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3, height: 14, color: AppColors.fire),
              const SizedBox(width: 6),
              const Text('劫数预警',
                  style: TextStyle(
                    color: AppColors.fireGlow,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text(r.jieShu,
              style: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 12,
                  height: 1.7,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // -- Helpers ------------------------------------------------------------

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Container(width: 3, height: 14, color: AppColors.gold),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );

  String _buildSummary(BaziResult r) {
    final gz = r.pillars.map((p) => p.ganZhi).join(' ');
    return '$gz · ${r.genderLabel}命${r.hasTime ? '' : '（无时柱）'}';
  }

  String _buildCopyText(BaziResult? r) {
    if (r == null) return '';
    final sb = StringBuffer('【八字推演 · 四柱命理】\n');
    sb.writeln('时间：${r.divineTime.toString().substring(0, 19)}');
    sb.writeln('生辰：${r.solarDisplay}（${r.lunarDisplay}）');
    sb.writeln('性别：${r.genderLabel}命');
    sb.writeln('\n—— 四柱 ——');
    for (final p in r.pillars) {
      sb.writeln('${p.label}：${p.ganZhi} '
          '（${p.wuxing} · ${p.nayin} · ${p.shishenGan} · ${p.dishi}）'
          '  藏干：${p.hideGan.join()}');
    }
    if (r.startYunDisplay != null) {
      sb.writeln('\n—— 大运（${r.yunForward ? "顺排" : "逆排"}）——');
      sb.writeln(r.startYunDisplay!);
      for (final dy in r.daYuns) {
        sb.writeln('${dy.ganZhi} ${dy.startAge}-${dy.endAge}岁 '
            '${dy.startYear}-${dy.endYear}年 ${dy.shishenGan}'
            '${dy.isCurrent ? " ← 当前" : ""}');
      }
    } else {
      sb.writeln('\n（未输入时辰，略过大运推演）');
    }
    sb.writeln('\n—— 流年 ——');
    sb.writeln('${r.currentLiuNian.year}年 ${r.currentLiuNian.ganZhi} '
        '虚岁${r.currentLiuNian.age} ${r.currentLiuNian.shishenGan}');
    if (r.shenshas.isNotEmpty) {
      sb.writeln('\n—— 神煞 ——');
      for (final s in r.shenshas) {
        sb.writeln('${s.name}（${s.pillarLabel}·${s.branch}）');
      }
    }
    sb.writeln('\n—— 命格批断 ——');
    sb.writeln(r.mingGe);
    sb.writeln('\n—— 五行分析 ——');
    sb.writeln(r.wuxingAnalysis);
    sb.writeln('\n—— 劫数预警 ——');
    sb.writeln(r.jieShu);
    sb.writeln('\n—— 志极 Jeenith · 叩问本心 ——');
    return sb.toString();
  }
}
