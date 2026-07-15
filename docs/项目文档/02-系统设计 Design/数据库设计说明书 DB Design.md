# 数据库设计说明书 Local Storage Design Document

> 志极 Jeenith · 本地存储设计（SharedPreferences + JSON）

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
| v1.0.0 | 2026-01 | 初版：SharedPreferences Key 设计 + 历史 JSON 结构 |
| v2.3.0 | 2026-06 | animationSettings 拆分为 Map<String, Map<String, bool>> |
| v2.3.2 | 2026-07 | anim key 拆为 anim_<techId>_<kind>，旧 key 不再读取 |
| v2.3.3 | 2026-07-15 | 同步当前存储结构与导出格式 |

---

## 1. 存储概述 Storage Overview

### 1.1 存储选型 Storage Choice

志极 Jeenith 为**纯客户端无后端应用**，所有数据本地持久化。经评估数据特征：

| 数据 Data | 特征 Characteristics | 模型 Model |
|---------|-----------------|----------|
| 应用配置 | 标量 bool/string | K/V |
| 分术动画开关 | 二维 bool（techId × kind） | K/V（扁平 key） |
| 卜算历史 | 同质记录列表 | JSON 数组（单 K/V value） |

结论：**无关系数据、无复杂查询、无多表关联**，采用 `shared_preferences`（K/V 存储）即可满足，无需引入 SQLite/Drift/Hive 等数据库（遵循 YAGNI 原则）。

### 1.2 存储引擎 Storage Engine

- **底层**：Android `SharedPreferences` / Windows 等价 K/V 持久化
- **Dart 封装**：`shared_preferences ^2.2`
- **特点**：异步 API、跨平台一致、零额外依赖、无事务支持

### 1.3 并发安全策略 Concurrency Safety

SharedPreferences 本身无事务/锁。卜算历史在「快速连续卜算」场景下，多个 `add` 并发执行 `load() → modify → save` 会导致 lost update。志极通过 `HistoryStore._serialize` 在应用层实现**串行化原子写**：

```
add(e) → _serialize → [load → insert(0,e) → save]  ← 排队执行，前一个完成才执行下一个
```

详见第 4 章。

---

## 2. 配置存储设计 Config Storage

### 2.1 配置 Key 清单 Config Keys

| Key | 类型 Type | 默认 Default | 含义 Meaning | 读写方 R/W |
|-----|--------|-----------|------------|---------|
| `showDetails` | bool | `true` | 起卦后是否展示真随机采样详情 | ConfigNotifier |
| `useOnline` | bool | `true` | 是否启用 random.org 在线熵源 | ConfigNotifier |
| `animationsEnabled` | bool | `true` | 微交互动效总开关 | ConfigNotifier |
| `themeMode` | string | `"dark"` | 主题模式：`light`/`dark`/`system` | ConfigNotifier |
| `anim_<techId>_<kind>` | bool | `true`（未记录时） | 某术某类动画开关 | ConfigNotifier |
| `divination_history` | string (JSON) | `"[]"` | 卜算历史 JSON 数组 | HistoryStore |

### 2.2 分术动画 Key 设计 Animation Key Design

**格式**：`anim_<techId>_<kind>`

| 组成 Part | 取值 Values | 示例 Example |
|---------|----------|------------|
| `<techId>` | 注册表 id（可能含下划线，如 `name_test`） | `xiaoliuren` / `name_test` |
| `<kind>` | `AnimationKind.name`：`entrance`/`transition`/`painter`/`reveal` | `entrance` |

**完整示例**：
- `anim_xiaoliuren_entrance`：小六壬入场仪式动画开关
- `anim_zhouyi_painter`：周易绘制过程动画开关
- `anim_name_test_reveal`：测名字结果揭示动画开关

**解析规则**（`ConfigNotifier.build`）：
1. 遍历所有以 `anim_` 开头的 key
2. 去前缀后取**最后一个下划线**分段：尾部为 `kind`，前部合并为 `techId`
3. `kind` 必须在 `AnimationKind.values` 集合内，否则跳过
4. 装入 `Map<String, Map<String, bool>>`（外层 techId，内层 kind.name）

> 为何用「最后一个下划线」分段：因为 `techId` 可能含下划线（如 `name_test`），不能简单按第一个下划线切分。

### 2.3 向前兼容 Forward Compatibility

- v2.3.2 前的旧 key `anim_<techId>`（无 kind 后缀）**不再读取**
- 未在 prefs 中记录的术/kind，`isAnimationEnabled` 返回 `true`（缺省开启）
- 新增术时无需写入任何 key，自动按缺省 true 处理

### 2.4 主题模式存储 Theme Mode

| 存储值 Stored | ThemeMode 枚举 Enum |
|------------|------------------|
| `"light"` | `ThemeMode.light` |
| `"dark"` | `ThemeMode.dark` |
| `"system"` | `ThemeMode.system` |
| null/未知 | `ThemeMode.dark`（默认深色） |

`JeenithApp._effectiveLight` 根据 themeMode + 系统亮度计算实际是否浅色主题。

