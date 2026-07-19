# 志极 Jeenith — 项目总结

> 供协作智能体快速了解项目全貌。详细信息见 `CLAUDE.md` / `AGENTS.md`。

---

## 一、项目概述

| 属性 | 值 |
|------|-----|
| 中文名 / 英文名 | 志极 / Jeenith |
| 品牌精神 | 志于本心，知于极处 |
| 所属组织 | Qore（叩心）· 口号「叩问本心，不忘初心」 |
| 包名 | `com.qore.jeenith` |
| 当前版本 | **2.9.0+36**（2026-07-20，feature — 六爻断法深化：旬空/六冲六合）|
| 项目位置 | `D:\Code\Project\Qore\Jeenith` |
| GitHub 仓库 | https://github.com/HeYS-Snowe/Jeenith |
| 身份信息源 | `D:\Code\.Rules\OrganizationAndUser.md`（唯一事实来源）|

**定位**：叩问本心的卜算合集——一个 APP 首页选术，承载 15 种中国传统卜算术 + 使用手册。核心价值是**可扩展卜算框架**：加新术 = 新建一个 feature 目录 + 注册一行，不改 core/shared。

**v2.0.0 标志**：结束 1.x 功能堆叠阶段，转向 2.x 交互体验与极致细节阶段。按钮物理反馈（0.95 缩放 + easeOutBack 弹回）、图标状态切换动画（+ ↔ x）、设置页全局动效开关三大微交互落地。

---

## 二、技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 框架 | Flutter 3.x（Dart 3.11+）| Android + Windows 桌面 |
| 状态管理 | Riverpod（flutter_riverpod ^2.5）| |
| 路由 | go_router ^14.0 | |
| 农历/八字/节气 | lunar ^1.7.8（寿星天文历）| 紫微/奇门/时辰起卦共用 |
| 图标 | flutter_svg ^2.0 | SVG 矢量图标 |
| 真随机 | dart:math Random.secure + 触摸轨迹 + http random.org + crypto SHA256 | 3 源混合真随机引擎 |
| 配置持久化 | shared_preferences ^2.2 | |
| 设备传感器 | sensors_plus ^6.0.0 | 陀螺仪/磁场（风水罗盘实时指向）|
| 结果分享 | share_plus ^10.0.0 | 系统分享面板（文本/截图）|
| 文件路径 | path_provider ^2.1.0 | 历史记录 JSON 导出 |
| APP 图标 | flutter_launcher_icons ^0.14 | |
| 微交互动效 | 自定义 AnimationController | 封装在 core/theme/animations.dart |

---

## 三、项目结构

