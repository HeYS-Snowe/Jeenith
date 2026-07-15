# 卜算业务规则与状态机 Divination Business Rules & State Machine

> 志极 Jeenith · 卜算合集起卦流程、仪式动画、历史记录与配置状态机的权威规则来源

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---|---|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心）· 简称 Qore |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe（唯一开发者） |
| 技术栈 Stack | Flutter 3.x（Dart 3.11+）· Riverpod · go_router · lunar |
| 许可证 License | MIT · Copyright (c) 2026 Qore |
| 上游依赖 Depends | 《架构设计文档》《详细设计说明书》《数据模型与 API 契约》 |
| 下游 Downstream | 各 feature 的 algorithm/state/ui 实现、共享动效组件、HistoryStore |

> 本文是**卜算业务流程与状态流转的权威规则来源**。各 feature 的页面（`*_page.dart`）据 §3 实现起卦流程；仪式动画（`core/animation/ritual/`）据 §4 实现入场状态；HistoryStore 据 §5 实现持久化状态；ConfigNotifier 据 §6 实现配置状态。

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|---|---|---|
| v1.0.0 | 2026-01 | 初始状态机：起卦 → 结果 → 历史三态 |
| v2.0.0 | 2026-03 | 引入真随机引擎状态、配置 AsyncNotifier 状态 |
| v2.1.0 | 2026-04 | 仪式入场动画状态机（周易/紫微/奇门/大六壬/罗盘） |
| v2.2.0 | 2026-05 | 仪式动画扩展至梅花/掷筊/抽签/测字，跳过按钮延迟态 |
| v2.3.0 | 2026-06 | AnimationKind 拆分，配置 setter 细化为分术分类状态 |
| v2.3.3 | 2026-07-15 | 文档重写：从「校园预警状态机」全面改写为「卜算业务规则与状态机」 |

---

## 1. 业务领域概述 Domain Overview

### 1.1 核心业务流 Core Business Flow

志极 Jeenith 是一款**叩问本心的卜算合集**，核心业务流为：

```
用户选术 → 仪式入场 → 输入采集 → 真随机起卦 → 结果揭示 → 历史持久化 → 复制/分享
```

与「事件驱动 + 状态机驱动的预警系统」不同，志极的业务是**用户主动叩问 + 一次性起卦 + 结果留存**的流程型业务，无后台流转、无人工接警、无超时升级。状态机的存在意义是：

| 维度 Dimension | 状态机作用 Role |
|---|---|
| 起卦流程 Casting | 防止用户在起卦进行中重复触发，保证一次叩问一次结果 |
| 仪式动画 Ritual | 控制入场动画的播放/可跳过/完成回调，避免动画与页面跳转竞态 |
| 历史记录 History | 串行化写入，防止快速连续卜算时 load→modify→save 竞态丢数据 |
| 配置 Config | AsyncNotifier 管理 loading/data 状态，setter 原子更新 |
| 路由 Route | `/ritual/:id` → `/tech/:id` 不可绕过，仪式前置强制 |

### 1.2 与预警系统的本质差异 Differences from Alert Systems

| 维度 | 校园预警系统（旧） | 志极卜算合集（新） |
|---|---|---|
| 业务驱动 | 边缘 AI 事件推送 | 用户主动叩问 |
| 状态数量 | 6 态（pending/handling/closed/false_alarm/escalated/archived） | 4 套独立状态机 |
| 并发模型 | 多 guard 接警竞争（乐观锁） | 单用户串行起卦 |
| 时间维度 | SLA 超时自动升级 | 无超时，仪式动画可跳过 |
| 持久化 | 后端数据库 + AlertStatusLog | 本地 SharedPreferences + JSON 数组 |
| 权限 | guard/manager/admin 三级 | 单用户无权限分级 |
| 终态 | archived（不可逆） | 历史可清空、可单条删除 |

---

## 2. 术语表 Glossary

