# 项目章程 Project Charter

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v0.1.0（初期草稿） |
| 创建日期 Created Date | 2026-07-05 |
| 生效日期 Effective Date | 待定 |
| 项目经理 Project Manager | 待定 |
| 项目发起人 Project Sponsor | 待定 |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description | 审核人 Reviewer |
|-------------|---------|---------------|-------------------|---------------|
| v0.1.0 | 2026-07-05 | 待定 | 初始版本，填写项目初期信息 Initial info filled | |

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

---

## 1. 项目概览 Project Overview

### 1.1 项目基本信息 Project Basic Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **项目名称 Project Name** | 校卫哨兵（Campus Sentinel） |
| **项目编号 Project ID** | 待定 |
| **项目类型 Project Type** | ☑ 移动App（手机端，Flutter） |
| **项目状态 Project Status** | ☑ 筹备中 |
| **开始日期 Start Date** | 2026-07-05 |
| **结束日期 End Date** | 待定 |
| **项目工期 Duration** | 待定 |

### 1.2 项目背景与意义 Background & Significance

校园安全是学校管理的重中之重。当前校园监控以事后查证为主，对打架斗殴、翻墙、危险攀爬、火情、异常聚集等行为的发现与响应存在明显滞后。"校卫哨兵"通过 AI 实时识别危险行为，并以移动端 APP 将预警秒级推送至一线安保与管理者，变被动监控为主动预警，缩短响应时间，降低安全事故影响。

### 1.3 项目愿景 Project Vision

让每一处校园监控都具备"主动发现危险"的能力，让每一位安保人员都随身携带一个"智能哨兵"，实现校园安全事件的秒级发现、触达与处置。

---

## 2. 项目目标与范围 Objectives & Scope

### 2.1 项目目标 Project Objectives

#### 2.1.1 业务目标 Business Objectives

| 序号 ID | 业务目标 Business Objective | 衡量指标 Metric | 目标值 Target |
|--------|--------------------------|---------------|------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

#### 2.1.2 用户目标 User Objectives

| 用户角色 User Role | 目标需求 User Need | 优先级 Priority |
|-----------------|-----------------|---------------|
| | | P0/P1/P2 |
| | | P0/P1/P2 |

#### 2.1.3 技术目标 Technical Objectives

| 技术指标 Technical Metric | 目标值 Target | 说明 Notes |
|----------------------|------------|----------|
| 响应时间 Response Time | < ms | |
| 并发用户 Concurrent Users | | |
| 可用性 Availability | % | |
| | | |

### 2.2 项目范围 Project Scope

#### 2.2.1 范围内 In Scope

| 序号 ID | 功能模块/交付物 Module/Deliverable | 描述 Description |
|--------|---------------------------|----------------|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |
| 5 | | |

#### 2.2.2 范围外 Out of Scope

| 序号 ID | 明确排除的内容 Excluded Item | 原因 Reason |
|--------|--------------------------|-----------|
| 1 | | |
| 2 | | |

### 2.3 范围管理原则 Scope Management Principles

<!-- 定义如何处理范围变更请求 -->

- 所有范围变更必须经过评审和批准
- 变更影响分析必须包含对时间、成本、质量的影响

---

## 3. 关键干系人 Stakeholders

### 3.1 干系人登记表 Stakeholder Register

| 序号 ID | 干系人姓名 Name | 角色职位 Role | 利益相关度 Interest | 影响力 Influence | 沟通需求 Communication |
|--------|---------------|------------|------------------|----------------|-------------------|
| 1 | | | 高/中/低 | 高/中/低 | |
| 2 | | | 高/中/低 | 高/中/低 | |
| 3 | | | 高/中/低 | 高/中/低 | |

### 3.2 干系人职责矩阵 Stakeholder Responsibility Matrix

| 干系人 Stakeholder | 角色 Role | 主要职责 Key Responsibilities |
|------------------|-----------|-----------------------------|
| 项目发起人 Sponsor | | 提供资源、决策支持、问题升级 |
| 项目经理 PM | | 项目管理、团队协调、进度控制 |
| 产品负责人 PO | | 需求定义、优先级排序、验收 |
| 技术负责人 Tech Lead | | 技术决策、架构设计、代码审查 |
| | | |