```
Jeenith/                           # 仓库根（solution root）
├── mobile/                        # Flutter 项目
│   ├── lib/
│   │   ├── app.dart               # JeenithApp（MaterialApp.router + Starfield 背景 + 主题模式）
│   │   ├── main.dart              # 入口（async + ProviderScope + 桌面窗口尺寸初始化）
│   │   ├── core/
│   │   │   ├── branding.dart      # 品牌常量（appName/tagline/copyright）
│   │   │   ├── calendar/          # lunar_service（农历服务）
│   │   │   ├── config/            # app_config + config_providers + platform_info（设备检测）
│   │   │   ├── divination/        # ★ 卜算框架抽象（DivinationTech + Registry + Result 模型）
│   │   │   ├── history/           # history_store（SharedPreferences JSON 持久化 + 原子读改写）
│   │   │   ├── rng/               # ★ 真随机引擎（3 源 SHA256 混合；触摸/鼠标轨迹自适应）
│   │   │   └── theme/             # app_theme.dart + animations.dart（动效常量与工具）
│   │   ├── data/
│   │   │   └── yijing/            # 64 卦 + 八卦数据 + 卦辞爻辞（周易/梅花共用）
│   │   ├── features/
│   │   │   ├── home/              # 首页（选术卡片 grid + 设置/历史/手册按钮 + 使用方法卡片）
│   │   │   ├── xiaoliuren/        # 小六壬（圆盘 + 仪式入场 + 七维断辞）
│   │   │   ├── zhouyi/            # 周易（金钱卦 + 逐爻揭示 + 卦辞爻辞）
│   │   │   ├── meihua/            # 梅花易数（数字起卦 + 体用 + 卦辞爻辞）
│   │   │   ├── jiaobei/           # 掷筊（杯筊 + 连掷累计）
│   │   │   ├── ziwei/             # 紫微斗数 v2（命身宫+12宫+14主星+辅星安星）
│   │   │   ├── qimen/             # 奇门遁甲 v2（阴阳遁+局数+四盘九宫）
│   │   │   ├── chouqian/          # 抽签求签（60 甲子签 + 签诗）
│   │   │   ├── cezi/              # 测字（单字五行 + 笔画断辞）
│   │   │   ├── daliuren/          # 大六壬（四课三传 + 天将 + 天盘地盘）
│   │   │   ├── luopan/            # 风水罗盘（实时磁场 + 24 山方位）
│   │   │   ├── manual/            # 使用手册页面（5 章节：基础/时辰 Q&A/历法体系/各术归属/实操提醒）
│   │   │   ├── settings/          # 设置页（主题/动效/仪式/采样/在线/导出）
│   │   │   └── history/           # 历史记录页（列表+详情+备注+删除+复制）
│   │   ├── providers/             # providers.dart（barrel 聚合 config + rng providers）
│   │   ├── router/                # app_router.dart（GoRouter + 仪式路由）
│   │   └── shared/
│   │       └── widgets/           # GoldButton / DarkButton / AnimatedExpandIcon / SvgIcon /
│   │                              #   DecorativePanel / EntranceItem / InteractableCard /
│   │                              #   CopyResultButton / ShareResultButton / GuideDialog /
│   │                              #   Starfield / SectionTitle
│   ├── scripts/
│   │   ├── build_apk.ps1          # APK 构建脚本（版本递增+归档+历史）
│   │   └── archive_history.py     # 历史记录追加（双份 build_history.json）
│   ├── android/ ios/ web/ windows/ linux/ macos/
│   ├── pubspec.yaml               # version: 2.4.1+25
│   ├── build_history.json         # 项目内历史副本
│   ├── ico/                       # APP 图标素材
│   └── assets/icons/              # SVG 图标
├── backend/                       # 占位（Jeenith 无后端）
├── design/                        # 占位（设计稿）
├── docs/                          # 文档（PROJECT_SUMMARY / FLUTTER_APK_BUILD_PIPELINE / NEXT_PLAN 等）
├── tools/                         # 占位（工具脚本）
├── builds/                        # ★ 构建产物归档（按平台分类，产物不入 git）
│   ├── android/                   # APK（build_apk.ps1 自动归档）
│   ├── windows/                   # Windows zip（手动归档）
│   ├── release_notes/             # 各版本 Release 说明 md（真实换行，复制粘贴用）
│   ├── build_history.json         # 构建历史（归档区主副本）
│   └── release_history.json       # 平台发布记录（GitHub Release 等）
├── log/                           # 更新日志（log/update/*.md）+ 崩溃日志（log/crush/）
├── CLAUDE.md                      # 项目定制规则
└── AGENTS.md                      # Agent 规则（与 CLAUDE.md 同步）
```

---

## 四、功能清单

### 15 种卜算术

| 术 | id | 玩法 | 完成度 |
|----|----|------|--------|
| **小六壬** | xiaoliuren | 掐指数数落宫（大安→留连→速喜→赤口→小吉→空亡），三段落宫 | ✅ 完整（圆盘动画 + 仪式入场 + 七维断辞）|
| **周易** | zhouyi | 金钱卦摇六爻，本卦+变卦 | ✅ 完整（逐爻揭示 + 变爻 + 卦辞爻辞）|
| **梅花易数** | meihua | 两数起卦，上下卦+动爻，体用 | ✅ 完整（+ 卦辞爻辞）|
| **掷筊** | jiaobei | 两片杯筊，圣/笑/阴筊 | ✅ 完整（连掷累计）|
| **紫微斗数** | ziwei | 公历生辰→命身宫+12宫+五行局+14主星+辅星 | ✅ v2.5 完整（四化/大限/长生/补煞 + 环形命盘）|
| **奇门遁甲** | qimen | 时辰→阴阳遁+局数+节气+四盘九宫 | ✅ v2.5 完整（天盘干/11 格局断辞 + 值符值使/八门/九星/八神）|
| **抽签** | chouqian | 60 甲子签，签诗 + 解签 | ✅ 完整 |
| **测字** | cezi | 单字五行 + 康熙笔画断辞 | ✅ 完整 |
| **大六壬** | daliuren | 四课三传 + 天将 + 天盘地盘 | ✅ 完整 |
| **风水罗盘** | luopan | 实时磁场传感器 + 24 山方位 | ✅ 完整（sensors_plus 实时指向）|
| **测名字** | name_test | 姓名康熙笔画 → 三才五格 + 五行喜忌 | ✅ 完整 |
| **八字推演** | bazi | 四柱 + 大运 + 神煞 + 五行喜忌 | ✅ 完整 |
| **称骨算命** | chenggu | 袁天罡称骨：年月日时四骨重→52 档命格歌 | ✅ v2.6 完整 |
| **太乙神数** | taiyi | 三式之首：积年推太乙落宫/文昌始击/主客算/格局 | ✅ v2.7 完整（三式齐备）|
| **六爻** | liuyao | 京房纳甲：金钱卦六爻配六亲六神/世应用神断辞 | ✅ v2.8 完整 + v2.9 深化（八宫算法 + 旬空/六冲六合）— 12 项单测 |

