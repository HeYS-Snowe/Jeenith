# UI 设计规范 UI Guidelines

> 志极 Jeenith · 视觉设计与组件规范

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心） |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe |
| 许可证 License | MIT · Copyright (c) 2026 Qore |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-01 | 初版：深紫鎏金配色、字体、间距、组件库 |
| v1.5.0 | 2026-03 | 新增浅色主题色彩（AppColorsLight） |
| v2.0.0 | 2026-03 | 品牌定调，按钮物理反馈规范 |
| v2.1.0 | 2026-04 | 仪式动画视觉规范 |
| v2.3.3 | 2026-07-15 | 同步当前组件库与动效常量 |

---

## 1. 设计理念 Design Philosophy

### 1.1 品牌精神 Brand Spirit

- **中文精神**：志于本心，知于极处
- **英文口号**：Question the core. Return to origins.
- **组织口号**：叩问本心，不忘初心（Qore Origins / 叩心）

UI 设计围绕「**叩问本心的沉浸式卜算体验**」，营造庄严、神秘、深邃的东方术数氛围。

### 1.2 设计原则 Design Principles

| 原则 Principle | 体现 Manifestation |
|--------------|-----------------|
| 沉浸感 Immersion | 全 APP 星空背景 + 仪式入场动画 + 微交互 |
| 庄严感 Solemnity | 深紫底色 + 鎏金点缀，规避轻浮色彩 |
| 一致性 Consistency | 配色/字体/间距/动效全 APP 统一，常量集中管理 |
| 可调性 Adjustability | 所有动效可按术/按类开关，尊重低性能/无障碍 |
| 跨平台 Cross-Platform | 触摸与鼠标交互范式平滑切换 |

### 1.3 视觉关键词 Visual Keywords

深邃星空 · 鎏金质感 · 五行色系 · 宋体雅韵 · 仪式动效 · 卡片错峰

---

## 2. 色彩系统 Color System

### 2.1 深色主题（主）Dark Theme (Primary)

定义于 `core/theme/app_theme.dart` 的 `AppColors`。

#### 2.1.1 背景色 Background

| 色名 Name | 色值 Hex | 用途 Usage |
|---------|--------|----------|
| `bg` | `#0C0A12` | 主背景（深紫黑） |
| `bgInner` | `#1B1626` | 内层背景 |
| `bgMid` | `#120F1A` | 中层背景 |
| `bgOuter` | `#0A0810` | 外层背景 |

#### 2.1.2 鎏金系 Gold

| 色名 | 色值 | 用途 |
|-----|-----|-----|
| `gold` | `#D4A857` | 主鎏金（按钮/标题/主色） |
| `goldBright` | `#E8C87A` | 高亮鎏金（聚焦态） |
| `goldLight` | `#F0D488` | 轻鎏金 |
| `goldBorder` | `rgba(212,168,87,0.43)` | 鎏金描边 |

#### 2.1.3 文字色 Text

| 色名 | 色值 | 用途 |
|-----|-----|-----|
| `textHighlight` | `#FDF6E3` | 高亮文字 |
| `textPrimary` | `#F0E6CF` | 主要文字 |
| `textBody` | `#C8BC9E` | 正文 |
| `textMeta` | `#A89A78` | 元信息 |
| `textSubtitle` | `#8A7A55` | 副标题 |
| `textHint` | `#6A6076` | 占位提示 |

#### 2.1.4 面板色 Panel

| 色名 | 色值 | 用途 |
|-----|-----|-----|
| `panel` | `rgba(18,14,26,0.78)` | 面板底 |
| `card` | `rgba(28,22,38,0.86)` | 卡片底 |
| `buttonTop` | `#3A2F4A` | 按钮渐变顶 |
| `buttonBottom` | `#241C30` | 按钮渐变底 |

#### 2.1.5 五行色 Five Elements

用于小六壬六宫、断语分级、五行属性着色：

| 五行 Element | 基色 Base | 辉光色 Glow |
|------------|---------|-----------|
| 木 Wood | `#3FAE6F` | `#7FE3AD` |
| 水 Water | `#6A8AA6` | `#9BC0DC` |
| 火 Fire | `#E85A3C` | `#FF9077` |
| 金 Metal | `#C5CDD8` | `#EEF2F8` |
| 水（深）WaterDeep | `#3A86B8` | `#74BCE4` |
| 土 Earth | `#B8924E` | `#E0BF7E` |

#### 2.1.6 周易爻色 Yao Colors