| 术语 Term | 含义 Meaning |
|---|---|
| **术 Tech** | 一种卜算方法，实现 `DivinationTech` 接口，如小六壬、周易 |
| **起卦 Cast** | 一次完整的卜算过程，从输入到结果 |
| **仪式 Ritual** | 起卦前的入场动画，对应路由 `/ritual/:id` |
| **真随机 TrueRandom** | 多源 SHA256 混合的随机数引擎 |
| **熵源 Entropy Source** | 真随机的输入源（系统熵/触摸轨迹/在线大气噪声） |
| **卦象 Result** | 起卦产物，封装为 `DivinationResult` |
| **历史条目 HistoryEntry** | 持久化到 SharedPreferences 的一条卜算记录 |
| **AnimationKind** | 动画分类枚举：entrance/transition/painter/reveal |

---

## 3. 起卦流程状态机 Casting Flow State Machine

### 3.1 状态枚举 States

各 feature 的 `*_page.dart` 通过 StatefulWidget 局部状态管理起卦流程。状态枚举如下（语义统一，命名可各术自定）：

| 状态 State | 含义 Meaning | UI 表现 Visual |
|---|---|---|
| `idle` | 空闲，等待用户触发 | 起卦按钮可点击 |
| `inputting` | 输入采集中（部分术需用户输入，如测字输入字、八字输入时辰） | 输入框激活，起卦按钮禁用 |
| `casting` | 真随机生成 + 算法推演中 | `DivinationLoadingIndicator` 加载态 |
| `revealing` | 结果揭示动画播放中 | 结果卡片渐显/上浮 |
| `result` | 结果展示完成，可复制/分享/再起 | 结果卡片稳定，操作按钮可点击 |

### 3.2 状态迁移图 Transition Diagram

```
                      ┌──── (用户输入完成) ────┐
                      ▼                          │
   [进入页面] ──▶ idle ──(点击起卦)──▶ inputting ─┘
                   │                            │
                   │                            (无需输入的术直接)
                   │                                  │
                   └──(无需输入)──────────────────────┤
                                                      ▼
                                              casting ──(算法返回)──▶ revealing ──(动画完)──▶ result
                                                  │                                          │
                                                  │                                          │
                                                  └──(异常/取消)──▶ idle                      └──(再起一卦)──▶ idle
```

### 3.3 迁移表 Transition Table

| from | 事件 event | to | 前置条件 Precondition | 后置动作 Post-action |
|---|---|---|---|---|
| `idle` | `start` 用户点击起卦 | `inputting` 或 `casting` | 该术需输入则 `inputting`，否则 `casting` | 禁用起卦按钮 |
| `inputting` | `submit` 输入完成 | `casting` | 输入校验通过 | 调用 `TrueRandom.generate` |
| `inputting` | `cancel` 取消输入 | `idle` | — | 清空输入 |
| `casting` | `generated` 真随机 + 算法完成 | `revealing` | `DivinationResult` 非空 | 启动揭示动画 |
| `casting` | `error` 异常 | `idle` | — | 错误提示，恢复起卦按钮 |
| `revealing` | `revealed` 揭示动画完成 | `result` | — | 调用 `HistoryStore.add` 持久化 |
| `result` | `recast` 再起一卦 | `idle` 或 `casting` | — | 清空结果，重置状态 |
| `result` | `copy` / `share` | `result` | — | 不改变状态，仅触发副作用 |

### 3.4 起卦流程不变量 Invariants

- **INV-CAST-1**：`casting` 状态下起卦按钮必须禁用，防止重复触发
- **INV-CAST-2**：`revealing` → `result` 迁移时**必须**调用 `HistoryStore.add`，确保结果落盘
- **INV-CAST-3**：真随机数**必须**经 `TrueRandom.generate` 生成，禁止使用 `math.Random` 伪随机
- **INV-CAST-4**：`error` 迁移回 `idle` 后，UI 状态必须完全可重入（无残留中间态）

---

## 4. 仪式动画状态机 Ritual Animation State Machine

### 4.1 状态枚举 States

仪式入场动画（`core/animation/ritual/<tech>_ritual.dart`）控制起卦前的沉浸式过渡。状态如下：

