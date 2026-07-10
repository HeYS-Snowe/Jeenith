# CLAUDE.md — 志极 Jeenith

> 本文件是 Jeenith 项目的 AI 编码定制规则，基于 AI 编码规则体系生成。
> 身份信息（组织、包名、署名）以 `D:\Code\.Rules\OrganizationAndUser.md` 为单一事实来源。

---

## 规则体系引用

### 基础规则（自动生效）

本项目的编码规则基于 AI 编码规则体系：

- **规则入口**: `D:\Code\.Rules\main.md`
- **规则优先级**: 本文件(定制规则) > 预设配置 > 核心规则 > 默认行为
- **规则冲突时**: 以本文件中的定制规则为准
- **项目审计**: `D:\Code\.Rules\docs\audit\Jeenith\`（P0/P1 待办优先处理，进项目先查 open 条目）

### CRITICAL 禁令（绝对禁止）

> 以下禁令提取自核心规则，违反会导致严重问题

- NEVER 硬编码 API 密钥、密码、Token 等敏感信息 — 原因：泄露到版本控制导致安全事故
- NEVER 使用字符串拼接 SQL — 原因：SQL 注入攻击
- NEVER 跳过用户输入验证 — 原因：注入攻击和数据污染
- NEVER 在未读取文件内容的情况下修改文件 — 原因：破坏已有设计意图
- NEVER 将授权范围自行扩大 — 原因：一次授权不等于永久授权
- NEVER 编造不确定的信息 — 原因：编造的信息比不知道更危险
- NEVER 添加未被明确要求的功能 — 原因：增加维护成本且未经需求验证
- NEVER 在代码、注释、提交信息中使用 emoji — 原因：影响可读性和搜索

### 必须遵守

- 先说结论再说理由
- 先看再改，理解上下文后再修改
- 每次变更后运行 `flutter analyze` 与相关测试
- 出现问题先检索 `D:\Code\.Rules\ERROR\entries\`，参考但不盲从

---

## 项目信息

| 属性 | 值 |
|------|-----|
| 项目名称 | 志极 Jeenith |
| 项目定位 | 叩问本心的卜算合集（小六壬、周易及更多） |
| 项目类型 | mobile（全平台：Android / iOS / Web / 桌面） |
| 包名 / applicationId | `com.qore.jeenith` |
| 版本 | 1.0.0+1 |
| 版权 | Copyright (c) 2026 Qore. All rights reserved. |

---

## 技术栈（以 pubspec.yaml 实际依赖为准）

> **重要**：本项目的实际依赖与 `stacks/flutter/presets/flutter.yaml` 预设有差异。以下列实际依赖为准，NEVER 照搬预设引入项目未使用的库。

| 能力 | 实际选用 | 预设默认（勿引入） |
|------|----------|-------------------|
| 状态管理 | `flutter_riverpod ^2.5.0`（手动 Provider，**非** code-generation） | ~ riverpod 3.x / `@riverpod` 注解 |
| 路由 | `go_router ^14.0.0` | 一致 |
| 网络请求 | `http ^1.2.0` | ~ dio |
| 本地存储 | `shared_preferences ^2.2.0` | ~ drift / flutter_secure_storage |
| 数据模型 | 原生 Dart 类（`@immutable`） | ~ freezed |
| 历法计算 | `lunar ^1.7.8`（农历/干支/节气，时辰起卦与命理共用） | — |
| 加密 | `crypto ^3.0.0`（真随机 SHA256 混合） | — |
| Lint | `flutter_lints ^6.0.0` | — |

- Dart SDK: `^3.11.4`
- NEVER 引入上表"勿引入"列的库 — 原因：项目已选定轻量技术栈，混入未使用库增加体积与学习成本
- 添加新依赖前先确认是否真有必要，并在 pubspec.yaml 同步版本

---

## 架构约定

### 1. 卜算框架（核心扩展点）

本项目通过插件式注册表管理多种卜算法，`core/divination/` 是框架，`features/{术名}/` 是各术实现。

**抽象接口**：`DivinationTech`（见 `lib/core/divination/divination_tech.dart`）
- `id` — 唯一标识，用于路由 `/tech/:id`
- `meta` (`TechMeta`) — 展示元数据（名称、副标题、描述、主题色 `accentColor`、`sortOrder`、`enabled`）
- `usesTrueRandom` — 是否使用真随机引擎（默认 `false`）
- `buildPage(context, ref)` — 构建该术主页面

**注册表**：`divinationTechsProvider`（见 `lib/core/divination/divination_registry.dart`）

**新增一种卜算法的标准流程**（以紫微斗数为例）：

1. 新建 `lib/features/ziwei/` 目录，内部按分层组织：
   - `ziwei_tech.dart` — 实现 `DivinationTech`
   - `algorithm/` — 起卦算法与断辞
   - `data/` — 静态数据（宫位、卦象表等）
   - `state/` — Riverpod providers
   - `ui/` — 页面与组件
2. 在 `divinationTechsProvider` 的列表中追加一行 `ZiweiTech(),`
3. 完成。首页卡片、路由、详情页由框架自动驱动，NEVER 手动添加路由条目

### 2. 真随机系统（领域核心）

卜算的公信力建立在随机性的公正之上。`core/rng/` 是多源真随机引擎：

- 三种熵源：系统熵 + 触摸轨迹 + 在线大气噪声（random.org）
- 多源 SHA256 混合，链式扩展避免相关性（见 `true_random.dart`）
- 需要真随机的术，在 `DivinationTech` 中置 `usesTrueRandom = true`，通过 provider 获取 `TrueRandom` 服务
- `AppConfig.useOnline` 控制是否启用在线熵源（可被用户关闭，需网络）

### 3. 分层与依赖方向

```
app/      → 应用装配（theme / router / app），依赖 core 与 features
core/     → 框架层（divination / rng / calendar / config / constants / branding），NEVER 反向依赖 features
shared/   → 跨术共享 UI 组件（gold_button / dark_button / decorative_panel / section_title）
features/ → 各卜算法实现，依赖 core 与 shared，互不依赖
```

- 依赖方向单向：`features → core / shared`，`app → 全部`；NEVER 让 core 引用 features（注册表例外，它只持有抽象 `DivinationTech`）

---

## 项目特定禁令

> 每条禁令附原因 — 符合"禁令优于指令"原则

- NEVER 为新增卜算法修改 `core/` 或 `shared/` — 原因：破坏插件式架构，加术只需新建 `features/{name}/` + 注册表追加一行
- NEVER 为单个卜算法手写路由 — 原因：路由统一由 `/tech/:id` + `techByIdProvider` 驱动，手写会导致首页卡片与路由脱节
- NEVER 用 `Random`（伪随机）做卜算起卦 — 原因：卜算公信力依赖真随机，必须走 `core/rng/TrueRandom`
- NEVER 硬编码应用名/组织/版权/slogan — 原因：身份单一来源是 `Branding` 类（上游 `OrganizationAndUser.md`），硬编码会导致多处不一致
- NEVER 新建 `.dart` 文件时省略版权头 — 原因：项目统一 `// Copyright (c) 2026 Qore. All rights reserved.` 作为首行
- NEVER 让 `core/` 引用 `features/` — 原因：core 是框架层，反向依赖会形成循环并破坏可扩展性（注册表持有的是抽象接口，属例外）
- NEVER 在 `build` 方法内执行异步或副作用 — 原因：Flutter 构建须保持纯净，起卦等异步操作放事件回调或 provider

