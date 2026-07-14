# 志极 Jeenith v2.1.0 —— 动效体系完整设计方案（"动效定调与仪式感升级"）

**目标版本**：2.1.0+17
**核心定位**：从 v2.0.0 的「按钮+图标」克制微交互，升级到「全术仪式化动效体系」。80% 大动效（仪式感+视觉冲击）+ 20% 微动效（组件反馈）。
**前置条件**：性能流畅可承载大量动画；所有动效通过 `AppConfig.animationsEnabled` 全局开关；无光污染，遵循 oklch 色彩思路。

---

## 〇、现状诊断

### 现有动效清单（8 处，普遍克制）

| 位置 | 动效 | 问题 |
|------|------|------|
| `interactable_card.dart` 入场 | 淡入 + 上浮 24px，stagger | 太克制，没视觉冲击 |
| `interactable_card.dart` 按压 | 缩放 0.95 + 光晕，120ms | 没涟漪扩散 |
| `animated_expand_icon.dart` | 旋转+呼吸反馈（v2.0.0） | 唯一明显的，但只有 1 处用 |
| `gold_button.dart` / `dark_button.dart` | 缩放 0.95 + easeOutBack 弹回（v2.0.0） | 调用方多但参数雷同 |
| `starfield.dart` | 星空粒子背景 | 已有 |
| `xiaoliuren_ritual.dart` | 太极生六宫仪式 | **10 术中唯一的仪式动画** |
| `app_router.dart` `/tech/:id` 转场 | FadeTransition + ScaleTransition 0.92→1.0 | **所有术用同一个转场** |
| `AppConfig.animationsEnabled` | 全局开关 | 已就位 |

### 缺失动效（影响"不明显"的核心原因）

| 缺口 | 数量 | 影响 |
|------|------|------|
| 仪式动画 | 9 术缺失（仅小六壬有） | **核心卖点缺失**——占卜过程没有仪式感 |
| CustomPainter 静态 | 10 处全部静态 | 命盘/罗盘/卦象都是"直接画出来"，没有"绘制过程" |
| 结果揭示动画 | 10 术全部缺失 | 卦象/签诗/断辞直接铺出来，没有"墨晕开/打字机/段落错峰" |
| 路由转场差异化 | 缺失 | 10 术用同一个 FadeTransition，没有"术数识别感" |
| 桌面端 hover | 缺失 | 鼠标移入无反馈 |
| 加载指示器 | 用默认 CircularProgressIndicator | 与中国风违和 |
| 弹窗入场 | 默认 | GuideDialog 缺少仪式感 |

---

## 一、设计原则

| 原则 | 说明 |
|------|------|
| **仪式优先** | 占卜是核心卖点，每术必有仪式动画（3-6s），用户可设置跳过 |
| **过程可见** | 所有 CustomPainter 从"无"到"有"的绘制过程必须可感知（笔触、辐射、扫描） |
| **可关可控** | 沿用 `animationsEnabled` 总开关；仪式动画单独 sub-switch（仪式通常较长） |
| **黑金定调** | 主色 #D4A857 鎏金 + #E85A3C 朱砂 + 五行色；遵循 oklch 低饱和度思路，禁霓虹色 |
| **性能优先** | 60fps 目标，所有动画用 RepaintBoundary 隔离 + shouldRepaint 精确控制 |
| **桌面/移动自适应** | hover 仅桌面端；触摸端用 long-press 替代 |
| **差异化转场** | 每术路由转场有自己的视觉语言（小六壬太极旋、周易爻堆叠、紫微辐射...） |

---

## 二、80% 大动效方案

### A. 仪式动画（9 术新增 + 1 术已有 = 10 套）

**架构**：新建 `core/animation/ritual/` 目录，每术一个文件，继承 `RitualAnimation` 抽象基类。

```dart
abstract class RitualAnimation extends ConsumerStatefulWidget {
  final VoidCallback onCompleted;
  const RitualAnimation({super.key, required this.onCompleted});
  // 子类实现：3-6s 动画，结束调用 onCompleted 跳转 tech 页面
}
```

**路由**：每术注册一个 `/ritual/<tech>` 路由，类似小六壬现有模式。

