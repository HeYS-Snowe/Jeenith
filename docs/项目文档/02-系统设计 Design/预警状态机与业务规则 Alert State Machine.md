# 预警状态机与业务规则 Alert State Machine & Business Rules

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---|---|
| 文档版本 Version | v0.1.0 |
| 创建日期 Created | 2026-07-05 |
| 作者 Author | Claude（思维逻辑层） |
| 面向读者 Audience | Codex（视觉层）、后端实现、产品 |
| 上游依赖 Depends | PRD（待细化） |
| 下游 Downstream | 《数据模型与 API 契约》《App 页面与路由清单》、UI 状态徽章/卡片 |

> 本文是**预警业务的权威规则来源**。Codex 据第 §3、§7 设计状态徽章与预警卡片；后端据 §3、§4 实现状态机与校验。

---

## 1. 危险行为分类 Behavior Types

边缘侧 AI 可识别的行为类型。`behavior_type` 为系统枚举，全量可配置。

| behavior_type | 中文名 | 默认级别 default severity | 默认接警 SLA ack_sla | 说明 |
|---|---|---|---|---|
| `fight` | 打架斗殴 | high | 30s | 肢体冲突/暴力行为 |
| `fence_climb` | 翻越围墙 | high | 30s | 围墙/栅栏翻越 |
| `dangerous_climb` | 危险攀爬 | medium | 120s | 攀爬危险区域（顶棚、护栏等） |
| `fire_smoke` | 火情/烟雾 | high | 30s | 明火、浓烟 |
| `crowd_gather` | 人员异常聚集 | medium | 120s | 短时人数超阈值/聚集异常 |
| `abnormal_loiter` | 异常徘徊 | high | 30s | 长时徘徊/驻足（**轻生倾向**，项目核心场景） |
| `restricted_zone` | 危险区域靠近 | medium | 120s | 靠近危险区域（顶楼边缘/配电房等） |
| `water_zone` | 水域入侵 | high | 30s | 进入湖边/水池等水域 |
| `intrusion` | 人员入侵 | high | 30s | 非授权人员闯入禁区 |
| _reserved_ | 跌倒 / 持械 / 奔跑等 | — | — | 预留扩展，按需启用 |

> 最终级别 `severity` 由 `behavior_type` 默认值，结合置信度、人数、持续时长等上下文，经 `AlertRule` 规则推导得出（见 §4-R1）。

---

## 2. 预警级别 Severity

预警的紧急程度，决定视觉权重、推送强度与超时升级策略。

| severity | 含义 | 视觉（给 Codex） | 推送 | 自动升级 |
|---|---|---|---|---|
| `high` | 一级高危 | 红 | 强提醒（震动+铃声，可穿透静音） | 30s 未接警 → escalated |
| `important` | 二级重要 | 橙 | 强提醒 | 60s 未接警 → escalated |
| `medium` | 三级中等 | 黄 | 列表提示 | 120s 未接警 → escalated |
| `low` | 四级一般 | 紫 | 列表提示，不强响 | 不自动升级 |

---

## 3. 预警单生命周期状态机 Alert Lifecycle

### 3.1 状态枚举 Status Enum

`Alert.status`，6 个值。这是 Codex 状态徽章的核心维度。

| status | 中文 | 含义 | 视觉建议（给 Codex） |
|---|---|---|---|
| `pending` | 待处置 | AI 生成，无人认领 | **警报红 + 脉冲动画**，最高视觉权重 |
| `handling` | 处置中 | 安保已接警认领 | 警示橙 / 深蓝，稳定态 |
| `closed` | 已闭环 | 处置完成 | 中性灰 / 成功绿 |
| `false_alarm` | 误报 | 判定为误报 | 灰色描边，弱化 |
| `escalated` | 已升级 | 超时或手动升级，已上报管理者 | 复用警报红 + **"已升级"角标** |
| `archived` | 已归档 | 闭环/误报后定时归档 | 极弱灰，仅历史可查 |

### 3.2 合法状态迁移 Transitions

```
                         ┌──────── auto (ack SLA 超时) ────────┐
                         ▼                                      │
   [AI 生成] ──▶  pending ──(接警 ack)──▶ handling ──(提交处置)──▶ closed ──(T 天)──▶ archived
                   │                          │                   │
                   │                          ├─(发现误报)──────▶ false_alarm ──(T 天)──▶ archived
                   │                          │                   │
                   ├─(误报，未接警)──────────▶ false_alarm          │
                   │                                              │
                   └─(手动升级)─────────────▶ escalated ◀─(请求支援/超时)─┘
                                                │
                                                ├─(管理者指派回)──▶ handling
                                                └─(管理者强制闭环)──▶ closed
```

迁移表（合法迁移 = 仅下列路径，其余非法，后端拒绝）：

| from | 事件 event | to | 操作角色 | 前置条件 | 后置动作 |
|---|---|---|---|---|---|
| `pending` | `ack` 接警 | `handling` | guard | 乐观锁未被他人抢占 | 写 acked_by/acked_at；推相关方 |
| `pending` | `false_alarm` 误报 | `false_alarm` | guard/manager | — | 记误报；统计 |
| `pending` | auto escalate（SLA 超时） | `escalated` | 系统 | 超 ack_sla_sec 未 ack | 二次强推管理者 |
| `pending` | `escalate` 手动升级 | `escalated` | guard | — | 推管理者 |
| `handling` | `handle` 提交处置 | `closed` | guard | 必填 handle_type + note | 写 handled_by/handled_at |
| `handling` | `false_alarm` 发现误报 | `false_alarm` | guard/manager | — | 记误报 |
| `handling` | `escalate` 请求支援/超时 | `escalated` | guard | — | 推管理者 |
| `escalated` | `reassign` 指派回 | `handling` | manager | 指定 guard | 新 acked_by |
| `escalated` | `force_close` 强制闭环 | `closed` | manager | 必填 note | — |
| `closed` | auto archive（T 天） | `archived` | 系统 | 闭环满 T 天 | 归档，不再活跃 |
| `false_alarm` | auto archive（T 天） | `archived` | 系统 | 满T 天 | 归档 |

