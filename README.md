# 志极 Jeenith

> 叩问本心的卜算合集 —— *Question the core. Return to origins.*
>
> 所属组织：**Qore（叩心）**　·　应用包名：`com.qore.jeenith`

志极是一款以"叩问本心"为核心理念的卜算应用，收录多种传统术数：**小六壬、周易（金钱卦）、梅花易数、掷筊、紫微斗数、奇门遁甲**。首页选术即占，可扩展的卜算框架——加一种新术只需新建 feature 目录 + registry 注册一行。

## 特性

- **六术合一**：小六壬、周易、梅花、掷筊、紫微、奇门，统一首页入口
- **真随机引擎**：多源 SHA256 混合（系统熵 + 指针轨迹 + 在线大气噪声 random.org），移动端采集触摸微动、桌面端采集鼠标轨迹
- **可扩展框架**：每种术实现 `DivinationTech` 接口 + registry 注册，互不干扰
- **跨平台自适应**：Android + Windows 桌面，按设备切换交互范式（触摸拖拽 / 鼠标滚轮、sheet / 分栏布局）
- **沉浸仪式感**：太极生六宫入场动画、卦象渐显、星空背景

## 卜算术清单

| 术 | 状态 | 简介 |
|----|------|------|
| 小六壬 | ✅ | 掐指神课，三段游走六宫断吉凶 |
| 周易 | ✅ | 金钱卦，三铜钱摇六爻 |
| 梅花易数 | ✅ | 数字起卦，分体用、观生克 |
| 掷筊 | ✅ | 圣杯问事 |
| 紫微斗数 | 🚧 | v1 基础版 |
| 奇门遁甲 | 🚧 | v1 基础版 |

## 技术栈

| 层级 | 技术 |
|------|------|
| 框架 | Flutter 3.x（Dart） |
| 状态管理 | Riverpod（flutter_riverpod） |
| 路由 | go_router |
| 农历 / 干支 / 节气 | lunar（寿星天文历） |
| 图标 | flutter_svg |
| 真随机 | `Random.secure` + 指针轨迹 + random.org |
| 配置持久化 | shared_preferences |

## 目录结构

```
Jeenith/
  mobile/             # Flutter 项目
    lib/
      app.dart        # JeenithApp（MaterialApp.router）
      main.dart       # 入口（async + ProviderScope）
      core/           # branding / calendar / config / divination / history / rng / theme
      data/           # yijing（64卦 + 八卦数据，周易/梅花共用）
      features/       # home / xiaoliuren / zhouyi / meihua / jiaobei / ziwei / qimen / settings / history
      providers/      # providers.dart（barrel 聚合 config + rng providers）
      router/         # app_router.dart（GoRouter）
      shared/         # widgets/（共用组件）
    scripts/          # build_apk.ps1 + archive_history.py
    android/ ios/ web/ windows/ linux/ macos/
    pubspec.yaml
  backend/            # 占位（无后端）
  design/             # 占位（设计稿）
  docs/               # FLUTTER_APK_BUILD_PIPELINE.md 等
  tools/              # 占位
  builds/             # 构建产物归档（APK/ZIP + build_history.json，不入版本控制）
```

## 构建

### 环境要求

- Flutter 3.x（Dart SDK ^3.11）
- Android：Android SDK / Gradle
- Windows：Visual Studio（含 CMake）

### Android APK

```bash
cd mobile
flutter pub get
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "1.1.2"
```

脚本自动完成：更新版本号 → 构建 → 重命名归档到 `builds/` → 写入双份 `build_history.json`。完整规范见 [`docs/FLUTTER_APK_BUILD_PIPELINE.md`](docs/FLUTTER_APK_BUILD_PIPELINE.md)。

### Windows 桌面

```bash
cd mobile
flutter build windows --release
# 产物：build/windows/x64/runner/Release/
```

### 代码检查

```bash
cd mobile && flutter analyze
```

## 扩展：加一种新卜算术

1. 新建 `mobile/lib/features/<新术>/` 目录（页面 + 算法 + `<新术>_tech.dart`）
2. 实现 `DivinationTech` 接口
3. 在 registry 注册一行

框架统一提供：注册发现、RNG 服务、配置、主题、共享组件。

## 身份与版权

- 所属组织：**Qore Origins（叩心）** —— *Question the core. Return to origins.*
- 开发者：HeYS-Snowe
- 版权：Copyright (c) 2026 Qore. All rights reserved.

> 组织、包名、署名等身份信息以 `D:\Code\.Rules\OrganizationAndUser.md` 为唯一事实来源，不在项目内硬编码。
