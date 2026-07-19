// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/chenggu_page.dart';

class ChengguTech extends DivinationTech {
  const ChengguTech();

  @override
  String get id => 'chenggu';

  @override
  TechMeta get meta => const TechMeta(
        id: 'chenggu',
        displayName: '称骨算命',
        subtitle: '袁天罡称骨',
        description: '以农历生辰查年月日时四骨重，相加得总骨重，对照称骨歌断一生命格。',
        accentColor: AppColors.fire,
        sortOrder: 12,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const ChengguPage();
}
