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
| 当前版本 | **1.1.0+4**（2026-07-12）|
| 项目位置 | `D:\Code\Project\Qore\Jeenith` |
| 身份信息源 | `D:\Code\.Rules\OrganizationAndUser.md`（唯一事实来源）|

**定位**：叩问本心的卜算合集——一个 APP 首页选术，承载多种中国传统卜算术。核心价值是**可扩展卜算框架**：加新术 = 新建一个 feature 目录 + 注册一行，不改 core/shared。

---

## 二、技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 框架 | Flutter 3.x（Dart 3.11+）| Android + Windows 桌面 |
| 状态管理 | Riverpod（flutter_riverpod ^2.5）| |
| 路由 | go_router ^14.0 | |
| 农历/八字/节气 | lunar ^1.7.8（寿星天文历）| 紫微/奇门/时辰起卦共用 |
| 图标 | flutter_svg ^2.0 | SVG 矢量图标 |
| 真随机 | dart:math Random.secure + 触摸轨迹 + http random.org + crypto SHA256 | |
| 配置持久化 | shared_preferences ^2.2 | |
| APP 图标 | flutter_launcher_icons ^0.14 | |

---

## 三、项目结构（Campus_Sentinel 多模块）

```
Jeenith/                           # 仓库根（solution root）
├── mobile/                        # Flutter 项目（your_app）
│   ├── lib/
│   │   ├── app.dart               # JeenithApp（MaterialApp.router + Starfield 背景）
│   │   ├── main.dart              # 入口（async + ProviderScope）
│   │   ├── core/
│   │   │   ├── branding.dart      # 品牌常量（appName/tagline/copyright）
│   │   │   ├── calendar/          # lunar_service（农历服务）
│   │   │   ├── config/            # app_config + config_providers（SharedPreferences）
│   │   │   ├── divination/        # ★ 卜算框架抽象（DivinationTech + Registry + Result 模型）
│   │   │   ├── history/           # history_store（SharedPreferences JSON 持久化）
│   │   │   ├── rng/               # ★ 真随机引擎（3 源 SHA256 混合）
│   │   │   └── theme/             # app_theme.dart（AppColors 色板 + appTheme()）
│   │   ├── data/
│   │   │   └── yijing/            # 64 卦 + 八卦数据（周易/梅花共用）
│   │   ├── features/
│   │   │   ├── home/              # 首页（选术卡片 grid + 设置/历史按钮 + 使用方法卡片）
│   │   │   ├── xiaoliuren/        # 小六壬（掐指算法 + 圆盘 CustomPainter + 仪式入场动画）
│   │   │   ├── zhouyi/            # 周易（金钱卦 + 六爻逐爻揭示）
│   │   │   ├── meihua/            # 梅花易数（数字起卦 + 体用）
│   │   │   ├── jiaobei/           # 掷筊（杯筊 + 连掷）
│   │   │   ├── ziwei/             # 紫微斗数（v1：命身宫+12宫+五行局）
│   │   │   ├── qimen/             # 奇门遁甲（v1：阴阳遁+局数+节气）
│   │   │   ├── settings/          # 设置页（动画/采样/在线开关）
│   │   │   └── history/           # 历史记录页（列表+详情+备注+删除）
│   │   ├── providers/             # providers.dart（barrel 聚合 config + rng providers）
│   │   ├── router/                # app_router.dart（GoRouter + 仪式路由）
│   │   └── shared/
│   │       └── widgets/           # 共用组件（GoldButton/DarkButton/DecorativePanel/
│   │                              #   EntranceItem/CopyResultButton/GuideDialog/
│   │                              #   InteractableCard/Starfield/SvgIcon/SectionTitle）
│   ├── scripts/
│   │   ├── build_apk.ps1          # APK 构建脚本（版本递增+归档+历史）
│   │   └── archive_history.py     # 历史记录追加（双份 build_history.json）
│   ├── android/ ios/ web/ windows/ linux/ macos/
│   ├── pubspec.yaml               # name: jeenith, version: 1.1.0+4
│   ├── build_history.json         # 项目内历史副本
│   ├── ico/                       # APP 图标素材
│   └── assets/icons/              # SVG 图标
├── backend/                       # 占位（Jeenith 无后端）
├── design/                        # 占位（设计稿）
├── docs/                          # 文档（本文件 + FLUTTER_APK_BUILD_PIPELINE.md）
├── tools/                         # 占位（工具脚本）
├── builds/                        # ★ 构建产物归档（APK/ZIP + build_history.json 主副本）
├── build_history.json             # 项目内历史副本
├── CLAUDE.md                      # 项目定制规则
└── AGENTS.md                      # Agent 规则（与 CLAUDE.md 同步）
```

