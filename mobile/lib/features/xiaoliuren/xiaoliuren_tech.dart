// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/xiaoliuren_page.dart';

class XiaoliurenTech extends DivinationTech {
  const XiaoliurenTech();

  @override
  String get id => 'xiaoliuren';

  @override
  TechMeta get meta => const TechMeta(
        id: 'xiaoliuren',
        displayName: '小六壬',
        subtitle: '掐指神课',
        description: '从大安起数，三段掐指游走六宫，以落宫五行六神断吉凶。',
        accentColor: AppColors.gold,
        sortOrder: 0,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) =>
      const XiaoliurenPage();
}