| 术 | 仪式动画设计 | 时长 | 关键帧 |
|----|------------|------|--------|
| **周易** | 3 枚铜钱从屏幕顶部抛落，翻滚旋转，落地时显示正反（字/背）。重复 6 次成六爻，从下到上堆叠。 | 5s | 铜钱抛物线 + 翻滚（AnimatedBuilder + 物理 Tween）→ 落地震动（scale 1.0→0.92→1.0）→ 爻从底叠加 |
| **梅花易数** | 两个数字从空中飘落（用户输入或随机），落入「上卦位」和「下卦位」，撞击瞬间迸发出卦爻，数字消散成五行色光。最后动爻从顶降临。 | 4s | 数字下落（easeIn）→ 撞击爆发（scale 0→1.2→1.0 + 粒子）→ 数字淡出 + 卦象淡入 |
| **掷筊** | 杯筊从屏幕上方抛出，在空中翻转 2-3 周，落地时根据结果（圣/笑/阴）显示不同姿态：圣筊一正一反、笑筊两面朝上、阴筊两面朝下。连掷时累计。 | 3s | 杯筊抛物线 + 旋转（AnimatedRotation + 物理 Tween）→ 落地弹跳 → 状态定型（光晕颜色对应） |
| **紫微斗数** | 黑色虚空背景 → 中心点金光绽放 → 12 宫位按命局顺序从中心辐射展开（每宫 100ms 错峰）→ 14 主星从天顶降落到对应宫位（带光尾轨迹）→ 辅星随后。 | 6s | 中心爆光 → 12 宫辐射展开（stagger 100ms）→ 星曜降落（光尾 + 落地震动）→ 命盘成型（金光描边一圈） |
| **奇门遁甲** | 3×3 九宫格从虚空中显现 → 值符值使从外飞入中心 → 八门按方位飞入 → 九星从天顶降下 → 八神在四角落座。像棋局布阵。 | 5s | 九宫淡入 → 值符值使飞入（translate + scale）→ 八门九星八神依次落座（每 200ms 一个）→ 整盘金光描边 |
| **抽签** | 竹签筒在屏幕中央摇晃（左右倾斜 ±15°）→ 签条从筒中跳出（带轻微旋转）→ 落到屏幕中央展开为卷轴 → 签诗从上到下逐字书写（毛笔笔触）。 | 5s | 签筒摇晃（rotate）→ 签条跳出（translate + scale）→ 卷轴展开（width 动画）→ 笔锋书写（PathMetric + ShaderMask） |
| **测字** | 用户输入的字 → 字形从虚空浮现 → 笔画按笔顺逐笔书写（可用 PathMetric 提取笔画路径）→ 五行属性色从笔尖开始染色扩散 → 全字定型。 | 5s | 字形浮现（opacity）→ 笔顺书写（CustomPainter + PathMetric）→ 五行色染（ShaderMask + Gradient）→ 定型（scale 1.0→1.05→1.0） |
| **大六壬** | 天盘（圆环）顺时针旋转、地盘（圆环）逆时针旋转，对位到当前时辰 → 四课从天盘/地盘对应位置浮现 → 三传从天盘降下 → 天将神将归位。 | 5s | 双盘对位旋转（反向 AnimationController）→ 四课浮现（fade + scale）→ 三传降下（translate + 光尾）→ 归位金光 |
| **风水罗盘** | 罗盘从北开始 → 顺时针快速扫描到真实方位（magnetometer 读取）→ 24 山依次点亮（每 50ms 一座）→ 中央指针稳定 → 显示方位断辞。 | 4s | 罗盘快速旋转（450°/s 衰减到目标角度）→ 24 山依次点亮（stagger 50ms）→ 指针稳定 → 断辞淡入 |
| **小六壬**（已有，保留） | 太极生六宫仪式 | 4s | 现状保留 |

### B. CustomPainter 绘制过程动画（10 处升级）

所有静态 CustomPainter 升级为"有绘制过程"的。基类：

```dart
abstract class AnimatedChartPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0，绘制进度
  const AnimatedChartPainter({required this.progress});
  // 子类实现 paintInner(canvas, size, progress)：根据 progress 决定绘制哪些元素
}
```

**调用方**：用 `AnimationController + AnimatedBuilder` 包裹，progress 由 controller.value 驱动。

