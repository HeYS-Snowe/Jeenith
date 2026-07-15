# 业务需求文档 BRD Business Requirements Document

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
| v1.0.0 | 2026-07-05 | HeYS-Snowe | BRD 初稿 Initial BRD |
| v2.3.3 | 2026-07-15 | HeYS-Snowe | 同步当前 release，定稿 |

---

## 目录 Table of Contents

1. [业务背景 Business Background](#1-业务背景-business-background)
2. [业务目标 Business Objectives](#2-业务目标-business-objectives)
3. [业务需求 Business Requirements](#3-业务需求-business-requirements)
4. [业务流程 Business Process](#4-业务流程-business-process)
5. [业务规则 Business Rules](#5-业务规则-business-rules)
6. [业务范围 Business Scope](#6-业务范围-business-scope)
7. [干系人分析 Stakeholder Analysis](#7-干系人分析-stakeholder-analysis)
8. [业务约束 Business Constraints](#8-业务约束-business-constraints)
9. [业务风险 Business Risks](#9-业务风险-business-risks)
10. [成功标准 Success Criteria](#10-成功标准-success-criteria)

---

## 1. 业务背景 Business Background

### 1.1 行业背景 Industry Background

中华术数文化是东方文明的重要组成部分，历经数千年沉淀，形成了以小六壬、周易、梅花易数、紫微斗数、奇门遁甲、大六壬、八字推演等为代表的完整推演体系。这些术数不仅是观象问事的工具，更是古人思考"天人关系"的智慧结晶，承载着"叩问本心、明察事理"的文化内核。

随着移动端与桌面端技术的发展，传统术数的数字化呈现迎来新机遇：

- **跨端体验**：Flutter 等跨端框架可让单代码库覆盖 Android + Windows 桌面，实现体验一致
- **历算基础**：lunar（寿星天文历）等成熟库提供准确的农历/节气/八字/紫微/奇门/大六壬历算基础
- **真随机引擎**：dart:math Random.secure + 触摸轨迹 + random.org 多源真随机在移动端可落地
- **动效体系**：Flutter 动效能力可支撑仪式感设计的实现
- **开源生态**：MIT 协议开源降低了传统文化应用的传播与协作门槛

### 1.2 现状问题 Current Issues

当前市面上的术数 App 普遍存在以下问题：

| 问题 Issue | 描述 Description |
|----------|---------------|
| 体验粗糙 | 界面古板、操作流程割裂，缺乏现代审美与仪式感 |
| 算法杂糅 | 术数算法实现不规范，缺乏天文历算等关键基础 |
| 真随机缺失 | 多采用伪随机数，缺乏对"心诚则灵"语境下随机本源的尊重 |
| 功能割裂 | 用户需在多个 App 间切换，缺乏统一的卜算合集体验 |
| 桌面端缺位 | 研究者难以在 PC 上进行严肃的排盘与推演 |
| 闭源封闭 | 多数术数 App 闭源，难以查证算法实现 |

### 1.3 业务机会 Business Opportunity

- **合集机会**：12 术统一入口，一站式体验
- **体验机会**：仪式感动效 + 精致交互，差异化竞争
- **算法机会**：lunar 天文历 + 权威文献对照，建立可信度
- **随机机会**：多源真随机引擎，契合"心诚则灵"
- **桌面机会**：Windows 桌面同等体验，覆盖研究者
- **开源机会**：MIT 协议开源，扩大影响力

---

## 2. 业务目标 Business Objectives

### 2.1 战略目标 Strategic Objectives

| 序号 ID | 战略目标 Strategic Objective | 描述 Description |
|--------|--------------------------|---------------|
| 1 | 文化传承 | 活化传承中华术数文化，以现代体验重新进入大众视野 |
| 2 | 品牌建设 | 树立 Qore Origins 在传统文化数字化领域的品牌形象 |
| 3 | 技术沉淀 | 沉淀 Flutter 跨端 + 动效体系 + 可扩展框架的工程范式 |
| 4 | 开源贡献 | 以 MIT 协议回馈传统文化与 Flutter 社区 |

### 2.2 业务目标 Business Objectives

| 序号 ID | 业务目标 Business Objective | 衡量指标 Metric | 目标值 Target |
|--------|--------------------------|---------------|------------|
| 1 | 上线 12 种主流术数卜算功能 | 术数种类 Count | 12 种 |
| 2 | 建立可扩展卜算框架 | 新术接入工作量 | ≤ 1 feature 目录 + registry 一行 |
| 3 | 提供精致仪式感体验 | 动效体系阶段数 | Phase 1-6 全覆盖 |
| 4 | 真随机引擎落地 | 真随机来源数 | ≥ 3（Random.secure / 触摸轨迹 / random.org） |
| 5 | 跨端一致 | 平台数 | Android + Windows |
| 6 | 开源运营 | 协议 + 仓库 | MIT + GitHub 公开 |
| 7 | 算法可信 | 算法对照 | 关键排盘对照权威工具一致 |

### 2.3 用户目标 User Objectives

| 用户角色 User Role | 目标需求 User Need | 优先级 Priority |
|-----------------|-----------------|---------------|
| 传统文化爱好者 | 一站式体验多种主流术数 | P0 |
| 术数研究者 | 算法实现规范、可查证、可复算 | P0 |
| 移动端用户 | 离线可用、便携、精致交互 | P0 |
| 桌面端用户 | Windows 桌面同等体验 | P1 |
| 技术观察者 | 学习 Flutter 跨端 + 动效 + 可扩展框架 | P2 |

### 2.4 品牌目标 Brand Objectives

践行"志于本心，知于极处 —— Question the core. Return to origins."的品牌精神：

- **志于本心**：每一次起卦、摇爻、掐指、布盘都是叩问本心的仪式
- **知于极处**：算法规范、真随机引擎、精致体验，知其极致

---

## 3. 业务需求 Business Requirements

### 3.1 核心业务需求 Core Business Requirements

#### BR-01 12 术合集

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-01 |
| **优先级** | P0 |
| **业务描述** | 提供小六壬、周易（金钱卦）、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字等 12 种主流术数的卜算功能 |
| **业务价值** | 一站式体验，避免用户多 App 切换 |
| **来源** | 画像 A 传统文化爱好者 |

#### BR-02 仪式感体验

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-02 |
| **优先级** | P0 |
| **业务描述** | 起卦、摇爻、掐指、布盘等过程具有仪式感动效（Phase 1-6） |
| **业务价值** | 差异化竞争，契合"叩问本心"语境 |
| **来源** | 画像 A 传统文化爱好者 |

#### BR-03 真随机引擎

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-03 |
| **优先级** | P0 |
| **业务描述** | 卜算使用多源真随机引擎（random.org / 触摸轨迹 / Random.secure），多源降级 |
| **业务价值** | 契合"心诚则灵"语境，提升可信度 |
| **来源** | 画像 A/B |

#### BR-04 算法规范可查证

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-04 |
| **优先级** | P0 |
| **业务描述** | 术数算法基于 lunar 天文历，关键排盘对照权威工具一致 |
| **业务价值** | 建立研究者可信度，支撑学术辅助定位 |
| **来源** | 画像 B 术数研究者 |

#### BR-05 跨端一致

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-05 |
| **优先级** | P0 |
| **业务描述** | Android + Windows 桌面行为一致（罗盘传感器除外） |
| **业务价值** | 覆盖移动端 + 桌面端研究者 |
| **来源** | 画像 B 术数研究者 |

#### BR-06 可扩展框架

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-06 |
| **优先级** | P0 |
| **业务描述** | DivinationTech + registry 框架，新术接入 ≤ 1 feature 目录 + 一行注册 |
| **业务价值** | 支撑后续新术快速接入，降低维护成本 |
| **来源** | 战略目标 |

#### BR-07 隐私优先

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-07 |
| **优先级** | P0 |
| **业务描述** | 无账号、无数据收集、本地存储、仅 random.org 可选网络 |
| **业务价值** | 符合隐私偏好，降低合规风险 |
| **来源** | 画像 A/B |

#### BR-08 历史记录与导出

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-08 |
| **优先级** | P1 |
| **业务描述** | 卜算结果自动保存为历史，可导出文件 |
| **业务价值** | 便于事后查阅与分享 |
| **来源** | 画像 A/B |

#### BR-09 使用手册

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-09 |
| **优先级** | P1 |
| **业务描述** | 12 术原理与操作说明 |
| **业务价值** | 降低用户认知门槛，强调文化属性 |
| **来源** | 画像 A/B |

#### BR-10 主题与动效控制

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-10 |
| **优先级** | P0 |
| **业务描述** | 主题切换 + 动效全局开关 + 4 个 AnimationKind 独立控制 |
| **业务价值** | 适应用户偏好，无障碍友好 |
| **来源** | 画像 A |

#### BR-11 结果分享

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-11 |
| **优先级** | P1 |
| **业务描述** | share_plus 系统分享卜算结果 |
| **业务价值** | 便于交流讨论，扩大传播 |
| **来源** | 画像 A |

#### BR-12 开源运营

| 项 Item | 内容 Content |
|-------|-----------|
| **需求ID** | BR-12 |
| **优先级** | P1 |
| **业务描述** | MIT 协议开源，GitHub 公开仓库 |
| **业务价值** | 回馈社区，扩大品牌影响力 |
| **来源** | 战略目标 |

### 3.2 业务需求优先级矩阵 Priority Matrix

| 优先级 Priority | 需求 Requirements |
|-------------|----------------|
| P0 | BR-01 12 术合集 / BR-02 仪式感 / BR-03 真随机 / BR-04 算法规范 / BR-05 跨端一致 / BR-06 可扩展框架 / BR-07 隐私优先 / BR-10 主题动效控制 |
| P1 | BR-08 历史记录 / BR-09 使用手册 / BR-11 结果分享 / BR-12 开源运营 |
| P2 | - |

---

## 4. 业务流程 Business Process

### 4.1 核心业务流程 Core Business Process

#### 4.1.1 卜算流程 Divination Flow

```
用户打开 App
    ↓
首页选术 grid（Starfield 背景）
    ↓
点击某术数入口
    ↓
进入术数操作页
    ↓
[输入类] 用户输入生辰/姓名/字 → lunar/算法计算
[起卦类] 用户起卦动作 → 真随机引擎生成 → 算法计算
    ↓
绘制过程动效（Phase 3）
    ↓
结果揭示动效（Phase 4）
    ↓
展示结果（卦象/盘面/判词）
    ↓
历史记录自动写入（原子读-改-写）
    ↓
用户可分享/复制/返回
```

#### 4.1.2 罗盘流程 Luopan Flow

```
用户打开 App
    ↓
点击"风水罗盘"入口
    ↓
App 检测传感器可用性
    ↓
[可用] 申请权限 → 启动罗盘 → 实时方位
[不可用] 禁用罗盘 → 提示用户
```

#### 4.1.3 设置流程 Settings Flow

```
用户打开设置页
    ↓
切换主题 / 动效开关 / AnimationKind 细分
    ↓
配置持久化（shared_preferences）
    ↓
全局生效
```

#### 4.1.4 历史流程 History Flow

```
用户打开历史页
    ↓
展示卜算历史列表
    ↓
点击某条历史 → 查看详情
    ↓
用户可导出 / 删除
```

### 4.2 业务流程图 Business Flow Diagram

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  首页   │ →  │  选术   │ →  │  操作   │ →  │  计算   │
│ Home    │    │ Select  │    │ Operate │    │ Compute │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
                                                   ↓
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  分享   │ ←  │  历史   │ ←  │  揭示   │ ←  │  绘制   │
│ Share   │    │ History │    │ Reveal  │    │  Draw   │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
```

---

## 5. 业务规则 Business Rules

### 5.1 卜算规则 Divination Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| DR-01 | 卜算随机源必须为真随机（多源降级），不得使用伪随机 |
| DR-02 | 真随机引擎降级顺序：random.org → 触摸轨迹 → Random.secure |
| DR-03 | random.org 不可达时静默降级，不阻塞用户 |
| DR-04 | 卜算结果必须自动写入历史记录 |
| DR-05 | 历史记录写入必须使用原子读-改-写 |
| DR-06 | 罗盘功能在传感器不可用时必须降级提示 |

### 5.2 算法规则 Algorithm Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| AR-01 | 历算必须基于 lunar（寿星天文历） |
| AR-02 | 紫微斗数安星必须对照权威排盘工具校验 |
| AR-03 | 奇门遁甲四盘排布必须对照权威文献校验 |
| AR-04 | 大六壬四课三传必须对照专业排盘软件校验 |
| AR-05 | 八字四柱必须对照 lunar 文档校验 |
| AR-06 | 周易 64 卦卦辞爻辞数据必须完整 |

### 5.3 体验规则 Experience Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| ER-01 | 动效必须统一封装在 core/theme/animations.dart |
| ER-02 | 所有动效可通过设置页全局开关（AppConfig.animationsEnabled） |
| ER-03 | 4 个 AnimationKind 必须独立控制 |
| ER-04 | CustomPainter 必须显式 dispose TextPainter |
| ER-05 | Starfield 背景动效全局呈现 |

### 5.4 隐私规则 Privacy Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| PR-01 | 不收集任何用户信息 |
| PR-02 | 无账号系统 |
| PR-03 | 历史记录本地存储 |
| PR-04 | 仅 random.org 可选网络通信，无用户数据上传 |
| PR-05 | 权限最小化，仅传感器权限按需申请 |

### 5.5 扩展规则 Extensibility Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| XR-01 | 新术接入必须遵循 features/xxx/ 目录范式 |
| XR-02 | 新术必须实现 DivinationTech 抽象 |
| XR-03 | 新术必须在 registry 注册一行 |
| XR-04 | 新术必须同时在 Android + Windows 可用 |

### 5.6 构建规则 Build Rules

| 规则ID Rule ID | 规则描述 Rule Description |
|-------------|------------------------|
| BR-01 | 发布前 flutter analyze 必须 0 error / 0 warning |
| BR-02 | 构建必须通过 scripts/build_apk.ps1 |
| BR-03 | 构建产物必须双份归档（builds/ + build_history.json） |
| BR-04 | 版本号 + 归档 + 历史自动 |

---

## 6. 业务范围 Business Scope

### 6.1 范围内 In Scope

- 12 种主流术数卜算功能
- 核心框架（DivinationTech + registry + 仪式路由）
- 真随机引擎（多源降级）
- 动效体系 Phase 1-6
- 主题与设置（主题切换 + 动效开关 + 动画细分）
- 历史记录与导出
- 结果分享
- 使用手册
- 双端构建（Android APK + Windows ZIP）
- 双份历史归档
- MIT 协议开源

### 6.2 范围外 Out of Scope

- 后端服务 / 用户账号系统 / 云同步
- iOS / macOS / Linux 构建
- 付费功能 / 内购 / 广告
- 推送通知 / 第三方 SDK 接入
- 实时多人协作 / 社交功能
- 应用市场强上架（GitHub 为主渠道）

### 6.3 范围管理原则 Scope Management Principles

- 新术接入遵循 features/xxx/ + DivinationTech + registry 范式
- 范围变更必须评估对架构与动效体系的影响
- 跨端一致性优先
- 算法正确性优先于视觉表现

---

## 7. 干系人分析 Stakeholder Analysis

### 7.1 干系人登记 Stakeholder Register

| 序号 ID | 干系人 Stakeholder | 角色 Role | 利益 Interest | 影响 Influence | 期望 Expectation |
|--------|----------------|---------|------------|-------------|--------------|
| 1 | HeYS-Snowe | 唯一开发者 | 高 | 高 | 项目成功落地 |
| 2 | Qore Origins | 发起组织 | 高 | 高 | 品牌建设 + 文化传承 |
| 3 | 传统文化爱好者 | 终端用户 | 高 | 中 | 一站式 + 仪式感 |
| 4 | 术数研究者 | 终端用户 | 高 | 中 | 算法规范 + 可查证 |
| 5 | 技术观察者 | 观察者 | 中 | 低 | 工程范本 |
| 6 | 开源社区 | 贡献者 | 中 | 低 | PR / Issue |

### 7.2 干系人沟通计划 Communication Plan

| 干系人 Stakeholder | 沟通方式 Method | 频率 Frequency |
|----------------|-------------|-------------|
| HeYS-Snowe | 自驱 | 持续 |
| Qore Origins | 里程碑同步 | 每里程碑 |
| 用户 / 社区 | GitHub Issues | 按需 |

---

## 8. 业务约束 Business Constraints

### 8.1 约束清单 Constraint List

| 约束类型 Constraint Type | 约束描述 Description | 应对措施 Mitigation |
|----------------------|------------------|------------------|
| 时间约束 Schedule | 单人开发，节奏紧凑 | 严格按版本节奏迭代 |
| 资源约束 Resources | 唯一开发者，无团队 | 自动化构建 + 双份归档 |
| 技术约束 Technical | 跨端一致性要求高 | Flutter 单代码库 |
| 平台约束 Platform | 无后端，纯客户端 | 本地存储 + 离线优先 |
| 法律约束 Legal | 术数内容需合规 | MIT 协议 + 传统文化工具定位 |
| 传感器约束 Sensor | 风水罗盘依赖陀螺仪/磁场 | sensors_plus 抽象 + 降级 |
| 预算约束 Budget | 零预算开源项目 | 全开源工具链 |

### 8.2 依赖关系 Dependencies

| 依赖项 Dependency | 类型 Type | 描述 Description |
|----------------|---------|----------------|
| lunar | 外部 | 寿星天文历，历算核心依赖 |
| random.org | 外部 | 真随机源（可选） |
| sensors_plus | 外部 | 风水罗盘传感器 |
| shared_preferences | 外部 | 配置持久化 |
| Flutter SDK | 外部 | Dart 3.11+ |

---

## 9. 业务风险 Business Risks

### 9.1 风险矩阵 Risk Matrix

| 风险ID Risk ID | 风险描述 Risk Description | 影响 Impact | 概率 Probability | 等级 Level | 应对 Strategy |
|--------------|----------------------|-----------|---------------|---------|-------------|
| R001 | 术数算法实现错误 | 高 | 中 | 高 | 对照权威文献/在线排盘工具校验 |
| R002 | 风水罗盘传感器兼容性 | 中 | 中 | 中 | sensors_plus 抽象 + 降级 |
| R003 | 单人开发进度瓶颈 | 中 | 高 | 高 | 严格版本节奏 |
| R004 | lunar 库版本升级导致历算回归 | 中 | 低 | 低 | 锁定版本，回归测试 |
| R005 | Windows 桌面 Flutter 支持不稳定 | 中 | 低 | 低 | 先验证 Windows 构建 |
| R006 | random.org 网络不可用 | 低 | 高 | 中 | 真随机多源降级 |
| R007 | 术数内容合规风险 | 高 | 低 | 中 | MIT + 传统文化工具定位 |
| R008 | Flutter 升级破坏性变更 | 中 | 中 | 中 | 锁定 3.x 主线 |
| R009 | 开源项目可持续性 | 中 | 中 | 中 | 开发者自驱 + 社区贡献 |
| R010 | 用户认知门槛 | 中 | 中 | 中 | 使用手册 + 引导 |

### 9.2 风险应对详情 Risk Response Details

详见可行性分析报告 §8.2。

---

## 10. 成功标准 Success Criteria

### 10.1 业务成功标准 Business Success Criteria

| 类别 Category | 成功标准 Success Criteria | 衡量方式 Measurement |
|-------------|-------------------------|-------------------|
| 功能完整 Functionality | 12 术全部上线且可独立完成卜算闭环 | 功能测试 |
| 框架可扩展 Extensibility | 新增术数 ≤ 1 feature 目录 + registry 一行 | 接入测试 |
| 体验精致 Experience | 动效 Phase 1-6 全覆盖 + 仪式感达标 | 设计评审 |
| 跨端一致 Cross-Platform | Android + Windows 行为一致 | 双端对比 |
| 算法正确 Algorithm | 关键排盘/安星对照权威工具一致 | 算法校验 |
| 开源规范 Open Source | MIT LICENSE + 公开仓库 + 文档完整 | 仓库评审 |
| 质量达标 Quality | flutter analyze 0 error / 0 warning | 静态分析 |
| 隐私合规 Privacy | 不收集用户信息，本地存储 | 隐私评审 |

### 10.2 验收标准 Acceptance Criteria

| 验收项 Item | 标准 Criteria | 验收方式 Method |
|-----------|-------------|---------------|
| 功能完成度 | 12 术 + 手册 + 设置 + 历史 全部上线 | 功能测试 |
| 缺陷密度 | 发布前 0 critical / 0 major | 手工测试 + 静态分析 |
| 性能指标 | 启动 < 2s，单次卜算 < 500ms | 性能测试 |
| 文档完整性 | 项目文档 + 使用手册完整 | 文档评审 |
| 双端构建 | Android APK + Windows ZIP 均产出 | 构建脚本验证 |

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
| 12 术 | 小六壬/周易/梅花/掷筊/紫微/奇门/抽签/测字/大六壬/罗盘/八字/测名字 |
| Qore | 叩心，发起组织简称 |

### 附录B：参考文档 Reference Documents

- 产品需求文档 PRD
- 功能规格说明书 Functional Spec
- 原型设计文档 Prototype Design
- AGENTS.md / CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

---

**文档结束 End of Document**

**重要提示:** 本 BRD 基于 2.3.3 release 的实际落地情况定稿，业务需求变更须重新评审。
