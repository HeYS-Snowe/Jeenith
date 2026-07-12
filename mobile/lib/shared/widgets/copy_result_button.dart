// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import 'dark_button.dart';

/// 「复制结果」按钮：一键复制详细结果文本到剪贴板，并 SnackBar 提示。
class CopyResultButton extends StatelessWidget {
  final String text;
  final bool enabled;
  const CopyResultButton({super.key, required this.text, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return DarkButton(
      icon: const Icon(Icons.copy_all, color: AppColors.textPrimary, size: 18),
      text: '复制结果',
      onPressed: enabled
          ? () async {
              await Clipboard.setData(ClipboardData(text: text));
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
          : null,
    );
  }
}
