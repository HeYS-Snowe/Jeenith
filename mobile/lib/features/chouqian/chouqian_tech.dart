// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/chouqian_page.dart';

class ChouqianTech extends DivinationTech {
  const ChouqianTech();

  @override
  String get id => 'chouqian';

  @override
  TechMeta get meta => const TechMeta(
        id: 'chouqian',
        displayName: '抽签',
        subtitle: '百签问运',
        description: '摇签筒取一签，三十签诗问吉凶祸福。',
        accentColor: AppColors.wood,
        sortOrder: 6,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const ChouqianPage();
}
