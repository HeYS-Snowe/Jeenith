# 接口设计文档 Internal API Design Document

> 志极 Jeenith · 内部接口设计（Dart 接口 + Provider + 服务）

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心） |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe |
| 许可证 License | MIT · Copyright (c) 2026 Qore |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-01 | 初版：DivinationTech/EntropyCollector/HistoryStore 接口 |
| v2.3.0 | 2026-06 | ConfigNotifier 接口拆分（setAnimationSetting/setAllAnimations） |
| v2.3.3 | 2026-07-15 | 同步当前接口签名与 Provider 清单 |

---

## 1. 接口设计概述 Interface Overview

### 1.1 接口分类 Interface Categories

志极 Jeenith 为纯客户端应用，无网络 API，所有「接口」均为 Dart 内部契约，分四类：

| 类型 Type | 形式 Form | 作用 Role |
|---------|---------|---------|
| 抽象接口 abstract interface | `abstract class` | 跨实现多态（DivinationTech / EntropyCollector） |
| 服务类 Service | 静态方法类 | 无状态能力（HistoryStore / LunarService / HistoryExport） |
| Provider | Riverpod Provider | 依赖注入与响应式订阅 |
| 数据模型 Data Model | `@immutable class` | 数据载体（AppConfig / DivinationResult 等） |

### 1.2 设计约定 Conventions

- 所有公开类/方法有文档注释（`///`）
- 不可变数据模型用 `@immutable` + `const` 构造 + `copyWith`
- 异步操作返回 `Future`，不阻塞 UI 线程
- 失败优先静默降级，不抛异常崩溃（除 debug assert）

---

## 2. 核心抽象接口 Core Abstract Interfaces

### 2.1 DivinationTech —— 卜算术接口

**文件**：`core/divination/divination_tech.dart`
**角色**：每种术实现的统一契约，框架据此注册发现与路由。

```dart
abstract class DivinationTech {
  const DivinationTech();

  /// 唯一标识（路由参数 /tech/:id）。须全 APP 唯一。
  String get id;

  /// 展示元数据（首页卡片 + 排序 + 功能开关）。
  TechMeta get meta;

  /// 构建该术主页面。框架注入 [ref] 供访问全局 providers。
  Widget buildPage(BuildContext context, WidgetRef ref);
}
```

**实现约束**：
- `id` 必须全 APP 唯一（注册表 assert 检测）
- 实例应为 `const`（注册表无运行时开销）
- `buildPage` 内部自管输入采集、起卦、动画、结果展示

**实现清单**：XiaoliurenTech / ZhouyiTech / MeihuaTech / JiaobeiTech / ZiweiTech / QimenTech / ChouqianTech / CeziTech / DaliurenTech / LuopanTech / NameTestTech / BaziTech（共 12 个）。

### 2.2 EntropyCollector —— 熵源接口

**文件**：`core/rng/entropy_source.dart`
**角色**：真随机引擎的可插拔熵源契约。

```dart
abstract class EntropyCollector {
  /// 熵源名称（UI 展示用）。
  String get name;

  /// 当前是否可用（如在线源未启用时返回 false）。
  bool get isAvailable;

  /// 采样一次，返回展示值 + 用于 SHA256 混合的字节。
  /// 失败应抛异常，由 TrueRandom 捕获并标记 failed。
  Future<({String display, Uint8List bytes})> sample();
}
```

**实现**：
- `SystemEntropySource`：`Random.secure` 系统熵
- `TouchEntropySource`：`TouchTracker` 指针轨迹
- `OnlineEntropySource`：random.org HTTP 大气噪声（受 `useOnline` 开关控制）

---

## 3. 服务类接口 Service Interfaces

### 3.1 TrueRandom —— 真随机引擎

**文件**：`core/rng/true_random.dart`

```dart
class TrueRandom {
  final List<EntropyCollector> sources;
  TrueRandom(this.sources);

  /// 生成 count 个 [1, vmax] 整数，附带各源采样详情。
  Future<EntropySample> generate({int count = 3, int vmax = 9});
}
```

