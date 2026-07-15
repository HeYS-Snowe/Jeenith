# App 页面与路由清单 App Pages & Routes

> 志极 Jeenith · 页面清单与 go_router 路由表

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 / Jeenith |
| 组织 Organization | Qore Origins（叩心） |
| 包名 Package | `com.qore.jeenith` |
| 文档版本 Version | v2.3.3 |
| 当前版本 App Version | 2.3.3+23（release，2026-07-15） |
| 开发者 Developer | HeYS-Snowe |
| 路由库 Router | go_router ^14.0 |
| 许可证 License | MIT · Copyright (c) 2026 Qore |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改内容 Description |
|-------------|---------|-------------------|
| v1.0.0 | 2026-01 | 初版：4 系统页 + 12 术路由 |
| v2.1.0 | 2026-04 | 新增 5 术仪式前置路由（周易/紫微/奇门/大六壬/罗盘） |
| v2.2.0 | 2026-05 | 新增 4 术仪式前置路由（梅花/掷筊/抽签/测字） |
| v2.3.3 | 2026-07-15 | 同步当前路由表与转场逻辑 |

---

## 1. 路由概述 Route Overview

### 1.1 路由方案 Routing Solution

志极 Jeenith 采用 `go_router ^14.0` 声明式路由，路由表集中在 `mobile/lib/router/app_router.dart`，由 `routerProvider`（Riverpod Provider）暴露。`JeenithApp` 通过 `ref.watch(routerProvider)` 注入 `MaterialApp.router`。

### 1.2 路由分类 Route Categories

| 类别 Category | 路径模式 Pattern | 数量 Count | 说明 |
|------------|--------------|----------|-----|
| 系统页 System | `/` `/history` `/settings` `/manual` | 4 | 固定页面 |
| 仪式前置 Ritual | `/ritual/<id>` | 10 | 各术入场动画 |
| 术主页 Tech | `/tech/:id` | 1（动态） | 动态解析 12 术 |

### 1.3 初始路由 Initial Route

`initialLocation: '/'`（首页）

---

## 2. 完整路由表 Route Table

### 2.1 系统页路由 System Routes

| 路径 Path | 页面 Page | 文件 File | builder/pageBuilder | 说明 |
|---------|--------|--------|------------------|-----|
| `/` | HomePage | `features/home/home_page.dart` | builder | 首页：术数 grid + 品牌 |
| `/history` | HistoryPage | `features/history/history_page.dart` | builder | 卜算历史列表 |
| `/settings` | SettingsPage | `features/settings/settings_page.dart` | builder | 配置页 |
| `/manual` | ManualPage | `features/manual/manual_page.dart` | builder | 使用手册 |

### 2.2 仪式前置路由 Ritual Routes

每术一条 `/ritual/<id>`，构建对应 `<Tech>Ritual` 组件，`onCompleted` 回调 `context.go('/tech/<id>')` 进入术主页。

| 路径 Path | 仪式组件 Ritual Widget | 文件 File | 时长 Duration | 引入版本 Added |
|---------|------------------|--------|------------|------------|
| `/ritual/xiaoliuren` | XiaoliurenRitual | `features/xiaoliuren/ui/xiaoliuren_ritual.dart` | — | v1.0.0 |
| `/ritual/zhouyi` | ZhouyiRitual | `core/animation/ritual/zhouyi_ritual.dart` | 5000ms | v2.1.0 |
| `/ritual/ziwei` | ZiweiRitual | `core/animation/ritual/ziwei_ritual.dart` | 6000ms | v2.1.0 |
| `/ritual/qimen` | QimenRitual | `core/animation/ritual/qimen_ritual.dart` | 5000ms | v2.1.0 |
| `/ritual/daliuren` | DaliurenRitual | `core/animation/ritual/daliuren_ritual.dart` | 5000ms | v2.1.0 |
| `/ritual/luopan` | LuopanRitual | `core/animation/ritual/luopan_ritual.dart` | 4000ms | v2.1.0 |
| `/ritual/meihua` | MeihuaRitual | `core/animation/ritual/meihua_ritual.dart` | 4000ms | v2.2.0 |
| `/ritual/jiaobei` | JiaobeiRitual | `core/animation/ritual/jiaobei_ritual.dart` | 3000ms | v2.2.0 |
| `/ritual/chouqian` | ChouqianRitual | `core/animation/ritual/chouqian_ritual.dart` | 5000ms | v2.2.0 |
| `/ritual/cezi` | CeziRitual | `core/animation/ritual/cezi_ritual.dart` | 5000ms | v2.2.0 |

