// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/animation/ritual/cezi_ritual.dart';
import '../core/animation/ritual/chouqian_ritual.dart';
import '../core/animation/ritual/daliuren_ritual.dart';
import '../core/animation/ritual/jiaobei_ritual.dart';
import '../core/animation/ritual/luopan_ritual.dart';
import '../core/animation/ritual/meihua_ritual.dart';
import '../core/animation/ritual/qimen_ritual.dart';
import '../core/animation/ritual/ziwei_ritual.dart';
import '../core/animation/ritual/zhouyi_ritual.dart';
import '../core/animation/transitions/tech_transitions.dart';
import '../core/config/config_providers.dart';
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
      GoRoute(path: '/manual', builder: (context, state) => const ManualPage()),
      // 小六壬仪式入场动画（点卡片 → 太极生六宫 → 进入小六壬页）
      GoRoute(
        path: '/ritual/xiaoliuren',
        builder: (context, state) =>
            XiaoliurenRitual(onCompleted: () => context.go('/tech/xiaoliuren')),
      ),
      // v2.1.0 仪式入场动画：周易铜钱抛落（5s，6 轮金钱卦）
      GoRoute(
        path: '/ritual/zhouyi',
        builder: (context, state) =>
            ZhouyiRitual(onCompleted: () => context.go('/tech/zhouyi')),
      ),
      // v2.1.0 仪式入场动画：紫微命盘展开（6s，12 宫辐射 + 14 主星降落）
      GoRoute(
        path: '/ritual/ziwei',
        builder: (context, state) =>
            ZiweiRitual(onCompleted: () => context.go('/tech/ziwei')),
      ),
      // v2.1.0 仪式入场动画：奇门九宫飞布（5s，值符值使 + 八门九星八神）
      GoRoute(
        path: '/ritual/qimen',
        builder: (context, state) =>
            QimenRitual(onCompleted: () => context.go('/tech/qimen')),
      ),
      // v2.1.0 仪式入场动画：大六壬双盘旋转（5s，天盘顺/地盘逆 + 四课三传）
      GoRoute(
        path: '/ritual/daliuren',
        builder: (context, state) =>
            DaliurenRitual(onCompleted: () => context.go('/tech/daliuren')),
      ),
      // v2.1.0 仪式入场动画：风水罗盘扫描（4s，指针扫描 + 24 山依次点亮）
      GoRoute(
        path: '/ritual/luopan',
        builder: (context, state) =>
            LuopanRitual(onCompleted: () => context.go('/tech/luopan')),
      ),
      // v2.2.0 仪式入场动画：梅花数字撞击（4s，两数飘落 + 撞击爆发 + 卦象淡入）
      GoRoute(
        path: '/ritual/meihua',
        builder: (context, state) =>
            MeihuaRitual(onCompleted: () => context.go('/tech/meihua')),
      ),
      // v2.2.0 仪式入场动画：掷筊翻转落地（3s，杯筊抛物线 + 翻滚 + 结果定型）
      GoRoute(
        path: '/ritual/jiaobei',
        builder: (context, state) =>
            JiaobeiRitual(onCompleted: () => context.go('/tech/jiaobei')),
      ),
      // v2.2.0 仪式入场动画：抽签卷轴展开（5s，签筒摇晃 + 签条跳出 + 卷轴展开 + 笔锋书写）
      GoRoute(
        path: '/ritual/chouqian',
        builder: (context, state) =>
            ChouqianRitual(onCompleted: () => context.go('/tech/chouqian')),
      ),
      // v2.2.0 仪式入场动画：测字字形浮现 + 五行色染（5s，道字浮现 + 木色扩散）
      GoRoute(
        path: '/ritual/cezi',
        builder: (context, state) =>
            CeziRitual(onCompleted: () => context.go('/tech/cezi')),
      ),
      GoRoute(
        path: '/tech/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final tech = ref.read(techByIdProvider(id));
          final Widget page = (tech == null)
              ? const Scaffold(body: Center(child: Text('未知卜算法')))
              : _TechPage(tech: tech);
          // v2.3.0: per-tech signature transition; falls back to fade
          // when the tech's animation setting is off.
          final transitionsEnabled =
              ref.read(configProvider).valueOrNull?.isAnimationEnabled(id) ?? true;
          return TechTransition.build(
            key: state.pageKey,
            child: page,
            techId: id,
            transitionsEnabled: transitionsEnabled,
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
