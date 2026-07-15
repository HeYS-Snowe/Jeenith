# 项目章程 Project Charter

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-05 |
| 生效日期 Effective Date | 2026-07-05 |
| 项目负责人 Project Lead | HeYS-Snowe |
| 项目发起人 Project Sponsor | Qore Origins（叩心）|

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description | 审核人 Reviewer |
|-------------|---------|---------------|-------------------|---------------|
| v1.0.0 | 2026-07-05 | HeYS-Snowe | 立项初稿，确立项目定位与目标 Initiation draft | HeYS-Snowe |
| v1.1.0 | 2026-07-15 | HeYS-Snowe | 同步至 2.3.3 release，更新里程碑与版本演进 Sync to 2.3.3 release | HeYS-Snowe |

---

## 目录 Table of Contents

1. [项目概览 Project Overview](#1-项目概览-project-overview)
2. [项目目标与范围 Objectives & Scope](#2-项目目标与范围-objectives--scope)
3. [关键干系人 Stakeholders](#3-关键干系人-stakeholders)
4. [项目组织与团队 Organization](#4-项目组织与团队-organization)
5. [项目里程碑 Milestones](#5-项目里程碑-milestones)
6. [项目约束 Constraints](#6-项目约束-constraints)
7. [项目假设 Assumptions](#7-项目假设-assumptions)
8. [主要风险 Major Risks](#8-主要风险-major-risks)
9. [预算概要 Budget Summary](#9-预算概要-budget-summary)
10. [成功标准 Success Criteria](#10-成功标准-success-criteria)
11. [沟通管理 Communication Management](#11-沟通管理-communication-management)
12. [变更管理 Change Management](#12-变更管理-change-management)
13. [批准与授权 Approval & Authorization](#13-批准与授权-approval--authorization)

---

## 1. 项目概览 Project Overview

### 1.1 项目基本信息 Project Basic Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **项目名称 Project Name** | 志极（Jeenith） |
| **项目编号 Project ID** | QORE-JEENITH-001 |
| **组织 Organization** | Qore Origins（叩心）|
| **应用包名 Package Name** | `com.qore.jeenith` |
| **项目类型 Project Type** | ☑ 移动 App（Flutter，Android + Windows 桌面）|
| **项目状态 Project Status** | ☑ 进行中（已发布 release 2.3.3） |
| **开始日期 Start Date** | 2026-07-05 |
| **当前版本 Current Version** | 2.3.3+23（release，2026-07-15）|
| **GitHub 仓库 Repository** | https://github.com/1010523654/Jeenith |
| **许可证 License** | MIT |
| **版权 Copyright** | Copyright (c) 2026 Qore |

### 1.2 项目背景与意义 Background & Significance

中华术数文化源远流长，小六壬、周易、梅花易数、紫微斗数、奇门遁甲、大六壬、八字推演等术数体系承载了古人观象、推演、问事、明心的智慧。然而当前市面上的相关 App 多存在以下问题：

- **体验粗糙**：界面古板、操作流程割裂，缺乏现代审美与仪式感
- **算法杂糅**：术数算法实现不规范，缺乏天文历算等关键基础
- **真随机缺失**：多采用伪随机数，缺乏对"心诚则灵"语境下随机本源的尊重
- **功能割裂**：用户需在多个 App 间切换，缺乏统一的卜算合集体验

"志极"由 Qore（叩心）发起，定位为**叩问本心的卜算合集**，以现代、精致的 Flutter 跨端体验承载十二种主流术数，并通过可扩展的卜算框架（DivinationTech + registry）支持后续新术的快速接入，让传统术数以**叩问本心、知于极处**的精神重新进入现代人的生活。

### 1.3 项目愿景 Project Vision

**志于本心，知于极处 —— Question the core. Return to origins.**

让传统术数以现代、精致、可信赖的方式呈现于指尖；让每一次起卦、摇爻、掐指、布盘都成为叩问本心的仪式；让可扩展框架支撑更多术数的接入，成为术数爱好者的随身工具集。

---

## 2. 项目目标与范围 Objectives & Scope

### 2.1 项目目标 Project Objectives

#### 2.1.1 业务目标 Business Objectives

| 序号 ID | 业务目标 Business Objective | 衡量指标 Metric | 目标值 Target |
|--------|--------------------------|---------------|------------|
| 1 | 上线 12 种主流术数卜算功能 | 术数种类 Count | 12 种 |
| 2 | 建立可扩展卜算框架 | 新增术数接入工作量 | ≤ 1 个 feature 目录 + registry 一行 |
| 3 | 提供精致仪式感体验 | 动效体系阶段数 | Phase 1-6 全覆盖 |
| 4 | 真随机引擎落地 | 真随机来源数 | ≥ 3（Random.secure / 触摸轨迹 / random.org）|

#### 2.1.2 用户目标 User Objectives

| 用户角色 User Role | 目标需求 User Need | 优先级 Priority |
|-----------------|-----------------|---------------|
| 传统文化爱好者 | 一站式体验多种主流术数 | P0 |
| 术数研究者 | 算法实现规范、可查证、可复算 | P0 |
| 移动端用户 | 离线可用、便携、精致交互 | P0 |
| 桌面端用户 | Windows 桌面同等体验 | P1 |

#### 2.1.3 技术目标 Technical Objectives

| 技术指标 Technical Metric | 目标值 Target | 说明 Notes |
|----------------------|------------|----------|
| 启动时间 Cold Start | < 2s | 中端 Android 设备 |
| 卜算响应 Divination Latency | < 500ms | 单次起卦到结果呈现 |
| 内存占用 Memory | < 200MB | 含星点背景动画 |
| 跨平台一致性 Cross-Platform | 100% | Android + Windows 同代码库 |
| flutter analyze | 0 error / 0 warning | 发布前强制 |

### 2.2 项目范围 Project Scope

#### 2.2.1 范围内 In Scope

| 序号 ID | 功能模块/交付物 Module/Deliverable | 描述 Description |
|--------|---------------------------|----------------|
| 1 | 核心框架 Core Framework | DivinationTech 抽象 + registry 注册 + 仪式路由 |
| 2 | 小六壬 Xiaoliuren | 掐指神课，三段游走六宫断吉凶 |
| 3 | 周易 Zhouyi | 金钱卦，三铜钱摇六爻 + 卦辞爻辞 |
| 4 | 梅花易数 Meihua | 数字起卦，分体用、观生克 |
| 5 | 掷筊 Jiaobei | 圣杯问事 |
| 6 | 紫微斗数 Ziwei | v2 全套星曜安星（14 主星 + 辅星）|
| 7 | 奇门遁甲 Qimen | v2 四盘九宫 |
| 8 | 抽签 Chouqian | 抽签求签 |
| 9 | 测字 Cezi | 字义拆解断吉凶 |
| 10 | 大六壬 Daliuren | 四课三传全套 |
| 11 | 风水罗盘 Luopan | 陀螺仪/磁场实时方位 |
| 12 | 八字推演 Bazi | 四柱 + 大运 + 流年 + 神煞 |
| 13 | 测名字 NameTest | 五格剖象 |
| 14 | 使用手册 Manual | 术数原理与操作说明 |
| 15 | 设置 Settings | 主题/动效开关/动画细分 |
| 16 | 历史 History | 卜算历史记录 + 导出 |
| 17 | 真随机引擎 RNG | Random.secure + 触摸轨迹 + random.org |
| 18 | 主题与动效体系 Theme & Motion | 主题切换 + 动效 Phase 1-6 |
| 19 | 结果分享 Share | share_plus 系统分享 |
| 20 | Windows 桌面构建 | flutter build windows --release |

#### 2.2.2 范围外 Out of Scope

| 序号 ID | 明确排除的内容 Excluded Item | 原因 Reason |
|--------|--------------------------|-----------|
| 1 | 后端服务 Backend Service | 纯客户端应用，无网络依赖 |
| 2 | 用户账号系统 Account System | 隐私优先，本地存储历史 |
| 3 | iOS / macOS / Linux 构建 | 当前仅聚焦 Android + Windows |
| 4 | 付费功能 / 内购 | 开源 MIT 协议，免费提供 |
| 5 | 推送通知 / 云同步 | 无后端，不做云同步 |

### 2.3 范围管理原则 Scope Management Principles

- 所有新术接入遵循"新建 features/xxx/ + 实现 DivinationTech + registry 注册一行"的扩展范式
- 范围变更必须经开发者评估对架构与动效体系的影响
- 跨端一致性优先：任何功能须同时在 Android 与 Windows 桌面可用
- 术数算法正确性优先于视觉表现，先正确再精致

---

## 3. 关键干系人 Stakeholders

### 3.1 干系人登记表 Stakeholder Register

| 序号 ID | 干系人姓名 Name | 角色职位 Role | 利益相关度 Interest | 影响力 Influence | 沟通需求 Communication |
|--------|---------------|------------|------------------|----------------|-------------------|
| 1 | HeYS-Snowe | 唯一开发者 / 全栈 / 架构 / 维护 | 高 | 高 | 自驱 |
| 2 | Qore Origins | 项目发起组织 | 高 | 高 | 里程碑节点同步 |
| 3 | 传统文化爱好者 | 终端用户 | 高 | 中 | GitHub Issues / 反馈 |
| 4 | 术数研究者 | 终端用户 | 高 | 中 | 算法可查证性反馈 |
| 5 | 开源社区 | 观察者 / 贡献者 | 中 | 低 | PR / Issue |

### 3.2 干系人职责矩阵 Stakeholder Responsibility Matrix

| 干系人 Stakeholder | 角色 Role | 主要职责 Key Responsibilities |
|------------------|-----------|-----------------------------|
| Qore Origins | 发起组织 | 提供品牌定位与精神内核、决策支持 |
| HeYS-Snowe | 全栈开发者 | 架构设计、需求定义、编码、测试、发布、维护 |
| 术数爱好者/研究者 | 用户 | 使用反馈、算法正确性校验、Issue 上报 |

---

## 4. 项目组织与团队 Organization

### 4.1 组织结构图 Organizational Structure

```
                  Qore Origins（叩心）
                  项目发起组织 Sponsor
                          |
              HeYS-Snowe（唯一开发者）
              全栈 / 架构 / 维护 / 测试 / 发布
                          |
        ┌────────────┬────┴────┬────────────┐
    核心框架 Core  术数模块  动效体系  跨端构建
                  Features   Motion   Cross-Platform
```

### 4.2 团队成员列表 Team Members

| 序号 ID | 姓名 Name | 角色 Role | 职责 Responsibilities | 参与时间 Period |
|--------|---------|---------|---------------------|---------------|
| 1 | HeYS-Snowe | 全栈开发者 / 架构师 | 项目全周期：需求、设计、编码、测试、发布、维护 | 2026-07-05 至今 |

> 本项目为单人开发项目，所有角色职责由 HeYS-Snowe 一人承担。

### 4.3 角色与职责 Roles & Responsibilities (RACI)

| 任务活动 Task | 发起组织 Sponsor | 开发者 Developer |
|-------------|---------------|----------------|
| 需求定义 Requirements | I | A/R |
| 架构设计 Architecture | I | A/R |
| 编码实现 Development | I | A/R |
| 测试验收 Testing | I | A/R |
| 发布上线 Release | I | A/R |
| 维护迭代 Maintenance | I | A/R |

**图例 Legend:**
- **R** = Responsible 负责执行
- **A** = Accountable 最终负责
- **C** = Consulted 需要咨询
- **I** = Informed 需要知情

---

## 5. 项目里程碑 Milestones

### 5.1 里程碑计划 Milestone Schedule

| 序号 ID | 里程碑名称 Milestone | 里程碑日期 Target Date | 关键交付物 Deliverables | 负责人 Owner |
|--------|-----------------|---------------------|----------------------|------------|
| M1 | 项目立项 Initiation | 2026-07-05 | 项目章程、技术选型 | HeYS-Snowe |
| M2 | v1.0.0 首发release | 2026-07-12 | 核心框架 + 6 术 v1 | HeYS-Snowe |
| M3 | v1.2.0 卦辞爻辞 | 2026-07-13 | 周易/梅花数据补全 | HeYS-Snowe |
| M4 | v1.3.0-v1.4.0 v2 升级 | 2026-07-13 | 紫微 v2 + 奇门 v2 | HeYS-Snowe |
| M5 | v1.5.0 体验基础 | 2026-07-13 | 主题/分享/历史导出 | HeYS-Snowe |
| M6 | v1.6.0-v1.8.0 功能补全 | 2026-07-13 | 抽签/测字/大六壬/罗盘/手册 | HeYS-Snowe |
| M7 | v2.0.0 体验深化 release | 2026-07-14 | 品牌定调 + 物理反馈 | HeYS-Snowe |
| M8 | v2.1.0-v2.2.0 动效体系 | 2026-07-14 | Phase 1-6 全覆盖 | HeYS-Snowe |
| M9 | v2.3.0 术数补强 | 2026-07-15 | 八字 + 测名字 + 紫微重构 | HeYS-Snowe |
| M10 | v2.3.3 当前 release | 2026-07-15 | 起卦修复 + 动画细分 + MIT | HeYS-Snowe |

### 5.2 里程碑详细描述 Milestone Details

#### M2: v1.0.0 首发 release
- **日期 Date:** 2026-07-12
- **目标 Objective:** 完成核心框架与 6 种基础术数（小六壬/周易/梅花/掷筊/紫微/奇门），具备完整卜算闭环
- **成功标准 Success Criteria:** 6 术可独立完成起卦-结果-分享全流程，flutter analyze 0 error
- **依赖 Dependencies:** M1 完成

#### M7: v2.0.0 体验深化 release
- **日期 Date:** 2026-07-14
- **目标 Objective:** 品牌定调、按钮物理反馈、图标状态切换、动效全局开关
- **成功标准 Success Criteria:** 视觉与交互达到精致级别，品牌精神"志于本心，知于极处"贯穿全产品
- **依赖 Dependencies:** M3-M6 完成

#### M10: v2.3.3 当前 release
- **日期 Date:** 2026-07-15
- **目标 Objective:** 完成 12 术全集（八字 + 测名字补入）、起卦按钮 BUG 修复、设置页动画细分开关、MIT LICENSE
- **成功标准 Success Criteria:** 12 术全部可用，动画可细分控制，开源协议就位
- **依赖 Dependencies:** M9 完成

---

## 6. 项目约束 Constraints

### 6.1 约束条件汇总 Constraints Summary

| 约束类型 Constraint Type | 约束描述 Description | 应对措施 Mitigation |
|----------------------|------------------|------------------|
| 时间约束 Schedule | 单人开发，节奏紧凑 | 严格按版本节奏迭代，每版本聚焦核心目标 |
| 资源约束 Resources | 唯一开发者，无团队 | 自动化构建脚本 + 双份历史归档降低运维负担 |
| 技术约束 Technical | 跨端一致性要求高 | Flutter 单代码库覆盖 Android + Windows |
| 平台约束 Platform | 无后端，纯客户端 | 历史本地存储 + 离线优先 |
| 法律约束 Legal | 术数内容需合规 | MIT 协议开源，定位为传统文化工具，非迷信宣传 |
| 传感器约束 Sensor | 风水罗盘依赖陀螺仪/磁场 | sensors_plus 抽象 + 设备能力降级处理 |

### 6.2 依赖关系 Dependencies

| 依赖项 Dependency | 类型 Type | 描述 Description | 影响分析 Impact |
|----------------|---------|----------------|---------------|
| lunar（寿星天文历）| 外部 | 农历/八字/紫微/奇门/大六壬依赖 | 核心依赖，需锁版本 ^1.7.8 |
| random.org | 外部 | 真随机引擎可选项 | 失败时降级至 Random.secure |
| sensors_plus | 外部 | 风水罗盘方位 | 不支持设备禁用罗盘功能 |
| shared_preferences | 外部 | 配置持久化 | 核心依赖 |
| Flutter SDK | 外部 | Dart 3.11+ | 锁定 3.x 主线 |

---

## 7. 项目假设 Assumptions

| 序号 ID | 假设内容 Assumption | 影响分析 Impact | 验证方法 Verification |
|--------|-------------------|---------------|-------------------|
| 1 | Flutter 持续维护 Android + Windows 桌面端 | 高 | 关注 Flutter 官方 roadmap |
| 2 | lunar 库持续维护且历算准确 | 高 | 关键节气/八字用例对照 |
| 3 | 目标用户对术数有基础认知 | 中 | 使用手册覆盖原理说明 |
| 4 | 开源社区对传统文化 App 有兴趣 | 中 | GitHub Star / Issue 反馈 |
| 5 | Android 设备陀螺仪/磁场传感器普遍可用 | 中 | 罗盘功能降级处理 |

**重要提醒:** 如果假设不成立，需要重新评估项目可行性。

---

## 8. 主要风险 Major Risks

### 8.1 高优先级风险 High Priority Risks

| 风险ID Risk ID | 风险描述 Risk Description | 影响等级 Impact | 概率 Probability | 风险 owner Risk Owner |
|--------------|----------------------|---------------|---------------|-------------------|
| R001 | 术数算法实现存在错误（安星/排盘/神煞） | 高 | 中 | HeYS-Snowe |
| R002 | 风水罗盘传感器兼容性问题 | 中 | 中 | HeYS-Snowe |
| R003 | 单人开发导致进度瓶颈 | 中 | 高 | HeYS-Snowe |
| R004 | lunar 库版本升级导致历算回归 | 中 | 低 | HeYS-Snowe |
| R005 | Windows 桌面端 Flutter 支持不稳定 | 中 | 低 | HeYS-Snowe |
| R006 | 真随机引擎（random.org）网络不可用 | 低 | 高 | HeYS-Snowe |

### 8.2 风险应对计划 Risk Response Plan

| 风险 Risk | 应对策略 Strategy | 具体措施 Actions | 触发条件 Trigger |
|----------|----------------|----------------|----------------|
| R001 | 减轻 | 关键算法对照权威文献/在线排盘工具校验 | 上线前 |
| R002 | 减轻 | 传感器不可用时禁用罗盘并提示用户 | 设备能力检测失败 |
| R003 | 接受 | 严格版本节奏，优先核心目标 | 持续 |
| R004 | 减轻 | 锁定 lunar 版本，升级前回归测试 | lunar 发布新版 |
| R005 | 减轻 | 关键功能先验证 Windows 构建 | Flutter 升级前 |
| R006 | 接受 | 真随机引擎多源降级：random.org → 触摸轨迹 → Random.secure | random.org 不可达 |

---

## 9. 预算概要 Budget Summary

### 9.1 预算分配 Budget Allocation

| 类别 Category | 预算金额 Budget (¥) | 占比 Percentage |
|-------------|-------------------|---------------|
| 开发人力 Human Resources | 0（开发者自驱） | 0% |
| 开发设备 Hardware | 已有设备折旧 | - |
| 软件工具 Software | 0（开源工具链） | 0% |
| 域名/服务 Services | 0（无后端） | 0% |
| GitHub 仓库 Services | 0（免费公开仓库） | 0% |
| 应急储备 Contingency | 0 | 0% |
| **总计 Total** | **¥0** | **100%** |

> 本项目为开源个人项目，零预算运营，依赖开发者业余时间投入与开源工具链。

### 9.2 预算授权 Budget Authorization

| 授权级别 Authorization Level | 授权金额 Limit | 说明 Notes |
|--------------------------|-------------|----------|
| 开发者 Developer | ¥0 | 个人项目，无预算支出 |
| 发起组织 Sponsor | ¥0 | 不涉及资金投入 |

---

## 10. 成功标准 Success Criteria

### 10.1 项目成功标准 Project Success Criteria

| 类别 Category | 成功标准 Success Criteria | 衡量方式 Measurement |
|-------------|-------------------------|-------------------|
| 功能完整 Functionality | 12 术全部上线且可独立完成卜算闭环 | 功能测试 |
| 框架可扩展 Extensibility | 新增术数 ≤ 1 feature 目录 + registry 一行 | 接入测试 |
| 体验精致 Experience | 动效 Phase 1-6 全覆盖 + 仪式感达标 | 设计评审 |
| 跨端一致 Cross-Platform | Android + Windows 行为一致 | 双端对比 |
| 算法正确 Algorithm | 关键排盘/安星对照权威工具一致 | 算法校验 |
| 开源规范 Open Source | MIT LICENSE + 公开仓库 + 文档完整 | 仓库评审 |
| 质量达标 Quality | flutter analyze 0 error / 0 warning | 静态分析 |

### 10.2 验收标准 Acceptance Criteria

| 验收项 Item | 标准 Criteria | 验收方式 Method |
|-----------|-------------|---------------|
| 功能完成度 Feature Completion | 12 术 + 手册 + 设置 + 历史 全部上线 | 功能测试 |
| 缺陷密度 Defect Density | 发布前 0 critical / 0 major | 手工测试 + 静态分析 |
| 性能指标 Performance | 启动 < 2s，单次卜算 < 500ms | 性能测试 |
| 文档完整性 Documentation | 项目文档 + 使用手册完整 | 文档评审 |
| 双端构建 Builds | Android APK + Windows ZIP 均产出 | 构建脚本验证 |

---

## 11. 沟通管理 Communication Management

### 11.1 沟通计划 Communication Plan

| 会议/报告 Meeting/Report | 频率 Frequency | 参与人 Participants | 时长 Duration |
|-----------------------|--------------|------------------|-------------|
| 版本迭代评审 Release Review | 每版本 As Needed | HeYS-Snowe | 30 分钟 |
| GitHub Issue 响应 Issue Triage | 按需 As Needed | HeYS-Snowe | - |
| 里程碑同步 Milestone Sync | 每里程碑 At Milestone | HeYS-Snowe + Qore | 30 分钟 |
| 构建归档 Build Archive | 每构建 Per Build | 自动化脚本 | - |

### 11.2 沟通工具 Communication Tools

| 用途 Purpose | 工具 Tool |
|-----------|---------|
| 代码托管 Code Hosting | GitHub |
| 问题追踪 Issue Tracking | GitHub Issues |
| 文档协作 Docs | 本地 Markdown + 项目 docs/ |
| 任务管理 Task | 本地 todo / AGENTS.md / CLAUDE.md |
| 构建归档 Build Archive | builds/ + build_history.json |

---

## 12. 变更管理 Change Management

### 12.1 变更控制流程 Change Control Process

```
变更请求提交 → 影响分析（架构/动效/跨端）→ 评审决策 → 实施 → 验证 → 归档
Change Request → Impact Analysis → Decision → Implement → Verify → Archive
```

### 12.2 变更控制委员会 Change Control Board (CCB)

| 成员 Member | 角色 Role | 职责 Responsibility |
|-----------|---------|-------------------|
| HeYS-Snowe | 开发者 | 变更评审与决策 |
| Qore Origins | 发起组织 | 品牌与方向相关变更的最终确认 |

---

## 13. 批准与授权 Approval & Authorization

### 13.1 项目章程批准 Charter Approval

本人确认并同意以上项目章程内容，并授权项目启动。

I confirm and agree to the contents of this Project Charter and authorize the project initiation.

| 角色 Role | 姓名 Name | 签名 Signature | 日期 Date |
|----------|---------|--------------|---------|
| 项目发起人 Project Sponsor | Qore Origins | - | 2026-07-05 |
| 项目负责人 Project Lead | HeYS-Snowe | - | 2026-07-05 |

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| DivinationTech | 卜算术抽象接口，所有术数模块实现的统一契约 |
| registry | 卜算术注册表，新术接入的统一入口 |
| lunar | 寿星天文历 Dart 库，提供农历/节气/八字等历算 |
| RNG | Random Number Generator，真随机引擎 |
| 小六壬 | 掐指神课，三段游走六宫断吉凶 |
| 金钱卦 | 周易起卦法，三铜钱摇六爻 |
| 紫微斗数 | 以紫微星为首的命理推演术 |
| 奇门遁甲 | 四盘九宫时空推演术 |
| 大六壬 | 四课三传式占术 |
| 五格剖象 | 姓名学五格（天/人/地/外/总）分析法 |

### 附录B：参考文档 Reference Documents

- AGENTS.md（项目根目录）
- CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md（构建规范）
- docs/NEXT_PLAN/（后续规划）
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

### 附录C：版本演进 Version Evolution

| 版本 Version | 日期 Date | 核心内容 Highlights |
|-------------|---------|------------------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 术 v1 |
| 1.1.0 | 2026-07-12 | 工程迁移至 mobile/ 子目录 |
| 1.2.0 | 2026-07-13 | 周易/梅花卦辞爻辞数据 |
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

---

**文档结束 End of Document**

**重要提示:** 本章程一经签署，即成为项目执行的正式依据。任何变更必须经过正式的变更控制流程。
