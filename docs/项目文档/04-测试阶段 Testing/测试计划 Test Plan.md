# 测试计划 Test Plan

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 项目类型 Type | Flutter 移动 App（Android + Windows 桌面）|
| 当前版本 Current Version | 2.3.3+23（release） |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 测试负责人 QA Lead | HeYS-Snowe |
| 对应开发版本 Dev Version | 2.3.3+23 |
| 仓库 Repository | https://github.com/1010523654/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 审核人 Reviewer | 修改内容 Description |
|-------------|---------|---------------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | | 初始版本，覆盖 v2.3.3 release 全量测试 |

---

## 目录 Table of Contents

1. [测试概述 Test Overview](#1-测试概述-test-overview)
2. [测试策略 Test Strategy](#2-测试策略-test-strategy)
3. [测试范围 Test Scope](#3-测试范围-test-scope)
4. [测试环境 Test Environment](#4-测试环境-test-environment)
5. [测试资源 Test Resources](#5-测试资源-test-resources)
6. [测试进度 Test Schedule](#6-测试进度-test-schedule)
7. [测试交付物 Test Deliverables](#7-测试交付物-test-deliverables)
8. [风险管理 Risk Management](#8-风险管理-risk-management)
9. [退出标准 Exit Criteria](#9-退出标准-exit-criteria)

---

## 1. 测试概述 Test Overview

### 1.1 项目背景 Background

志极 Jeenith 是 Qore（叩心）出品的卜算合集移动 App，集成 12 种传统术数：小六壬、周易、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字，外加使用手册。App 为纯客户端（无后端），随机性由真随机引擎（系统熵 + 触摸轨迹 + random.org）保证，风水罗盘使用设备磁力计/陀螺仪。

### 1.2 测试目标 Objectives

- **功能正确性**：12 种卜算术的算法结果与古典算法预期一致（已知输入 → 已知输出）。
- **真随机质量**：多源 SHA256 混合熵源的输出通过 χ² 均匀性检验（p > 0.05）。
- **跨平台一致性**：Android（触摸）与 Windows（鼠标）双端 UX 一致，无平台回归。
- **性能达标**：冷启动 ≤ 2.5s，卜算起卦响应 ≤ 1.5s，路由转场 ≥ 55 FPS。
- **动效可控**：4 类 AnimationKind（entrance / transition / painter / reveal）开关生效。
- **静态质量**：`flutter analyze` 0 issue。
- **历史完整性**：HistoryStore 原子读-改-写在快速连续卜算时不丢数据。
- **资源释放**：所有 CustomPainter 显式 dispose TextPainter，无 native handle 泄漏。

---

## 2. 测试策略 Test Strategy

### 2.1 测试层级 Levels

| 层级 Level | 范围 Scope | 工具 Tool | 占比 Weight |
|-----------|-----------|----------|-----------|
| 单元测试 Unit | 算法 pure function（divine.dart）、RNG、历法转换 | flutter_test | 50% |
| 组件测试 Widget | 各 feature UI 页面、共享组件（GoldButton / InteractableCard / Starfield）| flutter_test | 25% |
| 集成测试 Integration | 起卦 → 结果 → 历史 全流程、路由跳转 | integration_test | 15% |
| 手工测试 Manual | 真机 UX、传感器（罗盘）、动效观感、分享 | 人工 | 10% |

### 2.2 测试方法 Methods

- **黑盒**：12 种术每种至少 3 组已知输入 → 预期输出对照。
- **白盒**：分支覆盖 RNG 的多源降级路径（在线不可用、采样失败、单源兜底）。
- **回归**：每个 release 前重跑全量回归集（v1.0.0 → 当前版本的所有用例）。
- **探索性**：在真机上随机点击 5 分钟，观察异常崩溃或动效卡顿。
- **统计**：对 RNG 输出 N=10000 次取样做 χ² 检验。

---

## 3. 测试范围 Test Scope

### 3.1 In Scope（必须测试）

#### 3.1.1 12 种卜算术 Divination Algorithms

| ID | 名称 | 算法验证重点 |
|----|------|-----------|
| xiaoliuren | 小六壬 | 大安/留连/速喜/赤口/小吉/空亡 六宫映射 |
| zhouyi | 周易 | 64 卦生成、动爻判定、卦辞爻辞匹配 |
| meihua | 梅花易数 | 数字起卦、本/互/变卦、体用生克 |
| jiaobei | 掷筊 | 三掷结果（圣筊/笑筊/阴筊/无筊）组合 |
| ziwei | 紫微斗数 | 命盘安星、十二宫、主副煞星定位 |
| qimen | 奇门遁甲 | 四盘（天/地/人/神）九宫飞布 |
| chouqian | 抽签 | 100 签随机抽一、签文匹配 |
| cezi | 测字 | 字形笔画统计、五行归类 |
| daliuren | 大六壬 | 四课三传、天地盘 |
| luopan | 风水罗盘 | 磁力计方位角、24 山向映射 |
| bazi | 八字推演 | 年/月/日/时四柱、十神、大运 |
| name_test | 测名字 | 五格剖象法（天/人/地/外/总）、三才 |

#### 3.1.2 真随机引擎 TrueRandom

- 系统熵源（Random.secure）可用性
- 触摸轨迹熵采集（TouchTracker）
- 在线 random.org 大气噪声（OnlineEntropySource）
- 多源 SHA256 链式混合
- 单源降级（offline 时仅用系统熵 + 触摸）
- 输出范围 [1, vmax] 边界

#### 3.1.3 动效体系 Animation System

- 4 类 AnimationKind 独立开关（entrance / transition / painter / reveal）
- 总开关 animationsEnabled 与分项开关的优先级
- 12 种仪式动画时长（详见 `core/theme/animations.dart`）
- 路由转场 TechTransition 差异化曲线
- 跳过按钮 3000ms 延迟显示

#### 3.1.4 跨平台与传感器

- Android：触摸事件、应用生命周期、分享 Intent
- Windows：鼠标事件、窗口尺寸（window_manager）、应用图标（.ico 嵌入）
- 风水罗盘：磁力计 / 加速度计（sensors_plus）数据流
- 主题：system / light / dark 三模式切换

#### 3.1.5 数据与持久化

- HistoryStore 原子读-改-写
- AppConfig 持久化（shared_preferences）
- 历史导出（path_provider + share_plus）
- lunar 历法跨年/闰月边界

### 3.2 Out of Scope（本期不测试）

- 后端 API（项目无后端）
- iOS / macOS / Linux 平台（仅 Android + Windows）
- 应用商店上架审核（暂走 GitHub Release 分发）
- 第三方库 lunar / flutter_svg 的内部测试（信任上游）

---

## 4. 测试环境 Test Environment

### 4.1 开发/构建环境

| 项 Item | 配置 Config |
|--------|------------|
| 操作系统 OS | Windows 11 23H2 |
| Flutter SDK | 3.x（Dart 3.11+）|
| IDE | Trae / VS Code |
| 设备真机 | Android 13+（arm64）+ Windows 11 桌面 |
| 网络 | 在线测试需可访问 random.org |

### 4.2 测试设备矩阵

| 设备 Device | 平台 Platform | 版本 Version | 用途 Usage |
|------------|--------------|--------------|-----------|
| Pixel 6 / 等效 Android 真机 | Android | 13+ | 触摸、罗盘、APK 性能 |
| Windows 11 桌面 | Windows | 11 23H2 | 鼠标、窗口、exe 性能 |
| Android 模拟器 | Android | 14 | 回归套件自动化 |
| Windows 桌面（debug） | Windows | 11 | 集成测试 automation |

### 4.3 关键依赖版本

- flutter_riverpod ^2.5.0
- go_router ^14.0.0
- lunar ^1.7.8
- sensors_plus ^6.0.0
- share_plus ^10.0.0
- crypto ^3.0.0（SHA256 混合）

---

## 5. 测试资源 Test Resources

### 5.1 人力资源

| 角色 Role | 职责 Responsibility | 投入 Effort |
|----------|--------------------|----|
| 开发 / QA（同一人） | 全部用例设计、执行、报告 | 100% |
| 代码审查 Reviewer | PR 合并前审查 | 30% |

### 5.2 测试数据

- 12 种术各 3 组「输入 → 预期输出」对照（手工核对的算法 oracle）。
- RNG χ² 检验样本：N=10000，vmax=9。
- 历法边界：1900-2100 年的农历闰月、节气交接点。

---

## 6. 测试进度 Test Schedule

| 阶段 Phase | 任务 Task | 预计 Days | 状态 Status |
|-----------|---------|----------|-----------|
| P1 | 用例设计 + 单元测试编写 | 3 | □ |
| P2 | 组件测试 + 真随机 χ² 检验 | 2 | □ |
| P3 | 集成测试 + 跨平台回归 | 2 | □ |
| P4 | 性能测试 + 传感器真机测试 | 1 | □ |
| P5 | 安全测试（熵源/存储/网络） | 1 | □ |
| P6 | 探索性测试 + BUG 修复 | 1 | □ |
| P7 | 测试报告 + release 决策 | 1 | □ |

---

## 7. 测试交付物 Test Deliverables

1. 本测试计划 Test Plan（本文档）
2. 测试用例集 Test Cases（见 `测试用例模板 Test Case.md`）
3. 测试报告 Test Report（见 `测试报告 Test Report.md`）
4. 性能测试报告 Performance Test Report
5. 安全测试报告 Security Test Report
6. Bug 列表 Bug List（见 `Bug报告模板 Bug Report.md`）
7. `flutter analyze` 输出截图（须 0 issue）

---

## 8. 风险管理 Risk Management

| 风险 Risk | 影响 Impact | 概率 Probability | 缓解 Mitigation |
|----------|-----------|------|-------------|
| random.org 在线熵源不可用 | 真随机质量下降 | 中 | 单元测试覆盖离线降级路径 |
| 真机磁力计差异 | 罗盘方位不准 | 中 | 提供「真北/磁北」选择 + 多机校准 |
| lunar 闰月边界 | 八字/紫微四柱错算 | 低 | 单元测试覆盖 1900-2100 边界 |
| Windows 缓存旧 exe 图标 | 用户感知图标未更新 | 中 | release notes 提示清缓存指令 |
| 单人 QA 带来的盲区 | 漏测路径 | 高 | 用 PR review + 探索性测试补充 |

---

## 9. 退出标准 Exit Criteria

release 上线必须同时满足：

- ✅ 所有 P0 / P1 用例 100% 通过
- ✅ P2 用例通过率 ≥ 95%
- ✅ `flutter analyze` 0 issue
- ✅ 无未关闭的 Critical / High Bug
- ✅ 真随机 χ² 检验 p > 0.05
- ✅ 性能指标全部达标（详见性能测试报告）
- ✅ Android APK 与 Windows ZIP 均已构建并归档
- ✅ `builds/build_history.json` 与 `builds/release_history.json` 已更新
