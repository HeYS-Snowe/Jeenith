// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../divination/divination_tech.dart';
import '../../features/jiaobei/jiaobei_tech.dart';
import '../../features/meihua/meihua_tech.dart';
import '../../features/qimen/qimen_tech.dart';
import '../../features/xiaoliuren/xiaoliuren_tech.dart';
import '../../features/zhouyi/zhouyi_tech.dart';
import '../../features/ziwei/ziwei_tech.dart';

/// ★ 核心注册表：添加新术 = 在此列表追加一行 + 新建 feature 目录 ★
///
/// 加新术步骤（以紫微斗数为例）：
///   1. 新建 features/ziwei/ 目录（data/algorithm/state/ui/ziwei_tech.dart）
///   2. 在此追加：ZiweiTech(),
/// 完成。无需修改 core/ 或 shared/ 任何代码。
final divinationTechsProvider = Provider<List<DivinationTech>>((ref) {
  final techs = <DivinationTech>[
    XiaoliurenTech(),
    ZhouyiTech(),
    MeihuaTech(),
    JiaobeiTech(),
    ZiweiTech(),
    QimenTech(),
  ];
  // ID 必须唯一，否则 techByIdProvider.firstOrNull 会静默命中错误项。
  assert(
    techs.map((t) => t.id).toSet().length == techs.length,
    'Duplicate DivinationTech id detected',
  );
  return techs;
});

/// 按 ID 查找（路由用）。
final techByIdProvider =
    Provider.family<DivinationTech?, String>((ref, id) {
  return ref
      .watch(divinationTechsProvider)
      .where((t) => t.id == id)
      .firstOrNull;
});

/// 首页排序后的可用列表。
final visibleTechsProvider = Provider<List<DivinationTech>>((ref) {
  return ref
      .watch(divinationTechsProvider)
      .where((t) => t.meta.enabled)
      .toList()
    ..sort((a, b) => a.meta.sortOrder.compareTo(b.meta.sortOrder));
});
