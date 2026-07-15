# API接口文档 API Documentation

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 适用版本 App Version | 2.3.3+23 |
| 文档类型 Doc Type | 内部 API（Dart 接口/Provider，非 HTTP） |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-07-15 | 初始版本，覆盖框架核心接口 |

---

## 目录 Table of Contents

1. [API概述 API Overview](#1-api概述-api-overview)
2. [卜算框架 Divination Framework](#2-卜算框架-divination-framework)
3. [真随机引擎 RNG Engine](#3-真随机引擎-rng-engine)
4. [配置服务 Config Service](#4-配置服务-config-service)
5. [历史存储 History Store](#5-历史存储-history-store)
6. [路由系统 Router](#6-路由系统-router)

---

## 1. API概述 API Overview

### 1.1 文档说明 Document Description

志极 Jeenith 为纯客户端 Flutter App（无后端），本文档描述项目内部的 Dart 接口与 Riverpod Provider，供开发者理解框架核心 API 与扩展点。

### 1.2 架构分层 Architecture Layers

```
features/<tech>/          ← 术数实现层（调用框架 API）
    ↓
core/divination/          ← 卜算框架（DivinationTech / Registry / Result）
core/rng/                 ← 真随机引擎（多源熵 + TrueRandom）
core/config/              ← 配置服务（AppConfig + ConfigNotifier）
core/history/             ← 历史存储（HistoryStore + HistoryExport）
    ↓
providers/                ← barrel 聚合
router/                   ← 路由系统
```

### 1.3 核心扩展点 Core Extension Point

加新卜算术仅需：
1. 实现 `DivinationTech` 接口
2. 在 `divination_registry.dart` 注册一行
3. 无需修改 core/ 或 shared/ 任何代码

---

## 2. 卜算框架 Divination Framework

### 2.1 DivinationTech 接口

**文件**：`core/divination/divination_tech.dart`

每种术数实现此接口，页面内自行管理输入采集、起卦调用、动画与结果展示。

```dart
abstract class DivinationTech {
  const DivinationTech();

  /// 唯一标识（路由 /tech/:id）。
  String get id;

  /// 展示元数据。
  TechMeta get meta;

  /// 构建该术主页面。框架提供 [ref] 供访问 providers。
  Widget buildPage(BuildContext context, WidgetRef ref);
}
```

**实现示例**：

```dart
class XiaoliurenTech extends DivinationTech {
  const XiaoliurenTech();

  @override
  String get id => 'xiaoliuren';

  @override
  TechMeta get meta => const TechMeta(
    id: 'xiaoliuren',
    displayName: '小六壬',
    subtitle: '掐指神课',
    description: '...',
    accentColor: Color(0xFF...),
    sortOrder: 0,
  );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) => const XiaoliurenPage();
}
```

### 2.2 TechMeta 展示元数据

```dart
@immutable
class TechMeta {
  final String id;            // 路由参数，如 'xiaoliuren'
  final String displayName;   // '小六壬'
  final String subtitle;      // '掐指神课'
  final String description;   // 卡片描述
  final Color accentColor;    // 卡片主题色
  final int sortOrder;        // 首页排列顺序（默认 99）
  final bool enabled;         // 功能开关（开发中可隐藏，默认 true）
}
```

### 2.3 DivinationRegistry 注册表

**文件**：`core/divination/divination_registry.dart`

| Provider | 返回类型 Return Type | 说明 Description |
|----------|-------------------|----------------|
| `divinationTechsProvider` | `List<DivinationTech>` | 全部已注册术数列表 |
| `techByIdProvider(id)` | `DivinationTech?` | 按 ID 查找（路由用） |
| `visibleTechsProvider` | `List<DivinationTech>` | 首页排序后的可用列表（按 sortOrder） |

**注册方式**：

```dart
final divinationTechsProvider = Provider<List<DivinationTech>>((ref) {
  final techs = <DivinationTech>[
    XiaoliurenTech(),
    ZhouyiTech(),
    // ... 追加一行即可加新术
  ];
  assert(techs.map((t) => t.id).toSet().length == techs.length,
      'Duplicate DivinationTech id detected');
  return techs;
});
```

### 2.4 DivinationResult 统一结果模型

**文件**：`core/divination/divination_result.dart`

兼容多术的统一结果模型：

```dart
@immutable
class DivinationResult {
  final String techId;
  final String primaryName;              // 主名（卦名/落宫等）
  final String? primarySubtitle;         // 副标题
  final String? secondaryName;           // 变卦名（周易）
  final List<ChangingPosition>? changingPositions;  // 变爻位
  final Verdict? verdict;                // 综合断语
  final List<DetailDimension>? details;  // 多维断辞
  final List<ResultCardData> cards;      // 结构化卡片
  final List<int>? inputNumbers;         // 输入数字
  final EntropySample? entropy;          // 真随机采样详情
  final DateTime timestamp;
  final Object? raw;                     // 术特定原始数据（escape hatch）
}
```

**辅助数据类**：

| 类 Class | 用途 Purpose |
|---------|------------|
| `Verdict` | 吉凶分级（grade / tone / description） |
| `DetailDimension` | 单维断辞（label / content） |
| `ChangingPosition` | 变位（index / label） |
| `ResultCardData` | 结果卡数据（order / title / poem / meaning / details 等） |
| `EntropySourceResult` | 熵源采样结果（name / display / succeeded） |
| `EntropySample` | 真随机采样（numbers / sources / timestamp） |

---

## 3. 真随机引擎 RNG Engine

### 3.1 EntropyCollector 熵源接口

**文件**：`core/rng/entropy_source.dart`

```dart
abstract class EntropyCollector {
  String get name;
  bool get isAvailable;
  Future<({String display, Uint8List bytes})> sample();
}
```

### 3.2 内置熵源 Built-in Entropy Sources

| 熵源 Source | 文件 File | 说明 Description |
|------------|---------|----------------|
| `SystemEntropySource` | `system_entropy_source.dart` | `Random.secure()` 系统熵 |
| `TouchEntropySource` | `touch_entropy_source.dart` | 触摸轨迹熵（依赖 TouchTracker） |
| `OnlineEntropySource` | `online_entropy_source.dart` | random.org 大气噪声（可配置开关） |

### 3.3 TrueRandom 引擎

**文件**：`core/rng/true_random.dart`

多源 SHA256 混合真随机引擎：

```dart
class TrueRandom {
  final List<EntropyCollector> sources;
  TrueRandom(this.sources);

  /// 生成 count 个 [1, vmax] 整数，附带各源采样详情。
  Future<EntropySample> generate({int count = 3, int vmax = 9}) async { ... }
}
```

**算法流程**：
1. 遍历各熵源，调用 `sample()` 采集字节
2. 多源 SHA256 链式混合：`digest = sha256(digest + sourceBytes)`
3. 收尾混合时间戳 + 系统熵
4. 链式 SHA256 扩展为 count 个数（避免简单切片相关性）
5. 模运算映射到 `[1, vmax]` 区间

### 3.4 RNG Providers

**文件**：`core/rng/rng_providers.dart`

| Provider | 返回类型 Return Type | 说明 Description |
|----------|-------------------|----------------|
| `touchTrackerProvider` | `TouchTracker` | 触摸轨迹采集器（单例） |
| `trueRandomProvider` | `TrueRandom` | 真随机引擎（3 源按配置开关） |

**引擎组装**：

```dart
final trueRandomProvider = Provider<TrueRandom>((ref) {
  final config = ref.watch(configProvider).valueOrNull ?? AppConfig.defaults;
  final tracker = ref.watch(touchTrackerProvider);
  return TrueRandom([
    SystemEntropySource(),
    TouchEntropySource(tracker),
    OnlineEntropySource(config.useOnline),  // 受配置开关控制
  ]);
});
```

### 3.5 调用示例 Usage Example

```dart
// 在术数页面中生成 3 个 [1, 9] 的随机数
final rng = ref.read(trueRandomProvider);
final sample = await rng.generate(count: 3, vmax: 9);
// sample.numbers → [3, 7, 1]
// sample.sources → 各源采样详情（供 UI 展示）
```

---

## 4. 配置服务 Config Service

### 4.1 AppConfig 配置模型

**文件**：`core/config/app_config.dart`

```dart
class AppConfig {
  final bool showDetails;              // 起卦后展示采样详情
  final bool useOnline;                // 在线大气噪声 random.org
  final bool animationsEnabled;        // 微交互动效总开关
  final Map<String, Map<String, bool>> animationSettings;  // 按术数分类的动画开关
  final ThemeMode themeMode;           // 主题模式：system/light/dark
}
```

**动画分类开关**：

```dart
enum AnimationKind { entrance, transition, painter, reveal }

// 读取某术某类动画开关（未记录时默认 true）
bool isAnimationEnabled(String techId, AnimationKind kind) =>
    animationSettings[techId]?[kind.name] ?? true;
```

### 4.2 ConfigNotifier 配置持久化

**文件**：`core/config/config_providers.dart`

| Provider | 返回类型 Return Type | 说明 Description |
|----------|-------------------|----------------|
| `configProvider` | `AsyncValue<AppConfig>` | 配置 Provider（AsyncNotifier） |

**方法 API**：

| 方法 Method | 参数 Params | 说明 Description |
|------------|-----------|----------------|
| `setShowDetails(bool)` | `v` | 设置采样详情展示开关 |
| `setUseOnline(bool)` | `v` | 设置在线熵源开关 |
| `setAnimationsEnabled(bool)` | `v` | 设置动效总开关 |
| `setAnimationSetting(techId, kind, v)` | `String, AnimationKind, bool` | 设置某术某类动画开关 |
| `setAllAnimations(techIds, v)` | `List<String>, bool` | 一键批量开关 |
| `setThemeMode(ThemeMode)` | `v` | 设置主题模式 |

**持久化 Key 约定**：

| Key | 类型 Type | 说明 Description |
|-----|---------|----------------|
| `showDetails` | bool | 采样详情展示 |
| `useOnline` | bool | 在线熵源 |
| `animationsEnabled` | bool | 动效总开关 |
| `anim_<techId>_<kind>` | bool | 某术某类动画开关（如 `anim_xiaoliuren_entrance`） |
| `themeMode` | String | 主题模式（`light`/`dark`/`system`） |

---

## 5. 历史存储 History Store

### 5.1 HistoryEntry 记录模型

**文件**：`core/history/history_store.dart`

```dart
class HistoryEntry {
  final String id;          // 唯一 ID（microsecondsSinceEpoch + 计数器）
  final String techId;      // 术数 ID
  final String techName;    // 术数名
  final DateTime time;      // 卜算时间
  final String summary;     // 摘要（列表展示）
  final String detail;      // 详细文本（复制用）
  final String? note;       // 用户备注
}
```

### 5.2 HistoryStore 静态 API

**文件**：`core/history/history_store.dart`

所有方法为静态方法，基于 SharedPreferences JSON 存储，写操作通过 `_serialize()` 串行化（原子读-改-写）。

| 方法 Method | 返回类型 Return Type | 说明 Description |
|------------|-------------------|----------------|
| `load()` | `Future<List<HistoryEntry>>` | 加载全部历史（最新在前） |
| `add(HistoryEntry)` | `Future<void>` | 新增记录（串行化） |
| `updateNote(id, note)` | `Future<void>` | 更新备注（串行化） |
| `remove(id)` | `Future<void>` | 删除记录（串行化） |
| `clear()` | `Future<void>` | 清空全部（串行化） |
| `generateId()` | `String` | 生成单调递增唯一 ID |

**调用示例**：

```dart
// 新增一条卜算历史
await HistoryStore.add(HistoryEntry(
  id: HistoryStore.generateId(),
  techId: 'xiaoliuren',
  techName: '小六壬',
  time: DateTime.now(),
  summary: '大安 · 速喜 · 空亡',
  detail: '...',
));
```

### 5.3 HistoryExport 导出

**文件**：`core/history/history_export.dart`

| 格式 Format | 说明 Description |
|------------|----------------|
| JSON | 完整保真，可直接重新导入 |
| Markdown | 人类可读表格 + 详情块 |
| CSV | Excel/WPS 可直接打开（含 UTF-8 BOM） |

---

## 6. 路由系统 Router

### 6.1 路由配置 Router Config

**文件**：`router/app_router.dart`

| Provider | 返回类型 Return Type | 说明 Description |
|----------|-------------------|----------------|
| `routerProvider` | `GoRouter` | 全局路由配置 |

### 6.2 路由表 Route Table

| 路径 Path | 类型 Type | 说明 Description |
|----------|---------|----------------|
| `/` | 静态 | 首页（选术） |
| `/tech/:id` | 动态 | 术数主页面（id 为 techId） |
| `/ritual/:id` | 动态 | 仪式入场动画（id 为 techId） |
| `/history` | 静态 | 历史记录页 |
| `/settings` | 静态 | 设置页 |
| `/manual` | 静态 | 使用手册 |

### 6.3 转场动画 Transition

`/tech/:id` 路由的 `pageBuilder` 使用 `TechTransition.build()` 实现每术专属转场：

```dart
GoRoute(
  path: '/tech/:id',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id']!;
    final tech = ref.read(techByIdProvider(id));
    final transitionsEnabled = ref
            .read(configProvider)
            .valueOrNull
            ?.isAnimationEnabled(id, AnimationKind.transition) ?? true;
    return TechTransition.build(
      key: state.pageKey,
      child: page,
      techId: id,
      transitionsEnabled: transitionsEnabled,
    );
  },
),
```

---

## 附录：已注册术数清单 Registered Techs

| ID | 名称 Name | sortOrder | 接入版本 Version |
|----|----------|-----------|----------------|
| xiaoliuren | 小六壬 | 0 | v1.0.0 |
| zhouyi | 周易 | 1 | v1.0.0 |
| meihua | 梅花易数 | 2 | v1.0.0 |
| jiaobei | 掷筊 | 3 | v1.0.0 |
| ziwei | 紫微斗数 | 4 | v1.0.0（v1.3.0 全套星曜） |
| qimen | 奇门遁甲 | 5 | v1.0.0（v1.4.0 四盘九宫） |
| chouqian | 抽签 | 6 | v1.6.0 |
| cezi | 测字 | 7 | v1.6.0 |
| daliuren | 大六壬 | 8 | v1.7.0 |
| luopan | 风水罗盘 | 9 | v1.7.0 |
| bazi | 八字推演 | 10 | v2.3.0 |
| name_test | 测名字 | 11 | v2.3.0 |

---

**文档结束 End of Document**

志极 Jeenith · 志于本心，知于极处
