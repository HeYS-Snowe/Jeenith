# 详细设计说明书 Low Level Design Document

> 志极 Jeenith · 卜算合集详细设计与关键算法

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
| v1.0.0 | 2026-01 | 初版：类图、注册表、RNG、HistoryStore 详细设计 |
| v2.3.0 | 2026-06 | 补充 AnimationKind 拆分、紫微/八字算法流程 |
| v2.3.3 | 2026-07-15 | 同步当前实现，完善序列图 |

---

## 1. 详细设计概述 LLD Overview

本文档在《概要设计说明书》基础上，深入到类、方法、算法与序列层面，描述志极 Jeenith 的关键实现细节。重点覆盖：核心注册表、真随机引擎、配置状态机、历史存储、仪式动画体系、典型术算法流程。

---

## 2. 核心类设计 Core Class Design

### 2.1 卜算框架类图 Divination Framework Class Diagram

```
                    ┌─────────────────────────┐
                    │   «interface»           │
                    │   DivinationTech        │
                    ├─────────────────────────┤
                    │ + id: String            │
                    │ + meta: TechMeta        │
                    │ + buildPage(ctx, ref)   │
                    └────────────┬────────────┘
                                 ▲
            ┌────────┬───────────┼───────────┬─────────┐
            │        │           │           │         │
   XiaoliurenTech ZhouyiTech  ZiweiTech  ...  BaziTech
            │        │           │
            ▼        ▼           ▼
       XiaoliurenPage ZhouyiPage ZiweiPage  (ConsumerWidget)
```

### 2.2 DivinationTech 接口实现 Detail

```dart
abstract class DivinationTech {
  const DivinationTech();
  String get id;                                    // 唯一标识
  TechMeta get meta;                                // 元数据
  Widget buildPage(BuildContext context, WidgetRef ref);  // 页面构造
}

@immutable
class TechMeta {
  final String id;
  final String displayName;   // '小六壬'
  final String subtitle;      // '掐指神课'
  final String description;
  final Color accentColor;    // 卡片主题色
  final int sortOrder;        // 首页排序
  final bool enabled;         // 功能开关
}
```

**设计要点**：
- `const` 构造使所有 Tech 实例可为编译期常量，注册表无运行时开销
- `buildPage` 注入 `WidgetRef`，术页面可直接 `ref.read/watch` 全局 Provider
- 框架只统一「注册发现 + RNG + 配置 + 主题 + 共享组件」，输入采集/起卦/动画/展示由术页面自管

### 2.3 注册表实现 Registry Implementation

```dart
final divinationTechsProvider = Provider<List<DivinationTech>>((ref) {
  final techs = <DivinationTech>[
    XiaoliurenTech(), ZhouyiTech(), MeihuaTech(), JiaobeiTech(),
    ZiweiTech(), QimenTech(), ChouqianTech(), CeziTech(),
    DaliurenTech(), LuopanTech(), NameTestTech(), BaziTech(),
  ];
  assert(techs.map((t) => t.id).toSet().length == techs.length,
      'Duplicate DivinationTech id detected');
  return techs;
});

final techByIdProvider = Provider.family<DivinationTech?, String>((ref, id) =>
    ref.watch(divinationTechsProvider).where((t) => t.id == id).firstOrNull);

final visibleTechsProvider = Provider<List<DivinationTech>>((ref) =>
    ref.watch(divinationTechsProvider)
        .where((t) => t.meta.enabled).toList()
      ..sort((a, b) => a.meta.sortOrder.compareTo(b.meta.sortOrder)));
```

**关键设计**：
- `assert` 在 debug 模式拦截 id 重复，避免 `firstOrNull` 静默命中错误项
- `Provider.family` 实现路由参数 → 术实例的按需解析
- `visibleTechsProvider` 二次过滤 + 排序，首页 grid 直接消费

---

## 3. 真随机引擎详细设计 RNG Detail Design

### 3.1 类结构 RNG Class Structure

```
TrueRandom
   ├── sources: List<EntropyCollector>
   └── generate({count, vmax}) → Future<EntropySample>

EntropyCollector «interface»
   ├── SystemEntropySource   (Random.secure)
   ├── TouchEntropySource    (TouchTracker 轨迹)
   └── OnlineEntropySource   (random.org HTTP)

TouchTracker
   ├── onPointerMove(event)
   ├── onPointerHover(event)
   └── sample() → bytes

EntropySample
   ├── numbers: List<int>
   ├── sources: List<EntropySourceResult>
   └── timestamp: DateTime
```

