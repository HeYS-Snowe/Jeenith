// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/config_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/section_title.dart';

/// 设置页：动画设置（按卜算术分类的可收放列表）+ 随机与展示。
///
/// 加新术的动画设置时，在「动画设置」下追加一个 ExpansionTile 即可。
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
            const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (e, _) => Center(child: Text('载入失败：$e')),
        data: (c) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const SectionTitle('◆ 动画设置'),
            const SizedBox(height: 4),
            _card(
              context,
              children: [
                ExpansionTile(
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  iconColor: AppColors.gold,
                  collapsedIconColor: AppColors.textSubtitle,
                  title: const Text('小六壬',
                      style: TextStyle(
                          color: AppColors.goldBright,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  children: [
                    SwitchListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      title: const Text('仪式入场动画',
                          style: TextStyle(color: AppColors.textPrimary)),
                      subtitle: const Text(
                          '点击卡片后，太极生六宫的过渡动画（关闭则直接进入）',
                          style:
                              TextStyle(color: AppColors.textSubtitle, fontSize: 12)),
                      value: c.xiaoliurenCinematic,
                      onChanged: (v) => ref
                          .read(configProvider.notifier)
                          .setXiaoliurenCinematic(v),
                    ),
                  ],
                ),
                // 后续新术的动画设置在此追加 ExpansionTile
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
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.22)),
      ),
      child: Column(children: children),
    );
  }
}
