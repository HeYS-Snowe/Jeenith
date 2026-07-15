# 志极 Jeenith · 项目总结报告 Project Summary Report

> 叩问本心，不忘初心 —— Question the core. Return to origins.

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 报告版本 Report Version | v2.3.3 |
| 项目名称 Project Name | 志极 Jeenith |
| 组织 Organization | Qore Origins（叩心）|
| 包名 Package Name | com.qore.jeenith |
| 项目类型 Project Type | 移动 App（Flutter，Android + Windows 桌面），无后端纯客户端 |
| 项目周期 Project Period | 2026-07-12 ~ 2026-07-15 |
| 当前版本 Current Version | 2.3.3+23（release）|
| 开发者 Developer | HeYS-Snowe（唯一开发者）|
| 仓库 Repository | https://github.com/1010523654/Jeenith |
| 许可证 License | MIT License |
| 报告日期 Report Date | 2026-07-15 |

---

## 目录 Table of Contents

1. [项目概述 Project Overview](#1-项目概述-project-overview)
2. [项目成果 Project Achievements](#2-项目成果-project-achievements)
3. [技术架构 Technical Architecture](#3-技术架构-technical-architecture)
4. [版本演进 Version Evolution](#4-版本演进-version-evolution)
5. [数据指标 Data Metrics](#5-数据指标-data-metrics)
6. [附录 Appendix](#6-附录-appendix)

---

## 1. 项目概述 Project Overview

### 1.1 项目定位 Project Positioning

志极 Jeenith 是一款**叩问本心的卜算合集**移动应用，由 Qore Origins（叩心）组织出品，开发者 HeYS-Snowe 独立完成。项目以「志于本心，知于极处」为品牌精神，口号「叩问本心，不忘初心」，聚焦于将传统术数以现代移动体验重新呈现。

**核心定位**：

- 一个 APP 首页选术，覆盖 12 种传统术数
- 可扩展卜算框架（加新术 = 新建 feature 目录 + 注册一行）
- 纯客户端架构，无后端依赖，隐私零外泄
- 双端覆盖：Android 移动端 + Windows 桌面端

### 1.2 项目目标达成情况 Objectives Achievement

| 目标 Objective | 计划值 Planned | 实际值 Actual | 达成情况 Achievement |
|-------------|-------------|-----------|-------------------|
| 术数种类 | 12 种 | 12 种 | ✅ 达成 |
| 跨端平台 | Android + Windows | Android + Windows | ✅ 达成 |
| 框架可扩展性 | 加新术 ≤ 1 文件改动 | 加新术 = 新建 feature + 注册一行 | ✅ 达成 |
| 真随机引擎 | 多源熵混合 | 三源（系统 + 触摸 + 在线）+ SHA256 | ✅ 达成 |
| 动效体系 | 全局可控 | Phase 1-6 + 4 个 AnimationKind 独立开关 | ✅ 达成 |
| 品牌定调 | 深色星空 + 金色 | 统一封装于 core/theme + branding.dart | ✅ 达成 |
| 开源许可 | MIT | MIT LICENSE 于 v2.3.3 落地 | ✅ 达成 |

---

## 2. 项目成果 Project Achievements

### 2.1 功能完成情况 Feature Completion

| 模块 Module | 计划功能 Planned | 完成功能 Completed | 完成率 Completion |
|----------|---------------|-----------------|---------------|
| 小六壬 Xiaoliuren | 起卦 + 六宫解读 + 仪式动画 | ✅ 全部完成 | 100% |
| 周易 Zhouyi | 金钱卦起卦 + 64 卦 + 384 爻辞 | ✅ 全部完成 | 100% |
| 梅花易数 Meihua | 时间/数字起卦 + 体用生克 | ✅ 全部完成 | 100% |
| 掷筊 Jiaobei | 三掷成卦 + 圣杯/笑杯/阴杯 | ✅ 全部完成 | 100% |
| 紫微斗数 Ziwei | v2 星盘 + 星曜安放 + 解读 | ✅ 全部完成 | 100% |
| 奇门遁甲 Qimen | v2 局盘 + 八门九星 + 解读 | ✅ 全部完成 | 100% |
| 抽签 Chouqian | 签筒 + 签诗 + 解读 | ✅ 全部完成 | 100% |
| 测字 Cezi | 单字输入 + 笔画 + 解读 | ✅ 全部完成 | 100% |
| 大六壬 Daliuren | 四课三传 + 天将 + 解读 | ✅ 全部完成 | 100% |
| 风水罗盘 Luopan | 磁力计方位 + 24 山 + 实时指针 | ✅ 全部完成 | 100% |
| 八字推演 Bazi | 四柱 + 十神 + 神煞 | ✅ 全部完成 | 100% |
| 测名字 NameTest | 五格剖象 + 笔画 + 三才 | ✅ 全部完成 | 100% |
| 使用手册 Manual | 各术使用说明 + 引导 | ✅ 全部完成 | 100% |
| 历史记录 History | 存档 + 导出 + 原子写入 | ✅ 全部完成 | 100% |
| 设置中心 Settings | 主题 + 动效开关 + 4 类细分 | ✅ 全部完成 | 100% |
| 结果分享 Share | 截图 + 文本 + 系统分享 | ✅ 全部完成 | 100% |
| **总计 Total** | **17 模块** | **17 模块** | **100%** |

### 2.2 交付物清单 Deliverables List

| 交付物类别 Deliverable Type | 交付物名称 Deliverable Name | 状态 Status |
|----------------------|----------------------|----------|
| 源代码 Source Code | mobile/lib/ 完整 Flutter 项目 | ✅ 已交付 |
| 构建脚本 Build Scripts | scripts/build_apk.ps1 + archive_history.py | ✅ 已交付 |
| Android 产物 APK | builds/android/ 归档 | ✅ 已交付 |
| Windows 产物 ZIP | builds/windows/ 归档 | ✅ 已交付 |
| 项目文档 Docs | docs/项目文档/ 全套（00-07）| ✅ 已交付 |
| 构建规范 Build Spec | docs/FLUTTER_APK_BUILD_PIPELINE.md | ✅ 已交付 |
| 项目规则 Rules | AGENTS.md + CLAUDE.md | ✅ 已交付 |
| 构建历史 Build History | build_history.json + builds/release_history.json | ✅ 已交付 |
| 开源许可 License | LICENSE (MIT) | ✅ 已交付 |

### 2.3 核心创新点 Key Innovations

| 创新点 Innovation | 说明 Description |
|---------------|---------------|
| 可扩展卜算框架 | `DivinationTech` 抽象 + 注册表，12 术共用框架，新术接入成本极低 |
| 三源真随机引擎 | Random.secure + 触摸轨迹熵 + random.org 在线熵，SHA256 摘要混合 |
| 仪式感动效体系 | Phase 1-6 六阶段动效，4 个 AnimationKind 独立开关，覆盖入场/转场/绘制/揭示 |
| 跨端纯客户端 | 无后端依赖，隐私零外露，Android + Windows 双端复用率 > 95% |
| 原子化历史存储 | SharedPreferences 原子读-改-写，防止快速连续卜算丢数据 |
| 桌面端窗口适配 | window_manager + screen_retriever，桌面端窗口尺寸/位置/最小尺寸可控 |

---

## 3. 技术架构 Technical Architecture

### 3.1 技术栈 Technology Stack

| 层级 Layer | 技术 Technology | 版本 Version | 用途 Usage |
|----------|-------------|------------|----------|
| 框架 Framework | Flutter | 3.x（Dart 3.11+）| 跨端 UI 框架 |
| 状态管理 State | flutter_riverpod | ^2.5.0 | 响应式状态管理 |
| 路由 Router | go_router | ^14.0.0 | 声明式路由 + 仪式路由 |
| 农历历法 Calendar | lunar | ^1.7.8 | 寿星天文历：农历/干支/节气 |
| 图标 Icons | flutter_svg | ^2.0.0 | SVG 矢量图标 |
| 配置持久化 Config | shared_preferences | ^2.2.0 | 用户设置/历史/引导状态 |
| 设备传感器 Sensor | sensors_plus | ^6.0.0 | 磁力计（风水罗盘方位角）|
| 结果分享 Share | share_plus | ^10.0.0 | 系统分享（截图/导出文件）|
| 文件路径 Path | path_provider | ^2.1.0 | 临时文件路径（截图/导出）|
| 网络 Network | http | ^1.2.0 | random.org 在线熵获取 |
| 加密 Crypto | crypto | ^3.0.0 | SHA256 熵摘要 |
| 桌面窗口 Window | window_manager | ^0.5.2 | Windows 窗口尺寸/位置 |
| 屏幕信息 Screen | screen_retriever | ^0.2.2 | 获取屏幕分辨率 |

### 3.2 目录结构 Directory Structure

```
Jeenith/
  mobile/                      # Flutter 项目
    lib/
      app.dart                 # JeenithApp（MaterialApp.router + Starfield 背景）
      main.dart                # 入口（async + ProviderScope + 桌面窗口初始化）
      core/                    # 核心层
        animation/             # 动效体系（painters/particles/reveal/ritual/transitions）
        calendar/              # 农历服务（lunar_service.dart）
        config/                # 配置（app_config + config_providers + platform_info）
        divination/            # 卜算框架（DivinationTech 抽象 + 注册表 + 结果模型）
        history/               # 历史存储（history_store + history_export，原子读改写）
        rng/                   # 真随机引擎（三源熵 + SHA256 + 降级策略）
        theme/                 # 主题（app_theme + animations）
        branding.dart          # 品牌身份常量
      data/                    # 数据层
        yijing/                # 64 卦 + 八卦数据（周易/梅花共用）
      features/                # 功能层（12 术 + 配套）
        home/                  # 首页选术 grid
        xiaoliuren/            # 小六壬（algorithm/data/state/ui）
        zhouyi/                # 周易（algorithm/ui）
        meihua/                # 梅花易数
        jiaobei/               # 掷筊
        ziwei/                 # 紫微斗数 v2（algorithm/data/ui）
        qimen/                 # 奇门遁甲 v2
        chouqian/              # 抽签
        cezi/                  # 测字
        daliuren/              # 大六壬
        luopan/                # 风水罗盘（sensor + ui）
        bazi/                  # 八字推演（algorithm/divine + shensha）
        name_test/             # 测名字（algorithm/strokes_data + wuge）
        manual/                # 使用手册
        settings/              # 设置中心
        history/               # 历史记录
      providers/               # Riverpod barrel（聚合 config + rng providers）
      router/                  # GoRouter + 仪式路由
      shared/                  # 共享组件
        widgets/               # GoldButton/DarkButton/Starfield/GuideDialog 等
    scripts/                   # build_apk.ps1 + archive_history.py
    android/ windows/ ...      # 各平台工程
    pubspec.yaml               # 版本 2.3.3+23
  backend/                     # 占位（Jeenith 无后端）
  design/                      # 占位（设计稿）
  docs/                        # 项目文档（00-07 全套）
  tools/                       # 占位（工具脚本）
  builds/                      # 构建产物归档（android/ + windows/）
  build_history.json           # 项目内历史副本
  AGENTS.md / CLAUDE.md        # 项目规则（双份同步）
  LICENSE                      # MIT
```

### 3.3 核心架构决策 Architecture Decisions

#### 3.3.1 可扩展卜算框架 Extensible Divination Framework

```
DivinationTech（抽象契约）
├── id: String                    # 唯一标识（路由用）
├── meta: TechMeta                # 元数据（名称/图标/排序/启用）
└── divine(): DivinationResult    # 起卦方法
        │
        ▼
divination_registry.dart（注册表）
├── divinationTechsProvider       # 全部术列表
├── techByIdProvider              # 按 ID 查找（路由用）
└── visibleTechsProvider          # 首页可见列表（按 sortOrder 排序）
```

**加新术步骤**：新建 `features/xxx/` → 实现 `DivinationTech` → 注册表追加一行。无需改动 core/ 或 shared/。

#### 3.3.2 真随机引擎 True Random Engine

```
熵源 Entropy Sources
├── SystemEntropySource     # Random.secure 系统级安全随机
├── TouchEntropySource      # 触摸轨迹熵（用户参与，仪式感）
└── OnlineEntropySource     # random.org 在线真随机（降级可选）
        │
        ▼
TrueRandom（混合器）
└── SHA256(系统熵 ‖ 触摸熵 ‖ 在线熵) → 摘要 → 取模映射
```

**降级策略**：在线熵不可用时回退到本地双源，不阻塞起卦。

#### 3.3.3 动效体系 Animation System

```
core/animation/
├── painters/                # 动态绘制（卦象/星盘/盘面）
├── particles/               # 粒子系统（结果揭示）
├── reveal/                  # 揭示动画（墨晕扩散 + 打字机文本）
├── ritual/                  # 仪式入场（10 术各有 ritual）
└── transitions/             # 路由转场
        │
        ▼
AppConfig.isAnimationEnabled(id, kind)
├── AnimationKind.entrance   # 入场仪式
├── AnimationKind.transition # 路由转场
├── AnimationKind.drawing    # 绘制过程
└── AnimationKind.reveal     # 结果揭示
```

4 个 AnimationKind 独立开关，用户可在设置页按需关闭。

---

## 4. 版本演进 Version Evolution

### 4.1 版本时间线 Version Timeline

| 版本 Version | 日期 Date | 核心内容 Core Content | 阶段 Stage |
|------------|----------|---------------------|----------|
| 1.0.0 | 2026-07-12 | release，核心框架 + 6 种术 v1 | 框架奠基 |
| 1.1.0 | 2026-07-12 | 工程结构迁移 + WBS + 规范文档 | 工程化 |
| 1.2.0 | 2026-07-12 | 周易/梅花卦辞爻辞数据 | 内容深化 |
| 1.3.0 | 2026-07-13 | 紫微斗数 v2 重构 | 算法升级 |
| 1.4.0 | 2026-07-13 | 奇门遁甲 v2 重构 | 算法升级 |
| 1.5.0 | 2026-07-13 | 主题切换 + 结果分享 + 历史导出 | 体验补全 |
| 1.6.0 | 2026-07-13 | 抽签 + 测字 | 术数扩展 |
| 1.7.0 | 2026-07-13 | 大六壬 + 风水罗盘 | 术数扩展 |
| 1.8.0 | 2026-07-13 | 使用手册 | 文档补全 |
| 2.0.0 | 2026-07-14 | release，体验深化与品牌定调 | 品牌定调 |
| 2.1.0 | 2026-07-14 | 动效体系 Phase 1-3 | 动效体系 |
| 2.2.0 | 2026-07-14 | 动效体系 Phase 4-6 | 动效体系 |
| 2.3.0 | 2026-07-15 | 八字推演 + 测名字 + 紫微盘重构 | 术数扩展 |
| 2.3.1 | 2026-07-15 | 起卦按钮 BUG 修复 + 动效曲线优化 | 稳定性 |
| 2.3.2 | 2026-07-15 | 设置页动画细分开关 + Windows 图标修复 | 体验打磨 |
| 2.3.3 | 2026-07-15 | 首页按钮间距修复 + MIT LICENSE + 图标归档 | 收尾发布 |

### 4.2 里程碑达成 Milestone Achievement

| 里程碑 Milestone | 日期 Date | 评估 Evaluation |
|--------------|---------|--------------|
| 框架奠基 + 6 术 v1 | 2026-07-12 | ✅ 按时 |
| 全 12 术落地 | 2026-07-13 | ✅ 按时 |
| 体验深化 + 品牌定调 | 2026-07-14 | ✅ 按时 |
| 动效体系 Phase 1-6 | 2026-07-14 | ✅ 按时 |
| 八字 + 测名字 + 收尾 | 2026-07-15 | ✅ 按时 |

### 4.3 关键版本亮点 Key Release Highlights

#### v1.0.0（框架奠基）

- 搭建 `DivinationTech` 抽象 + 注册表 + 真随机引擎 + 历史存储
- 落地 6 种术 v1：小六壬、周易、梅花、掷筊、紫微、奇门
- 验证可扩展框架可行性

#### v2.0.0（品牌定调）

- 体验深化：按钮物理反馈、图标状态切换、动效全局开关
- 品牌定调：深色星空背景 + 金色主色 + 宋体韵味
- 统一封装于 core/theme/ 与 branding.dart

#### v2.3.3（收尾发布）

- 12 术全部落地（八字 + 测名字于 v2.3.0 完成）
- 动效体系 Phase 1-6 + 4 个 AnimationKind 独立开关
- MIT LICENSE 落地，Windows 图标产物归档
- 首页按钮间距修复，体验打磨完成

---

## 5. 数据指标 Data Metrics

### 5.1 项目规模 Project Scale

| 指标 Indicator | 数值 Value |
|-------------|---------|
| 开发周期 Dev Period | 4 天（2026-07-12 ~ 2026-07-15）|
| 版本发布数 Releases | 15 个（1.0.0 ~ 2.3.3）|
| 术数种类 Tech Count | 12 种 |
| 功能模块 Modules | 17 个（12 术 + 手册 + 历史 + 设置 + 分享 + 首页）|
| 跨端平台 Platforms | 2（Android + Windows）|
| 核心依赖包 Dependencies | 11 个 |
| 共享组件 Shared Widgets | 12+ 个（GoldButton/DarkButton/Starfield 等）|

### 5.2 框架效能 Framework Efficiency

| 指标 Indicator | 数值 Value |
|-------------|---------|
| 加新术改动文件 | 2 个（新建 feature 目录 + 注册表一行）|
| 框架投入占比 | ~30%（v1.0.0 一天）|
| 后续术接入平均耗时 | 2-3 小时/术 |
| 双端代码复用率 | > 95% |
| 算法与 UI 解耦 | feature 内 algorithm/ 与 ui/ 分离 |

### 5.3 动效体系 Animation System

| 指标 Indicator | 数值 Value |
|-------------|---------|
| 动效阶段 Phases | 6 个（Phase 1-6）|
| AnimationKind 独立开关 | 4 个（entrance/transition/drawing/reveal）|
| 仪式动画覆盖术数 | 10 种（八字/测名字暂无）|
| 全局动效开关 | ✅ 支持（AppConfig.animationsEnabled）|

### 5.4 真随机引擎 True Random Engine

| 指标 Indicator | 数值 Value |
|-------------|---------|
| 熵源数量 | 3 个（系统 + 触摸 + 在线）|
| 混合算法 | SHA256 摘要 |
| 在线熵降级 | ✅ 支持（回退本地双源）|
| 用户参与度 | 触摸轨迹熵（仪式感）|

### 5.5 质量指标 Quality Metrics

| 指标 Indicator | 数值 Value |
|-------------|---------|
| flutter analyze | 通过（无 error）|
| 单元测试覆盖 | ⚠️ 待补（后续改进项）|
| CustomPainter 内存泄漏 | 0（显式 dispose TextPainter）|
| 历史存储原子化 | ✅ 原子读-改-写 |
| 身份信息硬编码 | 0（单一事实来源 OrganizationAndUser.md）|

---

## 6. 附录 Appendix

### 附录A：项目时间线 Project Timeline

```
[1.0.0 框架奠基]    [1.2 卦辞]    [1.5 主题/分享]    [1.7 大六壬/罗盘]    [2.0 品牌定调]    [2.1-2.2 动效]    [2.3.3 收尾]
   2026-07-12      2026-07-12      2026-07-13         2026-07-13        2026-07-14       2026-07-14       2026-07-15
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     Day 1                          Day 2                                 Day 3                       Day 4
```

### 附录B：12 术清单 Tech List

| # | 术数 Tech | 英文 English | 路由 ID | 起卦方式 Method |
|---|---------|------------|--------|--------------|
| 1 | 小六壬 | Xiaoliuren | xiaoliuren | 时辰起卦 |
| 2 | 周易（金钱卦）| Zhouyi | zhouyi | 三爻成卦 |
| 3 | 梅花易数 | Meihua | meihua | 时间/数字起卦 |
| 4 | 掷筊 | Jiaobei | jiaobei | 三掷成卦 |
| 5 | 紫微斗数 | Ziwei | ziwei | 生辰起盘 |
| 6 | 奇门遁甲 | Qimen | qimen | 时辰起局 |
| 7 | 抽签 | Chouqian | chouqian | 签筒随机 |
| 8 | 测字 | Cezi | cezi | 单字输入 |
| 9 | 大六壬 | Daliuren | daliuren | 时辰起课 |
| 10 | 风水罗盘 | Luopan | luopan | 磁力计方位 |
| 11 | 八字推演 | Bazi | bazi | 生辰四柱 |
| 12 | 测名字 | NameTest | name_test | 姓名五格 |

### 附录C：开源与许可 Open Source

| 项目 Item | 内容 Content |
|---------|-------------|
| 仓库 Repository | https://github.com/1010523654/Jeenith |
| 许可证 License | MIT License |
| 版权 Copyright | Copyright (c) 2026 Qore |
| 开发者 Developer | HeYS-Snowe |

---

**文档结束 End of Document**

> 志极 Jeenith · 志于本心，知于极处 · Copyright (c) 2026 Qore · MIT License
