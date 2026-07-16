// Copyright (c) 2026 Qore
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import 'dark_button.dart';

/// 「分享结果」按钮：通过 [RepaintBoundary] 截图结果区域为 PNG，写临时文件后调系统分享。
///
/// 用法：
///   1. 在结果区外层包 `RepaintBoundary(key: boundaryKey, child: ...)`
///   2. 与 [CopyResultButton] 并列放置本按钮，传入同一 `boundaryKey`。
class ShareResultButton extends StatelessWidget {
  final GlobalKey boundaryKey;
  final bool enabled;
  final String? fallbackText;

  const ShareResultButton({
    super.key,
    required this.boundaryKey,
    this.enabled = true,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    return DarkButton(
      icon: const Icon(Icons.ios_share, color: AppColors.textPrimary, size: 18),
      text: '分享结果',
      onPressed: enabled ? () => _share(context) : null,
    );
  }

  Future<void> _share(BuildContext context) async {
    try {
      final boundaryObj = boundaryKey.currentContext?.findRenderObject();
      if (boundaryObj is! RenderRepaintBoundary) {
        _fallbackShare();
        return;
      }
      final image = await boundaryObj.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        _fallbackShare();
        return;
      }
      final bytes = byteData.buffer.asUint8List();
      final tmpDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tmpDir.path}/jeenith_share_$ts.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (_) {
      _fallbackShare();
    }
  }

  Future<void> _fallbackShare() async {
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      await Share.share(fallbackText!);
    }
  }
}
