# 性能测试报告 Performance Test Report

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 测试版本 Build Under Test | 2.3.3+23 |
| 报告版本 Report Version | v1.0.0 |
| 测试日期 Test Date | YYYY-MM-DD |
| 测试人 Tester | HeYS-Snowe |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | YYYY-MM-DD | HeYS-Snowe | 初始版本，覆盖 v2.3.3 release 性能基线 |

---

## 目录 Table of Contents

1. [测试概述 Test Overview](#1-测试概述-test-overview)
2. [测试环境 Test Environment](#2-测试环境-test-environment)
3. [性能基线 Performance Baseline](#3-性能基线-performance-baseline)
4. [启动时间 Cold Start](#4-启动时间-cold-start)
5. [起卦响应时间 Divination Latency](#5-起卦响应时间-divination-latency)
6. [帧率与动效 FPS & Animation](#6-帧率与动效-fps--animation)
7. [内存占用 Memory](#7-内存占用-memory)
8. [APK / ZIP 体积 Size](#8-apk--zip-体积-size)
9. [传感器性能 Sensor Performance](#9-传感器性能-sensor-performance)
10. [结论与建议 Conclusion](#10-结论与建议-conclusion)

---

## 1. 测试概述 Test Overview

### 1.1 测试目标 Objectives

针对志极 Jeenith 2.3.3+23 在 Android 真机与 Windows 桌面双端的：

- 冷启动时间
- 12 种卜算术起卦响应时间
- 路由转场 / 仪式动画 / 结果揭示的帧率
- 内存占用与峰值
- APK 与 Windows ZIP 体积
- 风水罗盘传感器数据流性能

建立 release 性能基线，确保用户体验达到指标。

### 1.2 性能指标 Performance Targets

| 指标 Metric | 目标 Target | 备注 |
|-----------|-----------|-----|
| 冷启动时间 Cold Start | ≤ 2.5s | 首帧可交互 |
| 起卦响应 Latency | ≤ 1.5s | 含 RNG 采样 + 算法 + 渲染 |
| 路由转场 FPS | ≥ 55 FPS | TechTransition |
| 仪式动画 FPS | ≥ 50 FPS | 5000-6000ms 仪式 |
| 内存稳态 RAM | ≤ 250 MB | Android |
| 内存峰值 RAM | ≤ 350 MB | 仪式 + CustomPainter |
| APK 体积 | ≤ 60 MB | release |
| Windows ZIP 体积 | ≤ 15 MB | release |
| 罗盘传感器延迟 | ≤ 50 ms | 磁力计到指针更新 |

---

## 2. 测试环境 Test Environment

### 2.1 设备 Devices

| 设备 Device | 平台 Platform | OS | 硬件 Hardware | 屏幕 Screen |
|------------|--------------|----|--------------|-----------|
| Android 真机 | Android | 13+ | arm64, 8GB RAM | 1080×2400 |
| Windows 桌面 | Windows | 11 23H2 | x64, 16GB RAM | 1920×1080 |

### 2.2 测试工具 Tools

| 工具 Tool | 用途 Usage |
|----------|----------|
| Android Studio Profiler | 内存、CPU、GPU 采样 |
| Flutter DevTools Performance | 帧率、Widget rebuild |
| `Stopwatch` (Dart) | 起卦耗时埋点 |
| `flutter run --profile` | profile 模式性能 |
| PowerShell `Measure-Command` | 启动时间 |

### 2.3 构建信息 Build Info

| 项 Item | 值 Value |
|--------|---------|
| APK 文件 | Jeenith_release_2.3.3_20260715_01.apk |
| APK 大小 | 55.00 MB |
| Windows ZIP | Jeenith_release_2.3.3_20260715_01_windows_x64.zip |
| Windows ZIP 大小 | 13.27 MB |
| 构建模式 Build Mode | release |

---

## 3. 性能基线 Performance Baseline

> 以下为 v2.3.3+23 在双端实测基线，每个数据点取 5 次采样的中位数。

| 类别 Category | 指标 Metric | Android | Windows | 目标 Target | 结果 Result |
|-------------|-----------|---------|---------|-----------|-----------|
| 启动 | 冷启动首帧 (ms) | — | — | ≤ 2500 | □ |
| 启动 | 热启动首帧 (ms) | — | — | ≤ 800 | □ |
| 起卦 | 小六壬 (ms) | — | — | ≤ 1500 | □ |
| 起卦 | 周易 (ms) | — | — | ≤ 1500 | □ |
| 起卦 | 紫微 (ms) | — | — | ≤ 1500 | □ |
| 起卦 | 奇门 (ms) | — | — | ≤ 1500 | □ |
| 起卦 | 八字 (ms) | — | — | ≤ 1500 | □ |
| 起卦 | 罗盘（启动传感器）(ms) | — | N/A | ≤ 1500 | □ |
| 帧率 | 路由转场 FPS | — | — | ≥ 55 | □ |
| 帧率 | 仪式动画 FPS | — | — | ≥ 50 | □ |
| 帧率 | Starfield 背景 FPS | — | — | ≥ 55 | □ |
| 内存 | 稳态 RAM (MB) | — | — | ≤ 250 | □ |
| 内存 | 峰值 RAM (MB) | — | — | ≤ 350 | □ |
| 体积 | APK / ZIP (MB) | 55.00 | 13.27 | ≤ 60 / ≤ 15 | □ |
| 传感器 | 罗盘指针延迟 (ms) | — | N/A | ≤ 50 | □ |

---

## 4. 启动时间 Cold Start

### 4.1 测试方法 Methodology

- **冷启动**：杀进程后从图标点击到首页首帧可交互。
- **热启动**：从后台返回前台到首帧可交互。
- 5 次采样取中位数。

### 4.2 实测结果 Results

| 次数 Run | Android 冷启动 (ms) | Windows 冷启动 (ms) | Android 热启动 (ms) | Windows 热启动 (ms) |
|---------|------------------|------------------|------------------|------------------|
| 1 | — | — | — | — |
| 2 | — | — | — | — |
| 3 | — | — | — | — |
| 4 | — | — | — | — |
| 5 | — | — | — | — |
| **中位数 Median** | **—** | **—** | **—** | **—** |
| **目标 Target** | ≤ 2500 | ≤ 2500 | ≤ 800 | ≤ 800 |
| **结果 Result** | □ Pass | □ Pass | □ Pass | □ Pass |

### 4.3 启动阶段拆解 Startup Breakdown

| 阶段 Phase | Android (ms) | Windows (ms) | 备注 |
|-----------|-----------|-----------|-----|
| native init | — | — | |
| Flutter engine | — | — | |
| ProviderScope + AppConfig 加载 | — | — | shared_preferences |
| 首页 build + Starfield first paint | — | — | |

---

## 5. 起卦响应时间 Divination Latency

### 5.1 测试方法 Methodology

- 在每种术页面触发起卦，`Stopwatch` 埋点测量从「点击起卦按钮」到「结果渲染完成」耗时。
- 含 RNG 采样（系统熵 + 触摸轨迹 + random.org）+ 算法 + CustomPainter 渲染。
- 排除仪式动画时长（仪式动画是展示延迟，不是性能延迟）。
- 5 次采样取中位数。

### 5.2 实测结果 Results

| 术 Divination | 中位数 Median (ms) | 目标 Target | 结果 Result | 备注 |
|-----------|-----------------|-----------|-----------|-----|
| 小六壬 | — | ≤ 1500 | □ | |
| 周易 | — | ≤ 1500 | □ | 64 卦数据查找 |
| 梅花易数 | — | ≤ 1500 | □ | |
| 掷筊 | — | ≤ 1500 | □ | |
| 紫微斗数 | — | ≤ 1500 | □ | 安星 + StarChartPainter |
| 奇门遁甲 | — | ≤ 1500 | □ | 四盘九宫 |
| 抽签 | — | ≤ 1500 | □ | |
| 测字 | — | ≤ 1500 | □ | 笔画统计 |
| 大六壬 | — | ≤ 1500 | □ | 双盘旋转 |
| 风水罗盘 | — | ≤ 1500 | □ | 传感器初始化 |
| 八字推演 | — | ≤ 1500 | □ | lunar 历法 + 大运 |
| 测名字 | — | ≤ 1500 | □ | 五格剖象 |

### 5.3 RNG 耗时拆解 RNG Breakdown

| 阶段 Phase | 中位数 Median (ms) | 备注 |
|-----------|------------------|-----|
| 系统熵采样 | — | Random.secure |
| 触摸轨迹采样 | — | TouchTracker |
| 在线 random.org 采样 | — | HTTP 请求，受网络影响 |
| SHA256 链式混合 | — | crypto 包 |
| 总计 Total | — | |

---

## 6. 帧率与动效 FPS & Animation

### 6.1 测试方法 Methodology

- `flutter run --profile` 模式运行。
- Flutter DevTools Performance 录制 10 秒，统计平均 FPS 与最低 FPS。
- 测试场景：首页 → 进入某术 → 仪式动画 → 结果揭示 → 路由返回。

### 6.2 路由转场 TechTransition

| 路由 Route | 平均 FPS | 最低 FPS | 目标 Target | 结果 Result |
|----------|---------|---------|-----------|-----------|
| home → xiaoliuren | — | — | ≥ 55 | □ |
| home → zhouyi | — | — | ≥ 55 | □ |
| home → ziwei | — | — | ≥ 55 | □ |
| home → qimen | — | — | ≥ 55 | □ |
| home → bazi | — | — | ≥ 55 | □ |
| home → settings | — | — | ≥ 55 | □ |
| home → history | — | — | ≥ 55 | □ |
| home → manual | — | — | ≥ 55 | □ |

### 6.3 仪式动画 FPS

| 术 Divination | 时长 (ms) | 平均 FPS | 最低 FPS | 目标 Target | 结果 Result |
|-----------|---------|---------|---------|-----------|-----------|
| 周易铜钱抛落 | 5000 | — | — | ≥ 50 | □ |
| 紫微命盘展开 | 6000 | — | — | ≥ 50 | □ |
| 奇门九宫飞布 | 5000 | — | — | ≥ 50 | □ |
| 大六壬双盘旋转 | 5000 | — | — | ≥ 50 | □ |
| 风水罗盘扫描 | 4000 | — | — | ≥ 50 | □ |
| 梅花数字撞击 | 4000 | — | — | ≥ 50 | □ |
| 掷筊抛落 | 3000 | — | — | ≥ 50 | □ |
| 测字字形浮现 | 5000 | — | — | ≥ 50 | □ |
| 抽签卷轴展开 | 5000 | — | — | ≥ 50 | □ |

### 6.4 Starfield 背景持续帧率

| 场景 Scenario | 平均 FPS | 最低 FPS | 目标 Target | 结果 Result |
|-------------|---------|---------|-----------|-----------|
| 首页静止 | — | — | ≥ 55 | □ |
| 首页滚动 | — | — | ≥ 55 | □ |
| 起卦过程 | — | — | ≥ 50 | □ |

---

## 7. 内存占用 Memory

### 7.1 测试方法 Methodology

- Android Studio Profiler 持续采样 60 秒。
- 测试场景：冷启动 → 首页静止 30s → 进入紫微起卦（最重 CustomPainter）→ 返回首页。
- 记录稳态与峰值。

### 7.2 实测结果 Results

| 阶段 Stage | Android RAM (MB) | Windows RAM (MB) | 目标 Target | 结果 Result |
|----------|-----------------|-----------------|-----------|-----------|
| 冷启动后首页 | — | — | — | □ |
| 首页稳态（30s） | — | — | ≤ 250 | □ |
| 起卦中峰值 | — | — | ≤ 350 | □ |
| 返回首页后 | — | — | ≤ 稳态+10% | □ |

### 7.3 内存泄漏检测 Leak Detection

| 检查项 Item | Android | Windows | 结果 Result |
|-----------|---------|---------|-----------|
| CustomPainter TextPainter dispose | □ 无泄漏 | □ 无泄漏 | □ Pass |
| 重复起卦 20 次后内存 | □ 稳定 | □ 稳定 | □ Pass |
| 退出风水罗盘后传感器流 | □ 关闭 | N/A | □ Pass |
| 路由 pop 后 Widget 树释放 | □ 释放 | □ 释放 | □ Pass |

---

## 8. APK / ZIP 体积 Size

### 8.1 当前版本 Current Build

| 产物 Artifact | 大小 Size | 目标 Target | 结果 Result |
|-------------|---------|-----------|-----------|
| Jeenith_release_2.3.3_20260715_01.apk | 55.00 MB | ≤ 60 MB | □ Pass |
| Jeenith_release_2.3.3_20260715_01_windows_x64.zip | 13.27 MB | ≤ 15 MB | □ Pass |

### 8.2 历史版本趋势 Historical Trend

| 版本 Version | APK (MB) | Windows ZIP (MB) | 变化 Delta |
|------------|---------|-----------------|----------|
| v1.0.0 | 50.66 | — | baseline |
| v1.1.0 | 50.97 | 12.34 | +0.31 / — |
| v1.5.0 | 52.43 | 12.70 | +1.46 / +0.36 |
| v1.7.0 | 52.92 | 13.03 | +0.49 / +0.33 |
| v2.0.0 | 53.06 | 21.00 | +0.14 / +7.97（Windows 重构） |
| v2.1.0 | 53.48 | 13.10 | +0.42 / -7.90 |
| v2.3.0 | 54.89 | 13.29 | +1.41 / +0.19 |
| v2.3.3 | 55.00 | 13.27 | +0.11 / -0.02 |

### 8.3 体积优化建议 Optimization Notes

- APK 主要由 Flutter engine + lunar 历法库 + assets（yijing/、icons/）构成。
- Windows ZIP 较小（无 Dart AOT overhead 之外的 engine 损耗）。
- 当前体积在可接受范围内，无需 R8/ProGuard 进一步裁剪。

---

## 9. 传感器性能 Sensor Performance

### 9.1 测试方法 Methodology

- 仅 Android 真机（Windows 无磁力计）。
- 进入风水罗盘页面，记录传感器事件频率与罗盘指针更新延迟。

### 9.2 实测结果 Results

| 指标 Metric | 值 Value | 目标 Target | 结果 Result |
|-----------|---------|-----------|-----------|
| 磁力计采样率 (Hz) | — | ≥ 10 | □ |
| 加速度计采样率 (Hz) | — | ≥ 10 | □ |
| 指针更新延迟 (ms) | — | ≤ 50 | □ |
| 旋转 360° 指针跟随 | □ 平滑 | 平滑 | □ |
| 退出后采样停止 | □ 是 | 是 | □ |
| 后台 1 分钟耗电 | — | ≤ 1% | □ |

---

## 10. 结论与建议 Conclusion

### 10.1 性能基线汇总 Summary

| 类别 Category | 通过 Pass | 失败 Fail | 阻塞 Blocked |
|-------------|---------|---------|------------|
| 启动时间 Cold Start | — | — | — |
| 起卦响应 Latency | — | — | — |
| 帧率 FPS | — | — | — |
| 内存 Memory | — | — | — |
| 体积 Size | — | — | — |
| 传感器 Sensor | — | — | — |

### 10.2 性能结论 Conclusion

> （填写最终结论，例如：v2.3.3+23 在双端性能基线全部达标，启动 ≤ 2.5s，起卦 ≤ 1.5s，路由转场 ≥ 55 FPS，仪式动画 ≥ 50 FPS，稳态内存 ≤ 250 MB，APK 55.00 MB / ZIP 13.27 MB。建议发布。）

### 10.3 优化建议 Recommendations

- □ 无需优化，性能达标
- □ 建议下一版本优化：（列出具体项）
