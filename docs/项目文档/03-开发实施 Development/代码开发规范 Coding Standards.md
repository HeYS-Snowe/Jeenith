# 代码开发规范 Coding Standards

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 技术栈 Tech Stack | Flutter 3.x（Dart 3.11+） |
| 开发者 Developer | HeYS-Snowe |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本，基于项目实际代码风格提炼 |

---

## 目录 Table of Contents

1. [规范概述 Standards Overview](#1-规范概述-standards-overview)
2. [目录结构 Directory Structure](#2-目录结构-directory-structure)
3. [命名规范 Naming Conventions](#3-命名规范-naming-conventions)
4. [Dart/Flutter 风格 Dart/Flutter Style](#4-dartflutter-风格-dartflutter-style)
5. [状态管理 State Management](#5-状态管理-state-management)
6. [路由管理 Routing](#6-路由管理-routing)
7. [动效与组件 Animation & Widgets](#7-动效与组件-animation--widgets)
8. [硬约束 Hard Constraints](#8-硬约束-hard-constraints)
9. [注释规范 Comment Standards](#9-注释规范-comment-standards)

---

## 1. 规范概述 Standards Overview

### 1.1 规范目的 Purpose

本文档定义志极 Jeenith 项目的编码规范，确保代码的一致性、可读性和可维护性。所有规范均从项目实际代码风格提炼，遵循 SOLID、DRY、KISS、YAGNI 原则。

### 1.2 适用范围 Scope

适用于 `mobile/lib/` 下全部 Dart 代码，涵盖 core/ 框架层、data/ 数据层、features/ 术数层、shared/ 共享组件层、providers/ 与 router/ 聚合层。

### 1.3 核心原则 Core Principles

| 原则 Principle | 说明 Description |
|--------------|---------------|
| 先看再改 Read before edit | 修改前必须理解上下文与现有风格 |
| 框架与内容分离 Framework/Content Split | core/ 提供框架，features/ 实现术数，互不侵入 |
| 可扩展性 Extensibility | 加新术 = 新建 feature 目录 + 实现 DivinationTech + registry 注册一行 |
| 身份不硬编码 No hardcoded identity | 身份信息以 `D:\Code\.Rules\OrganizationAndUser.md` 为准，代码内通过 Branding 类引用 |

---

## 2. 目录结构 Directory Structure

```
mobile/lib/
├── main.dart                    # 入口（async + ProviderScope + 桌面窗口初始化）
├── app.dart                     # JeenithApp（MaterialApp.router + Starfield + 主题）
├── core/                        # 核心框架层（不依赖 features）
│   ├── animation/               # 动效体系（ritual/transitions/reveal/particles/painters）
│   ├── calendar/                # 农历服务（lunar_service.dart）
│   ├── config/                  # 配置（AppConfig + ConfigNotifier + PlatformInfo）
│   ├── divination/              # 卜算框架（Tech/Registry/Result）
│   ├── history/                 # 历史存储与导出
│   ├── rng/                     # 真随机引擎（多源熵 + TrueRandom）
│   ├── theme/                   # 主题与动效常量（app_theme + animations）
│   └── branding.dart            # 品牌身份常量
├── data/                        # 数据层
│   └── yijing/                  # 周易 64 卦 + 八卦数据（周易/梅花共用）
├── features/                    # 术数实现层（每术一个目录）
│   ├── home/                    # 首页
│   ├── xiaoliuren/              # 小六壬（algorithm/ + ui/ + state/ + data/ + xiaoliuren_tech.dart）
│   ├── zhouyi/                  # 周易
│   ├── meihua/                  # 梅花易数
│   ├── ...（每术结构相同）
│   ├── manual/                  # 使用手册
│   ├── settings/                # 设置
│   └── history/                 # 历史记录页
├── providers/                   # barrel 聚合（providers.dart）
├── router/                      # 路由（app_router.dart，GoRouter + 仪式路由）
└── shared/                      # 共享组件
    └── widgets/                 # GoldButton/DarkButton/Starfield/InteractableCard 等
```

### 2.1 术数 feature 目录约定 Tech Feature Convention

每个术数 feature 目录遵循统一结构：

```
features/<tech_id>/
├── <tech_id>_tech.dart          # 实现 DivinationTech 接口（必须）
├── algorithm/
│   └── divine.dart              # 起卦算法（纯函数，必须）
├── ui/
│   └── <tech_id>_page.dart      # 主页面（必须）
├── data/                        # 常量数据表（可选）
└── state/                       # Riverpod providers（可选）
```

---

## 3. 命名规范 Naming Conventions

| 类型 Type | 风格 Style | 示例 Example |
|----------|----------|------------|
| 类名 Class | UpperCamelCase | `DivinationTech`、`TrueRandom`、`HistoryStore` |
| 变量/方法 Variable/Method | lowerCamelCase | `trueRandomProvider`、`generateId` |
| 常量 Constant | lowerCamelCase | `pressDown`、`cardStagger` |
| 私有成员 Private | 前缀下划线 | `_serialize`、`_chain`、`_key` |
| 文件名 File | lowerCamelCase / snake_case | `divination_tech.dart`、`app_config.dart` |
| Provider | lowerCamelCase + Provider 后缀 | `configProvider`、`trueRandomProvider` |
| 路由路径 Route Path | 小写 + 斜杠 | `/tech/xiaoliuren`、`/ritual/zhouyi` |
| Tech ID | 小写无下划线 / 小写 | `xiaoliuren`、`name_test` |

### 3.1 文件头版权声明 File Header

所有 Dart 文件以版权声明开头：

```dart
// Copyright (c) 2026 Qore. All rights reserved.
```

---

## 4. Dart/Flutter 风格 Dart/Flutter Style

### 4.1 不可变模型 Immutable Models

数据模型使用 `@immutable` 注解 + `const` 构造函数：

```dart
@immutable
class TechMeta {
  final String id;
  final String displayName;
  // ...
  const TechMeta({required this.id, required this.displayName, ...});
}
```

### 4.2 抽象接口 Abstract Interfaces

框架层用 `abstract class` 定义接口，子类用 `const` 构造函数：

```dart
abstract class DivinationTech {
  const DivinationTech();
  String get id;
  TechMeta get meta;
  Widget buildPage(BuildContext context, WidgetRef ref);
}
```

### 4.3 工具类私有构造 Private Constructor

工具类/常量类用私有构造函数防止实例化：

```dart
class AppAnimations {
  AppAnimations._();
  static const int pressDown = 110;
}
```

### 4.4 枚举 Enum

```dart
enum AnimationKind { entrance, transition, painter, reveal }
```

---

## 5. 状态管理 State Management

### 5.1 Riverpod Provider 模式

项目使用 `flutter_riverpod ^2.5`，采用手写 Provider/AsyncNotifier（非 codegen）：

```dart
// 简单 Provider
final touchTrackerProvider = Provider<TouchTracker>((ref) => TouchTracker());

// 依赖其他 Provider
final trueRandomProvider = Provider<TrueRandom>((ref) {
  final config = ref.watch(configProvider).valueOrNull ?? AppConfig.defaults;
  final tracker = ref.watch(touchTrackerProvider);
  return TrueRandom([...]);
});

// AsyncNotifierProvider（配置持久化）
final configProvider = AsyncNotifierProvider<ConfigNotifier, AppConfig>(
  ConfigNotifier.new,
);

// Provider.family（按 ID 查找）
final techByIdProvider = Provider.family<DivinationTech?, String>((ref, id) {
  return ref.watch(divinationTechsProvider).where((t) => t.id == id).firstOrNull;
});
```

### 5.2 Provider 命名约定

- 简单值：`xxxProvider`
- AsyncNotifier：`xxxProvider`（类名 `XxxNotifier`）
- Family：`xxxByIdProvider`

### 5.3 barrel 聚合

`providers/providers.dart` 作为 barrel 文件聚合 config + rng providers，供 features 层统一导入。

---

## 6. 路由管理 Routing

### 6.1 GoRouter 配置

路由集中于 `router/app_router.dart`，通过 `routerProvider` 提供：

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/tech/:id', pageBuilder: (context, state) { ... }),
      GoRoute(path: '/ritual/:id', builder: ...),  // 仪式入场动画
      // ...
    ],
  );
});
```

### 6.2 路由约定

| 路径 Path | 用途 Purpose |
|----------|------------|
| `/` | 首页（选术） |
| `/tech/:id` | 术数主页面（动态路由） |
| `/ritual/:id` | 仪式入场动画（路由前置过渡） |
| `/history` | 历史记录 |
| `/settings` | 设置 |
| `/manual` | 使用手册 |

### 6.3 转场动画

`/tech/:id` 路由使用 `TechTransition.build()` 实现每术专属转场，根据 `AppConfig.isAnimationEnabled(id, AnimationKind.transition)` 控制开关。

---

## 7. 动效与组件 Animation & Widgets

### 7.1 全局动效常量 Global Animation Constants

所有微交互动效的时长、曲线、错峰间隔集中定义于 `core/theme/animations.dart`，禁止在业务代码中硬编码：

```dart
class AppAnimations {
  static const int pressDown = 110;
  static const int pressRelease = 260;
  static const Curve pressReleaseCurve = Cubic(0.34, 1.56, 0.64, 1);
  // ...
}
```

### 7.2 动效开关 Animation Toggle

所有动效可通过设置页全局/分类开关：

- 总开关：`AppConfig.animationsEnabled`
- 分类开关：`AppConfig.isAnimationEnabled(techId, AnimationKind)`（4 类：entrance/transition/painter/reveal）
- 关闭后降级为静态组件，不影响核心功能

### 7.3 共享组件 Shared Widgets

| 组件 Widget | 用途 Purpose |
|------------|------------|
| GoldButton / DarkButton | 主按钮（自带物理反馈） |
| InteractableCard | 可交互卡片 |
| Starfield | 星尘背景 |
| CopyResultButton / ShareResultButton | 结果复制/分享 |
| GuideDialog | 引导弹窗 |
| DivinationLoadingIndicator | 中国风加载指示器 |
| HoverableIconButton | 悬停反馈图标按钮 |

---

## 8. 硬约束 Hard Constraints

以下为项目不可违反的硬约束：

### 8.1 CustomPainter 必须 dispose TextPainter

```dart
class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(text: ..., textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
    tp.dispose();  // 必须！防止 native handle 泄漏
  }
}
```

### 8.2 HistoryStore 原子读-改-写

历史记录写操作必须通过 `_serialize()` 串行化，防止并发 load/save 竞态：

```dart
static Future<void> add(HistoryEntry e) => _serialize(() async {
  final list = await load();
  list.insert(0, e);
  await _save(list);
});
```

### 8.3 Registry 注册唯一性

`divinationTechsProvider` 列表中的 Tech ID 必须唯一，注册表含 assert 校验：

```dart
assert(
  techs.map((t) => t.id).toSet().length == techs.length,
  'Duplicate DivinationTech id detected',
);
```

### 8.4 身份信息不硬编码

品牌身份信息通过 `core/branding.dart` 的 `Branding` 类引用，单一事实来源为 `D:\Code\.Rules\OrganizationAndUser.md`：

```dart
Branding.appName      // '志极'
Branding.appNameEn    // 'Jeenith'
Branding.orgEn        // 'Qore'
Branding.copyright    // 'Copyright (c) 2026 Qore'
```

### 8.5 加新术流程

加新卜算术的标准化流程：

1. 新建 `features/<tech_id>/` 目录（algorithm/ + ui/ + <tech_id>_tech.dart）
2. 实现 `DivinationTech` 接口（id / meta / buildPage）
3. 在 `core/divination/divination_registry.dart` 列表追加一行 `XxxTech(),`
4. 完成。无需修改 core/ 或 shared/ 任何代码

---

## 9. 注释规范 Comment Standards

### 9.1 文档注释 Doc Comments

公开类与接口使用 `///` 文档注释：

```dart
/// 卜算术抽象。
///
/// 每种术实现此接口，页面内自行管理输入采集、起卦调用、动画与结果展示。
/// 框架只统一提供：注册发现、RNG 服务、配置、主题、共享组件。
abstract class DivinationTech { ... }
```

### 9.2 行内注释 Inline Comments

复杂算法逻辑用 `//` 行内注释说明意图（中文优先）：

```dart
// 多源 SHA256 混合
var digest = sha256.convert(<int>[]).bytes;
for (final b in parts) {
  digest = sha256.convert([...digest, ...b]).bytes;
}
```

### 9.3 版本标记 Version Tags

重要变更用版本号标记：

```dart
/// v2.3.2: 进一步细分为 `animationSettings: Map<String, Map<String, bool>>`
```

---

**文档结束 End of Document**

志极 Jeenith · 志于本心，知于极处