| 状态 State | 含义 Meaning | 触发条件 Trigger |
|---|---|---|
| `idle` | 动画未启动 | 页面构建完成 |
| `playing` | 仪式动画播放中 | `AnimationController.forward()` |
| `completable` | 跳过按钮已显示，用户可跳过 | 动画播放满 `skipButtonDelay`（3000ms） |
| `completed` | 动画自然结束 | `AnimationController.addStatusListener(completed)` |
| `skipped` | 用户主动跳过 | 跳过按钮 `onPressed` |

### 4.2 状态迁移图 Transition Diagram

```
   [页面构建] ──▶ idle ──(forward)──▶ playing ──(t ≥ 3000ms)──▶ completable
                                         │                              │
                                         │                              │
                                         ├──(动画自然结束)──▶ completed ─┤
                                         │                              │
                                         └──(用户点击跳过)──▶ skipped ───┤
                                                                         │
                                                                         ▼
                                                                  onCompleted()
                                                                  context.go('/tech/<id>')
```

### 4.3 迁移表 Transition Table

| from | 事件 event | to | 前置条件 Precondition | 后置动作 Post-action |
|---|---|---|---|---|
| `idle` | `forward` 启动动画 | `playing` | `AppConfig.isAnimationEnabled(techId, AnimationKind.entrance)` 为 true | `AnimationController.forward()` |
| `playing` | `tick` 播放满 3000ms | `completable` | — | 显示跳过按钮（淡入） |
| `playing` | `complete` 动画结束 | `completed` | — | 触发 `onCompleted` 回调 |
| `completable` | `skip` 用户跳过 | `skipped` | — | `AnimationController.stop()` + 触发 `onCompleted` |
| `completable` | `complete` 动画结束 | `completed` | — | 触发 `onCompleted` 回调 |
| `completed` / `skipped` | `navigate` 路由跳转 | — | — | `context.go('/tech/<id>')` |

### 4.4 仪式动画不变量 Invariants

- **INV-RIT-1**：`onCompleted` 回调**必须且只能触发一次**（`completed` 与 `skipped` 互斥）
- **INV-RIT-2**：跳过按钮**必须**延迟 `skipButtonDelay`（3000ms）显示，避免用户误触直接跳过仪式感
- **INV-RIT-3**：动画开关关闭时，仪式路由应**直接** `onCompleted`，不进入 `playing` 状态（由路由层或仪式组件判断）
- **INV-RIT-4**：`AnimationController` 必须在 `State.dispose` 中释放，防止内存泄漏

### 4.5 各术仪式时长 Ritual Durations

| 术 Tech | 仪式时长 Duration | 动画主题 Theme |
|---|---|---|
| 周易 zhouyi | 5000ms | 铜钱抛落 6 轮 |
| 紫微 ziwei | 6000ms | 命盘展开 + 14 主星降落 |
| 奇门 qimen | 5000ms | 九宫飞布 + 值符值使 |
| 大六壬 daliuren | 5000ms | 天地双盘旋转 + 四课三传 |
| 风水罗盘 luopan | 4000ms | 指针扫描 + 24 山点亮 |
| 梅花 meihua | 4000ms | 数字飘落撞击 + 卦象淡入 |
| 掷筊 jiaobei | 3000ms | 杯筊抛物线 + 翻滚 + 定型 |
| 测字 cezi | 5000ms | 字形浮现 + 五行色染 |
| 抽签 chouqian | 5000ms | 签筒摇晃 + 签条跳出 + 卷轴展开 |
| 小六壬 xiaoliuren | 自定 | 太极生六宫 |

> 时长常量统一定义在 `core/theme/animations.dart` 的 `AppAnimations.ritual<Tech>` 系列。

---

## 5. 历史记录状态机 History Record State Machine

### 5.1 持久化状态枚举 Persistence States

`HistoryStore` 管理 `divination_history` JSON 数组，单条 `HistoryEntry` 的生命周期状态：

| 状态 State | 含义 Meaning | 存储位置 Storage |
|---|---|---|
| `created` | 内存中构造完成，待写入 | `HistoryEntry` 对象 |
| `persisted` | 已写入 SharedPreferences | `divination_history` JSON 数组首项 |
| `editable` | 已持久化，可更新 note | 同上，`note` 字段可变 |
| `removed` | 已从数组移除 | 不再存在于 JSON |
| `cleared` | 全部历史清空 | `divination_history` key 被移除 |

