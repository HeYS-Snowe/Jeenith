# 项目立项申请书 Project Proposal

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-05 |
| 最后修改 Last Modified | 2026-07-15 |
| 作者 Author | HeYS-Snowe |
| 审核人 Reviewer | Qore Origins |
| 批准人 Approver | Qore Origins |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-05 | HeYS-Snowe | 立项初稿 Initiation draft |
| v1.1.0 | 2026-07-15 | HeYS-Snowe | 同步至 2.3.3 release，补全市场分析与风险评估 Sync to 2.3.3 release |

---

## 目录 Table of Contents

1. [项目背景 Project Background](#1-项目背景-project-background)
2. [项目概述 Project Overview](#2-项目概述-project-overview)
3. [立项理由 Justification](#3-立项理由-justification)
4. [项目目标 Project Objectives](#4-项目目标-project-objectives)
5. [项目范围 Project Scope](#5-项目范围-project-scope)
6. [技术方案 Technical Solution](#6-技术方案-technical-solution)
7. [市场分析 Market Analysis](#7-市场分析-market-analysis)
8. [风险评估 Risk Assessment](#8-风险评估-risk-assessment)
9. [资源需求 Resource Requirements](#9-资源需求-resource-requirements)
10. [时间计划 Timeline](#10-时间计划-timeline)
11. [预期收益 Expected Benefits](#11-预期收益-expected-benefits)
12. [审批意见 Approval](#12-审批意见-approval)

---

## 1. 项目背景 Project Background

### 1.1 立项背景 Initiation Background

中华术数文化是东方文明的重要组成，历经数千年沉淀，形成了以小六壬、周易、梅花易数、紫微斗数、奇门遁甲、大六壬、八字推演等为代表的完整推演体系。这些术数不仅是观象问事的工具，更是古人思考"天人关系"的智慧结晶，承载着"叩问本心、明察事理"的文化内核。

然而，在数字化浪潮下，传统术数的传承与体验面临以下问题：

**当前问题 Current Issues:**
- 传统术数 App 体验陈旧，多为表单式输入与纯文本输出，缺乏仪式感与现代审美
- 各术数 App 功能割裂，用户需要在多个 App 之间切换，缺乏统一合集体验
- 大量 App 使用伪随机数，难以契合"心诚则灵"语境下对随机本源的尊重
- 部分术数算法实现不规范，缺乏天文历算（如寿星天文历 lunar）等关键基础支撑
- 桌面端体验缺位，研究者难以在 PC 上进行严肃的排盘与推演

**业务痛点 Business Pain Points:**
- **体验痛点**：界面古板、操作流程割裂、缺乏动效与仪式感
- **算法痛点**：实现杂糅、历算基础缺失、难以复算与查证
- **随机痛点**：伪随机数主导，缺乏真随机引擎
- **生态痛点**：术数分散，缺乏可扩展的卜算框架

### 1.2 项目来源 Project Source

| 来源类型 Source Type | 具体说明 Description |
|-------------------|-------------------|
| ☑ 战略规划 Strategic Plan | Qore Origins 旗下传统文化数字化战略 |
| ☑ 个人愿景 Personal Vision | 开发者对传统术数与现代体验融合的追求 |
| ☑ 技术升级 Technology Upgrade | Flutter 跨端 + lunar 天文历 + 真随机引擎 |
| ☑ 开源贡献 Open Source | 以 MIT 协议回馈传统文化社区 |
| □ 客户需求 Customer Request | - |
| □ 比赛竞赛 Competition | - |

---

## 2. 项目概述 Project Overview

### 2.1 项目基本信息 Project Basic Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **项目名称 Project Name** | 志极（Jeenith） |
| **组织 Organization** | Qore Origins（叩心） |
| **应用包名 Package Name** | `com.qore.jeenith` |
| **项目类型 Project Type** | 移动 App（Flutter，Android + Windows 桌面） |
| **项目定位 Positioning** | 叩问本心的卜算合集 |
| **当前版本 Current Version** | 2.3.3+23（release，2026-07-15） |
| **GitHub 仓库 Repository** | https://github.com/HeYS-Snowe/Jeenith |
| **许可证 License** | MIT |
| **品牌精神 Brand Spirit** | 志于本心，知于极处 —— Question the core. Return to origins. |
| **开发者 Developer** | HeYS-Snowe（唯一开发者） |
| **创建日期 Created Date** | 2026-07-05 |

### 2.2 项目定位 Product Positioning

"志极"是一款以现代、精致体验承载十二种主流中华术数的卜算合集 App。其核心定位为：

- **合集而非单术**：一站式覆盖十二种主流术数，统一体验入口
- **仪式而非表单**：每一次起卦、摇爻、掐指、布盘都成为叩问本心的仪式
- **精致而非古板**：Flutter 跨端 + 动效体系 Phase 1-6 + 主题切换
- **可信而非杂糅**：lunar 天文历 + 真随机引擎 + 算法对照权威文献
- **可扩展而非封闭**：DivinationTech + registry 框架，新术接入 ≤ 1 feature 目录 + 一行注册

---

## 3. 立项理由 Justification

### 3.1 文化传承价值 Cultural Heritage Value

中华术数是东方哲学"天人合一"思想的实践载体。通过数字化手段将其以现代、精致的方式呈现，有助于：

- **活化传承**：让传统术数以现代交互重新进入大众视野
- **规范整理**：以代码形式固化算法实现，避免口耳相传中的失真
- **学术辅助**：为术数研究者提供可复算、可查证的排盘工具

### 3.2 技术驱动价值 Technology-Driven Value

- **Flutter 跨端**：单代码库覆盖 Android + Windows 桌面，验证 Flutter 在传统文化 App 的可行性
- **真随机引擎**：探索 dart:math Random.secure + 触摸轨迹 + random.org 多源真随机在移动端的落地
- **可扩展框架**：DivinationTech + registry 范式可复用于其他"插件式合集"类应用
- **动效体系**：Phase 1-6 的入场仪式/路由转场/绘制过程/结果揭示动效体系，是 Flutter 高级动效的实践样本

### 3.3 用户需求价值 User Demand Value

- 传统文化爱好者需要一站式体验多种术数
- 术数研究者需要算法规范、可查证的排盘工具
- 移动端用户需要离线可用、便携精致的卜算工具
- 桌面端用户需要 Windows 平台的同等体验

### 3.4 开源生态价值 Open Source Value

- MIT 协议开源，回馈传统文化与 Flutter 社区
- 提供可参考的"传统文化 + 现代体验"App 工程范本
- 框架可被复用于其他术数/占卜类应用

---

## 4. 项目目标 Project Objectives

### 4.1 总体目标 Overall Objective

**项目愿景 Project Vision:**

构建面向中文用户的现代卜算合集"志极（Jeenith）"，以 Flutter 跨端体验承载十二种主流术数，通过可扩展的 DivinationTech 框架支持新术快速接入，以真随机引擎、动效体系、仪式感设计实现"叩问本心、知于极处"的品牌精神，成为术数爱好者的随身工具集。

### 4.2 具体目标 Specific Objectives

| 序号 ID | 目标描述 Objective | 成功标准 Success Criteria | 优先级 Priority |
|--------|-----------------|------------------------|---------------|
| 1 | 上线 12 种主流术数卜算功能 | 12 术全部可独立完成卜算闭环 | P0 |
| 2 | 建立可扩展卜算框架 | 新增术数 ≤ 1 feature 目录 + registry 一行 | P0 |
| 3 | 实现真随机引擎 | ≥ 3 种真随机来源 + 多源降级 | P0 |
| 4 | 完成动效体系 Phase 1-6 | 入场/路由/绘制/揭示全覆盖 + 全局开关 | P0 |
| 5 | 跨端一致（Android + Windows） | 双端行为一致，构建产物均产出 | P0 |
| 6 | 开源 MIT 协议 | 公开仓库 + LICENSE + 文档完整 | P1 |
| 7 | 完成使用手册 | 12 术原理与操作说明 | P1 |

### 4.3 关键成功指标 KSI (Key Success Indicators)

| 指标 Indicator | 目标值 Target | 当前值 Current |
|--------------|-------------|--------------|
| 术数种类 Divination Count | 12 种 | 12 种（已达成）|
| 真随机来源 RNG Sources | ≥ 3 种 | 3 种（已达成）|
| 动效阶段 Motion Phases | 6 阶段全覆盖 | 6 阶段（已达成）|
| 跨端平台 Platforms | Android + Windows | Android + Windows（已达成）|
| flutter analyze | 0 error / 0 warning | 达标 |
| 启动时间 Cold Start | < 2s | 达标 |
| 单次卜算响应 Latency | < 500ms | 达标 |

---

## 5. 项目范围 Project Scope

### 5.1 项目边界 Project Boundaries

#### 包含范围 In Scope

- 移动端卜算合集 App"志极"（Flutter，Android + Windows 桌面）
- 12 种主流术数：小六壬 / 周易（金钱卦）/ 梅花易数 / 掷筊 / 紫微斗数 / 奇门遁甲 / 抽签 / 测字 / 大六壬 / 风水罗盘 / 八字推演 / 测名字
- 核心框架：DivinationTech 抽象 + registry 注册 + 仪式路由
- 真随机引擎：dart:math Random.secure + 触摸轨迹 + random.org（多源降级）
- 动效体系：Phase 1-6（入场仪式 / 路由转场 / 绘制过程 / 结果揭示）
- 主题与设置：主题切换 + 动效全局开关 + 动画细分（4 个 AnimationKind 独立控制）
- 历史记录：本地存储 + 导出
- 结果分享：share_plus 系统分享
- 使用手册：术数原理与操作说明
- 双端构建产物：Android APK + Windows ZIP
- 双份历史归档：builds/ + build_history.json

#### 排除范围 Out of Scope

- 后端服务 / 用户账号系统 / 云同步
- iOS / macOS / Linux 构建
- 付费功能 / 内购 / 广告
- 推送通知 / 第三方 SDK 接入
- 实时多人协作 / 社交功能

### 5.2 范围管理原则 Scope Management Principles

- **扩展范式**：新术接入遵循"新建 features/xxx/ + 实现 DivinationTech + registry 注册一行"
- **跨端一致**：任何功能须同时在 Android 与 Windows 桌面可用
- **算法优先**：术数算法正确性优先于视觉表现，先正确再精致
- **隐私优先**：所有数据本地存储，不收集用户信息

---

## 6. 技术方案 Technical Solution

### 6.1 技术栈 Technology Stack

| 层级 Layer | 技术 Technology | 用途 Purpose |
|----------|---------------|------------|
| 框架 Framework | Flutter 3.x（Dart 3.11+） | 跨端 UI 框架 |
| 状态管理 State | flutter_riverpod ^2.5 | 响应式状态管理 |
| 路由 Router | go_router ^14.0 | 声明式路由 + 仪式路由 |
| 历法 Calendar | lunar ^1.7.8 | 寿星天文历（农历/节气/八字/紫微/奇门/大六壬）|
| 图标 Icons | flutter_svg ^2.0 | SVG 矢量图标 |
| 真随机 RNG | dart:math Random.secure + http random.org + crypto SHA256 | 多源真随机引擎 |
| 配置存储 Config | shared_preferences ^2.2 | 主题/动效偏好持久化 |
| 传感器 Sensor | sensors_plus ^6.0.0 | 陀螺仪/磁场（风水罗盘）|
| 分享 Share | share_plus ^10.0.0 | 系统分享卜算结果 |
| 文件路径 Path | path_provider ^2.1.0 | 历史导出文件路径 |
| APP 图标 Icon | flutter_launcher_icons ^0.14 | 自动生成多平台图标 |

### 6.2 架构设计 Architecture Design

```
mobile/lib/
├── app.dart              # JeenithApp（MaterialApp.router + Starfield 背景 + 主题模式）
├── main.dart             # 入口（async + ProviderScope + 桌面窗口尺寸初始化）
├── core/                 # 核心功能
│   ├── branding/         # 品牌信息（不硬编码，读 OrganizationAndUser.md）
│   ├── calendar/         # lunar 历算封装
│   ├── config/           # AppConfig（animationsEnabled / AnimationKind 细分）
│   ├── divination/       # DivinationTech 抽象 + registry 注册
│   ├── history/          # HistoryStore（原子读-改-写）
│   ├── rng/              # 真随机引擎（多源降级）
│   └── theme/            # 主题 + animations.dart（动效统一封装）
├── data/                 # 数据层
│   └── yijing/           # 64卦 + 八卦数据（周易/梅花共用）
├── features/             # 12 术 + 设置 + 历史 + 手册
│   ├── home/             # 首页选术 grid
│   ├── xiaoliuren/       # 小六壬
│   ├── zhouyi/           # 周易（金钱卦）
│   ├── meihua/           # 梅花易数
│   ├── jiaobei/          # 掷筊
│   ├── ziwei/            # 紫微斗数 v2
│   ├── qimen/            # 奇门遁甲 v2
│   ├── chouqian/         # 抽签
│   ├── cezi/             # 测字
│   ├── daliuren/         # 大六壬
│   ├── luopan/           # 风水罗盘
│   ├── bazi/             # 八字推演
│   ├── name_test/        # 测名字
│   ├── manual/           # 使用手册
│   ├── settings/         # 设置（主题/动效/动画细分）
│   └── history/          # 历史
├── providers/            # providers.dart（barrel 聚合 config + rng providers）
├── router/               # app_router.dart（GoRouter + 仪式路由）
└── shared/               # 通用组件
    └── widgets/          # GoldButton / DarkButton / AnimatedExpandIcon / SvgIcon /
                          #   DecorativePanel / InteractableCard / CopyResultButton /
                          #   ShareResultButton / GuideDialog / Starfield / SectionTitle
```

### 6.3 关键技术决策 Key Technical Decisions

| 决策 Decision | 选择 Choice | 理由 Reason |
|-------------|-----------|-----------|
| 跨端框架 | Flutter | 单代码库覆盖 Android + Windows，UI 一致 |
| 状态管理 | Riverpod | 编译时安全、可测试、生态成熟 |
| 路由 | go_router | 声明式 + 仪式路由（起卦过程中的路由守卫）|
| 历法库 | lunar | 寿星天文历，农历/节气/八字/紫微/奇门/大六壬统一基础 |
| 真随机 | Random.secure + 触摸轨迹 + random.org | 多源降级，契合"心诚则灵"语境 |
| 传感器 | sensors_plus | 风水罗盘陀螺仪/磁场实时方位 |
| 数据存储 | shared_preferences | 配置类轻量存储，无需数据库 |
| 历史存储 | 本地 JSON（原子读-改-写）| 无后端，隐私优先 |
| 图标 | flutter_svg | 矢量图标，多分辨率适配 |
| 分享 | share_plus | 系统级分享，无第三方依赖 |

### 6.4 真随机引擎方案 RNG Solution

```
真随机来源（按优先级降级）
┌─────────────────────────────────────────┐
│ 1. random.org（HTTP 真随机，需网络）      │
│    └─ 失败降级 ↓                         │
│ 2. 触摸轨迹熵（用户起卦过程的触摸采样）    │
│    └─ 失败降级 ↓                         │
│ 3. dart:math Random.secure（系统 CSPRNG） │
└─────────────────────────────────────────┘
       ↓
   SHA256 混合 → 卜算随机源
```

### 6.5 动效体系方案 Motion System

| 阶段 Phase | 内容 Content | 实现 Implementation |
|-----------|------------|-------------------|
| Phase 1 | 入场仪式 | 首页 Starfield + 术数卡片入场 |
| Phase 2 | 路由转场 | go_router 自定义转场 |
| Phase 3 | 绘制过程 | 起卦过程中的卦象/盘面绘制动画 |
| Phase 4 | 结果揭示 | 结果卡片揭示动画 |
| Phase 5 | 按钮物理反馈 | GoldButton / DarkButton 物理反馈 |
| Phase 6 | 图标状态切换 | AnimatedExpandIcon + SvgIcon 状态切换 |

> 所有动效统一封装在 `core/theme/animations.dart`，可通过设置页全局开关（AppConfig.animationsEnabled），并支持 4 个 AnimationKind 独立控制。

---

## 7. 市场分析 Market Analysis

### 7.1 目标市场 Target Market

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| 地域 Region | 中文文化圈（中国大陆、港澳台、东南亚华人社区）|
| 人群 Audience | 传统文化爱好者、术数研究者、Flutter/技术观察者 |
| 场景 Scenario | 日常问事、命理研究、排盘学习、文化体验 |
| 渠道 Channel | GitHub 开源、应用市场（可选）、社群传播 |

### 7.2 竞品分析 Competitive Analysis

| 维度 Dimension | 传统术数 App | 志极 Jeenith |
|--------------|------------|------------|
| 体验 Experience | 表单式、文本输出 | 仪式感、动效体系、精致交互 |
| 术数覆盖 Coverage | 单术为主 | 12 术合集 |
| 算法基础 Algorithm | 自实现，参差不齐 | lunar 天文历统一基础 |
| 随机源 RNG | 伪随机 | 多源真随机引擎 |
| 框架 Framework | 封闭 | DivinationTech + registry 可扩展 |
| 跨端 Cross-Platform | 多为 Android 单端 | Android + Windows 桌面 |
| 开源 Open Source | 多为闭源 | MIT 协议开源 |
| 桌面端 Desktop | 几乎缺位 | Windows 桌面同等体验 |

### 7.3 差异化优势 Differentiation

- **合集体验**：12 术一站式，统一交互范式
- **仪式感设计**：动效 Phase 1-6 全覆盖，叩问本心的仪式
- **真随机引擎**：多源真随机，契合"心诚则灵"
- **算法规范**：lunar 天文历 + 权威文献对照
- **可扩展框架**：新术接入 ≤ 1 feature 目录 + registry 一行
- **跨端一致**：Android + Windows 同代码库
- **开源 MIT**：回馈社区，可复用工程范本

### 7.4 市场风险 Market Risk

- 术数类应用在部分渠道审核较严，需明确定位为"传统文化工具"
- 用户教育成本：需通过使用手册降低术数认知门槛
- 开源项目的可持续性：依赖开发者业余时间投入

---

## 8. 风险评估 Risk Assessment

### 8.1 风险矩阵 Risk Matrix

| 风险ID Risk ID | 风险描述 Risk Description | 影响 Impact | 概率 Probability | 等级 Level | 应对 Strategy |
|--------------|----------------------|-----------|---------------|---------|-------------|
| R001 | 术数算法实现错误（安星/排盘/神煞）| 高 | 中 | 高 | 关键算法对照权威文献/在线排盘工具校验 |
| R002 | 风水罗盘传感器兼容性 | 中 | 中 | 中 | sensors_plus 抽象 + 设备能力降级 |
| R003 | 单人开发进度瓶颈 | 中 | 高 | 高 | 严格版本节奏，优先核心目标 |
| R004 | lunar 库版本升级导致历算回归 | 中 | 低 | 低 | 锁定版本 ^1.7.8，升级前回归测试 |
| R005 | Windows 桌面 Flutter 支持不稳定 | 中 | 低 | 低 | 关键功能先验证 Windows 构建 |
| R006 | random.org 网络不可用 | 低 | 高 | 中 | 真随机多源降级 |
| R007 | 术数内容合规风险 | 高 | 低 | 中 | MIT 协议 + 定位传统文化工具 + 非迷信宣传 |
| R008 | Flutter 升级破坏性变更 | 中 | 中 | 中 | 锁定 3.x 主线，升级前回归测试 |

### 8.2 风险应对详情 Risk Response Details

#### R001 术数算法错误
- **触发条件**：上线后发现排盘/安星结果与权威工具不一致
- **应对措施**：建立关键用例对照集（紫微 14 主星 / 奇门四盘 / 大六壬四课三传 / 八字四柱）
- **降级方案**：发现问题立即修复并发版，附 changelog 说明

#### R007 术数内容合规
- **触发条件**：应用市场审核拒绝 / 政策收紧
- **应对措施**：明确定位为"传统文化工具"，使用手册强调文化属性，避免"迷信宣传"措辞
- **降级方案**：GitHub 始终为发布主渠道，应用市场为辅

---

## 9. 资源需求 Resource Requirements

### 9.1 人力资源 Human Resources

| 角色 Role | 人数 Count | 投入 Effort | 来源 Source |
|----------|---------|----------|-----------|
| 全栈开发者 / 架构师 / 维护 | 1 | 业余时间 | HeYS-Snowe |
| **合计 Total** | **1** | - | - |

### 9.2 硬件资源 Hardware Resources

| 设备 Device | 用途 Purpose | 来源 Source |
|-----------|-----------|-----------|
| 开发 PC（Windows） | 开发 + Windows 桌面构建 | 自有 |
| Android 测试机 | Android 设备测试 | 自有 |

### 9.3 软件资源 Software Resources

| 软件 Software | 用途 Purpose | 费用 Cost |
|-------------|-----------|---------|
| Flutter SDK | 跨端框架 | 免费 |
| Android Studio / VS Code | IDE | 免费 |
| Git / GitHub | 版本控制 + 仓库 | 免费 |
| PowerShell 7+ | 构建脚本 | 免费 |

### 9.4 第三方服务 Third-Party Services

| 服务 Service | 用途 Purpose | 费用 Cost |
|-----------|-----------|---------|
| random.org | 真随机源（可选） | 免费额度 |
| GitHub | 代码托管 | 免费 |

### 9.5 预算 Budget

| 类别 Category | 预算 Budget (¥) |
|-------------|---------------|
| 人力 Human | 0（自驱） |
| 硬件 Hardware | 0（自有设备） |
| 软件 Software | 0（开源） |
| 服务 Services | 0（免费额度） |
| **总计 Total** | **¥0** |

> 本项目为零预算开源个人项目。

---

## 10. 时间计划 Timeline

### 10.1 版本演进计划 Version Roadmap

| 版本 Version | 日期 Date | 核心内容 Highlights | 状态 Status |
|-------------|---------|------------------|-----------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 术 v1（小六壬/周易/梅花/掷筊/紫微/奇门）| ✓ 已发布 |
| 1.1.0 | 2026-07-12 | 工程迁移至 mobile/ 子目录 | ✓ 已发布 |
| 1.2.0 | 2026-07-13 | 周易/梅花卦辞爻辞数据 | ✓ 已发布 |
| 1.3.0 | 2026-07-13 | 紫微斗数 v2 | ✓ 已发布 |
| 1.4.0 | 2026-07-13 | 奇门遁甲 v2 | ✓ 已发布 |
| 1.5.0 | 2026-07-13 | 主题切换 + 结果分享 + 历史导出 | ✓ 已发布 |
| 1.6.0 | 2026-07-13 | 抽签 + 测字 | ✓ 已发布 |
| 1.7.0 | 2026-07-13 | 大六壬 + 风水罗盘 | ✓ 已发布 |
| 1.8.0 | 2026-07-13 | 使用手册页面 | ✓ 已发布 |
| 2.0.0 | 2026-07-14 | release，体验深化与品牌定调 | ✓ 已发布 |
| 2.1.0 / 2.2.0 | 2026-07-14 | 动效体系 Phase 1-6 | ✓ 已发布 |
| 2.3.0 | 2026-07-15 | 八字推演 + 测名字 + 紫微盘重构 | ✓ 已发布 |
| 2.3.1-2.3.3 | 2026-07-15 | 起卦按钮修复 + 设置页动画细分 + MIT LICENSE | ✓ 已发布 |

### 10.2 后续规划 Future Plan

| 版本 Version | 计划内容 Planned Content |
|-------------|----------------------|
| 2.4.x | 思源宋体字体接入、首次使用引导遮罩 |
| 2.5.x | 主题浅色对齐细节、罗盘精度优化 |
| 3.x | 视新术需求扩展（如六爻纳甲、铁板神数等）|

---

## 11. 预期收益 Expected Benefits

### 11.1 文化收益 Cultural Benefits

- 活化传承中华术数文化，以现代体验重新进入大众视野
- 以代码形式规范化术数算法实现，避免口耳相传失真
- 为术数研究者提供可复算、可查证的排盘工具

### 11.2 技术收益 Technical Benefits

- 验证 Flutter 跨端（Android + Windows）在传统文化 App 的可行性
- 沉淀真随机引擎、动效体系、可扩展框架等可复用工程范式
- 为开源社区提供"传统文化 + 现代体验"App 工程范本

### 11.3 品牌收益 Brand Benefits

- 树立 Qore Origins 在传统文化数字化领域的品牌形象
- 践行"志于本心，知于极处"的品牌精神
- 通过开源扩大品牌影响力

### 11.4 用户收益 User Benefits

- 一站式体验 12 种主流术数
- 享受精致仪式感的卜算体验
- 获得算法规范、可查证的排盘工具
- 隐私优先，所有数据本地存储

---

## 12. 审批意见 Approval

### 12.1 立项审批 Initiation Approval

| 角色 Role | 姓名 Name | 意见 Opinion | 签名 Signature | 日期 Date |
|----------|---------|-----------|--------------|---------|
| 申请人 Applicant | HeYS-Snowe | 同意立项 Agree | - | 2026-07-05 |
| 审核人 Reviewer | Qore Origins | 同意立项 Agree | - | 2026-07-05 |
| 批准人 Approver | Qore Origins | 同意立项 Agree | - | 2026-07-05 |

### 12.2 附加说明 Additional Notes

- 本项目为零预算开源个人项目，不涉及资金投入
- 项目持续运营依赖开发者业余时间投入
- 重大方向变更需经 Qore Origins 确认
- 项目以 MIT 协议开源，欢迎社区贡献

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| Jeenith | 志极，项目英文名 |
| Qore | 叩心，发起组织简称 |
| DivinationTech | 卜算术抽象接口 |
| registry | 卜算术注册表 |
| lunar | 寿星天文历 Dart 库 |
| RNG | Random Number Generator，真随机引擎 |
| Starfield | 星点背景动画 |
| AnimationKind | 动画类型枚举（4 种独立控制）|

### 附录B：参考文档 Reference Documents

- 项目章程 Project Charter
- 可行性分析报告 Feasibility Analysis
- AGENTS.md / CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

---

**文档结束 End of Document**

**重要提示:** 本立项申请书一经批准，即成为项目执行的正式依据。任何重大变更须重新评审。
