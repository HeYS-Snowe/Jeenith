// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/calendar/lunar_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/divination/divination_result.dart';
import '../../../core/rng/rng_providers.dart';
import '../../../shared/widgets/dark_button.dart';
import '../../../shared/widgets/decorative_panel.dart';
import '../../../shared/widgets/gold_button.dart';
import '../algorithm/divine.dart';
import '../state/xiaoliuren_providers.dart';
import 'divination_wheel.dart';
import 'palace_result_card.dart';

class XiaoliurenPage extends ConsumerStatefulWidget {
  const XiaoliurenPage({super.key});

  @override
  ConsumerState<XiaoliurenPage> createState() => _XiaoliurenPageState();
}

class _XiaoliurenPageState extends ConsumerState<XiaoliurenPage> {
  final _inputCtrl = TextEditingController();
  final _wheelKey = GlobalKey<DivinationWheelState>();
  List<int>? _nums;
  DivineResult? _divine;
  EntropySample? _entropy;
  DivinationResult? _result;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _inputCtrl.dispose();
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
        .map((s) => int.parse(s))
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
      _result = null;
      _busy = true;
      _error = null;
    });
    _inputCtrl.text = nums.join(' ');
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
  }

  void _onWheelDone() {
    if (_nums == null || _divine == null) return;
    setState(() {
      _result =
          buildXiaoliurenResult(nums: _nums!, divine: _divine!, entropy: _entropy);
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wheelSize = MediaQuery.of(context).size.width.clamp(0.0, 360.0);
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
      body: Column(
        children: [
          SizedBox(
            height: wheelSize + 16,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: DivinationWheel(key: _wheelKey, onDone: _onWheelDone),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '输入三位数字，如 2 8 9',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      errorText: _error,
                    ),
                    onSubmitted: (_) => _onDivine(),
                  ),
                ),
                const SizedBox(width: 8),
                GoldButton(text: '起卦', onPressed: _busy ? null : _onDivine),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                DarkButton(text: '🎲 随机', onPressed: _busy ? null : _onRandom),
                DarkButton(text: '🕐 时辰', onPressed: _busy ? null : _onTime),
                DarkButton(text: '↺ 重置', onPressed: _onReset),
              ],
            ),
          ),
          Expanded(child: _buildResultArea()),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    final r = _result;
    if (r == null) {
      return const Center(
        child: Text('输入数字、随机取数或以时辰起卦',
            style: TextStyle(color: AppColors.textHint)),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      children: [
        DecorativePanel(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '取数 ${r.inputNumbers?.join(" ")}　→　${r.cards.map((c) => c.title).join(" · ")}',
            style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
        if (r.entropy != null) ...[
          const SizedBox(height: 10),
          _entropyCard(r.entropy!),
        ],
        const SizedBox(height: 10),
        for (var i = 0; i < r.cards.length; i++) ...[
          PalaceResultCard(data: r.cards[i]),
          const SizedBox(height: 10),
        ],
        if (r.verdict != null)
          DecorativePanel(
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
      ],
    );
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