### 5.2 状态迁移图 Transition Diagram

```
   [起卦完成] ──▶ created ──(HistoryStore.add)──▶ persisted ──┬──(updateNote)──▶ editable ──┐
                                                                │                          │
                                                                │                          │(再次 updateNote)
                                                                ├──(remove)──▶ removed       │
                                                                │                          │
                                                                └──(clear all)──▶ cleared   └──▶ persisted（同一条）
                                                                       ▲
                                                                       │
                                                              (clear 影响所有条目)
```

### 5.3 迁移表 Transition Table

| from | 事件 event | to | 操作 API | 串行化 Serialized |
|---|---|---|---|---|
| `created` | `add` | `persisted` | `HistoryStore.add(entry)` | ✅ 是 |
| `persisted` / `editable` | `updateNote` | `editable` | `HistoryStore.updateNote(id, note)` | ✅ 是 |
| `persisted` / `editable` | `remove` | `removed` | `HistoryStore.remove(id)` | ✅ 是 |
| 任意 | `clear` | `cleared` | `HistoryStore.clear()` | ✅ 是 |

### 5.4 串行化机制 Serialization Mechanism

`HistoryStore` 所有写操作**必须**经 `_serialize` 串行化，避免 load→modify→save 竞态：

```dart
static Future<void> _chain = Future.value();

static Future<T> _serialize<T>(Future<T> Function() task) {
  final prev = _chain;
  final completer = Completer<T>();
  _chain = prev.then((_) => task()).then(completer.complete, onError: completer.completeError);
  return completer.future;
}
```

**串行化状态链**：

```
add(req1) ──▶ [load → insert → save] ──▶ add(req2) ──▶ [load → insert → save] ──▶ ...
```

每个写操作排队等待前一个完成，确保 load 时读到的是最新状态。**违反此机制将导致快速连续卜算时后写入覆盖前写入**（项目硬约束）。

### 5.5 ID 生成策略 ID Generation

```dart
static int _counter = 0;
static String generateId() {
  final now = DateTime.now();
  _counter = (_counter + 1) & 0xFFFF;
  return '${now.microsecondsSinceEpoch}-${_counter.toRadixString(16).padLeft(4, '0')}';
}
```

- **时间戳**：`microsecondsSinceEpoch` 提供单调基准
- **自增计数**：`& 0xFFFF` 循环 65536，避免同一帧多次调用碰撞
- **格式**：`<microseconds>-<hex4>`，如 `1800000000000000-0001`
- **不变量 INV-HIST-1**：ID 单调递增（同一进程内），最新记录始终在数组首项

### 5.6 JSON 容错 JSON Fault Tolerance

```dart
static Future<List<HistoryEntry>> load() async {
  final prefs = await SharedPreferences.getInstance();
  final s = prefs.getString(_key);
  if (s == null) return <HistoryEntry>[];
  try {
    final list = jsonDecode(s) as List;
    return list.map((j) => HistoryEntry.fromJson(j as Map<String, dynamic>)).toList();
  } catch (_) {
    return <HistoryEntry>[];  // 解析失败返回空列表，不抛异常崩溃
  }
}
```

**不变量 INV-HIST-2**：`load()` 永不抛异常，JSON 损坏时降级为空列表，保证 APP 不崩溃。

---

## 6. 配置状态机 Config State Machine

### 6.1 状态枚举 States

`ConfigNotifier extends AsyncNotifier<AppConfig>` 管理应用配置：

| 状态 State | 含义 Meaning | Riverpod 表现 |
|---|---|---|
| `loading` | 初始化中，正在从 SharedPreferences 读取 | `AsyncLoading<AppConfig>` |
| `data` | 配置就绪 | `AsyncData<AppConfig>` |
| `error` | 初始化异常（极少，prefs 不可用） | `AsyncError<AppConfig>` |

### 6.2 状态迁移图 Transition Diagram