### 框架特性

- **可扩展卜算框架**：`DivinationTech` 抽象（id/meta/buildPage）+ `divinationRegistry`（加新术 = 追加一行）+ 统一结果模型 `DivinationResult`
- **真随机引擎**（`core/rng/`）：3 源 SHA256 混合（系统熵 Random.secure + 触摸轨迹 PointerEvent + random.org 大气噪声），链式扩展生成，可配置开关
- **仪式入场动画**（小六壬）：太极缩放旋转 + 同心圆错峰 + 六宫绕行归位，可设置切换
- **首次使用方法弹窗**：3 秒禁关 + SharedPreferences 标记首次
- **首页置顶使用方法卡片**：可收起 ExpansionTile（v2.0.0 起配 AnimatedExpandIcon 状态切换动画）
- **复制结果**（10 术）：一键复制详细文本（术名+时间+取数/卦象+断辞+采样）
- **分享结果**（10 术）：share_plus 系统分享面板，支持文本 + RepaintBoundary 截图
- **历史记录**：SharedPreferences JSON 持久化，列表+详情+备注+删除+复制，可导出 JSON 文件
- **使用手册页面**：5 章节（基础使用/时辰边界 Q&A/历法体系区分/各术数历法归属/实操提醒）
- **设置页**：主题模式（深色/浅色/跟随系统）/ 微交互动效总开关 / 仪式入场动画 / 采样详情 / 在线大气噪声 / 历史导出

### UI / 交互

- **深色中国风**：玄黑底（#0C0A12）+ 鎏金（#D4A857）+ 朱砂（#E85A3C）+ 五行色（木青/水蓝/火红/金白/土黄）。遵循 oklch 色彩思路，无高饱和光污染。
- **微交互动效 v2.0.0**：
  - **按钮物理反馈**：GoldButton / DarkButton 改 ConsumerStatefulWidget，按动 0.95 缩放 + 阴影变化 + easeOutBack 弹回（`Cubic(0.34, 1.56, 0.64, 1)`），调用方零改动
  - **图标状态切换**：AnimatedExpandIcon 组件，AnimatedRotation 0°→90° 旋转 + 点击瞬间 AnimatedScale 呼吸反馈
  - **动效总开关**：AppConfig.animationsEnabled 持久化到 SharedPreferences，设置页可关闭，关闭后不影响任何核心功能
  - **动效常量集中**：core/theme/animations.dart 统一管理所有时长/曲线/错峰间隔
- **层叠布局**（小六壬/周易）：圆盘/六爻固定底层 + `DraggableScrollableSheet` 上层可拖拽覆盖 + 交互 `SliverPersistentHeader(pinned)` 粘顶吸附
- **设备自适应**（`core/config/platform_info.dart`）：移动端用 DraggableScrollableSheet 拖拽；桌面端鼠标拖拽不灵，改 `Column` 上下分栏。指针轨迹熵源——移动端走 `onPointerMove`、桌面端走 `onPointerHover`
- **入场动画**：首页选术卡片错峰淡入上浮（InteractableCard + AppAnimations.staggeredIntervals）
- **Starfield 星空背景**：全局粒子背景
- **桌面窗口尺寸**：基于屏幕可视区计算，9:18.5 宽高比，clamp 在 380×600 ~ 1400×2789
- **高 DPI**：AA_EnableHighDpiScaling + AA_UseHighDpiPixmaps

---

## 五、构建

### APK（Android）

```bash
cd mobile
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "2.0.0"
```

脚本自动：更新 pubspec 版本 → flutter build → 备份 → 重命名 → 归档到 `builds/android/` → 追加双份 `build_history.json`。构建失败自动回滚版本号。

### Windows 桌面

