// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/meihua_page.dart';

class MeihuaTech extends DivinationTech {
  const MeihuaTech();

  @override
  String get id => 'meihua';

  @override
  TechMeta get meta => const TechMeta(
        id: 'meihua',
        displayName: '梅花易数',
        subtitle: '数字起卦',
        description: '以两个数取上下卦与动爻，分体用、观生克。',
        accentColor: AppColors.wood, // 梅花·苍绿
        sortOrder: 2,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const MeihuaPage();
}
