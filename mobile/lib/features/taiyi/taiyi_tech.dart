// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/taiyi_page.dart';

class TaiyiTech extends DivinationTech {
  const TaiyiTech();

  @override
  String get id => 'taiyi';

  @override
  TechMeta get meta => const TechMeta(
        id: 'taiyi',
        displayName: '太乙神数',
        subtitle: '三式之首',
        description: '以太乙积年推演太乙落宫、文昌始击、主客算与格局，断主客胜负吉凶。',
        accentColor: AppColors.goldBright,
        sortOrder: 13,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const TaiyiPage();
}