```bash
cd mobile
flutter build windows --release
# 产物：build/windows/x64/runner/Release/jeenith.exe
# 手动 zip 归档到 builds/windows/：
pwsh -c "Compress-Archive -Path build/windows/x64/runner/Release/* -DestinationPath ../builds/windows/Jeenith_<状态>_<版本>_<日期>_01_windows_x64.zip -Force"
```

### 构建规范

详见 `docs/FLUTTER_APK_BUILD_PIPELINE.md`。命名规则：`Jeenith_{状态}_{版本}_{日期}_{序号}.apk/.zip`。产物按平台分类归档：`builds/android/`（APK）、`builds/windows/`（zip）。GitHub Release 发布记录在 `builds/release_history.json` + `builds/release_notes/`。

### 当前归档（builds/android/ + builds/windows/）

| 文件 | 平台 | 版本 | 大小 | 状态 |
|------|------|------|------|------|
| Jeenith_release_1.0.0_20260711_01.apk | Android | 1.0.0+1 | 50.66 MB | release |
| Jeenith_release_1.0.1_20260711_01.apk | Android | 1.0.1+2 | 50.69 MB | release |
| Jeenith_release_1.0.1_20260711_01_windows_x64.zip | Windows | 1.0.1+2 | 12.30 MB | release |
| Jeenith_release_1.1.0_20260712_01.apk | Android | 1.1.0+4 | 50.97 MB | release |
| Jeenith_release_1.1.0_20260712_01_windows_x64.zip | Windows | 1.1.0+4 | 12.34 MB | release |
| Jeenith_fix_1.1.2_20260712_01.apk | Android | 1.1.2+6 | 50.97 MB | fix |
| Jeenith_fix_1.1.2_20260712_01_windows_x64.zip | Windows | 1.1.2+6 | 12.61 MB | fix |
| Jeenith_fix_1.1.3_20260712_01.apk | Android | 1.1.3+7 | 51.23 MB | fix |
| Jeenith_fix_1.1.3_20260712_01_windows_x64.zip | Windows | 1.1.3+7 | 12.74 MB | fix |
| Jeenith_feature_1.2.0_20260713_01.apk | Android | 1.2.0+9 | 51.26 MB | feature |
| Jeenith_feature_1.2.0_20260713_01_windows_x64.zip | Windows | 1.2.0+9 | 12.76 MB | feature |
| Jeenith_feature_1.3.0_20260713_01.apk | Android | 1.3.0+10 | 51.30 MB | feature |
| Jeenith_feature_1.3.0_20260713_01_windows_x64.zip | Windows | 1.3.0+10 | 12.77 MB | feature |
| Jeenith_feature_1.4.0_20260713_01.apk | Android | 1.4.0+11 | 51.31 MB | feature |
| Jeenith_feature_1.4.0_20260713_01_windows_x64.zip | Windows | 1.4.0+11 | 12.77 MB | feature |
| Jeenith_feature_1.5.0_20260713_01.apk | Android | 1.5.0+12 | 52.43 MB | feature |
| Jeenith_feature_1.5.0_20260713_01_windows_x64.zip | Windows | 1.5.0+12 | 12.70 MB | feature |
| Jeenith_feature_1.6.0_20260713_01.apk | Android | 1.6.0+13 | 52.54 MB | feature |
| Jeenith_feature_1.6.0_20260713_01_windows_x64.zip | Windows | 1.6.0+13 | 13.00 MB | feature |
| Jeenith_feature_1.7.0_20260713_01.apk | Android | 1.7.0+14 | 52.92 MB | feature |
| Jeenith_feature_1.7.0_20260713_01_windows_x64.zip | Windows | 1.7.0+14 | 13.03 MB | feature |
| Jeenith_feature_1.8.0_20260713_01.apk | Android | 1.8.0+15 | 53.04 MB | feature |
| Jeenith_feature_1.8.0_20260713_01_windows_x64.zip | Windows | 1.8.0+15 | 13.06 MB | feature |
| **Jeenith_release_2.0.0_20260714_01.apk** | **Android** | **2.0.0+16** | **53.06 MB** | **release** |
| **Jeenith_release_2.0.0_20260714_01_windows_x64.zip** | **Windows** | **2.0.0+16** | **21.00 MB** | **release** |
| Jeenith_release_2.3.1_20260715_01.apk | Android | 2.3.1+21 | 54.98 MB | release |
| Jeenith_release_2.3.2_20260715_01.apk | Android | 2.3.2+22 | 55.00 MB | release |
| Jeenith_release_2.3.2_20260715_01_windows_x64.zip | Windows | 2.3.2+22 | 13.27 MB | release |
| **Jeenith_release_2.3.3_20260715_01.apk** | **Android** | **2.3.3+23** | **55.00 MB** | **release** |
| **Jeenith_release_2.3.3_20260715_01_windows_x64.zip** | **Windows** | **2.3.3+23** | **13.27 MB** | **release** |
| Jeenith_release_2.4.0_20260715_01.apk | Android | 2.4.0+24 | 55.14 MB | release |
| Jeenith_release_2.4.0_20260715_01_windows_x64.zip | Windows | 2.4.0+24 | 13.01 MB | release |
| **Jeenith_fix_2.4.1_20260718_01.apk** | **Android** | **2.4.1+25** | **73.89 MB** | **fix** |
| **Jeenith_fix_2.4.1_20260718_01_windows_x64.zip** | **Windows** | **2.4.1+25** | **40.01 MB** | **fix** |
| **Jeenith_feature_2.4.2_20260718_01.apk** | **Android** | **2.4.2+26** | **74.06 MB** | **feature** |
| **Jeenith_feature_2.4.2_20260718_01_windows_x64.zip** | **Windows** | **2.4.2+26** | **32.09 MB** | **feature** |
| **Jeenith_feature_2.4.3_20260719_01.apk** | **Android** | **2.4.3+27** | **75.01 MB** | **feature** |
| **Jeenith_feature_2.4.3_20260719_01_windows_x64.zip** | **Windows** | **2.4.3+27** | **32.37 MB** | **feature** |
| **Jeenith_feature_2.4.4_20260719_01.apk** | **Android** | **2.4.4+28** | **58.26 MB** | **feature** |
| **Jeenith_feature_2.4.4_20260719_01_windows_x64.zip** | **Windows** | **2.4.4+28** | **15.58 MB** | **feature** |
| **Jeenith_feature_2.5.0_20260719_01.apk** | **Android** | **2.5.0+29** | **58.34 MB** | **feature** |
| **Jeenith_feature_2.5.0_20260719_01_windows_x64.zip** | **Windows** | **2.5.0+29** | **15.59 MB** | **feature** |
| **Jeenith_feature_2.6.0_20260719_01.apk** | **Android** | **2.6.0+30** | **58.59 MB** | **feature** |
| **Jeenith_feature_2.6.0_20260719_01_windows_x64.zip** | **Windows** | **2.6.0+30** | **15.62 MB** | **feature** |
| **Jeenith_feature_2.7.0_20260719_01.apk** | **Android** | **2.7.0+31** | **58.64 MB** | **feature** |
| **Jeenith_feature_2.7.0_20260719_01_windows_x64.zip** | **Windows** | **2.7.0+31** | **15.63 MB** | **feature** |
| **Jeenith_fix_2.7.1_20260719_01.apk** | **Android** | **2.7.1+32** | **58.64 MB** | **fix** |
| **Jeenith_fix_2.7.1_20260719_01_windows_x64.zip** | **Windows** | **2.7.1+32** | **15.63 MB** | **fix** |
| **Jeenith_feature_2.8.0_20260719_01.apk** | **Android** | **2.8.0+34** | **58.81 MB** | **feature** |
| **Jeenith_feature_2.8.0_20260719_01_windows_x64.zip** | **Windows** | **2.8.0+34** | **15.65 MB** | **feature** |
| **Jeenith_fix_2.8.1_20260719_01.apk** | **Android** | **2.8.1+35** | **58.81 MB** | **fix** |
| **Jeenith_fix_2.8.1_20260719_01_windows_x64.zip** | **Windows** | **2.8.1+35** | **15.65 MB** | **fix** |