| 色名 | 色值 | 用途 |
|-----|-----|-----|
| `yang` | `#D4A857` | 阳爻 |
| `yin` | `#9BC0DC` | 阴爻 |
| `changing` | `#E85A3C` | 变爻 |

#### 2.1.7 断语分级色 Verdict Grades

| 分级 Grade | 色名 | 色值 |
|----------|-----|-----|
| 大吉 Great | `gradeGreat` | `#7FE3AD` |
| 吉 Good | `gradeGood` | `#9BC0DC` |
| 平 Steady | `gradeSteady` | `#D4A857` |
| 凶 Rough | `gradeRough` | `#E0BF7E` |
| 大凶 Bad | `gradeBad` | `#FF9077` |

### 2.2 浅色主题 Light Theme

定义于 `AppColorsLight`（v1.5.0 新增），与深色保持同等五色系语义，但底色改为浅米色，鎏金加深以保证对比度：

- 背景：`#F6F0E2`（浅米）/ `#EBE2CC` / `#F1E9D5` / `#E5D9BD`
- 鎏金：`#9B7A2A`（加深）/ `#8A6A1E` / `#B89534`
- 五行色均加深（如木 `#2D8E54`、火 `#C13E1E`）

### 2.3 主题模式 Theme Mode

`AppConfig.themeMode`：`system` / `light` / `dark`，默认 `dark`。`JeenithApp._effectiveLight` 根据模式 + 系统亮度计算实际浅深，Starfield 与配色同步切换。

---

## 3. 字体系统 Typography

### 3.1 字体定义 Font Definition

```dart
class AppFonts {
  static const String serif = 'SourceHanSerif';  // 思源宋体（如打包则用，否则回退系统）
}
```

### 3.2 字号阶 Typographic Scale

| 用途 Usage | 字号 Size | 字重 Weight | 字距 LetterSpacing | 颜色 Color |
|---------|---------|-----------|-----------------|---------|
| AppBar 标题 | 20 | bold | 6 | goldBright |
| 卡片标题 | 18-20 | bold | — | textHighlight |
| 卦名/落宫名 | 22-26 | bold | — | accentColor |
| 正文 | 14-16 | normal | — | textBody |
| 元信息 | 12-13 | normal | — | textMeta |
| 诗诀 | 15 | normal | 2 | textPrimary |
| 副标题 | 13-14 | normal | — | textSubtitle |
| 占位提示 | 14 | normal | — | textHint |

### 3.3 字体使用规范 Font Usage

- 标题/卦名/诗诀优先宋体（`SourceHanSerif`），营造古韵
- 正文可回退系统默认（保证可读性）
- 字距 6 用于 AppBar 标题，营造疏朗庄严感

---

## 4. 间距与圆角 Spacing & Radius

### 4.1 间距阶 Spacing Scale

| 名称 | 值 | 用途 |
|-----|---|-----|
| xs | 4 | 紧凑内边距 |
| sm | 8 | 元素间小间距 |
| md | 12-16 | 常规内边距 |
| lg | 20-24 | 卡片内边距 |
| xl | 32 | 区块间距 |
| xxl | 48 | 大区块间距 |

### 4.2 圆角 Radius

| 用途 | 圆角 | 来源 |
|-----|-----|-----|
| 输入框/按钮 | 10 | `BorderRadius.circular(10)`（appTheme） |
| 卡片 | 12-16 | InteractableCard |
| 面板 | 12 | DecorativePanel |
| 圆形 | 圆形 | 罗盘/命盘等圆形组件 |

---

## 5. 组件库 Component Library

### 5.1 共享组件清单 Shared Widgets

定义于 `shared/widgets/`，共 14 个：

| 组件 Component | 用途 Usage | 动效 Animation |
|-------------|---------|--------------|
| `GoldButton` | 鎏金主按钮 | 物理反馈（按下塌缩/抬起回弹） |
| `DarkButton` | 暗色次按钮 | 物理反馈 |
| `InteractableCard` | 可交互卡片 | 错峰上浮 |
| `DecorativePanel` | 装饰面板 | 展开/收起 |
| `SectionTitle` | 分节标题 | — |
| `SvgIcon` | SVG 图标 | — |
| `AnimatedExpandIcon` | 展开图标 | 旋转 |
| `HoverableIconButton` | 图标按钮（桌面 hover） | hover 态 |
| `EntranceItem` | 错峰入场封装 | staggered |
| `Starfield` | 星空粒子背景 | 持续 |
| `DivinationLoadingIndicator` | 起卦加载态 | 旋转/脉冲 |
| `CopyResultButton` | 复制结果 | 图标切换 |
| `ShareResultButton` | 分享结果 | 图标切换 |
| `GuideDialog` | 引导弹窗 | — |