### 3.2 generate() 算法流程 generate Algorithm

```dart
Future<EntropySample> generate({int count = 3, int vmax = 9}) async {
  final results = <EntropySourceResult>[];
  final parts = <Uint8List>[];

  // 1. 逐源采样（任一失败不影响其他）
  for (final src in sources) {
    if (!src.isAvailable) { results.add(...failed); continue; }
    try {
      final r = await src.sample();
      results.add(...succeeded(r.display));
      if (r.bytes.isNotEmpty) parts.add(r.bytes);
    } catch (_) { results.add(...failed); }
  }

  // 2. 多源 SHA256 链式混合
  var digest = sha256.convert(<int>[]).bytes;
  for (final b in parts) {
    digest = sha256.convert([...digest, ...b]).bytes;
  }

  // 3. 收尾加盐（时间戳 + 16 字节系统熵），防重放
  digest = sha256.convert([
    ...digest,
    ...utf8.encode(DateTime.now().microsecondsSinceEpoch.toString()),
    ..._secureBytes(16),
  ]).bytes;

  // 4. 链式 SHA256 扩展为 count 个数（避免简单切片相关性）
  final nums = <int>[];
  var cur = digest;
  for (var i = 0; i < count; i++) {
    cur = sha256.convert([...cur, i]).bytes;
    final big = BigInt.parse(cur.map((b) => b.toRadixString(16).padLeft(2,'0')).join(), radix: 16);
    nums.add((big % BigInt.from(vmax)).toInt() + 1);
  }
  return EntropySample(numbers: nums, sources: results, timestamp: DateTime.now());
}
```

**算法要点**：
- **链式混合**而非拼接：`digest = SHA256(digest ++ bytes_i)`，前源结果影响后源哈希
- **链式扩展**而非切片：每个数 `cur = SHA256(cur ++ i)` 独立哈希，杜绝切片相关性
- **BigInt 取模**：避免 64 位溢出，支持大 vmax（如周易 vmax=64、vmax=384）
- **降级容错**：在线源失败时 `parts` 不含其 bytes，混合仍可用其余源

### 3.3 触摸轨迹熵源 Touch Entropy

`TouchTracker` 由 `JeenithApp` 的 `Listener` 全局监听 `onPointerMove` / `onPointerHover`，累积指针坐标/时间戳。`TouchEntropySource.sample()` 将轨迹序列化为 bytes 并清空缓冲。桌面平台通过 `onPointerHover` 采集鼠标移动轨迹，保证跨平台均有轨迹熵。

---

## 4. 配置状态机详细设计 Config State Machine

### 4.1 AppConfig 模型 Config Model

```dart
enum AnimationKind { entrance, transition, painter, reveal }

class AppConfig {
  final bool showDetails;
  final bool useOnline;
  final bool animationsEnabled;                    // 总开关
  final Map<String, Map<String, bool>> animationSettings;  // 外层 techId，内层 kind
  final ThemeMode themeMode;

  bool isAnimationEnabled(String techId, AnimationKind kind) =>
      animationSettings[techId]?[kind.name] ?? true;  // 缺省 true（向前兼容）

  static const defaults = AppConfig(
    showDetails: true, useOnline: true, animationsEnabled: true,
    animationSettings: {}, themeMode: ThemeMode.dark,
  );
}
```

### 4.2 ConfigNotifier 状态流转 State Transition

```
build() ──► AsyncLoading<AppConfig>
   │ 读取 SharedPreferences
   ▼
AsyncData<AppConfig>
   │ setXxx(v)
   ▼
写 prefs → current.copyWith(...) → state = AsyncData(new)
```

**持久化 Key 设计**：
- 配置项：`showDetails` / `useOnline` / `animationsEnabled` / `themeMode`
- 分术动画：`anim_<techId>_<kind>`（如 `anim_xiaoliuren_entrance`）
- 解析时以**最后一个下划线**分段（techId 可能含下划线，如 `name_test`），尾部为 kind

**向前兼容**：v2.3.2 前的旧 key `anim_<techId>`（无 kind 后缀）不再读取，未记录的术/kind 默认 true。

### 4.3 动画开关判定逻辑 Animation Toggle Logic

