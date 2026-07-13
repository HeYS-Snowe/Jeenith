// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/config/config_providers.dart';
import 'core/rng/rng_providers.dart';
import 'shared/widgets/starfield.dart';
import 'router/app_router.dart';

class JeenithApp extends ConsumerWidget {
  const JeenithApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final tracker = ref.watch(touchTrackerProvider);
    final config = ref.watch(configProvider).valueOrNull;
    final isLightOuter = _effectiveLight(context, config);
    return Listener(
      onPointerMove: tracker.onPointerMove,
      onPointerHover: tracker.onPointerHover,
      child: MaterialApp.router(
        title: '志极',
        theme: appTheme(isLight: isLightOuter),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final isLight = _effectiveLight(context, config);
          return ColoredBox(
            color: isLight ? AppColorsLight.bg : AppColors.bg,
            child: Stack(
              children: [
                Positioned.fill(child: Starfield(isLight: isLight)),
                if (child != null) Positioned.fill(child: child),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 根据 themeMode + 系统亮度计算实际是否浅色主题。
  bool _effectiveLight(BuildContext context, AppConfig? config) {
    final mode = config?.themeMode ?? ThemeMode.system;
    switch (mode) {
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.light;
    }
  }
}