### 5.2 GoldButton 规范 GoldButton Spec

- **配色**：渐变 `buttonTop` → `buttonBottom`，文字 `goldBright`
- **描边**：`goldBorder`
- **动效**：
  - 按下：`pressDown` (110ms, `easeIn`) 塌缩
  - 抬起：`pressRelease` (260ms, `Cubic(0.34,1.56,0.64,1)` easeOutBack 变体) 弹回
- **开关**：受 `AppConfig.animationsEnabled` 总开关约束

### 5.3 InteractableCard 规范 InteractableCard Spec

- **结构**：标题 + 副标题 + 内容区
- **入场**：`AppAnimations.staggeredIntervals(n)` 生成错峰 Interval
  - `stepRatio = 0.08`（相邻错开）
  - `durationRatio = 0.42`（每张占区间）
  - `cardRiseCurve = easeOutCubic`
- **总时长**：`cardRise = 420ms`

### 5.4 Starfield 规范 Starfield Spec

- **布局**：`Positioned.fill` 铺满全 APP
- **粒子**：随机星点，受主题色影响（深色亮星/浅色暗星）
- **回收**：离屏粒子定时清理，避免无限增长
- **层级**：`JeenithApp.builder` 的 Stack 底层，UI 在其上

---

## 6. 动效系统 Animation System

### 6.1 AnimationKind 分类 Animation Categories

`enum AnimationKind { entrance, transition, painter, reveal }`

| Kind | 含义 Meaning | 示例 Example |
|------|-----------|------------|
| `entrance` | 入场仪式（仪式动画页/路由前置过渡） | 铜钱抛落、命盘展开 |
| `transition` | 路由转场（TechTransition） | 术签名转场 |
| `painter` | 绘制过程（CustomPainter progress 动画） | 卦象绘制、罗盘扫描 |
| `reveal` | 结果揭示（RevealAnimation 封装） | 墨晕扩散、打字机 |

### 6.2 动效常量 Animation Constants

定义于 `core/theme/animations.dart` 的 `AppAnimations`：

#### 6.2.1 微交互时长

| 常量 | 值(ms) | 用途 |
|-----|-------|-----|
| `pressDown` | 110 | 按下塌缩 |
| `pressRelease` | 260 | 抬起弹回 |
| `iconRotate` | 240 | 图标旋转 |
| `iconScale` | 140 | 图标呼吸 |
| `cardStagger` | 90 | 错峰间隔基数 |
| `cardRise` | 420 | 卡片上浮总时长 |
| `panelExpand` | 260 | 面板展开 |

#### 6.2.2 仪式动画时长

| 常量 | 值(ms) | 术 |
|-----|-------|---|
| `ritualZhouyi` | 5000 | 周易铜钱抛落 |
| `ritualZiwei` | 6000 | 紫微命盘展开 |
| `ritualQimen` | 5000 | 奇门九宫飞布 |
| `ritualDaliuren` | 5000 | 大六壬双盘旋转 |
| `ritualLuopan` | 4000 | 风水罗盘扫描 |
| `ritualMeihua` | 4000 | 梅花数字撞击 |
| `ritualJiaobei` | 3000 | 掷筊抛落 |
| `ritualCezi` | 5000 | 测字字形浮现 |
| `ritualChouqian` | 5000 | 抽签卷轴展开 |
| `skipButtonDelay` | 3000 | 跳过按钮延迟显示 |

#### 6.2.3 曲线 Curves

| 常量 | 曲线 | 用途 |
|-----|-----|-----|
| `pressDownCurve` | `easeIn` | 按下 |
| `pressReleaseCurve` | `Cubic(0.34,1.56,0.64,1)` | 抬起（easeOutBack 变体，0.4 回弹） |
| `iconRotateCurve` | `easeOutCubic` | 图标旋转 |
| `cardRiseCurve` | `easeOutCubic` | 卡片上浮 |
| `panelExpandCurve` | `easeInOutCubic` | 面板展开 |

### 6.3 动效开关层级 Toggle Hierarchy

```
1. animationsEnabled (总开关)
   └─ false → 全部动效跳过
   └─ true ↓
2. isAnimationEnabled(techId, kind) (分术分类)
   └─ false → 跳过该术该类
   └─ true → 播放
```

