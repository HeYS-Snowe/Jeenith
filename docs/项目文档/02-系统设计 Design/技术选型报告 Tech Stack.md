# 技术选型报告 Technology Stack Report

> 志极 Jeenith · 卜算合集技术选型论证

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心） |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe |
| 许可证 License | MIT · Copyright (c) 2026 Qore |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-01 | 初版：核心栈选型论证 |
| v2.3.0 | 2026-06 | 新增 sensors_plus / share_plus / path_provider 论证 |
| v2.3.3 | 2026-07-15 | 同步当前依赖版本与选型理由 |

---

## 1. 选型概述 Selection Overview

### 1.1 选型目标 Selection Goals

志极 Jeenith 的技术选型围绕以下目标展开：

| 目标 Goal | 权重 Weight | 说明 |
|---------|-----------|-----|
| 跨平台一致性 | 高 | 一套代码同时覆盖 Android 移动端与 Windows 桌面 |
| 卜算严肃性 | 高 | 真随机引擎、不可预知起卦 |
| 沉浸式体验 | 高 | 仪式动画、星空背景、微交互 |
| 可扩展性 | 高 | 加新术低成本，核心零改动 |
| 维护成本 | 高 | 唯一开发者，依赖须稳定低负担 |
| 隐私自洽 | 中 | 纯本地无后端，可选在线熵源 |

### 1.2 选型原则 Selection Principles

- **成熟优先**：选择社区活跃、文档完善的稳定库
- **最小依赖**：能用标准库/自研解决的不引入第三方
- **许可兼容**：所有依赖须与 MIT 许可证兼容
- **跨平台一致**：所选库须 Android + Windows 双端可用

---

## 2. 核心技术栈 Core Stack

### 2.1 技术栈总览 Stack Summary

| 层级 Layer | 技术 Technology | 版本 Version | 用途 Usage |
|----------|--------------|------------|----------|
| 框架 | Flutter | 3.x（Dart 3.11+） | 跨平台 UI 框架 |
| 状态管理 | flutter_riverpod | ^2.5 | 响应式状态管理 |
| 路由 | go_router | ^14.0 | 声明式路由 |
| 历法 | lunar | ^1.7.8 | 寿星天文历（农历/八字/节气） |
| 图标 | flutter_svg | ^2.0 | SVG 矢量图标 |
| 配置持久化 | shared_preferences | ^2.2 | K/V 本地存储 |
| 设备传感器 | sensors_plus | ^6.0.0 | 陀螺仪/磁场（风水罗盘） |
| 结果分享 | share_plus | ^10.0.0 | 系统分享 |
| 文件路径 | path_provider | ^2.1.0 | 历史导出临时目录 |
| 哈希 | crypto | （Dart 生态） | SHA256 真随机混合 |
| HTTP | http | （Dart 生态） | random.org 在线熵源 |
| 真随机核心 | dart:math Random.secure | 内置 | 系统熵源 |
| APP 图标 | flutter_launcher_icons | ^0.14 | 生成各平台图标 |

### 2.2 身份与品牌 Identity & Branding

- 身份信息（组织/包名/署名）以 `D:\Code\.Rules\OrganizationAndUser.md` 为单一事实来源
- 品牌常量集中在 `core/branding.dart`（appName/orgCn/slogan/copyright）
- 版权：Copyright (c) 2026 Qore，MIT 许可证

---

## 3. 关键选型论证 Key Selection Rationale

### 3.1 Flutter（框架）

**选择**：Flutter 3.x（Dart 3.11+）

**候选对比**：

| 框架 | 跨平台 | 仪式动画支持 | 生态 | 维护成本 | 结论 |
|-----|------|-----------|-----|--------|-----|
| Flutter | Android+iOS+Windows+macOS+Linux+Web 一套 | 强（CustomPainter+AnimationController） | 成熟 | 低 | ✅ 选定 |
| React Native | 移动强，桌面弱 | 中（JS bridge 开销） | 成熟 | 中 | ❌ 桌面支持弱 |
| 原生 Android | 单平台 | 强 | — | 高 | ❌ 无法覆盖 Windows |
| Electron | 桌面强，移动弱 | 强（Web） | 成熟 | 高（内存） | ❌ 移动端不可用 |

**理由**：
- 一套 Dart 代码同时产出 Android APK 与 Windows 桌面应用，契合唯一开发者维护双端的现实
- CustomPainter + AnimationController 对仪式动画（铜钱抛落、命盘展开、罗盘扫描）的表达力极强
- 声明式 UI 与 Riverpod 配合，状态变更自动驱动 UI 重建，契合配置/熵源的响应式需求
- Dart 3.11+ 的 record/模式匹配简化了 `({int month, int day, String display})` 等返回

