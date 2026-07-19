# 架构设计文档 Architecture Design Document

> 志极 Jeenith · 卜算合集移动应用整体架构设计

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心）· 简称 Qore |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe（唯一开发者） |
| 技术栈 Stack | Flutter 3.x（Dart 3.11+）· Riverpod · go_router · lunar |
| 许可证 License | MIT · Copyright (c) 2026 Qore |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-01 | 初始架构：core/features 分层，DivinationTech 注册机制 |
| v2.0.0 | 2026-03 | 体验深化：品牌定调、动效总开关、真随机引擎重构 |
| v2.1.0 | 2026-04 | 仪式动画体系 Phase 1-3：周易/紫微/奇门/大六壬/罗盘入场 |
| v2.2.0 | 2026-05 | 仪式动画 Phase 4-6：梅花/掷筊/抽签/测字入场 + 转场 |
| v2.3.0 | 2026-06 | 新增八字/测名字，紫微盘重构，AnimationKind 拆分 |
| v2.3.3 | 2026-07-15 | 首页间距修复、MIT LICENSE、Windows 图标归档 |

---

## 1. 架构概述 Architecture Overview

### 1.1 项目定位 Product Positioning

志极 Jeenith 是一款**叩问本心的卜算合集移动 App**，汇聚十二种传统术数：小六壬、周易（金钱卦）、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字，外加使用手册。核心理念「志于本心，知于极处 —— Question the core. Return to origins.」。

应用采用**可扩展卜算框架**：每种术独立成模块，通过统一接口与注册表接入，新增一术仅需「新建 feature 目录 + 实现接口 + 注册表追加一行」，无需改动核心层或共享层。

### 1.2 架构目标 Architecture Goals

| 目标维度 Goal | 目标描述 Description |
|-------------|-------------------|
| 可扩展 Extensibility | 加新术成本 ≤ 1 个 feature 目录 + 1 行注册；核心层零改动 |
| 沉浸感 Immersion | 全 APP 星空背景 + 仪式入场动画 + 微交互动效，可按术/按类开关 |
| 严肃性 Seriousness | 多源 SHA256 真随机引擎，杜绝伪随机操纵感，保证起卦不可预知 |
| 跨平台 Cross-Platform | Android 触摸 + Windows 桌面鼠标，统一交互范式切换 |
| 离线自洽 Offline-First | 纯客户端无后端，所有计算本地完成；在线熵源可降级为离线 |
| 体验可调 Personalization | 动画/熵源/主题均可细粒度配置并持久化 |

### 1.3 架构特征 Architecture Characteristics

- **纯客户端架构**：无后端服务，无网络依赖（除可选的 random.org 在线熵源）
- **分层 + 注册表混合**：core/data/features 分层 + divination_registry 插件化注册
- **Riverpod 响应式状态**：配置/熵源/路由均以 Provider 暴露，UI 自动订阅
- **声明式路由 + 仪式前置**：go_router 声明路由表，`/ritual/<id>` 作为各术入场前置
- **品牌一致视觉层**：深紫鎏金主题 + Starfield 星空背景全 APP 穿透

---

## 2. 架构原则 Architecture Principles

### 2.1 核心设计原则 Core Principles

| 原则 Principle | 在本项目的体现 Manifestation |
|--------------|--------------------------|
| **开闭原则 OCP** | DivinationTech 接口对扩展开放，registry 对修改关闭；新术不改 core |
| **单一职责 SRP** | 每层边界清晰：core 提供能力，features 实现术，shared 提供组件 |
| **依赖倒置 DIP** | features 依赖 core 的抽象接口（DivinationTech/EntropyCollector），不依赖具体实现 |
| **KISS** | 无后端、无数据库、无复杂 ORM；SharedPreferences JSON 持久化足矣 |
| **YAGNI** | 不预设账号体系/云同步；按需演进，暂未实现的不预留接口 |
| **DRY** | 真随机引擎、历史存储、农历服务全 APP 共用，禁止各术自造 |

### 2.2 项目定制规则 Project Conventions

