// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/zhouyi_page.dart';

class ZhouyiTech extends DivinationTech {
  const ZhouyiTech();

  @override
  String get id => 'zhouyi';

  @override
  TechMeta get meta => const TechMeta(
        id: 'zhouyi',
        displayName: '周易',
        subtitle: '金钱卦',
        description: '三铜钱摇六爻，得本卦与之卦，以断吉凶。',
        accentColor: AppColors.gold,
        sortOrder: 1,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const ZhouyiPage();
}
