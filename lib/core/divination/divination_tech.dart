// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 卜算术展示元数据（首页卡片 + 路由用）。
@immutable
class TechMeta {
  final String id;            // 路由参数，如 'xiaoliuren'
  final String displayName;   // '小六壬'
  final String subtitle;      // '掐指神课'
  final String description;   // 卡片描述
  final Color accentColor;    // 卡片主题色
  final int sortOrder;        // 首页排列顺序
  final bool enabled;         // 功能开关（开发中可隐藏）

  const TechMeta({
    required this.id,
    required this.displayName,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    this.sortOrder = 99,
    this.enabled = true,
  });
}

/// 卜算术抽象。
///
/// 每种术实现此接口，页面内自行管理输入采集、起卦调用、动画与结果展示。
/// 框架只统一提供：注册发现、RNG 服务、配置、主题、共享组件。
/// 加新术 = 新建 feature 目录 + 实现本接口 + 在 registry 注册一行。
abstract class DivinationTech {
  /// 唯一标识（路由 /tech/:id）。
  String get id;

  /// 展示元数据。
  TechMeta get meta;

  /// 是否使用 TrueRandom 服务。
  bool get usesTrueRandom => false;

  /// 构建该术主页面。框架提供 [ref] 供访问 providers。
  Widget buildPage(BuildContext context, WidgetRef ref);
}