```
   [APP 启动] ──▶ loading ──(prefs 读取完成)──▶ data ──┬──(setShowDetails)──▶ data'
                                                       ├──(setUseOnline)────▶ data'
                                                       ├──(setAnimationsEnabled)──▶ data'
                                                       ├──(setAnimationSetting)──▶ data'
                                                       ├──(setAllAnimations)──▶ data'
                                                       └──(setThemeMode)────▶ data'
```

### 6.3 Setter 原子更新流程 Setter Atomic Update

所有 setter 遵循统一的「写 prefs → await future → state = AsyncData(copyWith)」三步流程：

```dart
Future<void> setShowDetails(bool v) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showDetails', v);          // 1. 先写盘
  final current = await future;                    // 2. 等待当前状态就绪
  state = AsyncData(current.copyWith(showDetails: v));  // 3. 原子更新状态
}
```

**不变量 INV-CFG-1**：prefs 写入与 state 更新顺序**必须**先写盘后更新状态，避免 UI 看到新状态但 prefs 未持久化（重启后回滚）
**不变量 INV-CFG-2**：setter 必须用 `copyWith` 不可变更新，禁止直接修改 `current` 字段

### 6.4 动画开关层级 Animation Toggle Hierarchy

动画开关采用**三层降级**判断，`AppConfig.isAnimationEnabled(techId, kind)` 逻辑：

```
1. 全局总开关 animationsEnabled = false  →  返回 false（最高优先级）
2. 分术分分类开关 animationSettings[techId][kind] = false  →  返回 false
3. 缺省（未显式设置）  →  返回 true（默认开启）
```

| 层级 Level | Key 格式 | 默认值 Default | 作用域 Scope |
|---|---|---|---|
| 全局 | `animationsEnabled` | `true` | 全 APP 所有动效 |
| 分术分类 | `anim_<techId>_<kind>` | `true`（缺省） | 单术单 AnimationKind |

**AnimationKind 枚举**：

| kind | 含义 | 典型场景 |
|---|---|---|
| `entrance` | 入场仪式 | `/ritual/:id` 仪式动画 |
| `transition` | 路由转场 | `/tech/:id` 页面进入转场 |
| `painter` | 绘制过程 | CustomPainter 动态绘制（如紫微盘旋转、罗盘扫描） |
| `reveal` | 结果揭示 | 起卦结果卡片渐显 |

**Key 解析规则**：`anim_<techId>_<kind>` 中 techId 可能含下划线（如 `name_test`），因此以**最后一个下划线**分段：尾部为 kind，前面合并为 techId。

### 6.5 批量操作 Bulk Operations

`setAllAnimations(techIds, v)` 一键开关所有术的所有分类：

```dart
for (final id in techIds) {
  for (final kind in AnimationKind.values) {
    await prefs.setBool('anim_${id}_${kind.name}', v);
  }
}
```

设置页提供「开启所有分类」/「关闭所有分类」按钮，对应 `v = true` / `v = false`。

---

## 7. 路由状态机 Route State Machine

### 7.1 路由流转图 Route Flow

```
   / (首页 grid)
       │
       ├──(点击术卡片)──▶ /ritual/:id (仪式入场)
       │                        │
       │                        ├──(动画完成 / 跳过)──▶ /tech/:id (术主页面)
       │                        │
       │                        └──(动画开关关闭)──▶ /tech/:id (直接跳过仪式)
       │
       ├──(底部导航)──▶ /history (历史)
       ├──(底部导航)──▶ /settings (设置)
       └──(底部导航)──▶ /manual (手册)
```

### 7.2 路由状态表 Route Table

| 路由 Route | 类型 Type | 状态管理 State | 说明 |
|---|---|---|---|
| `/` | 系统 | 无状态 | 首页 grid，`visibleTechsProvider` 驱动 |
| `/history` | 系统 | `FutureBuilder<List<HistoryEntry>>` | 历史列表，`HistoryStore.load` |
| `/settings` | 系统 | `ConsumerWidget` watch `configProvider` | 设置页 |
| `/manual` | 系统 | 无状态 | 使用手册 |
| `/ritual/:id` | 仪式 | StatefulWidget + AnimationController | 10 个术的入场动画 |
| `/tech/:id` | 动态 | `techByIdProvider.family` 解析 | 术主页面，带 `TechTransition` 转场 |