---

## 3. 历史存储设计 History Storage

### 3.1 历史 Key 与结构 History Key

**Key**：`divination_history`
**Value**：JSON 字符串，反序列化为 `List<HistoryEntry>`

### 3.2 HistoryEntry JSON Schema

```json
{
  "id": "1784122714123456-0001",
  "techId": "zhouyi",
  "techName": "周易",
  "time": "2026-07-15T14:30:25.123456",
  "summary": "本卦：乾为天 → 变卦：天风姤",
  "detail": "【周易·金钱卦】\n本卦：乾为天（乾上乾下）\n...",
  "note": null
}
```

| 字段 Field | 类型 Type | 必填 Required | 说明 Description |
|---------|--------|-----------|---------------|
| `id` | string | ✅ | 唯一 ID（microsecondsSinceEpoch + 自增计数 16 进制） |
| `techId` | string | ✅ | 术标识（路由参数） |
| `techName` | string | ✅ | 术显示名（冗余存储，便于历史列表直接展示） |
| `time` | string | ✅ | 卜算时间（ISO 8601，含微秒） |
| `summary` | string | ✅ | 摘要（卦名/落宫等，列表展示） |
| `detail` | string | ✅ | 详情文本（复制/导出用，同 _buildCopyText） |
| `note` | string\|null | ❌ | 用户备注（可编辑） |

### 3.3 历史数组结构 History Array

```json
[
  { "id": "...", "techId": "zhouyi", ... },   ← 最新（index 0）
  { "id": "...", "techId": "xiaoliuren", ... },
  ...
]
```

- **顺序**：最新在前（`list.insert(0, e)`）
- **容量**：无硬上限，建议用户定期导出/清理（提供 `clear()`）
- **单条体量**：detail 文本受控（卦辞/断辞），单条约 1-5 KB

### 3.4 ID 生成策略 ID Generation

```dart
static int _counter = 0;
static String generateId() {
  final now = DateTime.now();
  _counter = (_counter + 1) & 0xFFFF;   // 0-65535 回绕
  return '${now.microsecondsSinceEpoch}-${_counter.toRadixString(16).padLeft(4, '0')}';
}
```

- 时间维度：`microsecondsSinceEpoch` 提供全局单调性
- 同帧碰撞：`_counter` 自增解决同一帧多次调用
- 回绕：`& 0xFFFF` 限制为 4 位 16 进制，固定长度

---

## 4. 原子写串行化设计 Atomic Serialization

### 4.1 问题背景 Problem Background

SharedPreferences 的 `getString` / `setString` 是独立操作，无事务。快速连续卜算时：

```
T1: load() → [A]          ← 读到空
T2: load() → [A]          ← 读到空（T1 还没 save）
T1: insert(B) → [B, A] → save([B, A])
T2: insert(C) → [C, A] → save([C, A])   ← B 丢失！
```

### 4.2 串行化方案 Serialization Solution

```dart
static Future<void> _chain = Future.value();

static Future<T> _serialize<T>(Future<T> Function() task) {
  final prev = _chain;
  final completer = Completer<T>();
  _chain = prev.then((_) => task())
      .then(completer.complete, onError: completer.completeError);
  return completer.future;
}
```

**机制**：所有写操作（add/updateNote/remove/clear）经 `_serialize` 排入 `_chain` 串行链，前一个 Future 完成后才执行下一个，保证「load → modify → save」整体原子。

**串行化后**：
```
T1: _serialize → load → insert(B) → save([B,A]) → complete
T2: _serialize → load → insert(C) → save([C,B,A]) → complete   ← 不丢
```

### 4.3 写操作清单 Write Operations

| 方法 Method | 操作 Operation | 串行化 Serialized |
|-----------|--------------|-----------------|
| `add(e)` | load → insert(0, e) → save | ✅ |
| `updateNote(id, note)` | load → 查找 → copyWith(note) → save | ✅ |
| `remove(id)` | load → removeWhere → save | ✅ |
| `clear()` | prefs.remove(_key) | ✅ |

`load()` 为只读，不串行化（但写操作内部的 load 受串行保护）。

---

## 5. 数据访问层 Data Access Layer

### 5.1 HistoryStore API

```dart
class HistoryStore {
  static Future<List<HistoryEntry>> load();                 // 读全部
  static Future<void> add(HistoryEntry e);                  // 新增
  static Future<void> updateNote(String id, String? note);  // 改备注
  static Future<void> remove(String id);                    // 删除单条
  static Future<void> clear();                              // 清空
  static String generateId();                               // 生成 ID
}
```

### 5.2 HistoryEntry 模型

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

### 5.3 容错策略 Fault Tolerance

| 场景 Scenario | 处理 Handling |
|------------|------------|
| `divination_history` key 不存在 | `load()` 返回 `<HistoryEntry>[]` |
| JSON 解析失败 | `load()` catch 后返回空列表，不抛异常 |
| 单条记录字段缺失 | `fromJson` 抛异常被上层 catch，整列表回退空 |
| SharedPreferences 写失败 | 静默失败（Future error），不崩溃 |