- 先看再改，理解上下文后动手
- 身份信息（组织/包名/署名）以 `D:\Code\.Rules\OrganizationAndUser.md` 为唯一事实来源，不硬编码
- 加新卜算术 = 新建 `features/xxx/` + 实现 `DivinationTech` + registry 注册一行
- 微交互动画统一封装在 `core/theme/animations.dart`，所有动效可通过设置页全局/分术开关（`AppConfig.animationsEnabled` + `animationSettings`）
- CustomPainter 实现必须显式 `dispose` TextPainter，防止 native handle 泄漏
- HistoryStore 写操作必须串行化（原子读-改-写），防止快速连续卜算丢数据

---

## 3. 逻辑架构 Logical Architecture

### 3.1 分层总览 Layered Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     app.dart (JeenithApp)                    │
│   MaterialApp.router + Starfield 背景 + 主题模式 + 触摸监听    │
├─────────────────────────────────────────────────────────────┤
│  router/ (app_router.dart)                                    │
│  GoRouter · / · /history · /settings · /manual · /ritual/:id · /tech/:id │
├─────────────────────────────────────────────────────────────┤
│  features/ (12 术 + 4 系统页)                                  │
│  每术: algorithm/ data/ state/ ui/ xxx_tech.dart              │
│  系统页: home / history / settings / manual                   │
├─────────────────────────────────────────────────────────────┤
│  shared/widgets/ (14 个共享组件)                               │
│  GoldButton · DarkButton · InteractableCard · Starfield ...   │
├─────────────────────────────────────────────────────────────┤
│  core/ (能力层)                                                │
│  divination/ · rng/ · config/ · history/ · calendar/ ·        │
│  theme/ · animation/ · branding                               │
├─────────────────────────────────────────────────────────────┤
│  data/ (yijing 卦象数据)                                       │
│  64 卦 + 八卦数据，周易/梅花共用                                │
├─────────────────────────────────────────────────────────────┤
│  providers/ (barrel 聚合 config + rng providers)              │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 各层职责 Layer Responsibilities

#### 3.2.1 core/ —— 能力层 Capability Layer

提供全 APP 共用的基础设施，**对 features 完全无反向依赖**。

| 子模块 Sub-module | 职责 Responsibility |
|----------------|------------------|
| `divination/` | DivinationTech 抽象接口、TechMeta 元数据、DivinationResult 统一结果模型 |
| `divination/divination_registry.dart` | **核心注册表**：techsProvider / techByIdProvider / visibleTechsProvider |
| `rng/` | 真随机引擎：EntropyCollector 接口 + 3 源（System/Touch/Online）+ TrueRandom SHA256 混合 |
| `config/` | AppConfig 配置模型 + ConfigNotifier（AsyncNotifier）+ PlatformInfo 平台检测 |
| `history/` | HistoryStore 原子存储 + HistoryEntry 模型 + HistoryExport 导出（JSON/MD/CSV） |
| `calendar/` | LunarService 农历服务（封装 lunar 包） |
| `theme/` | AppColors/AppColorsLight 色彩 + AppFonts 字体 + appTheme 主题 + AppAnimations 动效常量 |
| `animation/` | 仪式动画（ritual/）、转场（transitions/）、揭示（reveal/）、粒子（particles/）、绘制（painters/） |
| `branding.dart` | 品牌身份常量（appName/orgCn/slogan/copyright） |

#### 3.2.2 data/ —— 数据层 Data Layer

| 子模块 | 职责 |
|-------|----|
| `yijing/` | 64 卦象数据 + 八卦属性数据，周易（金钱卦）与梅花易数共用，避免重复定义 |

#### 3.2.3 features/ —— 功能层 Feature Layer

每个术独立成目录，内部遵循统一子结构：

```
features/<tech>/
  algorithm/    # 起卦算法（纯逻辑，无 UI 依赖）
  data/         # 术特定静态数据（如六宫、签文、字库）
  state/        # Riverpod providers（术状态管理）
  ui/           # 页面、自定义组件、仪式动画
  <tech>_tech.dart  # DivinationTech 实现 + TechMeta 元数据
```

