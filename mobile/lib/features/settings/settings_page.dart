// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/config/config_providers.dart';
import '../../core/divination/divination_registry.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/divination_loading_indicator.dart';
import '../../shared/widgets/section_title.dart';

/// 设置页：外观 + 动画/动效（按卜算术分类，一键全控）+ 随机与展示。
///
/// v2.3.0: 原本分散的「动效」（4 个 sub-switch）与「动画设置」（按术 ExpansionTile）
/// 合并为单一的「◆ 动画/动效」分区。顶部为微交互动效总开关（按钮缩放/图标旋转等
/// 全局微交互），其下为「开启所有分类 / 关闭所有分类」两枚一键按钮，再下按术数
/// 列出 ExpansionTile，每术一个开关，统一写入 `AppConfig.animationSettings` Map。
///
/// v2.3.2: 每术 ExpansionTile 内拆分为 4 个细分开关（入场仪式 / 路由转场 /
/// 绘制过程 / 结果揭示），由 `AppConfig.isAnimationEnabled(techId, kind)` 读取，
/// 写入 prefs key `anim_<techId>_<kind>`。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(configProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('设　置'),
      ),
      body: configAsync.when(
        loading: () =>
            const Center(child: DivinationLoadingIndicator(size: 48)),
        error: (e, _) => Center(child: Text('载入失败：$e')),
        data: (c) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const SectionTitle('◆ 外观'),
            const SizedBox(height: 4),
            _card(
              context,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Row(
                    children: [
                      const Text('主题模式',
                          style: TextStyle(color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      const Text('跟随系统/浅色/深色',
                          style: TextStyle(
                              color: AppColors.textSubtitle, fontSize: 12)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto),
                        label: Text('跟随'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('浅色'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('深色'),
                      ),
                    ],
                    selected: {c.themeMode},
                    onSelectionChanged: (modes) => ref
                        .read(configProvider.notifier)
                        .setThemeMode(modes.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const SectionTitle('◆ 动画/动效'),
            const SizedBox(height: 4),
            _card(
              context,
              children: [
                // 微交互动效总开关（按钮缩放/图标旋转/卡片错峰等全局微交互）
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  title: const Text('启用微交互动效',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text(
                      '按钮按动缩放/图标状态切换/卡片错峰等微交互（关闭后不影响功能）',
                      style:
                          TextStyle(color: AppColors.textSubtitle, fontSize: 12)),
                  value: c.animationsEnabled,
                  onChanged: (v) => ref
                      .read(configProvider.notifier)
                      .setAnimationsEnabled(v),
                ),
                const Divider(color: Color.fromRGBO(212, 168, 87, 0.18), height: 1),
                // 一键全控按钮区
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.select_all, size: 16),
                          label: const Text('开启所有分类'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.goldBright,
                            side: BorderSide(
                                color: AppColors.gold.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => ref
                              .read(configProvider.notifier)
                              .setAllAnimations(
                                  ref.read(visibleTechsProvider).map((t) => t.id).toList(),
                                  true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.deselect, size: 16),
                          label: const Text('关闭所有分类'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSubtitle,
                            side: BorderSide(
                                color: AppColors.textSubtitle.withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => ref
                              .read(configProvider.notifier)
                              .setAllAnimations(
                                  ref.read(visibleTechsProvider).map((t) => t.id).toList(),
                                  false),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color.fromRGBO(212, 168, 87, 0.18), height: 1),
                // 按术数分类的 ExpansionTile 列表
                ...ref.watch(visibleTechsProvider).map((t) => ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      iconColor: AppColors.gold,
                      collapsedIconColor: AppColors.textSubtitle,
                      title: Text(t.meta.displayName,
                          style: const TextStyle(
                              color: AppColors.goldBright,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      children: [
                        // v2.3.2: 4 个细分开关
                        _kindSwitch(c, ref, t.id, AnimationKind.entrance,
                            '入场仪式', '仪式入场动画（路由前置过渡）'),
                        _kindSwitch(c, ref, t.id, AnimationKind.transition,
                            '路由转场', '进入此术时的路由过渡动画'),
                        _kindSwitch(c, ref, t.id, AnimationKind.painter,
                            '绘制过程', 'CustomPainter 绘制过程动画'),
                        _kindSwitch(c, ref, t.id, AnimationKind.reveal,
                            '结果揭示', '结果段落错峰淡入与打字机'),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 20),

            const SectionTitle('◆ 随机与展示'),
            const SizedBox(height: 4),
            _card(
              context,
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  title: const Text('展示采样详情',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('随机起卦后展示各熵源的真实采样值',
                      style:
                          TextStyle(color: AppColors.textSubtitle, fontSize: 12)),
                  value: c.showDetails,
                  onChanged: (v) =>
                      ref.read(configProvider.notifier).setShowDetails(v),
                ),
                const Divider(color: Color.fromRGBO(212, 168, 87, 0.18), height: 1),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  title: const Text('在线大气噪声',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('联网取 random.org 真随机增强熵源',
                      style:
                          TextStyle(color: AppColors.textSubtitle, fontSize: 12)),
                  value: c.useOnline,
                  onChanged: (v) =>
                      ref.read(configProvider.notifier).setUseOnline(v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '志极 Jeenith · 叩问本心，不忘初心\nCopyright (c) 2026 Qore',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textHint, fontSize: 11, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.22)),
      ),
      child: Column(children: children),
    );
  }

  /// 单个细分动画开关：紧凑型 SwitchListTile，左对齐缩进 20，subtitle 12px。
  Widget _kindSwitch(
    AppConfig c,
    WidgetRef ref,
    String techId,
    AnimationKind kind,
    String title,
    String subtitle,
  ) =>
      SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        dense: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: AppColors.textSubtitle, fontSize: 11)),
        value: c.isAnimationEnabled(techId, kind),
        onChanged: (v) => ref
            .read(configProvider.notifier)
            .setAnimationSetting(techId, kind, v),
      );
}
