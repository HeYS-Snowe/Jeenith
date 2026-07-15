# 产品需求文档 PRD Product Requirements Document

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v2.3.3 |
| 创建日期 Created Date | 2026-07-05 |
| 最后修改 Last Modified | 2026-07-15 |
| 作者 Author | HeYS-Snowe |
| 审核人 Reviewer | Qore Origins |
| 产品名称 Product Name | 志极（Jeenith） |
| 当前版本 Current Version | 2.3.3+23（release，2026-07-15）|

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-05 | HeYS-Snowe | PRD 初稿，6 术 v1 需求 Initial PRD |
| v1.6.0 | 2026-07-13 | HeYS-Snowe | 补全抽签/测字/大六壬/罗盘需求 |
| v2.0.0 | 2026-07-14 | HeYS-Snowe | 体验深化与品牌定调需求 |
| v2.3.0 | 2026-07-15 | HeYS-Snowe | 八字推演 + 测名字需求 |
| v2.3.3 | 2026-07-15 | HeYS-Snowe | 同步当前 release 状态，定稿 |

---

## 目录 Table of Contents

1. [产品概述 Product Overview](#1-产品概述-product-overview)
2. [目标用户 Target Users](#2-目标用户-target-users)
3. [产品定位与价值 Product Positioning](#3-产品定位与价值-product-positioning)
4. [功能需求 Functional Requirements](#4-功能需求-functional-requirements)
5. [非功能需求 Non-Functional Requirements](#5-非功能需求-non-functional-requirements)
6. [用户故事 User Stories](#6-用户故事-user-stories)
7. [用例 Use Cases](#7-用例-use-cases)
8. [信息架构 Information Architecture](#8-信息架构-information-architecture)
9. [版本规划 Version Roadmap](#9-版本规划-version-roadmap)
10. [验收标准 Acceptance Criteria](#10-验收标准-acceptance-criteria)

---

## 1. 产品概述 Product Overview

### 1.1 产品基本信息 Product Basic Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **产品名称 Product Name** | 志极（Jeenith） |
| **组织 Organization** | Qore Origins（叩心） |
| **应用包名 Package Name** | `com.qore.jeenith` |
| **产品类型 Product Type** | 移动 App（Flutter，Android + Windows 桌面） |
| **产品定位 Positioning** | 叩问本心的卜算合集 |
| **当前版本 Current Version** | 2.3.3+23（release，2026-07-15） |
| **品牌精神 Brand Spirit** | 志于本心，知于极处 —— Question the core. Return to origins. |
| **GitHub 仓库 Repository** | https://github.com/1010523654/Jeenith |
| **许可证 License** | MIT |

### 1.2 产品简介 Product Brief

"志极"是一款以现代、精致体验承载十二种主流中华术数的卜算合集 App。通过可扩展的 DivinationTech 框架，将小六壬、周易（金钱卦）、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字等十二种术数统一收纳于同一体验入口，以真随机引擎、动效体系 Phase 1-6、仪式感设计践行"叩问本心、知于极处"的品牌精神。

### 1.3 产品愿景 Product Vision

让传统术数以现代、精致、可信赖的方式呈现于指尖；让每一次起卦、摇爻、掐指、布盘都成为叩问本心的仪式；让可扩展框架支撑更多术数的接入，成为术数爱好者的随身工具集。

---

## 2. 目标用户 Target Users

### 2.1 用户画像 User Personas

#### 画像 A：传统文化爱好者（核心用户）

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| 年龄 Age | 25-55 岁 |
| 特征 Characteristics | 对中华传统文化有浓厚兴趣，多术数均有涉猎 |
| 痛点 Pain Points | 现有术数 App 体验割裂、需多 App 切换、缺乏仪式感 |
| 期望 Expectation | 一站式体验多种术数，仪式感强，操作流畅 |
| 设备 Device | Android 手机为主，部分有 Windows PC |

#### 画像 B：术数研究者

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| 年龄 Age | 30-60 岁 |
| 特征 Characteristics | 对特定术数有深入研究，关注算法规范与可查证性 |
| 痛点 Pain Points | 现有工具算法不规范、难以复算、缺乏权威历算基础 |
| 期望 Expectation | 算法规范、可复算、对照权威文献、桌面端可严肃排盘 |
| 设备 Device | Windows PC 为主，Android 手机辅助 |

#### 画像 C：技术观察者

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| 年龄 Age | 20-40 岁 |
| 特征 Characteristics | 关注 Flutter 跨端、动效体系、开源项目 |
| 痛点 Pain Points | 缺少高质量 Flutter 工程范本 |
| 期望 Expectation | 学习 Flutter 跨端 + 动效 + 可扩展框架的工程实践 |
| 设备 Device | Android + Windows |

### 2.2 用户需求总结 User Needs Summary

| 需求 Need | 优先级 Priority | 来源 Source |
|----------|---------------|-----------|
| 一站式体验 12 种主流术数 | P0 | 画像 A |
| 算法规范、可复算、可查证 | P0 | 画像 B |
| 桌面端同等体验 | P1 | 画像 B |
| 仪式感与精致动效 | P0 | 画像 A |
| 真随机而非伪随机 | P1 | 画像 A/B |
| 隐私优先、离线可用 | P0 | 画像 A/B |
| 历史记录与导出 | P1 | 画像 A/B |
| 使用手册 | P1 | 画像 A/B |
| 开源可参考 | P2 | 画像 C |

---

## 3. 产品定位与价值 Product Positioning

### 3.1 产品定位 Product Positioning

- **合集而非单术**：一站式覆盖十二种主流术数，统一体验入口
- **仪式而非表单**：每一次起卦、摇爻、掐指、布盘都成为叩问本心的仪式
- **精致而非古板**：Flutter 跨端 + 动效体系 Phase 1-6 + 主题切换
- **可信而非杂糅**：lunar 天文历 + 真随机引擎 + 算法对照权威文献
- **可扩展而非封闭**：DivinationTech + registry 框架，新术接入 ≤ 1 feature 目录 + 一行注册

### 3.2 价值主张 Value Proposition

| 维度 Dimension | 价值 Value |
|-------------|---------|
| 文化价值 Cultural | 活化传承中华术数，以现代体验重新进入大众视野 |
| 用户价值 User | 一站式 12 术 + 仪式感 + 真随机 + 算法规范 |
| 技术价值 Technical | Flutter 跨端 + 动效体系 + 可扩展框架的工程范本 |
| 品牌价值 Brand | 践行"志于本心，知于极处"的 Qore 品牌精神 |

### 3.3 差异化优势 Differentiation

- 12 术合集，统一交互范式
- 动效 Phase 1-6 全覆盖，叩问本心的仪式
- 多源真随机引擎，契合"心诚则灵"
- lunar 天文历 + 权威文献对照，算法规范
- 可扩展框架，新术接入成本极低
- Android + Windows 跨端一致
- MIT 协议开源

---

## 4. 功能需求 Functional Requirements

### 4.1 功能架构 Function Architecture

```
志极 Jeenith
├── 首页 Home（选术 grid）
├── 卜算术 Divination（12 种）
│   ├── 小六壬 Xiaoliuren
│   ├── 周易 Zhouyi（金钱卦）
│   ├── 梅花易数 Meihua
│   ├── 掷筊 Jiaobei
│   ├── 紫微斗数 Ziwei
│   ├── 奇门遁甲 Qimen
│   ├── 抽签 Chouqian
│   ├── 测字 Cezi
│   ├── 大六壬 Daliuren
│   ├── 风水罗盘 Luopan
│   ├── 八字推演 Bazi
│   └── 测名字 NameTest
├── 使用手册 Manual
├── 设置 Settings
└── 历史 History
```

### 4.2 核心功能需求 Core Functional Requirements

#### FR-01 首页选术 Home Selection

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-01 |
| **优先级** | P0 |
| **描述** | 首页以 grid 展示 12 种术数入口，用户点击进入对应术数操作页 |
| **输入** | 用户点击 |
| **输出** | 路由跳转至对应术数 |
| **验收** | 12 术入口均可点击进入，Starfield 背景动效正常 |

#### FR-02 小六壬 Xiaoliuren

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-02 |
| **优先级** | P0 |
| **描述** | 掐指神课，三段游走六宫断吉凶 |
| **输入** | 三段数字（如月份/日期/时辰），通过触摸轨迹采样真随机 |
| **计算** | 大安/留连/速喜/赤口/小吉/空亡六宫游走 |
| **输出** | 六宫结果 + 吉凶判词 |
| **验收** | 算法正确，仪式感动画完整，结果可分享/复制 |

#### FR-03 周易 Zhouyi（金钱卦）

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-03 |
| **优先级** | P0 |
| **描述** | 金钱卦，三铜钱摇六爻 |
| **输入** | 用户摇卦（触摸交互 + 真随机）|
| **计算** | 6 爻阴阳 → 64 卦本卦/变卦/互卦 |
| **输出** | 卦象 + 卦辞/爻辞 + 吉凶 |
| **验收** | 64 卦数据完整，卦辞爻辞正确，金钱摇卦动效完整 |

#### FR-04 梅花易数 Meihua

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-04 |
| **优先级** | P0 |
| **描述** | 数字起卦，分体用、观生克 |
| **输入** | 数字（时间/方位/随机等）|
| **计算** | 上下卦 + 动爻 + 体用生克 |
| **输出** | 卦象 + 体用分析 + 吉凶 |
| **验收** | 起卦算法正确，体用分析清晰 |

#### FR-05 掷筊 Jiaobei

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-05 |
| **优先级** | P0 |
| **描述** | 圣杯问事 |
| **输入** | 用户掷筊（触摸 + 真随机） |
| **计算** | 圣筊/笑筊/阴筊三态 |
| **输出** | 筊杯结果 + 解读 |
| **验收** | 三态概率合理，掷筊动效完整 |

#### FR-06 紫微斗数 Ziwei

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-06 |
| **优先级** | P0 |
| **描述** | v2 全套星曜安星（14 主星 + 辅星） |
| **输入** | 生辰（农历/公历）+ 性别 |
| **计算** | 命盘 12 宫 + 14 主星 + 辅星安星 |
| **输出** | 命盘图 + 星曜解读 |
| **验收** | 安星算法对照权威工具一致，命盘绘制清晰 |

#### FR-07 奇门遁甲 Qimen

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-07 |
| **优先级** | P0 |
| **描述** | v2 四盘九宫 |
| **输入** | 时间（节气/时辰） |
| **计算** | 天盘/地盘/人盘/神盘 + 九宫 |
| **输出** | 四盘九宫图 + 解读 |
| **验收** | 四盘排布正确，九宫绘制清晰 |

#### FR-08 抽签 Chouqian

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-08 |
| **优先级** | P0 |
| **描述** | 抽签求签 |
| **输入** | 用户抽签动作（触摸 + 真随机） |
| **计算** | 签文索引 |
| **输出** | 签文 + 解读 |
| **验收** | 抽签动效完整，签文数据完整 |

#### FR-09 测字 Cezi

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-09 |
| **优先级** | P0 |
| **描述** | 字义拆解断吉凶 |
| **输入** | 用户输入汉字 |
| **计算** | 字形/字义/笔画拆解 |
| **输出** | 拆解分析 + 吉凶判词 |
| **验收** | 拆解逻辑合理，常见字覆盖完整 |

#### FR-10 大六壬 Daliuren

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-10 |
| **优先级** | P0 |
| **描述** | 四课三传全套 |
| **输入** | 时间（月将/时辰） |
| **计算** | 四课 + 三传（初传/中传/末传） |
| **输出** | 四课三传图 + 解读 |
| **验收** | 四课三传算法对照权威工具一致 |

#### FR-11 风水罗盘 Luopan

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-11 |
| **优先级** | P0 |
| **描述** | 陀螺仪/磁场实时方位 |
| **输入** | 设备传感器（陀螺仪 + 磁场） |
| **计算** | 实时方位角 + 罗盘层 |
| **输出** | 罗盘指针 + 方位解读 |
| **验收** | Android 端方位准确，不支持设备降级提示 |

#### FR-12 八字推演 Bazi

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-12 |
| **优先级** | P0 |
| **描述** | 四柱 + 大运 + 流年 + 神煞 |
| **输入** | 生辰（公历/农历）+ 性别 |
| **计算** | 年柱/月柱/日柱/时柱 + 大运 + 流年 + 神煞 |
| **输出** | 四柱八字 + 大运流年 + 神煞解读 |
| **验收** | 四柱对照 lunar 文档一致，大运起运算法正确 |

#### FR-13 测名字 NameTest

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-13 |
| **优先级** | P0 |
| **描述** | 五格剖象 |
| **输入** | 姓名 |
| **计算** | 天格/人格/地格/外格/总格 + 三才 |
| **输出** | 五格数理 + 三才 + 解读 |
| **验收** | 五格计算正确，常见姓氏笔画库完整 |

#### FR-14 使用手册 Manual

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-14 |
| **优先级** | P1 |
| **描述** | 12 术原理与操作说明 |
| **输入** | 用户浏览 |
| **输出** | 12 术分章说明 |
| **验收** | 12 术均有原理 + 操作说明 |

#### FR-15 设置 Settings

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-15 |
| **优先级** | P0 |
| **描述** | 主题切换 + 动效全局开关 + 动画细分（4 个 AnimationKind 独立控制） |
| **输入** | 用户切换 |
| **输出** | 配置持久化（shared_preferences） |
| **验收** | 主题切换生效，动效开关生效，4 个 AnimationKind 独立控制 |

#### FR-16 历史 History

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-16 |
| **优先级** | P1 |
| **描述** | 卜算历史记录 + 导出 |
| **输入** | 卜算结果自动写入 |
| **计算** | 原子读-改-写（防止快速连续卜算丢数据） |
| **输出** | 历史列表 + 导出文件 |
| **验收** | 历史记录完整，导出文件可分享 |

#### FR-17 结果分享 Share

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-17 |
| **优先级** | P1 |
| **描述** | share_plus 系统分享卜算结果 |
| **输入** | 用户点击分享 |
| **输出** | 系统分享面板 |
| **验收** | 分享内容包含结果文本，跨端可用 |

#### FR-18 真随机引擎 RNG

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | FR-18 |
| **优先级** | P0 |
| **描述** | 多源真随机引擎 |
| **输入** | 卜算过程中的触摸轨迹 + 系统熵 + random.org |
| **计算** | 多源熵 + SHA256 混合 |
| **输出** | 真随机数 |
| **验收** | 三源降级机制生效，random.org 不可达时静默降级 |

---

## 5. 非功能需求 Non-Functional Requirements

### 5.1 性能需求 Performance Requirements

| 指标 Metric | 目标 Target | 说明 Notes |
|-----------|-----------|----------|
| 冷启动 Cold Start | < 2s | 中端 Android 设备 |
| 卜算响应 Latency | < 500ms | 单次起卦到结果呈现 |
| 内存占用 Memory | < 200MB | 含 Starfield 背景动画 |
| 帧率 FPS | ≥ 60fps | 动效过程中 |
| 包体积 APK Size | < 30MB | release 构建 |

### 5.2 跨平台需求 Cross-Platform Requirements

| 需求 Requirement | 说明 Notes |
|---------------|----------|
| Android 支持 | minSdkVersion 满足主流设备 |
| Windows 桌面支持 | Windows 10/11 |
| 单代码库 Single Codebase | 跨端行为一致 |
| 平台差异处理 | 罗盘传感器在桌面端降级 |

### 5.3 动效体系需求 Motion System Requirements

| 阶段 Phase | 需求 Requirement |
|-----------|---------------|
| Phase 1 入场仪式 | Starfield + 卡片入场 |
| Phase 2 路由转场 | go_router 自定义转场 |
| Phase 3 绘制过程 | 卦象/盘面绘制动画 |
| Phase 4 结果揭示 | 结果卡片揭示动画 |
| Phase 5 按钮物理反馈 | GoldButton / DarkButton 物理反馈 |
| Phase 6 图标状态切换 | AnimatedExpandIcon + SvgIcon |
| 全局开关 | AppConfig.animationsEnabled |
| 细分控制 | 4 个 AnimationKind 独立控制 |
| 资源管理 | CustomPainter 显式 dispose TextPainter |

### 5.4 主题需求 Theme Requirements

| 需求 Requirement | 说明 Notes |
|---------------|----------|
| 主题切换 | 深色/浅色模式 |
| 主题持久化 | shared_preferences |
| 品牌色 Brand Color | Qore 品牌色系 |
| Starfield 背景 | 全局星点背景动画 |

### 5.5 真随机需求 RNG Requirements

| 需求 Requirement | 说明 Notes |
|---------------|----------|
| 多源降级 | random.org → 触摸轨迹 → Random.secure |
| 静默降级 | 不阻塞用户 |
| SHA256 混合 | 多源熵混合 |

### 5.6 隐私需求 Privacy Requirements

| 需求 Requirement | 说明 Notes |
|---------------|----------|
| 无用户数据收集 | 不收集任何用户信息 |
| 无账号系统 | 无需注册登录 |
| 本地存储 | 历史记录本地 JSON |
| 网络通信 | 仅 random.org（可选），无用户数据上传 |
| 权限最小化 | 仅传感器权限（罗盘），按需申请 |

### 5.7 质量需求 Quality Requirements

| 需求 Requirement | 目标 Target |
|---------------|----------|
| flutter analyze | 0 error / 0 warning |
| 代码风格 | 遵循 Dart Style + 项目规范 |
| 资源管理 | CustomPainter 显式 dispose TextPainter |
| 历史原子性 | HistoryStore 原子读-改-写 |
| 构建归档 | 双份历史（builds/ + build_history.json）|

### 5.8 可扩展性需求 Extensibility Requirements

| 需求 Requirement | 说明 Notes |
|---------------|----------|
| 新术接入 | ≤ 1 feature 目录 + registry 一行 |
| DivinationTech 抽象 | 卜算术统一契约 |
| feature 目录范式 | features/xxx/ 标准结构 |

---

## 6. 用户故事 User Stories

### US-01 一站式体验

**作为**一名传统文化爱好者，
**我希望**在一个 App 内体验 12 种主流术数，
**以便**我不需要在多个 App 之间切换。

**验收**：12 术均可在首页 grid 入口进入，独立完成卜算闭环。

### US-02 仪式感起卦

**作为**一名用户，
**我希望**起卦过程具有仪式感动效，
**以便**我能感受到"叩问本心"的庄重。

**验收**：每个术数均有入场/绘制/揭示动效，可通过设置页关闭。

### US-03 真随机

**作为**一名用户，
**我希望**卜算使用真随机而非伪随机，
**以便**契合"心诚则灵"的语境。

**验收**：真随机引擎三源降级，random.org 不可达时静默降级。

### US-04 算法可查证

**作为**一名术数研究者，
**我希望**排盘结果可对照权威工具复算，
**以便**验证算法正确性。

**验收**：紫微 14 主星、奇门四盘、大六壬四课三传、八字四柱均对照权威工具一致。

### US-05 桌面端排盘

**作为**一名术数研究者，
**我希望**在 Windows 桌面端进行严肃排盘，
**以便**在大屏幕上查看命盘/盘面。

**验收**：Windows 桌面构建产出，与 Android 行为一致（罗盘降级除外）。

### US-06 历史记录

**作为**一名用户，
**我希望**卜算结果自动保存为历史，
**以便**我事后查阅与导出。

**验收**：历史记录本地存储，原子读-改-写，可导出文件。

### US-07 主题与动效控制

**作为**一名用户，
**我希望**可切换主题并控制动效开关，
**以便**根据偏好调整体验。

**验收**：主题切换生效，动效全局开关生效，4 个 AnimationKind 独立控制。

### US-08 使用手册

**作为**一名初学者，
**我希望**有使用手册说明各术原理与操作，
**以便**降低认知门槛。

**验收**：12 术均有原理 + 操作说明。

### US-09 隐私保护

**作为**一名用户，
**我希望**App 不收集我的任何信息，
**以便**保护隐私。

**验收**：无账号、无数据收集、本地存储、仅 random.org 可选网络。

### US-10 结果分享

**作为**一名用户，
**我希望**能分享卜算结果给朋友，
**以便**交流讨论。

**验收**：share_plus 系统分享，跨端可用。

---

## 7. 用例 Use Cases

### UC-01 周易起卦

**主参与者**：用户
**前置条件**：App 已安装，用户在首页

**主流程 Main Flow:**
1. 用户点击"周易"入口
2. 进入周易操作页，展示金钱卦起卦引导
3. 用户点击"摇卦"按钮，触发摇卦动效
4. 真随机引擎生成 6 爻阴阳
5. 展示 6 爻动画绘制
6. 计算本卦/变卦/互卦
7. 展示卦象 + 卦辞爻辞 + 吉凶
8. 历史记录自动写入
9. 用户可分享/复制结果

**备选流程 Alternative Flow:**
- 4a. random.org 不可达 → 静默降级至触摸轨迹 + Random.secure

**后置条件**：结果已展示，历史已记录

### UC-02 紫微排盘

**主参与者**：用户
**前置条件**：App 已安装，用户在首页

**主流程 Main Flow:**
1. 用户点击"紫微斗数"入口
2. 进入紫微操作页，展示生辰输入
3. 用户输入生辰（农历/公历）+ 性别
4. lunar 计算命盘 12 宫
5. 安 14 主星 + 辅星
6. 展示命盘绘制动画
7. 展示命盘图 + 星曜解读
8. 历史记录自动写入
9. 用户可分享/复制结果

**后置条件**：命盘已展示，历史已记录

### UC-03 风水罗盘

**主参与者**：用户
**前置条件**：App 已安装，设备有陀螺仪/磁场传感器

**主流程 Main Flow:**
1. 用户点击"风水罗盘"入口
2. App 检测传感器可用性
3. 申请传感器权限
4. 启动罗盘，实时显示方位
5. 用户移动设备，罗盘指针实时响应
6. 展示方位解读

**备选流程 Alternative Flow:**
- 2a. 传感器不可用（如 Windows 桌面）→ 禁用罗盘并提示用户

**后置条件**：罗盘已展示（或降级提示）

---

## 8. 信息架构 Information Architecture

### 8.1 页面结构 Page Structure

```
JeenithApp
├── 首页 Home（Starfield + 选术 grid）
│   ├── 小六壬 → 操作页 → 结果页
│   ├── 周易 → 操作页 → 结果页
│   ├── 梅花易数 → 操作页 → 结果页
│   ├── 掷筊 → 操作页 → 结果页
│   ├── 紫微斗数 → 输入页 → 排盘页
│   ├── 奇门遁甲 → 输入页 → 排盘页
│   ├── 抽签 → 操作页 → 结果页
│   ├── 测字 → 输入页 → 结果页
│   ├── 大六壬 → 输入页 → 排盘页
│   ├── 风水罗盘 → 罗盘页
│   ├── 八字推演 → 输入页 → 排盘页
│   └── 测名字 → 输入页 → 结果页
├── 使用手册 Manual（分章列表 → 详情）
├── 设置 Settings（主题/动效/动画细分）
└── 历史 History（列表 → 详情）
```

### 8.2 导航结构 Navigation Structure

- **底部导航 / 抽屉**：首页 / 历史 / 手册 / 设置
- **路由**：go_router 声明式 + 仪式路由（起卦过程路由守卫）
- **返回**：标准 Material 返回 + 自定义转场

---

## 9. 版本规划 Version Roadmap

### 9.1 已发布 Released

| 版本 Version | 日期 Date | 核心内容 Highlights |
|-------------|---------|------------------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 术 v1 |
| 1.1.0 | 2026-07-12 | 工程迁移至 mobile/ |
| 1.2.0 | 2026-07-13 | 周易/梅花卦辞爻辞 |
| 1.3.0 | 2026-07-13 | 紫微斗数 v2 |
| 1.4.0 | 2026-07-13 | 奇门遁甲 v2 |
| 1.5.0 | 2026-07-13 | 主题切换 + 结果分享 + 历史导出 |
| 1.6.0 | 2026-07-13 | 抽签 + 测字 |
| 1.7.0 | 2026-07-13 | 大六壬 + 风水罗盘 |
| 1.8.0 | 2026-07-13 | 使用手册页面 |
| 2.0.0 | 2026-07-14 | release，体验深化与品牌定调 |
| 2.1.0 / 2.2.0 | 2026-07-14 | 动效体系 Phase 1-6 |
| 2.3.0 | 2026-07-15 | 八字推演 + 测名字 + 紫微盘重构 |
| 2.3.1-2.3.3 | 2026-07-15 | 起卦按钮修复 + 设置页动画细分 + MIT LICENSE |

### 9.2 后续规划 Future Plan

| 版本 Version | 计划内容 Planned | 优先级 Priority |
|-------------|---------------|--------------|
| 2.4.x | 思源宋体字体 + 首次使用引导遮罩 | P1 |
| 2.5.x | 主题浅色对齐 + 罗盘精度优化 | P2 |
| 3.x | 视新术需求扩展（六爻纳甲 / 铁板神数等）| P2 |

---

## 10. 验收标准 Acceptance Criteria

### 10.1 功能验收 Functional Acceptance

| 验收项 Item | 标准 Criteria | 验收方式 Method |
|-----------|-------------|---------------|
| 12 术卜算闭环 | 12 术均可独立完成起卦-结果-分享全流程 | 功能测试 |
| 真随机引擎 | 三源降级机制生效 | 网络阻断测试 |
| 动效体系 | Phase 1-6 全覆盖 + 全局开关 + 4 AnimationKind 细分 | 设计评审 |
| 主题切换 | 深/浅色切换生效 + 持久化 | 功能测试 |
| 历史记录 | 自动写入 + 原子读-改-写 + 导出 | 并发测试 |
| 使用手册 | 12 术均有原理 + 操作说明 | 内容评审 |
| 跨端一致 | Android + Windows 行为一致 | 双端对比 |

### 10.2 性能验收 Performance Acceptance

| 验收项 Item | 标准 Criteria |
|-----------|-------------|
| 冷启动 | < 2s |
| 卜算响应 | < 500ms |
| 内存占用 | < 200MB |
| 帧率 | ≥ 60fps |
| 包体积 | < 30MB |

### 10.3 质量验收 Quality Acceptance

| 验收项 Item | 标准 Criteria |
|-----------|-------------|
| flutter analyze | 0 error / 0 warning |
| CustomPainter 资源 | 显式 dispose TextPainter |
| HistoryStore 原子性 | 原子读-改-写 |
| 构建归档 | 双份历史（builds/ + build_history.json）|

### 10.4 算法验收 Algorithm Acceptance

| 验收项 Item | 标准 Criteria |
|-----------|-------------|
| 紫微 14 主星 | 对照权威排盘工具一致 |
| 奇门四盘 | 对照权威文献一致 |
| 大六壬四课三传 | 对照专业排盘软件一致 |
| 八字四柱 | 对照 lunar 文档一致 |
| 周易 64 卦 | 卦辞爻辞数据完整 |

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| DivinationTech | 卜算术抽象接口 |
| registry | 卜算术注册表 |
| lunar | 寿星天文历 Dart 库 |
| RNG | Random Number Generator，真随机引擎 |
| Starfield | 星点背景动画 |
| AnimationKind | 动画类型枚举（4 种独立控制）|
| 金钱卦 | 周易起卦法，三铜钱摇六爻 |
| 五格剖象 | 姓名学五格分析法 |
| 四课三传 | 大六壬核心结构 |
| 14 主星 | 紫微斗数主星 |

### 附录B：参考文档 Reference Documents

- 业务需求文档 BRD
- 功能规格说明书 Functional Spec
- 原型设计文档 Prototype Design
- AGENTS.md / CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

---

**文档结束 End of Document**

**重要提示:** 本 PRD 基于 2.3.3 release 的实际落地情况定稿，后续版本规划视需求迭代更新。
