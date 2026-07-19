# 安全测试报告 Security Test Report

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 测试版本 Build Under Test | 2.3.3+23 |
| 报告版本 Report Version | v1.0.0 |
| 测试日期 Test Date | YYYY-MM-DD |
| 测试人 Tester | HeYS-Snowe |
| 仓库 Repository | https://github.com/HeYS-Snowe/Jeenith |
| 许可证 License | MIT |

---

## 修改记录 Change History

| 版本 Version | 日期 Date | 修改人 Modifier | 修改内容 Description |
|-------------|---------|---------------|-------------------|
| v1.0.0 | YYYY-MM-DD | HeYS-Snowe | 初始版本，覆盖 v2.3.3 release 安全基线 |

---

## 目录 Table of Contents

1. [测试概述 Test Overview](#1-测试概述-test-overview)
2. [测试环境 Test Environment](#2-测试环境-test-environment)
3. [威胁模型 Threat Model](#3-威胁模型-threat-model)
4. [真随机熵源安全 RNG Security](#4-真随机熵源安全-rng-security)
5. [本地存储安全 Local Storage](#5-本地存储安全-local-storage)
6. [网络传输安全 Network Security](#6-网络传输安全-network-security)
7. [代码与依赖安全 Code & Dependency](#7-代码与依赖安全-code--dependency)
8. [平台权限 Permissions](#8-平台权限-permissions)
9. [隐私合规 Privacy Compliance](#9-隐私合规-privacy-compliance)
10. [安全结论 Conclusion](#10-安全结论-conclusion)

---

## 1. 测试概述 Test Overview

### 1.1 测试目标 Objectives

志极 Jeenith 是无后端的纯客户端 App，安全测试聚焦于：

- **真随机熵源质量**：多源 SHA256 混合的抗预测性、降级路径安全性。
- **本地存储**：历史记录、AppConfig 是否含敏感数据、是否会被其他 App 读取。
- **网络传输**：仅与 random.org 通信，确认无敏感数据外泄、传输加密。
- **代码与依赖**：无硬编码密钥、依赖无已知 CVE。
- **平台权限**：仅申请必要权限（罗盘传感器）。
- **隐私合规**：无用户账号体系、无个人身份信息（PII）收集。

### 1.2 安全原则 Principles

- OWASP Mobile Top 10
- 最小权限原则
- 数据最小化（不收集与功能无关的数据）
- 默认安全（secure by default）

---

## 2. 测试环境 Test Environment

### 2.1 设备 Devices

| 设备 Device | 平台 Platform | 用途 Usage |
|------------|--------------|-----------|
| Android 真机（已 root） | Android 13+ | 存储隔离测试、抓包 |
| Windows 桌面 | Windows 11 23H2 | 文件系统权限测试 |
| 抓包工具 Wireshark / Fiddler | — | 网络流量分析 |

### 2.2 测试方法 Methods

| 方法 Method | 用途 Usage |
|----------|----------|
| 静态代码审计 | 搜索硬编码密钥、敏感 API |
| 网络抓包 | 验证仅 random.org 流量，HTTPS 强制 |
| 存储隔离测试 | adb shell 检查 SharedPreferences 文件权限 |
| 依赖扫描 | `flutter pub outdated` + 已知 CVE 查询 |
| RNG 统计检验 | χ² 均匀性 + 熵估计 |

---

## 3. 威胁模型 Threat Model

### 3.1 资产 Assets

| 资产 Asset | 位置 Location | 敏感度 Sensitivity |
|----------|-------------|-----------------|
| 起卦历史记录 | shared_preferences (JSON) | 低（用户卜算记录，无 PII） |
| AppConfig（含动画开关） | shared_preferences | 极低 |
| 真随机种子混合输出 | 内存 | 中（影响卜算结果不可预测性） |
| random.org 请求 | 网络传输 | 低（无认证 token） |

### 3.2 威胁 Threats

| 威胁 Threat | 影响 Impact | 概率 Probability |
|-----------|-----------|----------------|
| 攻击者预测 RNG 输出 | 卜算结果可预测 | 低（多源混合） |
| 恶意 App 读取历史 | 隐私泄漏 | 低（Android 沙箱） |
| random.org 中间人攻击 | 熵源被污染 | 低（HTTPS） |
| APK 被二次打包篡改 | 信任受损 | 中（GitHub Release 分发） |
| 依赖库 CVE | 潜在漏洞 | 低（定期 audit） |

### 3.3 不适用 Not Applicable

- 账号体系、密码、Token（无）
- 后端 API、SQL 注入、XSS（无后端）
- 支付、加密货币（无）
- 用户上传内容、UGC（无）

---

## 4. 真随机熵源安全 RNG Security

### 4.1 熵源架构 Architecture

志极真随机引擎（`core/rng/true_random.dart`）采用 3 源 SHA256 链式混合：

```
系统熵（Random.secure）─┐
触摸轨迹（TouchTracker）─┼─► SHA256 链式混合 ─► [1, vmax] 整数
random.org 大气噪声 ────┘
```

- 链式混合：`digest = SHA256(SHA256(...) || source_bytes)`
- 收尾：附加时间戳 + 16 字节 Random.secure
- 链式扩展：`cur = SHA256(cur || i)`，避免简单切片相关性

### 4.2 熵源质量检验 Quality Tests

| 检验 Test | 样本 N | 结果 Expected | 实测 Actual | 结论 Result |
|---------|-------|-------------|-----------|-----------|
| χ² 均匀性（α=0.05, df=8） | 10000 | p > 0.05 | — | □ |
| 各值频次偏差 | 10000 | ≤ ±20% | — | □ |
| 连续重复次数 | 10000 | ≤ 5 | — | □ |
| 输出范围 [1, vmax] 边界 | 1000 | 含 1 和 vmax | — | □ |

### 4.3 抗预测性 Anti-Prediction

| 攻击场景 Attack Scenario | 缓解措施 Mitigation | 验证 Verification | 结果 Result |
|----------------------|------------------|-----------------|-----------|
| 仅知道系统熵输出 | 触摸轨迹 + random.org 仍保密 | 模拟已知系统熵下输出仍不可预测 | □ |
| 仅知道 random.org 输出 | 系统熵 + 触摸仍保密 | 同上 | □ |
| 全部熵源已知 | 不可能（系统熵 Random.secure 抗预测） | — | □ |
| 离线场景（无 random.org） | 系统熵 + 触摸仍提供 2 源 | TC-RNG-002 验证 | □ |

### 4.4 降级路径安全 Degradation

| 场景 Scenario | 行为 Behavior | 安全性 Security | 结果 Result |
|-------------|-----------|---------------|-----------|
| random.org 不可达 | 跳过该源，标记 succeeded=false | 不崩溃，输出仍合法 | □ |
| 触摸轨迹过短 | 跳过该源 | 输出仍合法 | □ |
| 全部熵源失败 | 兜底用 Random.secure 16 字节 | 仍有真随机保证 | □ |
| SHA256 计算异常 | 捕获并降级 | 不崩溃 | □ |

### 4.5 熵估计 Entropy Estimation

| 熵源 Source | 估算熵 Est. Entropy (bits) | 备注 |
|-----------|------------------------|-----|
| Random.secure 16 字节 | ≥ 128 | 操作系统 CSPRNG |
| 触摸轨迹（每点） | ~4-8 | 用户行为熵 |
| random.org 16 字节 | ≥ 128 | 大气噪声 |
| **混合总熵** | **≥ 256** | 远超卜算所需 |

---

## 5. 本地存储安全 Local Storage

### 5.1 存储内容 Inventory

| 数据 Data | 存储方式 Storage | 是否敏感 Sensitive | 加密 Encrypted |
|---------|---------------|----------------|--------------|
| 起卦历史 HistoryStore | shared_preferences (JSON) | 否（无 PII） | 否（沙箱隔离） |
| AppConfig | shared_preferences | 否 | 否 |
| 临时导出文件 | path_provider (cache) | 否 | 否 |

### 5.2 Android 沙箱隔离 Sandbox Isolation

| 检查项 Item | 方法 Method | 预期 Expected | 实测 Actual | 结果 Result |
|-----------|----------|-------------|-----------|-----------|
| SharedPreferences 文件权限 | `adb shell ls -l /data/data/com.qore.jeenith/shared_prefs/` | 仅 owner 可读写（0600） | — | □ |
| 其他 App 可读 | `adb shell run-as <other.app>` | 不可读 | — | □ |
| 历史导出文件路径 | `adb shell ls /data/data/com.qore.jeenith/cache/` | 仅 owner | — | □ |

### 5.3 Windows 文件权限 File Permissions

| 检查项 Item | 路径 Path | 预期 Expected | 实测 Actual | 结果 Result |
|-----------|---------|-------------|-----------|-----------|
| 配置文件 | `%APPDATA%\com.qore\jeenith\` | 用户私有 | — | □ |
| 历史导出 | `%TEMP%\` 或类似 | 用户私有 | — | □ |

### 5.4 敏感数据扫描 Sensitive Data Scan

| 检查项 Item | 结果 Result | 备注 |
|-----------|-----------|-----|
| 历史记录是否含生辰八字 | □ 否（仅含起卦结果摘要） | 用户输入实时算，不持久化 |
| 历史记录是否含姓名 | □ 否 | |
| 配置是否含密码/Token | □ 否 | |
| 日志是否输出敏感数据 | □ 否 | release 模式无日志 |

---

## 6. 网络传输安全 Network Security

### 6.1 网络流量清单 Inventory

志极 App 仅与一个外部端点通信：

| 端点 Endpoint | 用途 Usage | 协议 Protocol | 触发 Trigger |
|------------|---------|------------|------------|
| random.org | 在线大气噪声熵源 | HTTPS | 起卦时（useOnline=true） |

### 6.2 HTTPS 强制 HTTPS Enforcement

| 检查项 Item | 预期 Expected | 实测 Actual | 结果 Result |
|-----------|-------------|-----------|-----------|
| 仅 HTTPS 通信 | 是 | — | □ |
| 证书校验 | 严格校验 | — | □ |
| 拒绝自签名证书 | 是 | — | □ |
| HTTP 明文回退 | 否 | — | □ |

### 6.3 抓包验证 Packet Capture

| 检查项 Item | 预期 Expected | 实测 Actual | 结果 Result |
|-----------|-------------|-----------|-----------|
| 仅 random.org 流量 | 是 | — | □ |
| 请求体无敏感数据 | 是（仅请求随机字节） | — | □ |
| 响应体无敏感数据 | 是（仅返回随机数） | — | □ |
| 无 analytics / tracking | 是 | — | □ |
| 无崩溃上报 | 是 | — | □ |

### 6.4 离线行为 Offline Behavior

| 场景 Scenario | 行为 Behavior | 结果 Result |
|-------------|-----------|-----------|
| 完全离线 | random.org 降级，仍可起卦 | □ Pass |
| 网络延迟高 | 不阻塞 UI，最坏退化为系统熵+触摸 | □ Pass |

---

## 7. 代码与依赖安全 Code & Dependency

### 7.1 硬编码密钥扫描 Hardcoded Secrets

| 检查项 Item | 方法 Method | 结果 Result |
|-----------|----------|-----------|
| 搜索 `password=` / `token=` / `secret=` | Grep | □ 无 |
| 搜索 `AKIA` / `api_key` | Grep | □ 无 |
| random.org 是否需 API Key | 检查 `OnlineEntropySource` | □ 否（免费公开 API） |
| 签名 keystore 密码 | 检查构建脚本 | □ 不硬编码 |

### 7.2 依赖扫描 Dependency Audit

| 依赖 Dependency | 版本 Version | 已知 CVE | 结果 Result |
|---------------|------------|---------|-----------|
| flutter_riverpod | ^2.5.0 | 无 | □ |
| go_router | ^14.0.0 | 无 | □ |
| lunar | ^1.7.8 | 无 | □ |
| flutter_svg | ^2.0.0 | 无 | □ |
| shared_preferences | ^2.2.0 | 无 | □ |
| sensors_plus | ^6.0.0 | 无 | □ |
| share_plus | ^10.0.0 | 无 | □ |
| path_provider | ^2.1.0 | 无 | □ |
| http | ^1.2.0 | 无 | □ |
| crypto | ^3.0.0 | 无 | □ |
| window_manager | ^0.5.2 | 无 | □ |
| screen_retriever | ^0.2.2 | 无 | □ |

### 7.3 静态分析 Static Analysis

| 检查项 Item | 命令 Command | 结果 Result |
|-----------|------------|-----------|
| flutter analyze | `flutter analyze` | □ 0 issue |
| dart code metrics | 自定义规则 | □ 通过 |

### 7.4 代码签名 Code Signing

| 平台 Platform | 签名方式 Signing | 验证 Verification | 结果 Result |
|------------|---------------|-----------------|-----------|
| Android APK | debug keystore（暂未 release 签名） | — | □ 已知限制 |
| Windows exe | 无强制签名 | — | □ 已知限制 |

> **已知限制**：当前 release 通过 GitHub Release 分发，APK 与 exe 暂未做正式代码签名。用户应从 GitHub Release 页下载并核对 SHA-256。

---

## 8. 平台权限 Permissions

### 8.1 Android 权限

| 权限 Permission | 用途 Usage | 必需 Required | 结果 Result |
|--------------|---------|------------|-----------|
| INTERNET | random.org 在线熵源 | 是（可选关闭） | □ 合理 |
| ACCESS_NETWORK_STATE | 检测网络可达性 | 是 | □ 合理 |
| ACCESS_FINE_LOCATION | — | 否 | □ 未申请 |
| ACCESS_COARSE_LOCATION | — | 否 | □ 未申请 |
| READ_CONTACTS | — | 否 | □ 未申请 |
| CAMERA | — | 否 | □ 未申请 |
| RECORD_AUDIO | — | 否 | □ 未申请 |
| 磁力计（隐式） | 风水罗盘 | 是（仅罗盘功能） | □ 合理 |
| 加速度计（隐式） | 风水罗盘 | 是（仅罗盘功能） | □ 合理 |

### 8.2 Windows 权限

| 检查项 Item | 结果 Result | 备注 |
|-----------|-----------|-----|
| 仅用户态运行 | □ 是 | 无需管理员权限 |
| 无系统服务安装 | □ 是 | |
| 无注册表自启 | □ 是 | |
| 网络访问 | □ 仅 random.org | |

### 8.3 权限最小化原则 Verification

- □ 仅申请功能必需权限
- □ 风水罗盘权限为运行时按需启用
- □ 用户可在系统设置中撤销权限，App 不强制
- □ 撤销权限后 App 仍可使用（罗盘功能降级）

---

## 9. 隐私合规 Privacy Compliance

### 9.1 数据收集清单 Data Collection

志极 App **不收集任何用户个人身份信息（PII）**：

| 数据类型 Data Type | 是否收集 Collected | 是否上传 Uploaded | 备注 |
|---------------|---------------|---------------|-----|
| 姓名 | 否 | 否 | 用户输入仅内存中用于起卦，不持久化 |
| 生辰八字 | 否 | 否 | 同上 |
| 测字输入 | 否 | 否 | 同上 |
| 设备 ID | 否 | 否 | |
| 位置信息 | 否 | 否 | |
| 联系人 | 否 | 否 | |
| 麦克风 / 摄像头 | 否 | 否 | |

### 9.2 隐私政策 Privacy Policy

- □ 项目无账号体系，无需隐私政策强制展示
- □ 用户卜算数据仅本地存储，可随时清除（清空历史）
- □ random.org 请求不含用户数据，仅请求随机字节
- □ 无第三方 analytics / crash reporting SDK

### 9.3 合规清单 Compliance Checklist

| 法规 Regulation | 适用 Applicable | 状态 Status | 备注 |
|--------------|---------------|-----------|-----|
| GDPR（欧盟） | □ 否（无 PII） | N/A | |
| CCPA（加州） | □ 否 | N/A | |
| PIPL（中国） | □ 否（无 PII 上传） | N/A | |
| COPPA（儿童） | □ 否 | N/A | |

---

## 10. 安全结论 Conclusion

### 10.1 安全检查汇总 Summary

| 类别 Category | 检查项数 Items | 通过 Pass | 失败 Fail | 已知限制 Known Limit |
|-------------|-------------|---------|---------|-------------------|
| 真随机熵源 | 13 | — | — | — |
| 本地存储 | 10 | — | — | — |
| 网络传输 | 8 | — | — | — |
| 代码与依赖 | 12 | — | — | APK / exe 未签名 |
| 平台权限 | 8 | — | — | — |
| 隐私合规 | 7 | — | — | — |
| **合计 Total** | **58** | **—** | **—** | **1** |

### 10.2 安全风险等级 Risk Rating

| 风险 Risk | 等级 Severity | 处理 Action |
|----------|-----------|-----------|
| APK / exe 未做正式代码签名 | Medium | release notes 提示用户核对 SHA-256，未来考虑自签名 |
| random.org 在线熵源受网络影响 | Low | 已有降级路径，离线仍可用 |
| 其他 App 在 root 设备上可读历史 | Low | 仅 root 设备，正常沙箱已隔离 |

### 10.3 安全结论 Conclusion

> （填写最终结论，例如：志极 Jeenith 2.3.3+23 在真随机熵源、本地存储、网络传输、代码与依赖、平台权限、隐私合规等方面均通过安全测试。仅存在 1 个已知限制：APK / exe 暂未做正式代码签名，通过 GitHub Release 分发并提示用户核对 SHA-256 缓解。无 Critical / High 安全风险，建议发布。）

### 10.4 后续改进 Roadmap

| 行动 Action | 优先级 Priority | 截止 Due |
|-----------|--------------|---------|
| APK release 签名（自签名 keystore） | Medium | 下一版本 |
| Windows exe 代码签名证书 | Low | 长期 |
| 依赖定期 audit 自动化 | Low | 长期 |