### 7.3 路由解析状态 Route Resolution

`/tech/:id` 路由的解析流程：

```
1. 从 state.pathParameters 取 id
2. ref.read(techByIdProvider(id))
   ├── 返回 null  →  渲染 "未知卜算法" 兜底页
   └── 返回 tech  →  渲染 _TechPage(tech: tech)
3. 读取 configProvider 判断 transition 动画开关
   ├── 开启  →  TechTransition.build（签名转场）
   └── 关闭  →  TechTransition.build 降级为 fade
```

**不变量 INV-ROUTE-1**：`techByIdProvider` 返回 null 时**禁止崩溃**，必须渲染兜底页
**不变量 INV-ROUTE-2**：`/tech/:id` **必须**经 `/ritual/:id` 入场（仪式前置），但仪式动画开关关闭时可直接 `context.go('/tech/:id')`

### 7.4 转场降级 Transition Fallback

`TechTransition.build` 根据动画开关决定转场方式：

| 条件 Condition | 转场 Transition |
|---|---|
| `transitionsEnabled = true` | 术签名转场（如紫微辐射、奇门九宫） |
| `transitionsEnabled = false` | 淡入淡出（`fadeTransition`） |

---

## 8. 真随机引擎状态 TrueRandom Engine State

### 8.1 熵采集流程 Entropy Collection

`TrueRandom.generate` 的内部状态流转：

```
   [调用 generate]
       │
       ▼
   遍历 sources（3 源）
       │
       ├── SystemEntropySource ──(Random.secure)──▶ bytes ✓
       ├── TouchEntropySource  ──(轨迹采样)──────▶ bytes ✓ 或 失败 ✗
       └── OnlineEntropySource ──(random.org http)─▶ bytes ✓ 或 失败 ✗
       │
       ▼
   多源 SHA256 链式混合
       │
       ▼
   收尾加盐（时间戳 + 16 字节系统熵）
       │
       ▼
   链式 SHA256 扩展为 count 个数
       │
       ▼
   返回 EntropySample(numbers, sources, timestamp)
```

### 8.2 熵源降级状态 Source Degradation

| 状态 State | 触发 Trigger | 处理 Handling |
|---|---|---|
| `available` | `src.isAvailable = true` | 正常采样 |
| `unavailable` | `src.isAvailable = false` | 跳过，记录 `succeeded: false` |
| `failed` | `src.sample()` 抛异常 | 跳过，记录 `display: '采样失败'` |

**不变量 INV-RNG-1**：任一熵源失败**不影响**整体生成，只要至少一个源成功即可
**不变量 INV-RNG-2**：在线源（random.org）失败时静默降级，不提示用户（离线可用是硬约束）
**不变量 INV-RNG-3**：`parts` 为空（所有源失败）时，仍通过收尾加盐的 SHA256 生成结果，保证不抛异常

### 8.3 在线熵源开关 Online Entropy Toggle

`AppConfig.useOnline` 控制是否启用在线熵源：

| useOnline | OnlineEntropySource 状态 | 行为 |
|---|---|---|
| `true`（默认） | `isAvailable = true` | 尝试请求 random.org |
| `false` | `isAvailable = false` | 跳过，仅用系统熵 + 触摸轨迹 |

设置页可手动关闭以节省流量或离线使用。

---

## 9. 业务规则不变量汇总 Business Rule Invariants

### 9.1 核心规则 Core Rules

| 规则 ID | 规则内容 Rule | 违反后果 Consequence |
|---|---|---|
| **R1 真随机性** | 所有起卦**必须**经 `TrueRandom.generate`，禁止 `math.Random` | 卜算结果可预知，失去严肃性 |
| **R2 历史串行化** | `HistoryStore` 写操作**必须**经 `_serialize` 串行化 | 快速连续卜算时后写覆盖前写，丢数据 |
| **R3 ID 单调性** | `generateId` 基于 `microsecondsSinceEpoch` + 自增计数 | 同帧碰撞，历史排序错乱 |
| **R4 动画开关层级** | 全局 → 分术分分类 三层降级判断 | 用户关闭动画后仍播放，体验不一致 |
| **R5 仪式前置** | `/tech/:id` **应**经 `/ritual/:id` 入场（动画开启时强制） | 仪式感缺失，但功能仍可用 |
| **R6 JSON 容错** | `HistoryStore.load` 解析失败返回空列表 | APP 崩溃 |
| **R7 在线降级** | 在线熵源失败静默跳过，离线仍可用 | 无网络时无法卜算 |
| **R8 CustomPainter dispose** | CustomPainter 必须 `dispose` TextPainter | native handle 泄漏 |

