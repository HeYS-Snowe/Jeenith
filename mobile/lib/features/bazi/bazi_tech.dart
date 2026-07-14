// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/bazi_page.dart';

class BaziTech extends DivinationTech {
  const BaziTech();

  @override
  String get id => 'bazi';

  @override
  TechMeta get meta => const TechMeta(
        id: 'bazi',
        displayName: '八字推演',
        subtitle: '四柱命理',
        description: '依生辰排四柱、起大运、查神煞，批断先天命格与五行喜忌。',
        accentColor: AppColors.earth,
        sortOrder: 10,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const BaziPage();
}
