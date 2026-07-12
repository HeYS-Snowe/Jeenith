// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/jiaobei_page.dart';

class JiaobeiTech extends DivinationTech {
  const JiaobeiTech();

  @override
  String get id => 'jiaobei';

  @override
  TechMeta get meta => const TechMeta(
        id: 'jiaobei',
        displayName: '掷筊',
        subtitle: '杯筊问事',
        description: '两片杯筊掷地，圣筊/笑筊/阴筊，问一事之可否。',
        accentColor: AppColors.earth, // 木色·古朴
        sortOrder: 3,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const JiaobeiPage();
}