| Painter | 绘制过程动画设计 | 时长 |
|---------|----------------|------|
| `xiaoliuren/divination_wheel.dart` 六宫圆盘 | 从中心辐射展开：宫位按 1→6 顺序从中心点放大归位，每个宫位错峰 100ms | 800ms |
| `ziwei/star_chart_painter.dart` 命盘 | 12 宫位按顺时针从命宫开始逐个绘制，星曜按主星→辅星顺序降位 | 1.2s |
| `qimen/qimen_painter.dart` 九宫 | 9 格从中心向外螺旋展开（中宫→四正→四隅），符使/门/星/神逐层叠加 | 1s |
| `daliuren/daliuren_painter.dart` 天地盘 | 天盘顺时针绘制、地盘逆时针绘制，对位后四课三传浮现 | 1.2s |
| `luopan/luopan_painter.dart` 罗盘 | 24 山从北开始顺时针逐个点亮，指针最后稳定 | 1s |
| `zhouyi/hexagram_view.dart` 六爻 | 六爻从下到上逐爻绘制（初爻→上爻），每爻 100ms 错峰，动爻绘制时金光闪烁 | 600ms |
| `meihua/meihua_painter.dart` 卦象 | 上下卦分两段绘制：下卦从底向上、上卦从下向上，动爻最后金光描边 | 700ms |
| `chouqian/chouqian_painter.dart` 签诗 | 卷轴展开（width 动画）+ 签诗从上到下逐字书写（PathMetric + ShaderMask） | 1.5s |
| `cezi/cezi_painter.dart` 字符 | 字形按笔顺逐笔书写（提取 PathMetric），五行色染从笔尖扩散 | 1.5s |
| `jiaobei/jiaobei_painter.dart` 杯筊 | 杯筊从两侧旋转入场，落地时弹跳一下，状态光晕淡入 | 600ms |

### C. 结果揭示动画（10 术通用）

卜算结果不要直接铺出来，统一封装到 `shared/widgets/reveal_animation.dart`：

| 元素 | 揭示动画 | 时长 |
|------|---------|------|
| 卦象/签诗主图 | 墨晕开效果（ShaderMask + RadialGradient + AnimatedBuilder） | 800ms |
| 主断辞标题 | 逐字打字机效果（每个字 30ms 错峰淡入） | 1s |
| 段落详情 | 段落错峰淡入上浮（每段间隔 200ms，translate Y 16px） | 1.5s |
| 七维断辞（小六壬） | 七个维度依次展开（卡片从右滑入，stagger 80ms） | 1.2s |
| 复制/分享按钮 | 揭示完成后从底部弹出（scale 0.8→1.0 + opacity） | 300ms |

### D. 首页体验升级

| 元素 | 升级方案 | 时长 |
|------|---------|------|
| App Logo（如有） | 呼吸光晕：scale 1.0→1.03→1.0 + boxShadow 12→18→12，无限循环 | 3s 循环 |
| 卡片网格入场 | 从「淡入上浮 24px」升级到「从中心爆炸式展开」：第一张卡片从屏幕中心放大归位，其余卡片按距离中心的位置 stagger 展开（同时有 translate + scale + opacity） | 800ms |
| 卡片 hover（桌面端） | 鼠标移入：卡片 translateY(-4) + 阴影 blur 10→18 + border opacity 0.5→0.8 | 200ms |
| 卡片按下 | 现有缩放 0.95 + 新增"涟漪"扩散（Ink Ripple 替代方案：自定义 AnimatedBuilder 绘制圆形扩散） | 400ms |
| 设置/历史/手册按钮 | hover 时图标旋转 5° + 颜色变金 | 200ms |

### E. 路由转场差异化

每术注册自己的转场 builder，存在 `DivinationTech.transitionBuilder`：

| 术 | 转场风格 | 实现 |
|----|---------|------|
| 小六壬 | 太极旋转入场（圆环从中心放大 + 旋转 90°） | CustomTransitionPage + AnimatedBuilder |
| 周易 | 六爻堆叠入场（六条横线从下到上叠加成页面） | Column + stagger |
| 梅花 | 两数字合体入场（两个数字从两侧滑入合体成页面） | SlideTransition |
| 掷筊 | 杯筊抛物线入场 | 自定义 |
| 紫微 | 命盘辐射入场（从中心放大） | ScaleTransition + 自定义 curve |
| 奇门 | 九宫格分块入场（3×3 格子分别淡入） | GridView + stagger |
| 抽签 | 卷轴展开入场 | AnimatedContainer width |
| 测字 | 字符浮现入场 | Opacity + Scale |
| 大六壬 | 双盘旋转入场 | RotationTransition |
| 风水罗盘 | 指针扫描入场 | RotationTransition |

