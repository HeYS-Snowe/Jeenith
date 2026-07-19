# 志极 Jeenith · 运维手册 Operations Manual

> 志于本心，知于极处 —— Question the core. Return to origins.

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 组织 Organization | Qore Origins（叩心）|
| 包名 Package Name | com.qore.jeenith |
| 当前版本 Current Version | 2.3.3+23（release）|
| 手册版本 Manual Version | v1.0 |
| 更新日期 Updated Date | 2026-07-15 |
| 运维负责人 Operations Owner | HeYS-Snowe（开发者）|
| 项目位置 Project Location | D:\Code\Project\Qore\Jeenith |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |

---

## 目录 Table of Contents

1. [运维概述 Operations Overview](#1-运维概述-operations-overview)
2. [开发环境 Development Environment](#2-开发环境-development-environment)
3. [构建流程 Build Pipeline](#3-构建流程-build-pipeline)
4. [版本管理 Version Management](#4-版本管理-version-management)
5. [发布与归档 Release & Archive](#5-发布与归档-release--archive)
6. [故障排查 Troubleshooting](#6-故障排查-troubleshooting)
7. [维护与监控 Maintenance & Monitoring](#7-维护与监控-maintenance--monitoring)

---

## 1. 运维概述 Operations Overview

### 1.1 运维目标 Operations Goals

志极 Jeenith 是**纯客户端无后端**应用，运维聚焦于「构建—发布—归档—故障排查」四环节，无服务端运维。

| 目标 Goal | 指标 Indicator | 目标值 Target |
|----------|---------------|-------------|
| 构建成功率 Build Success | 构建通过率 | 100% |
| 版本归档完整性 Archive Integrity | 双份历史记录 | 100% 同步 |
| 产物命名规范 Naming Compliance | 命名规则一致性 | 100% |
| 故障响应 Fault Response | 关键 BUG 修复 | < 24h |

### 1.2 运维职责 Operations Responsibilities

| 角色 Role | 职责 Responsibility |
|----------|---------------|
| 开发者 Developer（HeYS-Snowe）| 构建、发布、归档、故障修复、版本管理 |
| 用户 User | 通过 GitHub Issues 反馈问题 |

### 1.3 运维特点 Operations Characteristics

| 特性 Feature | 说明 Description |
|-----------|---------------|
| 纯客户端 | 无后端，无服务器运维 |
| 无数据库 | 数据本地存储（SharedPreferences），无 DBA 需求 |
| 无 CI/CD | 手动触发构建脚本（build_apk.ps1）|
| 无监控 | 无线上监控，依赖用户反馈 |
| 双端构建 | Android APK + Windows ZIP |

---

## 2. 开发环境 Development Environment

### 2.1 环境要求 Environment Requirements

| 组件 Component | 版本要求 Version | 说明 Description |
|-------------|---------------|---------------|
| 操作系统 OS | Windows 10+ | 开发主机（PowerShell 7+）|
| Flutter SDK | 3.x（Dart 3.11+）| 跨端框架 |
| Android Studio | 最新稳定版 | Android 构建 + 模拟器 |
| Visual Studio | 2022（含 C++ 桌面开发）| Windows 桌面构建工具链 |
| Git | 最新版 | 版本控制 |
| PowerShell | 7+（pwsh）| 构建脚本运行环境 |
| Python | 3.x | 历史归档脚本（archive_history.py）|

### 2.2 环境搭建 Environment Setup

```
步骤1：安装 Flutter SDK（https://docs.flutter.dev/get-started/install）
步骤2：安装 Android Studio + Android SDK
步骤3：安装 Visual Studio 2022（勾选「使用 C++ 的桌面开发」）
步骤4：安装 Git + PowerShell 7+
步骤5：克隆仓库 git clone https://github.com/HeYS-Snowe/Jeenith.git
步骤6：cd mobile && flutter pub get
步骤7：flutter doctor（确认环境完整）
```

### 2.3 环境验证 Environment Verification

```powershell
# 验证 Flutter 环境
flutter doctor -v

# 验证 PowerShell 版本
pwsh -v

# 验证项目依赖
cd D:\Code\Project\Qore\Jeenith\mobile
flutter pub get
flutter analyze
```

**预期结果**：

- `flutter doctor` 全绿（无红叉）
- `flutter analyze` 无 error（warning 可接受）
- `flutter pub get` 成功获取所有依赖

---

## 3. 构建流程 Build Pipeline

### 3.1 Android APK 构建 Android APK Build

**标准构建命令**：

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
pwsh -File scripts/build_apk.ps1 -Status release
```

**指定版本构建**：

```powershell
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.4.0"
```

**调试构建**：

```powershell
pwsh -File scripts/build_apk.ps1 -Status debug -BuildType debug
```

**构建脚本自动完成**：

| 步骤 Step | 操作 Operation |
|---------|-------------|
| 1 | 读取 pubspec.yaml 当前版本号 |
| 2 | 计算新版本号（release: minor++，其他: patch++）|
| 3 | 更新 pubspec.yaml 版本号 |
| 4 | 执行 `flutter build apk --release` |
| 5 | 备份原始 APK 到 `build/app/outputs/flutter-apk/backup/` |
| 6 | 重命名 APK 为 `Jeenith_<status>_<version>_<date>_<seq>.apk` |
| 7 | 归档到 `builds/android/` |
| 8 | 追加双份 `build_history.json`（项目内 + builds/）|
| 9 | 输出构建摘要（路径/大小/版本/序号）|

**构建失败回滚**：

- 构建失败时，脚本自动将 pubspec.yaml 版本号回滚到构建前状态
- 退出码 1，便于 CI 集成

### 3.2 Windows 桌面构建 Windows Desktop Build

**标准构建命令**：

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
flutter build windows --release
```

**产物位置**：

```
mobile\build\windows\x64\runner\Release\jeenith.exe
```

**手动归档**：

```powershell
# 进入产物目录
cd D:\Code\Project\Qore\Jeenith\mobile\build\windows\x64\runner\Release

# 压缩为 ZIP（手动）
Compress-Archive -Path * -DestinationPath "Jeenith_release_2.3.3_20260715_01.zip"

# 移动到归档目录
Move-Item "Jeenith_release_2.3.3_20260715_01.zip" "D:\Code\Project\Qore\Jeenith\builds\windows\"
```

**Windows 图标生成**：

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
flutter pub run flutter_launcher_icons
```

### 3.3 预构建检查 Pre-Build Checks

构建前必须执行：

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile

# 1. 获取最新依赖
flutter pub get

# 2. 静态分析（必须无 error）
flutter analyze

# 3. 确认版本号
Get-Content pubspec.yaml | Select-String "version:"
```

### 3.4 构建产物清单 Build Artifacts

| 平台 Platform | 产物 Artifact | 位置 Location |
|-------------|------------|-------------|
| Android | APK 文件 | builds/android/ |
| Windows | ZIP 包（手动压缩）| builds/windows/ |
| 备份 | 原始 APK | build/app/outputs/flutter-apk/backup/ |
| 历史 | build_history.json | 项目根 + builds/ |

---

## 4. 版本管理 Version Management

### 4.1 版本号规则 Version Numbering

志极采用 `Major.Minor.Patch+BuildNumber` 格式，例如 `2.3.3+23`。

| 状态 Status | 版本号规则 Rule | 示例 Example |
|------|--------------|-----------|
| release | minor++，patch=0 | 2.3.3 → 2.4.0 |
| beta | patch++ | 2.3.3 → 2.3.4 |
| alpha | patch++ | 2.3.3 → 2.3.4 |
| rc | patch++ | 2.3.3 → 2.3.4 |
| fix | patch++ | 2.3.3 → 2.3.4 |
| hotfix | patch++ | 2.3.3 → 2.3.4 |
| feature | patch++ | 2.3.3 → 2.3.4 |
| dev | patch++ | 2.3.3 → 2.3.4 |
| debug | patch++ | 2.3.3 → 2.3.4 |

**BuildNumber**：每次构建自增 1，不区分状态。

### 4.2 版本号位置 Version Location

版本号定义在 `mobile/pubspec.yaml`：

```yaml
version: 2.3.3+23
```

**禁止手动修改**：版本号由 `build_apk.ps1` 脚本自动管理，手动修改可能导致版本号不一致。

### 4.3 产物命名规则 Artifact Naming

```
{AppName}_{Status}_{Version}_{Date}_{Sequence}.{Extension}
```

| 字段 Field | 说明 Description | 示例 Example |
|----------|---------------|-----------|
| AppName | 应用名（固定）| Jeenith |
| Status | 构建状态 | release / beta / fix 等 |
| Version | 版本号 | 2.3.3 |
| Date | 构建日期 | 20260715 |
| Sequence | 当日序号 | 01, 02, 03... |
| Extension | 扩展名 | apk / zip |

**示例**：

- `Jeenith_release_2.3.3_20260715_01.apk`
- `Jeenith_release_2.3.3_20260715_01.zip`

### 4.4 版本历史记录 Version History

**双份历史记录**：

| 文件 File | 位置 Location | 用途 Usage |
|---------|-------------|----------|
| build_history.json | 项目根 | 项目内副本 |
| build_history.json | builds/ | 归档副本 |
| release_history.json | builds/ | 发布历史 |

**历史记录内容**：

- 构建时间
- 版本号 + BuildNumber
- 状态
- 文件名
- 文件大小
- 构建序号

**归档脚本**：`mobile/scripts/archive_history.py`

```powershell
# 由 build_apk.ps1 自动调用
python archive_history.py <apk_filename>
```

---

## 5. 发布与归档 Release & Archive

### 5.1 发布流程 Release Process

```
[1. 预构建检查] → [2. 执行构建] → [3. 验证产物] → [4. 提交代码] → [5. 推送仓库] → [6. 发布 Release]
```

**详细步骤**：

```
步骤1：预构建检查
  - flutter pub get
  - flutter analyze（无 error）
  - 确认 AGENTS.md / CLAUDE.md 规则

步骤2：执行构建
  - pwsh -File scripts/build_apk.ps1 -Status release
  - 等待构建完成，查看构建摘要

步骤3：验证产物
  - 检查 builds/android/ 下 APK 文件
  - 检查命名是否符合规范
  - 检查 build_history.json 是否更新

步骤4：提交代码
  - git add pubspec.yaml build_history.json builds/
  - git commit -m "release: v2.3.3"
  - git push origin main

步骤5：GitHub Release
  - 在 GitHub 创建新 Release
  - Tag: v2.3.3
  - 上传 APK + ZIP 产物
  - 填写 Release Notes
```

### 5.2 归档规范 Archive Standards

**归档目录结构**：

```
Jeenith/
  builds/
    android/                    # Android APK 归档
      Jeenith_release_2.3.3_20260715_01.apk
      Jeenith_release_2.3.2_20260715_01.apk
      ...
    windows/                    # Windows ZIP 归档
      Jeenith_release_2.3.3_20260715_01.zip
      ...
    build_history.json          # 构建历史
    release_history.json        # 发布历史
  build_history.json            # 项目内历史副本（与 builds/ 同步）
```

**归档要求**：

| 要求 Requirement | 说明 Description |
|--------------|---------------|
| 双份历史 | build_history.json 在项目根 + builds/ 各一份 |
| 命名规范 | 严格遵循 `{AppName}_{Status}_{Version}_{Date}_{Seq}.{ext}` |
| 不删除旧版本 | 保留所有历史版本，便于回溯 |
| Windows 手动归档 | Windows ZIP 需手动压缩 + 移动 |

### 5.3 Release Notes 规范 Release Notes Standard

每个 Release 应包含：

```markdown
## v2.3.3 (2026-07-15)

### ✨ 新功能 Features
- 首页按钮间距修复
- 添加 MIT LICENSE

### 🐛 修复 Bug Fixes
- 起卦按钮 BUG 修复
- Windows 图标产物归档

### 📦 构建 Build
- Windows 图标修复
- 设置页动画细分开关
```

---

## 6. 故障排查 Troubleshooting

### 6.1 构建问题 Build Issues

**Q1: flutter build apk 失败，提示版本号错误**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| pubspec.yaml 版本号格式错误 | 确认格式为 `version: X.Y.Z+N` |
| 脚本回滚后版本号不一致 | 手动检查 pubspec.yaml，修正后重新构建 |

**Q2: 构建脚本执行失败，提示 PowerShell 错误**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| PowerShell 版本过低 | 升级到 PowerShell 7+（pwsh）|
| 执行策略限制 | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| 路径含中文/空格 | 使用英文路径（项目已在 D:\Code\）|

**Q3: Windows 桌面构建失败**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| Visual Studio 缺少 C++ 工具链 | 安装 VS 2022，勾选「使用 C++ 的桌面开发」|
| flutter doctor 报错 | 根据 `flutter doctor -v` 输出修复 |
| window_manager 依赖问题 | `flutter pub get` 重新获取依赖 |

**Q4: APK 体积过大**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| 未开启混淆 | 确认 `flutter build apk --release`（release 默认开启）|
| 资源文件过大 | 检查 assets/ 目录，压缩图片/SVG |
| 未拆分 ABI | 可使用 `--split-per-abi` 拆分（但志极默认 fat APK）|

### 6.2 运行时问题 Runtime Issues

**Q1: 应用启动崩溃**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| SharedPreferences 损坏 | 清除应用数据：设置 → 应用 → 志极 → 清除数据 |
| 依赖版本不兼容 | 检查 pubspec.lock，`flutter pub upgrade` |
| Android 版本过低 | 确认 Android 5.0+（minSdk 21）|

**Q2: 风水罗盘指针不动**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| 未授权传感器权限 | 设置 → 应用 → 志极 → 权限 → 开启传感器 |
| 设备无磁力计 | 部分低端设备无磁力计硬件 |
| 磁场干扰 | 远离金属/电子设备，水平持握 |
| Windows 桌面端 | 桌面端无磁力计，功能不可用（已知限制）|

**Q3: 动效卡顿/掉帧**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| 设备性能不足 | 设置 → 动效总开关关闭 |
| 粒子系统过载 | 关闭「结果揭示」动效 |
| 后台进程过多 | 清理后台，释放内存 |

**Q4: 历史记录丢失**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| v2.3.1 之前的版本 | 升级到 v2.3.1+，已修复原子性问题 |
| 应用卸载重装 | 卸载会清除数据，需先导出历史 |
| SharedPreferences 异常 | 清除应用数据后重新使用 |

### 6.3 开发问题 Development Issues

**Q1: flutter analyze 报错**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| 未运行 pub get | `flutter pub get` 获取依赖 |
| 代码风格问题 | 根据 analyze 输出修复，参考 flutter_lints |
| 自定义规则 | 检查 analysis_options.yaml |

**Q2: 热重载失效**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| 修改了 initState | 需要热重启（R）而非热重载（r）|
| 修改了全局状态 | 热重启 |
| 修改了 pubspec.yaml | 需要完全重启应用 |

**Q3: CustomPainter 内存泄漏**

| 原因 Cause | 解决方案 Solution |
|----------|----------------|
| TextPainter 未 dispose | 在 CustomPainter.dispose() 中显式 dispose TextPainter |
| AnimationController 未 dispose | 在 State.dispose() 中显式 dispose Controller |

### 6.4 故障排查流程 Troubleshooting Process

```
[复现问题] → [收集信息] → [定位原因] → [修复] → [验证] → [发布修复]
```

**信息收集清单**：

| 信息 Info | 获取方式 Method |
|---------|-------------|
| 应用版本 | 设置 → 关于志极 |
| 设备型号 | 系统设置 |
| 操作系统版本 | 系统设置 |
| 复现步骤 | 用户描述 |
| 错误日志 | `flutter logs`（开发模式）|

---

## 7. 维护与监控 Maintenance & Monitoring

### 7.1 日常维护 Daily Maintenance

| 维护项 Item | 频率 Frequency | 操作 Operation |
|-----------|--------------|-------------|
| 依赖更新 | 每月 | `flutter pub upgrade --major-versions` |
| flutter analyze | 每次提交 | 确认无 error |
| 构建脚本验证 | 每个版本 | 执行构建脚本确认流程完整 |
| 归档完整性 | 每个版本 | 检查 builds/ 目录 + 双份 history |
| 仓库同步 | 每次提交 | git push origin main |

### 7.2 依赖管理 Dependency Management

**核心依赖清单**：

| 依赖 Dependency | 版本 Version | 用途 Usage |
|---------------|------------|----------|
| flutter_riverpod | ^2.5.0 | 状态管理 |
| go_router | ^14.0.0 | 路由 |
| lunar | ^1.7.8 | 农历/干支/节气 |
| flutter_svg | ^2.0.0 | SVG 图标 |
| shared_preferences | ^2.2.0 | 本地存储 |
| http | ^1.2.0 | 网络请求（random.org）|
| crypto | ^3.0.0 | SHA256 |
| window_manager | ^0.5.2 | 桌面窗口 |
| screen_retriever | ^0.2.2 | 屏幕信息 |
| share_plus | ^10.0.0 | 系统分享 |
| path_provider | ^2.1.0 | 文件路径 |
| sensors_plus | ^6.0.0 | 磁力计 |

**依赖升级流程**：

```
步骤1：flutter pub outdated（查看可升级依赖）
步骤2：flutter pub upgrade --major-versions（升级主版本）
步骤3：flutter analyze（确认无破坏性变更）
步骤4：flutter run（手动测试核心功能）
步骤5：提交 pubspec.yaml + pubspec.lock
```

### 7.3 代码质量 Code Quality

| 检查项 Check | 工具 Tool | 频率 Frequency |
|-----------|---------|--------------|
| 静态分析 | flutter analyze | 每次提交 |
| 代码风格 | flutter_lints ^6.0.0 | 实时 |
| 依赖安全 | flutter pub outdated | 每月 |
| 内存泄漏 | 手动检查 dispose | 代码审查 |

### 7.4 文档维护 Documentation Maintenance

| 文档 Doc | 维护时机 When | 责任人 Owner |
|---------|------------|------------|
| AGENTS.md / CLAUDE.md | 项目规则变更 | 开发者 |
| docs/项目文档/ | 每个大版本 | 开发者 |
| docs/FLUTTER_APK_BUILD_PIPELINE.md | 构建流程变更 | 开发者 |
| CHANGELOG | 每个版本 | 开发者 |

### 7.5 仓库管理 Repository Management

| 操作 Operation | 频率 Frequency | 说明 Description |
|-------------|--------------|---------------|
| git push | 每次提交 | 推送到 origin/main |
| GitHub Release | 每个版本 | 上传产物 + Release Notes |
| Issues 处理 | 按需 | 响应用户反馈 |
| 依赖升级 PR | 每月 | Dependabot 或手动 |

---

## 附录 Appendix

### 附录A：常用命令 Common Commands

```powershell
# === 构建 ===
cd D:\Code\Project\Qore\Jeenith\mobile
pwsh -File scripts/build_apk.ps1 -Status release                    # APK release 构建
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.4.0"  # 指定版本
flutter build windows --release                                      # Windows 构建

# === 开发 ===
flutter pub get                                                      # 获取依赖
flutter analyze                                                      # 静态分析
flutter run                                                          # 运行（调试）
flutter run -d windows                                               # Windows 桌面运行
flutter logs                                                         # 查看日志

# === 图标 ===
flutter pub run flutter_launcher_icons                               # 生成应用图标

# === 依赖 ===
flutter pub outdated                                                 # 查看过时依赖
flutter pub upgrade --major-versions                                 # 升级依赖

# === 归档（Windows）===
Compress-Archive -Path * -DestinationPath "Jeenith_release_X.Y.Z_YYYYMMDD_01.zip"
```

### 附录B：目录结构 Directory Structure

```
Jeenith/
  mobile/                          # Flutter 项目
    lib/                           # 源代码
    scripts/
      build_apk.ps1                # APK 构建脚本
      archive_history.py           # 历史归档脚本
    android/                       # Android 工程
    windows/                       # Windows 工程
    pubspec.yaml                   # 版本 2.3.3+23
  builds/                          # 构建产物归档
    android/                       # APK 归档
    windows/                       # ZIP 归档
    build_history.json             # 构建历史
    release_history.json           # 发布历史
  docs/                            # 项目文档
  build_history.json               # 项目内历史副本
  AGENTS.md / CLAUDE.md            # 项目规则
  LICENSE                          # MIT
```

### 附录C：应急联系 Emergency Contact

| 类型 Type | 方式 Method |
|---------|----------|
| 问题反馈 | GitHub Issues: https://github.com/HeYS-Snowe/Jeenith/issues |
| 开发者 | HeYS-Snowe |
| 仓库 | https://github.com/HeYS-Snowe/Jeenith |

### 附录D：检查清单 Checklists

**发布前检查清单 Pre-Release Checklist**：

- [ ] flutter pub get 成功
- [ ] flutter analyze 无 error
- [ ] 构建脚本执行成功
- [ ] APK 命名符合规范
- [ ] builds/android/ 归档完成
- [ ] build_history.json 双份同步
- [ ] pubspec.yaml 版本号正确
- [ ] git commit + push 完成
- [ ] GitHub Release 创建
- [ ] 产物上传完成
- [ ] Release Notes 填写

**故障修复检查清单 Bug Fix Checklist**：

- [ ] 问题已复现
- [ ] 根本原因已定位
- [ ] 修复代码已编写
- [ ] flutter analyze 通过
- [ ] 修复已验证
- [ ] 构建成功
- [ ] 版本号已更新
- [ ] 发布修复版本

---

**文档结束 End of Document**

> 志极 Jeenith · 志于本心，知于极处 · Copyright (c) 2026 Qore · MIT License
