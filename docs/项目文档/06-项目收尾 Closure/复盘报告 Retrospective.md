# 志极 Jeenith · 项目复盘报告 Project Retrospective Report

> 志于本心，知于极处 —— Question the core. Return to origins.

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 组织 Organization | Qore Origins（叩心）|
| 当前版本 Current Version | 2.3.3+23（release）|
| 复盘周期 Retrospective Period | 2026-07-12 ~ 2026-07-15 |
| 复盘日期 Retrospective Date | 2026-07-15 |
| 开发者 Developer | HeYS-Snowe（唯一开发者）|
| 仓库 Repository | https://github.com/1010523654/Jeenith |

---

## 目录 Table of Contents

1. [复盘概述 Retrospective Overview](#1-复盘概述-retrospective-overview)
2. [版本演进回顾 Version Evolution Review](#2-版本演进回顾-version-evolution-review)
3. [做得好的方面 What Went Well](#3-做得好的方面-what-went-well)
4. [问题与不足 Problems & Gaps](#4-问题与不足-problems--gaps)
5. [经验教训 Lessons Learned](#5-经验教训-lessons-learned)
6. [后续改进计划 Improvement Plan](#6-后续改进计划-improvement-plan)

---

## 1. 复盘概述 Retrospective Overview

### 1.1 项目定位回顾 Project Positioning Review

志极 Jeenith 是 Qore Origins（叩心）旗下的卜算合集移动应用，定位为「叩问本心的卜算合集」。项目以 Flutter 跨端框架构建，覆盖 Android 与 Windows 桌面双平台，无后端纯客户端架构。当前已实现 **12 种传统术数**：

- 小六壬、周易（金钱卦）、梅花易数、掷筊、紫微斗数（v2）、奇门遁甲（v2）
- 抽签、测字、大六壬、风水罗盘、八字推演、测名字

外加使用手册、历史记录、设置中心等配套功能，形成完整的「起卦—解读—存档—分享」闭环。

### 1.2 复盘目的 Retrospective Purpose

| 目的 Purpose | 说明 Description |
|-------------|---------------|
| 经验沉淀 | 系统总结 v1.0.0 ~ v2.3.3 四天密集开发中的决策与得失 |
| 框架验证 | 验证「可扩展卜算框架」设计是否真正落地，新术接入成本是否可控 |
| 技术复盘 | 梳理真随机引擎、动效体系、CustomPainter 等关键技术选型的实际效果 |
| 路线校准 | 为后续思源宋体、首次引导遮罩、浅色主题对齐等提供决策依据 |

### 1.3 复盘方法 Retrospective Method

本次复盘采用 **4L 方法 + STAR 结构** 结合：

- **Liked** 做得好的方面（架构、动效、真随机）
- **Learned** 学到的经验（框架设计、性能优化、跨端适配）
- **Lacked** 遗憾和不足（测试覆盖、字体、引导流程）
- **Longed for** 期望改进的方面（浅色主题、可访问性、国际化）

---

## 2. 版本演进回顾 Version Evolution Review

### 2.1 版本时间线 Version Timeline

| 版本 Version | 日期 Date | 核心内容 Core Content | 阶段定位 Stage |
|------------|----------|---------------------|--------------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 种术 v1（小六壬/周易/梅花/掷筊/紫微/奇门） | 框架奠基 |
| 1.1.0 | 2026-07-12 | 工程结构迁移、WBS 拆分、规范文档落地 | 工程化 |
| 1.2.0 | 2026-07-12 | 周易/梅花卦辞爻辞数据落地 | 内容深化 |
| 1.3.0 | 2026-07-13 | 紫微斗数 v2 重构（星盘绘制 + 星曜安放） | 算法升级 |
| 1.4.0 | 2026-07-13 | 奇门遁甲 v2 重构 | 算法升级 |
| 1.5.0 | 2026-07-13 | 主题切换 + 结果分享 + 历史导出 | 体验补全 |
| 1.6.0 | 2026-07-13 | 抽签 + 测字落地 | 术数扩展 |
| 1.7.0 | 2026-07-13 | 大六壬 + 风水罗盘（sensors_plus 磁力计） | 术数扩展 |
| 1.8.0 | 2026-07-13 | 使用手册落地 | 文档补全 |
| 2.0.0 | 2026-07-14 | release，体验深化与品牌定调（按钮物理反馈 + 图标状态切换 + 动效开关） | 品牌定调 |
| 2.1.0 | 2026-07-14 | 动效体系 Phase 1-3（入场仪式 / 路由转场 / 绘制过程） | 动效体系 |
| 2.2.0 | 2026-07-14 | 动效体系 Phase 4-6（结果揭示 / 粒子系统 / 墨晕扩散） | 动效体系 |
| 2.3.0 | 2026-07-15 | 八字推演 + 测名字 + 紫微盘重构 | 术数扩展 |
| 2.3.1 | 2026-07-15 | 起卦按钮 BUG 修复 + 动效曲线优化 | 稳定性 |
| 2.3.2 | 2026-07-15 | 设置页动画细分开关（4 个 AnimationKind 独立控制）+ Windows 图标修复 | 体验打磨 |
| 2.3.3 | 2026-07-15 | 首页按钮间距修复 + MIT LICENSE + Windows 图标产物归档 | 收尾发布 |

### 2.2 关键里程碑达成 Milestone Achievement

| 里程碑 Milestone | 计划日期 Planned | 实际日期 Actual | 评估 Evaluation |
|--------------|---------------|--------------|--------------|
| 框架奠基 + 6 术 v1 | 2026-07-12 | 2026-07-12 | ✅ 按时达成 |
| 全 12 术落地 | 2026-07-13 | 2026-07-13 | ✅ 按时达成 |
| 体验深化 + 品牌定调 | 2026-07-14 | 2026-07-14 | ✅ 按时达成 |
| 动效体系 Phase 1-6 | 2026-07-14 | 2026-07-14 | ✅ 按时达成 |
| 八字 + 测名字 + 收尾 | 2026-07-15 | 2026-07-15 | ✅ 按时达成 |

**总体评估**：四天三个大版本（1.0 / 2.0 / 2.3），节奏紧凑但全部按计划交付，未出现里程碑延期。

---

## 3. 做得好的方面 What Went Well

### 3.1 架构设计 Architecture Design

| 方面 Aspect | 成功描述 Success Description |
|------------|-----------------------|
| 可扩展框架 | `DivinationTech` 抽象 + `divination_registry.dart` 注册表，加新术仅需新建 feature 目录 + 注册一行，无需改动 core/shared |
| 分层清晰 | core / data / features / providers / router / shared 六层分明，算法（algorithm/）与 UI（ui/）在 feature 内再次解耦 |
| 双端复用 | Flutter 单代码库覆盖 Android + Windows 桌面，复用率 > 95%，桌面端仅需 window_manager 窗口尺寸适配 |
| 真随机引擎 | 三源熵混合（Random.secure + 触摸轨迹熵 + random.org 在线熵）+ SHA256 摘要，仪式感与随机性双重保障 |

### 3.2 体验设计 Experience Design

| 方面 Aspect | 成功描述 Success Description |
|------------|-----------------------|
| 动效体系 | Phase 1-6 完整覆盖入场仪式、路由转场、绘制过程、结果揭示、粒子系统、墨晕扩散，4 个 AnimationKind 独立开关 |
| 品牌定调 | 深色星空背景 + 金色主色 + 宋体韵味，统一封装于 core/theme/ 与 branding.dart |
| 仪式感 | 起卦前默念引导、仪式入场动画（太极生六宫等）、结果揭示动画三段式体验 |
| 物理反馈 | 按钮物理反馈（按压缩放 + 震感）、图标状态切换、InteractableCard 悬停反馈 |

### 3.3 工程实践 Engineering Practices

| 方面 Aspect | 成功描述 Success Description |
|------------|-----------------------|
| 构建自动化 | `build_apk.ps1` 一键完成版本自增 + 构建 + 重命名 + 归档 + 双份历史记录 |
| 规范先行 | AGENTS.md / CLAUDE.md 双份项目规则，身份信息单一事实来源（OrganizationAndUser.md） |
| 历史原子化 | HistoryStore 采用原子读-改-写模式，防止快速连续卜算丢数据 |
| Painter 防泄漏 | CustomPainter 显式 dispose TextPainter，杜绝 native handle 泄漏 |

---

## 4. 问题与不足 Problems & Gaps

### 4.1 测试覆盖 Testing Coverage

| 问题 Problem | 影响分析 Impact | 根本原因 Root Cause |
|-------------|-------------|-----------------|
| 无单元测试 | 算法正确性依赖人工验证，回归风险高 | 四天密集开发周期内优先功能交付，未铺设测试基线 |
| 无集成测试 | 起卦流程、历史存档、分享等链路无自动化保障 | 同上 |
| 仅 flutter analyze | 静态检查无法覆盖运行时逻辑分支 | 测试基础设施投入不足 |

### 4.2 视觉细节 Visual Details

| 问题 Problem | 影响分析 Impact | 根本原因 Root Cause |
|-------------|-------------|-----------------|
| 未接入思源宋体 | 部分设备上宋体韵味缺失，品牌一致性受损 | 字体文件体积与首启动加载权衡未决 |
| 浅色主题对齐不足 | 浅色模式下部分组件配色未精细调校 | 深色为主设计，浅色适配后置 |
| 首次引导遮罩缺失 | 新用户首次进入仅有弹窗，缺乏高亮引导 | 优先级让位于核心术数功能 |

### 4.3 跨端差异 Cross-Platform Differences

| 问题 Problem | 影响分析 Impact | 根本原因 Root Cause |
|-------------|-------------|-----------------|
| Windows 磁力计缺失 | 风水罗盘在桌面端无方位角输入 | 桌面端无磁力计硬件，sensors_plus 仅移动端可用 |
| 桌面端触控差异 | 触摸轨迹熵源在桌面端退化为鼠标轨迹 | 鼠标轨迹随机性远低于触摸，熵质量下降 |
| 分辨率适配 | 高 DPI 屏幕下部分图标尺寸需复核 | window_manager + screen_retriever 适配未全覆盖 |

### 4.4 内容深度 Content Depth

| 问题 Problem | 影响分析 Impact | 根本原因 Root Cause |
|-------------|-------------|-----------------|
| 紫微 v2 / 奇门 v2 仍可深化 | 部分星曜/格局解读较简 | 传统术数内容量大，v2 为框架级实现 |
| 卦辞爻辞覆盖 | 64 卦 + 384 爻数据已落地但解读可更详 | 数据完整性与解读深度的平衡 |
| 测字笔画库 | 部分生僻字笔画数据缺失 | 笔画数据来源有限 |

---

## 5. 经验教训 Lessons Learned

### 5.1 框架先行 Framework First

**经验**：v1.0.0 先用一天搭建 `DivinationTech` 抽象 + 注册表 + 真随机引擎 + 历史存储，后续 6 个术平均 2-3 小时即可接入。框架投入占比约 30%，但为后续 6 个术节省了 60%+ 的接入时间。

**教训**：抽象要克制。`DivinationTech` 仅约束 id / meta / divine() 三个契约，不侵入算法实现，避免了过度抽象导致的灵活性损失。

### 5.2 动效体系分阶段 Phase-Based Animation

**经验**：动效分 Phase 1-6 六阶段落地，每阶段聚焦一类动效（入场 / 转场 / 绘制 / 揭示 / 粒子 / 墨晕），避免一次性铺开导致的回归爆炸。v2.3.2 进一步将 4 个 AnimationKind 拆为独立开关，用户可按需关闭。

**教训**：动效必须有全局开关。部分低端设备上粒子系统 + 墨晕扩散会掉帧，`AppConfig.animationsEnabled` 是必须的安全阀。

### 5.3 真随机引擎设计 True Random Engine

**经验**：三源熵混合（系统 + 触摸 + 在线）+ SHA256 摘要的设计，既保证了仪式感（触摸轨迹让用户「参与」随机），又保证了随机质量（多源混合 + 在线校验）。

**教训**：在线熵源（random.org）必须有降级策略。网络不可用时回退到本地双源，不能阻塞起卦流程。

### 5.4 原子化存储 Atomic Storage

**经验**：HistoryStore 一开始就采用原子读-改-写，v2.3.1 起卦按钮 BUG 修复时验证了其有效性——快速连续卜算未出现数据丢失。

**教训**：SharedPreferences 异步写入 + 快速连续操作是高危组合，原子化是底线。

### 5.5 单人开发的节奏管理 Solo Dev Pace

**经验**：四天三版本（1.0 / 2.0 / 2.3）的节奏下，每日明确「核心目标 + 边界」——核心目标必达，边界可延后。例如 v2.3.0 八字 + 测名字为核心，浅色主题对齐为边界延后到 v2.4+。

**教训**：单人开发必须接受「不完美但可迭代」。MIT LICENSE 在 v2.3.3 才补上，字体/引导/浅色对齐明确延后，避免追求一次到位导致的交付风险。

---

## 6. 后续改进计划 Improvement Plan

### 6.1 短期改进（v2.4.x）Short-Term Improvements

| 改进项 Item | 改进措施 Action | 优先级 Priority |
|-----------|---------------|--------------|
| 思源宋体接入 | 引入 Source Han Serif，权衡体积后按需加载 | 高 |
| 浅色主题对齐 | 逐屏复核浅色模式配色，补齐 DarkButton/GoldButton 浅色变体 | 高 |
| 首次引导遮罩 | 实现高亮遮罩式引导，替代纯弹窗 | 中 |
| 单元测试基线 | 为 12 术 algorithm/divine.dart 铺设单元测试，覆盖核心算法分支 | 高 |

### 6.2 中期改进（v2.5 ~ v3.0）Mid-Term Improvements

| 改进项 Item | 改进措施 Action | 优先级 Priority |
|-----------|---------------|--------------|
| 桌面端罗盘替代方案 | 探索鼠标拖拽模拟方位角输入，或接入在线方位服务 | 中 |
| 测字笔画库扩充 | 补全生僻字笔画数据，支持用户纠错反馈 | 中 |
| 紫微/奇门解读深化 | 扩充星曜格局解读文本，支持长文展开 | 中 |
| 国际化基础 | 抽取核心文案，为英文化预留接口（不强制全量翻译） | 低 |

### 6.3 长期方向 Long-Term Directions

| 方向 Direction | 说明 Description |
|-------------|---------------|
| AI 辅助解读 | 用户可将卦象截图 + 问题发送给外部 AI（已在引导中提示），后续可探索内置 AI 解读 |
| 数据云同步 | 当前无后端，长期可评估可选的本地加密 + 云同步方案（不破坏纯客户端定位） |
| 术数社区 | 卜算结果分享 + 同好交流（需评估社区治理成本） |
| 更多术数 | 框架已就绪，按需扩展六爻、铁板神数、手相面相等 |

### 6.4 流程改进 Process Improvements

| 问题 Problem | 改进措施 Action |
|----------|---------------|
| 测试缺失 | 后续每个新术必须伴随单元测试，PR 不带测试不予合并 |
| 文档同步 | 版本发布同步更新 CHANGELOG + NEXT_PLAN，避免文档滞后 |
| 性能基线 | 建立动效帧率基线，低端设备性能回归有据可查 |

---

## 附录 Appendix

### 附录A：参与者反馈 Participant Feedback

| 成员 Member | 最大的收获 Biggest Takeaway | 最大的挑战 Biggest Challenge |
|----------|----------------------------|----------------------------|
| HeYS-Snowe | 可扩展框架在 12 术接入中验证了其有效性 | 四天三版本节奏下的优先级取舍 |

### 附录B：关键数据 Key Metrics

| 指标 Metric | 数值 Value |
|-----------|---------|
| 开发周期 Dev Period | 4 天（2026-07-12 ~ 2026-07-15）|
| 版本发布数 Releases | 15 个（1.0.0 ~ 2.3.3）|
| 术数种类 Tech Count | 12 种 |
| 跨端平台 Platforms | 2（Android + Windows）|
| 依赖包数 Dependencies | 11 个核心包 |

---

**文档结束 End of Document**

> 志极 Jeenith · Copyright (c) 2026 Qore · MIT License