---

## 三、20% 微动效方案

### F. 组件级反馈

| 组件 | 微动效 | 时长 |
|------|--------|------|
| `IconButton`（设置/历史/手册） | hover：图标旋转 5° + 颜色变金；按下：scale 0.9 + 反弹 | 150ms |
| `SwitchListTile` | 切换瞬间：thumb 滑动 + 激活色光晕扩散（BoxShadow 0→8→0） | 200ms |
| `ListTile`（历史列表） | 按下：scale 0.98 + 左移 2px；松开：弹回 | 120ms |
| `CopyResultButton` | 复制成功：图标从 `copy_all` → `check` 旋转切换 + 短暂勾选动画 | 400ms |
| `ShareResultButton` | 按下：从图标位置辐射出 3 个小圆点（分享感） | 300ms |
| `SnackBar` | 从默认 slide → 改为从底部弹起 + 阴影 + 图标 stagger | 350ms |
| `GuideDialog` | 从默认 → 改为从中心放大入场 + 背景模糊渐入 | 280ms |

### G. 加载指示器

新建 `shared/widgets/divination_loading_indicator.dart`：

- 替换所有 `CircularProgressIndicator`
- 设计：六边形外环旋转 + 中心八卦图 + 鎏金光晕呼吸
- 时长：2.4s 循环
- 使用位置：在线 random.org 等待、历史导出、分享截图生成

### H. 弹窗与遮罩

- `GuideDialog` 入场：背景 `BackdropFilter` 模糊从 0→5 渐入 + 卡片从中心 scale 0.85→1.0 + 弹回（easeOutBack）
- `AlertDialog`（删除确认等）：从底部 slide up + 阴影渐入
- 仪式动画的"跳过"按钮：3s 后才出现，淡入

---

## 四、技术架构

### 4.1 新增目录结构

```
mobile/lib/core/animation/
├── ritual/
│   ├── ritual_animation.dart       # 抽象基类
│   ├── zhouyi_ritual.dart          # 周易铜钱抛落
│   ├── meihua_ritual.dart          # 梅花数字撞击
│   ├── jiaobei_ritual.dart         # 掷筊翻转
│   ├── ziwei_ritual.dart           # 紫微命盘展开
│   ├── qimen_ritual.dart           # 奇门九宫飞布
│   ├── chouqian_ritual.dart        # 抽签卷轴
│   ├── cezi_ritual.dart            # 测字笔顺
│   ├── daliuren_ritual.dart        # 大六壬双盘
│   └── luopan_ritual.dart          # 风水罗盘扫描
├── painters/
│   └── animated_chart_painter.dart # CustomPainter 动画基类
├── transitions/
│   ├── tech_transitions.dart       # 每术路由转场 builder
│   └── shared_transitions.dart     # 通用转场（FadeUpScale 等）
├── reveal/
│   ├── reveal_animation.dart       # 结果揭示动画封装
│   ├── typewriter_text.dart        # 打字机文本组件
│   └── ink_spread.dart             # 墨晕开 ShaderMask
└── particles/
    └── particle_system.dart        # 通用粒子系统（仪式动画用）
```

### 4.2 配置开关升级

`AppConfig` 新增字段（沿用 v2.0.0 模式）：

```dart
class AppConfig {
  final bool animationsEnabled;           // v2.0.0 已有：总开关
  final bool ritualAnimationsEnabled;     // 新增：仪式动画子开关（默认 true，因为较长可关）
  final bool painterAnimationsEnabled;    // 新增：CustomPainter 绘制过程（默认 true）
  final bool revealAnimationsEnabled;     // 新增：结果揭示（默认 true）
  final bool transitionsEnabled;          // 新增：差异化路由转场（默认 true）
  // ...
}
```

设置页新增「◆ 仪式动画」「◆ 转场动画」「◆ 结果揭示」3 个 sub-switch，归在「动效」section 下。

