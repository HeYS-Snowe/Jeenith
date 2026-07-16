// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/daliuren_page.dart';

class DaliurenTech extends DivinationTech {
  const DaliurenTech();

  @override
  String get id => 'daliuren';

  @override
  TechMeta get meta => const TechMeta(
        id: 'daliuren',
        displayName: '大六壬',
        subtitle: '三传四课',
        description: '以月将加占时定天盘，推四课三传、十二天将。',
        accentColor: AppColors.earth, // 大六壬·土
        sortOrder: 8,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const DaliurenPage();
}