---

## 4. 项目组织与团队 Organization

### 4.1 组织结构图 Organizational Structure

```
                    项目发起人 Project Sponsor
                             |
                    项目经理 Project Manager
                             |
        ┌────────────┬────────┴────────┬────────────┐
    产品负责人 PO  技术负责人 Tech Lead  测试负责人 QA  设计师 Designer
        │             │                 │
    ┌───┴───┐     ┌───┴───┐         ┌───┴───┐
  前端开发 后端开发  前端开发 后端开发   测试工程师
```

### 4.2 团队成员列表 Team Members

| 序号 ID | 姓名 Name | 角色 Role | 职责 Responsibilities | 参与时间 Period |
|--------|---------|---------|---------------------|---------------|
| 1 | | 项目经理 PM | | |
| 2 | | 前端开发 Frontend | | |
| 3 | | 后端开发 Backend | | |
| 4 | | 设计师 Designer | | |
| 5 | | 测试工程师 QA | | |

### 4.3 角色与职责 Roles & Responsibilities (RACI)

| 任务活动 Task | 项目经理 PM | 产品负责人 PO | 技术负责人 Tech Lead | 开发团队 Dev | 测试团队 QA |
|-------------|-----------|-------------|-------------------|------------|-----------|
| 需求定义 Requirements | A/R | C/A | I | C | I |
| 架构设计 Architecture | A | I | R/C | C | I |
| 开发编码 Development | A | I | C | R | I |
| 测试验收 Testing | A | I | C | I | R |
| 部署上线 Deployment | A | I | R/C | C | I |

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
| M1 | 项目启动 Kickoff | | 项目章程、团队组建 | PM |
| M2 | 需求确认 Requirements Sign-off | | PRD文档 | PO |
| M3 | 设计评审 Design Review | | 设计文档 | Tech Lead |
| M4 | 开发完成 Code Complete | | 功能代码 | Dev Team |
| M5 | 测试完成 Testing Complete | | 测试报告 | QA |
| M6 | 产品上线 Launch | | 发布版本 | All |

### 5.2 里程碑详细描述 Milestone Details

#### M1: 项目启动 Project Kickoff
- **日期 Date:**
- **目标 Objective:**
- **成功标准 Success Criteria:**
- **依赖 Dependencies:**

#### M2: 需求确认 Requirements Sign-off
- **日期 Date:**
- **目标 Objective:**
- **成功标准 Success Criteria:**
- **依赖 Dependencies:** M1完成

<!-- 其他里程碑以此类推 -->

---

## 6. 项目约束 Constraints

### 6.1 约束条件汇总 Constraints Summary

| 约束类型 Constraint Type | 约束描述 Description | 应对措施 Mitigation |
|----------------------|------------------|------------------|
| 时间约束 Schedule | | |
| 预算约束 Budget | | |
| 资源约束 Resources | | |
| 技术约束 Technical | | |
| 政策约束 Policy | | |

### 6.2 依赖关系 Dependencies

| 依赖项 Dependency | 类型 Type | 描述 Description | 影响分析 Impact |
|----------------|---------|----------------|---------------|
| | 内部/外部 | | |
| | 内部/外部 | | |

---

## 7. 项目假设 Assumptions

| 序号 ID | 假设内容 Assumption | 影响分析 Impact | 验证方法 Verification |
|--------|-------------------|---------------|-------------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

**重要提醒:** 如果假设不成立，需要重新评估项目可行性

---

## 8. 主要风险 Major Risks

### 8.1 高优先级风险 High Priority Risks

| 风险ID Risk ID | 风险描述 Risk Description | 影响等级 Impact | 概率 Probability | 风险 owner Risk Owner |
|--------------|----------------------|---------------|---------------|-------------------|
| R001 | | 高/中/低 | 高/中/低 | |
| R002 | | 高/中/低 | 高/中/低 | |
| R003 | | 高/中/低 | 高/中/低 | |

### 8.2 风险应对计划 Risk Response Plan

| 风险 Risk | 应对策略 Strategy | 具体措施 Actions | 触发条件 Trigger |
|----------|----------------|----------------|----------------|
| R001 | 规避/减轻/接受/转移 | | |
| R002 | 规避/减轻/接受/转移 | | |