---

## 四、功能清单

### 6 种卜算术

| 术 | id | 玩法 | 完成度 |
|----|----|------|--------|
| **小六壬** | xiaoliuren | 掐指数数落宫（大安→留连→速喜→赤口→小吉→空亡），三段落宫 | ✅ 完整（圆盘动画 + 仪式入场 + 七维断辞）|
| **周易** | zhouyi | 金钱卦摇六爻，本卦+变卦 | ✅ 完整（逐爻揭示 + 变爻）|
| **梅花易数** | meihua | 两数起卦，上下卦+动爻，体用 | ✅ 完整 |
| **掷筊** | jiaobei | 两片杯筊，圣/笑/阴筊 | ✅ 完整（连掷累计）|
| **紫微斗数** | ziwei | 公历生辰→命身宫+12宫+五行局 | ⚠️ v1 基础（星曜安星待 v2）|
| **奇门遁甲** | qimen | 时辰→阴阳遁+局数+节气 | ⚠️ v1 基础（四盘待 v2）|

### 框架特性

- **可扩展卜算框架**：`DivinationTech` 抽象（id/meta/buildPage）+ `divinationRegistry`（加新术 = 追加一行）+ 统一结果模型 `DivinationResult`
- **真随机引擎**（`core/rng/`）：3 源 SHA256 混合（系统熵 Random.secure + 触摸轨迹 PointerEvent + random.org 大气噪声），链式扩展生成，可配置开关
- **仪式入场动画**（小六壬）：太极缩放旋转 + 同心圆错峰 + 六宫绕行归位（首宫随机选/角随机/方向随机），可设置切换
- **首次使用方法弹窗**：3 秒禁关 + SharedPreferences 标记首次
- **首页置顶使用方法卡片**：可收起 ExpansionTile
- **复制结果**（6 术）：一键复制详细文本（术名+时间+取数/卦象+断辞+采样）
- **历史记录**：SharedPreferences JSON 持久化，列表+详情+备注+删除
- **设置页**：仪式入场动画 / 采样详情 / 在线大气噪声 开关

### UI / 交互

- **深色中国风**：玄黑底（#0C0A12）+ 鎏金（#D4A857）+ 朱砂（#E85A3C）+ 五行色（木青/水蓝/火红/金白/土黄）
- **层叠布局**（小六壬/周易）：圆盘/六爻固定底层 + `DraggableScrollableSheet` 上层可拖拽覆盖 + 交互 `SliverPersistentHeader(pinned)` 粘顶吸附
- **入场动画**：首页选术卡片错峰淡入上浮（InteractableCard）
- **Starfield 星空背景**：全局粒子背景
- **高 DPI**：AA_EnableHighDpiScaling + AA_UseHighDpiPixmaps

---

## 五、构建

### APK（Android）

```bash
cd mobile
pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "1.2.0"
```

脚本自动：更新 pubspec 版本 → flutter build → 备份 → 重命名 → 归档到 `builds/` → 追加双份 `build_history.json`。构建失败自动回滚版本号。

### Windows 桌面

```bash
cd mobile
flutter build windows --release
# 产物：build/windows/x64/runner/Release/jeenith.exe
# 手动 zip 归档到 builds/（用 archive_history.py 或 python 脚本）
```

### 构建规范

详见 `docs/FLUTTER_APK_BUILD_PIPELINE.md`。命名规则：`Jeenith_{状态}_{版本}_{日期}_{序号}.apk/.zip`。产物在 `builds/`（与 mobile/ 平级，不受 flutter clean 影响）。

### 当前归档（builds/）

| 文件 | 平台 | 版本 | 大小 |
|------|------|------|------|
| Jeenith_release_1.0.0_20260711_01.apk | Android | 1.0.0+1 | 50.7 MB |
| Jeenith_release_1.0.1_20260711_01.apk | Android | 1.0.1+2 | 50.7 MB |
| Jeenith_release_1.0.1_20260711_01_windows_x64.zip | Windows | 1.0.1+2 | 12.3 MB |
| Jeenith_release_1.1.0_20260712_01.apk | Android | 1.1.0+4 | 51.0 MB |
| Jeenith_release_1.1.0_20260712_01_windows_x64.zip | Windows | 1.1.0+4 | 12.3 MB |

---

## 六、后续待做（已记录 memory）

见 `~/.claude/projects/.../memory/jeenith-future-phases.md`：

