# 功能规格说明书 Functional Specification

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 文档版本 Document Version | v2.3.3 |
| 创建日期 Created Date | 2026-07-05 |
| 最后修改 Last Modified | 2026-07-15 |
| 作者 Author | HeYS-Snowe |
| 审核人 Reviewer | Qore Origins |
| 产品名称 Product Name | 志极（Jeenith） |
| 当前版本 Current Version | 2.3.3+23（release，2026-07-15）|

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | 2026-07-05 | HeYS-Snowe | 功能规格初稿 Initial spec |
| v2.3.3 | 2026-07-15 | HeYS-Snowe | 同步 12 术 + 真随机 + 历史规格，定稿 |

---

## 目录 Table of Contents

1. [概述 Overview](#1-概述-overview)
2. [首页功能规格 Home Specification](#2-首页功能规格-home-specification)
3. [12 术功能规格 Divination Specifications](#3-12-术功能规格-divination-specifications)
4. [真随机引擎规格 RNG Specification](#4-真随机引擎规格-rng-specification)
5. [历史记录规格 History Specification](#5-历史记录规格-history-specification)
6. [设置规格 Settings Specification](#6-设置规格-settings-specification)
7. [使用手册规格 Manual Specification](#7-使用手册规格-manual-specification)
8. [结果分享规格 Share Specification](#8-结果分享规格-share-specification)
9. [动效体系规格 Motion Specification](#9-动效体系规格-motion-specification)
10. [跨端规格 Cross-Platform Specification](#10-跨端规格-cross-platform-specification)

---

## 1. 概述 Overview

### 1.1 文档目的 Document Purpose

本说明书详细定义"志极（Jeenith）"产品各功能的输入、计算、输出规格，作为开发实现与验收的依据。

### 1.2 产品基本信息 Product Information

| 项目 Item | 信息 Information |
|---------|---------------|
| **产品名称** | 志极（Jeenith） |
| **组织** | Qore Origins（叩心） |
| **包名** | `com.qore.jeenith` |
| **类型** | 移动 App（Flutter，Android + Windows 桌面） |
| **当前版本** | 2.3.3+23（release，2026-07-15） |
| **品牌精神** | 志于本心，知于极处 —— Question the core. Return to origins. |

### 1.3 功能架构 Function Architecture

```
志极 Jeenith
├── 首页 Home（选术 grid）
├── 卜算术 Divination（12 种）
│   ├── 小六壬 Xiaoliuren
│   ├── 周易 Zhouyi（金钱卦）
│   ├── 梅花易数 Meihua
│   ├── 掷筊 Jiaobei
│   ├── 紫微斗数 Ziwei
│   ├── 奇门遁甲 Qimen
│   ├── 抽签 Chouqian
│   ├── 测字 Cezi
│   ├── 大六壬 Daliuren
│   ├── 风水罗盘 Luopan
│   ├── 八字推演 Bazi
│   └── 测名字 NameTest
├── 使用手册 Manual
├── 设置 Settings
├── 历史 History
├── 真随机引擎 RNG（core/rng/）
└── 动效体系 Motion（core/theme/animations.dart）
```

---

## 2. 首页功能规格 Home Specification

### 2.1 功能描述 Description

首页以 Starfield 星点背景 + 12 术 grid 入口呈现，用户点击进入对应术数。

### 2.2 输入 Input

- 用户点击某术数入口卡片

### 2.3 计算 Compute

- go_router 路由跳转
- 仪式路由守卫（如需要）

### 2.4 输出 Output

- 跳转至对应术数的操作页/输入页/罗盘页

### 2.5 规格 Specification

| 项 Item | 规格 Spec |
|-------|---------|
| 背景 | Starfield 全局星点背景动画 |
| 布局 | 12 术 grid（响应式） |
| 卡片 | InteractableCard + SvgIcon + 术数名 |
| 入场动效 | Phase 1（卡片入场） |
| 路由 | go_router + 自定义转场（Phase 2） |
| 动效开关 | 受 AppConfig.animationsEnabled 控制 |

### 2.6 验收 Acceptance

- 12 术入口均可点击进入
- Starfield 背景正常
- 动效开关生效

---

## 3. 12 术功能规格 Divination Specifications

### 3.1 小六壬 Xiaoliuren

#### 3.1.1 功能描述
掐指神课，三段游走六宫断吉凶。

#### 3.1.2 输入 Input
- 三段数字（如月份/日期/时辰）
- 通过触摸轨迹采样真随机（可选）

#### 3.1.3 计算 Compute
- 大安 → 留连 → 速喜 → 赤口 → 小吉 → 空亡六宫游走
- 三段数字依次游走，落宫断吉凶

#### 3.1.4 输出 Output
- 六宫结果（落宫名 + 位置）
- 吉凶判词
- 宫位解读

#### 3.1.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 六宫顺序 | 大安 → 留连 → 速喜 → 赤口 → 小吉 → 空亡 |
| 游走规则 | 三段数字依次游走，第三段落宫为结果 |
| 真随机 | 支持触摸轨迹采样 |
| 动效 | Phase 3 掐指绘制 + Phase 4 结果揭示 |
| 历史 | 自动写入 |
| 分享 | 支持 share_plus |

#### 3.1.6 验收
- 算法对照传统小六壬规则正确
- 仪式感动效完整
- 结果可分享/复制

### 3.2 周易 Zhouyi（金钱卦）

#### 3.2.1 功能描述
金钱卦，三铜钱摇六爻。

#### 3.2.2 输入 Input
- 用户摇卦动作（触摸交互 + 真随机）

#### 3.2.3 计算 Compute
- 6 爻阴阳（三铜钱正反组合）
- 本卦 / 变卦 / 互卦
- 64 卦索引

#### 3.2.4 输出 Output
- 卦象（本卦 + 变卦 + 互卦）
- 卦辞 / 爻辞
- 吉凶判词

#### 3.2.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 摇卦 | 三铜钱 × 6 次 |
| 爻阴阳 | 三正为老阳（变） / 三反为老阴（变） / 二正一反为少阴 / 二反一正为少阳 |
| 卦数据 | 64 卦完整（data/yijing/） |
| 卦辞爻辞 | 完整 |
| 动效 | Phase 3 摇卦动画 + 6 爻绘制 + Phase 4 卦象揭示 |
| 真随机 | 每爻独立真随机 |
| 历史 | 自动写入 |
| 分享 | 支持 |

#### 3.2.6 验收
- 64 卦数据完整
- 卦辞爻辞正确
- 金钱摇卦动效完整
- 真随机每爻独立

### 3.3 梅花易数 Meihua

#### 3.3.1 功能描述
数字起卦，分体用、观生克。

#### 3.3.2 输入 Input
- 数字（时间起卦 / 方位起卦 / 随机起卦等）

#### 3.3.3 计算 Compute
- 上卦 + 下卦 + 动爻
- 体用分析（体卦 / 用卦）
- 体用生克（五行生克）

#### 3.3.4 输出 Output
- 卦象（本卦 + 变卦）
- 体用分析
- 生克吉凶

#### 3.3.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 起卦法 | 时间 / 数字 / 方位 |
| 上卦 | 数字上卦（除 8 取余，0 取 8） |
| 下卦 | 数字下卦（除 8 取余，0 取 8） |
| 动爻 | 总数除 6 取余（0 取 6） |
| 体用 | 动爻所在卦为用卦，另一为体卦 |
| 生克 | 五行生克（金木水火土） |
| 动效 | Phase 3 起卦绘制 + Phase 4 结果揭示 |

#### 3.3.6 验收
- 起卦算法正确
- 体用分析清晰
- 生克判断正确

### 3.4 掷筊 Jiaobei

#### 3.4.1 功能描述
圣杯问事。

#### 3.4.2 输入 Input
- 用户掷筊动作（触摸 + 真随机）

#### 3.4.3 计算 Compute
- 圣筊（一正一反）
- 笑筊（两正）
- 阴筊（两反）

#### 3.4.4 输出 Output
- 筊杯结果（三态）
- 解读

#### 3.4.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 筊杯态 | 圣筊 / 笑筊 / 阴筊 |
| 概率 | 圣筊 50% / 笑筊 25% / 阴筊 25% |
| 动效 | Phase 3 掷筊动画 + Phase 4 结果揭示 |
| 真随机 | 支持 |

#### 3.4.6 验收
- 三态概率合理
- 掷筊动效完整

### 3.5 紫微斗数 Ziwei

#### 3.5.1 功能描述
v2 全套星曜安星（14 主星 + 辅星）。

#### 3.5.2 输入 Input
- 生辰（农历 / 公历）
- 性别

#### 3.5.3 计算 Compute
- lunar 历算 → 命盘 12 宫
- 14 主星安星（紫微系 / 天府系）
- 辅星安星（左辅右弼 / 文昌文曲 / 天魁天钺等）

#### 3.5.4 输出 Output
- 命盘图（12 宫 + 主星 + 辅星）
- 星曜解读

#### 3.5.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 12 宫 | 命宫 / 兄弟 / 夫妻 / 子女 / 财帛 / 疾厄 / 迁移 / 奴仆 / 官禄 / 田宅 / 福德 / 父母 |
| 14 主星 | 紫微 / 天机 / 太阳 / 武曲 / 天同 / 廉贞 / 天府 / 太阴 / 贪狼 / 巨门 / 天相 / 天梁 / 七杀 / 破军 |
| 辅星 | 左辅 / 右弼 / 文昌 / 文曲 / 天魁 / 天钺 / 禄存 / 天马等 |
| 安星 | 紫微系（紫微定 14 主星）+ 天府系 |
| 历算 | lunar |
| 动效 | Phase 3 命盘绘制 + Phase 4 揭示 |
| 对照 | 权威排盘工具 |

#### 3.5.6 验收
- 14 主星安星对照权威工具一致
- 辅星安星正确
- 命盘绘制清晰

### 3.6 奇门遁甲 Qimen

#### 3.6.1 功能描述
v2 四盘九宫。

#### 3.6.2 输入 Input
- 时间（节气 / 时辰）

#### 3.6.3 计算 Compute
- 天盘 / 地盘 / 人盘 / 神盘
- 九宫排布

#### 3.6.4 输出 Output
- 四盘九宫图
- 解读

#### 3.6.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 四盘 | 天盘 / 地盘 / 人盘 / 神盘 |
| 九宫 | 1坎 2坤 3震 4巽 5中 6乾 7兑 8艮 9离 |
| 节气 | 24 节气定局 |
| 历算 | lunar |
| 动效 | Phase 3 九宫绘制 + Phase 4 揭示 |
| 对照 | 权威文献 |

#### 3.6.6 验收
- 四盘排布正确
- 九宫绘制清晰
- 节气定局正确

### 3.7 抽签 Chouqian

#### 3.7.1 功能描述
抽签求签。

#### 3.7.2 输入 Input
- 用户抽签动作（触摸 + 真随机）

#### 3.7.3 计算 Compute
- 签文索引（真随机）

#### 3.7.4 输出 Output
- 签文（签号 + 签诗 + 解读）

#### 3.7.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 签文数 | 完整签文数据 |
| 真随机 | 签文索引 |
| 动效 | Phase 3 抽签动画 + Phase 4 签文揭示 |

#### 3.7.6 验收
- 抽签动效完整
- 签文数据完整
- 真随机索引

### 3.8 测字 Cezi

#### 3.8.1 功能描述
字义拆解断吉凶。

#### 3.8.2 输入 Input
- 用户输入汉字

#### 3.8.3 计算 Compute
- 字形拆解
- 字义分析
- 笔画计算

#### 3.8.4 输出 Output
- 拆解分析
- 吉凶判词

#### 3.8.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 输入 | 单字 / 多字 |
| 拆解 | 字形 / 字义 / 笔画 |
| 笔画 | 常见字笔画库 |
| 动效 | Phase 3 字形拆解 + Phase 4 结果揭示 |

#### 3.8.6 验收
- 拆解逻辑合理
- 常见字覆盖完整

### 3.9 大六壬 Daliuren

#### 3.9.1 功能描述
四课三传全套。

#### 3.9.2 输入 Input
- 时间（月将 / 时辰）

#### 3.9.3 计算 Compute
- 月将 + 时辰 → 四课
- 四课 → 三传（初传 / 中传 / 末传）

#### 3.9.4 输出 Output
- 四课三传图
- 解读

#### 3.9.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 月将 | lunar 节气定月将 |
| 四课 | 日干 / 日支 / 课干 / 课支 |
| 三传 | 初传 / 中传 / 末传 |
| 历算 | lunar |
| 动效 | Phase 3 四课三传绘制 + Phase 4 揭示 |
| 对照 | 专业排盘软件 |

#### 3.9.6 验收
- 四课三传算法对照权威工具一致
- 月将正确

### 3.10 风水罗盘 Luopan

#### 3.10.1 功能描述
陀螺仪/磁场实时方位。

#### 3.10.2 输入 Input
- 设备传感器（陀螺仪 + 磁场）

#### 3.10.3 计算 Compute
- 实时方位角
- 罗盘层（24 山等）

#### 3.10.4 输出 Output
- 罗盘指针
- 方位解读

#### 3.10.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 传感器 | sensors_plus（陀螺仪 + 磁场） |
| 方位角 | 实时计算 |
| 罗盘层 | 24 山 + 八卦 + 天干地支 |
| 平台 | Android 完整支持 |
| 降级 | Windows 桌面 / 不支持设备禁用并提示 |
| 动效 | 罗盘指针实时响应 |

#### 3.10.6 验收
- Android 端方位准确
- 不支持设备降级提示

### 3.11 八字推演 Bazi

#### 3.11.1 功能描述
四柱 + 大运 + 流年 + 神煞。

#### 3.11.2 输入 Input
- 生辰（公历 / 农历）
- 性别

#### 3.11.3 计算 Compute
- 年柱 / 月柱 / 日柱 / 时柱（lunar）
- 大运（起运年 + 大运流年）
- 流年
- 神煞

#### 3.11.4 输出 Output
- 四柱八字
- 大运流年
- 神煞解读

#### 3.11.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 四柱 | 年柱 / 月柱 / 日柱 / 时柱 |
| 大运 | 起运年 + 10 步大运 |
| 流年 | 当年流年 |
| 神煞 | 天乙 / 文昌 / 桃花 / 驿马等 |
| 历算 | lunar |
| 动效 | Phase 3 四柱绘制 + Phase 4 揭示 |
| 对照 | lunar 文档 |

#### 3.11.6 验收
- 四柱对照 lunar 文档一致
- 大运起运算法正确
- 神煞正确

### 3.12 测名字 NameTest

#### 3.12.1 功能描述
五格剖象。

#### 3.12.2 输入 Input
- 姓名

#### 3.12.3 计算 Compute
- 天格 / 人格 / 地格 / 外格 / 总格
- 三才（天/人/地）
- 五行数理

#### 3.12.4 输出 Output
- 五格数理
- 三才
- 解读

#### 3.12.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 五格 | 天格 / 人格 / 地格 / 外格 / 总格 |
| 三才 | 天 / 人 / 地三才 |
| 笔画 | 常见姓氏笔画库 |
| 数理 | 1-81 数理吉凶 |
| 动效 | Phase 3 五格绘制 + Phase 4 揭示 |

#### 3.12.6 验收
- 五格计算正确
- 常见姓氏笔画库完整
- 数理吉凶正确

---

## 4. 真随机引擎规格 RNG Specification

### 4.1 功能描述 Description

多源真随机引擎，提供卜算所需随机数。

### 4.2 输入 Input

- 卜算过程中的触摸轨迹
- 系统熵（dart:math Random.secure）
- random.org HTTP 真随机

### 4.3 计算 Compute

- 多源熵采集
- SHA256 混合
- 输出真随机数

### 4.4 输出 Output

- 真随机数（整数 / 字节流）

### 4.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 来源 1 | random.org（HTTP 真随机，需网络） |
| 来源 2 | 触摸轨迹熵（用户起卦过程触摸采样） |
| 来源 3 | dart:math Random.secure（系统 CSPRNG） |
| 混合 | crypto SHA256 |
| 降级 | random.org → 触摸轨迹 → Random.secure |
| 降级行为 | 静默降级，不阻塞用户 |
| 模块位置 | core/rng/ |

### 4.6 降级流程 Fallback Flow

```
1. 尝试 random.org
   ├─ 成功 → 使用 random.org 真随机
   └─ 失败 ↓
2. 使用触摸轨迹熵
   ├─ 有触摸采样 → 使用触摸熵
   └─ 无触摸采样 ↓
3. 使用 dart:math Random.secure
   └─ 始终可用
```

### 4.7 验收 Acceptance

- 三源降级机制生效
- random.org 不可达时静默降级
- 不阻塞用户操作
- SHA256 混合正确

---

## 5. 历史记录规格 History Specification

### 5.1 功能描述 Description

卜算结果自动保存为历史，可查阅与导出。

### 5.2 输入 Input

- 卜算结果自动写入
- 用户手动删除/导出

### 5.3 计算 Compute

- 原子读-改-写（防止快速连续卜算丢数据）

### 5.4 输出 Output

- 历史列表
- 历史详情
- 导出文件（path_provider）

### 5.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 存储 | 本地 JSON |
| 写入 | 原子读-改-写（HistoryStore） |
| 列表 | 按时间倒序 |
| 详情 | 完整卜算结果 |
| 导出 | path_provider 文件路径 |
| 分享 | 导出文件可分享 |
| 模块位置 | core/history/ |

### 5.6 原子读-改-写 Atomic Read-Modify-Write

```
1. 读取当前历史 JSON
2. 解析为 List
3. 添加新记录
4. 序列化为 JSON
5. 写回文件
（全程互斥锁，防止并发写入丢数据）
```

### 5.7 验收 Acceptance

- 历史记录完整
- 快速连续卜算不丢数据
- 导出文件可分享

---

## 6. 设置规格 Settings Specification

### 6.1 功能描述 Description

主题切换 + 动效全局开关 + 动画细分控制。

### 6.2 输入 Input

- 用户切换主题
- 用户切换动效开关
- 用户切换 AnimationKind 细分

### 6.3 计算 Compute

- AppConfig 状态更新
- shared_preferences 持久化

### 6.4 输出 Output

- 全局主题生效
- 全局动效开关生效
- AnimationKind 细分生效

### 6.5 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 主题 | 深色 / 浅色 |
| 动效全局开关 | AppConfig.animationsEnabled |
| AnimationKind 细分 | 4 种独立控制 |
| 持久化 | shared_preferences |
| 模块位置 | core/config/ + features/settings/ |

### 6.6 AnimationKind 定义

| AnimationKind | 描述 Description |
|-------------|---------------|
| 入场仪式 Entrance | Phase 1 入场动效 |
| 路由转场 Transition | Phase 2 路由转场 |
| 绘制过程 Drawing | Phase 3 绘制动效 |
| 结果揭示 Reveal | Phase 4 结果揭示 |

### 6.7 验收 Acceptance

- 主题切换生效 + 持久化
- 动效全局开关生效
- 4 个 AnimationKind 独立控制
- 重启后配置保留

---

## 7. 使用手册规格 Manual Specification

### 7.1 功能描述 Description

12 术原理与操作说明。

### 7.2 输入 Input

- 用户浏览

### 7.3 输出 Output

- 12 术分章说明

### 7.4 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 章节 | 12 术各一章 |
| 内容 | 原理 + 操作说明 + 注意事项 |
| 模块位置 | features/manual/ |
| 文化属性 | 强调传统文化，非迷信 |

### 7.5 验收 Acceptance

- 12 术均有原理 + 操作说明
- 文化属性清晰

---

## 8. 结果分享规格 Share Specification

### 8.1 功能描述 Description

share_plus 系统分享卜算结果。

### 8.2 输入 Input

- 用户点击分享按钮

### 8.3 输出 Output

- 系统分享面板
- 分享内容（结果文本）

### 8.4 规格 Spec

| 项 Item | 规格 Spec |
|-------|---------|
| 组件 | ShareResultButton（shared/widgets/） |
| 分享方式 | share_plus 系统分享 |
| 分享内容 | 卜算结果文本 |
| 跨端 | Android + Windows 均可用 |
| 复制 | CopyResultButton 支持 |

### 8.5 验收 Acceptance

- 分享内容包含结果文本
- 跨端可用
- 复制功能可用

---

## 9. 动效体系规格 Motion Specification

### 9.1 功能描述 Description

动效 Phase 1-6 全覆盖，统一封装，全局/细分开关。

### 9.2 规格 Spec

| 阶段 Phase | 内容 Content | 实现 Implementation |
|-----------|------------|-------------------|
| Phase 1 | 入场仪式 | Starfield + 卡片入场 |
| Phase 2 | 路由转场 | go_router 自定义转场 |
| Phase 3 | 绘制过程 | 卦象/盘面绘制动画 |
| Phase 4 | 结果揭示 | 结果卡片揭示动画 |
| Phase 5 | 按钮物理反馈 | GoldButton / DarkButton 物理反馈 |
| Phase 6 | 图标状态切换 | AnimatedExpandIcon + SvgIcon |

### 9.3 控制 Control

| 控制项 Control | 说明 Notes |
|-------------|----------|
| 全局开关 | AppConfig.animationsEnabled |
| 细分控制 | 4 个 AnimationKind 独立控制 |
| 统一封装 | core/theme/animations.dart |

### 9.4 资源管理 Resource Management

| 规则 Rule | 说明 Notes |
|----------|----------|
| CustomPainter | 显式 dispose TextPainter |
| AnimationController | 显式 dispose |
| Stream / Listener | 显式 cancel |

### 9.5 验收 Acceptance

- Phase 1-6 全覆盖
- 全局开关生效
- 4 个 AnimationKind 独立控制
- CustomPainter 显式 dispose TextPainter

---

## 10. 跨端规格 Cross-Platform Specification

### 10.1 平台支持 Platform Support

| 平台 Platform | 状态 Status | 说明 Notes |
|-----------|-----------|----------|
| Android | ✓ 完整支持 | 主平台 |
| Windows 桌面 | ✓ 支持 | Windows 10/11 |
| iOS | ✗ 不支持 | 范围外 |
| macOS | ✗ 不支持 | 范围外 |
| Linux | ✗ 不支持 | 范围外 |

### 10.2 平台差异处理 Platform Differences

| 功能 Function | Android | Windows |
|------------|---------|---------|
| 12 术卜算 | ✓ | ✓ |
| 真随机引擎 | ✓ | ✓ |
| 动效体系 | ✓ | ✓ |
| 历史记录 | ✓ | ✓ |
| 风水罗盘 | ✓ | ✗ 降级提示 |
| 结果分享 | ✓ | ✓ |
| 主题切换 | ✓ | ✓ |

### 10.3 桌面窗口初始化 Desktop Window Init

- main.dart 处理桌面窗口尺寸初始化
- 默认窗口大小适配桌面

### 10.4 验收 Acceptance

- 双端行为一致（罗盘除外）
- 双端构建产物均产出
- Android APK + Windows ZIP

---

## 附录 Appendix

### 附录A：模块位置 Module Locations

| 模块 Module | 位置 Location |
|----------|------------|
| 核心框架 | core/divination/ |
| 历算 | core/calendar/ |
| 配置 | core/config/ |
| 历史 | core/history/ |
| 真随机 | core/rng/ |
| 主题与动效 | core/theme/ |
| 品牌 | core/branding/ |
| 周易数据 | data/yijing/ |
| 12 术 | features/xxx/ |
| 通用组件 | shared/widgets/ |
| 路由 | router/ |
| Providers | providers/ |

### 附录B：通用组件 Shared Widgets

| 组件 Widget | 用途 Purpose |
|----------|-----------|
| GoldButton | 金色主按钮（物理反馈） |
| DarkButton | 深色次按钮（物理反馈） |
| AnimatedExpandIcon | 动画展开图标 |
| SvgIcon | SVG 矢量图标 |
| DecorativePanel | 装饰面板 |
| InteractableCard | 可交互卡片 |
| CopyResultButton | 复制结果按钮 |
| ShareResultButton | 分享结果按钮 |
| GuideDialog | 引导对话框 |
| Starfield | 星点背景动画 |
| SectionTitle | 章节标题 |

### 附录C：术语表 Glossary

| 术语 Term | 定义 Definition |
|----------|---------------|
| DivinationTech | 卜算术抽象接口 |
| registry | 卜算术注册表 |
| lunar | 寿星天文历 Dart 库 |
| RNG | Random Number Generator，真随机引擎 |
| Starfield | 星点背景动画 |
| AnimationKind | 动画类型枚举（4 种独立控制）|
| 金钱卦 | 周易起卦法 |
| 五格剖象 | 姓名学五格分析法 |
| 四课三传 | 大六壬核心结构 |
| 14 主星 | 紫微斗数主星 |
| 四盘九宫 | 奇门遁甲核心结构 |
| 四柱八字 | 八字推演核心 |

### 附录D：参考文档 Reference Documents

- 产品需求文档 PRD
- 业务需求文档 BRD
- 原型设计文档 Prototype Design
- AGENTS.md / CLAUDE.md（项目根目录）
- docs/FLUTTER_APK_BUILD_PIPELINE.md
- D:\Code\.Rules\OrganizationAndUser.md（身份信息源）

---

**文档结束 End of Document**

**重要提示:** 本功能规格说明书基于 2.3.3 release 的实际落地情况定稿，功能变更须重新评审。
