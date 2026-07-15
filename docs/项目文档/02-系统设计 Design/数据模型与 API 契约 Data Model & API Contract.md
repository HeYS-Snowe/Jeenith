# 数据模型与 API 契约 Data Model & API Contract

> 志极 Jeenith · 数据模型字段表与内部 API 契约

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
| v1.0.0 | 2026-01 | 初版：DivinationResult / TechMeta / AppConfig 字段表 |
| v2.3.0 | 2026-06 | AppConfig.animationSettings 拆为二维 Map |
| v2.3.3 | 2026-07-15 | 同步当前字段定义与 JSON 序列化契约 |

---

## 1. 模型概述 Model Overview

志极 Jeenith 的数据模型分四类，均为 `@immutable` Dart 类，集中在 `core/`：

| 类别 Category | 模型 Models | 文件 File |
|------------|-----------|--------|
| 配置 Config | AppConfig, AnimationKind | `core/config/app_config.dart` |
| 卜算框架 Framework | DivinationTech, TechMeta | `core/divination/divination_tech.dart` |
| 卜算结果 Result | DivinationResult, ResultCardData, Verdict, DetailDimension, ChangingPosition, EntropySample, EntropySourceResult | `core/divination/divination_result.dart` |
| 历史 History | HistoryEntry | `core/history/history_store.dart` |

所有模型遵循：
- `@immutable` + `const` 构造
- 可空字段用 `?`
- 提供 `copyWith`（需变更的）
- 序列化方法（`toJson` / `fromJson`）仅在需持久化时提供

---

## 2. 配置模型 Config Models

### 2.1 AnimationKind

**文件**：`core/config/app_config.dart`

```dart
enum AnimationKind { entrance, transition, painter, reveal }
```

| 枚举值 Value | name | 含义 Meaning |
|------------|----|------------|
| `entrance` | `"entrance"` | 入场仪式（仪式动画页/路由前置过渡） |
| `transition` | `"transition"` | 路由转场（TechTransition） |
| `painter` | `"painter"` | 绘制过程（CustomPainter progress 动画） |
| `reveal` | `"reveal"` | 结果揭示（RevealAnimation 封装） |

### 2.2 AppConfig

**文件**：`core/config/app_config.dart`

| 字段 Field | 类型 Type | 必填 Required | 默认 Default | 说明 Description |
|---------|--------|-----------|-----------|---------------|
| `showDetails` | `bool` | ✅ | `true` | 起卦后展示真随机采样详情 |
| `useOnline` | `bool` | ✅ | `true` | 启用 random.org 在线熵源 |
| `animationsEnabled` | `bool` | ❌ | `true` | 微交互动效总开关 |
| `animationSettings` | `Map<String, Map<String, bool>>` | ❌ | `{}` | 分术分类型动画开关（外层 techId，内层 kind.name） |
| `themeMode` | `ThemeMode` | ❌ | `ThemeMode.dark` | 主题模式 |

**方法 Methods**：

| 方法 | 签名 Signature | 说明 |
|-----|--------------|-----|
| `isAnimationEnabled` | `bool isAnimationEnabled(String techId, AnimationKind kind)` | 读取某术某类动画开关，缺省返回 `true` |
| `copyWith` | `AppConfig copyWith({...})` | 不可变更新 |
| `defaults` | `static const AppConfig` | 默认配置常量 |

**持久化映射**：

| 字段 | SharedPreferences Key | 类型 |
|-----|---------------------|-----|
| `showDetails` | `showDetails` | bool |
| `useOnline` | `useOnline` | bool |
| `animationsEnabled` | `animationsEnabled` | bool |
| `themeMode` | `themeMode` | string（`light`/`dark`/`system`） |
| `animationSettings[techId][kind]` | `anim_<techId>_<kind>` | bool |

---

## 3. 卜算框架模型 Framework Models

### 3.1 TechMeta

**文件**：`core/divination/divination_tech.dart`

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `id` | `String` | ✅ | 唯一标识（路由参数 `/tech/:id`） |
| `displayName` | `String` | ✅ | 显示名（如「小六壬」） |
| `subtitle` | `String` | ✅ | 副标题（如「掐指神课」） |
| `description` | `String` | ✅ | 卡片描述 |
| `accentColor` | `Color` | ✅ | 卡片主题色 |
| `sortOrder` | `int` | ❌ | 首页排列顺序，默认 `99` |
| `enabled` | `bool` | ❌ | 功能开关，默认 `true`（开发中可隐藏） |

### 3.2 DivinationTech

