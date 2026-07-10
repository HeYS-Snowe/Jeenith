// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/rng/rng_providers.dart';
import 'router.dart';
import 'theme.dart';

class JeenithApp extends ConsumerWidget {
  const JeenithApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final tracker = ref.watch(touchTrackerProvider);
    return Listener(
      onPointerMove: tracker.onPointerMove,
      child: MaterialApp.router(
        title: '志极',
        theme: appTheme(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