---

## 6. 数据导出设计 Data Export

### 6.1 HistoryExport API

`core/history/history_export.dart` 提供三种导出格式，均写入临时目录返回 `File`，调用方走 `share_plus` 分享：

| 方法 Method | 格式 Format | 用途 Usage | 文件名 Filename |
|-----------|-----------|---------|---------------|
| `exportJson(list)` | JSON | 完整保真，可重导入 | `jeenith_history_<ts>.json` |
| `exportMarkdown(list)` | Markdown | 人类可读表格 + 详情块 | `jeenith_history_<ts>.md` |
| `exportCsv(list)` | CSV | Excel 可打开 | `jeenith_history_<ts>.csv` |

### 6.2 JSON 导出格式

```json
[
  {
    "id": "...",
    "techId": "zhouyi",
    "techName": "周易",
    "time": "2026-07-15T14:30:25.123456",
    "summary": "...",
    "detail": "...",
    "note": null
  }
]
```

与 `divination_history` 存储 value 完全一致（`JsonEncoder.withIndent('  ')` 美化）。

### 6.3 Markdown 导出格式

```markdown
# 志极 Jeenith · 卜算历史

导出时间：2026-07-15 14:30:25
记录总数：12

| # | 时间 | 术 | 摘要 | 备注 |
|---|------|----|------|------|
| 1 | 2026-07-15 14:30:25 | 周易 | 本卦：乾为天 | |

---

## 1. 周易 · 本卦：乾为天

**时间**：2026-07-15 14:30:25
**详情**：

```
【周易·金钱卦】...
```
```

### 6.4 CSV 导出格式

- 首行 BOM（`\uFEFF`）确保 Excel UTF-8 正确识别
- 列：`时间,术,摘要,详情,备注`
- 含逗号/引号/换行的字段用双引号包裹，内部引号双写转义

---

## 7. 数据生命周期 Data Lifecycle

### 7.1 生命周期状态 Lifecycle States

```
[起卦生成] → HistoryStore.add → [持久化] → [历史页展示]
                                              │
                                    ┌─────────┼─────────┐
                                    ▼         ▼         ▼
                              [改备注]   [删除单条]  [导出]
                                    │         │         │
                                    └────更新────┘    [分享]
                                              │
                                         [清空] → 移除 key
```

### 7.2 容量管理 Capacity Management

- 无自动清理策略（保留全部历史供回顾）
- 提供手动 `clear()` 与单条 `remove(id)`
- 提供导出（JSON/MD/CSV）后用户自行归档
- 单条体量受控，千条记录约 1-5 MB，SharedPreferences 可承受

---

## 8. 数据安全 Data Security

| 维度 Dimension | 策略 Strategy |
|-------------|------------|
| 隐私 Privacy | 纯本地存储，无网络上报，无云端 |
| 敏感数据 Sensitive | 无密码/Token 等敏感信息；卜算历史非敏感 |
| 完整性 Integrity | JSON 解析容错，损坏回退空列表不崩溃 |
| 并发安全 Concurrency | `_serialize` 串行化原子写 |
| 备份 Backup | 导出 JSON/MD/CSV 供用户自行备份 |

---

## 9. 存储迁移 Storage Migration

### 9.1 版本迁移历史 Migration History

| 版本 Version | 变更 Change | 迁移策略 Migration |
|-----------|----------|-----------------|
| v2.3.0 | 动画设置从单一开关拆为 `Map<String, bool>`（按术） | 旧 key 不读，缺省 true |
| v2.3.2 | 进一步拆为 `Map<String, Map<String, bool>>`（按术×类型） | 旧 `anim_<techId>` 不读，新 `anim_<techId>_<kind>` 缺省 true |

### 9.2 迁移原则 Migration Principles

- **向前兼容优先**：旧 key 一律不读，新 key 缺省 true，保证升级后行为符合预期（动画默认开）
- **无显式迁移脚本**：配置类数据量小，缺省回退即可，无需写迁移代码
- **历史数据不变**：HistoryEntry JSON 结构自 v1.0 稳定，无字段废弃

---

## 10. 存储清单汇总 Storage Summary

| Key | 类型 | 写入方 Writer | 读取方 Reader | 说明 |
|-----|----|-----------|-----------|-----|
| `showDetails` | bool | ConfigNotifier | ConfigNotifier | 采样详情展示 |
| `useOnline` | bool | ConfigNotifier | ConfigNotifier / trueRandomProvider | 在线熵源 |
| `animationsEnabled` | bool | ConfigNotifier | ConfigNotifier / UI | 动画总开关 |
| `themeMode` | string | ConfigNotifier | ConfigNotifier / JeenithApp | 主题模式 |
| `anim_*_*` | bool | ConfigNotifier | ConfigNotifier / Router / UI | 分术分类型动画 |
| `divination_history` | string(JSON) | HistoryStore | HistoryStore / HistoryPage | 卜算历史 |

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
