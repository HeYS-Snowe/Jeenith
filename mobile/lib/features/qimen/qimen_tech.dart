// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/qimen_page.dart';

class QimenTech extends DivinationTech {
  const QimenTech();

  @override
  String get id => 'qimen';

  @override
  TechMeta get meta => const TechMeta(
        id: 'qimen',
        displayName: '奇门遁甲',
        subtitle: '时家奇门',
        description: '以时辰定阴阳遁与局数，排奇门局盘。',
        accentColor: AppColors.fire, // 奇门·朱
        sortOrder: 5,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const QimenPage();
}