当前已注册 12 术（按 sortOrder 排序）：

| # | id | 显示名 | 副标题 | sortOrder |
|---|----|-------|-------|-----------|
| 1 | xiaoliuren | 小六壬 | 掐指神课 | 0 |
| 2 | zhouyi | 周易 | 金钱卦 | 1 |
| 3 | meihua | 梅花易数 | 心易万物 | 2 |
| 4 | jiaobei | 掷筊 | 圣杯问神 | 3 |
| 5 | ziwei | 紫微斗数 | 帝星命盘 | 4 |
| 6 | qimen | 奇门遁甲 | 九宫飞布 | 5 |
| 7 | chouqian | 抽签 | 天机一签 | 6 |
| 8 | cezi | 测字 | 字藏玄机 | 7 |
| 9 | daliuren | 大六壬 | 三传四课 | 8 |
| 10 | luopan | 风水罗盘 | 二十四山 | 9 |
| 11 | name_test | 测名字 | 名姓五行 | 10 |
| 12 | bazi | 八字推演 | 四柱命理 | 11 |

系统页（非术）：`home/`（首页 grid）、`history/`（历史）、`settings/`（设置）、`manual/`（手册）。

#### 3.2.4 shared/widgets/ —— 共享组件层 Shared Widgets

14 个全 APP 复用的展示组件，所有动效受 `AppConfig.animationsEnabled` 总开关约束：

`GoldButton`（鎏金主按钮，物理反馈）· `DarkButton`（暗色次按钮）· `InteractableCard`（可交互卡片，错峰上浮）· `DecorativePanel`（装饰面板）· `SectionTitle`（分节标题）· `SvgIcon`（SVG 图标）· `AnimatedExpandIcon`（展开图标旋转）· `HoverableIconButton`（桌面 hover 态）· `EntranceItem`（错峰入场封装）· `Starfield`（星空粒子背景）· `DivinationLoadingIndicator`（起卦加载态）· `CopyResultButton`（复制结果）· `ShareResultButton`（分享结果）· `GuideDialog`（引导弹窗）。

#### 3.2.5 providers/ —— 聚合层 Barrel

`providers/providers.dart` 是 barrel 文件，统一 `export` config_providers + rng_providers，各处一处 import 即得全部 providers。

#### 3.2.6 router/ —— 路由层 Router

`router/app_router.dart` 声明 GoRouter 路由表，`routerProvider` 暴露。`/tech/:id` 路由通过 `techByIdProvider` 动态解析术并注入 `TechTransition` 转场（按术动画开关降级为 fade）。

---

## 4. 依赖关系 Dependency Graph

### 4.1 层间依赖方向

```
app.dart ──► router ──► features ──► core (divination/rng/config/history/calendar/theme)
                  │          │
                  │          └──► shared/widgets ──► core/theme
                  │          └──► data/yijing (仅 zhouyi/meihua)
                  └──► core (config/animation/transitions)
features ──► providers (barrel) ──► core/config + core/rng
```

**依赖方向铁律**：
- core **不依赖** features / shared / router（无反向依赖）
- shared/widgets **只依赖** core/theme
- features 依赖 core + shared + data，**不依赖** 其他 features（术间隔离）
- router 依赖 core（config/divination）+ features 的页面入口

### 4.2 关键 Provider 依赖链

```
configProvider (AsyncNotifier<AppConfig>)
   │
   ├──► trueRandomProvider (watch config.useOnline)
   │        └──► TouchEntropySource(touchTrackerProvider)
   ├──► routerProvider (read config.isAnimationEnabled for transitions)
   └──► JeenithApp (watch config.themeMode)

divinationTechsProvider (List<DivinationTech>)
   ├──► visibleTechsProvider (filter enabled + sort)
   └──► techByIdProvider.family (route resolution)
```

---

## 5. 扩展机制 Extension Mechanism

### 5.1 新增卜算术流程 Adding a New Tech

以「紫微斗数」为例（已落地）：