**契约**：
- `count`：需求数个数（小六壬=3，周易=6）
- `vmax`：上界（小六壬=6/9，周易=64 等）
- 返回 `EntropySample`，含 `numbers`（结果）+ `sources`（各源采样展示）+ `timestamp`
- 任一源失败不影响整体，混合时跳过该源 bytes

### 3.2 HistoryStore —— 历史存储

**文件**：`core/history/history_store.dart`

```dart
class HistoryStore {
  static Future<List<HistoryEntry>> load();                 // 读全部（最新在前）
  static Future<void> add(HistoryEntry e);                  // 新增（串行化原子写）
  static Future<void> updateNote(String id, String? note);  // 改备注
  static Future<void> remove(String id);                    // 删除单条
  static Future<void> clear();                              // 清空
  static String generateId();                               // 生成唯一 ID
}
```

**契约**：
- 所有写操作经 `_serialize` 串行化，保证原子性
- `load()` 解析失败返回空列表，不抛异常
- `add` 后最新记录在 index 0

### 3.3 LunarService —— 农历服务

**文件**：`core/calendar/lunar_service.dart`

```dart
class LunarService {
  LunarService._();

  /// 当前时刻农历月、日。
  /// 返回 (month: 正月=1..腊月=12, day: 初一=1..三十=30, display: '五月十八')
  static ({int month, int day, String display}) nowLunarMonthDay();
}
```

**契约**：底层封装 `lunar` 包的 `Lunar.fromDate(DateTime.now())`，各术可自行调用 lunar 原始 API 完成复杂排盘。

### 3.4 HistoryExport —— 历史导出

**文件**：`core/history/history_export.dart`

```dart
class HistoryExport {
  HistoryExport._();

  static Future<File> exportJson(List<HistoryEntry> list);     // JSON（可重导入）
  static Future<File> exportMarkdown(List<HistoryEntry> list); // Markdown（可读）
  static Future<File> exportCsv(List<HistoryEntry> list);      // CSV（Excel）
}
```

**契约**：均写入 `getTemporaryDirectory()`，文件名 `jeenith_history_<ms>.<ext>`，调用方走 `share_plus` 分享。

### 3.5 PlatformInfo —— 平台检测

**文件**：`core/config/platform_info.dart`

```dart
class PlatformInfo {
  static final DeviceFamily family;   // mobile / desktop / web
  static final String label;          // Android/iOS/Windows/...
  static bool get isMobile;
  static bool get isDesktop;
  static bool get isWeb;
  static bool get isAndroid;
  static bool get isWindows;
  // ...
}
```

**契约**：运行时一次性判定，基于 `defaultTargetPlatform` + `kIsWeb`，不依赖 dart:io。

---

## 4. Provider 接口 Provider Interfaces

### 4.1 配置 Provider

**文件**：`core/config/config_providers.dart`

```dart
final configProvider = AsyncNotifierProvider<ConfigNotifier, AppConfig>(
  ConfigNotifier.new,
);

class ConfigNotifier extends AsyncNotifier<AppConfig> {
  Future<AppConfig> build();                                      // 异步读 prefs
  Future<void> setShowDetails(bool v);
  Future<void> setUseOnline(bool v);
  Future<void> setAnimationsEnabled(bool v);
  Future<void> setAnimationSetting(String techId, AnimationKind kind, bool v);
  Future<void> setAllAnimations(List<String> techIds, bool v);
  Future<void> setThemeMode(ThemeMode v);
}
```

**契约**：
- 初始为 `AsyncLoading`，读 prefs 完成后转 `AsyncData<AppConfig>`
- 每个 setter：先写 prefs，再 `state = AsyncData(current.copyWith(...))`
- `setAllAnimations` 批量开关所有术的所有 kind

### 4.2 RNG Provider

**文件**：`core/rng/rng_providers.dart`

