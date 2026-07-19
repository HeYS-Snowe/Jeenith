# 部署运维手册 Deployment Guide

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 项目类型 Type | Flutter 移动 App（Android + Windows 桌面） |
| 包名 Package | com.qore.jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 维护人 Maintainer | HeYS-Snowe |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |
| 许可证 License | MIT |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本，覆盖 Android APK + Windows exe 双端构建部署流程 |

---

## 目录 Table of Contents

1. [部署架构 Deployment Architecture](#1-部署架构-deployment-architecture)
2. [环境准备 Prerequisites](#2-环境准备-prerequisites)
3. [Android APK 构建与签名](#3-android-apk-构建与签名)
4. [Windows exe 构建](#4-windows-exe-构建)
5. [产物归档流程 Artifact Archiving](#5-产物归档流程-artifact-archiving)
6. [GitHub Release 发布](#6-github-release-发布)
7. [历史记录管理 History Management](#7-历史记录管理-history-management)
8. [常见问题 FAQ](#8-常见问题-faq)
9. [回滚 Rollback](#9-回滚-rollback)

---

## 1. 部署架构 Deployment Architecture

### 1.1 项目性质 Nature

志极 Jeenith 是**纯客户端 App，无后端服务**。部署仅涉及：

- 构建 Android APK 与 Windows exe
- 归档构建产物
- 通过 GitHub Release 分发

无服务器、无数据库、无 CI/CD pipeline（手工构建）。

### 1.2 部署拓扑 Topology

```
开发机 (Windows 11)
   │
   ├── flutter build apk --release ──► builds/android/Jeenith_*.apk
   ├── flutter build windows --release ──► builds/windows/Jeenith_*.zip
   │
   └── git push origin main ──► GitHub 仓库
                                │
                                └── GitHub Release（手工创建）
                                       │
                                       ├── 上传 APK
                                       └── 上传 Windows ZIP
```

### 1.3 产物命名规则 Naming Rule

```
{程序名}_{状态类型}_{版本号}_{构建日期}_{构建序号}.{扩展名}
```

| 字段 Field | 说明 Description | 示例 Example |
|----------|---------------|-----------|
| 程序名 | 固定 `Jeenith` | Jeenith |
| 状态类型 | release / beta / alpha / rc / fix / hotfix / feature / dev / debug | release |
| 版本号 | X.Y.Z（来自 pubspec.yaml） | 2.3.3 |
| 构建日期 | YYYYMMDD | 20260715 |
| 构建序号 | 同日同版本 2 位序号 | 01 |
| 扩展名 | apk / zip | apk |

完整示例：`Jeenith_release_2.3.3_20260715_01.apk`

### 1.4 状态类型说明 Status Types

| 状态 | 含义 | 完全度 |
|------|------|--------|
| release | 正式版 | 完全体 |
| beta | 测试版 | 非完全体 |
| alpha | 内测版 | 非完全体 |
| rc | 候选版 | 接近完全体 |
| fix | 修复版 | 完全体 |
| hotfix | 紧急修复版 | 完全体 |
| feature | 功能版 | 非完全体 |
| dev | 开发版 | 非完全体 |
| debug | 调试版 | 非完全体 |

---

## 2. 环境准备 Prerequisites

### 2.1 开发机要求

| 项 Item | 要求 Requirement |
|--------|----------------|
| 操作系统 OS | Windows 11 23H2（推荐）或 Windows 10 |
| Flutter SDK | 3.x（Dart 3.11+）|
| PowerShell | 7+（pwsh）|
| Git | 2.x |
| Android Studio | 用于 Android SDK + 构建工具 |
| Visual Studio 2022 | 含「使用 C++ 的桌面开发」工作负载（Windows 桌面 Flutter）|

### 2.2 Flutter 环境校验

```powershell
flutter doctor -v
```

期望输出：

- ✅ Flutter（Channel stable, 3.x）
- ✅ Android toolchain
- ✅ Visual Studio - develop Windows apps
- ✅ Android Studio
- ✅ Connected device

### 2.3 项目依赖

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
flutter pub get
```

### 2.4 静态分析

```powershell
flutter analyze
```

期望输出：`No issues found!`（0 issue 是 release 必要条件）

---

## 3. Android APK 构建与签名

### 3.1 一键构建脚本 Build Script

志极提供 `scripts/build_apk.ps1` 自动化构建脚本，自动完成版本号更新、构建、重命名、归档、历史记录更新。

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.3.3"
```

#### 参数 Parameters

| 参数 Parameter | 类型 Type | 默认 Default | 说明 Description |
|--------------|---------|------------|---------------|
| `-BuildType` | debug/release/profile | release | Flutter 构建类型 |
| `-Status` | release/beta/alpha/rc/fix/hotfix/feature/dev/debug | release | 状态类型（影响产物命名）|
| `-TargetVersion` | X.Y.Z | 自动递增 | 目标版本号 |

#### 自动化行为 Automated Steps

1. 读取 `pubspec.yaml` 当前版本
2. 若未指定 `-TargetVersion`，按 `-Status` 规则递增（release: minor++, patch=0；其他: patch++）
3. 自动递增 build number
4. 写回 `pubspec.yaml`（UTF-8 无 BOM）
5. 执行 `flutter build apk --release`
6. 备份原始 APK 到 `build/.../backup/`
7. 重命名为 `Jeenith_{status}_{version}_{date}_{seq}.apk`
8. 移动到 `builds/android/`
9. 计算 SHA-256
10. 追加记录到 `builds/build_history.json`
11. 输出构建摘要

### 3.2 手工构建 Manual Build

如需手工控制每一步：

```powershell
# 1. 更新版本号（手工编辑 pubspec.yaml 的 version: 行）
# version: 2.3.3+23

# 2. 构建
cd D:\Code\Project\Qore\Jeenith\mobile
flutter build apk --release

# 3. 产物位置
# D:\Code\Project\Qore\Jeenith\mobile\build\app\outputs\flutter-apk\app-release.apk

# 4. 重命名并归档（参考自动脚本逻辑）
$src = "build\app\outputs\flutter-apk\app-release.apk"
$dst = "..\builds\android\Jeenith_release_2.3.3_20260715_01.apk"
Copy-Item -Path $src -Destination $dst -Force

# 5. 计算 SHA-256
$hash = (Get-FileHash $dst -Algorithm SHA256).Hash
Write-Host "SHA-256: $hash"
```

### 3.3 APK 签名 Signing

#### 当前签名状态

- **debug keystore**：Flutter 默认使用 `~/.android/debug.keystore` 签名 release APK。
- **release keystore**：暂未配置正式 release keystore（已知限制，见安全测试报告）。

#### 配置正式 release keystore（未来计划）

1. 生成 keystore：

```powershell
keytool -genkey -v -keystore jeenith-release.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias jeenith
```

2. 在 `mobile/android/key.properties` 配置（**不提交到 git**）：

```properties
storePassword=*****
keyPassword=*****
keyAlias=jeenith
storeFile=../jeenith-release.jks
```

3. 在 `mobile/android/app/build.gradle` 引用：

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

4. 将 `key.properties` 与 `*.jks` 加入 `.gitignore`。

### 3.4 APK 验证 Verification

```powershell
# 查看 APK 签名信息
jarsigner -verify -verbose -certs builds\android\Jeenith_release_2.3.3_20260715_01.apk

# 查看 APK 包名与版本
aapt dump badging builds\android\Jeenith_release_2.3.3_20260715_01.apk | findstr "package versionName"
```

---

## 4. Windows exe 构建

### 4.1 构建命令 Build Command

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
flutter build windows --release
```

#### 产物位置 Output

```
D:\Code\Project\Qore\Jeenith\mobile\build\windows\x64\runner\Release\
├── jeenith.exe
├── flutter_windows.dll
├── data/
└── ... (其他依赖 dll)
```

### 4.2 应用图标 Icon

志极 Windows 应用图标通过 `mobile/windows/runner/resources/` 下的 `.ico` 文件嵌入，由 `Runner.rc` 引用。

#### 图标更新流程 Icon Update

1. 准备多尺寸志极品牌图标 `.ico`（包含 16/32/48/64/128/256 等）
2. 替换 `mobile/windows/runner/resources/app_icon.ico`
3. **必须 `flutter clean`**（避免 CMake 缓存旧的 Runner.rc 编译产物）：

```powershell
flutter clean
flutter pub get
flutter build windows --release
```

4. 验证 exe 图标（提取 32x32 颜色，确认主色调为志极深紫 RGB ≈ 27,23,27，无 Flutter 蓝 #54C5F8）

### 4.3 Windows ZIP 打包

```powershell
$src = "build\windows\x64\runner\Release\*"
$dst = "..\builds\windows\Jeenith_release_2.3.3_20260715_01_windows_x64.zip"
Compress-Archive -Path $src -DestinationPath $dst -Force

# 计算 SHA-256
$hash = (Get-FileHash $dst -Algorithm SHA256).Hash
Write-Host "SHA-256: $hash"
```

### 4.4 窗口尺寸初始化

志极通过 `window_manager` + `screen_retriever` 在启动时初始化窗口尺寸（详见 `main.dart`）。无需额外部署配置。

### 4.5 Windows 图标缓存问题

Windows 资源管理器对 exe 图标有缓存机制。若替换 exe 后仍显示旧图标：

- 按 `Ctrl+Shift+Esc` 打开任务管理器 → 重启「Windows 资源管理器」进程
- 或清空图标缓存：`ie4uinit.exe -show`（命令行执行）

---

## 5. 产物归档流程 Artifact Archiving

### 5.1 归档目录结构 Directory Structure

```
builds/
├── android/
│   ├── Jeenith_release_1.0.0_20260711_01.apk
│   ├── Jeenith_release_2.3.3_20260715_01.apk
│   └── ...
├── windows/
│   ├── Jeenith_release_1.0.1_20260711_01_windows_x64.zip
│   ├── Jeenith_release_2.3.3_20260715_01_windows_x64.zip
│   └── ...
├── release_notes/
│   ├── release_notes_v1.0.0.md
│   ├── release_notes_v2.3.3.md
│   └── ...
├── build_history.json
└── release_history.json
```

### 5.2 build_history.json

每次构建后追加一条记录，字段包括：

```json
{
  "version": "2.3.3+23",
  "status": "release",
  "statusLabel": "正式版",
  "date": "20260715",
  "sequence": 1,
  "filename": "Jeenith_release_2.3.3_20260715_01.apk",
  "timestamp": "2026-07-15T20:27:13",
  "fileSize": 57667575,
  "fileSizeFormatted": "55.00 MB",
  "sha256": "E3F5E13FA6E7BFB7F3A45D31BC2DE421D32CC5379E1E777B0F440794180F625D",
  "sourcePath": "D:\\Code\\Project\\Qore\\Jeenith\\mobile\\build\\app\\outputs\\flutter-apk\\app-release.apk",
  "targetPath": "D:\\Code\\Project\\Qore\\Jeenith\\mobile\\..\\builds\\android\\Jeenith_release_2.3.3_20260715_01.apk",
  "platform": "android-arm64,android-arm,android-x64",
  "verificationPassed": true
}
```

### 5.3 release_history.json

每次发布后追加一条记录，字段对应 GitHub New release 表单：

```json
{
  "platform": "GitHub",
  "repo": "HeYS-Snowe/Jeenith",
  "tag": "v2.3.3",
  "target": "main",
  "title": "v2.3.3 — 首页按钮间距修复 + MIT LICENSE + Windows 图标产物归档",
  "label": "Latest",
  "isLatest": true,
  "isPreRelease": false,
  "notesFile": "builds/release_notes/release_notes_v2.3.3.md",
  "notesFormat": "markdown",
  "assets": [
    {
      "name": "Jeenith_release_2.3.3_20260715_01.apk",
      "platform": "android-arm64,android-arm,android-x64",
      "size": 57667575,
      "sizeFormatted": "55.00 MB",
      "sha256": "E3F5E13FA6E7BFB7F3A45D31BC2DE421D32CC5379E1E777B0F440794180F625D",
      "localPath": "builds/android/Jeenith_release_2.3.3_20260715_01.apk",
      "downloadUrl": ""
    }
  ],
  "versionInPubspec": "2.3.3+23",
  "buildStatus": "release",
  "builtAt": "2026-07-15T20:30:00",
  "commit": "",
  "publishedAt": "",
  "url": "",
  "status": "unpublished"
}
```

#### status 枚举

- `draft`：待发布
- `published`：已在 GitHub 发布
- `unpublished`：仅本地构建，未在平台发布

### 5.4 项目内历史副本

`build_history.json` 在项目根目录也有一份副本（`D:\Code\Project\Qore\Jeenith\build_history.json`），构建脚本会同时更新两份。

---

## 6. GitHub Release 发布

### 6.1 发布前检查 Pre-release Checklist

- [ ] `flutter analyze` 0 issue
- [ ] APK 已构建并归档到 `builds/android/`
- [ ] Windows ZIP 已构建并归档到 `builds/windows/`
- [ ] `builds/build_history.json` 已更新
- [ ] release notes 已写到 `builds/release_notes/release_notes_v{version}.md`
- [ ] `release_history.json` 已追加记录，`status: "draft"`
- [ ] 测试报告已签署「可发布」
- [ ] 代码已 commit 并 push 到 `main`

### 6.2 创建 GitHub Release 步骤

1. 访问 https://github.com/HeYS-Snowe/Jeenith/releases/new
2. **Choose a tag**：输入 `v{version}`（如 `v2.3.3`），选择「Create new tag: v2.3.3 on publish」
3. **Target**：`main`
4. **Release title**：从 `release_history.json` 的 `title` 字段复制
5. **Description**：从 `builds/release_notes/release_notes_v{version}.md` 复制正文
6. **Set as the latest release**：勾选（正式版）
7. **Attach binaries**：拖拽 APK 与 Windows ZIP
8. **Publish release**

### 6.3 发布后操作 Post-release

1. 从 GitHub Release 页获取下载 URL
2. 更新 `release_history.json` 中对应记录：
   - `url`: `https://github.com/HeYS-Snowe/Jeenith/releases/tag/v{version}`
   - `publishedAt`: ISO8601 时间戳
   - 各 asset 的 `downloadUrl`
   - `status`: `published`
3. commit & push 更新后的 `release_history.json`

---

## 7. 历史记录管理 History Management

### 7.1 归档脚本 Archive Script

志极提供 Python 归档脚本：

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile
python scripts/archive_history.py
```

### 7.2 历史保留策略 Retention Policy

- `builds/android/` 与 `builds/windows/`：**永久保留所有版本**（便于回滚）
- `builds/build_history.json`：**只追加不删除**
- `builds/release_history.json`：**只追加不删除**
- `builds/release_notes/`：**每个 tag 一份，永久保留**
- `build/app/outputs/flutter-apk/backup/`：构建时自动备份的原始 APK，**定期清理**

### 7.3 历史查询 Query History

#### 查询某版本构建信息

```powershell
# 用 PowerShell 解析 JSON
$json = Get-Content builds\build_history.json -Raw | ConvertFrom-Json
$json.builds | Where-Object { $_.version -eq "2.3.3+23" } | Format-List
```

#### 查询某版本发布信息

```powershell
$json = Get-Content builds\release_history.json -Raw | ConvertFrom-Json
$json.releases | Where-Object { $_.tag -eq "v2.3.3" } | Format-List
```

---

## 8. 常见问题 FAQ

### Q1：构建脚本报「pubspec.yaml not found」

**原因**：脚本未在 `mobile/` 目录下运行。
**解决**：`cd D:\Code\Project\Qore\Jeenith\mobile` 后再执行脚本。

### Q2：Windows 构建后 exe 图标仍是 Flutter 默认蓝

**原因**：CMake 缓存了旧 `Runner.rc` 编译产物。
**解决**：

```powershell
flutter clean
flutter pub get
flutter build windows --release
```

### Q3：Windows 资源管理器仍显示旧 exe 图标

**原因**：Windows 图标缓存。
**解决**：

- 任务管理器 → 重启「Windows 资源管理器」
- 或命令行执行 `ie4uinit.exe -show`

### Q4：APK 体积过大

**原因**：Flutter engine + lunar 历法库 + assets。
**缓解**：

- 检查 `assets/yijing/` 是否有冗余文件
- 使用 `flutter build apk --split-per-abi` 按 ABI 拆分（产物更小，但需上传多个）
- 当前 55 MB 在可接受范围，无需优化

### Q5：构建脚本报「Cannot read version from pubspec.yaml」

**原因**：`pubspec.yaml` 的 `version:` 行格式异常。
**解决**：确保格式为 `version: X.Y.Z+N`（如 `version: 2.3.3+23`），无前导空格。

### Q6：random.org 在 release 模式下不可用

**原因**：HTTP 请求在 release 模式下需要 INTERNET 权限。
**解决**：检查 `mobile/android/app/src/main/AndroidManifest.xml` 是否含 `<uses-permission android:name="android.permission.INTERNET"/>`。

### Q7：风水罗盘在 Windows 桌面无响应

**原因**：Windows 桌面无磁力计硬件。
**解决**：设计如此。Windows 桌面应提示「请使用 Android 真机」或允许手动拖动罗盘。

### Q8：如何同时构建 APK 和 Windows ZIP

```powershell
cd D:\Code\Project\Qore\Jeenith\mobile

# 1. APK（脚本自动归档）
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.3.3"

# 2. Windows
flutter build windows --release
$src = "build\windows\x64\runner\Release\*"
$dst = "..\builds\windows\Jeenith_release_2.3.3_$(Get-Date -Format yyyyMMdd)_01_windows_x64.zip"
Compress-Archive -Path $src -DestinationPath $dst -Force
```

---

## 9. 回滚 Rollback

### 9.1 回滚到上一版本

由于志极无后端，回滚仅涉及：

1. 在 `builds/android/` 与 `builds/windows/` 找到上一版本 APK / ZIP
2. 在 GitHub Release 页将「Latest」标记改回上一版本
3. 通知用户下载上一版本（用户侧需卸载新版本再安装旧版本）

### 9.2 紧急 hotfix 流程

1. 从 `main` 拉取 `hotfix/v{version}` 分支
2. 修复 bug，commit
3. 构建 hotfix 版本：

```powershell
pwsh -File scripts/build_apk.ps1 -Status hotfix -TargetVersion "2.3.4"
```

4. 合并 `hotfix/v{version}` 回 `main`
5. 创建 GitHub Release（标记为 Latest，原 release 取消 Latest）

### 9.3 历史版本可用性 Historical Availability

`builds/build_history.json` 中所有版本的产物文件应保留在 `builds/android/` 与 `builds/windows/`。如发现文件缺失，从 GitHub Release 页下载对应版本补齐。

---

## 附：参考文档 References

- [FLUTTER_APK_BUILD_PIPELINE.md](../../docs/FLUTTER_APK_BUILD_PIPELINE.md)
- [AGENTS.md](../../AGENTS.md)
- [CLAUDE.md](../../CLAUDE.md)
- [Release Notes](../../builds/release_notes/)
- 项目位置：`D:\Code\Project\Qore\Jeenith`
- 仓库：https://github.com/HeYS-Snowe/Jeenith