> `archived` 为终态，不可再迁移。所有迁移均写 `AlertStatusLog`（见数据模型契约）。

---

## 4. 关键业务规则 Business Rules

- **R1 级别推导**：`severity = f(behavior_type.default_severity, confidence, person_count, duration)`。规则在 `AlertRule` 配置，例：`fight` 且 `confidence ≥ 0.85` → `high`；`crowd_gather` 且 `person_count < 阈值` → 降级或不生成。
- **R2 去重合并 Dedup**：同一 `camera_id` + `behavior_type`，在 `dedup_window_sec`（默认 15s）内的多次识别**合并进同一 `pending` 预警单**（`merged_count++`，刷新 snapshot 与最新 detected_at），不新建预警。窗口结束后若再有识别，开新预警单。
- **R3 置信度门槛**：`confidence < rule.confidence_threshold` 的识别**只写 `DetectionRecord` 日志，不进入 `Alert`**（不生成、不合并不进入）。
- **R4 接警 SLA 与自动升级**：`pending` 存在时长 > `ack_sla_sec`（high=30s/medium=120s/low=不升级）且未被 ack → 系统自动迁移至 `escalated`，二次强推管理者。
- **R5 接警独占（乐观锁）**：一个 `pending` 同时只能被一个 guard ack。并发用 `Alert.version` 乐观锁：ack 时 `WHERE id=? AND version=?`，失败方返回"已被他人接警"。防止重复处置。
- **R6 闭环必填**：迁移至 `closed` 必须提交 `handle_type`（处置手段枚举）+ `note`；`photos` 可选。
- **R7 边缘离线**：`camera.status = offline` 期间不产生预警；恢复后补传 `DetectionRecord`（按 `detected_at` 去重排序），补传的记录若落入已归档窗口则不再生成新预警。
- **R8 升级去重**：`escalated` 不重复触发二次推送，同一预警的升级通知在窗口内只推一次。

---

## 5. 角色权限矩阵（状态操作）Role Permissions

| 操作 Action | guard 安保 | manager 管理者 | admin 系统管理员 |
|---|:---:|:---:|:---:|
| 查看预警（按区域可见域） | R（本区域） | R（所辖区域） | R（全部） |
| 接警 `ack` | ✅ | — | — |
| 提交处置 `handle` → closed | ✅ | — | — |
| 标记误报 `false_alarm` | ✅ | ✅ | — |
| 手动升级 `escalate` | ✅ | ✅ | — |
| 介入指派回 `reassign` | — | ✅ | — |
| 强制闭环 `force_close` | — | ✅ | — |
| 配置规则 `AlertRule` | — | — | ✅ |
| 管理设备/区域/账号 | — | — | ✅ |

**数据可见域**：guard 仅本区域；manager 所辖区域树；admin 全部。列表查询强制带 `region_scope` 过滤。

---

## 6. 推送策略（与状态绑定）Push Strategy

| 触发 | 通道 | 强度 | 目标 |
|---|---|---|---|
| `pending` 生成 | Push（FCM/APNs）+ WebSocket | 强（high 可穿透静音） | 区域值班 guard |
| auto/manual `escalated` | Push + WebSocket | 强 | manager（二次，窗口内去重） |
| `ack` / `closed` / `false_alarm` | in-app 轻通知 | 弱 | 相关方 |
| 离线补传 | 重连后 WebSocket 增量同步 | — | 当前用户 |

---

## 7. 给 Codex 的视觉映射（速查）Visual Mapping

- **状态徽章**（按 `status`）：`pending`=警报红+脉冲 / `handling`=警示橙 / `closed`=成功绿 / `false_alarm`=灰描边 / `escalated`=警报红+"已升级"角标 / `archived`=极弱灰。
- **级别色条**（按 `severity`，预警卡片左侧 4px 竖条）：`high`=红 / `medium`=橙 / `low`=蓝。
- **列表排序权重**：`pending` 最前 → `escalated` → 按 `severity` → 按 `detected_at` 倒序；`archived` 不进默认列表。
- **强提醒**：`pending` + `high` 走全屏/置顶强提醒样式（具体由 Codex 定）。

---

## 附录 A：字段在数据模型中的位置

`Alert.status` / `Alert.severity` / `Alert.confidence` / `Alert.merged_count` / `Alert.version`（乐观锁）/ `Alert.acked_by` / `Alert.handled_by` / `Alert.handle_type` / `Alert.escalated_at` 等 —— 详见《数据模型与 API 契约》。

## 附录 B：处置手段枚举 handle_type

| code | 中文 |
|---|---|
| `dispatched` | 已派员到场 |
| `verbal_warn` | 现场口头劝阻 |
| `reported_110` | 报警 110 |
| `fire_extinguish` | 灭火处置 |
| `crowd_disperse` | 疏散人群 |
| `other` | 其他（note 必填） |

---

**文档结束** —— 下游：《数据模型与 API 契约》《App 页面与路由清单》。
