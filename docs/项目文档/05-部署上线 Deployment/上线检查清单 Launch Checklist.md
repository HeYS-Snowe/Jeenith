# 上线检查清单 Launch Checklist

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 项目类型 Type | Flutter 移动 App（Android + Windows 桌面）|
| 包名 Package | com.qore.jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 维护人 Maintainer | HeYS-Snowe |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本，对齐志极 v2.3.3 release 全流程 |

---

## 目录 Table of Contents

1. [使用说明 Usage](#1-使用说明-usage)
2. [代码质量检查 Code Quality](#2-代码质量检查-code-quality)
3. [版本号检查 Version Number](#3-版本号检查-version-number)
4. [测试通过 Testing](#4-测试通过-testing)
5. [Android APK 构建检查 Android Build](#5-android-apk-构建检查-android-build)
6. [Windows exe 构建检查 Windows Build](#6-windows-exe-构建检查-windows-build)
7. [应用图标与品牌 Icon & Branding](#7-应用图标与品牌-icon--branding)
8. [签名检查 Signing](#8-签名检查-signing)
9. [产物归档检查 Archiving](#9-产物归档检查-archiving)
10. [历史记录检查 History Records](#10-历史记录检查-history-records)
11. [发布说明检查 Release Notes](#11-发布说明检查-release-notes)
12. [GitHub Release 发布检查 GitHub Publish](#12-github-release-发布检查-github-publish)
13. [上线后检查 Post-launch](#13-上线后检查-post-launch)
14. [紧急回滚检查 Rollback](#14-紧急回滚检查-rollback)
15. [签字确认 Sign-off](#15-签字确认-sign-off)

---

## 1. 使用说明 Usage

### 1.1 适用范围 Scope

本清单适用于志极 Jeenith 每次 release 上线前的全流程检查。覆盖从代码冻结到 GitHub Release 发布的 14 个环节，共 80+ 检查项。

### 1.2 使用方法 How to Use

- 每项检查打勾 `[x]` 表示通过；`[ ]` 表示未完成；`[!]` 表示阻塞。
- 任何「阻塞」项未解决前，禁止发布。
- 全部通过后，由发布负责人签字确认（第 15 节）。
- 每次发布新建一份本清单的副本，命名 `Launch_Checklist_v{version}_{date}.md`。

### 1.3 检查项分级 Levels

| 等级 Level | 含义 | 阻塞发布 Block Launch |
|----------|------|-------------------|
| MUST | 必须 | 是 |
| SHOULD | 应当 | 否（但需记录原因） |
| NICE | 建议 | 否 |

---

## 2. 代码质量检查 Code Quality

### 2.1 静态分析 Static Analysis

- [ ] **MUST** 执行 `flutter analyze` 输出 `No issues found!`（0 issue）
- [ ] **MUST** 无 `TODO` / `FIXME` 标记在 release 分支代码中遗留（grep 验证）
- [ ] **SHOULD** 无 `print()` 调试语句遗留（release 应使用日志框架或移除）
- [ ] **SHOULD** 无未使用的 import（`dart analyze` 会捕获）
- [ ] **NICE** 代码注释覆盖率 ≥ 60%

### 2.2 代码审查 Code Review

- [ ] **MUST** 所有 PR 已通过 code review 并合并到 `main`
- [ ] **MUST** 无未关闭的 Critical / High Bug
- [ ] **SHOULD** 无未关闭的 Medium Bug
- [ ] **NICE** 无未关闭的 Low Bug

### 2.3 关键代码路径 Key Code Paths

- [ ] **MUST** `core/rng/true_random.dart` 无近期改动，或改动已通过 χ² 检验
- [ ] **MUST** `core/history/history_store.dart` 原子读-改-写逻辑无改动，或改动已通过 5 连发测试
- [ ] **MUST** `core/divination/divination_registry.dart` 12 种术注册完整，无重复 ID
- [ ] **MUST** `core/theme/animations.dart` 时长常量与设置页开关一致

---

## 3. 版本号检查 Version Number

### 3.1 pubspec.yaml

- [ ] **MUST** `version: X.Y.Z+N` 格式正确（如 `2.3.3+23`）
- [ ] **MUST** X.Y.Z 与本次发布目标版本一致
- [ ] **MUST** N（build number）已递增（≥ 上次发布的 build number + 1）
- [ ] **MUST** `flutter pub get` 成功，无依赖冲突

### 3.2 历史一致性 History Consistency

- [ ] **MUST** `builds/build_history.json` 中最新记录的 `version` 与 pubspec 一致
- [ ] **MUST** `builds/release_history.json` 中最新记录的 `versionInPubspec` 与 pubspec 一致
- [ ] **MUST** 本次版本号在历史中**唯一**（不与已发布版本重复）

### 3.3 版本号递增规则 Increment Rule

| 状态 Status | 规则 Rule |
|-----------|---------|
| release | minor++，patch=0 |
| fix / hotfix | patch++ |
| feature / beta / alpha / rc | patch++ |
| dev / debug | patch++ |

- [ ] **MUST** 本次版本号递增符合上表规则

---

## 4. 测试通过 Testing

### 4.1 测试报告 Test Report

- [ ] **MUST** 测试报告（`测试报告 Test Report.md`）已填写
- [ ] **MUST** 所有 P0 用例 100% 通过
- [ ] **MUST** 所有 P1 用例 100% 通过
- [ ] **MUST** P2 用例通过率 ≥ 95%
- [ ] **MUST** 测试结论为「通过 Pass」或「有条件通过 Conditional Pass」
- [ ] **MUST** 发布建议为「可发布 Go」

### 4.2 性能测试 Performance

- [ ] **MUST** 性能测试报告（`性能测试报告 Performance Test.md`）已填写
- [ ] **MUST** 冷启动 ≤ 2.5s
- [ ] **MUST** 起卦响应 ≤ 1.5s
- [ ] **MUST** 路由转场 FPS ≥ 55
- [ ] **MUST** 仪式动画 FPS ≥ 50
- [ ] **MUST** 稳态内存 ≤ 250 MB
- [ ] **MUST** APK ≤ 60 MB
- [ ] **MUST** Windows ZIP ≤ 15 MB

### 4.3 安全测试 Security

- [ ] **MUST** 安全测试报告（`安全测试报告 Security Test.md`）已填写
- [ ] **MUST** 真随机 χ² 检验 p > 0.05
- [ ] **MUST** 无 Critical 安全风险
- [ ] **MUST** 无 High 安全风险
- [ ] **SHOULD** 已知限制（如 APK 未签名）已在 release notes 中声明

### 4.4 跨平台测试 Cross-Platform

- [ ] **MUST** Android 真机全量测试通过
- [ ] **MUST** Windows 桌面全量测试通过
- [ ] **MUST** 风水罗盘在 Android 真机磁力计可用
- [ ] **MUST** 风水罗盘在 Windows 桌面有降级处理

---

## 5. Android APK 构建检查 Android Build

### 5.1 构建命令 Build Command

- [ ] **MUST** 在 `mobile/` 目录下执行构建脚本：`pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "X.Y.Z"`
- [ ] **MUST** 构建脚本无报错退出
- [ ] **MUST** 输出包含 `[VERSION] Updated: X.Y.Z+N`
- [ ] **MUST** 输出包含 `[BUILD] success`

### 5.2 产物文件 Artifact

- [ ] **MUST** `builds/android/Jeenith_release_X.Y.Z_YYYYMMDD_NN.apk` 文件存在
- [ ] **MUST** APK 大小 ≤ 60 MB
- [ ] **MUST** APK SHA-256 已计算并记录
- [ ] **MUST** APK 安装到 Android 真机可启动
- [ ] **MUST** APK 启动后无崩溃

### 5.3 APK 元数据 Metadata

- [ ] **MUST** `aapt dump badging` 输出包名 `com.qore.jeenith`
- [ ] **MUST** `aapt dump badging` 输出 versionName = X.Y.Z
- [ ] **MUST** `aapt dump badging` 输出 versionCode = N
- [ ] **SHOULD** APK target SDK ≥ 33（Android 13）
- [ ] **SHOULD** APK min SDK ≥ 21（Android 5.0）

### 5.4 功能抽样验证 Sample Verification

- [ ] **MUST** 首页 12 张卡片渲染正确
- [ ] **MUST** 至少 3 种术起卦正常（如小六壬 / 周易 / 紫微）
- [ ] **MUST** 起卦后历史记录新增
- [ ] **MUST** 设置页可访问，动画开关可切换
- [ ] **MUST** 风水罗盘页面可访问，磁力计响应

---

## 6. Windows exe 构建检查 Windows Build

### 6.1 构建命令 Build Command

- [ ] **MUST** 在 `mobile/` 目录下执行 `flutter build windows --release`
- [ ] **MUST** 构建无报错退出
- [ ] **MUST** 产物位于 `build/windows/x64/runner/Release/`

### 6.2 ZIP 打包 Packaging

- [ ] **MUST** ZIP 文件命名为 `Jeenith_release_X.Y.Z_YYYYMMDD_NN_windows_x64.zip`
- [ ] **MUST** ZIP 已归档到 `builds/windows/`
- [ ] **MUST** ZIP 大小 ≤ 15 MB
- [ ] **MUST** ZIP SHA-256 已计算并记录

### 6.3 运行验证 Run Verification

- [ ] **MUST** 解压 ZIP 后 `jeenith.exe` 可启动
- [ ] **MUST** 启动后无崩溃
- [ ] **MUST** 窗口尺寸初始化正常（window_manager）
- [ ] **MUST** 至少 3 种术起卦正常
- [ ] **MUST** 风水罗盘页面有降级提示

---

## 7. 应用图标与品牌 Icon & Branding

### 7.1 Android 图标

- [ ] **MUST** `mobile/android/app/src/main/res/` 下各密度 mipmap 含志极品牌图标
- [ ] **MUST** `pubspec.yaml` 中 `flutter_launcher_icons` 配置正确
- [ ] **MUST** 安装后桌面图标显示为志极品牌（非 Flutter 默认）
- [ ] **MUST** 自适应图标（adaptive icon）背景色为志极深紫 `#0C0A12`

### 7.2 Windows 图标

- [ ] **MUST** `mobile/windows/runner/resources/app_icon.ico` 为志极品牌多尺寸图标
- [ ] **MUST** exe 文件在资源管理器中显示志极图标（非 Flutter 蓝 #54C5F8）
- [ ] **SHOULD** 提取 32x32 图标验证主色调为志极深紫 RGB ≈ 27,23,27

### 7.3 应用名称 App Name

- [ ] **MUST** Android `AndroidManifest.xml` 中 `android:label` = "志极"
- [ ] **MUST** Windows `Runner.rc` 中 `AppName` = "志极" / "Jeenith"
- [ ] **MUST** 桌面 / 任务栏显示名称正确

### 7.4 版本信息显示 Version Display

- [ ] **SHOULD** 应用内某处（如关于页 / 设置页底部）显示版本号 X.Y.Z+N
- [ ] **SHOULD** 版本号与 pubspec 一致

---

## 8. 签名检查 Signing

### 8.1 Android APK 签名

- [ ] **MUST** APK 已签名（`jarsigner -verify` 通过）
- [ ] **SHOULD** 使用 release keystore 签名（当前为 debug keystore，已知限制）
- [ ] **NICE** 使用正式代码签名证书

### 8.2 Windows exe 签名

- [ ] **SHOULD** exe 已签名（当前未签名，已知限制）
- [ ] **NICE** 使用 EV 代码签名证书

### 8.3 签名密钥安全 Keystore Security

- [ ] **MUST** keystore 文件不在 git 仓库中（.gitignore 配置正确）
- [ ] **MUST** keystore 密码不硬编码在构建脚本中
- [ ] **MUST** `key.properties` 文件不在 git 仓库中

---

## 9. 产物归档检查 Archiving

### 9.1 Android 归档

- [ ] **MUST** `builds/android/Jeenith_release_X.Y.Z_YYYYMMDD_NN.apk` 存在
- [ ] **MUST** 文件名严格符合命名规则：`Jeenith_{status}_{version}_{date}_{seq}.apk`
- [ ] **MUST** 文件大小、SHA-256 已记录到 `build_history.json`
- [ ] **MUST** 原始 APK 备份到 `build/app/outputs/flutter-apk/backup/`（如有）

### 9.2 Windows 归档

- [ ] **MUST** `builds/windows/Jeenith_release_X.Y.Z_YYYYMMDD_NN_windows_x64.zip` 存在
- [ ] **MUST** 文件名严格符合命名规则：`Jeenith_{status}_{version}_{date}_{seq}_windows_x64.zip`
- [ ] **MUST** 文件大小、SHA-256 已记录到 `build_history.json`

### 9.3 归档完整性 Completeness

- [ ] **MUST** `builds/android/` 与 `builds/windows/` 下新版本文件存在
- [ ] **MUST** 项目根目录 `build_history.json` 与 `builds/build_history.json` 两份副本一致
- [ ] **MUST** 旧版本文件未被删除（永久保留策略）

---

## 10. 历史记录检查 History Records

### 10.1 build_history.json

- [ ] **MUST** 新增记录字段完整：`version` / `status` / `statusLabel` / `date` / `sequence` / `filename` / `timestamp` / `fileSize` / `fileSizeFormatted` / `sha256` / `sourcePath` / `targetPath` / `platform` / `verificationPassed`
- [ ] **MUST** Android 与 Windows 各一条记录（共 2 条新记录）
- [ ] **MUST** `verificationPassed` = true
- [ ] **MUST** JSON 格式合法，可被解析

### 10.2 release_history.json

- [ ] **MUST** 新增 release 记录字段完整：`platform` / `repo` / `tag` / `target` / `title` / `label` / `isLatest` / `isPreRelease` / `notesFile` / `notesFormat` / `assets` / `versionInPubspec` / `buildStatus` / `builtAt` / `commit` / `publishedAt` / `url` / `status`
- [ ] **MUST** `tag` = `vX.Y.Z`
- [ ] **MUST** `target` = `main`
- [ ] **MUST** `versionInPubspec` = `X.Y.Z+N`
- [ ] **MUST** `buildStatus` = `release`（或对应状态）
- [ ] **MUST** `status` = `draft`（发布前）/ `published`（发布后）
- [ ] **MUST** `assets` 包含 APK 与 Windows ZIP 两项（含 `name` / `platform` / `size` / `sizeFormatted` / `sha256` / `localPath`）
- [ ] **MUST** `isLatest` = true（若为最新正式版）
- [ ] **MUST** JSON 格式合法

### 10.3 release_notes

- [ ] **MUST** `builds/release_notes/release_notes_vX.Y.Z.md` 文件已创建
- [ ] **MUST** 内容包含版本号、构建日期、变更说明、下载链接、SHA-256
- [ ] **MUST** `notesFile` 字段指向该文件

---

## 11. 发布说明检查 Release Notes

### 11.1 内容完整性 Content Completeness

- [ ] **MUST** 标题包含版本号与一句话摘要（如 `v2.3.3 — 首页按钮间距修复 + MIT LICENSE + Windows 图标产物归档`）
- [ ] **MUST** 列出所有新功能（如有）
- [ ] **MUST** 列出所有改进（如有）
- [ ] **MUST** 列出所有 Bug 修复（如有），关联 Bug ID 与 Commit
- [ ] **MUST** 列出已知问题（如有）及临时规避
- [ ] **MUST** 列出破坏性变更（如有）及迁移指南

### 11.2 下载信息 Download Info

- [ ] **MUST** 列出 Android APK 文件名、大小、SHA-256
- [ ] **MUST** 列出 Windows ZIP 文件名、大小、SHA-256
- [ ] **SHOULD** 提供 GitHub Release 链接（发布后回填）

### 11.3 提交列表 Commits

- [ ] **SHOULD** 列出自上一版本以来的提交（commit-sha + 类型 + 说明）

### 11.4 版权与许可证 Copyright

- [ ] **MUST** 提及 MIT 许可证与版权 `Copyright (c) 2026 Qore`

---

## 12. GitHub Release 发布检查 GitHub Publish

### 12.1 发布前 Pre-publish

- [ ] **MUST** 代码已 commit 并 push 到 `main`
- [ ] **MUST** `main` 分支构建状态为绿色
- [ ] **MUST** release_history.json 中 `status: "draft"`
- [ ] **MUST** release_notes markdown 已就绪
- [ ] **MUST** APK 与 Windows ZIP 已归档

### 12.2 创建 Release Create Release

- [ ] **MUST** tag 命名 `vX.Y.Z`（如 `v2.3.3`）
- [ ] **MUST** target = `main`
- [ ] **MUST** release title 从 release_history.json `title` 复制
- [ ] **MUST** description 从 `release_notes_vX.Y.Z.md` 复制正文（真实换行）
- [ ] **MUST** 上传 APK asset
- [ ] **MUST** 上传 Windows ZIP asset
- [ ] **MUST** 正式版勾选「Set as the latest release」
- [ ] **MUST** 非 pre-release（除非是 beta / alpha / rc）

### 12.3 发布后 Post-publish

- [ ] **MUST** GitHub Release 页可访问
- [ ] **MUST** 两个 asset 下载链接可访问
- [ ] **MUST** 更新 `release_history.json`：
  - `url`: `https://github.com/HeYS-Snowe/Jeenith/releases/tag/vX.Y.Z`
  - `publishedAt`: ISO8601 时间戳
  - 各 asset `downloadUrl`
  - `status`: `published`
- [ ] **MUST** commit & push 更新后的 `release_history.json`

### 12.4 下载验证 Download Verification

- [ ] **MUST** 在另一台设备下载 APK，安装可启动
- [ ] **MUST** 下载 APK 的 SHA-256 与 release notes 一致
- [ ] **MUST** 在另一台 Windows 设备下载 ZIP，解压可启动
- [ ] **MUST** 下载 ZIP 的 SHA-256 与 release notes 一致

---

## 13. 上线后检查 Post-launch

### 13.1 用户反馈监控 Feedback Monitoring

- [ ] **SHOULD** 发布后 24 小时内监控 GitHub Issues
- [ ] **SHOULD** 发布后 48 小时内无 Critical Bug 报告
- [ ] **SHOULD** 收集用户反馈，记录到下个版本 backlog

### 13.2 应用健康监控 Health Monitoring

由于志极无后端，无应用埋点，无崩溃上报（设计如此，无 PII 收集）。健康监控仅能通过：

- [ ] **SHOULD** 在测试设备上实际使用 30 分钟，确认无崩溃
- [ ] **SHOULD** 关注 GitHub Issues 中用户报告的问题

### 13.3 文档同步 Documentation Sync

- [ ] **MUST** `builds/release_history.json` 已更新并 push
- [ ] **MUST** `builds/build_history.json` 已更新并 push
- [ ] **SHOULD** `docs/NEXT_PLAN/` 已更新（如有规划变更）
- [ ] **SHOULD** `AGENTS.md` / `CLAUDE.md` 版本号已更新

---

## 14. 紧急回滚检查 Rollback

> 仅在发布后发现 Critical Bug 需要回滚时使用本节。

### 14.1 回滚决策 Decision

- [ ] **MUST** 确认新版本存在 Critical Bug 无法 hotfix
- [ ] **MUST** 发布负责人批准回滚
- [ ] **MUST** 准备回滚公告（GitHub Issue + Release notes 更新）

### 14.2 回滚操作 Operation

- [ ] **MUST** 在 GitHub Release 页将「Latest」标记改回上一版本
- [ ] **MUST** 创建 GitHub Issue 说明回滚原因，关联到新版本 release
- [ ] **MUST** 通知已知用户（如有沟通渠道）

### 14.3 Hotfix 流程 Hotfix Path

如选择 hotfix 而非回滚：

- [ ] **MUST** 从 `main` 拉取 `hotfix/vX.Y.(Z+1)` 分支
- [ ] **MUST** 修复 Critical Bug
- [ ] **MUST** 执行完整构建流程（步骤 5-12）
- [ ] **MUST** 创建新 GitHub Release（标记为 Latest）
- [ ] **MUST** 合并 hotfix 分支回 `main`

---

## 15. 签字确认 Sign-off

### 15.1 检查项统计 Statistics

| 等级 Level | 总数 Total | 通过 Pass | 阻塞 Block | 跳过 Skip |
|----------|----------|---------|----------|---------|
| MUST | — | — | — | — |
| SHOULD | — | — | — | — |
| NICE | — | — | — | — |
| **合计 Total** | **—** | **—** | **—** | **—** |

### 15.2 发布决策 Launch Decision

- [ ] **可发布 Go**：所有 MUST 项通过，无阻塞，建议按计划发布。
- [ ] **有条件发布 Conditional Go**：存在 SHOULD 项未通过，已记录原因，可在指定时间内补救。
- [ ] **推迟发布 Hold**：存在 MUST 项未通过，需修复后重新检查。
- [ ] **阻塞发布 Block**：存在 Critical Bug 或测试不通过，禁止发布。

### 15.3 签字 Sign-off

| 角色 Role | 姓名 Name | 日期 Date | 签字 Signature |
|----------|---------|----------|--------------|
| 发布负责人 Release Manager | HeYS-Snowe | YYYY-MM-DD | |
| 测试负责人 QA Lead | HeYS-Snowe | YYYY-MM-DD | |
| 开发负责人 Dev Lead | HeYS-Snowe | YYYY-MM-DD | |

---

## 附录：检查清单副本命名 Naming

每次发布创建本清单的副本：

```
docs/项目文档/05-部署上线 Deployment/
└── Launch_Checklist_v{version}_{date}.md
```

示例：`Launch_Checklist_v2.3.3_20260715.md`

副本中所有 `[ ]` 应替换为 `[x]` / `[!]` 实际状态，签字行填写实际日期与签名。

---

## 附录：参考文档 References

- [部署运维手册 Deployment Guide](./部署运维手册%20Deployment%20Guide.md)
- [发布说明 Release Notes](./发布说明%20Release%20Notes.md)
- [测试计划 Test Plan](../04-测试阶段%20Testing/测试计划%20Test%20Plan.md)
- [测试报告 Test Report](../04-测试阶段%20Testing/测试报告%20Test%20Report.md)
- [性能测试报告 Performance Test](../04-测试阶段%20Testing/性能测试报告%20Performance%20Test.md)
- [安全测试报告 Security Test](../04-测试阶段%20Testing/安全测试报告%20Security%20Test.md)
- [FLUTTER_APK_BUILD_PIPELINE.md](../../FLUTTER_APK_BUILD_PIPELINE.md)
- [AGENTS.md](../../../AGENTS.md)
- [CLAUDE.md](../../../CLAUDE.md)
- 项目位置：`D:\Code\Project\Qore\Jeenith`
- 仓库：https://github.com/HeYS-Snowe/Jeenith
