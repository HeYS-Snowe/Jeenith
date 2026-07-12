// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/branding.dart';
import '../../core/config/config_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_registry.dart';
import '../../shared/widgets/entrance_item.dart';
import '../../shared/widgets/guide_dialog.dart';
import '../../shared/widgets/interactable_card.dart';

/// 首页：选术卡片 grid。读 [visibleTechsProvider]，新术自动出现。
///
/// 点选某术时整体上浮淡出（退出动画），再导航。小六壬在开启「仪式入场动画」
/// 时走 `/ritual/xiaoliuren`（太极生六宫过渡），否则直接进 `/tech/:id`。
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _exit;
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowGuide());
  }

  /// 首次启动后弹出「使用方法」，关闭后用 SharedPreferences 记为已读，不再弹。
  Future<void> _maybeShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('hasSeenGuide') ?? false) return;
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const GuideDialog(),
    );
    if (!mounted) return;
    await prefs.setBool('hasSeenGuide', true);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _exit.dispose();
    super.dispose();
  }

  /// 点选某术：小六壬在开启仪式动画时走仪式路由，其余直接进。
  void _onTapTech(String id) {
    if (_exiting) return;
    final cinematic =
        ref.read(configProvider).valueOrNull?.xiaoliurenCinematic ?? true;
    final target = (id == 'xiaoliuren' && cinematic)
        ? '/ritual/xiaoliuren'
        : '/tech/$id';
    _startExit(() => context.go(target));
  }

  void _startExit(void Function() then) {
    if (_exiting) return;
    _exiting = true;
    _exit.forward().then((_) {
      if (mounted) then();
    });
  }

  /// 首页置顶的「使用方法」卡片（可收起，默认展开）。
  Widget _guideCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.30)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.gold,
        collapsedIconColor: AppColors.textSubtitle,
        dense: true,
        title: const Row(
          children: [
            Icon(Icons.menu_book, color: AppColors.goldBright, size: 18),
            SizedBox(width: 6),
            Text('使用方法',
                style: TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
          ],
        ),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. 单一卜算术起卦',
                    style: TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Text('第一次问大致的问题，第二次问细致的问题。',
                    style: TextStyle(
                        color: AppColors.textBody, fontSize: 12, height: 1.5)),
                SizedBox(height: 8),
                Text('2. 多卜算术组合使用',
                    style: TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Text('先用一种卜算术起卦问大致的问题，再用另外一种起卦问细节上的问题。',
                    style: TextStyle(
                        color: AppColors.textBody, fontSize: 12, height: 1.5)),
                SizedBox(height: 8),
                Text('3. 可以将卦象的完整截图和问题一并发送给 AI，也可以自己查资料。',
                    style: TextStyle(
                        color: AppColors.textBody, fontSize: 12, height: 1.5)),
                SizedBox(height: 6),
                Text('4. 点击起卦按钮前，心里默念问题，集中注意力，注意力达到顶点的一刹那起卦。',
                    style: TextStyle(
                        color: AppColors.textBody, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final techs = ref.watch(visibleTechsProvider);
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _exit,
          builder: (context, child) => Opacity(
            opacity: 1 - _exit.value,
            child: Transform.translate(
              offset: Offset(0, -36 * _exit.value),
              child: child,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 44),
                  EntranceItem(
                    animation: _entrance,
                    interval: const Interval(0.0, 0.30),
                    slide: 18,
                    child: Text(
                      Branding.appName,
                      style: const TextStyle(
                        color: AppColors.goldBright,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  EntranceItem(
                    animation: _entrance,
                    interval: const Interval(0.12, 0.40),
                    slide: 14,
                    child: Text(
                      Branding.tagline,
                      style: const TextStyle(
                        color: AppColors.textSubtitle,
                        fontSize: 12,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  EntranceItem(
                    animation: _entrance,
                    interval: const Interval(0.20, 0.50),
                    child: _guideCard(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.86,
                      children: [
                        for (var i = 0; i < techs.length; i++)
                          Builder(builder: (context) {
                            final meta = techs[i].meta;
                            return InteractableCard(
                              entrance: _entrance,
                              interval:
                                  Interval(0.28 + i * 0.08, (0.62 + i * 0.08).clamp(0.0, 1.0).toDouble()),
                              color: meta.accentColor,
                              onTap: () => _onTapTech(meta.id),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: meta.accentColor
                                          .withValues(alpha: 0.28),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.auto_awesome,
                                        color: meta.accentColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    meta.displayName,
                                    style: TextStyle(
                                      color: meta.accentColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    meta.subtitle,
                                    style: const TextStyle(
                                      color: AppColors.textSubtitle,
                                      fontSize: 12,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    meta.description,
                                    style: const TextStyle(
                                      color: AppColors.textBody,
                                      fontSize: 11,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  EntranceItem(
                    animation: _entrance,
                    interval: const Interval(0.78, 1.0),
                    slide: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        Branding.copyright,
                        style: const TextStyle(
                            color: AppColors.textHint, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              // 左上角历史记录按钮
              Positioned(
                top: 6,
                left: 6,
                child: IconButton(
                  icon: const Icon(Icons.history,
                      color: AppColors.textSubtitle),
                  tooltip: '历史记录',
                  onPressed: () => _startExit(() => context.go('/history')),
                ),
              ),
              // 右上角设置按钮
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: AppColors.textSubtitle),
                  tooltip: '设置',
                  onPressed: () => _startExit(() => context.go('/settings')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