---

## 9. 预算概要 Budget Summary

### 9.1 预算分配 Budget Allocation

| 类别 Category | 预算金额 Budget (¥) | 占比 Percentage |
|-------------|-------------------|---------------|
| 人力成本 Human Resources | | % |
| 硬件设备 Hardware | | % |
| 软件工具 Software | | % |
| 服务费用 Services | | % |
| 应急储备 Contingency | | % |
| **总计 Total** | **¥** | **100%** |

### 9.2 预算授权 Budget Authorization

| 授权级别 Authorization Level | 授权金额 Limit | 说明 Notes |
|--------------------------|-------------|----------|
| 项目经理 PM | ¥ | 日常开支 |
| 项目发起人 Sponsor | ¥ | 大额支出 |
| | ¥ | |

---

## 10. 成功标准 Success Criteria

### 10.1 项目成功标准 Project Success Criteria

| 类别 Category | 成功标准 Success Criteria | 衡量方式 Measurement |
|-------------|-------------------------|-------------------|
| 业务目标 Business | | |
| 用户满意度 User Satisfaction | | |
| 技术指标 Technical | | |
| 进度 Schedule | | |
| 质量 Quality | | |

### 10.2 验收标准 Acceptance Criteria

| 验收项 Item | 标准 Criteria | 验收方式 Method |
|-----------|-------------|---------------|
| 功能完成度 Feature Completion | 100% | 功能测试 |
| 缺陷密度 Defect Density | < 个/千行 | 代码审查 |
| 性能指标 Performance | 达标 | 性能测试 |
| 文档完整性 Documentation | 完整 | 文档评审 |

---

## 11. 沟通管理 Communication Management

### 11.1 沟通计划 Communication Plan

| 会议/报告 Meeting/Report | 频率 Frequency | 参与人 Participants | 时长 Duration |
|-----------------------|--------------|------------------|-------------|
| 每日站会 Daily Standup | 每日 Daily | 全体团队 | 15分钟 |
| 周例会 Weekly Meeting | 每周 Weekly | 核心团队 | 1小时 |
| 里程碑评审 Milestone Review | 按需 As Needed | 干系人 | 2小时 |
| 日报 Daily Report | 每日 Daily | PM | - |
| 周报 Weekly Report | 每周 Weekly | 干系人 | - |

### 11.2 沟通工具 Communication Tools

| 用途 Purpose | 工具 Tool |
|-----------|---------|
| 即时沟通 IM | |
| 文档协作 Docs | |
| 任务管理 Task Management | |
| 代码管理 Code | |
| 视频会议 Video Meeting | |

---

## 12. 变更管理 Change Management

### 12.1 变更控制流程 Change Control Process

```
变更请求提交 → 影响分析 → 变更评审 → 决策(批准/拒绝) → 实施 → 验证
Change Request → Impact Analysis → Review → Decision → Implement → Verify
```

### 12.2 变更控制委员会 Change Control Board (CCB)

| 成员 Member | 角色 Role | 职责 Responsibility |
|-----------|---------|-------------------|
| | | |
| | | |

---

## 13. 批准与授权 Approval & Authorization

### 13.1 项目章程批准 Charter Approval

本人确认并同意以上项目章程内容，并授权项目启动。

I confirm and agree to the contents of this Project Charter and authorize the project initiation.

| 角色 Role | 姓名 Name | 签名 Signature | 日期 Date |
|----------|---------|--------------|---------|
| 项目发起人 Project Sponsor | | | |
| 项目经理 Project Manager | | | |
| 关键干系人 Key Stakeholder | | | |
| 关键干系人 Key Stakeholder | | | |

---

## 附录 Appendix

### 附录A：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| PRD | Product Requirements Document 产品需求文档 |
| UAT | User Acceptance Testing 用户验收测试 |
| | |

### 附录B：参考文档 Reference Documents

-
-
-

### 附录C：项目编号规则 Project ID Rules

---

**文档结束 End of Document**

**重要提示:** 本章程一经签署，即成为项目执行的正式依据。任何变更必须经过正式的变更控制流程。
