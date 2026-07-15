# 可行性分析报告 Feasibility Analysis

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-05 |
| 最后修改 Last Modified | 2026-07-15 |
| 作者 Author | HeYS-Snowe |
| 审核人 Reviewer | Qore Origins |
| 项目名称 Project Name | 志极（Jeenith） |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-05 | HeYS-Snowe | 立项可行性分析初稿 Initiation feasibility draft |
| v1.1.0 | 2026-07-15 | HeYS-Snowe | 同步至 2.3.3 release，更新已验证项 Sync to 2.3.3 release |

---

## 目录 Table of Contents

1. [项目概述 Project Overview](#1-项目概述-project-overview)
2. [可行性分析方法 Methodology](#2-可行性分析方法-methodology)
3. [技术可行性 Technical Feasibility](#3-技术可行性-technical-feasibility)
4. [经济可行性 Economic Feasibility](#4-经济可行性-economic-feasibility)
5. [操作可行性 Operational Feasibility](#5-操作可行性-operational-feasibility)
6. [法律可行性 Legal Feasibility](#6-法律可行性-legal-feasibility)
7. [进度可行性 Schedule Feasibility](#7-进度可行性-schedule-feasibility)
8. [风险评估 Risk Assessment](#8-风险评估-risk-assessment)
9. [可行性结论 Conclusion](#9-可行性结论-conclusion)
10. [建议与对策 Recommendations](#10-建议与对策-recommendations)

---

## 1. 项目概述 Project Overview

### 1.1 项目基本信息 Project Basic Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **项目名称 Project Name** | 志极（Jeenith） |
| **组织 Organization** | Qore Origins（叩心） |
| **应用包名 Package Name** | `com.qore.jeenith` |
| **项目类型 Project Type** | 移动 App（Flutter，Android + Windows 桌面）|
| **项目定位 Positioning** | 叩问本心的卜算合集 |
| **当前版本 Current Version** | 2.3.3+23（release，2026-07-15） |
| **开发者 Developer** | HeYS-Snowe（唯一开发者） |
| **创建日期 Created Date** | 2026-07-05 |
| **GitHub 仓库 Repository** | https://github.com/1010523654/Jeenith |
| **许可证 License** | MIT |

### 1.2 项目背景 Project Background

中华术数文化源远流长，小六壬、周易、梅花易数、紫微斗数、奇门遁甲、大六壬、八字推演等术数体系承载了古人观象、推演、问事、明心的智慧。当前市面上的术数 App 普遍存在体验粗糙、算法杂糅、真随机缺失、功能割裂等问题。

"志极"由 Qore（叩心）发起，定位为**叩问本心的卜算合集**，以现代、精致的 Flutter 跨端体验承载十二种主流术数，并通过可扩展的卜算框架（DivinationTech + registry）支持后续新术的快速接入。本项目旨在验证以下命题的可行性：

- 以 Flutter 单代码库覆盖 Android + Windows 桌面端的可行性
- 以 lunar（寿星天文历）作为术数算法统一基础的可行性
- 以多源真随机引擎契合"心诚则灵"语境的可行性
- 以单人开发节奏完成 12 术合集 + 动效体系的可行性
- 以 MIT 协议开源运营传统文化 App 的可行性

### 1.3 分析目的 Purpose

本报告从技术、经济、操作、法律、进度五个维度对"志极"项目进行可行性分析，识别关键风险并给出应对建议，作为立项决策的依据。

---

## 2. 可行性分析方法 Methodology

### 2.1 分析维度 Analysis Dimensions

| 维度 Dimension | 关注点 Focus | 评估方式 Method |
|-------------|-----------|--------------|
| 技术可行性 Technical | 技术栈、算法、跨端、传感器 | 技术调研 + PoC 验证 |
| 经济可行性 Economic | 成本、收益、可持续性 | 预算分析 + ROI 评估 |
| 操作可行性 Operational | 用户接受度、使用门槛 | 用户调研 + 流程评估 |
| 法律可行性 Legal | 合规、版权、协议 | 法规调研 + 协议审查 |
| 进度可行性 Schedule | 时间、资源、节奏 | 里程碑规划 + 风险评估 |

### 2.2 评估标准 Evaluation Criteria

- **可行 Feasible**：当前条件下可达成，无重大阻碍
- **有条件可行 Conditionally Feasible**：需满足特定条件或采取应对措施
- **不可行 Infeasible**：存在重大阻碍，需重新评估

---

## 3. 技术可行性 Technical Feasibility

### 3.1 跨端框架可行性 Cross-Platform Framework

**评估项：Flutter 覆盖 Android + Windows 桌面**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| Android 支持 | ✓ 已验证 | Flutter Stable 主线，无障碍 |
| Windows 桌面支持 | ✓ 已验证 | Flutter 3.x stable，已产出 release ZIP |
| 单代码库一致性 | ✓ 已验证 | 双端行为一致，差异仅平台特有（如传感器）|
| 桌面窗口初始化 | ✓ 已验证 | main.dart 已处理桌面窗口尺寸初始化 |
| 性能表现 | ✓ 达标 | 启动 < 2s，单次卜算 < 500ms |

**结论 Conclusion：可行 Feasible**

Flutter 3.x 对 Android 与 Windows 桌面均已稳定支持，本项目已在 2.3.3 release 中验证双端构建产物均可正常产出与运行。

### 3.2 术数算法基础可行性 Algorithm Foundation

**评估项：lunar（寿星天文历）作为术数算法统一基础**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| lunar 库可用性 | ✓ 可用 | pub.dev lunar ^1.7.8，活跃维护 |
| 农历/节气支持 | ✓ 验证 | 农历转换、节气计算准确 |
| 八字四柱支持 | ✓ 验证 | v2.3.0 八字推演已落地 |
| 紫微斗数历算 | ✓ 验证 | v1.3.0 紫微 v2 已落地 |
| 奇门遁甲历算 | ✓ 验证 | v1.4.0 奇门 v2 已落地 |
| 大六壬历算 | ✓ 验证 | v1.7.0 大六壬已落地 |
| 算法正确性校验 | ⚠ 持续 | 关键排盘对照权威工具，已建立用例集 |

**结论 Conclusion：可行 Feasible**

lunar 库提供完整的农历/节气/八字/紫微/奇门/大六壬历算基础，本项目已基于其完成 5 种术数的落地。算法正确性通过对照权威在线排盘工具持续校验。

### 3.3 真随机引擎可行性 RNG Engine

**评估项：多源真随机引擎**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| dart:math Random.secure | ✓ 可用 | 系统级 CSPRNG，无需网络 |
| 触摸轨迹熵采集 | ✓ 已实现 | 起卦过程触摸采样 |
| random.org HTTP 真随机 | ✓ 已实现 | 失败时自动降级 |
| crypto SHA256 混合 | ✓ 已实现 | 多源熵混合 |
| 多源降级机制 | ✓ 已实现 | random.org → 触摸 → Random.secure |

**结论 Conclusion：可行 Feasible**

真随机引擎采用三源降级策略，即使网络不可用也能保证随机性，契合"心诚则灵"语境。

### 3.4 传感器可行性 Sensor Feasibility

**评估项：风水罗盘陀螺仪/磁场传感器**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| sensors_plus 可用性 | ✓ 可用 | pub.dev ^6.0.0，活跃维护 |
| Android 传感器支持 | ✓ 验证 | 主流设备陀螺仪/磁场普遍可用 |
| Windows 桌面传感器 | ⚠ 有限 | 桌面端通常无陀螺仪/磁场，需降级 |
| 设备能力降级 | ✓ 已实现 | 不可用时禁用罗盘并提示 |

**结论 Conclusion：有条件可行 Conditionally Feasible**

Android 端风水罗盘功能完整可用；Windows 桌面端因硬件限制需降级处理（禁用罗盘功能并提示用户）。已在 v1.7.0 落地。

### 3.5 动效体系可行性 Motion System

**评估项：动效 Phase 1-6 全覆盖**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| 入场仪式 Phase 1 | ✓ 已实现 | Starfield + 卡片入场 |
| 路由转场 Phase 2 | ✓ 已实现 | go_router 自定义转场 |
| 绘制过程 Phase 3 | ✓ 已实现 | 卦象/盘面绘制动画 |
| 结果揭示 Phase 4 | ✓ 已实现 | 结果卡片揭示 |
| 按钮物理反馈 Phase 5 | ✓ 已实现 | GoldButton / DarkButton |
| 图标状态切换 Phase 6 | ✓ 已实现 | AnimatedExpandIcon + SvgIcon |
| 全局动效开关 | ✓ 已实现 | AppConfig.animationsEnabled |
| 动画细分控制 | ✓ 已实现 | 4 个 AnimationKind 独立控制 |
| 性能影响 | ✓ 达标 | CustomPainter 显式 dispose TextPainter |

**结论 Conclusion：可行 Feasible**

动效体系 Phase 1-6 已在 v2.1.0/v2.2.0 全部落地，并通过设置页全局开关 + 4 个 AnimationKind 细分控制。CustomPainter 显式 dispose TextPainter 防止 native handle 泄漏。

### 3.6 可扩展框架可行性 Extensibility Framework

**评估项：DivinationTech + registry 可扩展框架**

| 评估点 Aspect | 状态 Status | 说明 Notes |
|-------------|-----------|----------|
| DivinationTech 抽象 | ✓ 已实现 | 卜算术统一契约 |
| registry 注册机制 | ✓ 已实现 | 新术接入一行注册 |
| feature 目录范式 | ✓ 已验证 | 12 术均按 features/xxx/ 范式落地 |
| 新术接入成本 | ✓ 达标 | ≤ 1 feature 目录 + registry 一行 |

**结论 Conclusion：可行 Feasible**

可扩展框架已在 12 术落地中反复验证，新术接入成本可控。

### 3.7 技术可行性总结 Technical Summary

| 维度 Dimension | 结论 Conclusion |
|-------------|-------------|
| 跨端框架 | ✓ 可行 |
| 术数算法基础 | ✓ 可行 |
| 真随机引擎 | ✓ 可行 |
| 传感器 | ⚠ 有条件可行（桌面降级）|
| 动效体系 | ✓ 可行 |
| 可扩展框架 | ✓ 可行 |

**总体技术可行性 Overall Technical Feasibility：可行 Feasible**

---

## 4. 经济可行性 Economic Feasibility

### 4.1 成本分析 Cost Analysis

| 成本类别 Cost Category | 金额 Amount (¥) | 说明 Notes |
|--------------------|---------------|----------|
| 开发人力 Human | 0 | 开发者业余时间自驱投入 |
| 开发设备 Hardware | 0 | 自有 PC + Android 测试机折旧 |
| 软件工具 Software | 0 | 全开源工具链（Flutter / VS Code / Git）|
| 第三方服务 Services | 0 | GitHub 免费公开仓库 + random.org 免费额度 |
| 域名/服务器 Hosting | 0 | 无后端，纯客户端 |
| 应用市场费用 Store | 0（暂未上架）| GitHub 为发布主渠道 |
| **总计 Total** | **¥0** | 零预算运营 |

### 4.2 收益分析 Revenue Analysis

本项目为开源个人项目，不直接产生经济收益，收益体现在以下非货币维度：

| 收益维度 Revenue Dimension | 描述 Description |
|------------------------|---------------|
| 文化收益 Cultural | 活化传承中华术数文化 |
| 技术收益 Technical | 沉淀可复用工程范式 |
| 品牌收益 Brand | 树立 Qore Origins 品牌形象 |
| 社区收益 Community | 开源贡献，扩大影响力 |
| 个人成长 Growth | 开发者全栈能力提升 |

### 4.3 可持续性分析 Sustainability Analysis

| 维度 Dimension | 评估 Evaluation |
|-------------|--------------|
| 资金可持续 | ✓ 零成本运营，无资金压力 |
| 人力可持续 | ⚠ 依赖开发者业余时间，需控制节奏 |
| 技术可持续 | ✓ 依赖主流开源生态（Flutter / lunar）|
| 社区可持续 | ⚠ 视开源社区参与度而定 |

### 4.4 经济可行性结论 Economic Conclusion

**结论 Conclusion：可行 Feasible**

- 零预算运营，无资金压力
- 不依赖直接经济回报，以文化与品牌收益为主
- 可持续性依赖开发者节奏控制与社区参与
- 后续可视情况上架应用市场（需评估审核成本）

---

## 5. 操作可行性 Operational Feasibility

### 5.1 用户接受度 User Acceptance

| 评估点 Aspect | 评估 Evaluation |
|-------------|--------------|
| 目标用户群体 | 传统文化爱好者 + 术数研究者 + 技术观察者 |
| 用户认知门槛 | 中等（需基础术数认知，使用手册辅助）|
| 操作习惯匹配 | ✓ 移动端 + 桌面端常见交互范式 |
| 仪式感接受度 | ✓ 现代用户对精致动效接受度高 |
| 隐私偏好匹配 | ✓ 隐私优先，本地存储符合用户期望 |

### 5.2 使用门槛分析 Usage Barrier Analysis

| 门槛 Barrier | 等级 Level | 缓解措施 Mitigation |
|-----------|---------|------------------|
| 术数认知门槛 | 中 | 使用手册 + 引导提示 + 算法说明 |
| 操作流程门槛 | 低 | 仪式化交互引导用户完成起卦 |
| 跨端迁移门槛 | 低 | Android + Windows 同代码库，体验一致 |
| 罗盘硬件门槛 | 低 | 不支持设备自动降级 |

### 5.3 部署与维护 Deployment & Maintenance

| 评估点 Aspect | 评估 Evaluation |
|-------------|--------------|
| 安装方式 | APK 自分发 + Windows ZIP 自分发 + GitHub Release |
| 更新机制 | 用户主动下载新版本 |
| 配置持久化 | shared_preferences 本地存储 |
| 历史记录 | 本地 JSON，原子读-改-写 |
| 离线可用 | ✓ 完全离线（random.org 降级为本地真随机）|
| 维护成本 | 低（无后端，无服务端监控）|

### 5.4 操作可行性结论 Operational Conclusion

**结论 Conclusion：可行 Feasible**

- 目标用户群体明确，接受度高
- 使用门槛可通过手册与引导缓解
- 离线可用，部署维护成本极低
- 跨端体验一致，降低用户迁移成本

---

## 6. 法律可行性 Legal Feasibility

### 6.1 开源协议 License

| 评估点 Aspect | 评估 Evaluation |
|-------------|--------------|
| 协议选择 | MIT License |
| 协议兼容性 | ✓ MIT 与所有依赖协议兼容 |
| 商业使用 | ✓ MIT 允许商业使用 |
| 归属要求 | ✓ 保留版权声明 Copyright (c) 2026 Qore |

### 6.2 依赖协议审查 Dependency License Audit

| 依赖 Dependency | 协议 License | 兼容 Compatible |
|--------------|-----------|---------------|
| Flutter / Dart | BSD-3-Clause | ✓ |
| flutter_riverpod | MIT | ✓ |
| go_router | BSD-3-Clause | ✓ |
| lunar | MIT | ✓ |
| flutter_svg | BSD-3-Clause | ✓ |
| shared_preferences | BSD-3-Clause | ✓ |
| sensors_plus | BSD-3-Clause | ✓ |
| share_plus | BSD-3-Clause | ✓ |
| path_provider | BSD-3-Clause | ✓ |
| flutter_launcher_icons | MIT | ✓ |
| http | BSD-3-Clause | ✓ |
| crypto | BSD-3-Clause | ✓ |

**结论：所有依赖协议均与 MIT 兼容。**

### 6.3 内容合规 Content Compliance

| 评估点 Aspect | 评估 Evaluation | 应对措施 Mitigation |
|-------------|--------------|------------------|
| 术数内容定位 | 传统文化工具 | 使用手册强调文化属性 |
| 迷信宣传风险 | 低 | 避免承诺预测结果，强调"叩问本心" |
| 应用市场审核 | 中（部分渠道严格）| GitHub 为主渠道，应用市场可选 |
| 算法实现版权 | 自研 + 公开算法 | 未抄袭他人实现 |
| 卦辞爻辞数据 | 公共领域 | 周易原文属公共领域 |
| 历法数据 | lunar 库提供 | 遵循 lunar 协议 |

### 6.4 隐私合规 Privacy Compliance

| 评估点 Aspect | 评估 Evaluation |
|-------------|--------------|
| 用户数据收集 | ✓ 不收集任何用户信息 |
| 用户账号 | ✓ 无账号系统 |
| 网络通信 | 仅 random.org（可选），无用户数据上传 |
| 本地数据 | 历史记录本地存储，用户可导出/删除 |
| 权限申请 | 仅传感器权限（罗盘），按需申请 |

### 6.5 法律可行性结论 Legal Conclusion

**结论 Conclusion：可行 Feasible**

- MIT 协议与所有依赖兼容
- 内容定位为传统文化工具，合规风险低
- 隐私优先，不收集用户信息
- 应用市场审核风险可通过 GitHub 主渠道规避

---

## 7. 进度可行性 Schedule Feasibility

### 7.1 已完成进度 Completed Progress

| 版本 Version | 日期 Date | 核心内容 Highlights | 状态 Status |
|-------------|---------|------------------|-----------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 术 v1 | ✓ |
| 1.1.0-1.8.0 | 2026-07-12 ~ 07-13 | 工程迁移 + 卦辞 + 紫微 v2 + 奇门 v2 + 体验基础 + 抽签 + 测字 + 大六壬 + 罗盘 + 手册 | ✓ |
| 2.0.0 | 2026-07-14 | release，体验深化与品牌定调 | ✓ |
| 2.1.0-2.2.0 | 2026-07-14 | 动效体系 Phase 1-6 | ✓ |
| 2.3.0 | 2026-07-15 | 八字推演 + 测名字 + 紫微盘重构 | ✓ |
| 2.3.1-2.3.3 | 2026-07-15 | 起卦按钮修复 + 设置页动画细分 + MIT LICENSE | ✓ |

> 10 天内完成 12 术 + 动效体系 + 跨端构建 + 开源协议，节奏紧凑但已验证可行。

### 7.2 后续规划 Future Schedule

| 版本 Version | 计划内容 Planned | 优先级 Priority |
|-------------|---------------|--------------|
| 2.4.x | 思源宋体字体 + 首次使用引导遮罩 | P1 |
| 2.5.x | 主题浅色对齐 + 罗盘精度优化 | P2 |
| 3.x | 视新术需求扩展（六爻纳甲 / 铁板神数等）| P2 |

### 7.3 资源与节奏 Resource & Pace

| 评估点 Aspect | 评估 Evaluation |
|-------------|--------------|
| 单人开发节奏 | ✓ 已验证（10 天 12 术 + 动效）|
| 自动化构建 | ✓ build_apk.ps1 + 双份历史归档 |
| 质量保障 | ✓ flutter analyze 0 error 强制 |
| 文档同步 | ✓ 项目文档 + AGENTS.md + CLAUDE.md |

### 7.4 进度可行性结论 Schedule Conclusion

**结论 Conclusion：可行 Feasible**

- 已验证单人开发节奏可支撑 12 术 + 动效体系
- 自动化构建脚本降低运维负担
- 后续规划节奏可控，无紧迫截止

---

## 8. 风险评估 Risk Assessment

### 8.1 风险矩阵 Risk Matrix

| 风险ID Risk ID | 风险描述 Risk Description | 维度 Dimension | 影响 Impact | 概率 Probability | 等级 Level | 应对 Strategy |
|--------------|----------------------|-------------|-----------|---------------|---------|-------------|
| R001 | 术数算法实现错误（安星/排盘/神煞）| 技术 | 高 | 中 | 高 | 关键算法对照权威文献/在线排盘工具校验 |
| R002 | 风水罗盘传感器兼容性 | 技术 | 中 | 中 | 中 | sensors_plus 抽象 + 设备能力降级 |
| R003 | 单人开发进度瓶颈 | 进度 | 中 | 高 | 高 | 严格版本节奏，优先核心目标 |
| R004 | lunar 库版本升级导致历算回归 | 技术 | 中 | 低 | 低 | 锁定版本 ^1.7.8，升级前回归测试 |
| R005 | Windows 桌面 Flutter 支持不稳定 | 技术 | 中 | 低 | 低 | 关键功能先验证 Windows 构建 |
| R006 | random.org 网络不可用 | 技术 | 低 | 高 | 中 | 真随机多源降级 |
| R007 | 术数内容合规风险 | 法律 | 高 | 低 | 中 | MIT 协议 + 定位传统文化工具 + 非迷信宣传 |
| R008 | Flutter 升级破坏性变更 | 技术 | 中 | 中 | 中 | 锁定 3.x 主线，升级前回归测试 |
| R009 | 开源项目可持续性 | 经济 | 中 | 中 | 中 | 开发者自驱 + 社区贡献 |
| R010 | 用户认知门槛 | 操作 | 中 | 中 | 中 | 使用手册 + 引导提示 |

### 8.2 高风险项详评 High Risk Details

#### R001 术数算法错误
- **影响 Impact**：高 - 算法错误直接损害产品可信度
- **概率 Probability**：中 - 术数算法复杂，存在实现误差风险
- **应对措施**：
  - 紫微 14 主星 + 辅星安星对照在线排盘工具
  - 奇门四盘九宫对照权威文献
  - 大六壬四课三传对照专业排盘软件
  - 八字四柱 + 大运 + 流年对照 lunar 文档
  - 建立关键用例对照集

#### R003 单人开发进度瓶颈
- **影响 Impact**：中 - 影响后续迭代节奏
- **概率 Probability**：高 - 单人开发固有风险
- **应对措施**：
  - 严格版本节奏，每版本聚焦核心目标
  - 自动化构建 + 双份历史归档降低运维负担
  - 优先核心目标，非核心延后

#### R007 术数内容合规
- **影响 Impact**：高 - 影响应用市场上架与传播
- **概率 Probability**：低 - 已定位为传统文化工具
- **应对措施**：
  - 使用手册强调文化属性，避免"迷信宣传"措辞
  - GitHub 始终为发布主渠道
  - 应用市场上架为可选，不作为必须

---

## 9. 可行性结论 Conclusion

### 9.1 综合评估 Comprehensive Evaluation

| 维度 Dimension | 结论 Conclusion | 关键依据 Key Evidence |
|-------------|-------------|-------------------|
| 技术可行性 Technical | ✓ 可行 | 12 术 + 动效体系 + 跨端构建已落地 |
| 经济可行性 Economic | ✓ 可行 | 零预算运营，无资金压力 |
| 操作可行性 Operational | ✓ 可行 | 目标用户明确，离线可用，维护成本低 |
| 法律可行性 Legal | ✓ 可行 | MIT 协议 + 隐私优先 + 传统文化定位 |
| 进度可行性 Schedule | ✓ 可行 | 10 天完成 12 术 + 动效，节奏已验证 |

### 9.2 总体结论 Overall Conclusion

**"志极（Jeenith）"项目在技术、经济、操作、法律、进度五个维度均具备可行性，建议立项推进。**

项目已在 2.3.3 release 中验证了核心命题：
- ✓ Flutter 跨端（Android + Windows）可行
- ✓ lunar 天文历作为术数统一基础可行
- ✓ 多源真随机引擎可行
- ✓ 单人开发完成 12 术 + 动效体系可行
- ✓ MIT 协议开源运营传统文化 App 可行

### 9.3 条件与前提 Conditions & Prerequisites

项目可行性成立的前提条件：
1. 开发者持续投入业余时间
2. Flutter / lunar 等核心依赖持续维护
3. GitHub 作为发布主渠道保持可用
4. 术数内容定位保持"传统文化工具"

---

## 10. 建议与对策 Recommendations

### 10.1 技术建议 Technical Recommendations

1. **算法校验常态化**：建立关键用例对照集，每版本发布前回归
2. **依赖版本锁定**：pubspec.yaml 锁定主版本，升级前充分回归测试
3. **Windows 桌面持续验证**：每次 Flutter 升级前先验证 Windows 构建
4. **真随机引擎监控**：random.org 不可用时静默降级，不阻塞用户
5. **CustomPainter 资源管理**：持续遵守显式 dispose TextPainter 规范

### 10.2 运营建议 Operational Recommendations

1. **使用手册优先**：持续完善使用手册，降低用户认知门槛
2. **GitHub 为主渠道**：开源运营，应用市场为辅
3. **社区参与**：鼓励 Issue / PR 贡献，降低单人维护压力
4. **版本节奏控制**：每版本聚焦核心目标，避免范围蔓延

### 10.3 法律建议 Legal Recommendations

1. **定位明确**：始终以"传统文化工具"定位，避免迷信宣传措辞
2. **协议合规**：新增依赖时审查协议兼容性
3. **隐私透明**：在 README 与使用手册中明确说明无用户数据收集

### 10.4 风险监控 Risk Monitoring

- 每版本发布前进行算法对照校验
- 每季度评估依赖版本升级必要性
- 持续关注应用市场政策变化
- 监控 GitHub Issue 反馈，及时响应算法正确性问题

---

## 附录 Appendix

### 附录A：可行性评估检查清单 Feasibility Checklist

| 检查项 Item | 状态 Status | 备注 Notes |
|-----------|-----------|----------|
| 跨端框架验证 | ✓ | Android + Windows 双端 release 已产出 |
| 核心依赖可用 | ✓ | lunar / Riverpod / go_router 等均已验证 |
| 真随机引擎落地 | ✓ | 三源降级已实现 |
| 传感器降级处理 | ✓ | 罗盘不支持设备已处理 |
| 动效体系覆盖 | ✓ | Phase 1-6 全覆盖 |
| 可扩展框架验证 | ✓ | 12 术均按范式接入 |
| 零预算运营 | ✓ | 全开源工具链 |
| MIT 协议合规 | ✓ | 依赖协议均兼容 |
| 隐私合规 | ✓ | 不收集用户信息 |
| 单人节奏验证 | ✓ | 10 天完成核心目标 |

### 附录B：参考文档 Reference Documents

- 项目章程 Project Charter
- 项目立项申请书 Project Proposal
- AGENTS.md / CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

### 附录C：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| DivinationTech | 卜算术抽象接口 |
| registry | 卜算术注册表 |
| lunar | 寿星天文历 Dart 库 |
| RNG | Random Number Generator，真随机引擎 |
| CSPRNG | Cryptographically Secure Pseudo Random Number Generator |
| MIT | Massachusetts Institute of Technology，MIT 开源协议 |
| Starfield | 星点背景动画 |
| AnimationKind | 动画类型枚举（4 种独立控制）|

---

**文档结束 End of Document**

**重要提示:** 本可行性分析报告基于 2.3.3 release 的实际落地情况评估，结论已经过实践验证。后续重大技术变更需重新评估可行性。
