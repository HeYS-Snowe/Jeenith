// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/luopan_page.dart';

class LuopanTech extends DivinationTech {
  const LuopanTech();

  @override
  String get id => 'luopan';

  @override
  TechMeta get meta => const TechMeta(
        id: 'luopan',
        displayName: '风水罗盘',
        subtitle: '二十四山',
        description: '磁力计实时定方位，二十四山外加八卦方位。',
        accentColor: AppColors.metal, // 罗盘·金
        sortOrder: 9,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const LuopanPage();
}
