# CLAUDE.md — 志极 Jeenith

> 项目定制规则。身份信息（组织/包名/署名）以 `D:\Code\.Rules\OrganizationAndUser.md` 为准。

## 一、项目信息

| 属性 | 值 |
|------|-----|
| 中文名 / 英文名 | 志极 / Jeenith |
| 项目类型 | 移动 App（Flutter，Android + Windows 桌面）|
| 所属组织 | Qore（叩心）|
| 应用包名 | `com.qore.jeenith` |
| 项目位置 | `D:\Code\Project\Qore\Jeenith` |

**项目定位**：叩问本心的卜算合集——小六壬、周易、梅花易数、掷筊、紫微斗数、奇门遁甲。一个 APP 首页选术，可扩展卜算框架（加新术 = 新建 feature 目录 + 注册一行）。

## 二、目录结构

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
  backend/            # 占位（Jeenith 无后端）
  design/             # 占位（设计稿）
  docs/               # FLUTTER_APK_BUILD_PIPELINE.md 等
  tools/              # 占位（工具脚本）
  builds/             # 构建产物归档（APK/ZIP + build_history.json）
  build_history.json  # 项目内历史副本
```

## 三、技术栈

| 层级 | 技术 |
|------|------|
| 框架 | Flutter 3.x（Dart）|
| 状态管理 | Riverpod（flutter_riverpod）|
| 路由 | go_router |
| 农历/八字/节气 | lunar（寿星天文历）|
| 图标 | flutter_svg |
| 真随机 | dart:math Random.secure + 触摸轨迹 + random.org |
| 配置持久化 | shared_preferences |

## 四、构建

```bash
cd mobile
flutter pub get
flutter analyze
# APK
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "1.0.2"
# Windows 桌面
flutter build windows --release
```

构建规范见 `docs/FLUTTER_APK_BUILD_PIPELINE.md`。产物归档到 `builds/`（与 mobile/ 平级）。

## 五、后续阶段

见 memory/jeenith-future-phases.md：紫微/奇门 v2 深化、周易/梅花卦辞爻辞、结果分享、历史导出 + 主题字体。

## 六、规则

- 先看再改，理解上下文
- 身份信息以 OrganizationAndUser.md 为准，不硬编码
- 构建用 scripts/build_apk.ps1，版本号 + 归档 + 历史自动
- 加新卜算术 = 新建 features/xxx/ + 实现 DivinationTech + registry 注册一行