### 9.2 配置规则 Config Rules

| 规则 ID | 规则内容 Rule |
|---|---|
| **R9 配置原子更新** | setter 必须先写 prefs 后更新 state，`copyWith` 不可变更新 |
| **R10 配置默认值** | 首次启动所有配置取默认值（showDetails=true, useOnline=true, animationsEnabled=true, themeMode=dark） |
| **R11 Key 解析** | `anim_<techId>_<kind>` 以最后一个下划线分段，techId 可含下划线 |
| **R12 未知 kind 跳过** | 解析 prefs 时遇到未知 kind 名的 key 跳过，不报错（前向兼容） |

### 9.3 路由规则 Route Rules

| 规则 ID | 规则内容 Rule |
|---|---|
| **R13 未知术兜底** | `techByIdProvider` 返回 null 时渲染"未知卜算法"页，不崩溃 |
| **R14 转场降级** | transition 动画关闭时，`TechTransition` 降级为 fade |
| **R15 仪式可跳过** | 仪式动画播放满 3000ms 后显示跳过按钮，用户可主动跳过 |

---

## 10. 状态机交互矩阵 State Machine Interaction Matrix

各状态机之间的交互关系：

```
┌──────────────────┐
│  起卦流程状态机   │
│  (page 局部状态)  │
└─────────┬────────┘
          │ revealing → result 时
          ▼
┌──────────────────┐         ┌──────────────────┐
│  历史记录状态机   │◄────────│  真随机引擎状态   │
│ (HistoryStore)   │         │  (TrueRandom)    │
└─────────┬────────┘         └──────────────────┘
          │                        ▲
          │                        │ useOnline 控制
          ▼                        │
┌──────────────────┐         ┌──────────────────┐
│  配置状态机       │────────►│  在线熵源开关     │
│ (ConfigNotifier) │         │                  │
└─────────┬────────┘         └──────────────────┘
          │
          │ animationsEnabled / isAnimationEnabled
          ▼
┌──────────────────┐         ┌──────────────────┐
│  仪式动画状态机   │────────►│  路由状态机       │
│ (ritual widget)  │         │  (GoRouter)      │
└──────────────────┘         └──────────────────┘
```

| 触发方 From | 接收方 To | 交互点 Interaction |
|---|---|---|
| 起卦流程 | 真随机引擎 | `casting` 状态调用 `TrueRandom.generate` |
| 起卦流程 | 历史记录 | `revealing → result` 时调用 `HistoryStore.add` |
| 配置 | 真随机引擎 | `useOnline` 控制在线熵源 `isAvailable` |
| 配置 | 仪式动画 | `isAnimationEnabled(techId, entrance)` 控制仪式是否播放 |
| 配置 | 路由转场 | `isAnimationEnabled(techId, transition)` 控制转场降级 |
| 仪式动画 | 路由 | `onCompleted` 回调触发 `context.go('/tech/:id')` |
| 路由 | 配置 | `/tech/:id` pageBuilder 读取 `configProvider` 决定转场 |

---

## 11. 异常场景处理 Exception Handling

### 11.1 起卦异常 Casting Errors

| 异常 Exception | 处理 Handling | 状态迁移 Transition |
|---|---|---|
| 真随机生成超时 | 静默降级（在线源超时跳过） | `casting` 继续，不回退 |
| 算法异常（如 lunar 解析失败） | try-catch，提示"起卦失败" | `casting → idle` |
| 输入校验失败 | 输入框红色提示 | `inputting` 保持，不进 `casting` |

### 11.2 持久化异常 Persistence Errors

