// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/app/restart_controller.dart';
import 'core/config/platform_info.dart';
import 'data/yijing/hexagram_texts.dart';

/// 桌面端窗口最小尺寸（防止 UI 压崩；略小于目标宽度让 targetWidth 能生效）。
const _kMinWindowSize = Size(420, 700);

/// 高度撑满时给任务栏等留的垂直边距。
const _kVerticalMargin = 40.0;

/// 模拟手机竖屏比例（高/宽 ≈ 2.18，接近主流手机）。
const _kPhoneAspect = 9.0 / 19.6;

/// 桌面端目标窗口高度钳制范围。
const _kHeightMin = 600.0;
const _kHeightMax = 1600.0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformInfo.isDesktop) {
    await windowManager.ensureInitialized();

    final display = await ScreenRetriever.instance.getPrimaryDisplay();
    // screen_retriever 的 Display.size / visibleSize 已经是逻辑像素
    // （DPI-aware），不能再除以 scaleFactor，否则会把窗口算得过小。
    // visibleSize 已扣任务栏/Dock，没有则回退 size。
    final logical = display.visibleSize ?? display.size;
    final screenH = logical.height;

    // 高度撑满（留 _kVerticalMargin 边距），宽度按手机比例自适应。
    final targetHeight = (screenH - _kVerticalMargin).clamp(
      _kHeightMin,
      _kHeightMax,
    );
    final targetWidth = targetHeight * _kPhoneAspect;

    final windowOptions = WindowOptions(
      size: Size(targetWidth, targetHeight),
      minimumSize: _kMinWindowSize,
      center: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
  }

  // 预加载 64 卦卦辞爻辞到内存（周易/梅花结果页同步查询用）
  await HexagramTexts.load();

  runApp(const _JeenithRoot());
}

/// 根 widget：监听 [RestartController]，重启时更换 [ProviderScope] 的 key，
/// 使整个 widget 树（含所有 Riverpod 状态）从已更新的 SharedPreferences
/// 重新初始化（v2.11.0）。
class _JeenithRoot extends StatefulWidget {
  const _JeenithRoot();

  @override
  State<_JeenithRoot> createState() => _JeenithRootState();
}

class _JeenithRootState extends State<_JeenithRoot> {
  @override
  void initState() {
    super.initState();
    RestartController.instance.addListener(_onRestart);
  }

  @override
  void dispose() {
    RestartController.instance.removeListener(_onRestart);
    super.dispose();
  }

  void _onRestart() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: ValueKey('scope-${RestartController.instance.value}'),
      child: const JeenithApp(),
    );
  }
}