1. **新建目录**：`features/ziwei/`（含 algorithm/data/state/ui/ziwei_tech.dart）
2. **实现接口**：
   ```dart
   class ZiweiTech extends DivinationTech {
     @override String get id => 'ziwei';
     @override TechMeta get meta => const TechMeta(id: 'ziwei', ...);
     @override Widget buildPage(BuildContext context, WidgetRef ref) => const ZiweiPage();
   }
   ```
3. **注册一行**：在 `divination_registry.dart` 的 techs 列表追加 `ZiweiTech()`

**完成。** 无需修改 core/ 或 shared/ 任何代码。首页 grid 自动出现卡片，`/tech/ziwei` 路由自动可用，历史记录/复制/分享自动接入。

### 5.2 注册表的自动发现 Automatic Discovery

- `visibleTechsProvider` 过滤 `meta.enabled` 并按 `sortOrder` 排序，首页 grid 自动渲染
- `techByIdProvider.family` 按路由参数 `:id` 查找，`/tech/:id` 自动路由
- 注册表带 `assert` 检测 id 重复，避免静默命中错误项
- 仪式动画通过 `core/animation/ritual/` 下对应 `<tech>_ritual.dart` + 路由 `/ritual/<id>` 接入

### 5.3 动效可扩展性 Animation Extensibility

新增术的动画开关自动纳入设置页（`animationSettings[techId]` 缺省时 `isAnimationEnabled` 返回 true），无需额外注册。AnimationKind 四类（entrance/transition/painter/reveal）对新术即开即用。

---

## 6. 跨平台架构 Cross-Platform Architecture

### 6.1 平台检测 Platform Detection

`PlatformInfo`（基于 `defaultTargetPlatform` + `kIsWeb`，不依赖 dart:io）一次性判定设备大类：

| 设备大类 Family | 平台 Platforms | 交互范式 Interaction |
|--------------|--------------|-------------------|
| `mobile` | Android / iOS | 触摸拖拽、DraggableScrollableSheet、触摸轨迹熵源 |
| `desktop` | Windows / macOS / Linux | 鼠标滚轮、分栏布局、hover 轨迹熵源 |
| `web` | Web | 暂按 mobile 范式 |

### 6.2 交互范式切换 Interaction Switching

- 触摸轨迹熵源（`TouchEntropySource`）在桌面降级为 hover 采样（`onPointerHover`）
- 风水罗盘（`luopan`）陀螺仪/磁场（`sensors_plus`）在无传感器平台降级为触摸/鼠标交互
- `HoverableIconButton` 仅桌面显示 hover 态

---

## 7. 数据架构 Data Architecture

### 7.1 数据流向 Data Flow

```
用户输入 ──► TouchTracker（轨迹熵）──┐
系统熵（Random.secure）─────────────┤
random.org 大气噪声（http）─────────┤
                                    ▼
                        TrueRandom.generate() (SHA256 混合)
                                    │
                                    ▼
                        EntropySample (numbers + sources)
                                    │
                                    ▼
                    各术 algorithm 起卦 ──► DivinationResult
                                    │
                    ┌───────────────┤
                    ▼               ▼
              UI 渲染结果     HistoryStore.add (持久化)
                                    │
                                    ▼
                        SharedPreferences (JSON)
```

### 7.2 持久化策略 Persistence

| 数据 Data | 存储 Storage | Key | 说明 |
|---------|------------|-----|----|
| 卜算历史 | SharedPreferences | `divination_history` | JSON 数组，串行化原子写 |
| 配置-展示详情 | SharedPreferences | `showDetails` | bool |
| 配置-在线熵源 | SharedPreferences | `useOnline` | bool |
| 配置-动画总开关 | SharedPreferences | `animationsEnabled` | bool |
| 配置-主题模式 | SharedPreferences | `themeMode` | light/dark/system |
| 配置-分术动画 | SharedPreferences | `anim_<techId>_<kind>` | bool |

详见《数据库设计说明书》。

---

## 8. 安全与可靠性 Security & Reliability

