// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/divination/divination_tech.dart';
import 'ui/liuyao_page.dart';

class LiuyaoTech extends DivinationTech {
  const LiuyaoTech();

  @override
  String get id => 'liuyao';

  @override
  TechMeta get meta => const TechMeta(
        id: 'liuyao',
        displayName: '六爻',
        subtitle: '纳甲断卦',
        description: '金钱卦摇六爻，京房纳甲配六亲六神、定世应用神，以断吉凶成败。',
        accentColor: AppColors.gold,
        sortOrder: 14,
      );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const LiuyaoPage();
}