**文件**：`core/divination/divination_tech.dart`

| 成员 Member | 类型 Type | 说明 Description |
|-----------|--------|---------------|
| `id` | `String`（getter） | 唯一标识，须与 `meta.id` 一致 |
| `meta` | `TechMeta`（getter） | 展示元数据 |
| `buildPage` | `Widget Function(BuildContext, WidgetRef)` | 构建术主页 |

**契约**：抽象类，每种术实现。实例应为 `const`。

---

## 4. 卜算结果模型 Result Models

### 4.1 DivinationResult

**文件**：`core/divination/divination_result.dart`

统一结果模型，兼容小六壬（三宫+七维+分级）与周易（本卦+变卦+变爻）等所有术。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `techId` | `String` | ✅ | 术标识 |
| `primaryName` | `String` | ✅ | 主名（小六壬: 末宫名 / 周易: 本卦名） |
| `primarySubtitle` | `String?` | ❌ | 主名副标题（如「木·东方」「天」） |
| `secondaryName` | `String?` | ❌ | 副名（周易变卦名），无则 null |
| `secondarySubtitle` | `String?` | ❌ | 副名副标题 |
| `changingPositions` | `List<ChangingPosition>?` | ❌ | 变爻位（周易）/ 其他变位 |
| `verdict` | `Verdict?` | ❌ | 综合断语（吉凶分级） |
| `details` | `List<DetailDimension>?` | ❌ | 顶层多维断辞 |
| `cards` | `List<ResultCardData>` | ✅ | 结构化卡片（小六壬 3 张落宫 / 周易 1~2 张卦卡） |
| `inputNumbers` | `List<int>?` | ❌ | 输入随机数 |
| `entropy` | `EntropySample?` | ❌ | 真随机采样详情 |
| `timestamp` | `DateTime` | ✅ | 卜算时间 |
| `raw` | `Object?` | ❌ | 术特定原始数据（escape hatch，保证灵活） |

### 4.2 ResultCardData

**文件**：`core/divination/divination_result.dart`

单张结果卡的数据。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `order` | `String` | ✅ | 序号（「一」/「二」/「三」或「本」/「变」） |
| `title` | `String` | ✅ | 标题（「大安」/「乾」） |
| `subtitle` | `String?` | ❌ | 副标题（「木 · 青龙 · 东方」） |
| `badge` | `String?` | ❌ | 徽章（「大吉」） |
| `badgeColor` | `Color?` | ❌ | 徽章色 |
| `poem` | `String?` | ❌ | 诗诀 |
| `meaning` | `String?` | ❌ | 含义长文 |
| `details` | `List<DetailDimension>?` | ❌ | 多维断辞（小六壬七维） |
| `accentColor` | `Color?` | ❌ | 卡片主色 |

### 4.3 Verdict

**文件**：`core/divination/divination_result.dart`

整体吉凶分级。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `grade` | `String` | ✅ | 分级名（「大吉之象」） |
| `tone` | `Color` | ✅ | 分级主题色（参考 AppColors.grade*） |
| `description` | `String` | ✅ | 断语 |

### 4.4 DetailDimension

**文件**：`core/divination/divination_result.dart`

单维断辞（如 求谋/失物/出行 等）。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `label` | `String` | ✅ | 维度名（「求谋」） |
| `content` | `String` | ✅ | 断辞内容（「可成，宜稳进，贵人扶助。」） |

### 4.5 ChangingPosition

**文件**：`core/divination/divination_result.dart`

变位（周易变爻 / 未来其他术的变位）。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `index` | `int` | ✅ | 0-based 索引 |
| `label` | `String` | ✅ | 标签（「初」/「二」/.../「上」） |

### 4.6 EntropySample

**文件**：`core/divination/divination_result.dart`

真随机采样详情。

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `numbers` | `List<int>` | ✅ | 起卦用随机数 |
| `sources` | `List<EntropySourceResult>` | ✅ | 各源采样详情（UI 展示） |
| `timestamp` | `DateTime` | ✅ | 采样时间 |

### 4.7 EntropySourceResult

**文件**：`core/divination/divination_result.dart`

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `name` | `String` | ✅ | 熵源名称 |
| `display` | `String` | ✅ | 展示值 |
| `succeeded` | `bool` | ✅ | 是否采样成功 |

---

## 5. 历史模型 History Model

### 5.1 HistoryEntry

**文件**：`core/history/history_store.dart`