> 注：`bazi`（八字）与 `name_test`（测名字）无独立仪式前置路由，首页卡片点击直接 `context.go('/tech/<id>')`。

### 2.3 术主页路由 Tech Route

| 路径 Path | 解析 Resolution | 文件 File | pageBuilder | 转场 Transition |
|---------|-------------|--------|-----------|--------------|
| `/tech/:id` | `techByIdProvider(id)` → DivinationTech | `router/app_router.dart` | pageBuilder | TechTransition（按术开关降级 fade） |

**动态解析流程**：
1. 取 `state.pathParameters['id']`
2. `ref.read(techByIdProvider(id))` 查找术
3. `tech == null` → 渲染「未知卜算法」占位页
4. `tech != null` → `_TechPage(tech: tech)` → `tech.buildPage(context, ref)`
5. 读取 `isAnimationEnabled(id, AnimationKind.transition)` 决定转场

---

## 3. 页面清单 Page Inventory

### 3.1 系统页 System Pages

#### 3.1.1 首页 HomePage

- **路由**：`/`
- **文件**：`features/home/home_page.dart`
- **职责**：
  - 品牌标识展示（志极 / Jeenith / 口号）
  - 术数 grid（`visibleTechsProvider` 渲染，按 `sortOrder` 排序）
  - 卡片点击 → 仪式路由或直接术主页
  - 底部入口：历史 / 设置 / 手册
- **关键组件**：InteractableCard（错峰入场）、SvgIcon

#### 3.1.2 历史页 HistoryPage

- **路由**：`/history`
- **文件**：`features/history/history_page.dart`
- **职责**：
  - `HistoryStore.load()` 渲染历史列表（最新在前）
  - 单条点击展开详情
  - 编辑备注（`updateNote`）
  - 删除单条（`remove`）/ 清空（`clear`）
  - 导出（JSON/MD/CSV）→ share_plus 分享
- **状态**：本地 setState + HistoryStore 静态调用

#### 3.1.3 设置页 SettingsPage

- **路由**：`/settings`
- **文件**：`features/settings/settings_page.dart`
- **职责**：
  - 熵源开关（`useOnline`）
  - 采样详情开关（`showDetails`）
  - 动画总开关（`animationsEnabled`）
  - 一键批量动画开关（`setAllAnimations`）
  - 分术 × AnimationKind 细粒度开关（`setAnimationSetting`）
  - 主题模式切换（`themeMode`：system/light/dark）
  - 关于信息（版本/版权/开发者）
- **状态**：`configProvider`（AsyncNotifier）

#### 3.1.4 手册页 ManualPage

- **路由**：`/manual`
- **文件**：`features/manual/manual_page.dart`
- **职责**：各术使用说明、起卦方法、术语解释

### 3.2 术主页 Tech Pages

每个术主页由对应 `DivinationTech.buildPage` 构造，文件位于 `features/<tech>/ui/<tech>_page.dart`。

