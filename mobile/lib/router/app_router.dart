// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/divination/divination_registry.dart';
import '../core/divination/divination_tech.dart';
import '../features/home/home_page.dart';
import '../features/history/history_page.dart';
import '../features/manual/manual_page.dart';
import '../features/settings/settings_page.dart';
import '../features/xiaoliuren/ui/xiaoliuren_ritual.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/manual',
        builder: (context, state) => const ManualPage(),
      ),
      // 小六壬仪式入场动画（点卡片 → 太极生六宫 → 进入小六壬页）
      GoRoute(
        path: '/ritual/xiaoliuren',
        builder: (context, state) => XiaoliurenRitual(
          onCompleted: () => context.go('/tech/xiaoliuren'),
        ),
      ),
      GoRoute(
        path: '/tech/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final tech = ref.read(techByIdProvider(id));
          final Widget page = (tech == null)
              ? const Scaffold(body: Center(child: Text('未知卜算法')))
              : _TechPage(tech: tech);
          return CustomTransitionPage(
            key: state.pageKey,
            child: page,
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 280),
            transitionsBuilder: (context, animation, secondary, child) {
              final curved = CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale:
                      Tween<double>(begin: 0.92, end: 1.0).animate(curved),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    ],
  );
});

class _TechPage extends ConsumerWidget {
  final DivinationTech tech;
  const _TechPage({required this.tech});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      tech.buildPage(context, ref);
}