设置页提供：
- 总开关 `animationsEnabled`
- 一键批量开关 `setAllAnimations(techIds, v)`
- 按术 × AnimationKind 细粒度开关

### 6.4 错峰工具 Staggered Tool

```dart
static List<Interval> staggeredIntervals(int count,
    {double stepRatio = 0.08, double durationRatio = 0.42});
```

生成 N 个 Interval，用于 `EntranceItem` 的卡片错峰入场。

---

## 7. 仪式动画视觉规范 Ritual Animation Visual

### 7.1 仪式动画清单 Ritual List

| 术 | 仪式 | 时长 | 视觉核心 |
|---|-----|-----|--------|
| 小六壬 | 太极生六宫 | — | 太极旋转 + 六宫辐射展开 |
| 周易 | 铜钱抛落 | 5s | 6 轮三铜钱抛物线 + 正反面定型 |
| 紫微 | 命盘展开 | 6s | 12 宫辐射 + 14 主星降落 |
| 奇门 | 九宫飞布 | 5s | 值符值使定位 + 八门九星八神飞布 |
| 大六壬 | 双盘旋转 | 5s | 天盘顺转/地盘逆转 + 四课三传显化 |
| 罗盘 | 罗盘扫描 | 4s | 指针扫描 + 24 山依次点亮 |
| 梅花 | 数字撞击 | 4s | 两数飘落 + 撞击爆发 + 卦象淡入 |
| 掷筊 | 杯筊翻转 | 3s | 杯筊抛物线 + 翻滚 + 结果定型 |
| 抽签 | 卷轴展开 | 5s | 签筒摇晃 + 签条跳出 + 卷轴展开 + 笔锋书写 |
| 测字 | 字形浮现 | 5s | 道字浮现 + 木色扩散 |

### 7.2 仪式规范 Ritual Conventions

- **时长**：3-6s，不超过 6s（避免疲劳）
- **跳过**：延迟 3s（`skipButtonDelay`）显示跳过按钮，尊重用户时间
- **衔接**：`onCompleted` 回调 `context.go('/tech/<id>')`，仪式 → 主页无缝
- **开关**：受 `AnimationKind.entrance` 控制
- **背景**：仪式页同样叠加 Starfield

---

## 8. 布局规范 Layout

### 8.1 首页 Home Layout

- 顶部：品牌标识（志极 / Jeenith）+ 口号
- 中部：术数 grid（`visibleTechsProvider` 渲染），按 `sortOrder` 排序
- 卡片：`InteractableCard`，错峰入场，含 displayName + subtitle + description + accentColor
- 底部：历史/设置/手册入口

### 8.2 术页面 Tech Page Layout

- AppBar：术 displayName + 副标题，居中
- 内容区：
  - 输入采集区（按术不同：按钮/手势/生辰选择/字输入）
  - 起卦按钮（`GoldButton`）
  - 结果区（`RevealAnimation` 揭示 + `ResultCardData` 卡片列表）
  - 熵源详情（可选，受 `showDetails` 控制）
  - 复制/分享按钮（`CopyResultButton` / `ShareResultButton`）

### 8.3 跨平台布局 Cross-Platform

- **mobile**：单列，触摸拖拽，`DraggableScrollableSheet`
- **desktop**：可分栏，鼠标滚轮，hover 态（`HoverableIconButton`）

---

## 9. 图标系统 Icon System

### 9.1 SVG 图标 SVG Icons

- 使用 `flutter_svg` 渲染矢量图标
- `SvgIcon` 组件统一封装
- 中国风线条美学，任意 DPI 清晰
- 各术有独立 SVG 标识（首页卡片图标）

### 9.2 APP 图标 App Icon

- `flutter_launcher_icons` 一键生成 Android/Windows 各尺寸
- 主图标：志极品牌符号（深紫底 + 鎏金）

---

## 10. 可访问性 Accessibility

| 维度 Dimension | 策略 Strategy |
|-------------|------------|
| 动效敏感 | 全部动效可关闭（总开关 + 分术分类） |
| 对比度 | 深色主题文字 `textPrimary` (#F0E6CF) 对 `bg` (#0C0A12) 对比度 > 12:1 |
| 字号 | 跟随系统字号缩放 |
| 触摸目标 | 按钮 ≥ 48×48 dp |
| 平等 | 浅色/深色主题均完整支持 |

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