### 8.1 真随机性保障 True Randomness

- **多源混合**：系统熵 + 触摸轨迹 + 在线大气噪声，任一源失败不影响整体
- **SHA256 链式扩展**：避免简单切片相关性，每个数独立哈希
- **收尾加盐**：时间戳 + 16 字节系统熵，防止重放
- **降级策略**：在线源失败时静默跳过，离线仍可用

### 8.2 数据可靠性 Data Reliability

- **HistoryStore 串行化**：所有写操作经 `_serialize` 链式排队，杜绝 load→modify→save 竞态
- **ID 单调性**：`generateId` = `microsecondsSinceEpoch` + 自增计数（& 0xFFFF），避免同帧碰撞
- **JSON 容错**：`load()` 解析失败返回空列表，不抛异常崩溃

### 8.3 内存安全 Memory Safety

- CustomPainter 必须 `dispose` TextPainter，防 native handle 泄漏
- AnimationController 在 State.dispose 中释放
- 粒子系统（Starfield）定时清理离屏粒子

### 8.4 无敏感信息 No Sensitive Data

- 纯本地无网络上报，无用户账号，无个人隐私上传
- random.org 仅请求随机字节，不携带任何用户数据

---

## 9. 部署架构 Deployment Architecture

### 9.1 构建产物 Build Artifacts

| 平台 Platform | 命令 Command | 产物 Artifact | 归档 Archive |
|-------------|------------|-------------|------------|
| Android | `pwsh -File scripts/build_apk.ps1 -Status release` | APK | `builds/android/` |
| Windows | `flutter build windows --release` | exe + dll | `builds/windows/`（手动 zip） |

### 9.2 版本与归档 Versioning & Archive

- 版本号格式：`major.minor.patch+build`（如 `2.3.3+23`）
- 构建脚本自动更新 pubspec.yaml 版本 + 归档 + 双份历史（`build_history.json` + `release_history.json`）
- 构建规范见 `docs/FLUTTER_APK_BUILD_PIPELINE.md`

---

## 10. 技术决策记录 Architecture Decision Records

| 决策 Decision | 选择 Choice | 理由 Rationale |
|-------------|-----------|--------------|
| 框架 | Flutter | 一套代码 Android + Windows 桌面，声明式 UI 契合仪式动画 |
| 状态管理 | Riverpod | 编译时安全、Provider family 适合 techById 路由解析 |
| 路由 | go_router | 声明式路由表 + path 参数 + pageBuilder 转场控制 |
| 历法 | lunar（寿星天文历） | 业内权威，覆盖 1900-2100，干支/节气/八字一体 |
| 随机 | 多源 SHA256 | 严肃卜算需不可预知，单源 Random 不可信 |
| 持久化 | SharedPreferences | 无关系数据，K/V 足矣，零依赖 |
| 无后端 | 纯客户端 | 隐私自洽 + 离线可用 + 维护成本最低 |

---

## 附录：核心源文件索引 Source Index

| 文件 File | 作用 Role |
|---------|--------|
| `mobile/lib/app.dart` | 应用根组件 |
| `mobile/lib/main.dart` | 入口（ProviderScope + 桌面窗口初始化） |
| `mobile/lib/core/divination/divination_tech.dart` | DivinationTech 接口 + TechMeta |
| `mobile/lib/core/divination/divination_registry.dart` | 核心注册表 |
| `mobile/lib/core/divination/divination_result.dart` | 统一结果模型 |
| `mobile/lib/core/rng/true_random.dart` | 真随机引擎 |
| `mobile/lib/core/config/app_config.dart` | 配置模型 + AnimationKind |
| `mobile/lib/core/config/config_providers.dart` | ConfigNotifier |
| `mobile/lib/core/history/history_store.dart` | 原子历史存储 |
| `mobile/lib/router/app_router.dart` | GoRouter 路由表 |
| `mobile/lib/core/theme/app_theme.dart` | 主题与色彩 |
| `mobile/lib/core/theme/animations.dart` | 动效常量 |

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