| 字段 Field | 类型 Type | 必填 Required | JSON Key | 说明 Description |
|---------|--------|-----------|---------|---------------|
| `id` | `String` | ✅ | `id` | 唯一 ID |
| `techId` | `String` | ✅ | `techId` | 术标识 |
| `techName` | `String` | ✅ | `techName` | 术显示名（冗余存储） |
| `time` | `DateTime` | ✅ | `time` | 卜算时间（ISO 8601） |
| `summary` | `String` | ✅ | `summary` | 摘要（列表展示） |
| `detail` | `String` | ✅ | `detail` | 详情文本（复制/导出用） |
| `note` | `String?` | ❌ | `note` | 用户备注 |

**方法 Methods**：

| 方法 | 签名 | 说明 |
|-----|-----|-----|
| `toJson` | `Map<String, dynamic> toJson()` | 序列化 |
| `fromJson` | `factory HistoryEntry.fromJson(Map<String, dynamic>)` | 反序列化 |
| `copyWith` | `HistoryEntry copyWith({String? note})` | 仅支持改 note |

---

## 6. API 契约 API Contract

### 6.1 TrueRandom.generate

```dart
Future<EntropySample> generate({int count = 3, int vmax = 9});
```

| 参数 Param | 类型 Type | 默认 Default | 说明 |
|---------|--------|-----------|-----|
| `count` | `int` | `3` | 生成随机数个数 |
| `vmax` | `int` | `9` | 上界（结果 ∈ [1, vmax]） |

**返回**：`EntropySample`（含 `numbers` 长度 = `count`）

**各术调用约定**：

| 术 Tech | count | vmax |
|--------|------|-----|
| 小六壬 | 3 | 6（或 9） |
| 周易 | 6 | 64 |
| 掷筊 | 3 | — |
| 抽签 | 1 | 签总数 |

### 6.2 HistoryStore API

| 方法 Method | 签名 Signature | 返回 Return | 原子 Atomic |
|-----------|--------------|----------|-----------|
| `load` | `static Future<List<HistoryEntry>> load()` | 全部历史（最新在前） | 读 |
| `add` | `static Future<void> add(HistoryEntry e)` | — | ✅ 串行化 |
| `updateNote` | `static Future<void> updateNote(String id, String? note)` | — | ✅ 串行化 |
| `remove` | `static Future<void> remove(String id)` | — | ✅ 串行化 |
| `clear` | `static Future<void> clear()` | — | ✅ 串行化 |
| `generateId` | `static String generateId()` | 唯一 ID | — |

### 6.3 ConfigNotifier API

| 方法 Method | 签名 Signature | 副作用 Side Effect |
|-----------|--------------|-----------------|
| `build` | `Future<AppConfig> build()` | 读 SharedPreferences |
| `setShowDetails` | `Future<void> setShowDetails(bool v)` | 写 `showDetails` + 更新 state |
| `setUseOnline` | `Future<void> setUseOnline(bool v)` | 写 `useOnline` + 更新 state |
| `setAnimationsEnabled` | `Future<void> setAnimationsEnabled(bool v)` | 写 `animationsEnabled` + 更新 state |
| `setAnimationSetting` | `Future<void> setAnimationSetting(String techId, AnimationKind kind, bool v)` | 写 `anim_<techId>_<kind>` + 更新 state |
| `setAllAnimations` | `Future<void> setAllAnimations(List<String> techIds, bool v)` | 批量写所有术所有 kind + 更新 state |
| `setThemeMode` | `Future<void> setThemeMode(ThemeMode v)` | 写 `themeMode` + 更新 state |

### 6.4 Provider 契约 Provider Contract

| Provider | 类型 Type | 值 Value | 重建条件 Rebuild On |
|---------|--------|--------|------------------|
| `configProvider` | `AsyncNotifierProvider<ConfigNotifier, AppConfig>` | `AsyncData<AppConfig>` | setter 调用 |
| `trueRandomProvider` | `Provider<TrueRandom>` | TrueRandom 实例 | `configProvider` 的 `useOnline` 变化 |
| `touchTrackerProvider` | `Provider<TouchTracker>` | TouchTracker 单例 | 不重建 |
| `divinationTechsProvider` | `Provider<List<DivinationTech>>` | 12 术列表 | 不重建（编译期常量） |
| `techByIdProvider` | `Provider.family<DivinationTech?, String>` | 按 id 查术 | 入参 id |
| `visibleTechsProvider` | `Provider<List<DivinationTech>>` | enabled + sorted | `divinationTechsProvider` |
| `routerProvider` | `Provider<GoRouter>` | GoRouter 实例 | 不重建 |