---

## 目录结构

```
Jeenith/
├── lib/
│   ├── main.dart                     # 入口：ProviderScope + JeenithApp
│   ├── app/                          # 应用装配
│   │   ├── app.dart
│   │   ├── theme.dart
│   │   └── router.dart               # GoRouter，/ 与 /tech/:id
│   ├── core/                         # 框架层（加术时不改）
│   │   ├── branding.dart             # 品牌常量（单一来源）
│   │   ├── config/                   # AppConfig + config_providers
│   │   ├── constants/                # app_colors.dart（暗金中式色板）
│   │   ├── calendar/                 # lunar_service.dart（农历/干支/节气）
│   │   ├── divination/               # 卜算框架：tech / registry / result
│   │   └── rng/                      # 真随机：entropy sources + true_random
│   ├── shared/widgets/               # 共享 UI 组件
│   └── features/                     # 卜算法实现（按术分目录）
│       ├── home/                     # 首页（自动列出 visibleTechs）
│       └── xiaoliuren/               # 小六壬：tech / algorithm / data / state / ui
├── android/ ios/ linux/ macos/ web/ windows/   # 各平台壳工程
├── test/                             # 测试
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 构建与常用命令

| 用途 | 命令 |
|------|------|
| 安装依赖 | `flutter pub get` |
| 运行（开发） | `flutter run` |
| 静态分析 | `flutter analyze` |
| 单元/Widget 测试 | `flutter test` |
| 构建 Release APK | `flutter build apk --release` |
| 构建 AAB | `flutter build appbundle --release` |

- 产物命名与版本规则遵循 `D:\Code\.Rules\stacks\flutter\presets\flutter.yaml` 的 `build.artifact` 段（格式 `{project}_{status}_{version}_{date}`）
- 提交前必跑 `flutter analyze`，有 error 必须修复

---

## 配置与环境

本项目无环境变量依赖。运行时配置通过 `shared_preferences` 持久化，结构见 `lib/core/config/app_config.dart`：

| 配置项 | 说明 | 默认 |
|--------|------|------|
| `showDetails` | 起卦后展示采样详情 | `true` |
| `useOnline` | 启用在线大气噪声熵源（random.org，需网络） | `true` |

- 在线熵源失败时自动降级为本地源，NEVER 因网络异常阻断起卦流程

---

## 关联资源

- 规则体系：`D:\Code\.Rules\main.md`
- Flutter 预设：`D:\Code\.Rules\stacks\flutter\presets\flutter.yaml`（技术栈以上文本实际为准）
- 国内镜像：`D:\Code\.Rules\stacks\flutter\flutter-china-mirrors.md`
- 提示词库：`D:\Code\.prompt`
- 错误资源库：`D:\Code\.Rules\ERROR\entries/`（出问题先检索）

---

*此规则基于 AI 编码规则体系定制*
*基础规则详见 D:\Code\.Rules\main.md*