```dart
final touchTrackerProvider = Provider<TouchTracker>((ref) => TouchTracker());

final trueRandomProvider = Provider<TrueRandom>((ref) {
  final config = ref.watch(configProvider).valueOrNull ?? AppConfig.defaults;
  final tracker = ref.watch(touchTrackerProvider);
  return TrueRandom([
    SystemEntropySource(),
    TouchEntropySource(tracker),
    OnlineEntropySource(config.useOnline),
  ]);
});
```

**契约**：
- `trueRandomProvider` watch `configProvider`，`useOnline` 变化时重建引擎
- `touchTrackerProvider` 单例，由 `JeenithApp` 的 `Listener` 全局喂数据

### 4.3 注册表 Provider

**文件**：`core/divination/divination_registry.dart`

```dart
final divinationTechsProvider = Provider<List<DivinationTech>>((ref) { ... });
final techByIdProvider = Provider.family<DivinationTech?, String>((ref, id) { ... });
final visibleTechsProvider = Provider<List<DivinationTech>>((ref) { ... });
```

**契约**：
- `divinationTechsProvider`：全部注册术（含 disabled）
- `techByIdProvider`：按 id 查找（路由用），未找到返回 null
- `visibleTechsProvider`：过滤 `enabled` + 按 `sortOrder` 排序（首页 grid 用）

### 4.4 路由 Provider

**文件**：`router/app_router.dart`

```dart
final routerProvider = Provider<GoRouter>((ref) { ... });
```

**契约**：暴露 GoRouter 实例，`JeenithApp` 通过 `ref.watch(routerProvider)` 注入 `MaterialApp.router`。

### 4.5 Providers Barrel

**文件**：`providers/providers.dart`

```dart
export '../core/config/config_providers.dart';
export '../core/rng/rng_providers.dart';
```

各处统一 `import 'providers/providers.dart'` 即得 config + rng providers。

---

## 5. 数据模型接口 Data Model Interfaces

### 5.1 AppConfig

```dart
enum AnimationKind { entrance, transition, painter, reveal }

class AppConfig {
  final bool showDetails;
  final bool useOnline;
  final bool animationsEnabled;
  final Map<String, Map<String, bool>> animationSettings;
  final ThemeMode themeMode;

  bool isAnimationEnabled(String techId, AnimationKind kind);  // 缺省 true
  AppConfig copyWith({...});
  static const AppConfig defaults;
}
```

### 5.2 TechMeta

```dart
class TechMeta {
  final String id, displayName, subtitle, description;
  final Color accentColor;
  final int sortOrder;
  final bool enabled;
}
```

### 5.3 DivinationResult

```dart
class DivinationResult {
  final String techId;
  final String primaryName;
  final String? primarySubtitle, secondaryName, secondarySubtitle;
  final List<ChangingPosition>? changingPositions;
  final Verdict? verdict;
  final List<DetailDimension>? details;
  final List<ResultCardData> cards;        // 必填
  final List<int>? inputNumbers;
  final EntropySample? entropy;
  final DateTime timestamp;                 // 必填
  final Object? raw;                        // 术特定原始数据（escape hatch）
}
```

### 5.4 EntropySample

```dart
class EntropySample {
  final List<int> numbers;                  // 起卦用随机数
  final List<EntropySourceResult> sources;  // 各源采样详情（UI 展示）
  final DateTime timestamp;
}

class EntropySourceResult {
  final String name, display;
  final bool succeeded;
}
```

### 5.5 HistoryEntry

```dart
class HistoryEntry {
  final String id, techId, techName, summary, detail;
  final DateTime time;
  final String? note;

  Map<String, dynamic> toJson();
  factory HistoryEntry.fromJson(Map<String, dynamic> j);
  HistoryEntry copyWith({String? note});
}
```

### 5.6 结果辅助模型 Result Helpers