```
UI 渲染动画前：
  if (!config.animationsEnabled) → 全部跳过（总开关）
  else if (!config.isAnimationEnabled(techId, kind)) → 跳过该类
  else → 播放
```

`/tech/:id` 路由的 `pageBuilder` 读取 `isAnimationEnabled(id, AnimationKind.transition)` 决定 `TechTransition` 是否启用签名转场，关闭时降级为 fade。

---

## 5. 历史存储详细设计 History Store Detail

### 5.1 原子写串行化 Atomic Serialization

```dart
class HistoryStore {
  static const _key = 'divination_history';
  static Future<void> _chain = Future.value();   // 串行链

  static Future<T> _serialize<T>(Future<T> Function() task) {
    final prev = _chain;
    final completer = Completer<T>();
    _chain = prev.then((_) => task())
        .then(completer.complete, onError: completer.completeError);
    return completer.future;
  }

  static Future<void> add(HistoryEntry e) => _serialize(() async {
    final list = await load();
    list.insert(0, e);          // 最新在前
    await _save(list);
  });
}
```

**为何串行化**：快速连续卜算时，多个 `add` 并发执行 `load() → modify → save` 会导致后写覆盖先写（lost update）。`_serialize` 将所有写操作排队到 `_chain`，前一个完成才执行下一个，保证读-改-写原子性。

### 5.2 ID 生成策略 ID Generation

```dart
static int _counter = 0;
static String generateId() {
  final now = DateTime.now();
  _counter = (_counter + 1) & 0xFFFF;
  return '${now.microsecondsSinceEpoch}-${_counter.toRadixString(16).padLeft(4, '0')}';
}
```

- `microsecondsSinceEpoch` 提供时间维度唯一性
- `_counter`（& 0xFFFF 回绕）解决同一帧多次调用的碰撞
- 16 进制补零，固定长度便于排序与展示

### 5.3 HistoryEntry 序列化 Serialization

```dart
Map<String, dynamic> toJson() => {
  'id': id, 'techId': techId, 'techName': techName,
  'time': time.toIso8601String(),
  'summary': summary, 'detail': detail, 'note': note,
};
```

存储为 SharedPreferences 下的 JSON 数组字符串，`load()` 解析失败返回空列表（容错）。

---

## 6. 路由详细设计 Router Detail

### 6.1 GoRouter 路由表 Route Table

```dart
final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/manual', builder: (_, __) => const ManualPage()),
    // 仪式前置路由（每术一条）
    GoRoute(path: '/ritual/xiaoliuren', builder: (...) => XiaoliurenRitual(onCompleted: () => context.go('/tech/xiaoliuren'))),
    // ... 其他 11 术 /ritual/<id>
    // 术主页面（动态解析）
    GoRoute(
      path: '/tech/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        final tech = ref.read(techByIdProvider(id));
        final page = (tech == null) ? _UnknownTechPage() : _TechPage(tech: tech);
        final transitionsEnabled = ref.read(configProvider).valueOrNull
            ?.isAnimationEnabled(id, AnimationKind.transition) ?? true;
        return TechTransition.build(key: state.pageKey, child: page,
            techId: id, transitionsEnabled: transitionsEnabled);
      },
    ),
  ],
));
```

### 6.2 仪式路由设计 Ritual Route Design

- 每术一条 `/ritual/<id>` 路由，构建对应 `<Tech>Ritual` 组件
- `onCompleted` 回调 `context.go('/tech/<id>')` 进入术主页面
- 仪式动画时长 3-6s，跳过按钮延迟 3s 显示（`skipButtonDelay`）
- 无仪式动画的术（如测名字/八字）可直接 `context.go('/tech/<id>')`

### 6.3 转场降级 Transition Fallback

`TechTransition.build` 根据 `transitionsEnabled` 决定：启用时返回该术签名转场（CustomPage + 自定义 transitionBuilder），关闭时降级为默认 fade。

---

## 7. 仪式动画体系 Ritual Animation System

### 7.1 动画分类与时长 Animation Categories