| 异常 Exception | 处理 Handling |
|---|---|
| SharedPreferences 写入失败 | 异常向上抛（极少，通常 prefs 总可用） |
| JSON 解析失败 | `load()` 返回空列表，不崩溃 |
| ID 碰撞（理论不可能） | 自增计数 + 时间戳，单进程内保证唯一 |

### 11.3 动画异常 Animation Errors

| 异常 Exception | 处理 Handling |
|---|---|
| AnimationController 未 dispose | State.dispose 强制释放（防内存泄漏） |
| 仪式动画 widget 被中途 unmount | `onCompleted` 通过 `if (mounted)` 守卫 |
| CustomPainter TextPainter 未 dispose | 项目硬约束：必须显式 dispose |

---

## 12. 状态持久化与恢复 State Persistence & Recovery

### 12.1 APP 重启后的状态恢复 State Recovery After Restart

| 状态机 State Machine | 重启后恢复 Recovery | 说明 |
|---|---|---|
| 起卦流程 | ❌ 不恢复 | 起卦是即时操作，中断即放弃 |
| 仪式动画 | ❌ 不恢复 | 仪式是过渡，重启后回首页 |
| 历史记录 | ✅ 恢复 | 从 `divination_history` JSON 加载 |
| 配置 | ✅ 恢复 | 从 SharedPreferences 各 key 加载 |
| 路由 | ❌ 不恢复 | initialLocation 固定为 `/` |

### 12.2 配置加载顺序 Config Load Order

`ConfigNotifier.build()` 的加载顺序：

1. 实例化 SharedPreferences
2. 遍历所有 `anim_*` key，按最后一个下划线分段解析为 `animationSettings` Map
3. 读取 `showDetails` / `useOnline` / `animationsEnabled` / `themeMode`
4. 构造 `AppConfig` 返回，状态从 `AsyncLoading` → `AsyncData`

---

## 附录 A：状态机与源文件映射 Source Mapping

| 状态机 State Machine | 源文件 Source File |
|---|---|
| 起卦流程 | 各 `features/<tech>/ui/<tech>_page.dart` 的 StatefulWidget 局部状态 |
| 仪式动画 | `core/animation/ritual/<tech>_ritual.dart` + `features/xiaoliuren/ui/xiaoliuren_ritual.dart` |
| 历史记录 | `core/history/history_store.dart` |
| 配置 | `core/config/config_providers.dart`（`ConfigNotifier`） |
| 路由 | `router/app_router.dart`（`routerProvider`） |
| 真随机 | `core/rng/true_random.dart` |

## 附录 B：AnimationKind 与动效常量速查

| AnimationKind | 控制范围 Scope | AppAnimations 常量 |
|---|---|---|
| `entrance` | 仪式入场动画 | `ritualZhouyi=5000` / `ritualZiwei=6000` / `ritualQimen=5000` / `ritualDaliuren=5000` / `ritualLuopan=4000` / `ritualMeihua=4000` / `ritualJiaobei=3000` / `ritualCezi=5000` / `ritualChouqian=5000` / `skipButtonDelay=3000` |
| `transition` | 路由转场 | `TechTransition` 自定义转场，降级为 fade |
| `painter` | CustomPainter 绘制 | 各术 CustomPainter 内部 AnimationController |
| `reveal` | 结果揭示 | 各术结果卡片渐显/上浮动画 |

## 附录 C：SharedPreferences Key 清单

| Key | 类型 Type | 默认 Default | 作用 Scope |
|---|---|---|---|
| `divination_history` | String (JSON) | `null` | 历史记录数组 |
| `showDetails` | bool | `true` | 是否展示详情 |
| `useOnline` | bool | `true` | 在线熵源开关 |
| `animationsEnabled` | bool | `true` | 动画总开关 |
| `themeMode` | String | `dark` | 主题模式（light/dark/system） |
| `anim_<techId>_<kind>` | bool | `true`（缺省） | 分术分分类动画开关 |

---

**文档结束** —— 上游：《架构设计文档》《详细设计说明书》；下游：各 feature 实现、HistoryStore、ConfigNotifier、仪式动画组件。
