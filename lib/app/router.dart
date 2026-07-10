// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/divination/divination_registry.dart';
import '../core/divination/divination_tech.dart';
import '../features/home/home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/tech/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final tech = ref.read(techByIdProvider(id));
          if (tech == null) {
            return const Scaffold(body: Center(child: Text('未知卜算法')));
          }
          return _TechPage(tech: tech);
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