### GitHub Release 发布记录

`builds/release_history.json` 记录全部已构建 release：v1.0.0 / v1.0.1 / v1.1.0 / v1.1.2 已在 GitHub 发布（`published`），v1.1.3 ~ v2.3.3 仅本地构建（`unpublished`，待发布）。各版本 notes 见 `builds/release_notes/release_notes_<tag>.md`。

---

## 六、版本演进时间线

| 版本 | 日期 | 状态 | 核心内容 |
|------|------|------|----------|
| 1.0.0+1 | 2026-07-11 | release | 志极首个正式版本（6 术：小六壬/周易/梅花/掷筊/紫微 v1/奇门 v1）|
| 1.0.1+2 | 2026-07-11 | release | 新增 Windows 桌面平台支持 |
| 1.1.0+4 | 2026-07-12 | release | 工程迁移至 mobile/ 子目录 |
| 1.1.2+6 | 2026-07-12 | fix | Windows 桌面适配 + 真机在线熵源修复 |
| 1.1.3+7 | 2026-07-12 | fix | 全面代码质量审计修复 + 桌面端窗口尺寸修复 |
| 1.2.0+9 | 2026-07-13 | feature | 周易/梅花卦辞爻辞数据与文本展示 |
| 1.3.0+10 | 2026-07-13 | feature | 紫微斗数 v2 全套星曜安星（14 主星 + 辅星）|
| 1.4.0+11 | 2026-07-13 | feature | 奇门遁甲 v2 四盘九宫 |
| 1.5.0+12 | 2026-07-13 | feature | 主题切换 + 结果分享 + 历史导出 |
| 1.6.0+13 | 2026-07-13 | feature | 抽签求签 + 测字（术数扩到 10 种）|
| 1.7.0+14 | 2026-07-13 | feature | 大六壬全套 + 风水罗盘（sensors_plus）|
| 1.8.0+15 | 2026-07-13 | feature | 使用手册页面 + 圆角修复 + 历史复制 + 默认深色 |
| **2.0.0+16** | **2026-07-14** | **release** | **体验深化与品牌定调：按钮物理反馈 + 图标状态切换 + 动效开关** |
| 2.1.0+17 | 2026-07-14 | feature | 动效体系 Phase 1-3（入场仪式 + 路由转场 + HoverableIconButton）|
| 2.2.0+18 | 2026-07-14 | feature | 动效体系 Phase 4-6（绘制过程 + 结果揭示 + 设置开关）|
| 2.2.0+19 | 2026-07-14 | fix | v2.2.0 修订 |
| 2.3.0+20 | 2026-07-15 | feature | 八字推演 + 测名字 + 紫微盘重构 + 设置页动画 Map 化 |
| 2.3.1+21 | 2026-07-15 | release | 起卦按钮 BUG 修复 + 动效曲线优化 |
| 2.3.2+22 | 2026-07-15 | release | 设置页动画细分开关（4 个 AnimationKind）+ Windows 应用图标修复 |
| **2.3.3+23** | **2026-07-15** | **release** | **首页按钮间距修复 + MIT LICENSE + Windows 图标产物归档** |
| 2.4.0+24 | 2026-07-15 | release | 八字/测名字入场仪式 + 一键获取当前时间 + 词库扩展 + All rights reserved 全面移除 |
| **2.4.1+25** | **2026-07-18** | **fix** | **思源宋体接入 + 分享图主题背景 + 首页使用方法默认折叠 + 首页卡片浅色修复** |
| **2.4.2+26** | **2026-07-18** | **feature** | **浅色模式全面适配：深浅渐变切换（Color.lerp + ThemeAnimScope）+ 12 术 page 主题感知 + 命盘/天盘/罗盘 painter 注入 AppClr** |
| **2.4.3+27** | **2026-07-19** | **feature** | **历史预览（11 术恢复）+ 罗盘视觉统一 + 康熙笔画数据集（2 万字）+ RevealAnimation 第二次卜算重放修复** |
| **2.4.4+28** | **2026-07-19** | **feature** | **思源宋体子集化（APK 75→58 MB）+ 复杂术引导遮罩 + 共享组件浅色收尾** |
| **2.5.0+29** | **2026-07-19** | **feature** | **紫微深化（四化/大限/长生/8 补煞）+ 奇门深化（天盘干/11 格局断辞）— 断卦核心补全** |
| **2.6.0+30** | **2026-07-19** | **feature** | **称骨算命（袁天罡，第 13 术）— 年月日时四骨重 + 52 档命格歌** |
| **2.7.0+31** | **2026-07-19** | **feature** | **太乙神数（三式之首，第 14 术）— 积年推太乙落宫/文昌始击/主客算/格局，三式齐备** |
| **2.7.1+32** | **2026-07-19** | **fix** | **GoldButton 根治竖线坍塌（Transform.scale intrinsic）+ 按压缩放延迟（Listener 绕过 arena）** |
| **2.8.0+34** | **2026-07-19** | **feature** | **六爻纳甲（周易深度断法，第 15 术）— 京房纳甲/六亲/六神/世应/用神断辞 + 八宫算法 + 9 项单测** |
| **2.8.1+35** | **2026-07-19** | **fix** | **修复周易/小六壬桌面端 pinned header 崩溃（SliverPersistentHeader extent 与 ActionBar child 高度不匹配 → paintExtent<layoutExtent 空指针）** |
| **2.9.0+36** | **2026-07-20** | **feature** | **六爻断法深化：旬空（用神空亡断 + score 调整）+ 六冲/六合卦（格局判断 + 断辞 + UI chip）— 3 项新单测** |

