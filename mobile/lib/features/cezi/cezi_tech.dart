// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/cezi_page.dart';

class CeziTech extends DivinationTech {
  const CeziTech();

  @override
  String get id => 'cezi';

  @override
  TechMeta get meta => const TechMeta(
        id: 'cezi',
        displayName: '测字',
        subtitle: '一字一玄机',
        description: '拆字笔画，按五行定吉凶，一字一断。',
        accentColor: AppColors.waterDeep,
        sortOrder: 7,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const CeziPage();
}
