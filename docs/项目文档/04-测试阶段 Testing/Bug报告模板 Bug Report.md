# Bug 报告模板 Bug Report Template

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 适用范围 Scope | 全部 12 种卜算术 + 真随机引擎 + 动效体系 + 跨平台 + 历史 + 配置 |

---

## 一、Bug 编号规则 Naming Convention

```
BUG-{YYYYMMDD}-{3 位序号}
```

示例：`BUG-20260715-001`

---

## 二、严重程度定义 Severity Definition

| 等级 Severity | 含义 Meaning | 示例 Example | 响应 SLA |
|------------|-----------|-----------|---------|
| Critical | 阻塞核心功能 / 数据丢失 / 闪退 | App 启动崩溃；起卦无响应；历史全部丢失 | 4 小时内响应 |
| High | 核心功能受损但有 workaround | 某术起卦结果错误；某术页面打不开 | 1 天内响应 |
| Medium | 非核心功能受损 / 体验问题 | 动画卡顿；某按钮无反馈；UI 错位 | 3 天内响应 |
| Low | 文案 / 美化 / 边界情况 | 文案错字；颜色微调；极端尺寸下溢出 | 下个版本 |

---

## 三、优先级定义 Priority Definition

| 优先级 Priority | 含义 Meaning | 决定因素 Factor |
|--------------|-----------|--------------|
| P0 | 立即修复 | Critical 且影响 release |
| P1 | 本版本修复 | High 且影响功能验证 |
| P2 | 下个版本修复 | Medium 或 Low 影响体验 |
| P3 | 排期修复 | Low 不影响使用 |

---

## 四、状态流转 Status Workflow

```
New → Assigned → In Progress → Fixed → Verified → Closed
                                              ↓
                                         Reopened
```

| 状态 Status | 含义 Meaning |
|-----------|-----------|
| New | 新建未指派 |
| Assigned | 已指派开发 |
| In Progress | 开发修复中 |
| Fixed | 开发自测已修复，待 QA 验证 |
| Verified | QA 验证通过 |
| Reopened | QA 验证未通过，重新打开 |
| Closed | 已关闭（验证通过 / 重复 / 不修复 / 设计如此） |
| Won't Fix | 决定不修复 |

---

## 五、Bug 报告模板 Template

### BUG-{YYYYMMDD}-NNN | {Bug 标题}

| 字段 Field | 内容 Content |
|-----------|-------------|
| Bug ID | BUG-20260715-001 |
| 标题 Title | 简明描述（一行，包含模块 + 现象） |
| 严重程度 Severity | □ Critical □ High □ Medium □ Low |
| 优先级 Priority | □ P0 □ P1 □ P2 □ P3 |
| 状态 Status | New |
| 模块 Module | □ XLR □ ZY □ MH □ JB □ ZW □ QM □ CQ □ CZ □ DLR □ LP □ BZ □ NT □ RNG □ ANI □ UX □ HIST □ CFG □ Other |
| 平台 Platform | □ Android □ Windows □ Both |
| 报告人 Reporter | |
| 指派人 Assignee | |
| 报告日期 Date | YYYY-MM-DD |
| 影响版本 Affected Version | 2.3.3+23 |
| 修复版本 Fixed Version | |
| 关联用例 Test Case | TC-{MODULE}-NNN |

#### 复现步骤 Steps to Reproduce

1.
2.
3.

#### 预期结果 Expected

#### 实际结果 Actual

#### 复现频率 Reproducibility

□ 必现 Always □ 高频 Often □ 偶发 Sometimes □ 仅一次 Once

#### 测试环境 Environment

| 项 Item | 值 Value |
|--------|---------|
| 设备 Device | |
| 操作系统 OS | |
| App 版本 App Version | |
| 构建模式 Build Mode | □ debug □ profile □ release |
| 网络状态 Network | □ 在线 □ 离线 |
| useOnline | □ true □ false |
| animationsEnabled | □ true □ false |

#### 附件 Attachments

- □ 截图 Screenshot
- □ 录屏 Screen Recording
- □ 日志 Log
- □ Crash stack trace

#### 备注 Notes

（其他有助于定位的信息，如怀疑的根因、相关代码路径）

---

## 六、示例 Bug Sample Bug

### BUG-20260715-001 | 周易起卦后无响应（按钮点击无反馈）

| 字段 Field | 内容 Content |
|-----------|-------------|
| Bug ID | BUG-20260715-001 |
| 标题 Title | 周易起卦后无响应（按钮点击无反馈） |
| 严重程度 Severity | ☑ Critical |
| 优先级 Priority | ☑ P0 |
| 状态 Status | New |
| 模块 Module | ☑ ZY |
| 平台 Platform | ☑ Both |
| 报告人 Reporter | HeYS-Snowe |
| 指派人 Assignee | HeYS-Snowe |
| 报告日期 Date | 2026-07-15 |
| 影响版本 Affected Version | 2.3.3+23 |
| 关联用例 Test Case | TC-ZY-001 |