| 术 Tech | 仪式 Ritual | 时长 Duration | 核心 Core |
|--------|-----------|-------------|---------|
| 小六壬 | 太极生六宫 | — | 六宫辐射展开 |
| 周易 | 铜钱抛落 | 5000ms | 6 轮金钱卦抛掷 |
| 紫微 | 命盘展开 | 6000ms | 12 宫辐射 + 14 主星降落 |
| 奇门 | 九宫飞布 | 5000ms | 值符值使 + 八门九星八神 |
| 大六壬 | 双盘旋转 | 5000ms | 天盘顺/地盘逆 + 四课三传 |
| 风水罗盘 | 罗盘扫描 | 4000ms | 指针扫描 + 24 山点亮 |
| 梅花 | 数字撞击 | 4000ms | 两数飘落 + 撞击爆发 |
| 掷筊 | 杯筊翻转 | 3000ms | 抛物线 + 翻滚 + 定型 |
| 抽签 | 卷轴展开 | 5000ms | 签筒摇 + 签条跳 + 卷轴展 |
| 测字 | 字形浮现 | 5000ms | 道字浮现 + 木色扩散 |

时长常量集中在 `AppAnimations`（`ritualZhouyi = 5000` 等），跳过按钮 `skipButtonDelay = 3000`。

### 7.2 动效常量集中化 Animation Constants

`core/theme/animations.dart` 集中管理：
- **时长**：pressDown(110) / pressRelease(260) / iconRotate(240) / cardStagger(90) / cardRise(420) / panelExpand(260) 等
- **曲线**：pressDownCurve(easeIn) / pressReleaseCurve(Cubic(0.34,1.56,0.64,1) easeOutBack 变体) / iconRotateCurve(easeOutCubic) 等
- **错峰工具**：`staggeredIntervals(count, {stepRatio, durationRatio})` 生成 N 个 Interval

### 7.3 RevealAnimation 揭示封装

`core/animation/reveal/` 下：
- `reveal_animation.dart`：结果揭示动画封装（受 AnimationKind.reveal 开关控制）
- `ink_spread.dart`：墨晕扩散效果
- `typewriter_text.dart`：打字机文本逐字显现

---

## 8. 典型术算法流程 Typical Algorithm Flow

### 8.1 小六壬起卦流程 Xiaoliuren Algorithm

```
输入：3 个随机数 n1, n2, n3 (1..6 或 1..9)
   │
   ▼
1. 从「大安」起，按 n1 数 → 第一宫（月宫）
2. 从月宫起，按 n2 数 → 第二宫（日宫）
3. 从日宫起，按 n3 数 → 第三宫（时宫 / 末宫）
   │
   ▼
六宫：大安(木)·留连(水)·速喜(火)·赤口(金)·小吉(水)·空亡(土)
   │
   ▼
末宫定吉凶分级 + 七维断辞（求谋/失物/出行/婚姻/财运/疾病/官非）
   │
   ▼
DivinationResult {
  primaryName: 末宫名,
  cards: [三宫卡],
  verdict: Verdict(分级, 断语),
  details: [七维断辞],
}
```

### 8.2 周易金钱卦流程 Zhouyi Algorithm

```
输入：6 个随机数（每爻一次，三钱抛掷）
   │
   ▼
每爻：三钱正反面 → 6/7/8/9
  - 6 = 老阴（变阳）  - 7 = 少阳
  - 8 = 少阴          - 9 = 老阳（变阴）
   │
   ▼
本卦（6 爻组合 → 64 卦查表）+ 变爻位
   │
   ▼
有变爻 → 变卦（变爻阴阳互换 → 查表）
   │
   ▼
DivinationResult {
  primaryName: 本卦名,
  secondaryName: 变卦名,
  changingPositions: [变爻位],
  cards: [本卦卡, 变卦卡],
}
```

64 卦与八卦数据由 `data/yijing/` 提供，周易与梅花共用。

### 8.3 紫微斗数排盘流程 Ziwei Algorithm

```
输入：生辰（公历年月日时）+ 性别
   │
   ▼
1. LunarService / lunar 包 → 农历 + 干支 + 八字
2. 定命宫/身宫（月支 + 时支逆推）
3. 命盘 12 宫布局（命/兄/夫/子/财/疾/迁/奴/官/田/福/父）
4. 安 14 主星（紫微/天府系）+ 辅星/煞星
5. 大限/流年推算
   │
   ▼
DivinationResult {
  cards: [12 宫卡 + 主星],
  raw: 完整命盘结构,
}
```

### 8.4 八字推演流程 Bazi Algorithm