### 3.2 Riverpod（状态管理）

**选择**：flutter_riverpod ^2.5

**候选对比**：

| 方案 | 编译时安全 | 样板代码 | family 支持 | 结论 |
|-----|---------|--------|-----------|-----|
| Riverpod | ✅ | 中 | ✅ Provider.family | ✅ 选定 |
| Provider（旧） | ❌（运行时） | 低 | 弱 | ❌ 已过时 |
| Bloc | ✅ | 高（事件/状态类） | 需自建 | ❌ 样板过重 |
|GetX | ❌ | 极低 | — | ❌ 全局可变状态风险 |

**理由**：
- `Provider.family<DivinationTech?, String>` 天然契合路由 `:id` → 术实例的按需解析
- `AsyncNotifierProvider<ConfigNotifier, AppConfig>` 优雅处理配置的异步加载与状态流转
- 编译时安全，避免旧 Provider 的 `ProviderNotFoundException` 运行时崩溃
- 无 `BuildContext` 依赖，业务逻辑可脱离 UI 测试

### 3.3 go_router（路由）

**选择**：go_router ^14.0

**理由**：
- 声明式路由表（`routes: [GoRoute(...)]`）清晰可读，契合「先看再改」原则
- `pathParameters` 支持 `/tech/:id` 动态路由，配合 `techByIdProvider` 解析
- `pageBuilder` + `CustomPage` 可注入 `TechTransition` 签名转场，关闭时降级 fade
- 深层链接与 Web 端 URL 兼容（未来可扩展）

### 3.4 lunar（寿星天文历）

**选择**：lunar ^1.7.8（6tail/lunar，MIT）

**理由**：
- 业内权威的公历-农历转换库，覆盖 1900-2100，精度可靠
- 一站式提供干支、节气、星宿、八字、紫微安星所需的天文历基础
- 紫微斗数、八字推演、大六壬、奇门遁甲均依赖其输出，避免各术重复实现历法
- 纯 Dart 实现，无 native 依赖，跨平台一致
- MIT 许可证与项目兼容

`LunarService` 封装常用方法（`nowLunarMonthDay()`），各术直接调用 lunar 原始 API 完成复杂排盘。

### 3.5 真随机引擎（多源 SHA256）

**选择**：dart:math Random.secure + 触摸轨迹 + http(random.org) + crypto(SHA256)

**候选对比**：

| 方案 | 不可预知性 | 离线可用 | 跨平台 | 严肃性 | 结论 |
|-----|---------|--------|------|------|-----|
| dart:math Random | ❌（伪随机） | ✅ | ✅ | ❌ | ❌ 卜算不可用 |
| Random.secure 单源 | 中 | ✅ | ✅ | 中 | ❌ 单点 |
| **多源 SHA256 混合** | ✅ | ✅（在线可降级） | ✅ | ✅ | ✅ 选定 |
| 纯 random.org | ✅ | ❌ | ✅ | ✅ | ❌ 强依赖网络 |

**理由**：
- 卜算的严肃性要求起卦结果不可被预知/操纵，单源伪随机（`Random`）不可接受
- 三源混合（系统熵 + 触摸轨迹 + random.org 大气噪声）任一源失败仍可工作
- SHA256 链式混合 + 链式扩展，杜绝切片相关性
- 收尾加盐（时间戳 + 系统熵）防重放
- 在线源可由用户在设置页关闭，离线场景仍保证双源可用

### 3.6 SharedPreferences（持久化）

**选择**：shared_preferences ^2.2

**候选对比**：

| 方案 | 数据模型 | 依赖 | 跨平台 | 结论 |
|-----|--------|-----|------|-----|
| SharedPreferences | K/V | 零 | ✅ | ✅ 选定 |
| Hive | K/V + Box | 中 | ✅ | ❌ 过度 |
| Drift/SQLite | 关系型 | 重 | ✅ | ❌ 关系数据不存在 |
| 文件 JSON | 任意 | 零 | ✅ | ❌ 无并发保护 |

**理由**：
- 项目数据仅有「配置项（bool/string）」+「历史 JSON 数组」，纯 K/V 模型，无关系数据
- SharedPreferences 零额外依赖，跨平台一致，API 极简
- HistoryStore 通过 `_serialize` 串行化自行保证原子写，弥补 SharedPreferences 无事务的短板
- 避免 SQLite/Drift 的过度工程（YAGNI 原则）

### 3.7 sensors_plus（设备传感器）

**选择**：sensors_plus ^6.0.0

