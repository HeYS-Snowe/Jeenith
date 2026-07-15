# 用户需求调研报告 User Research

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
| v1.0.0 | 2026-07-05 | HeYS-Snowe | 用户调研初稿 Initial research |
| v2.3.3 | 2026-07-15 | HeYS-Snowe | 同步当前 release，定稿 |

---

## 目录 Table of Contents

1. [调研概述 Research Overview](#1-调研概述-research-overview)
2. [目标用户画像 User Personas](#2-目标用户画像-user-personas)
3. [用户需求分析 User Needs Analysis](#3-用户需求分析-user-needs-analysis)
4. [用户痛点分析 Pain Points Analysis](#4-用户痛点分析-pain-points-analysis)
5. [使用场景分析 Usage Scenarios](#5-使用场景分析-usage-scenarios)
6. [竞品用户反馈 Competitive Feedback](#6-竞品用户反馈-competitive-feedback)
7. [用户期望与建议 Expectations](#7-用户期望与建议-expectations)
8. [需求优先级排序 Priority](#8-需求优先级排序-priority)
9. [调研结论 Conclusion](#9-调研结论-conclusion)

---

## 1. 调研概述 Research Overview

### 1.1 调研目的 Research Purpose

本调研旨在深入了解"志极（Jeenith）"产品的目标用户群体特征、需求、痛点与使用场景，为产品设计与功能优先级提供依据。

### 1.2 调研方法 Research Methods

| 方法 Method | 描述 Description |
|-----------|---------------|
| 桌面研究 Desktop Research | 术数 App 市场调研、用户评论分析 |
| 用户画像分析 Persona Analysis | 基于产品定位构建典型用户画像 |
| 竞品分析 Competitive Analysis | 分析现有术数 App 的用户反馈 |
| 场景推演 Scenario Simulation | 推演典型使用场景 |
| 开发者自省 Developer Reflection | 开发者作为深度用户的自省 |

### 1.3 调研范围 Research Scope

- 中文文化圈术数 App 用户
- 传统文化爱好者
- 术数研究者
- Flutter/技术观察者
- 桌面端排盘用户

### 1.4 调研局限 Research Limitations

- 本项目为单人开发，无大规模用户访谈资源
- 调研主要基于桌面研究与开发者自省
- 后续可根据 GitHub Issue / 用户反馈持续迭代

---

## 2. 目标用户画像 User Personas

### 2.1 画像 A：传统文化爱好者（核心用户）

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **姓名 Name** | 李传统文化（化名） |
| **年龄 Age** | 25-55 岁 |
| **性别 Gender** | 不限 |
| **职业 Occupation** | 教师 / 文化工作者 / 自由职业 / 企事业单位员工 |
| **教育 Education** | 本科及以上 |
| **特征 Characteristics** | 对中华传统文化有浓厚兴趣，多术数均有涉猎，注重体验质感 |
| **设备 Device** | Android 手机为主，部分有 Windows PC |
| **使用频率 Frequency** | 每周数次 |
| **付费意愿 Payment** | 低（偏好免费工具） |
| **技术熟练度 Tech** | 中等 |

**用户故事**：作为一名传统文化爱好者，我希望在一个 App 内体验多种主流术数，避免在多个 App 之间切换，同时希望起卦过程有仪式感，结果可信赖。

### 2.2 画像 B：术数研究者

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **姓名 Name** | 王研究（化名） |
| **年龄 Age** | 30-60 岁 |
| **性别 Gender** | 不限 |
| **职业 Occupation** | 研究 / 教学 / 命理从业 |
| **教育 Education** | 本科及以上 |
| **特征 Characteristics** | 对特定术数有深入研究，关注算法规范与可查证性 |
| **设备 Device** | Windows PC 为主，Android 手机辅助 |
| **使用频率 Frequency** | 每日 |
| **付费意愿 Payment** | 中（愿为专业工具付费） |
| **技术熟练度 Tech** | 中等 |

**用户故事**：作为一名术数研究者，我希望排盘结果可对照权威工具复算，算法实现规范可查证，能在 Windows 桌面端进行严肃排盘。

### 2.3 画像 C：技术观察者

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **姓名 Name** | 张技术（化名） |
| **年龄 Age** | 20-40 岁 |
| **性别 Gender** | 不限 |
| **职业 Occupation** | 程序员 / 学生 / 技术爱好者 |
| **教育 Education** | 本科及以上 |
| **特征 Characteristics** | 关注 Flutter 跨端、动效体系、开源项目 |
| **设备 Device** | Android + Windows |
| **使用频率 Frequency** | 偶尔 |
| **付费意愿 Payment** | 低 |
| **技术熟练度 Tech** | 高 |

**用户故事**：作为一名技术观察者，我希望通过这个项目学习 Flutter 跨端 + 动效 + 可扩展框架的工程实践。

### 2.4 画像 D：初学者

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **姓名 Name** | 赵初学（化名） |
| **年龄 Age** | 18-35 岁 |
| **性别 Gender** | 不限 |
| **职业 Occupation** | 学生 / 年轻白领 |
| **教育 Education** | 高中及以上 |
| **特征 Characteristics** | 对术数好奇但缺乏系统认知 |
| **设备 Device** | Android 手机 |
| **使用频率 Frequency** | 偶尔 |
| **付费意愿 Payment** | 低 |
| **技术熟练度 Tech** | 中等 |

**用户故事**：作为一名初学者，我希望有使用手册说明各术原理与操作，降低认知门槛。

---

## 3. 用户需求分析 User Needs Analysis

### 3.1 功能需求 Functional Needs

| 需求ID Need ID | 需求描述 Need Description | 来源画像 Source | 优先级 Priority |
|-------------|----------------------|-------------|--------------|
| FN-01 | 一站式体验 12 种主流术数 | A | P0 |
| FN-02 | 紫微斗数全套安星 | B | P0 |
| FN-03 | 奇门遁甲四盘九宫 | B | P0 |
| FN-04 | 大六壬四课三传 | B | P0 |
| FN-05 | 八字四柱 + 大运 + 流年 | B | P0 |
| FN-06 | 周易金钱卦 + 卦辞爻辞 | A | P0 |
| FN-07 | 梅花易数体用分析 | A | P0 |
| FN-08 | 风水罗盘实时方位 | A | P0 |
| FN-09 | 抽签求签 | A | P0 |
| FN-10 | 测字拆解 | A | P0 |
| FN-11 | 测名字五格剖象 | A | P0 |
| FN-12 | 掷筊问事 | A | P0 |
| FN-13 | 小六壬掐指神课 | A | P0 |
| FN-14 | 使用手册 | A/D | P1 |
| FN-15 | 历史记录与导出 | A/B | P1 |
| FN-16 | 结果分享 | A | P1 |
| FN-17 | 主题切换 | A | P0 |
| FN-18 | 动效开关 + 细分控制 | A | P0 |

### 3.2 非功能需求 Non-Functional Needs

| 需求ID Need ID | 需求描述 Need Description | 来源画像 Source | 优先级 Priority |
|-------------|----------------------|-------------|--------------|
| NF-01 | 真随机而非伪随机 | A/B | P0 |
| NF-02 | 算法规范、可查证 | B | P0 |
| NF-03 | 跨端一致（Android + Windows） | B | P0 |
| NF-04 | 仪式感动效 | A | P0 |
| NF-05 | 隐私优先、离线可用 | A/B | P0 |
| NF-06 | 启动快速 | A | P0 |
| NF-07 | 卜算响应快 | A | P0 |
| NF-08 | 开源可参考 | C | P1 |
| NF-09 | MIT 协议 | C | P1 |
| NF-10 | 桌面端排盘 | B | P1 |

### 3.3 体验需求 Experience Needs

| 需求ID Need ID | 需求描述 Need Description |
|-------------|----------------------|
| EN-01 | 起卦过程有仪式感 |
| EN-02 | 视觉精致、不古板 |
| EN-03 | 操作流畅、响应快 |
| EN-04 | 结果展示清晰 |
| EN-05 | 命盘/盘面绘制美观 |
| EN-06 | 主题可切换 |
| EN-07 | 动效可关闭（无障碍） |

---

## 4. 用户痛点分析 Pain Points Analysis

### 4.1 现有术数 App 痛点 Existing Pain Points

| 痛点ID Pain ID | 痛点描述 Pain Description | 严重度 Severity | 来源画像 Source |
|-------------|----------------------|-------------|--------------|
| PP-01 | 体验粗糙，界面古板 | 高 | A |
| PP-02 | 操作流程割裂，缺乏仪式感 | 高 | A |
| PP-03 | 算法实现不规范，难以查证 | 高 | B |
| PP-04 | 缺乏天文历算基础 | 高 | B |
| PP-05 | 使用伪随机数 | 中 | A/B |
| PP-06 | 多 App 切换，功能割裂 | 高 | A |
| PP-07 | 桌面端缺位 | 中 | B |
| PP-08 | 闭源，难以查证 | 中 | B/C |
| PP-09 | 缺乏使用手册 | 中 | D |
| PP-10 | 无历史记录 | 中 | A/B |
| PP-11 | 无主题切换 | 低 | A |
| PP-12 | 动效过强无法关闭 | 低 | A |

### 4.2 痛点优先级 Pain Priority

| 优先级 Priority | 痛点 Pain Points |
|-------------|----------------|
| 高 | PP-01 体验粗糙 / PP-02 缺乏仪式感 / PP-03 算法不规范 / PP-04 缺乏历算 / PP-06 多 App 切换 |
| 中 | PP-05 伪随机 / PP-07 桌面缺位 / PP-08 闭源 / PP-09 无手册 / PP-10 无历史 |
| 低 | PP-11 无主题 / PP-12 动效无法关闭 |

### 4.3 痛点对应解决方案 Pain Solutions

| 痛点 Pain | 解决方案 Solution |
|---------|----------------|
| PP-01 体验粗糙 | Flutter 跨端 + 精致设计 + Starfield 背景 |
| PP-02 缺乏仪式感 | 动效体系 Phase 1-6 + 仪式路由 |
| PP-03 算法不规范 | lunar 天文历 + 权威文献对照 |
| PP-04 缺乏历算 | lunar 寿星天文历统一基础 |
| PP-05 伪随机 | 多源真随机引擎 |
| PP-06 多 App 切换 | 12 术合集，统一入口 |
| PP-07 桌面缺位 | Windows 桌面同等体验 |
| PP-08 闭源 | MIT 协议开源 |
| PP-09 无手册 | 使用手册 12 章覆盖 |
| PP-10 无历史 | 本地历史 + 导出 |
| PP-11 无主题 | 主题切换 + 持久化 |
| PP-12 动效无法关闭 | 全局开关 + 4 AnimationKind 细分 |

---

## 5. 使用场景分析 Usage Scenarios

### 5.1 场景 S1：日常问事

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **场景** | 用户对某事有疑问，希望通过术数问事 |
| **画像** | A 传统文化爱好者 |
| **设备** | Android 手机 |
| **流程** | 打开 App → 选术 → 起卦 → 看结果 → 分享/保存 |
| **关键需求** | 操作流畅、仪式感、结果清晰、可分享 |
| **典型时长** | 1-3 分钟 |

### 5.2 场景 S2：命理研究

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **场景** | 研究者为某人排盘，分析命理 |
| **画像** | B 术数研究者 |
| **设备** | Windows PC（主）+ Android（辅助） |
| **流程** | 打开 App → 紫微/八字 → 输入生辰 → 排盘 → 分析 → 对照权威工具 |
| **关键需求** | 算法正确、可查证、桌面端、命盘清晰 |
| **典型时长** | 10-30 分钟 |

### 5.3 场景 S3：术数学习

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **场景** | 初学者学习术数原理 |
| **画像** | D 初学者 |
| **设备** | Android 手机 |
| **流程** | 打开 App → 使用手册 → 阅读原理 → 选术体验 |
| **关键需求** | 使用手册、操作引导 |
| **典型时长** | 5-20 分钟 |

### 5.4 场景 S4：风水勘测

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **场景** | 用户勘测风水方位 |
| **画像** | A 传统文化爱好者 |
| **设备** | Android 手机（需传感器） |
| **流程** | 打开 App → 风水罗盘 → 持设备测方位 → 看解读 |
| **关键需求** | 传感器准确、方位解读、实时响应 |
| **典型时长** | 持续使用 |

### 5.5 场景 S5：技术学习

| 维度 Dimension | 描述 Description |
|--------------|---------------|
| **场景** | 技术观察者学习 Flutter 工程实践 |
| **画像** | C 技术观察者 |
| **设备** | Windows PC |
| **流程** | clone 仓库 → 阅读代码 → 学习动效/框架/跨端 |
| **关键需求** | 开源、文档完整、工程范本 |
| **典型时长** | 数小时 |

### 5.6 场景矩阵 Scenario Matrix

| 场景 Scenario | 画像 Persona | 设备 Device | 时长 Duration | 关键需求 Key Need |
|-----------|-----------|-----------|------------|---------------|
| S1 日常问事 | A | Android | 1-3 min | 流畅、仪式感 |
| S2 命理研究 | B | Windows | 10-30 min | 算法、桌面端 |
| S3 术数学习 | D | Android | 5-20 min | 手册、引导 |
| S4 风水勘测 | A | Android | 持续 | 传感器、实时 |
| S5 技术学习 | C | Windows | 数小时 | 开源、文档 |

---

## 6. 竞品用户反馈 Competitive Feedback

### 6.1 竞品用户评论分析 Competitive Review Analysis

基于应用市场与社区对现有术数 App 的用户评论分析：

| 反馈类型 Feedback | 频次 Frequency | 描述 Description |
|---------------|-------------|---------------|
| 体验粗糙 | 高 | "界面太老气"、"操作不流畅" |
| 算法错误 | 中 | "排盘结果不对"、"和书里不一样" |
| 缺乏历算 | 中 | "节气算错"、"农历转换不对" |
| 多 App 切换 | 中 | "为什么要装这么多 App" |
| 桌面端缺位 | 低 | "PC 上没有好用的" |
| 动效过强 | 低 | "动画太多没法关闭" |
| 无主题切换 | 低 | "晚上太亮" |
| 无历史记录 | 中 | "查不到之前的卦" |

### 6.2 竞品反馈对应方案 Competitive Solutions

| 反馈 Feedback | 志极方案 Jeenith Solution |
|------------|------------------------|
| 体验粗糙 | Flutter 跨端 + 精致设计 + Starfield |
| 算法错误 | lunar 天文历 + 权威文献对照 |
| 缺乏历算 | lunar 寿星天文历统一基础 |
| 多 App 切换 | 12 术合集 |
| 桌面端缺位 | Windows 桌面同等体验 |
| 动效过强 | 全局开关 + 4 AnimationKind 细分 |
| 无主题切换 | 主题切换 + 持久化 |
| 无历史记录 | 本地历史 + 导出 |

---

## 7. 用户期望与建议 Expectations

### 7.1 用户期望 User Expectations

| 期望 Expectation | 来源画像 Source | 优先级 Priority |
|---------------|-------------|--------------|
| 12 术一站式 | A | P0 |
| 仪式感动效 | A | P0 |
| 真随机 | A/B | P0 |
| 算法可查证 | B | P0 |
| 桌面端排盘 | B | P0 |
| 使用手册 | A/D | P1 |
| 历史记录 | A/B | P1 |
| 结果分享 | A | P1 |
| 主题切换 | A | P0 |
| 动效可控 | A | P0 |
| 开源 | C | P1 |

### 7.2 用户建议 User Suggestions

- 增加首次使用引导遮罩（来自画像 D）
- 支持思源宋体字体（来自画像 A，文化感更强）
- 罗盘精度优化（来自画像 A）
- 主题浅色对齐细节（来自画像 A）
- 后续扩展更多术数（来自画像 B）

---

## 8. 需求优先级排序 Priority

### 8.1 MoSCoW 优先级 MoSCoW Priority

| 优先级 Priority | 需求 Requirements |
|-------------|----------------|
| **Must Have** | 12 术合集 / 真随机引擎 / 算法规范 / 跨端一致 / 仪式感动效 / 隐私优先 / 主题切换 / 动效开关 |
| **Should Have** | 使用手册 / 历史记录 / 结果分享 / 开源 MIT |
| **Could Have** | 思源宋体字体 / 首次使用引导 / 罗盘精度优化 |
| **Won't Have** | 后端服务 / 账号系统 / iOS/macOS/Linux / 付费功能 |

### 8.2 Kano 模型分析 Kano Analysis

| 需求 Need | Kano 分类 Category | 说明 Notes |
|----------|----------------|----------|
| 12 术合集 | 期望 Expectation | 越多越好 |
| 算法正确 | 基本 Must-be | 错了用户会流失 |
| 真随机引擎 | 兴奋 Excitement | 超出预期 |
| 仪式感动效 | 兴奋 Excitement | 差异化 |
| 隐私优先 | 基本 Must-be | 隐私是底线 |
| 跨端一致 | 期望 Expectation | 覆盖更多场景 |
| 主题切换 | 期望 Expectation | 偏好适配 |
| 动效开关 | 基本 Must-be | 无障碍 |
| 使用手册 | 期望 Expectation | 降低门槛 |
| 历史记录 | 期望 Expectation | 事后查阅 |

---

## 9. 调研结论 Conclusion

### 9.1 核心发现 Key Findings

1. **合集需求强烈**：用户普遍痛点是多 App 切换，12 术合集是核心差异化
2. **算法可信是底线**：术数研究者将算法正确性视为基本需求
3. **仪式感是兴奋点**：动效体系 Phase 1-6 是超出预期的差异化
4. **真随机契合语境**："心诚则灵"语境下，真随机引擎建立信任
5. **桌面端有缺口**：研究者对 Windows 桌面排盘有明确需求
6. **开源建立信任**：开源可查证增强用户信任
7. **隐私是底线**：无账号、本地存储是基本要求
8. **动效可控是基本**：无障碍要求动效可关闭

### 9.2 用户画像权重 Persona Weights

| 画像 Persona | 权重 Weight | 说明 Notes |
|-----------|----------|----------|
| A 传统文化爱好者 | 高 | 核心用户，最大群体 |
| B 术数研究者 | 中 | 专业用户，影响口碑 |
| C 技术观察者 | 低 | 长尾用户，但影响开源传播 |
| D 初学者 | 中 | 潜在用户，需手册辅助 |

### 9.3 产品策略建议 Product Strategy Recommendations

1. **核心策略**：以 12 术合集 + 仪式感动效 + 真随机引擎建立差异化
2. **可信策略**：以 lunar 天文历 + 权威文献对照 + 开源建立信任
3. **覆盖策略**：以 Android + Windows 跨端覆盖移动与桌面场景
4. **降低门槛**：以使用手册 + 引导降低初学者认知门槛
5. **隐私优先**：以无账号 + 本地存储 + 离线可用建立隐私信任

### 9.4 后续调研方向 Future Research

- 持续收集 GitHub Issue / 用户反馈
- 关注术数研究者对算法正确性的反馈
- 关注桌面端用户的使用体验
- 关注开源社区对工程范本的反馈
- 视用户增长情况考虑正式用户访谈

---

## 附录 Appendix

### 附录A：用户画像汇总 Persona Summary

| 画像 Persona | 核心需求 Core Need | 关键痛点 Key Pain |
|-----------|----------------|----------------|
| A 传统文化爱好者 | 一站式 + 仪式感 | 多 App 切换、体验粗糙 |
| B 术数研究者 | 算法规范 + 桌面端 | 算法错误、桌面缺位 |
| C 技术观察者 | 开源 + 工程范本 | 缺少高质量范本 |
| D 初学者 | 手册 + 引导 | 认知门槛 |

### 附录B：场景汇总 Scenario Summary

| 场景 Scenario | 画像 Persona | 设备 Device | 时长 Duration |
|-----------|-----------|-----------|------------|
| S1 日常问事 | A | Android | 1-3 min |
| S2 命理研究 | B | Windows | 10-30 min |
| S3 术数学习 | D | Android | 5-20 min |
| S4 风水勘测 | A | Android | 持续 |
| S5 技术学习 | C | Windows | 数小时 |

### 附录C：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| Persona | 用户画像 |
| MoSCoW | Must/Should/Could/Won't 优先级模型 |
| Kano | Kano 满意度模型 |
| Starfield | 星点背景动画 |
| AnimationKind | 动画类型枚举 |
| lunar | 寿星天文历 Dart 库 |
| RNG | Random Number Generator，真随机引擎 |
| DivinationTech | 卜算术抽象接口 |
| registry | 卜算术注册表 |

### 附录D：参考文档 Reference Documents

- 产品需求文档 PRD
- 业务需求文档 BRD
- 功能规格说明书 Functional Spec
- 原型设计文档 Prototype Design
- AGENTS.md / CLAUDE.md（项目根目录）
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

---

**文档结束 End of Document**

**重要提示:** 本用户需求调研基于桌面研究与开发者自省，后续将根据 GitHub Issue / 用户反馈持续迭代。
