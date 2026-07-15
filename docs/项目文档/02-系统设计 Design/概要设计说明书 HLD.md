# 概要设计说明书 High Level Design Document

> 志极 Jeenith · 卜算合集系统概要设计

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
| v1.0.0 | 2026-01 | 初版：12 术模块划分、接口设计 |
| v2.3.0 | 2026-06 | 新增八字/测名字模块、紫微盘重构 |
| v2.3.3 | 2026-07-15 | 同步当前版本，补全接口契约 |

---

## 1. 系统概述 System Overview

### 1.1 系统目标 System Goals

志极 Jeenith 是一款面向传统文化的**纯客户端卜算合集移动应用**，目标为：

- 提供小六壬、周易、梅花易数等十二种传统术数的完整卜算体验
- 通过可扩展框架（DivinationTech 接口 + 注册表）支持低成本的术数扩展
- 以真随机引擎（多源 SHA256）保障起卦的不可预知性与严肃性
- 以仪式动画与星空背景营造沉浸式卜算氛围
- 跨平台支持 Android 移动端与 Windows 桌面端

### 1.2 系统边界 System Boundary

| 边界类型 Boundary | 说明 Description |
|----------------|----------------|
| 内部 Internal | 全部卜算算法、UI、配置、历史均在本地完成 |
| 外部 External | 仅 random.org 在线熵源（可选，可关闭）、share_plus 系统分享 |
| 非目标 Non-Goal | 无后端服务、无账号体系、无云同步、无社交功能 |

### 1.3 用户特征 User Characteristics

- 传统文化爱好者、术数研习者
- 单一开发者维护，文档面向开发与归档双重目的

---

## 2. 系统总体设计 Overall Design

### 2.1 总体结构 Overall Structure

系统采用**分层 + 注册表插件化**架构，自顶向下五层：

```
应用层   →  JeenithApp（MaterialApp.router + Starfield + 主题）
路由层   →  GoRouter（/ /ritual/:id /tech/:id 等声明式路由）
功能层   →  features/（12 术 + 4 系统页，每术自洽）
共享层   →  shared/widgets/（14 个复用组件）
能力层   →  core/（divination/rng/config/history/calendar/theme/animation）
数据层   →  data/yijing（64 卦共享数据）
```

### 2.2 运行环境 Runtime Environment

| 维度 Dimension | 配置 Configuration |
|--------------|------------------|
| 移动端 OS | Android 5.0+（minSdk）/ iOS 可编译未上架 |
| 桌面端 OS | Windows 10+ |
| 框架 | Flutter 3.x（Dart 3.11+） |
| 传感器 | 陀螺仪/磁场（仅风水罗盘，可选） |
| 网络 | random.org（可选，HTTP） |

---

## 3. 模块划分 Module Partition

### 3.1 模块总览 Module Overview