### 4.3 性能预算

| 指标 | 预算 | 措施 |
|------|------|------|
| 帧率 | 60fps（仪式动画可降至 30fps 但需平滑插值） | RepaintBoundary 隔离每个动画区域 |
| 帧时间 | ≤16ms | shouldRepaint 精确控制；静态元素用 Picture 缓存 |
| 内存 | 仪式动画峰值 ≤30MB | AnimationController 用完即 dispose；粒子有上限 |
| 启动时间 | 不影响 | 仪式动画资源按需加载 |
| 关闭动效后 | 0 开销 | `_animEnabled` false 时直接渲染静态结果 |

### 4.4 关键技术选型

| 需求 | 选型 | 理由 |
|------|------|------|
| 仪式动画 | 自定义 AnimationController + AnimatedBuilder | 与现有 InteractableCard 风格一致，无新依赖 |
| 物理动画（铜钱/杯筊下落） | 自定义物理 Tween（重力加速度模拟） | 不引入 physic 包，曲线即可 |
| 粒子系统（金光/光尾） | 自定义 ParticleSystem widget | 避免引入 particles_flutter 等 |
| 笔顺书写 | PathMetric + CustomPainter | Flutter 原生支持 |
| 墨晕开 | ShaderMask + RadialGradient | Flutter 原生 |
| 路由转场 | CustomTransitionPage | GoRouter 原生支持 |
| Lottie 资产 | ❌ 不引入 | 避免 APK 体积膨胀；自定义动画更可控 |

---

## 五、实施阶段

### Phase 1：基础设施（必须先做）

- [ ] 新建 `core/animation/` 目录结构
- [ ] `RitualAnimation` 抽象基类
- [ ] `AnimatedChartPainter` CustomPainter 基类
- [ ] `ParticleSystem` 通用粒子组件
- [ ] `TypewriterText` / `InkSpread` 揭示动画组件
- [ ] `AppConfig` 加 4 个 sub-switch + 持久化
- [ ] 设置页 UI 升级（「动效」section 加 4 个 sub-switch）
- [ ] 性能监控工具（开发模式 FPS 显示）

### Phase 2：仪式动画（核心卖点，分两批）

**Phase 2a（前 5 套）**：
- [ ] 周易铜钱抛落
- [ ] 紫微命盘展开（视觉冲击最大）
- [ ] 奇门九宫飞布
- [ ] 大六壬双盘旋转
- [ ] 风水罗盘扫描（利用已有 sensors_plus）

**Phase 2b（后 4 套）**：
- [ ] 梅花数字撞击
- [ ] 掷筊翻转落地
- [ ] 抽签卷轴展开
- [ ] 测字笔顺书写（技术难度最高）

### Phase 3：CustomPainter 绘制过程动画

- [ ] xiaoliuren 圆盘辐射展开
- [ ] ziwei 命盘顺时针展开
- [ ] qimen 九宫螺旋展开
- [ ] daliuren 双盘对位
- [ ] luopan 24 山依次点亮
- [ ] zhouyi 六爻从下到上
- [ ] meihua 上下卦分段
- [ ] chouqian 卷轴书写
- [ ] cezi 笔顺书写
- [ ] jiaobei 旋转入场

### Phase 4：结果揭示 + 路由转场

- [ ] `RevealAnimation` 封装组件
- [ ] 10 术结果页接入揭示动画
- [ ] `tech_transitions.dart` 每术转场 builder
- [ ] `DivinationTech` 加 `transitionBuilder` 字段
- [ ] 路由层接入差异化转场

### Phase 5：首页 + 微动效

- [ ] 首页卡片入场升级（爆炸式展开）
- [ ] 桌面端 hover 反馈
- [ ] IconButton / SwitchListTile / ListTile 微动效
- [ ] CopyResultButton 勾选动画
- [ ] ShareResultButton 扩散效果
- [ ] DivinationLoadingIndicator 替换 CircularProgressIndicator
- [ ] GuideDialog 入场升级

### Phase 6：性能调优 + 验收

