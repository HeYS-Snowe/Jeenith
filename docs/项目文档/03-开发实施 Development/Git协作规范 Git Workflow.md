# Git协作规范 Git Workflow

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 仓库地址 Repository | https://github.com/HeYS-Snowe/Jeenith |
| 默认分支 Default Branch | main |
| 开发者 Developer | HeYS-Snowe |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本 |

---

## 目录 Table of Contents

1. [Git工作流 Git Workflow](#1-git工作流-git-workflow)
2. [分支管理 Branch Management](#2-分支管理-branch-management)
3. [提交规范 Commit Convention](#3-提交规范-commit-convention)
4. [版本号规则 Version Numbering](#4-版本号规则-version-numbering)
5. [构建与归档 Build & Archive](#5-构建与归档-build--archive)
6. [常用命令 Common Commands](#6-常用命令-common-commands)

---

## 1. Git工作流 Git Workflow

### 1.1 工作流选择 Workflow Selection

志极 Jeenith 为个人开源项目，由唯一开发者 HeYS-Snowe 推进，采用**简化版主干开发（Trunk-based）**工作流：

```
                  main（唯一长期分支）
                       │
       ┌───────────────┼───────────────┐
       │               │               │
    直接提交         功能开发         发布打 tag
   （小修复）       （本地分支）     （v2.3.3 等）
```

### 1.2 工作流说明 Workflow Description

| 场景 Scenario | 方式 Method |
|-------------|-----------|
| 小修复/文档更新 | 直接在 main 分支提交 |
| 较大功能开发 | 本地创建临时分支，完成后合并回 main |
| 版本发布 | main 分支打 tag（如 v2.3.3） |
| 紧急修复 | 直接在 main 修复并发布 hotfix 版本 |

> 志极不设 develop/release/hotfix 长期分支，保持 main 为唯一事实来源。所有发布均从 main 构建。

---

## 2. 分支管理 Branch Management

### 2.1 分支策略 Branch Strategy

| 分支 Branch | 生命周期 Lifecycle | 用途 Purpose |
|------------|------------------|------------|
| main | 永久 | 唯一长期分支，所有发布从此构建 |
| feat/* | 临时（本地） | 较大功能开发，完成后删除 |
| fix/* | 临时（本地） | Bug 修复，完成后删除 |

### 2.2 分支命名规范 Branch Naming

```
feat/<tech-id>-<feature>     # 如 feat/ziwei-star-placement
fix/<scope>-<issue>          # 如 fix/home-button-spacing
docs/<topic>                 # 如 docs/api-documentation
```

### 2.3 分支保护 Branch Protection

- main 分支应始终保持可构建状态（`flutter analyze` 0 issue）
- 发布前确保 main 分支为最新且通过质量门禁
- 不强制使用 Pull Request（个人项目可本地合并），但鼓励清晰的 commit 历史

---

## 3. 提交规范 Commit Convention

### 3.1 Commit Message 格式

采用 Conventional Commits 规范：

```
<type>: <subject>

[可选 body]
```

### 3.2 Type 类型

| Type | 说明 Description | 示例 Example |
|------|---------------|------------|
| feat | 新功能 | `feat: 新增八字推演术数` |
| fix | Bug 修复 | `fix: 首页右上角按钮间距过近` |
| refactor | 重构 | `refactor: 设置页动画开关 Map 化` |
| perf | 性能优化 | `perf: 紫微命盘径向排版优化` |
| style | 代码风格 | `style: 统一 Curves.linear 为 easeInOutCubic` |
| docs | 文档 | `docs: 添加 MIT LICENSE` |
| chore | 构建/工具 | `chore: 更新 pubspec 版本号` |
| build | 构建系统 | `build: Windows 图标资源修复` |

### 3.3 Subject 规范

- 使用中文描述（与项目文档语言一致）
- 不超过 50 字
- 不加句号结尾
- 使用祈使句（如「修复」而非「修复了」）

### 3.4 提交示例 Commit Examples

```
feat: 新增大六壬四课三传算法

实现贼克/比用/涉害/别责四宗门，含十二天将与昼夜贵人定位。
天盘环形图 CustomPainter 含 4 层同心圆。

feat: 新增风水罗盘磁力计接入

sensors_plus 6.1.2 磁力计订阅，24 山罗盘 CustomPainter，
仅 Android 显示磁力计罗盘，桌面端显示占位说明。

fix: 首页右上角使用手册与设置按钮间距过近

在两个 HoverableIconButton 之间插入 SizedBox(width: 8)。

docs: 添加 MIT LICENSE 并更新 README 版权说明
```

### 3.5 提交粒度 Commit Granularity

- 一个 commit 完成一个逻辑变更
- 新增术数：算法、UI、注册可合为一个 commit 或拆分为多个
- Bug 修复：一个 Bug 一个 commit
- 避免混合不相关变更到一个 commit

---

## 4. 版本号规则 Version Numbering

### 4.1 版本号格式 Version Format

```
主版本.次版本.修订号+构建号
```

例如：`2.3.3+23`

### 4.2 版本号递增规则 Increment Rules

| 状态 Status | 规则 Rule | 示例 Example |
|------------|---------|------------|
| release（正式版） | 次版本+1，修订号归零 | 2.2.0 → 2.3.0 |
| feature/beta/alpha 等 | 修订号+1 | 2.3.0 → 2.3.1 |
| 构建号 | 每次构建+1 | +22 → +23 |

### 4.3 状态类型 Status Types

| 状态 Status | 含义 Meaning | 完整度 Completeness |
|------------|------------|-------------------|
| release | 正式版 | 完全体 |
| beta | 测试版 | 非完全体 |
| alpha | 内测版 | 非完全体 |
| rc | 候选版 | 接近完全体 |
| fix | 修复版 | 完全体 |
| hotfix | 紧急修复版 | 完全体 |
| feature | 功能版 | 非完全体 |
| dev | 开发版 | 非完全体 |
| debug | 调试版 | 非完全体 |

### 4.4 构建产物命名 Artifact Naming

```
Jeenith_<status>_<version>_<date>_<sequence>.<ext>
```

示例：
- `Jeenith_release_2.3.3_20260715_01.apk`
- `Jeenith_release_2.3.3_20260715_01_windows_x64.zip`

### 4.5 版本历史记录 Version History

每次构建自动更新两份历史记录：
- `builds/build_history.json`：构建产物元数据（文件名/大小/SHA-256/日期）
- `builds/release_history.json`：发布版本元数据（版本号/状态/变更摘要）
- `builds/release_notes/release_notes_v<version>.md`：详细发布说明

---

## 5. 构建与归档 Build & Archive

### 5.1 构建命令 Build Command

```bash
# Android APK（cwd=mobile）
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.3.3"

# Windows 桌面
flutter build windows --release
```

### 5.2 构建脚本职责 Build Script Responsibilities

`scripts/build_apk.ps1` 自动完成：
1. 读取/更新 pubspec.yaml 版本号
2. 执行 `flutter build apk --release`
3. 按命名规则重命名 APK
4. 归档到 `builds/android/`
5. 更新 `build_history.json` + `release_history.json`
6. 生成 `release_notes/release_notes_v<version>.md` 模板

### 5.3 归档目录结构 Archive Structure

```
builds/
├── android/                    # APK 产物
│   └── Jeenith_release_2.3.3_20260715_01.apk
├── windows/                    # Windows ZIP 产物
│   └── Jeenith_release_2.3.3_20260715_01_windows_x64.zip
├── release_notes/              # 发布说明
│   └── release_notes_v2.3.3.md
├── build_history.json          # 构建历史
└── release_history.json        # 发布历史
```

### 5.4 质量门禁 Quality Gate

每次构建前必须满足：
- `flutter analyze` 为 0 issue
- TextPainter 全部 dispose（无 native handle 泄漏）
- AnimationController 全部 dispose
- 无硬编码身份信息

---

## 6. 常用命令 Common Commands

### 6.1 日常开发 Daily Development

```bash
# 进入项目
cd D:\Code\Project\Qore\Jeenith\mobile

# 安装依赖
flutter pub get

# 静态分析（必须 0 issue）
flutter analyze

# 运行调试
flutter run
```

### 6.2 Git 操作 Git Operations

```bash
# 查看状态
git status

# 查看最近提交
git log --oneline -10

# 创建功能分支
git checkout -b feat/new-tech

# 合并回 main
git checkout main
git merge feat/new-tech

# 打发布 tag
git tag v2.3.3
git push origin v2.3.3
```

### 6.3 构建发布 Build & Release

```bash
# APK 构建（自动版本号+归档+历史）
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.3.3"

# Windows 桌面构建
flutter build windows --release

# 手动打包 Windows ZIP
Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath builds\windows\Jeenith_release_2.3.3_20260715_01_windows_x64.zip
```

---

## 附录：版本发布历史 Version Release History

| 版本 Version | 日期 Date | 状态 Status | 主题 Theme |
|-------------|---------|------------|----------|
| v1.0.0 | 2026-07-11 | release | 首版发布 |
| v1.2.0 | 2026-07-13 | feature | 卦辞爻辞数据 |
| v1.3.0 | 2026-07-13 | feature | 紫微斗数 v2 |
| v1.4.0 | 2026-07-13 | feature | 奇门遁甲 v2 |
| v1.5.0 | 2026-07-13 | feature | 主题/分享/导出 |
| v1.6.0 | 2026-07-13 | feature | 抽签/测字 |
| v1.7.0 | 2026-07-13 | feature | 大六壬/罗盘 |
| v2.0.0 | 2026-07-14 | release | 品牌定调 |
| v2.1.0 | 2026-07-14 | feature | 动效 Phase 1 |
| v2.2.0 | 2026-07-14 | feature | 动效 Phase 2 |
| v2.3.0 | 2026-07-14 | feature | 八字/测名字 |
| v2.3.1 | 2026-07-15 | fix | BUG 修复 |
| v2.3.2 | 2026-07-15 | release | 动画细分开关 |
| v2.3.3 | 2026-07-15 | release | 开源就绪 |

---

**文档结束 End of Document**

志极 Jeenith · 志于本心，知于极处