| 术 id | 页面 Page | 文件 File | 输入采集 Input |
|-----|--------|--------|------------|
| xiaoliuren | XiaoliurenPage | `features/xiaoliuren/ui/xiaoliuren_page.dart` | 真随机 3 数 |
| zhouyi | ZhouyiPage | `features/zhouyi/ui/zhouyi_page.dart` | 真随机 6 爻 |
| meihua | MeihuaPage | `features/meihua/ui/meihua_page.dart` | 数/时起卦 |
| jiaobei | JiaobeiPage | `features/jiaobei/ui/jiaobei_page.dart` | 真随机 |
| ziwei | ZiweiPage | `features/ziwei/ui/ziwei_page.dart` | 生辰 |
| qimen | QimenPage | `features/qimen/ui/qimen_page.dart` | 时辰 |
| chouqian | ChouqianPage | `features/chouqian/ui/chouqian_page.dart` | 真随机 |
| cezi | CeziPage | `features/cezi/ui/cezi_page.dart` | 手写/输入 |
| daliuren | DaliurenPage | `features/daliuren/ui/daliuren_page.dart` | 时辰 |
| luopan | LuopanPage | `features/luopan/ui/luopan_page.dart` | 传感器/触摸 |
| name_test | NameTestPage | `features/name_test/ui/name_test_page.dart` | 姓名输入 |
| bazi | BaziPage | `features/bazi/ui/bazi_page.dart` | 生辰 |

### 3.3 仪式动画页 Ritual Pages

仪式动画组件位于 `core/animation/ritual/<tech>_ritual.dart`（小六壬位于 `features/xiaoliuren/ui/xiaoliuren_ritual.dart`），由仪式路由构建。

每个仪式组件约定：
- 接收 `onCompleted` 回调
- 内部 AnimationController 驱动动画
- 跳过按钮延迟 3s 显示（`skipButtonDelay`）
- `onCompleted` → `context.go('/tech/<id>')`

---

## 4. 路由流转图 Route Flow

### 4.1 完整起卦流转 Full Divination Flow

```
                        ┌─────────┐
                        │ 首页 /  │
                        └────┬────┘
                             │ 点击术卡片
                ┌────────────┴────────────┐
                ▼                         ▼
     有仪式前置（10 术）          无仪式（bazi/name_test）
                │                         │
                ▼                         │
     /ritual/<id> 仪式动画                │
                │ onCompleted             │
                ▼                         │
     /tech/<id> ◄─────────────────────────┘
                │
                ▼
        术主页（采集 → 起卦 → 结果）
                │
        ┌───────┼───────┐
        ▼       ▼       ▼
   复制结果  分享结果  历史记录
                        │
                        ▼
               /history 历史页
```

### 4.2 系统页流转 System Navigation

```
/  ───► /history
 │  ───► /settings
 │  ───► /manual
 │  ───► /ritual/<id> ───► /tech/<id>
 │
 └─ AppBar/底部入口互跳
```

---

## 5. 路由实现细节 Route Implementation

### 5.1 routerProvider 定义

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/history', builder: (context, state) => const HistoryPage()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
      GoRoute(path: '/manual', builder: (context, state) => const ManualPage()),
      // 10 条仪式路由
      GoRoute(path: '/ritual/xiaoliuren',
          builder: (context, state) => XiaoliurenRitual(onCompleted: () => context.go('/tech/xiaoliuren'))),
      // ... 其他 9 术
      // 术主页动态路由
      GoRoute(path: '/tech/:id', pageBuilder: (context, state) { ... }),
    ],
  );
});
```

### 5.2 仪式路由 builder 模式 Ritual Builder Pattern

```dart
GoRoute(
  path: '/ritual/zhouyi',
  builder: (context, state) =>
      ZhouyiRitual(onCompleted: () => context.go('/tech/zhouyi')),
)
```

`context.go` 替换栈顶，仪式页不残留于路由历史。

### 5.3 术主页 pageBuilder 与转场 Tech pageBuilder & Transition

```dart
GoRoute(
  path: '/tech/:id',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id']!;
    final tech = ref.read(techByIdProvider(id));
    final Widget page = (tech == null)
        ? const Scaffold(body: Center(child: Text('未知卜算法')))
        : _TechPage(tech: tech);
    final transitionsEnabled = ref
            .read(configProvider).valueOrNull
            ?.isAnimationEnabled(id, AnimationKind.transition) ?? true;
    return TechTransition.build(
      key: state.pageKey,
      child: page,
      techId: id,
      transitionsEnabled: transitionsEnabled,
    );
  },
)