1. **紫微/奇门 v2 深化**：紫微 14 主星+辅星安星；奇门天地人神四盘（值符值使/八门/九星/八神）
2. **周易/梅花 卦辞爻辞**：64 卦卦辞 + 384 爻辞（JSON 资产），结果从"只给卦名"到"给断辞"
3. **结果分享**：系统分享面板（share_plus），文本/截图分享
4. **历史导出 + 主题字体**：历史记录导出 JSON；主题切换（深色/浅色）+ 思源宋体字体

---

## 七、注意事项（踩坑记录）

### 环境
- **PyQt5-sip 安装缺陷**：`pip install PyQt5` 后 sip.pyd 可能未写入，需 `--force-reinstall --no-cache-dir PyQt5-sip`（Python 版历史遗留）
- **venv 符号链接 → Qt 平台插件丢失**：venv 用符号链接创建时，`QT_QPA_PLATFORM_PLUGIN_PATH` 需在 import PyQt5 前显式设置
- **Windows python stdout 管道吞输出**：exit 127 零输出时，改用 `> file 2>&1` 重定向再 cat
- **Flutter SDK 路径**：`D:\Mobile_Development\Flutter\Flutter_SDK\bin\flutter.bat`
- **pub-cache 路径**：`D:\Mobile_Development\pub-cache\`
- **Android 模拟器**：emulator-5554（sdk gphone64 x86 64）

### 构建
- **中文路径 PyInstaller 冲突**：PyInstaller 的 Qt hook 在中文路径下报 `Qt plugin directory does not exist`（Python 版历史，Flutter 版无此问题——项目已移到英文路径 Qore/Jeenith）
- **lintVitalRelease "37.0" bug**：`shared_preferences_android:lintVitalRelease` 报 `For input string: "37.0"`（lint 工具自身 bug），`build.gradle.kts` 加 `lint { checkReleaseBuilds = false }` 规避
- **CMake 缓存路径冲突**：项目移动后 `build/windows/x64/CMakeCache.txt` 路径不匹配，删 `rm -rf build/windows` 后重 build
- **构建脚本 buildsDir**：`build_apk.ps1` 的 `$buildsDir = Join-Path $projectRoot "..\builds"`（builds 在仓库根，与 mobile/ 平级）

### 开发
- **DraggableScrollableSheet controller**：`ScrollController?` 可空，builder 内赋值，jumpTo 用 `?.hasClients` 守卫
- **SliverPersistentHeader SliverGeometry 错**：`maxExtent` 必须与 child 实际高度一致，否则 `layoutExtent > paintExtent` 崩溃；用 `constraints: BoxConstraints(minHeight: maxExtent)` 让 child 填充
- **InteractableCard Interval end > 1**：首页卡片入场动画 `Interval(begin, end)` 的 end 必须 ≤ 1.0，用 `.clamp(0.0, 1.0).toDouble()` 规避
- **HistoryStore const []**：`load()` 返回 `const []` 是不可修改列表，`list.insert` 会崩；用 `<HistoryEntry>[]`
- **DraggableScrollableSheet + 圆盘位置**：圆盘用 `Transform.translate(offset: Offset(0, -80))` 上移，让初始状态圆盘完整可见（面板 initialChildSize 0.35 不遮圆盘）

### .gitignore 建议
- `builds/` 不入 git（APK 是大二进制，用 NAS/云盘备份）
- `build_history.json`（两份）入 git（构建记录凭证）
- `mobile/build/` 不入 git
- `xlr_config.json`（用户配置）视需求

---

## 八、关键文件速查

| 文件 | 作用 |
|------|------|
| `mobile/lib/core/divination/divination_tech.dart` | 卜算框架抽象（DivinationTech + TechMeta）|
| `mobile/lib/core/divination/divination_registry.dart` | ★ 加新术的唯一修改点 |
| `mobile/lib/core/rng/true_random.dart` | 真随机引擎（3 源 SHA256）|
| `mobile/lib/core/history/history_store.dart` | 历史记录存储 |
| `mobile/lib/core/theme/app_theme.dart` | AppColors 色板 + appTheme() |
| `mobile/lib/features/xiaoliuren/ui/xiaoliuren_ritual.dart` | 仪式入场动画（太极生六宫）|
| `mobile/lib/features/xiaoliuren/ui/divination_wheel.dart` | 六宫圆盘 CustomPainter |
| `mobile/scripts/build_apk.ps1` | APK 构建脚本 |
| `docs/FLUTTER_APK_BUILD_PIPELINE.md` | 构建流水线规范 |