- [ ] 所有动画区域加 RepaintBoundary
- [ ] CustomPainter shouldRepaint 精确控制
- [ ] 静态元素 Picture 缓存
- [ ] Profile 模式跑各页面，确认 60fps
- [ ] 关闭动效后跑全部流程，确认无回归
- [ ] flutter analyze 0 issue
- [ ] 双端构建 v2.1.0+17

---

## 六、验收标准

- [ ] **仪式感**：10 术每术都有 3-6s 仪式动画，可设置页跳过
- [ ] **过程可见**：所有 CustomPainter 有"从无到有"绘制过程
- [ ] **结果揭示**：卦象/签诗/断辞有墨晕开/打字机/段落错峰
- [ ] **差异化转场**：10 术路由转场各不相同
- [ ] **微动效**：所有可点击元素有 hover/press 反馈
- [ ] **性能**：60fps，无掉帧；关闭动效后 0 开销
- [ ] **可控**：5 个开关（总+仪式+绘制+揭示+转场）独立配置
- [ ] **视觉**：黑金低饱和度，无光污染
- [ ] **flutter analyze 0 issue**
- [ ] **双端**：APK + Windows zip 构建归档

---

## 七、用户决策结果（已确认）

### 决策 1：仪式动画的跳过策略 → **方案 A：3 秒后显示「跳过」按钮**
（与小六壬现有模式一致，避免按钮干扰仪式感）

### 决策 2：仪式动画时长 → **标准版 4-6s**
（足够仪式感，用户跳过后下次直接进结果页）

### 决策 3：实施分批策略 → **方案 B：分 v2.1.0 + v2.2.0 两批**
- v2.1.0 = Phase 1（基础设施）+ Phase 2a（前 5 套仪式动画：周易/紫微/奇门/大六壬/风水罗盘）
- v2.2.0 = Phase 2b（后 4 套仪式：梅花/掷筊/抽签/测字）+ Phase 3-6（绘制过程/揭示/转场/微动效/性能调优）

### 决策 4：是否引入 Lottie → **不引入**
（自定义动画，APK 体积可控，与现有风格一致）

### 决策 5：测字笔顺书写 → **方案 C：简化为浮现 + 五行色染**
（整个字一次性浮现，五行色从中心扩散染色。避免数据膨胀，留待 v3.0 视需要再深化）

---

## 八、v2.1.0 实施清单（Phase 1 + Phase 2a）

### Phase 1：基础设施

- [x] 新建 `core/animation/` 目录结构（ritual / painters / transitions / reveal / particles）
- [x] `RitualAnimation` 抽象基类（ConsumerStatefulWidget + onCompleted + 3s 跳过按钮）
- [x] `AnimatedChartPainter` CustomPainter 基类（progress 参数驱动）
- [x] `ParticleSystem` 通用粒子组件（金光/光尾用）
- [x] `TypewriterText` 打字机文本组件
- [x] `InkSpread` 墨晕开 ShaderMask 组件
- [x] `AppConfig` 加 4 个 sub-switch（ritualAnimationsEnabled / painterAnimationsEnabled / revealAnimationsEnabled / transitionsEnabled）+ 持久化
- [x] 设置页 UI 升级（「动效」section 加 4 个 sub-switch）
- [x] `AppAnimations` 新增仪式时长常量（ritualZhouyi/Ziwei/Qimen/Daliuren/Luopan + skipButtonDelay）
- [ ] 性能监控工具（开发模式 FPS 显示，可隐藏，留待 v2.2.0）

### Phase 2a：前 5 套仪式动画

- [x] `zhouyi_ritual.dart` 周易铜钱抛落（5s）—— 3 枚铜钱 6 次抛落成六爻
- [x] `ziwei_ritual.dart` 紫微命盘展开（6s）—— 中心爆光+12宫辐射+14主星降落（视觉冲击最大）
- [x] `qimen_ritual.dart` 奇门九宫飞布（5s）—— 九宫显现+值符值使飞入+八门九星八神落座
- [x] `daliuren_ritual.dart` 大六壬双盘旋转（5s）—— 天盘顺/地盘逆对位+四课三传落定
- [x] `luopan_ritual.dart` 风水罗盘扫描（4s）—— 罗盘扫描到真实方位+24山依次点亮

### 路由注册

