// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import 'dark_button.dart';

/// 「复制结果」按钮：一键复制详细结果文本到剪贴板，并 SnackBar 提示。
///
/// v2.3.1：复制成功后图标从 `copy_all` → `check` 旋转切换（Phase 5 微动效），
/// 1.6s 后回到原图标。
class CopyResultButton extends StatefulWidget {
  final String text;
  final bool enabled;
  const CopyResultButton({super.key, required this.text, this.enabled = true});

  @override
  State<CopyResultButton> createState() => _CopyResultButtonState();
}

class _CopyResultButtonState extends State<CopyResultButton> {
  bool _copied = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _onCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    if (!mounted) return;
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已复制详细结果到剪贴板'),
          backgroundColor: AppColors.card,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 切换图标：复制成功后用 check 旋转入场
    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 0.0).animate(anim),
          child: ScaleTransition(scale: anim, child: child),
        );
      },
      child: _copied
          ? const Icon(Icons.check,
              key: ValueKey('check'),
              color: AppColors.goldBright,
              size: 18)
          : const Icon(Icons.copy_all,
              key: ValueKey('copy'),
              color: AppColors.textPrimary,
              size: 18),
    );
    return DarkButton(
      icon: icon,
      text: _copied ? '已复制' : '复制结果',
      onPressed: widget.enabled ? _onCopy : null,
    );
  }
}