class _TechPage extends ConsumerWidget {
  final DivinationTech tech;
  const _TechPage({required this.tech});
  @override
  Widget build(BuildContext context, WidgetRef ref) => tech.buildPage(context, ref);
}
```

**要点**：
- 用 `pageBuilder` 而非 `builder`，以便返回 `CustomPage` 注入转场
- `state.pageKey` 保证转场动画正确识别页面
- `transitionsEnabled = false` 时 `TechTransition.build` 降级为 fade
- `tech == null` 兜底占位页，防止路由参数错误白屏

### 5.4 转场控制 Transition Control

`TechTransition.build`（`core/animation/transitions/tech_transitions.dart`）：
- 启用：返回该术签名转场（CustomPage + 自定义 transitionBuilder）
- 关闭：降级为默认 fade
- 受 `AnimationKind.transition` + `animationsEnabled` 总开关双重控制

---

## 6. 导航 API Navigation API

### 6.1 go_router 导航方法

| 方法 Method | 用途 Usage | 示例 Example |
|-----------|---------|------------|
| `context.go(path)` | 替换当前页（无返回栈） | `context.go('/tech/zhouyi')` |
| `context.push(path)` | 压栈（可返回） | `context.push('/history')` |
| `context.pop()` | 出栈返回 | `context.pop()` |

### 6.2 项目导航约定 Navigation Conventions

- 仪式 → 术主页用 `context.go`（仪式不残留）
- 首页 → 系统页可用 `context.push`（可返回首页）
- 术主页内不互相跳转（术间隔离）

---

## 7. 页面状态管理 Page State

### 7.1 系统页状态 System Page State

| 页面 | 状态来源 State Source |
|-----|-------------------|
| HomePage | `visibleTechsProvider`（watch） |
| HistoryPage | `HistoryStore.load()`（本地 setState） |
| SettingsPage | `configProvider`（watch AsyncNotifier） |
| ManualPage | 无状态静态内容 |

### 7.2 术主页状态 Tech Page State

各术在 `features/<tech>/state/<tech>_providers.dart` 定义术特定 Provider，或直接 setState。统一通过 `ref.read(trueRandomProvider)` 获取真随机引擎，`ref.read(configProvider)` 读取配置。

---

## 8. 路由与品牌 Route & Branding

- AppBar 标题统一居中，`letterSpacing: 6`，`goldBright` 色
- 全 APP 透明 scaffold + Starfield 背景（`JeenithApp.builder` Stack 底层）
- 仪式页与术主页均叠加 Starfield，视觉连续

---

## 9. 路由清单汇总 Route Summary

| # | 路径 | 类型 | 页面/组件 | 转场 |
|---|-----|-----|---------|-----|
| 1 | `/` | 系统 | HomePage | 默认 |
| 2 | `/history` | 系统 | HistoryPage | 默认 |
| 3 | `/settings` | 系统 | SettingsPage | 默认 |
| 4 | `/manual` | 系统 | ManualPage | 默认 |
| 5 | `/ritual/xiaoliuren` | 仪式 | XiaoliurenRitual | 默认 |
| 6 | `/ritual/zhouyi` | 仪式 | ZhouyiRitual | 默认 |
| 7 | `/ritual/ziwei` | 仪式 | ZiweiRitual | 默认 |
| 8 | `/ritual/qimen` | 仪式 | QimenRitual | 默认 |
| 9 | `/ritual/daliuren` | 仪式 | DaliurenRitual | 默认 |
| 10 | `/ritual/luopan` | 仪式 | LuopanRitual | 默认 |
| 11 | `/ritual/meihua` | 仪式 | MeihuaRitual | 默认 |
| 12 | `/ritual/jiaobei` | 仪式 | JiaobeiRitual | 默认 |
| 13 | `/ritual/chouqian` | 仪式 | ChouqianRitual | 默认 |
| 14 | `/ritual/cezi` | 仪式 | CeziRitual | 默认 |
| 15 | `/tech/:id` | 术主页 | _TechPage（动态） | TechTransition |

共计 **15 条路由**（4 系统 + 10 仪式 + 1 动态术主页，覆盖 12 术）。

---

*本文档由 HeYS-Snowe 维护 · Copyright (c) 2026 Qore. MIT License.*