**理由**：
- 风水罗盘（luopan）需陀螺仪（朝向）与磁力计（方位角）实现真实指南针体验
- sensors_plus 是 Flutter 官方 plus 插件家族成员，维护稳定
- 在无传感器平台（桌面）自动降级为触摸/鼠标交互，不影响其他术

### 3.8 share_plus + path_provider（分享与导出）

**选择**：share_plus ^10.0.0 + path_provider ^2.1.0

**理由**：
- `share_plus` 调用系统分享面板，分享卜算结果文本/文件
- `path_provider` 获取临时目录，HistoryExport 导出 JSON/Markdown/CSV 后走分享
- 均为 Flutter 官方生态，跨平台一致

### 3.9 flutter_svg + flutter_launcher_icons

**选择**：flutter_svg ^2.0 + flutter_launcher_icons ^0.14

**理由**：
- SVG 矢量图标在任意 DPI 清晰，契合中国风线条美学
- `flutter_launcher_icons` 一键生成 Android/Windows 各尺寸图标，避免手动切图

---

## 4. 依赖清单 Dependency Inventory

### 4.1 运行时依赖 Runtime Dependencies

| 依赖 Package | 版本 Constraint | 用途 Role | 许可证 License |
|------------|---------------|---------|--------------|
| flutter | SDK | 框架 | BSD |
| flutter_riverpod | ^2.5 | 状态管理 | MIT |
| go_router | ^14.0 | 路由 | BSD |
| lunar | ^1.7.8 | 寿星天文历 | MIT |
| flutter_svg | ^2.0 | SVG 渲染 | MIT |
| shared_preferences | ^2.2 | K/V 存储 | BSD |
| sensors_plus | ^6.0.0 | 陀螺仪/磁场 | BSD |
| share_plus | ^10.0.0 | 系统分享 | BSD |
| path_provider | ^2.1.0 | 文件路径 | BSD |
| crypto | （Dart 生态） | SHA256 | BSD |
| http | （Dart 生态） | random.org 请求 | BSD |

### 4.2 开发依赖 Dev Dependencies

| 依赖 | 用途 |
|-----|-----|
| flutter_launcher_icons ^0.14 | 生成 APP 图标 |
| flutter_lints | 静态分析规则 |

### 4.3 许可证兼容性 License Compatibility

所有依赖许可证均为 BSD/MIT 系列，与项目 MIT 许可证完全兼容，无 GPL/AGPL 等 copyleft 风险。

---

## 5. 技术风险与缓解 Risk & Mitigation

| 风险 Risk | 等级 | 缓解 Mitigation |
|---------|----|---------------|
| random.org 在线不可用 | 低 | 静默降级为系统熵+触摸双源，离线可用 |
| 桌面端无陀螺仪/磁力计 | 中 | 风水罗盘降级为触摸/鼠标交互 |
| SharedPreferences 并发写丢失 | 中 | HistoryStore `_serialize` 串行化原子写 |
| lunar 历法精度边界（2100 后） | 极低 | 覆盖 1900-2100 足够，超界由库自身处理 |
| CustomPainter TextPainter 泄漏 | 中 | 项目规则强制 dispose，代码审查把关 |
| 大量历史记录 JSON 膨胀 | 低 | 提供 clear/export，单条文本量受控 |

---

## 6. 选型决策记录 Decision Records

| 决策 | 选择 | 否决项 | 关键理由 |
|-----|-----|-------|--------|
| 框架 | Flutter | RN/Electron/原生 | 一套代码双端 + 动画表达力 |
| 状态 | Riverpod | Provider/Bloc/GetX | 编译时安全 + family 路由解析 |
| 路由 | go_router | Navigator 1.0 | 声明式 + pageBuilder 转场 |
| 历法 | lunar | 自研 | 权威 + 一站式 + MIT |
| 随机 | 多源 SHA256 | Random/random.org 单源 | 严肃性 + 降级容错 |
| 持久化 | SharedPreferences | SQLite/Hive | K/V 足矣 + 零依赖 |
| 后端 | 无 | 任何后端 | 隐私自洽 + 离线 + 维护成本 |
| 图标 | flutter_svg | PNG | 矢量清晰 + 中国风线条 |

---

## 7. 未来演进 Future Evolution

| 方向 Direction | 当前 Current | 演进 Evolution |
|--------------|-----------|---------------|
| 字体 | 系统默认 + SourceHanSerif（如打包） | 思源宋体完整集成 |
| 主题 | 深色为主 + 浅色对齐 | 浅色细节完善 |
| 引导 | 无 | 首次使用引导遮罩 |
| Web 端 | 可编译未优化 | PlatformInfo.web 细化 |
| 数据同步 | 无 | 若需求出现，考虑端到端加密同步 |

所有演进遵循 YAGNI：暂未实现的不预留接口，按需推进。

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