#### 复现步骤 Steps to Reproduce

1. 启动 App，进入首页
2. 点击「周易」卡片
3. 进入周易页面，点击「起卦」按钮

#### 预期结果 Expected

按钮触发起卦流程，仪式动画播放后展示 64 卦结果。

#### 实际结果 Actual

按钮无任何反馈，仪式动画不播放，无结果展示，控制台无错误日志。

#### 复现频率 Reproducibility

☑ 必现 Always

#### 测试环境 Environment

| 项 Item | 值 Value |
|--------|---------|
| 设备 Device | Pixel 6 / Windows 11 |
| 操作系统 OS | Android 14 / Windows 11 23H2 |
| App 版本 App Version | 2.3.3+23 |
| 构建模式 Build Mode | ☑ release |
| 网络状态 Network | ☑ 在线 |
| useOnline | ☑ true |
| animationsEnabled | ☑ true |

#### 附件 Attachments

- ☑ 截图 Screenshot：zhouyi_button_no_response.png
- ☑ 录屏 Screen Recording：zhouyi_button_no_response.mp4

#### 备注 Notes

怀疑 `features/zhouyi/algorithm/divine.dart` 在 release 模式下被 tree-shaking 删除了某段必要逻辑，需检查 `zhouyi_tech.dart` 的 buildPage 是否正确连接了起卦回调。debug 模式下无法复现。

---

## 七、Bug 列表汇总 Bug List

> 每个 release 测试周期结束时，将所有 Bug 汇总于此表。

| Bug ID | 严重 Severity | 优先 Priority | 模块 Module | 平台 Platform | 标题 Title | 状态 Status | 报告人 Reporter | 指派人 Assignee | 报告日期 Date |
|--------|-----------|------------|-----------|--------------|-----------|-----------|---------------|---------------|-----------|
| BUG-20260715-001 | Critical | P0 | ZY | Both | 周易起卦后无响应 | New | HeYS-Snowe | HeYS-Snowe | 2026-07-15 |
| BUG-20260715-002 | — | — | — | — | — | — | — | — | — |
| BUG-20260715-003 | — | — | — | — | — | — | — | — | — |

---

## 八、Bug 统计 Statistics

### 8.1 按严重程度 By Severity

| 严重程度 Severity | 数量 Count | 已修复 Fixed | 已验证 Verified | 已关闭 Closed | 未关闭 Open |
|----------------|----------|-----------|---------------|-------------|-----------|
| Critical | — | — | — | — | — |
| High | — | — | — | — | — |
| Medium | — | — | — | — | — |
| Low | — | — | — | — | — |
| **合计 Total** | **—** | **—** | **—** | **—** | **—** |

### 8.2 按模块 By Module

| 模块 Module | Critical | High | Medium | Low | 合计 Total |
|-----------|----------|------|--------|-----|----------|
| XLR | — | — | — | — | — |
| ZY | — | — | — | — | — |
| MH | — | — | — | — | — |
| JB | — | — | — | — | — |
| ZW | — | — | — | — | — |
| QM | — | — | — | — | — |
| CQ | — | — | — | — | — |
| CZ | — | — | — | — | — |
| DLR | — | — | — | — | — |
| LP | — | — | — | — | — |
| BZ | — | — | — | — | — |
| NT | — | — | — | — | — |
| RNG | — | — | — | — | — |
| ANI | — | — | — | — | — |
| UX | — | — | — | — | — |
| HIST | — | — | — | — | — |
| CFG | — | — | — | — | — |

---

## 九、使用说明 Usage Notes

1. **每条 Bug 独立编号**：禁止合并多个问题到一个 Bug，否则追踪困难。
2. **复现步骤要可执行**：第三方按步骤应能 100% 复现（除非是偶发）。
3. **附件必备**：Critical / High 必须附截图或录屏，方便开发定位。
4. **真随机相关 Bug 特殊**：由于 RNG 是真随机，结果数值本身不可重现，Bug 描述应聚焦于「采样源缺失」「降级异常」「范围越界」等可观察现象，而非「结果数值不对」。
5. **跨平台 Bug**：必须在 Android + Windows 双端各复现一次，明确是平台特定还是通用。
6. **修复后必经验证**：开发将状态置为 Fixed 后，QA 必须复测并置为 Verified 才能关闭。
7. **Reopened 计数**：同一 Bug Reopen 超过 2 次需升级优先级并 root cause 分析。
