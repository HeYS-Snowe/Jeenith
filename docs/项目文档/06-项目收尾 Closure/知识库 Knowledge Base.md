# 志极 Jeenith · 知识库 Knowledge Base

> 叩问本心，不忘初心 —— Question the core. Return to origins.

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 组织 Organization | Qore Origins（叩心）|
| 当前版本 Current Version | 2.3.3+23（release）|
| 文档版本 Document Version | v1.0 |
| 创建日期 Created Date | 2026-07-15 |
| 维护人 Maintainer | HeYS-Snowe |
| 更新频率 Update Frequency | 每次迭代后 |

---

## 目录 Table of Contents

1. [知识库概述 Knowledge Base Overview](#1-知识库概述-knowledge-base-overview)
2. [核心技术概念 Core Technical Concepts](#2-核心技术概念-core-technical-concepts)
3. [术数术语表 Divination Glossary](#3-术数术语表-divination-glossary)
4. [常见问题 FAQ](#4-常见问题-faq)
5. [最佳实践 Best Practices](#5-最佳实践-best-practices)
6. [资源链接 Resources](#6-资源链接-resources)

---

## 1. 知识库概述 Knowledge Base Overview

### 1.1 知识库目的 Knowledge Base Purpose

| 目的 Purpose | 说明 Description |
|------------|-----------------|
| 知识沉淀 | 保存志极项目开发过程中的技术决策、术数知识与经验教训 |
| 快速检索 | 新功能开发时快速定位架构约定、术数术语与常见问题 |
| 术数参考 | 12 种传统术数的核心概念速查，辅助算法实现与内容校对 |
| 最佳实践 | Flutter 跨端开发、动效体系、真随机引擎等最佳实践沉淀 |

### 1.2 知识分类 Knowledge Categories

```
志极知识库 Jeenith Knowledge Base
├── 核心技术概念 Technical/
│   ├── 可扩展卜算框架 DivinationTech
│   ├── 真随机引擎 TrueRandom
│   ├── 动效体系 Animation System
│   └── 跨端适配 Cross-Platform
├── 术数术语表 Glossary/
│   ├── 通用术语 General
│   ├── 周易/梅花 Yijing/Meihua
│   ├── 紫微/八字 Ziwei/Bazi
│   └── 奇门/大六壬 Qimen/Daliuren
├── 常见问题 FAQ/
│   ├── 开发问题 Development
│   ├── 跨端问题 Cross-Platform
│   └── 术数问题 Divination
└── 最佳实践 Best Practices/
    ├── 框架扩展 Framework Extension
    ├── 性能优化 Performance
    └── 内存安全 Memory Safety
```

---

## 2. 核心技术概念 Core Technical Concepts

### 2.1 可扩展卜算框架 DivinationTech Framework

**核心抽象**：所有术数实现 `DivinationTech` 接口，包含三个契约：

| 契约 Contract | 类型 Type | 说明 Description |
|-------------|---------|---------------|
| `id` | String | 唯一标识，用于路由 `/tech/:id` 与注册表查找 |
| `meta` | TechMeta | 元数据：名称/图标/排序/启用状态 |
| `divine()` | DivinationResult | 起卦方法，返回卦象 + 解读 |

**注册表机制**：`divination_registry.dart` 提供三个 Provider：

- `divinationTechsProvider`：全部术列表（含未启用）
- `techByIdProvider`：按 ID 查找（路由用）
- `visibleTechsProvider`：首页可见列表（按 sortOrder 排序）

**加新术步骤**：

1. 新建 `features/xxx/` 目录（含 `algorithm/` + `ui/` + `xxx_tech.dart`）
2. 实现 `DivinationTech` 接口
3. 在 `divination_registry.dart` 的 `divinationTechsProvider` 列表追加一行 `XxxTech()`
4. 完成。无需修改 `core/` 或 `shared/` 任何代码

**关键约束**：`id` 必须唯一，注册表内有 `assert` 检查重复 ID。

### 2.2 真随机引擎 TrueRandom Engine

**三源熵混合架构**：

| 熵源 Source | 类 Class | 特性 Feature |
|-----------|---------|------------|
| 系统熵 | SystemEntropySource | `Random.secure()`，操作系统级 CSPRNG |
| 触摸熵 | TouchEntropySource | 用户触摸轨迹采样，仪式感 + 熵增强 |
| 在线熵 | OnlineEntropySource | random.org HTTP API，量子级真随机 |

**混合算法**：

```
SHA256(系统熵字节 ‖ 触摸轨迹熵字节 ‖ 在线熵字节) → 32 字节摘要 → 取模映射
```

**降级策略**：

- 在线熵获取失败（网络不可用）→ 回退到本地双源（系统 + 触摸）
- 触摸熵不足（桌面端鼠标轨迹）→ 系统熵主导，触摸熵作为附加
- 任何情况下不阻塞起卦流程

**关键类位置**：

- `core/rng/true_random.dart`：混合器
- `core/rng/system_entropy_source.dart`：系统熵
- `core/rng/touch_entropy_source.dart` + `touch_tracker.dart`：触摸熵
- `core/rng/online_entropy_source.dart`：在线熵
- `core/rng/rng_providers.dart`：Riverpod Provider

### 2.3 动效体系 Animation System

**Phase 1-6 六阶段**：

| Phase | 动效类型 Type | 覆盖范围 Scope | 实现位置 Location |
|-------|------------|--------------|-----------------|
| Phase 1 | 入场仪式 | 10 术（太极生六宫等）| core/animation/ritual/ |
| Phase 2 | 路由转场 | 全局 | core/animation/transitions/ |
| Phase 3 | 绘制过程 | 卦象/星盘/盘面 | core/animation/painters/ |
| Phase 4 | 结果揭示 | 全术 | core/animation/reveal/ |
| Phase 5 | 粒子系统 | 结果揭示增强 | core/animation/particles/ |
| Phase 6 | 墨晕扩散 | 结果揭示增强 | core/animation/reveal/ink_spread.dart |

**4 个 AnimationKind 独立开关**（v2.3.2）：

| AnimationKind | 说明 | 控制方法 |
|--------------|------|--------|
| entrance | 入场仪式 | `AppConfig.isAnimationEnabled(id, AnimationKind.entrance)` |
| transition | 路由转场 | `AppConfig.isAnimationEnabled(id, AnimationKind.transition)` |
| drawing | 绘制过程 | `AppConfig.isAnimationEnabled(id, AnimationKind.drawing)` |
| reveal | 结果揭示 | `AppConfig.isAnimationEnabled(id, AnimationKind.reveal)` |

**全局开关**：`AppConfig.animationsEnabled` 一键关闭所有动效（低端设备安全阀）。

**仪式路由**：开启仪式动画时走 `/ritual/<tech>`，动画结束自动 `context.go('/tech/<id>')`；关闭时直接进 `/tech/<id>`。

### 2.4 跨端适配 Cross-Platform Adaptation

**Android + Windows 双端**：

| 平台 Platform | 适配点 Adaptation | 实现 Implementation |
|-------------|----------------|-----------------|
| Android | 移动端原生 | flutter 默认 |
| Windows | 桌面窗口尺寸 | window_manager + screen_retriever |
| Windows | 桌面窗口位置 | window_manager |
| Windows | 最小尺寸约束 | window_manager setMinimumSize |

**跨端差异**：

| 差异点 Difference | Android | Windows |
|---------------|---------|---------|
| 磁力计（罗盘）| ✅ sensors_plus 可用 | ❌ 无硬件，罗盘不可用 |
| 触摸轨迹熵 | ✅ 高质量触摸采样 | ⚠️ 退化为鼠标轨迹 |
| 分享 | ✅ 系统分享菜单 | ✅ 系统分享（Windows 10+）|
| 文件路径 | path_provider | path_provider（Windows 桌面支持）|

### 2.5 历史存储 HistoryStore

**原子读-改-写模式**：

```dart
// ⚠️ 错误：非原子，快速连续卜算会丢数据
final list = await loadHistory();
list.add(newRecord);
await saveHistory(list);

// ✅ 正确：原子读-改-写
await HistoryStore.instance.addRecord(newRecord);
// 内部：读 → 改 → 写 在同一锁内完成
```

**关键约束**：

- SharedPreferences 异步写入 + 快速连续操作是高危组合
- 历史记录必须通过 `HistoryStore` 操作，禁止直接读写 SharedPreferences
- 历史导出通过 `history_export.dart` 生成 JSON/文本文件

---

## 3. 术数术语表 Divination Glossary

### 3.1 通用术语 General Terms

| 术语 Term | 释义 Definition |
|---------|---------------|
| 起卦 | 通过特定方式生成卦象的过程 |
| 卦象 | 卜算结果的图形/符号表示 |
| 解读 | 对卦象含义的阐释 |
| 时辰 | 中国传统时间单位，一天 12 时辰，每时辰 2 小时 |
| 干支 | 天干（10）+ 地支（12）的组合纪年/纪月/纪日/纪时 |
| 农历 | 中国传统历法，基于月相 + 节气 |
| 节气 | 24 节气，太阳黄经划分，用于农历节气定月 |
| 五行 | 金、木、水、火、土，相生相克 |
| 阴阳 | 万物对立统一的两极 |

### 3.2 周易/梅花术语 Yijing/Meihua Terms

| 术语 Term | 释义 Definition |
|---------|---------------|
| 卦 | 64 卦，每卦 6 爻 |
| 爻 | 卦的基本单位，分阳爻（—）阴爻（--）|
| 八卦 | 乾兑离震巽坎艮坤，8 个三爻基本卦 |
| 金钱卦 | 三枚铜钱掷六次成卦的方法 |
| 卦辞 | 每卦的总述 |
| 爻辞 | 每爻的描述 |
| 体用 | 梅花易数核心，体卦为主，用卦为客 |
| 互卦 | 卦中取 2-5 爻组成的卦，表过程 |
| 变卦 | 爻变后的卦，表结果 |
| 六亲 | 父母、兄弟、子孙、妻财、官鬼 |

### 3.3 紫微/八字术语 Ziwei/Bazi Terms

| 术语 Term | 释义 Definition |
|---------|---------------|
| 四柱 | 年柱、月柱、日柱、时柱，每柱天干地支 |
| 十神 | 比肩、劫财、食神、伤官、偏财、正财、七杀、正官、偏印、正印 |
| 神煞 | 命理中的吉凶神祇，如天乙贵人、文昌、桃花 |
| 命盘 | 紫微斗数的星盘，12 宫位 |
| 十二宫 | 命宫、兄弟、夫妻、子女、财帛、疾厄、迁移、奴仆、官禄、田宅、福德、父母 |
| 主星 | 紫微、天机、太阳、武曲、天同、廉贞、天府、太阴、贪狼、巨门、天相、天梁、七杀、破军 |
| 辅星 | 左辅、右弼、文昌、文曲、天魁、天钺等 |
| 化禄/化权/化科/化忌 | 四化，星曜的动态变化 |

### 3.4 奇门/大六壬术语 Qimen/Daliuren Terms

| 术语 Term | 释义 Definition |
|---------|---------------|
| 局 | 奇门遁甲的盘，分阳遁/阴遁共 1080 局 |
| 九宫 | 洛书九宫，戴九履一左三右七二四为肩六八为足 |
| 八门 | 休、生、伤、杜、景、死、惊、开 |
| 九星 | 天蓬、天芮、天冲、天辅、天禽、天心、天柱、天任、天英 |
| 八神 | 直符、腾蛇、太阴、六合、白虎、玄武、九地、九天 |
| 四课 | 大六壬的核心，日干支与月将推演 |
| 三传 | 初传、中传、末传，大六壬的三个阶段 |
| 天将 | 十二天将，贵人腾蛇朱雀六合勾陈青龙天空白虎太常玄武太阴天后 |
| 月将 | 太阳所在宫位，用于大六壬起课 |

### 3.5 其他术数术语 Other Terms

| 术语 Term | 释义 Definition |
|---------|---------------|
| 掷筊 | 两个半月形筊杯掷地，看正反面判断神意 |
| 圣杯 | 一正一反，表示同意 |
| 笑杯 | 两正面，表示一笑置之/再问 |
| 阴杯 | 两反面，表示否定 |
| 抽签 | 从签筒随机抽取一支签 |
| 签诗 | 签上的诗句，通常为传统签诗 |
| 测字 | 拆解汉字笔画结构推断吉凶 |
| 五格剖象 | 姓名学，天格/人格/地格/外格/总格 |
| 三才 | 天/人/地，五格剖象中的五行配置 |
| 24 山 | 风水罗盘的 24 个方位 |
| 方位角 | 罗盘指针所指的度数 |

---

## 4. 常见问题 FAQ

### 4.1 开发问题 Development Issues

**Q1: 如何添加一个新的卜算术？**

A: 三步完成：
1. 新建 `features/xxx/` 目录（含 `algorithm/divine.dart` + `ui/xxx_page.dart` + `xxx_tech.dart`）
2. 实现 `DivinationTech` 接口（id / meta / divine）
3. 在 `divination_registry.dart` 的 `divinationTechsProvider` 列表追加 `XxxTech()`
4. 无需修改 core/ 或 shared/，首页自动出现新术卡片。

**Q2: 真随机引擎如何降级？**

A: `OnlineEntropySource` 在网络不可用时自动回退到本地双源（系统 + 触摸）。`TrueRandom` 内部有 try-catch 包裹在线熵获取，失败不阻塞起卦。

**Q3: 动效在低端设备上掉帧怎么办？**

A: 三层开关：
- 全局：设置页关闭「动效总开关」（`AppConfig.animationsEnabled`）
- 细分：关闭特定 AnimationKind（entrance/transition/drawing/reveal）
- 自动：粒子系统会根据设备性能自适应粒子数量

**Q4: CustomPainter 为什么必须 dispose TextPainter？**

A: TextPainter 持有 native handle（Skia 文本布局对象），不 dispose 会导致 native 内存泄漏，长期运行可能 OOM。所有 CustomPainter 实现中 `paint()` 创建的 TextPainter 必须在 `dispose()` 或绘制结束后显式释放。

**Q5: 历史记录为什么偶尔丢失？**

A: v2.3.1 已修复。原因是 SharedPreferences 异步写入 + 快速连续卜算导致读-改-写非原子。`HistoryStore` 现采用原子读-改-写模式，禁止直接操作 SharedPreferences。

### 4.2 跨端问题 Cross-Platform Issues

**Q1: 风水罗盘在 Windows 桌面端为什么不可用？**

A: sensors_plus 的磁力计 API 仅移动端可用，桌面端无磁力计硬件。后续可探索鼠标拖拽模拟方位角输入。

**Q2: 桌面端窗口尺寸如何控制？**

A: `main.dart` 中通过 `window_manager` + `screen_retriever` 初始化：获取屏幕分辨率 → 计算 40% 宽高 → setMinimumSize 约束最小尺寸。

**Q3: 桌面端分享功能如何工作？**

A: share_plus 10.x 支持 Windows 桌面（Windows 10+），调用系统分享面板。截图/导出文件通过 path_provider 获取临时路径。

### 4.3 术数问题 Divination Issues

**Q1: 紫微斗数 v2 与 v1 有何区别？**

A: v2（v1.3.0）重构了星盘绘制与星曜安放算法，使用 CustomPainter 绘制 12 宫位星盘，主星/辅星/化曜完整安放。v1 仅为框架级原型。

**Q2: 奇门遁甲 v2 与 v1 有何区别？**

A: v2（v1.4.0）重构了局盘推演，完整支持阳遁/阴遁 1080 局，九宫/八门/九星/八神正确安放。v1 仅为框架级原型。

**Q3: 八字推演的「四柱」如何计算？**

A: 使用 lunar ^1.7.8（寿星天文历）库，根据出生年月日时推算年柱/月柱/日柱/时柱的天干地支，再推演十神与神煞。

**Q4: 测名字的「五格剖象」如何计算？**

A: 根据姓名每个字的笔画数（数据在 `name_test/algorithm/strokes_data.dart`），计算天格/人格/地格/外格/总格，再配三才五行。

**Q5: 多卜算术如何组合使用？**

A: 引导卡片建议：先用一种起卦问大致的问题，再用另外一种起卦问细节。例如先周易问「事业方向」，再小六壬问「下周面试结果」。

---

## 5. 最佳实践 Best Practices

### 5.1 框架扩展 Framework Extension

**加新术的最佳实践**：

1. **先看再改**：参考已有术（如 `features/xiaoliuren/`）的目录结构
2. **算法与 UI 分离**：`algorithm/divine.dart` 只管算法，`ui/xxx_page.dart` 只管展示
3. **复用共享组件**：GoldButton/DarkButton/InteractableCard/CopyResultButton/ShareResultButton
4. **接入真随机**：通过 `rng_providers.dart` 获取 `TrueRandom` 实例，不要自建随机源
5. **接入历史存储**：起卦结果通过 `HistoryStore.instance.addRecord()` 存档
6. **仪式动画可选**：新术可暂不实现 ritual，直接进 tech 页（如八字/测名字）

### 5.2 性能优化 Performance

| 优化项 Optimization | 方法 Method | 效果 Impact |
|------------------|-----------|----------|
| CustomPainter 重绘 | 仅在 `shouldRepaint` 返回 true 时重绘 | 避免无效重绘 |
| 动效帧率 | AnimationController duration + curve 精调 | 60fps 稳定 |
| 粒子数量自适应 | 根据设备性能动态调整粒子数 | 低端设备不卡顿 |
| SVG 图标缓存 | flutter_svg 自动缓存 | 避免重复解析 |
| 历史列表懒加载 | ListView.builder 分页加载 | 大量历史不卡顿 |
| 动效全局开关 | AppConfig.animationsEnabled | 低端设备一键降级 |

### 5.3 内存安全 Memory Safety

**CustomPainter 防泄漏**：

```dart
class MyPainter extends CustomPainter {
  TextPainter? _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    _textPainter = TextPainter(..)..layout();
    _textPainter!.paint(canvas, offset);
  }

  @override
  void dispose() {
    _textPainter?.dispose();  // ⚠️ 必须显式 dispose
    super.dispose();
  }
}
```

**AnimationController 防泄漏**：

```dart
class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();  // ⚠️ 必须在 State dispose 时释放
    super.dispose();
  }
}
```

### 5.4 身份信息管理 Identity Management

**单一事实来源**：

- 身份信息（组织/包名/署名）以 `D:\Code\.Rules\OrganizationAndUser.md` 为准
- 项目内通过 `core/branding.dart` 集中定义（`Branding.appName` / `Branding.orgCn` 等）
- **禁止在业务代码中硬编码身份信息**，必须引用 `Branding` 常量

### 5.5 构建归档 Build Archiving

**APK 构建规范**：

```bash
cd mobile
pwsh -File scripts/build_apk.ps1 -Status release
# 脚本自动完成：
# 1. 版本号自增（release: minor++，其他: patch++）
# 2. pubspec.yaml 版本更新
# 3. flutter build apk --release
# 4. APK 重命名为 Jeenith_release_<version>_<date>_<seq>.apk
# 5. 备份原始 APK 到 backup/
# 6. 归档到 builds/android/
# 7. 追加双份 build_history.json（项目内 + builds/）
```

**命名规则**：`{AppName}_{Status}_{Version}_{Date}_{Seq}.{ext}`

示例：`Jeenith_2.3.3_release_20260715_01.apk`

---

## 6. 资源链接 Resources

### 6.1 内部资源 Internal Resources

| 资源 Resource | 位置 Location |
|------------|-------------|
| 项目仓库 | https://github.com/HeYS-Snowe/Jeenith |
| 项目规则 | AGENTS.md / CLAUDE.md |
| 身份信息 | D:\Code\.Rules\OrganizationAndUser.md |
| 构建规范 | docs/FLUTTER_APK_BUILD_PIPELINE.md |
| 项目文档 | docs/项目文档/（00-07 全套）|
| 构建脚本 | mobile/scripts/build_apk.ps1 |
| 历史归档 | mobile/scripts/archive_history.py |

### 6.2 关键代码位置 Key Code Locations

| 模块 Module | 位置 Location |
|-----------|-------------|
| 卜算框架 | mobile/lib/core/divination/ |
| 注册表 | mobile/lib/core/divination/divination_registry.dart |
| 真随机引擎 | mobile/lib/core/rng/ |
| 动效体系 | mobile/lib/core/animation/ |
| 历史存储 | mobile/lib/core/history/ |
| 主题 | mobile/lib/core/theme/ |
| 品牌常量 | mobile/lib/core/branding.dart |
| 共享组件 | mobile/lib/shared/widgets/ |
| 路由 | mobile/lib/router/app_router.dart |
| 配置 | mobile/lib/core/config/ |

### 6.3 外部依赖文档 External Dependencies

| 依赖 Dependency | 用途 Usage | 文档 Doc |
|---------------|---------|--------|
| Flutter | 跨端框架 | https://docs.flutter.dev |
| Riverpod | 状态管理 | https://riverpod.dev |
| go_router | 路由 | https://pub.dev/packages/go_router |
| lunar | 农历/干支/节气 | https://github.com/6tail/lunar-flutter |
| flutter_svg | SVG 图标 | https://pub.dev/packages/flutter_svg |
| shared_preferences | 本地存储 | https://pub.dev/packages/shared_preferences |
| sensors_plus | 磁力计 | https://pub.dev/packages/sensors_plus |
| share_plus | 系统分享 | https://pub.dev/packages/share_plus |
| path_provider | 文件路径 | https://pub.dev/packages/path_provider |
| window_manager | 桌面窗口 | https://pub.dev/packages/window_manager |
| random.org | 在线真随机 | https://www.random.org |

### 6.4 术数参考资料 Divination References

| 术数 Tech | 参考方向 Reference Direction |
|---------|--------------------------|
| 周易 | 《周易本义》《周易正义》64 卦卦辞爻辞 |
| 梅花易数 | 《梅花易数》邵雍，体用生克 |
| 紫微斗数 | 《紫微斗数全书》，12 宫 + 主辅星 |
| 奇门遁甲 | 《神奇之门》《开悟之门》，阳遁阴遁 1080 局 |
| 大六壬 | 《大六壬全书》，四课三传 |
| 八字 | 《渊海子平》《三命通会》，四柱十神 |
| 风水罗盘 | 24 山向，罗盘逐层 |

---

## 附录 Appendix

### 附录A：知识库维护规范 Maintenance

| 维护项 Item | 频率 Frequency | 责任人 Responsible |
|-----------|--------------|-------------------|
| 术语表更新 | 新术落地时 | 开发者 |
| FAQ 更新 | 每次版本发布 | 开发者 |
| 最佳实践审查 | 每个大版本 | 开发者 |
| 链接有效性检查 | 每季度 | 开发者 |
| 代码位置同步 | 重构后 | 开发者 |

### 附录B：版本约定 Versioning

| 状态 Status | 含义 | 版本号规则 |
|------|------|----------|
| release | 正式版 | minor++，patch=0 |
| beta | 测试版 | patch++ |
| alpha | 内测版 | patch++ |
| rc | 候选版 | patch++ |
| fix | 修复版 | patch++ |
| hotfix | 紧急修复 | patch++ |
| feature | 功能版 | patch++ |
| dev | 开发版 | patch++ |
| debug | 调试版 | patch++ |

---

**文档结束 End of Document**

> 志极 Jeenith · 志于本心，知于极处 · Copyright (c) 2026 Qore · MIT License
