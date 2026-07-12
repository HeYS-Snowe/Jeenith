// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/rng/rng_providers.dart';
import 'shared/widgets/starfield.dart';
import 'router/app_router.dart';

class JeenithApp extends ConsumerWidget {
  const JeenithApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final tracker = ref.watch(touchTrackerProvider);
    return Listener(
      onPointerMove: tracker.onPointerMove,
      onPointerHover: tracker.onPointerHover,
      child: MaterialApp.router(
        title: '志极',
        theme: appTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ColoredBox(
          color: AppColors.bg,
          child: Stack(
            children: [
              const Positioned.fill(child: Starfield()),
              if (child != null) Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