---

## 七、后续待做

参考 `docs/NEXT_PLAN/` 与项目 memory：

1. ~~思源宋体字体~~ ✅ v2.4.1 已接入（Regular + Bold）；剩余**字体子集化**（pyftsubset 提取常用 3500 字 → 每 weight ~3 MB）以缩减 APK 体积
2. ~~浅色模式全面适配~~ ✅ v2.4.2 已完成（深浅渐变切换 + 12 术 page 主题感知 + painter 注入 AppClr）；剩余少数共享 widget（gold_button / dark_button / guide_dialog 等）逐个审计 + 思源宋体子集化缩减体积
3. **历史记录预览**（v2.4.3）：新历史存结构化 `extra` 字段支持恢复卦象；旧历史（仅文本）预览按钮置灰
4. **测字词库扩展**（v2.4.3）：接入开源康熙笔画数据集，替代当前 ~400 字 `Map`
5. **首次使用引导遮罩**：对高度复杂的术数（大六壬、奇门、紫微）新增首次使用遮罩层或指引
6. ~~紫微/奇门深化~~ ✅ v2.5.0 已完成紫微四化/大限/长生/补充神煞 + 奇门天盘干/格局断辞（断卦核心补全）；剩余奇门飞盘法（转盘法已完整，飞盘为另一体系可选）
7. **历史记录云同步**：可选后端账户体系，跨设备同步历史
8. ~~太乙神数~~ ✅ v2.7.0 已完成（三式之首，凑齐全套最高权威术数体系：奇门 + 大六壬 + 太乙）；剩余太乙月日时家推演、阴遁精细校验可后续深化
9. **更多卜算术**：~~六爻纳甲~~ ✅ v2.8.0 已完成（周易深度断法：纳甲/六亲/六神/世应/用神断辞 + 八宫算法 + 9 项单测）；铁板神数（需万条条文）、诸葛神数（需 384 签数据集）、择日黄历（lunar 库支持）

