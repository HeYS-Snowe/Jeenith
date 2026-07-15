# 测试报告 Test Report

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 测试版本 Build Under Test | 2.3.3+23 |
| 报告版本 Report Version | v1.0.0 |
| 测试周期 Test Period | 2026-07-XX ~ 2026-07-XX |
| 报告日期 Report Date | YYYY-MM-DD |
| 测试负责人 QA Lead | HeYS-Snowe |
| 仓库 Repository | https://github.com/1010523654/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | YYYY-MM-DD | HeYS-Snowe | 初始版本，覆盖 v2.3.3 release 全量测试结果 |

---

## 目录 Table of Contents

1. [测试概要 Test Summary](#1-测试概要-test-summary)
2. [测试范围与执行情况 Scope & Execution](#2-测试范围与执行情况-scope--execution)
3. [测试环境 Test Environment](#3-测试环境-test-environment)
4. [功能测试结果 Functional Test Results](#4-功能测试结果-functional-test-results)
5. [真随机引擎测试 RNG Test Results](#5-真随机引擎测试-rng-test-results)
6. [动效体系测试 Animation Test Results](#6-动效体系测试-animation-test-results)
7. [跨平台与传感器测试 Cross-Platform & Sensor](#7-跨平台与传感器测试-cross-platform--sensor)
8. [缺陷统计 Defect Statistics](#8-缺陷统计-defect-statistics)
9. [风险评估 Risk Assessment](#9-风险评估-risk-assessment)
10. [测试结论与发布建议 Conclusion & Recommendation](#10-测试结论与发布建议-conclusion--recommendation)

---

## 1. 测试概要 Test Summary

### 1.1 测试目标 Objectives

验证志极 Jeenith 2.3.3+23 在 Android 与 Windows 双平台的 12 种卜算术功能、真随机引擎质量、动效体系开关、传感器（风水罗盘磁力计）、历史持久化、配置持久化、跨平台 UX 一致性等是否达到 release 退出标准。

### 1.2 总体结论 Overall Result

| 项 Item | 结果 Result |
|--------|-----------|
| 测试结论 Conclusion | □ 通过 Pass □ 有条件通过 Conditional Pass □ 不通过 Fail |
| 发布建议 Recommendation | □ 可发布 Go □ 推迟发布 Hold □ 阻塞发布 Block |
| `flutter analyze` | □ 0 issue □ N issues |
| 真随机 χ² 检验 | □ p > 0.05 □ p ≤ 0.05 |
| 性能指标 | □ 全部达标 □ 部分达标 □ 不达标 |

---

## 2. 测试范围与执行情况 Scope & Execution

### 2.1 用例执行统计 Execution Statistics

| 优先级 Priority | 计划 Planned | 执行 Executed | 通过 Pass | 失败 Fail | 阻塞 Blocked | 通过率 Pass Rate |
|---------------|------------|-------------|----------|----------|------------|----------------|
| P0 | — | — | — | — | — | —% |
| P1 | — | — | — | — | — | —% |
| P2 | — | — | — | — | — | —% |
| P3 | — | — | — | — | — | —% |
| **合计 Total** | **—** | **—** | **—** | **—** | **—** | **—%** |

### 2.2 模块覆盖 Module Coverage

| 模块 Module | 计划 Planned | 执行 Executed | 通过 Pass | 失败 Fail |
|-----------|------------|-------------|----------|----------|
| XLR 小六壬 | — | — | — | — |
| ZY 周易 | — | — | — | — |
| MH 梅花易数 | — | — | — | — |
| JB 掷筊 | — | — | — | — |
| ZW 紫微斗数 | — | — | — | — |
| QM 奇门遁甲 | — | — | — | — |
| CQ 抽签 | — | — | — | — |
| CZ 测字 | — | — | — | — |
| DLR 大六壬 | — | — | — | — |
| LP 风水罗盘 | — | — | — | — |
| BZ 八字推演 | — | — | — | — |
| NT 测名字 | — | — | — | — |
| RNG 真随机 | — | — | — | — |
| ANI 动效 | — | — | — | — |
| UX 跨平台 | — | — | — | — |
| HIST 历史 | — | — | — | — |
| CFG 配置 | — | — | — | — |

---

## 3. 测试环境 Test Environment

### 3.1 设备 Devices

| 设备 Device | 平台 Platform | OS 版本 | 硬件 Hardware | 用途 Usage |
|------------|--------------|--------|--------------|-----------|
| Android 真机 | Android | 13+ | arm64, 含磁力计 | 触摸/罗盘/性能 |
| Windows 桌面 | Windows | 11 23H2 | x64, 无磁力计 | 鼠标/窗口/性能 |

### 3.2 构建信息 Build Info

| 项 Item | 值 Value |
|--------|---------|
| pubspec version | 2.3.3+23 |
| APK 文件名 | Jeenith_release_2.3.3_20260715_01.apk |
| APK SHA-256 | E3F5E13FA6E7BFB7F3A45D31BC2DE421D32CC5379E1E777B0F440794180F625D |
| APK 大小 | 55.00 MB |
| Windows ZIP | Jeenith_release_2.3.3_20260715_01_windows_x64.zip |
| Windows SHA-256 | FF691015789058AD59E730EB6F1338BBDEE860E6C62A5E214CEB4906C31074A8 |
| Windows ZIP 大小 | 13.27 MB |

---

## 4. 功能测试结果 Functional Test Results

### 4.1 12 种卜算术算法验证

| ID | 术 Divination | 用例数 Cases | 通过 Pass | 失败 Fail | 备注 Notes |
|----|-----------|------------|----------|----------|-----------|
| xiaoliuren | 小六壬 | — | — | — | 六宫映射核对 |
| zhouyi | 周易 | — | — | — | 64 卦生成 + 动爻 |
| meihua | 梅花易数 | — | — | — | 本/互/变卦 + 体用 |
| jiaobei | 掷筊 | — | — | — | 三掷组合 |
| ziwei | 紫微斗数 | — | — | — | 安星 + 12 宫 |
| qimen | 奇门遁甲 | — | — | — | 四盘九宫 |
| chouqian | 抽签 | — | — | — | 100 签抽一 |
| cezi | 测字 | — | — | — | 笔画 + 五行 |
| daliuren | 大六壬 | — | — | — | 四课三传 |
| luopan | 风水罗盘 | — | — | — | 24 山向 |
| bazi | 八字推演 | — | — | — | 四柱 + 大运 |
| name_test | 测名字 | — | — | — | 五格剖象 |

### 4.2 算法 oracle 对照结论

针对 12 种术各 3 组「输入 → 预期输出」手工核对：

- □ 全部通过
- □ 部分失败（详见缺陷列表）
- □ 阻塞（前置依赖未就绪）

主要发现：

> （填写测试中发现的关键问题，例如：奇门遁甲 X 用例在地盘飞布时阴遁排布与 oracle 不一致）

---

## 5. 真随机引擎测试 RNG Test Results

### 5.1 多源熵采集 Entropy Sources

| 熵源 Source | Android | Windows | 备注 |
|-----------|---------|---------|-----|
| 系统熵（Random.secure） | □ 可用 | □ 可用 | 必备源 |
| 触摸轨迹（TouchTracker） | □ 可用 | □ 可用（鼠标轨迹） | |
| 在线 random.org | □ 可用 | □ 可用 | 需联网 |

### 5.2 多源降级路径 Degradation Paths

| 场景 Scenario | 预期 Expected | 实际 Actual | 结果 Result |
|-------------|-------------|-----------|-----------|
| 在线断网 | 退化为系统熵+触摸 | | □ Pass □ Fail |
| 触摸轨迹过短 | 仅系统熵+在线 | | □ Pass □ Fail |
| 仅系统熵可用 | 输出仍合法 | | □ Pass □ Fail |
| 全部熵源失败 | 兜底用 Random.secure | | □ Pass □ Fail |

### 5.3 χ² 均匀性检验 Chi-Square Test

| 参数 Parameter | 值 Value |
|--------------|---------|
| 样本数 N | 10000 |
| vmax | 9 |
| 自由度 df | 8 |
| χ² 统计量 | — |
| 临界值（α=0.05） | 15.51 |
| p 值 | — |
| 结论 Conclusion | □ 接受均匀分布假设 □ 拒绝均匀分布假设 |

各值频次分布：

| 值 Value | 频次 Frequency | 期望 Expected | 偏差 Deviation |
|---------|--------------|--------------|--------------|
| 1 | — | 1111.1 | — |
| 2 | — | 1111.1 | — |
| 3 | — | 1111.1 | — |
| 4 | — | 1111.1 | — |
| 5 | — | 1111.1 | — |
| 6 | — | 1111.1 | — |
| 7 | — | 1111.1 | — |
| 8 | — | 1111.1 | — |
| 9 | — | 1111.1 | — |

---

## 6. 动效体系测试 Animation Test Results

### 6.1 4 类 AnimationKind 开关

| 开关 Switch | Android | Windows | 持久化 Persist |
|-----------|---------|---------|---------------|
| entrance | □ Pass | □ Pass | □ Pass |
| transition | □ Pass | □ Pass | □ Pass |
| painter | □ Pass | □ Pass | □ Pass |
| reveal | □ Pass | □ Pass | □ Pass |

### 6.2 总开关 animationsEnabled 优先级

| 场景 Scenario | 预期 Expected | 实际 Actual | 结果 Result |
|-------------|-------------|-----------|-----------|
| 总开关关 + 分项开 | 全部动效不播放 | | □ Pass □ Fail |
| 总开关开 + 分项关 | 仅关闭对应类别 | | □ Pass □ Fail |
| 重启 App | 配置保留 | | □ Pass □ Fail |

### 6.3 仪式动画时长抽样

| 术 Divination | 预期时长 Expected (ms) | 实际 Actual (ms) | 结果 Result |
|-----------|---------------------|----------------|-----------|
| 周易 | 5000 | — | □ |
| 紫微 | 6000 | — | □ |
| 奇门 | 5000 | — | □ |
| 大六壬 | 5000 | — | □ |
| 罗盘 | 4000 | — | □ |
| 梅花 | 4000 | — | □ |
| 掷筊 | 3000 | — | □ |
| 测字 | 5000 | — | □ |
| 抽签 | 5000 | — | □ |
| 跳过按钮延迟 | 3000 | — | □ |

---

## 7. 跨平台与传感器测试 Cross-Platform & Sensor

### 7.1 跨平台 UX 一致性

| 检查项 Item | Android | Windows | 结果 Result |
|-----------|---------|---------|-----------|
| 首页 12 张卡片渲染 | □ 正常 | □ 正常 | □ Pass |
| 起卦结果布局 | □ 一致 | □ 一致 | □ Pass |
| 路由转场动画 | □ 正常 | □ 正常 | □ Pass |
| 历史页加载 | □ 正常 | □ 正常 | □ Pass |
| 设置页交互 | □ 正常 | □ 正常 | □ Pass |
| 文字溢出 | □ 无 | □ 无 | □ Pass |
| 窗口最小尺寸 | N/A | □ 不溢出 | □ Pass |

### 7.2 风水罗盘传感器

| 测试项 Item | Android | Windows | 备注 |
|-----------|---------|---------|-----|
| 磁力计数据流 | □ Pass | □ N/A | 真机旋转 360° |
| 方位角计算 | □ Pass | □ N/A | 偏差 ≤ ±5° |
| 24 山向映射 | □ Pass | □ N/A | |
| 退出后传感器关闭 | □ Pass | □ N/A | 无后台耗电 |
| 无磁力计降级 | N/A | □ Pass | 不崩溃，提示或手动 |

### 7.3 持久化与历史

| 测试项 Item | 结果 Result | 备注 |
|-----------|-----------|-----|
| HistoryStore 原子读-改-写（5 连发） | □ Pass | 无丢失 |
| AppConfig 持久化 | □ Pass | 重启后保留 |
| 历史导出（path_provider + share_plus） | □ Pass | 文件可分享 |
| 主题模式切换 | □ Pass | system/light/dark |

---

## 8. 缺陷统计 Defect Statistics

### 8.1 按严重程度 By Severity

| 严重程度 Severity | 数量 Count | 已修复 Fixed | 未修复 Open | 阻塞 Block |
|----------------|----------|-----------|-----------|----------|
| Critical | — | — | — | — |
| High | — | — | — | — |
| Medium | — | — | — | — |
| Low | — | — | — | — |
| **合计 Total** | **—** | **—** | **—** | **—** |

### 8.2 按模块 By Module

| 模块 Module | Critical | High | Medium | Low | 合计 Total |
|-----------|----------|------|--------|-----|----------|
| XLR | — | — | — | — | — |
| ZY | — | — | — | — | — |
| MH | — | — | — | — | — |
| ... | — | — | — | — | — |
| RNG | — | — | — | — | — |
| ANI | — | — | — | — | — |
| UX | — | — | — | — | — |

### 8.3 关键缺陷列表 Key Defects

| Bug ID | 严重 Severity | 模块 Module | 标题 Title | 状态 Status |
|--------|------------|-----------|-----------|-----------|
| BUG-001 | — | — | — | — |

---

## 9. 风险评估 Risk Assessment

| 风险 Risk | 影响 Impact | 概率 Probability | 处理 Action |
|----------|-----------|----------------|-----------|
| 真随机 χ² 不达标 | release 阻塞 | 低 | 修复 RNG 后重测 |
| 罗盘真机偏差过大 | 用户感知不准 | 中 | release notes 提示校准 |
| Windows 缓存旧图标 | 用户感知图标未更新 | 中 | release notes 提供清缓存指令 |
| HistoryStore 高并发丢失 | 数据丢失 | 低 | 已用原子读-改-写，测试通过 |
| 单人 QA 漏测 | 潜在缺陷 | 高 | PR review + 探索性测试 |

---

## 10. 测试结论与发布建议 Conclusion & Recommendation

### 10.1 退出标准核对 Exit Criteria Checklist

- □ 所有 P0 / P1 用例 100% 通过
- □ P2 用例通过率 ≥ 95%
- □ `flutter analyze` 0 issue
- □ 无未关闭的 Critical / High Bug
- □ 真随机 χ² 检验 p > 0.05
- □ 性能指标全部达标（详见性能测试报告）
- □ Android APK 与 Windows ZIP 均已构建并归档
- □ `builds/build_history.json` 与 `builds/release_history.json` 已更新

### 10.2 测试结论 Conclusion

> （填写最终结论，例如：v2.3.3+23 已满足 release 退出标准，所有 P0/P1 用例通过，flutter analyze 0 issue，真随机 χ² 检验通过，性能指标全部达标。建议发布。）

### 10.3 发布建议 Recommendation

- □ **可发布 Go**：满足全部退出标准，建议按计划发布。
- □ **有条件发布 Conditional Go**：存在非阻塞问题，可在指定时间内修复后发布。
- □ **推迟发布 Hold**：存在阻塞问题，需修复并回归后重新评估。
- □ **阻塞发布 Block**：存在 Critical 缺陷，禁止发布。

### 10.4 后续行动 Follow-up

| 行动 Action | 负责人 Owner | 截止日期 Due |
|-----------|------------|-----------|
| 修复未关闭的 Medium/Low Bug | HeYS-Snowe | YYYY-MM-DD |
| 下一版本回归测试 | HeYS-Snowe | YYYY-MM-DD |

---

## 签署 Sign-off

| 角色 Role | 姓名 Name | 日期 Date | 签名 Signature |
|----------|---------|----------|--------------|
| 测试负责人 QA Lead | HeYS-Snowe | YYYY-MM-DD | |
| 开发负责人 Dev Lead | | YYYY-MM-DD | |
| 项目负责人 PM | | YYYY-MM-DD | |
