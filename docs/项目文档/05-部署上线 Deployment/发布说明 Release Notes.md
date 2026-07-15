# 发布说明 Release Notes

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 项目类型 Type | Flutter 移动 App（Android + Windows 桌面）|
| 包名 Package | com.qore.jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 发布负责人 Release Manager | HeYS-Snowe |
| 仓库 Repository | https://github.com/1010523654/Jeenith |
| 许可证 License | MIT |

> **本文档为发布说明模板**。实际发布的每个版本应参考 `builds/release_notes/release_notes_v{version}.md` 格式撰写，存于该目录下。

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始模板，对齐 builds/release_notes 实际格式 |

---

## 目录 Table of Contents

1. [版本信息 Version Information](#1-版本信息-version-information)
2. [版本概述 Version Overview](#2-版本概述-version-overview)
3. [新功能 New Features](#3-新功能-new-features)
4. [改进 Improvements](#4-改进-improvements)
5. [Bug 修复 Bug Fixes](#5-bug-修复-bug-fixes)
6. [破坏性变更 Breaking Changes](#6-破坏性变更-breaking-changes)
7. [已知问题 Known Issues](#7-已知问题-known-issues)
8. [下载 Download](#8-下载-download)
9. [安装与升级 Install & Upgrade](#9-安装与升级-install--upgrade)
10. [鸣谢 Acknowledgements](#10-鸣谢-acknowledgements)

---

## 1. 版本信息 Version Information

| 项目 Item | 值 Value |
|--------|---------|
| **版本号 Version** | vX.Y.Z |
| **构建号 Build Number** | N |
| **pubspec version** | X.Y.Z+N |
| **发布日期 Release Date** | YYYY-MM-DD |
| **版本类型 Type** | □ 正式版 release □ 测试版 beta □ 修复版 fix □ 功能版 feature □ 紧急修复 hotfix |
| **GitHub Tag** | vX.Y.Z |
| **GitHub Release URL** | https://github.com/1010523654/Jeenith/releases/tag/vX.Y.Z |
| **前置版本 Previous Version** | vX.Y.(Z-1) |
| **兼容性 Compatibility** | □ 与上一版本兼容 □ 需重新安装 |

---

## 2. 版本概述 Version Overview

### 概要 Summary

> （2-4 句话概述本版本主要变更。示例：v2.3.3 是志极 v2.3.x 系列的微调版本。本版本修复了首页右上角「使用手册」与「设置」两个按钮间距过近的视觉问题；正式添加项目 MIT LICENSE 并在 README 中声明开源协议；同时本次 Windows 桌面产物首次包含正确嵌入的志极品牌图标。`flutter analyze` 0 issue 通过。）

### 主要亮点 Highlights

1. （变更 1）
2. （变更 2）
3. （变更 3）

### 版本规模 Scale

| 维度 Dimension | 数量 Count |
|-------------|----------|
| 新功能 New Features | — |
| 改进 Improvements | — |
| Bug 修复 Bug Fixes | — |
| 破坏性变更 Breaking Changes | — |
| 提交 Commits | — |
| 修改文件 Files Changed | — |

---

## 3. 新功能 New Features

> 列出本版本新增的功能。如无新功能，写「本版本无新功能」。

### 3.1 {Feature Name}

**所属术 / 模块**：{XLR / ZY / MH / ... / RNG / ANI / UX / HIST / CFG / Other}

**描述 Description**：

（详细描述新功能的行为、用途、用户操作步骤）

**使用方式 Usage**：

1. ...
2. ...

**示例 Screenshot**：

（如有截图，附上）

---

## 4. 改进 Improvements

> 列出本版本对现有功能的优化。

### 4.1 {Improvement Title}

**模块**：{Module}

**变更前 Before**：

**变更后 After**：

**影响 Impact**：

---

## 5. Bug 修复 Bug Fixes

> 列出本版本修复的 Bug，关联 Bug ID。

| Bug ID | 严重 Severity | 模块 Module | 标题 Title | 修复方式 Fix |
|--------|-----------|-----------|-----------|-----------|
| BUG-YYYYMMDD-NNN | — | — | — | — |

### 详细说明 Details

#### BUG-YYYYMMDD-NNN | {Bug Title}

**问题 Problem**：

**根因 Root Cause**：

**修复 Fix**：

**关联 Commit**：`{commit-sha}`

---

## 6. 破坏性变更 Breaking Changes

> 列出与上一版本不兼容的变更。如无，写「本版本无破坏性变更」。

### 6.1 {Breaking Change Title}

**变更内容 Change**：

**影响范围 Impact**：

**迁移指南 Migration**：

---

## 7. 已知问题 Known Issues

> 列出本版本已知但未修复的问题，及临时规避方案。

| 编号 ID | 严重 Severity | 模块 Module | 标题 Title | 临时规避 Workaround | 计划修复 Planned Fix |
|--------|-----------|-----------|-----------|------------------|------------------|
| — | — | — | — | — | — |

### 详细说明 Details

#### {Known Issue Title}

**现象 Symptom**：

**影响平台 Affected Platform**：□ Android □ Windows □ Both

**临时规避 Workaround**：

**根因分析 Root Cause**：

**计划修复 Planned Fix**：vX.Y.Z 版本

---

## 8. 下载 Download

### 8.1 下载链接 Download Links

| 平台 Platform | 文件名 Filename | 大小 Size | SHA-256 |
|------------|--------------|---------|---------|
| Android | Jeenith_{status}_{version}_{date}_{seq}.apk | — MB | — |
| Windows x64 | Jeenith_{status}_{version}_{date}_{seq}_windows_x64.zip | — MB | — |

### 8.2 校验方法 Verification

下载后请核对 SHA-256：

```powershell
# Windows PowerShell
Get-FileHash Jeenith_*.apk -Algorithm SHA256
Get-FileHash Jeenith_*.zip -Algorithm SHA256
```

```bash
# Linux / macOS
shasum -a 256 Jeenith_*.apk
shasum -a 256 Jeenith_*.zip
```

期望输出与上表 SHA-256 一致。

### 8.3 下载地址 Download URL

- GitHub Release：https://github.com/1010523654/Jeenith/releases/tag/vX.Y.Z
- 直达 APK：https://github.com/1010523654/Jeenith/releases/download/vX.Y.Z/{apk-filename}
- 直达 Windows ZIP：https://github.com/1010523654/Jeenith/releases/download/vX.Y.Z/{zip-filename}

---

## 9. 安装与升级 Install & Upgrade

### 9.1 Android 安装

1. 下载 APK 文件
2. 在系统设置中允许「未知来源应用安装」（如已开启可跳过）
3. 点击 APK 安装
4. 启动「志极」

### 9.2 Android 升级

- 直接安装新版 APK 覆盖旧版本
- 历史记录与配置（shared_preferences）会保留
- **降级注意**：从高版本降级到低版本可能导致配置格式不兼容，建议先清空 App 数据

### 9.3 Windows 安装

1. 下载 ZIP 文件
2. 解压到任意目录（如 `D:\Jeenith\`）
3. 双击 `jeenith.exe` 运行
4. **首次运行**：Windows SmartScreen 可能拦截，点击「更多信息」→「仍要运行」

### 9.4 Windows 升级

- 解压新版 ZIP 到同一目录覆盖旧文件
- 配置文件存储在 `%APPDATA%\com.qore\jeenith\`，不会被覆盖

### 9.5 Windows 图标缓存提示

若新版本 exe 图标在资源管理器中显示为旧图标：

- 任务管理器（`Ctrl+Shift+Esc`）→ 重启「Windows 资源管理器」
- 或命令行执行 `ie4uinit.exe -show`

---

## 10. 鸣谢 Acknowledgements

### 开发团队 Team

- **开发 / 维护**：HeYS-Snowe
- **组织**：Qore（叩心）

### 第三方依赖 Third-party Dependencies

志极使用以下开源库，在此鸣谢：

- [Flutter](https://flutter.dev) - Google 的 UI 工具包
- [Riverpod](https://riverpod.dev) - 状态管理
- [go_router](https://pub.dev/packages/go_router) - 声明式路由
- [lunar](https://pub.dev/packages/lunar) - 寿星天文历（农历/干支/节气）
- [flutter_svg](https://pub.dev/packages/flutter_svg) - SVG 渲染
- [shared_preferences](https://pub.dev/packages/shared_preferences) - 本地配置
- [sensors_plus](https://pub.dev/packages/sensors_plus) - 设备传感器
- [share_plus](https://pub.dev/packages/share_plus) - 系统分享
- [path_provider](https://pub.dev/packages/path_provider) - 文件路径
- [crypto](https://pub.dev/packages/crypto) - SHA256 哈希
- [window_manager](https://pub.dev/packages/window_manager) - 桌面窗口管理
- [screen_retriever](https://pub.dev/packages/screen_retriever) - 屏幕分辨率
- [random.org](https://www.random.org) - 在线大气噪声真随机数

### 反馈 Feedback

- 问题反馈：https://github.com/1010523654/Jeenith/issues
- 仓库：https://github.com/1010523654/Jeenith

### 版权 License

Copyright (c) 2026 Qore. 本项目基于 MIT 许可证开源，详见 [LICENSE](https://github.com/1010523654/Jeenith/blob/main/LICENSE)。

---

## 附录：版本历史摘要 Version History Summary

> 完整版本历史见 [builds/release_history.json](../../../builds/release_history.json) 与 [builds/release_notes/](../../../builds/release_notes/)。

| 版本 Version | 发布日期 Date | 类型 Type | 标题 Title |
|------------|-----------|---------|-----------|
| v2.3.3 | 2026-07-15 | release | 首页按钮间距修复 + MIT LICENSE + Windows 图标产物归档 |
| v2.3.2 | 2026-07-15 | release | 设置页动画细分开关 + Windows 应用图标修复 |
| v2.3.1 | 2026-07-15 | release | 动效体系 Phase 3-6 全面落地 + 起卦按钮 BUG 修复 |
| v2.3.0 | 2026-07-15 | feature | 新增八字推演与测名字，紫微命盘重构，设置页动画 Map 化 |
| v2.2.0 | 2026-07-14 | feature | 动效体系 Phase 2b + Phase 4.3 + Phase 5.1（仪式动画补全 + 路由转场差异化）|
| v2.1.0 | 2026-07-14 | feature | 动效体系 Phase 1 + Phase 2a（5 套仪式动画落地）|
| v2.0.0 | 2026-07-14 | release | 体验深化与品牌定调（按钮/图标微交互升级）|
| v1.8.0 | 2026-07-13 | feature | 使用手册页面 + 圆角修复 + 历史复制 + 默认深色 |
| v1.7.0 | 2026-07-13 | feature | 大六壬全套 + 风水罗盘 |
| v1.6.0 | 2026-07-13 | feature | 抽签求签 + 测字 |
| v1.5.0 | 2026-07-13 | feature | 主题切换 + 结果分享 + 历史导出 |
| v1.4.0 | 2026-07-13 | feature | 奇门遁甲 v2 四盘九宫 |
| v1.3.0 | 2026-07-13 | feature | 紫微斗数 v2 全套星曜安星 |
| v1.2.0 | 2026-07-13 | feature | 卦辞爻辞数据与文本展示（周易/梅花）|
| v1.1.3 | 2026-07-12 | fix | 全面代码质量审计修复 + 桌面端窗口尺寸修复 |
| v1.1.2 | 2026-07-12 | fix | Windows 桌面适配 + 真机在线熵源修复 |
| v1.1.0 | 2026-07-12 | release | 工程迁移至 mobile/ 子目录 |
| v1.0.1 | 2026-07-11 | release | 新增 Windows 桌面平台 |
| v1.0.0 | 2026-07-11 | release | 志极首个正式版本 |
