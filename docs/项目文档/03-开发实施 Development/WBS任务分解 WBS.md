# WBS任务分解 Work Breakdown Structure

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 开发者 Developer | HeYS-Snowe |
| 当前版本 Current Version | 2.3.3+23 |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本，覆盖 v1.0.0 → v2.3.3 全部迭代任务树 |

---

## 目录 Table of Contents

1. [WBS概述 WBS Overview](#1-wbs概述-wbs-overview)
2. [项目层级分解 Project Hierarchy](#2-项目层级分解-project-hierarchy)
3. [版本迭代任务树 Version Iteration Task Tree](#3-版本迭代任务树-version-iteration-task-tree)
4. [核心模块任务 Core Module Tasks](#4-核心模块任务-core-module-tasks)
5. [里程碑 Milestones](#5-里程碑-milestones)

---

## 1. WBS概述 WBS Overview

### 1.1 项目定位 Project Positioning

志极 Jeenith 是一款叩问本心的卜算合集移动 App（Flutter，Android + Windows 桌面），收录 12 种传统术数：小六壬、周易、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字，配以使用手册与可扩展框架。

### 1.2 WBS分解原则 Decomposition Principles

| 原则 Principle | 说明 Description |
|--------------|---------------|
| 按版本迭代 Iteration-based | 任务按 v1.0.0 → v2.3.3 版本线分解，每版可独立交付 |
| 按术数分模块 Module-per-tech | 每种卜算术为独立 feature 模块，注册一行即可接入 |
| 框架与内容分离 Framework/Content Split | core/ 框架代码与 features/ 术数实现解耦 |
| 可扩展性 Extensibility | 加新术 = 新建 features/xxx/ + 实现 DivinationTech + registry 注册一行 |
| 纯客户端 Client-only | 无后端，所有计算与存储在本地完成 |

---

## 2. 项目层级分解 Project Hierarchy

```
1.0 志极 Jeenith Project
├── 1.1 框架基础 Framework Foundation (v1.0.0)
│   ├── 1.1.1 Flutter 工程脚手架
│   ├── 1.1.2 卜算框架核心 (DivinationTech / Registry / Result)
│   ├── 1.1.3 真随机引擎 (TrueRandom + 3 源熵)
│   ├── 1.1.4 路由系统 (GoRouter + 仪式路由)
│   ├── 1.1.5 主题与品牌定调 (黑金低饱和度)
│   └── 1.1.6 共享组件库 (GoldButton / DarkButton / Starfield 等)
│
├── 1.2 卜算术实现 Divination Techs
│   ├── 1.2.1 小六壬 Xiaoliuren (v1.0.0)
│   ├── 1.2.2 周易 Zhouyi (v1.0.0 → v1.2.0 卦辞爻辞)
│   ├── 1.2.3 梅花易数 Meihua (v1.0.0 → v1.2.0 卦辞爻辞)
│   ├── 1.2.4 掷筊 Jiaobei (v1.0.0)
│   ├── 1.2.5 紫微斗数 Ziwei (v1.0.0 → v1.3.0 全套星曜)
│   ├── 1.2.6 奇门遁甲 Qimen (v1.0.0 → v1.4.0 四盘九宫)
│   ├── 1.2.7 抽签 Chouqian (v1.6.0)
│   ├── 1.2.8 测字 Cezi (v1.6.0)
│   ├── 1.2.9 大六壬 Daliuren (v1.7.0)
│   ├── 1.2.10 风水罗盘 Luopan (v1.7.0)
│   ├── 1.2.11 八字推演 Bazi (v2.3.0)
│   └── 1.2.12 测名字 NameTest (v2.3.0)
│
├── 1.3 体验与完善 Experience & Polish
│   ├── 1.3.1 主题切换 (v1.5.0)
│   ├── 1.3.2 结果分享 (v1.5.0)
│   ├── 1.3.3 历史导出 (v1.5.0)
│   ├── 1.3.4 按钮物理反馈 (v2.0.0)
│   ├── 1.3.5 图标状态切换 (v2.0.0)
│   └── 1.3.6 动效开关体系 (v2.0.0 → v2.3.2)
│
├── 1.4 动效体系 Animation System (v2.1.0 → v2.2.0)
│   ├── 1.4.1 仪式入场动画 (10 套)
│   ├── 1.4.2 路由转场差异化
│   ├── 1.4.3 绘制过程动画
│   ├── 1.4.4 结果揭示动画
│   └── 1.4.5 加载指示器中国风化
│
├── 1.5 构建与发布 Build & Release
│   ├── 1.5.1 APK 构建脚本 (build_apk.ps1)
│   ├── 1.5.2 Windows 桌面构建
│   ├── 1.5.3 产物归档 (builds/)
│   ├── 1.5.4 版本历史记录 (build_history.json / release_history.json)
│   └── 1.5.5 发布说明 (release_notes/)
│
└── 1.6 文档与开源 Documentation & Open Source
    ├── 1.6.1 使用手册 (App 内 manual)
    ├── 1.6.2 项目文档 (docs/)
    ├── 1.6.3 MIT LICENSE (v2.3.3)
    └── 1.6.4 README (v2.3.3)
```

---

## 3. 版本迭代任务树 Version Iteration Task Tree

### 3.1 v1.0.0 — 首版发布（2026-07-11）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 1.1.1 | Flutter 工程初始化 | mobile/ 工程结构 |
| 1.1.2 | DivinationTech 接口 + Registry | core/divination/ |
| 1.1.3 | TrueRandom 多源熵引擎 | core/rng/ |
| 1.1.4 | GoRouter 路由 + 仪式路由 | core/router/ → router/ |
| 1.1.5 | 黑金主题 + Starfield 背景 | core/theme/ + shared/widgets/ |
| 1.1.6 | 小六壬实现 | features/xiaoliuren/ |
| 1.1.7 | 周易/梅花基础实现 | features/zhouyi/ + meihua/ |
| 1.1.8 | 紫微/奇门基础实现 | features/ziwei/ + qimen/ |
| 1.1.9 | 掷筊实现 | features/jiaobei/ |
| 1.1.10 | 首页 + 使用手册 | features/home/ + manual/ |

### 3.2 v1.1.x — 工程迁移（2026-07-12）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 2.1 | Flutter 工程迁移至 mobile/ 子目录 | 目录结构调整 |
| 2.2 | Windows 桌面平台支持 | windows/ 配置 |
| 2.3 | 多平台构建验证 | Android + Windows 产物 |

### 3.3 v1.2.0 — 卦辞爻辞数据（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 3.1 | 64 卦完整 JSON 数据资产 | assets/yijing/hexagrams.json |
| 3.2 | 386 条爻辞（含用九用六） | hexagrams.json |
| 3.3 | 周易结果页卦辞爻辞展示 | features/zhouyi/ui/ |
| 3.4 | 梅花结果页卦辞爻辞展示 | features/meihua/ui/ |
| 3.5 | data/yijing 数据层 | hexagram_texts.dart + hexagrams.dart + trigrams.dart |

### 3.4 v1.3.0 — 紫微斗数 v2（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 4.1 | 安星算法（14 主星 + 六吉六煞 + 博士十二神 + 神煞） | ziwei/algorithm/star_placement.dart |
| 4.2 | 星曜常量表 | ziwei/data/stars.dart |
| 4.3 | 环形命盘 CustomPainter | ziwei/ui/star_chart_painter.dart |
| 4.4 | 宫位详情列表 | ziwei/ui/ziwei_page.dart |

### 3.5 v1.4.0 — 奇门遁甲 v2（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 5.1 | 天盘九星 + 地盘九干 + 人盘八门 + 神盘八神 | qimen/algorithm/divine.dart |
| 5.2 | 值符值使定位算法 | divine.dart |
| 5.3 | 中宫寄二宫规则 | divine.dart |
| 5.4 | 洛书九宫格 UI + 四盘详表 | qimen/ui/qimen_page.dart |

### 3.6 v1.5.0 — 主题/分享/导出（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 6.1 | 深色/浅色/跟随系统主题切换 | app_theme.dart + config |
| 6.2 | ShareResultButton 截图分享 | shared/widgets/share_result_button.dart |
| 6.3 | 6 术集成 RepaintBoundary | 各 features/*/ui/ |
| 6.4 | HistoryExport（JSON/MD/CSV） | core/history/history_export.dart |
| 6.5 | 历史页导出 PopupMenuButton | features/history/history_page.dart |
| 6.6 | 浅色主题色系 AppColorsLight | app_theme.dart |

### 3.7 v1.6.0 — 抽签 + 测字（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 7.1 | 30 签样例数据 | chouqian/algorithm/divine.dart |
| 7.2 | 竹签筒可视化 + 摇签/落签动画 | chouqian/ui/chouqian_page.dart |
| 7.3 | 测字五行色染算法 | cezi/algorithm/divine.dart |
| 7.4 | 测字字形浮现 UI | cezi/ui/cezi_page.dart |
| 7.5 | Registry 注册两行 | divination_registry.dart |

### 3.8 v1.7.0 — 大六壬 + 风水罗盘（2026-07-13）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 8.1 | 大六壬四课三传算法 | daliuren/algorithm/divine.dart |
| 8.2 | 十二天将 + 昼夜贵人 | divine.dart |
| 8.3 | 天盘环形图 CustomPainter | daliuren/ui/daliuren_page.dart |
| 8.4 | 磁力计订阅 + 方位角计算 | luopan/sensor/compass_provider.dart |
| 8.5 | 24 山罗盘 CustomPainter | luopan/ui/luopan_page.dart |
| 8.6 | 平台判断（仅 Android 磁力计） | core/config/platform_info.dart |

### 3.9 v2.0.0 — 体验深化与品牌定调（2026-07-14）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 9.1 | GoldButton/DarkButton 物理反馈 | shared/widgets/gold_button.dart + dark_button.dart |
| 9.2 | AnimatedExpandIcon 图标状态切换 | shared/widgets/animated_expand_icon.dart |
| 9.3 | AppAnimations 全局动效常量 | core/theme/animations.dart |
| 9.4 | 动效总开关 AppConfig.animationsEnabled | core/config/ |
| 9.5 | 首页「使用方法」卡片升级 | features/home/home_page.dart |
| 9.6 | TextPainter dispose 链路审计 | 全项目 10 处 |

### 3.10 v2.1.0 — 动效体系 Phase 1+2a（2026-07-14）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 10.1 | RitualAnimation 仪式动画基类 | core/animation/ritual/ritual_animation.dart |
| 10.2 | CustomPainter 动画基类 + 工具函数 | core/animation/ |
| 10.3 | 周易铜钱抛落仪式（5s） | zhouyi_ritual.dart |
| 10.4 | 紫微命盘展开仪式（6s） | ziwei_ritual.dart |
| 10.5 | 奇门九宫飞布仪式（5s） | qimen_ritual.dart |
| 10.6 | 大六壬双盘旋转仪式（5s） | daliuren_ritual.dart |
| 10.7 | 风水罗盘扫描仪式（4s） | luopan_ritual.dart |
| 10.8 | 仪式路由接入 | router/app_router.dart |

### 3.11 v2.2.0 — 动效体系 Phase 2b+4.3+5.1（2026-07-14）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 11.1 | 梅花数字撞击仪式（4s） | meihua_ritual.dart |
| 11.2 | 掷筊翻转落地仪式（3s） | jiaobei_ritual.dart |
| 11.3 | 抽签卷轴展开仪式（5s） | chouqian_ritual.dart |
| 11.4 | 测字字形浮现仪式（5s） | cezi_ritual.dart |
| 11.5 | TechTransition 路由转场差异化 | core/animation/transitions/tech_transitions.dart |
| 11.6 | DivinationLoadingIndicator 中国风 | shared/widgets/divination_loading_indicator.dart |

### 3.12 v2.3.0 — 八字 + 测名字 + 紫微重构（2026-07-14）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 12.1 | 八字推演算法（立春分界 + 大运 + 神煞） | features/bazi/ |
| 12.2 | 测名字五格剖象法 + 490 字笔画表 | features/name_test/ |
| 12.3 | 紫微命盘重构（径向排版 + 手动旋转 + 惯性） | ziwei/ui/star_chart_painter.dart |
| 12.4 | 设置页动画 Map 化（animationSettings） | core/config/ |
| 12.5 | 全局消灭 Curves.linear | core/theme/animations.dart |
| 12.6 | 起卦按钮 RepaintBoundary Bug 修复 | 各 features/*/ui/ |

### 3.13 v2.3.1 — 起卦按钮 BUG 修复 + 动效曲线优化（2026-07-15）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 13.1 | 起卦按钮 BUG 修复 | features/*/ui/ |
| 13.2 | 动效曲线优化 | core/theme/animations.dart |

### 3.14 v2.3.2 — 动画细分开关 + Windows 图标修复（2026-07-15）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 14.1 | AnimationKind 枚举（4 类独立开关） | core/config/app_config.dart |
| 14.2 | 设置页每术 4 开关 UI | features/settings/settings_page.dart |
| 14.3 | Windows exe 图标修复（flutter clean + 重构建） | windows/runner/resources/ |

### 3.15 v2.3.3 — 首页间距 + MIT LICENSE + 图标归档（2026-07-15）

| WBS ID | 任务 Task | 交付物 Deliverable |
|--------|----------|-------------------|
| 15.1 | 首页右上角按钮间距修复（8px） | features/home/home_page.dart |
| 15.2 | MIT LICENSE 添加 | LICENSE + README.md |
| 15.3 | Windows 图标产物归档（正确 .ico） | builds/windows/ |

---

## 4. 核心模块任务 Core Module Tasks

### 4.1 卜算框架 Divination Framework

| WBS ID | 模块 Module | 职责 Responsibility |
|--------|------------|-------------------|
| F.1 | DivinationTech | 术数抽象接口（id / meta / buildPage） |
| F.2 | TechMeta | 展示元数据（首页卡片 + 路由） |
| F.3 | DivinationRegistry | 核心注册表（加新术 = 追加一行） |
| F.4 | DivinationResult | 统一结果模型（兼容多术） |
| F.5 | ResultCardData | 结果卡数据结构 |
| F.6 | Verdict / DetailDimension | 吉凶分级 + 多维断辞 |

### 4.2 真随机引擎 RNG Engine

| WBS ID | 模块 Module | 职责 Responsibility |
|--------|------------|-------------------|
| R.1 | EntropyCollector | 熵源接口 |
| R.2 | SystemEntropySource | Random.secure 系统熵 |
| R.3 | TouchEntropySource | 触摸轨迹熵 |
| R.4 | OnlineEntropySource | random.org 大气噪声 |
| R.5 | TrueRandom | 多源 SHA256 混合引擎 |
| R.6 | TouchTracker | 触摸轨迹采集器 |

### 4.3 配置与历史 Config & History

| WBS ID | 模块 Module | 职责 Responsibility |
|--------|------------|-------------------|
| C.1 | AppConfig | 配置模型（熵源/动效/主题） |
| C.2 | ConfigNotifier | 配置持久化（SharedPreferences） |
| C.3 | HistoryStore | 历史记录存储（原子读-改-写） |
| C.4 | HistoryExport | 历史导出（JSON/MD/CSV） |
| C.5 | HistoryEntry | 历史记录模型 |

### 4.4 动效体系 Animation System

| WBS ID | 模块 Module | 职责 Responsibility |
|--------|------------|-------------------|
| A.1 | AppAnimations | 全局动效常量（时长/曲线/错峰） |
| A.2 | RitualAnimation | 仪式动画基类 |
| A.3 | TechTransition | 路由转场差异化 |
| A.4 | RevealAnimation | 结果揭示封装 |
| A.5 | AnimationKind | 4 类动效开关枚举 |

---

## 5. 里程碑 Milestones

### 5.1 里程碑定义 Milestone Definitions

| 里程碑 ID | 名称 Name | 版本 Version | 日期 Date | 验收标准 Acceptance |
|----------|----------|-------------|---------|-------------------|
| M1 | 首版发布 Initial Release | v1.0.0 | 2026-07-11 | 6 术可用 + 框架成型 |
| M2 | 内容深化 Content Depth | v1.2.0 | 2026-07-13 | 64 卦 386 爻数据落地 |
| M3 | 全术集齐 All Techs | v1.7.0 | 2026-07-13 | 10 术全部实现 |
| M4 | 体验完善 Experience Polish | v1.5.0 | 2026-07-13 | 主题/分享/导出落地 |
| M5 | 品牌定调 Brand Defining | v2.0.0 | 2026-07-14 | 按钮物理反馈 + 动效开关 |
| M6 | 仪式化 Ritualization | v2.2.0 | 2026-07-14 | 10 术仪式动画 + 转场差异化 |
| M7 | 功能扩展 Feature Expansion | v2.3.0 | 2026-07-14 | 12 术集齐（+ 八字 + 测名字） |
| M8 | 开源就绪 Open Source Ready | v2.3.3 | 2026-07-15 | MIT LICENSE + 0 issue |

### 5.2 里程碑检查清单 Milestone Checklist

**M1 首版发布:**

- [x] DivinationTech 框架成型
- [x] TrueRandom 3 源熵引擎
- [x] 小六壬/周易/梅花/紫微/奇门/掷筊 6 术可用
- [x] 首页选术 + 使用手册
- [x] 黑金主题 + Starfield 背景

**M3 全术集齐:**

- [x] 抽签 + 测字（v1.6.0）
- [x] 大六壬 + 风水罗盘（v1.7.0）
- [x] 10 术全部注册接入
- [x] flutter analyze 0 issue

**M6 仪式化:**

- [x] 10 套仪式入场动画
- [x] 路由转场差异化（每术专属视觉语言）
- [x] 加载指示器中国风化
- [x] 4 类动效独立开关

**M8 开源就绪:**

- [x] MIT LICENSE 添加
- [x] README 版权声明
- [x] Windows 图标正确归档
- [x] flutter analyze 0 issue
- [x] 首页按钮间距修复

---

## 附录 Appendix

### 附录A：版本工作量统计 Effort Summary

| 版本 Version | 主题 Theme | 新增术数 New Techs |
|-------------|----------|------------------|
| v1.0.0 | 首版发布 | 小六壬/周易/梅花/紫微/奇门/掷筊 |
| v1.2.0 | 卦辞爻辞 | — |
| v1.3.0 | 紫微 v2 | — |
| v1.4.0 | 奇门 v2 | — |
| v1.5.0 | 主题/分享/导出 | — |
| v1.6.0 | 抽签/测字 | 抽签/测字 |
| v1.7.0 | 大六壬/罗盘 | 大六壬/风水罗盘 |
| v2.0.0 | 品牌定调 | — |
| v2.1.0 | 动效 Phase 1 | — |
| v2.2.0 | 动效 Phase 2 | — |
| v2.3.0 | 八字/测名字 | 八字推演/测名字 |
| v2.3.3 | 开源就绪 | — |

---

**文档结束 End of Document**

志极 Jeenith · 志于本心，知于极处