- [x] `app_router.dart` 新增 `/ritual/zhouyi`、`/ritual/ziwei`、`/ritual/qimen`、`/ritual/daliuren`、`/ritual/luopan`
- [x] `home_page.dart` 5 个术的卡片点击路由跳转改为先走仪式动画（小六壬继续走 `xiaoliurenCinematic`，5 个新术受 `ritualAnimationsEnabled` 控制）
- [x] 仪式动画结束后调用 `onCompleted` → `context.go('/tech/<id>')`

### Phase 2a 验收

- [x] 5 术点击卡片后进入对应仪式动画
- [x] 仪式动画 3s 后显示跳过按钮
- [x] 跳过/完成后进入对应 tech 页面
- [x] 设置页关闭 ritualAnimationsEnabled 后，点击卡片直接进 tech 页面
- [x] flutter analyze 0 issue（5 个 subagent 各自验证通过 + 路由集成后整体校验）
- [x] 双端构建 v2.1.0+17（APK 53.48 MB + Windows zip 13.1 MB）

---

## 九、v2.2.0 实施清单（Phase 2b + Phase 4.3 + Phase 5.1）

### Phase 2b：后 4 套仪式动画
- [x] 梅花数字撞击（4s）—— `meihua_ritual.dart`，5 阶段（飘落→撞击→消散→动爻→描边）
- [x] 掷筊翻转落地（3s）—— `jiaobei_ritual.dart`，4 阶段（抛物线→翻滚→弹跳→定型）
- [x] 抽签卷轴展开（5s）—— `chouqian_ritual.dart`，5 阶段（摇晃→跳出→展开→书写→描边）
- [x] 测字浮现+色染（5s）—— `cezi_ritual.dart`，4 阶段（粒子→浮现→木行色染→描边）
- [x] 4 个新时长常量：`ritualMeihua=4000` / `ritualJiaobei=3000` / `ritualCezi=5000` / `ritualChouqian=5000`
- [x] 路由注册：`/ritual/meihua`、`/ritual/jiaobei`、`/ritual/chouqian`、`/ritual/cezi`
- [x] home_page.dart `_ritualTechs` Set 扩展至 9 个术

### Phase 4.3：路由转场差异化
- [x] `tech_transitions.dart` 新建：10 术专属转场 builder（小六壬太极旋/周易爻堆叠/紫微辐射/奇门九宫/抽签卷轴/测字字符浮现/大六壬双盘旋转/风水罗盘指针扫描/梅花数字合体/掷筊抛物线）
- [x] `app_router.dart` `/tech/:id` 接入 `TechTransition.build()`，读 `transitionsEnabled` 决定是否启用

### Phase 5.1：DivinationLoadingIndicator
- [x] `divination_loading_indicator.dart` 新建：六边形外环 + 八卦点环 + 中心金光呼吸（2.4s/圈）
- [x] 替换 `history_page.dart` 和 `settings_page.dart` 中的 `CircularProgressIndicator`

### v2.2.0 验收
- [x] 10 术每术都有仪式入场动画（v2.1.0 5 套 + v2.2.0 4 套 + 小六壬已有 = 10）
- [x] 10 术路由转场各不相同（受 `transitionsEnabled` 控制）
- [x] 加载指示器中国风化
- [x] 双端构建 v2.2.0+18（APK 53.60 MB + Windows zip 13.12 MB）

### 留待 v2.3.0
- [ ] Phase 3：10 处 CustomPainter 绘制过程动画升级
- [ ] Phase 4.1-4.2：RevealAnimation 结果揭示封装 + 10 术接入
- [ ] Phase 5 其他：首页爆炸式展开 + 桌面 hover + IconButton/SwitchListTile/ListTile 微动效 + GuideDialog 入场
- [ ] Phase 6：性能调优 + 验收

---

## 十、体积与时长预估

| 维度 | 预估 |
|------|------|
| 新增代码行数 | ~3000-4000 行 Dart |
| APK 体积增量 | +500KB-1MB（主要是粒子系统 + 仪式动画组件，无新依赖） |
| 实施工时 | Phase 1: 1天 / Phase 2: 2-3天 / Phase 3: 1天 / Phase 4: 1天 / Phase 5: 1天 / Phase 6: 0.5天 = 6-7天 |
| 单仪式动画代码量 | ~200-400 行/术 |
| 单 CustomPainter 动画改造 | ~50-100 行/处 |