| 模块 Module | 类型 Type | 职责 Responsibility |
|------------|---------|-------------------|
| core/divination | 能力 | DivinationTech 接口、注册表、统一结果模型 |
| core/rng | 能力 | 真随机引擎（3 源 SHA256 混合） |
| core/config | 能力 | AppConfig 配置模型 + ConfigNotifier + 平台检测 |
| core/history | 能力 | 历史存储（原子写）+ 导出 |
| core/calendar | 能力 | 农历服务（封装 lunar） |
| core/theme | 能力 | 色彩/字体/主题/动效常量 |
| core/animation | 能力 | 仪式动画/转场/揭示/粒子/绘制 |
| data/yijing | 数据 | 64 卦 + 八卦数据 |
| features/* | 功能 | 12 术独立模块 + 4 系统页 |
| shared/widgets | 共享 | 14 个复用 UI 组件 |
| router | 路由 | GoRouter 路由表 + 转场控制 |
| providers | 聚合 | barrel export config + rng providers |

### 3.2 功能模块功能矩阵 Feature Matrix

| 术 Tech | 输入采集 Input | 起卦算法 Algorithm | 仪式动画 Ritual | 结果展示 Result |
|--------|-------------|----------------|--------------|--------------|
| 小六壬 | 真随机 3 数 | 三段掐指落宫 | 太极生六宫 | 三宫卡 + 七维断辞 |
| 周易 | 真随机 6 爻 | 金钱卦动爻 | 铜钱抛落 | 本卦+变卦+爻辞 |
| 梅花易数 | 数/时起卦 | 体用生克 | 数字撞击 | 卦象 + 断语 |
| 掷筊 | 真随机 | 圣杯三掷 | 杯筊翻转 | 圣/笑/阴判定 |
| 紫微斗数 | 生辰 | 安星布局 | 命盘展开 | 12 宫 + 主星 |
| 奇门遁甲 | 时辰 | 九宫飞布 | 九宫飞布 | 八门九星八神 |
| 抽签 | 真随机 | 签号抽取 | 卷轴展开 | 签文 + 解 |
| 测字 | 手写/输入 | 字形五行 | 字形浮现 | 五行 + 断语 |
| 大六壬 | 时辰 | 四课三传 | 双盘旋转 | 三传 + 四课 |
| 风水罗盘 | 传感器/触摸 | 24 山方位 | 罗盘扫描 | 方位 + 吉凶 |
| 测名字 | 姓名输入 | 三才五格 | — | 五格 + 三才 |
| 八字推演 | 生辰 | 四柱排盘 | — | 四柱 + 大运 |

### 3.3 系统页模块 System Pages

| 页面 Page | 路由 Route | 职责 |
|---------|----------|-----|
| 首页 Home | `/` | 术数 grid 入口 + 品牌展示 |
| 历史 History | `/history` | 卜算历史列表 + 备注 + 导出 |
| 设置 Settings | `/settings` | 熵源/动画/主题配置 |
| 手册 Manual | `/manual` | 各术使用说明 |

---

## 4. 接口设计 Interface Design

### 4.1 核心抽象接口 Core Abstract Interface

#### 4.1.1 DivinationTech —— 卜算术接口

```dart
abstract class DivinationTech {
  String get id;                                    // 唯一标识（路由参数）
  TechMeta get meta;                                // 展示元数据
  Widget buildPage(BuildContext context, WidgetRef ref);  // 构建主页
}
```

每种术实现此接口，框架统一提供注册发现、RNG、配置、主题、共享组件。

#### 4.1.2 EntropyCollector —— 熵源接口

```dart
abstract class EntropyCollector {
  String get name;
  bool get isAvailable;
  Future<({String display, Uint8List bytes})> sample();
}
```

#### 4.1.3 TechMeta —— 术元数据

```dart
class TechMeta {
  final String id;            // 路由参数
  final String displayName;   // 显示名
  final String subtitle;      // 副标题
  final String description;   // 描述
  final Color accentColor;    // 主题色
  final int sortOrder;        // 排序
  final bool enabled;         // 功能开关
}
```

### 4.2 服务接口 Service Interfaces

#### 4.2.1 TrueRandom

```dart
class TrueRandom {
  Future<EntropySample> generate({int count = 3, int vmax = 9});
}
```

#### 4.2.2 HistoryStore

```dart
class HistoryStore {
  static Future<List<HistoryEntry>> load();
  static Future<void> add(HistoryEntry e);
  static Future<void> updateNote(String id, String? note);
  static Future<void> remove(String id);
  static Future<void> clear();
}
```

#### 4.2.3 LunarService

```dart
class LunarService {
  static ({int month, int day, String display}) nowLunarMonthDay();
}
```

#### 4.2.4 ConfigNotifier

```dart
class ConfigNotifier extends AsyncNotifier<AppConfig> {
  Future<void> setShowDetails(bool v);
  Future<void> setUseOnline(bool v);
  Future<void> setAnimationsEnabled(bool v);
  Future<void> setAnimationSetting(String techId, AnimationKind kind, bool v);
  Future<void> setAllAnimations(List<String> techIds, bool v);
  Future<void> setThemeMode(ThemeMode v);
}
```

### 4.3 Provider 依赖接口 Provider Interfaces

| Provider | 类型 Type | 作用 Role |
|---------|--------|---------|
| `configProvider` | AsyncNotifierProvider<ConfigNotifier, AppConfig> | 配置状态 |
| `trueRandomProvider` | Provider<TrueRandom> | 真随机引擎实例 |
| `touchTrackerProvider` | Provider<TouchTracker> | 触摸轨迹采集 |
| `divinationTechsProvider` | Provider<List<DivinationTech>> | 全部注册术 |
| `visibleTechsProvider` | Provider<List<DivinationTech>> | 可见术（已启用+排序） |
| `techByIdProvider` | Provider.family<DivinationTech?, String> | 按 id 查术 |
| `routerProvider` | Provider<GoRouter> | 路由实例 |

---

## 5. 关键流程设计 Key Process Design

### 5.1 卜算主流程 Divination Flow

```
用户点击首页术卡片
    │
    ▼
路由 /ritual/<id>（仪式入场动画，可跳过）
    │ onCompleted
    ▼
路由 /tech/<id> → techByIdProvider 解析 → TechTransition 转场
    │
    ▼
术页面（采集输入 / 调用 TrueRandom.generate）
    │
    ▼
algorithm 起卦 → 构造 DivinationResult
    │
    ├─► UI 渲染（RevealAnimation 揭示 + ResultCard 卡片）
    └─► HistoryStore.add（异步持久化）
```

### 5.2 真随机生成流程 RNG Flow

```
TrueRandom.generate(count, vmax)
    │
    ├─► SystemEntropySource.sample()  → bytes
    ├─► TouchEntropySource.sample()   → bytes（依赖 TouchTracker）
    └─► OnlineEntropySource.sample()  → bytes（random.org，可失败）
                │
                ▼
        多源 SHA256 链式混合 + 时间戳加盐
                │
                ▼
        链式 SHA256 扩展为 count 个数 (1..vmax)
                │
                ▼
        EntropySample { numbers, sources, timestamp }
```

### 5.3 历史记录流程 History Flow

```
DivinationResult 生成
    │
    ▼
构造 HistoryEntry（summary + detail 文本）
    │
    ▼
HistoryStore.add → _serialize 排队
    │
    ▼
load() → insert(0, entry) → _save() → SharedPreferences
    │
    ▼
历史页 load() 刷新列表
```

---

## 6. 数据设计 Data Design

### 6.1 配置数据 AppConfig

```dart
class AppConfig {
  final bool showDetails;                            // 展示采样详情
  final bool useOnline;                              // 在线熵源
  final bool animationsEnabled;                      // 动画总开关
  final Map<String, Map<String, bool>> animationSettings;  // 分术分类型动画
  final ThemeMode themeMode;                         // 主题模式
}
```

### 6.2 历史数据 HistoryEntry

```dart
class HistoryEntry {
  final String id;          // 唯一 ID
  final String techId;      // 术 id
  final String techName;    // 术显示名
  final DateTime time;      // 卜算时间
  final String summary;     // 摘要
  final String detail;      // 详情文本
  final String? note;       // 用户备注
}
```

### 6.3 结果数据 DivinationResult

```dart
class DivinationResult {
  final String techId;
  final String primaryName;              // 主名（末宫/本卦）
  final String? primarySubtitle;
  final String? secondaryName;           // 变卦名
  final List<ResultCardData> cards;      // 结构化卡片
  final Verdict? verdict;                // 综合断语
  final List<DetailDimension>? details;  // 多维断辞
  final List<int>? inputNumbers;
  final EntropySample? entropy;
  final DateTime timestamp;
  final Object? raw;                     // 术特定原始数据
}
```

详细字段见《数据模型与 API 契约》。

---

## 7. 非功能设计 Non-Functional Design

### 7.1 性能 Performance

- 起卦算法本地纯计算，响应 < 100ms
- 在线熵源 random.org 单次请求超时降级，不阻塞主流程
- Starfield 粒子数受控，离屏粒子定时回收
- CustomPainter 显式 dispose TextPainter

### 7.2 可靠性 Reliability

- HistoryStore 串行化原子写，防快速连续卜算丢数据
- ID 单调递增（microsecondsSinceEpoch + 自增计数）
- JSON 解析容错，失败返回空列表不崩溃

### 7.3 可扩展性 Extensibility

- 加新术 = 新建 feature 目录 + 实现 DivinationTech + 注册一行
- 新术动画开关自动纳入设置页
- 新熵源实现 EntropyCollector 接口即可接入

### 7.4 可维护性 Maintainability

- 身份信息单一事实来源（OrganizationAndUser.md）
- 动效常量集中（animations.dart）
- providers barrel 聚合
- 构建脚本自动版本+归档+历史

### 7.5 安全性 Security

- 纯本地无隐私上传
- random.org 仅请求随机字节
- 无硬编码敏感信息

---

## 8. 模块间协作 Inter-Module Collaboration

### 8.1 起卦协作序列 Collaboration Sequence

```
HomePage → router(/ritual/zhouyi) → ZhouyiRitual
    │ onCompleted
    ▼
router(/tech/zhouyi) → techByIdProvider → ZhouyiTech.buildPage
    │
    ▼
ZhouyiPage → ref.read(trueRandomProvider).generate(count:6, vmax:64)
    │
    ▼
ZhouyiAlgorithm.divine(numbers) → DivinationResult
    │
    ├─► RevealAnimation + ResultCard 渲染
    └─► HistoryStore.add(HistoryEntry(...))
```

### 8.2 配置变更协作 Config Change

```
SettingsPage → ConfigNotifier.setAnimationSetting(techId, kind, false)
    │
    ▼
SharedPreferences.setBool('anim_<techId>_<kind>', false)
    │
    ▼
state = AsyncData(config.copyWith(...))
    │
    ▼
依赖 config 的 providers/UI 自动刷新
```

---

## 9. 出错处理 Error Handling

| 场景 Scenario | 处理 Handling |
|------------|------------|
| 在线熵源请求失败 | 静默跳过该源，仅用系统熵+触摸 |
| 触摸无轨迹 | TouchEntropySource 返回空 bytes，混合时跳过 |
| 历史解析失败 | load() 返回空列表，不抛异常 |
| 未知 techId 路由 | 渲染「未知卜算法」占位页 |
| SharedPreferences 不可用 | 配置回退 defaults，历史写失败静默 |

---

## 10. 设计约束 Design Constraints

- 唯一开发者，模块设计须低耦合可独立演进
- 无后端，所有状态本地持久化
- 仪式动画时长 3-6s，可跳过（延迟 3s 显示跳过按钮）
- 动效全部可开关，尊重低性能/无障碍需求

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
