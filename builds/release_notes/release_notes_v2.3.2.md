# v2.3.2 — 设置页动画细分开关 + Windows 应用图标修复

**版本**：2.3.2+22
**状态**：release
**构建日期**：2026-07-15

## 概述

v2.3.2 是志极 v2.3.x 系列的体验调优版本。设置页每术动画开关由「1 个总开关」细分为「入场仪式 / 路由转场 / 绘制过程 / 结果揭示」4 个独立开关，让用户可针对某种动画类型单独控制；同时修复了 Windows 桌面产物一直使用 Flutter 默认图标的问题，应用图标现正确显示志极品牌图标。`flutter analyze` 0 issue 通过。

## 一、设置页动画细分开关

### 1. 数据结构升级

[app_config.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/core/config/app_config.dart) 新增 `enum AnimationKind { entrance, transition, painter, reveal }`：

- `entrance`：入场仪式（仪式动画页面 / 路由前置过渡）
- `transition`：路由转场（TechTransition）
- `painter`：绘制过程（CustomPainter 的 progress 动画）
- `reveal`：结果揭示（RevealAnimation 封装）

`AppConfig.animationSettings` 从 `Map<String, bool>` 升级为 `Map<String, Map<String, bool>>`（外层 key = techId，内层 key = AnimationKind 字符串）。`isAnimationEnabled(techId)` 改为 `isAnimationEnabled(techId, AnimationKind kind)`，未记录时默认 true（向前兼容）。

### 2. prefs key 格式

[config_providers.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/core/config/config_providers.dart) prefs key 由 `anim_<techId>` 改为 `anim_<techId>_<kind>`（如 `anim_xiaoliuren_entrance`）。techId 可能含下划线（如 `name_test`），故以最后一个下划线分段：尾部为 kind，前面合并为 techId。旧 prefs key 自动忽略（不影响默认行为）。

### 3. 设置页 UI

[settings_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/settings/settings_page.dart) 每术 ExpansionTile 内由 1 个「开启此术动画」开关改为 4 个紧凑型 SwitchListTile，分别控制入场仪式 / 路由转场 / 绘制过程 / 结果揭示。顶部「开启所有分类 / 关闭所有分类」一键按钮现作用于所有 4 个 kind。

## 二、调用点适配

10 处调用点全部更新，按 kind 传入：

| 文件 | kind | 用途 |
|------|------|------|
| [home_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/home/home_page.dart) | entrance | 决定是否走仪式路由 `/ritual/<id>` |
| [app_router.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/router/app_router.dart) | transition | TechTransition 路由转场开关 |
| [ziwei_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/ziwei/ui/ziwei_page.dart) | painter | StarChartPainter 绘制过程动画 |
| [ziwei_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/ziwei/ui/ziwei_page.dart) | reveal | RevealAnimation.enabled |
| [bazi_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/bazi/ui/bazi_page.dart) | reveal | RevealAnimation.enabled |
| [cezi_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/cezi/ui/cezi_page.dart) | reveal | RevealAnimation.enabled |
| [chouqian_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/chouqian/ui/chouqian_page.dart) | reveal | RevealAnimation.enabled |
| [daliuren_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/daliuren/ui/daliuren_page.dart) | reveal | RevealAnimation.enabled |
| [jiaobei_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/jiaobei/ui/jiaobei_page.dart) | reveal | RevealAnimation.enabled |
| [qimen_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/qimen/ui/qimen_page.dart) | reveal | RevealAnimation.enabled |
| [name_test_page.dart](file:///d:/Code/Project/Qore/Jeenith/mobile/lib/features/name_test/ui/name_test_page.dart) | reveal | RevealAnimation.enabled |

## 三、Windows 应用图标修复

### 问题

Windows 桌面产物一直使用 Flutter 默认图标（Flutter logo），未应用志极品牌图标。`flutter_launcher_icons` 包不支持 Windows 平台，`mobile/windows/runner/resources/app_icon.ico` 一直保留 Flutter 模板默认文件。

### 修复

用 Python PIL 将 `mobile/ico/icon.png` 转换为多尺寸 `.ico`（256/128/64/48/32/16），直接替换 `mobile/windows/runner/resources/app_icon.ico`。`Runner.rc` 第 55 行 `IDI_APP_ICON ICON "resources\\app_icon.ico"` 引用路径不变，下次 `flutter build windows` 即生效。

## 四、版本号更新

- pubspec.yaml：2.3.1+21 → 2.3.2+22
- 构建序号：20260715 第 01 序

## 五、下载

| 平台 | 文件名 | 大小 | SHA-256 |
|------|--------|------|---------|
| Android | Jeenith_release_2.3.2_20260715_01.apk | 55.00 MB / 57667575 B | 3ECCD3191D225526A232EA104BBA581EA121F47EBDEFBE44797D798667257BE7 |
| Windows x64 | Jeenith_release_2.3.2_20260715_01_windows_x64.zip | 13.38 MB / 14025569 B | E055EEF259423A8424122AEF8D98BC84F03FB05074A7EF86ED1308595A24E404 |