---

## 八、注意事项（踩坑记录）

### 环境与工具链
- **Flutter SDK 路径**：`D:\Mobile_Development\Flutter\Flutter_SDK\bin\flutter.bat`
- **pub-cache 路径**：`D:\Mobile_Development\pub-cache\`
- **Android 模拟器**：emulator-5554（sdk gphone64 x86 64）
- **PowerShell 版本**：必须用 `pwsh`（PowerShell 7+），5.x 默认 GBK 解析中文注释会报错；git commit 不能用 heredoc，需 `Out-File` 写临时文件再 `git commit -F`

### 构建
- **lintVitalRelease "37.0" bug**：`shared_preferences_android:lintVitalRelease` 报 `For input string: "37.0"`（lint 工具自身 bug），`build.gradle.kts` 加 `lint { checkReleaseBuilds = false }` 规避
- **release 包 INTERNET 权限缺失**：release 只合并 main manifest，main 必须显式声明 `<uses-permission android:name="android.permission.INTERNET"/>`，否则 release 包联网全失败
- **CMake 缓存路径冲突**：项目移动后 `build/windows/x64/CMakeCache.txt` 路径不匹配，删 `build/windows` 后重 build
- **构建脚本 buildsDir**：`build_apk.ps1` 的 `$buildsDir = Join-Path $projectRoot "..\builds"`（builds 在仓库根，与 mobile/ 平级）
- **Release 构建签名**：必须使用专用 release keystore，不能用 debug signing
- **Windows zip 体积变化**：v1.8.0 13.06 MB → v2.0.0 21.00 MB，因 ConsumerStatefulWidget 引入 Riverpod 引用与 Flutter 版本变化，功能正常

### 开发与 UI
- **DraggableScrollableSheet controller**：`ScrollController?` 可空，builder 内赋值，jumpTo 用 `?.hasClients` 守卫
- **SliverPersistentHeader SliverGeometry 错**：`maxExtent` 必须与 child 实际高度一致，否则 `layoutExtent > paintExtent` 崩溃
- **InteractableCard Interval end > 1**：首页卡片入场动画 `Interval(begin, end)` 的 end 必须 ≤ 1.0，用 `.clamp(0.0, 1.0).toDouble()` 规避
- **HistoryStore const []**：`load()` 返回 `const []` 是不可修改列表，`list.insert` 会崩；用 `<HistoryEntry>[]`
- **HistoryStore 原子读改写**：快速连续卜算时多次 `load → insert → save` 可能丢数据，必须使用原子读-改-写模式
- **DraggableScrollableSheet + 圆盘位置**：圆盘用 `Transform.translate(offset: Offset(0, -80))` 上移
- **桌面端 sheet 拖拽不灵**：用 `PlatformInfo.isDesktop` 分支改 `Column` 上下分栏
- **桌面端 onPointerHover vs onPointerMove**：鼠标自由移动触发 `onPointerHover`（非 `onPointerMove`）
- **feature 根目录 tech 文件 import 层级**：`features/<x>/<x>_tech.dart` 在 feature 根，import core 用两层 `../../core/`
- **TextPainter dispose**：CustomPainter 中所有 TextPainter 实例必须显式 dispose，否则会泄漏 native handle（项目 10 处已全部正确释放）
- **圆角点击区域**：SwitchListTile/ExpansionTile/ListTile/DecorativePanel 必须设置 `shape` 和 `clipBehavior: Clip.antiAlias`，确保点击区域与视觉圆角一致
- **C++ 源文件注释**：项目内 C++ 源文件（windows/runner 等）必须使用英文注释，避免编码问题
- **ExpansibleController 替代 ExpansionTileController**：Flutter 3.31+ 起 `ExpansionTileController` 已废弃，改用 `ExpansibleController`

### .gitignore 建议
- `builds/android/`、`builds/windows/` 不入 git（APK/zip 大二进制，用 NAS/云盘/GitHub Release 备份）
- `build_history.json`（两份）+ `release_history.json` + `builds/release_notes/` 入 git（记录凭证）
- `mobile/build/` 不入 git

---

## 九、关键文件速查

| 文件 | 作用 |
|------|------|
| `mobile/lib/core/divination/divination_tech.dart` | 卜算框架抽象（DivinationTech + TechMeta）|
| `mobile/lib/core/divination/divination_registry.dart` | ★ 加新术的唯一修改点 |
| `mobile/lib/core/config/platform_info.dart` | 设备检测（mobile/desktop/web + 细分平台）|
| `mobile/lib/core/config/app_config.dart` | AppConfig（showDetails/useOnline/animationsEnabled/themeMode 等）|
| `mobile/lib/core/config/config_providers.dart` | Riverpod config provider + 持久化方法 |
| `mobile/lib/core/rng/true_random.dart` | 真随机引擎（3 源 SHA256）|
| `mobile/lib/core/history/history_store.dart` | 历史记录存储（原子读改写）|
| `mobile/lib/core/theme/app_theme.dart` | AppColors 色板 + appTheme() + 深色/浅色主题 |
| `mobile/lib/core/theme/animations.dart` | v2.0.0 微交互动效常量与工具（时长/曲线/错峰间隔）|
| `mobile/lib/shared/widgets/gold_button.dart` | GoldButton（v2.0.0 升级为 ConsumerStatefulWidget + 按压动画）|
| `mobile/lib/shared/widgets/dark_button.dart` | DarkButton（同上）|
| `mobile/lib/shared/widgets/animated_expand_icon.dart` | v2.0.0 图标状态切换动画组件 |
| `mobile/lib/shared/widgets/share_result_button.dart` | 结果分享（share_plus + RepaintBoundary 截图）|
| `mobile/lib/features/manual/manual_page.dart` | 使用手册页面（5 章节）|
| `mobile/lib/features/xiaoliuren/ui/xiaoliuren_ritual.dart` | 仪式入场动画（太极生六宫）|
| `mobile/lib/features/xiaoliuren/ui/divination_wheel.dart` | 六宫圆盘 CustomPainter |
| `mobile/lib/features/ziwei/ui/star_chart_painter.dart` | 紫微环形命盘 CustomPainter |
| `mobile/lib/features/luopan/` | 风水罗盘（sensors_plus 实时磁场）|
| `mobile/lib/features/daliuren/` | 大六壬（四课三传 + 天盘地盘）|
| `mobile/scripts/build_apk.ps1` | APK 构建脚本（自动版本递增 + 归档 + 历史）|
| `docs/FLUTTER_APK_BUILD_PIPELINE.md` | 构建流水线规范 |
| `docs/NEXT_PLAN/` | 版本规划文档 |
| `builds/release_history.json` | GitHub Release 发布记录 |
| `builds/build_history.json` | 构建历史（归档区主副本）|
| `log/update/` | 更新日志（feature_*.md / fix_*.md）|
