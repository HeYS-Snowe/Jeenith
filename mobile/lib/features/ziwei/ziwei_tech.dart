// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/ziwei_page.dart';

class ZiweiTech extends DivinationTech {
  const ZiweiTech();

  @override
  String get id => 'ziwei';

  @override
  TechMeta get meta => const TechMeta(
        id: 'ziwei',
        displayName: '紫微斗数',
        subtitle: '命盘排盘',
        description: '以生辰定命身宫、十二宫与五行局，排紫微命盘。',
        accentColor: AppColors.waterDeep, // 紫·深青
        sortOrder: 4,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const ZiweiPage();
}