---

## 7. JSON 序列化契约 JSON Serialization

### 7.1 HistoryEntry JSON

```json
{
  "id": "1784122714123456-0001",
  "techId": "zhouyi",
  "techName": "周易",
  "time": "2026-07-15T14:30:25.123456",
  "summary": "本卦：乾为天 → 变卦：天风姤",
  "detail": "【周易·金钱卦】\n本卦：乾为天...",
  "note": null
}
```

### 7.2 历史数组 JSON

```json
[
  { "id": "...", "techId": "zhouyi", ... },
  { "id": "...", "techId": "xiaoliuren", ... }
]
```

存储于 SharedPreferences key `divination_history`，value 为 `jsonEncode(list)` 字符串。

### 7.3 非序列化模型

以下模型**不序列化**，仅运行时存在于内存：
- `AppConfig`（字段分别持久化，非整体 JSON）
- `DivinationResult` / `ResultCardData` / `Verdict` 等（卜算结果不直接持久化，转为 HistoryEntry 的 summary/detail 文本后存储）
- `TechMeta` / `DivinationTech`（编译期常量）
- `EntropySample`（仅 UI 展示，不持久化）

---

## 8. 模型关系图 Model Relationship

```
DivinationTech ──► TechMeta
                ──► buildPage → ConsumerWidget

DivinationResult ──► List<ResultCardData> ──► List<DetailDimension>
                 ──► Verdict
                 ──► List<ChangingPosition>
                 ──► EntropySample ──► List<EntropySourceResult>

HistoryEntry ◄── toJson/fromJson ──► SharedPreferences(JSON)

AppConfig ──► Map<String, Map<String, bool>> animationSettings
          ──► ThemeMode
          ──► AnimationKind (enum)
```

---

## 9. 数据流契约 Data Flow Contract

### 9.1 起卦数据流 Divination Data Flow

```
TrueRandom.generate(count, vmax)
    │
    ▼
EntropySample { numbers, sources, timestamp }
    │
    ▼
<Tech>Algorithm.divine(numbers) → DivinationResult {
    techId, primaryName, cards, verdict, details,
    changingPositions, entropy, timestamp, raw
}
    │
    ├─► UI: RevealAnimation + ResultCard 渲染
    └─► HistoryEntry {
            id: generateId(),
            techId: result.techId,
            techName: tech.meta.displayName,
            time: result.timestamp,
            summary: buildSummary(result),
            detail: buildCopyText(result),
        }
            │
            ▼
        HistoryStore.add(entry) → SharedPreferences
```

### 9.2 配置数据流 Config Data Flow

```
用户操作 SettingsPage
    │
    ▼
ConfigNotifier.setXxx(v)
    │
    ├─► SharedPreferences.setXxx(key, v)
    └─► state = AsyncData(current.copyWith(...))
            │
            ▼
        watch(configProvider) 的 consumers 重建：
        - trueRandomProvider（useOnline 变化时重建引擎）
        - routerProvider（transition 设置变化）
        - JeenithApp（themeMode 变化）
        - 各术 UI（动画开关变化）
```

---

## 10. 契约不变量 Contract Invariants

| 不变量 Invariant | 说明 |
|---------------|-----|
| `DivinationTech.id == DivinationTech.meta.id` | 两者必须一致 |
| `DivinationTech.id` 全 APP 唯一 | 注册表 assert 检测 |
| `DivinationResult.cards` 非空 | 必填字段 |
| `DivinationResult.timestamp` 非空 | 必填字段 |
| `HistoryEntry.id` 全局唯一 | generateId 保证 |
| `HistoryStore.add` 后 entry 在 index 0 | 最新在前 |
| `AppConfig.isAnimationEnabled` 缺省返回 true | 向前兼容 |
| `TrueRandom.generate` 不抛异常 | 至少时间戳+系统熵可用 |
| `techByIdProvider(id)` 未知 id 返回 null | 路由兜底占位页 |

---

## 11. 字段命名规范 Naming Conventions

| 类型 Type | 规范 Rule | 示例 Example |
|---------|---------|------------|
| 类名 Class | UpperCamelCase | `DivinationResult` |
| 字段 Field | lowerCamelCase | `primaryName` |
| JSON Key | lowerCamelCase（与字段同名） | `"primaryName"` |
| 枚举 Enum | lowerCamelCase | `entrance` |
| 常量 Const | lowerCamelCase | `defaults` |
| 私有 Private | 前缀 `_` | `_chain` |
| 文件 File | snake_case | `divination_result.dart` |

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
