// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/name_test_page.dart';

class NameTestTech extends DivinationTech {
  const NameTestTech();

  @override
  String get id => 'name_test';

  @override
  TechMeta get meta => const TechMeta(
        id: 'name_test',
        displayName: '测名字',
        subtitle: '五格剖象',
        description: '姓名康熙笔画，按五格数理断吉凶。',
        accentColor: AppColors.earth,
        sortOrder: 11,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const NameTestPage();
}