```
输入：生辰（公历年月日时）+ 性别
   │
   ▼
1. lunar 包 → 四柱（年柱/月柱/日柱/时柱）天干地支
2. 五行强度分析 + 日主旺衰
3. 十神排列 + 大运排布（按性别阴阳顺逆）
4. 用神选取
   │
   ▼
DivinationResult {
  cards: [四柱卡 + 大运],
  raw: 八字结构,
}
```

---

## 9. 共享组件详细设计 Shared Widgets Detail

### 9.1 GoldButton 物理反馈

按下塌缩（pressDown 110ms easeIn）→ 抬起弹回（pressRelease 260ms Cubic(0.34,1.56,0.64,1) 略带回弹），模拟物理弹性质感。受 `animationsEnabled` 总开关约束。

### 9.2 InteractableCard 错峰上浮

`AppAnimations.staggeredIntervals(n)` 生成 N 个 Interval，相邻卡片错开 `stepRatio=0.08`，每张占 `durationRatio=0.42`，曲线 `cardRiseCurve`（easeOutCubic）。

### 9.3 Starfield 星空粒子

`Positioned.fill` 铺满全 APP 背景，随机生成星点粒子，定时清理离屏粒子，受主题色影响（深色/浅色模式不同星色）。`JeenithApp` 的 `builder` 将其作为 Stack 底层。

### 9.4 CopyResultButton / ShareResultButton

- Copy：构造结果文本 → `Clipboard.setData`
- Share：构造结果文本 → `SharePlus.shareXFiles` / `Share.share`（依赖 share_plus）

---

## 10. 内存与资源管理 Memory & Resource

### 10.1 CustomPainter dispose 规范

```dart
class _MyPainter extends CustomPainter {
  final TextPainter _tp = TextPainter(...);
  @override
  void paint(Canvas canvas, Size size) { _tp.layout(); _tp.paint(canvas, offset); }
  @override
  void dispose() { _tp.dispose(); super.dispose(); }  // 必须显式 dispose
}
```

TextPainter 持有 native 文本布局 handle，不 dispose 会泄漏。项目规则强制所有 CustomPainter 实现 dispose。

### 10.2 AnimationController 释放

所有 StatefulWidget 中的 AnimationController 在 `dispose()` 中调用 `_controller.dispose()`。

### 10.3 粒子回收

Starfield 维护粒子池，离屏粒子标记可复用，避免无限增长。

---

## 11. 关键序列图 Key Sequence Diagrams

### 11.1 起卦全序列 Divination Sequence

```
User    HomePage   Router   Ritual   TechPage   TrueRandom  Algorithm  HistoryStore
 │         │          │        │         │           │          │           │
 │─click──►│          │        │         │           │          │           │
 │         │─go(/ritual/zhouyi)►│       │           │          │           │
 │         │          │─build─►│        │           │          │           │
 │         │          │        │─anim done           │          │           │
 │         │          │        │─go(/tech/zhouyi)────►│          │           │
 │         │          │        │         │─generate(count:6,vmax:64)►│      │
 │         │          │        │         │           │◄─EntropySample──────│
 │         │          │        │         │─divine(nums)──────────►│        │
 │         │          │        │         │◄─DivinationResult──────│        │
 │         │          │        │         │─add(entry)──────────────────────►│
 │         │          │        │         │─render(RevealAnimation)│        │
```

### 11.2 配置变更序列 Config Change Sequence

```
SettingsPage → ConfigNotifier.setAnimationSetting(techId, kind, v)
   → SharedPreferences.setBool('anim_<techId>_<kind>', v)
   → state = AsyncData(config.copyWith(animationSettings: next))
   → watch(configProvider) 的 UI（含 routerProvider 转场判定）自动重建
```

---

## 12. 设计模式应用 Design Patterns

| 模式 Pattern | 应用 Application |
|------------|----------------|
| **策略模式 Strategy** | EntropyCollector 接口 + 3 实现，TrueRandom 持有 List |
| **注册表模式 Registry** | divinationTechsProvider 集中注册，按 id/family 查找 |
| **模板方法** | DivinationTech 接口定义骨架，各术实现 buildPage |
| **观察者 Observer** | Riverpod Provider watch 机制，配置变更自动传播 |
| **单例 Singleton** | HistoryStore 全静态方法，PlatformInfo 静态 final |
| **barrel 模块** | providers.dart 聚合 export |
| **工厂模式 Factory** | Provider.family 按参数构造 |

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