```dart
class DetailDimension { final String label, content; }       // 单维断辞
class Verdict { final String grade; final Color tone; final String description; }  // 吉凶分级
class ChangingPosition { final int index; final String label; }  // 变爻位
class ResultCardData { final String order, title; final String? subtitle, badge, poem, meaning;
  final Color? badgeColor, accentColor; final List<DetailDimension>? details; }  // 结果卡
```

详细字段表见《数据模型与 API 契约》。

---

## 6. 接口契约示例 Contract Examples

### 6.1 起卦调用契约 Divination Call

```dart
// 术页面内
final sample = await ref.read(trueRandomProvider).generate(count: 6, vmax: 64);
final numbers = sample.numbers;  // [12, 45, 7, 33, 58, 21]
final result = ZhouyiAlgorithm.divine(numbers);
// result: DivinationResult { techId: 'zhouyi', primaryName: '乾为天', cards: [...], ... }
```

### 6.2 历史记录契约 History Record

```dart
final entry = HistoryEntry(
  id: HistoryStore.generateId(),
  techId: result.techId,
  techName: '周易',
  time: result.timestamp,
  summary: '本卦：乾为天 → 变卦：天风姤',
  detail: buildCopyText(result),  // 同复制文本
);
await HistoryStore.add(entry);  // 串行化原子写
```

### 6.3 配置变更契约 Config Change

```dart
await ref.read(configProvider.notifier)
    .setAnimationSetting('zhouyi', AnimationKind.reveal, false);
// 内部：prefs.setBool('anim_zhouyi_reveal', false) → state 更新
// watch(configProvider) 的 UI 自动重建
```

### 6.4 路由解析契约 Route Resolution

```dart
// /tech/zhouyi
GoRoute(path: '/tech/:id', pageBuilder: (ctx, state) {
  final id = state.pathParameters['id']!;          // 'zhouyi'
  final tech = ref.read(techByIdProvider(id));     // ZhouyiTech
  final page = (tech == null) ? _UnknownPage() : _TechPage(tech: tech);
  final trans = ref.read(configProvider).valueOrNull
      ?.isAnimationEnabled(id, AnimationKind.transition) ?? true;
  return TechTransition.build(child: page, techId: id, transitionsEnabled: trans);
});
```

---

## 7. 接口依赖关系 Interface Dependencies

```
DivinationTech ──► TechMeta (core/divination)
                ──► WidgetRef (riverpod)

TrueRandom ──► EntropyCollector (core/rng)
           ──► EntropySample (core/divination/divination_result)

ConfigNotifier ──► AppConfig (core/config)
              ──► SharedPreferences

trueRandomProvider ──► configProvider (watch useOnline)
                  ──► touchTrackerProvider
                  ──► TrueRandom / 3 EntropySource

routerProvider ──► configProvider (read transition setting)
              ──► techByIdProvider
              ──► TechTransition
```

---

## 8. 错误处理契约 Error Handling Contract

| 接口 Interface | 失败场景 Failure | 处理 Handling |
|-------------|--------------|------------|
| `EntropyCollector.sample()` | 采样异常 | TrueRandom catch，标记 failed，跳过该源 |
| `TrueRandom.generate()` | 全部源失败 | 仍返回（仅时间戳+系统熵加盐），不抛异常 |
| `HistoryStore.load()` | JSON 解析失败 | catch 返回空列表 |
| `HistoryStore.add()` | 写失败 | Future error，调用方可 catch 静默 |
| `techByIdProvider(id)` | 未知 id | 返回 null，路由渲染占位页 |
| `LunarService.nowLunarMonthDay()` | 不会失败 | lunar 包内部容错 |
| `ConfigNotifier.build()` | prefs 不可用 | 回退 `AppConfig.defaults` |

---

## 9. 接口演进原则 Interface Evolution

- **新增**：新方法/字段直接加，向后兼容
- **废弃**：旧方法保留但标 `@Deprecated`，下一大版本移除
- **不破坏**：`buildPage` / `generate` / `add` 等核心签名自 v1.0 稳定
- **扩展点**：新熵源实现 `EntropyCollector`；新术实现 `DivinationTech`

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
