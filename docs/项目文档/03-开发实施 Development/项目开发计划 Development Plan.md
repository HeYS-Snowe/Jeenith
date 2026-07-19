# 项目开发计划 Project Development Plan

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project Name | 志极 Jeenith |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 开发者 Developer | HeYS-Snowe |
| 当前版本 Current Version | 2.3.3+23 |
| 项目仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-15 | HeYS-Snowe | 初始版本，回顾 v1.0.0 → v2.3.3 迭代历程并规划后续 |

---

## 目录 Table of Contents

1. [项目概述 Project Overview](#1-项目概述-project-overview)
2. [迭代计划 Iteration Plan](#2-迭代计划-iteration-plan)
3. [里程碑 Milestones](#3-里程碑-milestones)
4. [资源计划 Resource Plan](#4-资源计划-resource-plan)
5. [风险管理 Risk Management](#5-风险管理-risk-management)
6. [后续规划 Future Planning](#6-后续规划-future-planning)

---

## 1. 项目概述 Project Overview

### 1.1 项目基本信息 Project Basic Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 中文名称 Chinese Name | 志极 |
| 英文名称 English Name | Jeenith |
| 组织 Organization | Qore（叩心） |
| 应用包名 Package Name | com.qore.jeenith |
| 项目类型 Project Type | Flutter 移动 App（Android + Windows 桌面），无后端纯客户端 |
| 技术栈 Tech Stack | Flutter 3.x（Dart 3.11+）、Riverpod、go_router、lunar、flutter_svg、sensors_plus |
| 开发周期 Development Period | 2026-07-11 ~ 至今 |
| 开发者 Developer | HeYS-Snowe（唯一开发者） |
| 许可证 License | MIT |

### 1.2 产品定位 Product Positioning

志极是一款叩问本心的卜算合集——收录 12 种传统术数（小六壬、周易、梅花易数、掷筊、紫微斗数、奇门遁甲、抽签、测字、大六壬、风水罗盘、八字推演、测名字），配以使用手册与可扩展框架。一个 APP 首页选术，加新术仅需新建 feature 目录 + 注册一行。

**品牌精神**：志于本心，知于极处。

### 1.3 开发目标 Development Goals

| 目标类型 Goal Type | 目标描述 Goal Description | 达成状态 Status |
|----------------|---------------------|--------|
| 功能目标 Functional | 12 种术数全部实现 + 可扩展框架 | ✓ 已达成 |
| 质量目标 Quality | flutter analyze 0 issue + TextPainter 全 dispose | ✓ 已达成 |
| 体验目标 Experience | 仪式动画 + 路由转场 + 物理反馈 | ✓ 已达成 |
| 开源目标 Open Source | MIT LICENSE + README + 产物归档 | ✓ 已达成 |

---

## 2. 迭代计划 Iteration Plan

### 2.1 已完成迭代 Completed Iterations

#### 阶段一：框架奠基与首版（v1.0.0 ~ v1.1.x）

| 版本 Version | 日期 Date | 主题 Theme | 核心交付 Key Deliverables |
|-------------|---------|----------|--------------------------|
| v1.0.0 | 2026-07-11 | 首版发布 | DivinationTech 框架 + TrueRandom 引擎 + 6 术（小六壬/周易/梅花/紫微/奇门/掷筊）+ 首页 + 手册 |
| v1.1.0 | 2026-07-12 | 工程迁移 | Flutter 工程迁移至 mobile/ 子目录 + Windows 桌面支持 |

#### 阶段二：内容深化与全术集齐（v1.2.0 ~ v1.7.0）

| 版本 Version | 日期 Date | 主题 Theme | 核心交付 Key Deliverables |
|-------------|---------|----------|--------------------------|
| v1.2.0 | 2026-07-13 | 卦辞爻辞 | 64 卦 386 爻 JSON 数据 + 周易/梅花结果页展示 |
| v1.3.0 | 2026-07-13 | 紫微 v2 | 14 主星 + 六吉六煞 + 博士十二神 + 环形命盘 |
| v1.4.0 | 2026-07-13 | 奇门 v2 | 四盘九宫（天地人神）+ 值符值使 + 洛书布局 |
| v1.5.0 | 2026-07-13 | 体验完善 | 主题切换 + 结果截图分享 + 历史导出（JSON/MD/CSV） |
| v1.6.0 | 2026-07-13 | 扩展性 | 抽签求签 + 测字（验证框架可扩展性） |
| v1.7.0 | 2026-07-13 | 终章 | 大六壬四课三传 + 风水罗盘磁力计接入 |

#### 阶段三：品牌定调与动效体系（v2.0.0 ~ v2.2.0）

| 版本 Version | 日期 Date | 主题 Theme | 核心交付 Key Deliverables |
|-------------|---------|----------|--------------------------|
| v2.0.0 | 2026-07-14 | 品牌定调 | 按钮物理反馈 + 图标状态切换 + 全局动效开关 |
| v2.1.0 | 2026-07-14 | 动效 Phase 1 | 仪式动画基类 + 5 套仪式（周易/紫微/奇门/大六壬/罗盘） |
| v2.2.0 | 2026-07-14 | 动效 Phase 2 | 4 套仪式补全（梅花/掷筊/抽签/测字）+ 路由转场差异化 + 加载指示器 |

#### 阶段四：功能扩展与开源就绪（v2.3.0 ~ v2.3.3）

| 版本 Version | 日期 Date | 主题 Theme | 核心交付 Key Deliverables |
|-------------|---------|----------|--------------------------|
| v2.3.0 | 2026-07-14 | 功能扩展 | 八字推演 + 测名字 + 紫微命盘重构 + 动画 Map 化 |
| v2.3.1 | 2026-07-15 | BUG 修复 | 起卦按钮修复 + 动效曲线优化 |
| v2.3.2 | 2026-07-15 | 动画细分 | 4 类 AnimationKind 独立开关 + Windows 图标修复 |
| v2.3.3 | 2026-07-15 | 开源就绪 | 首页间距修复 + MIT LICENSE + Windows 图标归档 |

### 2.2 迭代节奏 Iteration Rhythm

志极采用**快速密集迭代**模式，由唯一开发者 HeYS-Snowe 推进：

- **版本号规则**：`主版本.次版本.修订号+构建号`（如 2.3.3+23）
- **发布节奏**：每个版本完成即构建归档，不设固定冲刺周期
- **构建命令**：`pwsh -File scripts/build_apk.ps1 -Status release -TargetVersion "x.y.z"`（cwd=mobile）
- **质量门禁**：每次构建前 `flutter analyze` 必须为 0 issue
- **归档规范**：APK + Windows ZIP + release_notes + build_history.json + release_history.json

---

## 3. 里程碑 Milestones

| 里程碑 Milestone | 版本 Version | 日期 Date | 验收标准 Acceptance Criteria |
|----------------|-------------|---------|---------------------------|
| M1 首版发布 Initial Release | v1.0.0 | 2026-07-11 | 6 术可用 + 框架成型 + TrueRandom 引擎 |
| M2 内容深化 Content Depth | v1.2.0 | 2026-07-13 | 64 卦 386 爻数据资产落地 |
| M3 全术集齐 All Techs Complete | v1.7.0 | 2026-07-13 | 10 术全部实现 + 框架可扩展性验证 |
| M4 体验完善 Experience Polish | v1.5.0 | 2026-07-13 | 主题/分享/导出三大完善性功能 |
| M5 品牌定调 Brand Defining | v2.0.0 | 2026-07-14 | 按钮物理反馈 + 全局动效开关体系 |
| M6 仪式化 Ritualization | v2.2.0 | 2026-07-14 | 10 套仪式动画 + 路由转场差异化 |
| M7 功能扩展 Feature Expansion | v2.3.0 | 2026-07-14 | 12 术集齐（+ 八字 + 测名字） |
| M8 开源就绪 Open Source Ready | v2.3.3 | 2026-07-15 | MIT LICENSE + Windows 图标 + 0 issue |

---

## 4. 资源计划 Resource Plan

### 4.1 人力资源 Human Resources

| 角色 Role | 人员 Person | 职责 Responsibility |
|----------|----------|-------------------|
| 开发者 Developer | HeYS-Snowe | 全栈开发（架构/算法/UI/动效/构建/文档） |

> 志极为个人开源项目，由 HeYS-Snowe 独立完成全部开发工作。

### 4.2 技术资源 Technical Resources

| 资源 Resource | 说明 Description |
|-------------|---------------|
| 开发环境 Development Env | Windows + Flutter 3.x（Dart 3.11+） |
| 代码托管 Code Hosting | GitHub（main 分支）：https://github.com/HeYS-Snowe/Jeenith |
| 农历历法 Calendar | lunar ^1.7.8（寿星天文历） |
| 真随机 True Random | Random.secure + 触摸轨迹 + random.org |
| 配置存储 Config Storage | shared_preferences ^2.2 |
| 设备传感器 Sensors | sensors_plus ^6.0.0（磁力计，风水罗盘） |

### 4.3 依赖清单 Dependencies

| 依赖 Dependency | 版本 Version | 用途 Purpose |
|----------------|------------|------------|
| flutter_riverpod | ^2.5 | 状态管理 |
| go_router | ^14.0 | 路由管理 |
| lunar | ^1.7.8 | 农历/八字/节气 |
| flutter_svg | ^2.0 | SVG 图标 |
| shared_preferences | ^2.2 | 配置持久化 |
| sensors_plus | ^6.0.0 | 陀螺仪/磁场 |
| share_plus | ^10.0.0 | 结果分享 |
| path_provider | ^2.1.0 | 历史导出文件路径 |
| crypto | — | SHA256 熵混合 |
| http | — | random.org 在线熵源 |
| flutter_launcher_icons | ^0.14 | APP 图标生成 |

---

## 5. 风险管理 Risk Management

### 5.1 已应对风险 Resolved Risks

| 风险 Risk | 影响 Impact | 应对措施 Mitigation | 状态 Status |
|----------|-----------|-------------------|-----------|
| 触摸轨迹熵源竞态 | 随机数质量 | TouchTracker 采样隔离 | ✓ 已解决 |
| 历史记录并发覆盖 | 数据丢失 | HistoryStore 串行化原子读-改-写 | ✓ 已解决 |
| TextPainter native handle 泄漏 | 内存泄漏 | 全项目 10 处显式 dispose | ✓ 已解决 |
| Windows exe 图标未应用 | 品牌不一致 | flutter clean + 重构建 .ico 资源 | ✓ 已解决 |
| 动画开关粒度不足 | 用户可控性差 | v2.3.2 拆分为 4 类 AnimationKind | ✓ 已解决 |
| RepaintBoundary 顶出起卦按钮 | 功能不可用 | v2.3.0 修复布局 | ✓ 已解决 |

### 5.2 持续关注风险 Ongoing Risks

| 风险 Risk | 影响 Impact | 监控措施 Monitoring |
|----------|-----------|-------------------|
| random.org 服务不可用 | 在线熵源降级 | 自动降级为系统熵 + 触摸熵（2 源） |
| 磁力计精度受设备影响 | 罗盘方位偏差 | UI 提示用户保持设备水平 |
| sensors_plus 7.x 需 AGP 8.12+ | 升级阻塞 | 当前锁定 ^6.0.0 |
| 思源宋体字体缺失 | 浅色主题字体不理想 | 后续可补充打包 |

---

## 6. 后续规划 Future Planning

### 6.1 短期规划 Short-term

| 任务 Task | 优先级 Priority | 说明 Description |
|----------|---------------|---------------|
| 思源宋体字体打包 | 中 | 浅色主题字体优化 |
| 首次使用引导遮罩 | 中 | 新用户引导 |
| 主题浅色对齐细节 | 低 | 浅色主题色系统一 |

### 6.2 中期规划 Mid-term

| 任务 Task | 优先级 Priority | 说明 Description |
|----------|---------------|---------------|
| 紫微 v2 深化 | 中 | 四化星 + 大限流年 |
| 奇门 v2 深化 | 中 | 更多格局判断 |
| 大六壬深化 | 中 | 完整九宗门 + 天将加临详断 |

### 6.3 长期方向 Long-term Direction

- 加新术仅需新建 features/xxx/ + 实现 DivinationTech + registry 注册一行，框架已就绪
- 桌面端（Windows）体验持续优化
- 历史记录云同步（若引入后端）

---

**文档结束 End of Document**

志极 Jeenith · 志于本心，知于极处
