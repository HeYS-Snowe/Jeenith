# 数据模型与 API 契约 Data Model & API Contract

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---|---|
| 文档版本 Version | v0.1.0 |
| 创建日期 Created | 2026-07-05 |
| 作者 Author | Claude（思维逻辑层） |
| 后端 Stack | Python 3.11 + FastAPI · 数据库候选 PostgreSQL · AI 识别在边缘侧 |
| 上游 Depends | 《预警状态机与业务规则》 |
| 下游 Downstream | 后端实现、Flutter 数据层、Codex（字段渲染） |

> 本文是**字段与接口的权威来源**。电商模板《数据库设计说明书》《接口设计文档》《API 接口文档》**已废弃**，不再适用。

---

## 1. 通用约定 Conventions

### 1.1 统一响应信封 Unified Envelope

```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1751750400,
  "requestId": "uuid"
}
```

分页响应：`data = { "items": [...], "pagination": { "page":1, "size":20, "total":100, "totalPages":5, "hasNext":true } }`

### 1.2 通用查询参数 Pagination & Filter

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| page | int | 1 | 页码，从 1 |
| size | int | 20 | 每页，1-100 |
| sort | string | detected_at | 排序字段 |
| order | string | desc | asc/desc |

### 1.3 错误码 Error Codes

| code | HTTP | 含义 |
|---|---|---|
| 200 | 200 | 成功 |
| 400 | 400 | 参数错误 |
| 401 | 401 | 未认证 / token 失效 |
| 403 | 403 | 无权限 / 区域越权 |
| 404 | 404 | 资源不存在 |
| 409 | 409 | 状态冲突（乐观锁失败 / 迁移非法） |
| 422 | 422 | 校验失败（如闭环缺必填） |
| 500 | 500 | 系统错误 |
| 10101 | 401 | 账号已禁用 |
| 10201 | 404 | 预警不存在 |
| 10202 | 409 | 状态迁移非法 |
| 10203 | 409 | 已被他人接警（version 不匹配） |
| 10204 | 422 | 闭环缺少 handle_type / note |
| 10301 | 403 | 区域越权（不在可见域） |

---

## 2. 核心实体 Core Entities

> 类型以 PostgreSQL 为准；主键统一 `BIGINT` 自增；时间 `TIMESTAMPTZ`；软删字段 `deleted_at TIMESTAMPTZ NULL`。

### 2.1 user 账号

| 字段 | 类型 | 必填 | 默认 | 说明 |
|---|---|---|---|---|
| id | BIGINT PK | Y | auto | |
| username | VARCHAR(50) UK | Y | | 登录账号 |
| name | VARCHAR(50) | Y | | 姓名 |
| phone | VARCHAR(20) | N | | 手机 |
| password_hash | VARCHAR(255) | Y | | bcrypt |
| role | enum | Y | | `guard`/`manager`/`admin` |
| region_ids | BIGINT[] | N | | 可见区域 id 列表（数据可见域） |
| status | enum | Y | active | `active`/`disabled` |
| last_login_at | TIMESTAMPTZ | N | | |
| created_at / updated_at | TIMESTAMPTZ | Y | now | |

### 2.2 region 监控区域（树形）

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| name | VARCHAR(100) | Y | 区域名（如"东区教学楼"） |
| parent_id | BIGINT | N | 父区域 |
| path | VARCHAR(255) | Y | 如 `/1/3/7`，便于按前缀查子树 |
| level | INT | Y | 层级 |
| manager_id | BIGINT | N | 负责 manager → user.id |
| created_at / updated_at | TIMESTAMPTZ | Y | |

### 2.3 camera 摄像头/设备

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| code | VARCHAR(64) UK | Y | 设备编号（边缘上报用） |
| name | VARCHAR(100) | Y | |
| region_id | BIGINT FK | Y | → region.id |
| location | VARCHAR(255) | N | 安装位置描述 |
| status | enum | Y | `online`/`offline`/`maintenance` |
| edge_node_id | VARCHAR(64) | N | 边缘节点标识 |
| stream_url | VARCHAR(255) | N | 仅管理用，**不下发 App** |
| installed_at | DATE | N | |
| created_at / updated_at | TIMESTAMPTZ | Y | |

### 2.4 alert_rule 预警规则

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| behavior_type | enum | Y | 见状态机 §1 |
| severity_default | enum | Y | high/medium/low |
| confidence_threshold | REAL | Y | 低于此值不生成预警（如 0.6） |
| dedup_window_sec | INT | Y | 去重合并窗口（默认 15） |
| ack_sla_sec | INT | Y | 接警 SLA，超时自动升级 |
| person_count_threshold | INT | N | crowd_gather 用 |
| enabled | BOOL | Y | true |

### 2.5 detection_record 边缘识别原始记录

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| camera_id | BIGINT FK | Y | |
| behavior_type | enum | Y | |
| confidence | REAL | Y | |
| snapshot_url | VARCHAR(512) | Y | 抓拍图对象存储 URL |
| person_count | INT | N | |
| detected_at | TIMESTAMPTZ | Y | 边缘检测时刻 |
| edge_node_id | VARCHAR(64) | N | |
| alert_id | BIGINT FK | N | 合并进的预警单；null=未达阈值 |
| ingested_at | TIMESTAMPTZ | Y | 服务端接收时刻 |

### 2.6 alert 预警单（核心）★

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| alert_no | VARCHAR(32) UK | Y | 业务编号 |
| camera_id | BIGINT FK | Y | |
| region_id | BIGINT FK | Y | 冗余，便于区域查询 |
| behavior_type | enum | Y | |
| severity | enum | Y | high/medium/low |
| status | enum | Y | pending/handling/closed/false_alarm/escalated/archived |
| confidence | REAL | Y | 最新/最高置信度 |
| snapshot_url | VARCHAR(512) | Y | 最新抓拍 |
| video_clip_url | VARCHAR(512) | N | 短视频片段 |
| person_count | INT | N | |
| detected_at | TIMESTAMPTZ | Y | 首次检测时刻 |
| merged_count | INT | Y | 合并的识别记录数，默认 1 |
| acked_by | BIGINT FK | N | → user.id |
| acked_at | TIMESTAMPTZ | N | |
| handle_type | enum | N | 闭环时填，见状态机附录 B |
| handling_note | TEXT | N | 处置说明 |
| handled_by | BIGINT FK | N | |
| handled_at | TIMESTAMPTZ | N | |
| escalated_at | TIMESTAMPTZ | N | |
| escalated_by | VARCHAR(32) | N | `auto` / `manual` / user_id |
| version | INT | Y | **乐观锁**，默认 1，每次状态变更 +1 |
| created_at / updated_at | TIMESTAMPTZ | Y | |

**关键索引**：`(region_id, status)`、`(status, severity, detected_at desc)`、`(camera_id, behavior_type, status)`、`uk_alert_no`。

### 2.7 alert_status_log 状态流转日志

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | BIGINT PK | Y | |
| alert_id | BIGINT FK | Y | |
| from_status | enum | N | |
| to_status | enum | Y | |
| event | VARCHAR(32) | Y | ack/handle/false_alarm/escalate/auto_escalate/reassign/force_close/archive |
| operator_id | BIGINT | N | 系统操作为 null |
| operator_role | enum | N | |
| note | TEXT | N | |
| created_at | TIMESTAMPTZ | Y | |

> `push_ticket`（推送工单）、`stats_snapshot`（统计快照）：MVP 推送工单可表化以便追踪送达；统计**实时聚合**，暂不建快照表。

### 2.8 实体关系 ER

```
region 1──N camera 1──N detection_record
                 1──N alert 1──N alert_status_log
                          N──1 user (acked_by / handled_by)
alert N──1 detection_record (合并)        user N──M region (region_ids 可见域)
```

---

## 3. API 端点 Endpoints

### 3.1 认证 Auth

| 方法 | 端点 | 说明 | 鉴权 |
|---|---|---|---|
| POST | /api/v1/auth/login | 登录 → access/refresh token | 公开 |
| POST | /api/v1/auth/refresh | 刷新 token | refresh |
| GET | /api/v1/auth/me | 当前用户 | JWT |

`POST /auth/login` 请求 `{account, password}` → `data: { access_token, refresh_token, token_type:"Bearer", expires_in, user:{id,name,role,region_ids} }`

### 3.2 预警 Alert（App 主接口）

| 方法 | 端点 | 说明 | 角色 |
|---|---|---|---|
| GET | /api/v1/alerts | 列表（带 region_scope 过滤） | all |
| GET | /api/v1/alerts/{id} | 详情（含 status_logs） | all |
| POST | /api/v1/alerts/{id}/ack | 接警 → handling | guard |
| POST | /api/v1/alerts/{id}/handle | 提交处置 → closed | guard |
| POST | /api/v1/alerts/{id}/false-alarm | 误报 | guard/manager |
| POST | /api/v1/alerts/{id}/escalate | 升级 → escalated | guard/manager |
| POST | /api/v1/alerts/{id}/reassign | 指派回 → handling | manager |
| POST | /api/v1/alerts/{id}/force-close | 强制闭环 → closed | manager |

> 所有写操作请求体必带 `version`（当前 Alert.version），用于乐观锁；不匹配返回 10203/409。

`GET /api/v1/alerts` 过滤：`status, severity, region_id, camera_id, behavior_type, detected_start, detected_end, page, size, sort, order`。`archived` 默认不返回。

`POST /alerts/{id}/handle` 请求 `{ version, handle_type, note, photos?:[url] }`（缺 handle_type/note → 10204/422）。

### 3.3 边缘上报 Ingest（机器通道）

| 方法 | 端点 | 说明 | 鉴权 |
|---|---|---|---|
| POST | /api/v1/ingest/detection | 单条上报 | edge token |
| POST | /api/v1/ingest/detections | 批量上报 | edge token |

`POST /ingest/detection` 请求 `{ camera_code, behavior_type, confidence, snapshot_url, person_count?, detected_at, edge_node_id }`
→ 服务端按规则去重合并 / 阈值过滤 → `data: { alert_id?, created:bool, merged:bool }`；`created=true` 触发推送。

### 3.4 统计 Stats（管理者看板）

| 方法 | 端点 | 说明 |
|---|---|---|
| GET | /api/v1/stats/overview | 总览（range=today/week/month，region_id 可选） |
| GET | /api/v1/stats/trend | 时序（granularity=hour/day） |

### 3.5 管理 Admin（admin/manager）

`/api/v1/cameras`、`/api/v1/regions`、`/api/v1/alert-rules`、`/api/v1/users` —— 标准 CRUD，按角色鉴权。

---

## 4. 关键响应结构（Codex 渲染依赖）Response Shapes

### 4.1 AlertListItem（列表项）

```json
{
  "id": 8801, "alert_no": "20260705-094012-C12-001",
  "camera": { "id": 12, "name": "东区围墙-12" },
  "region": { "id": 7, "name": "东区" },
  "behavior_type": "fence_climb", "severity": "high", "status": "pending",
  "confidence": 0.92, "merged_count": 3,
  "snapshot_url": "https://oss/.../snap_8801.jpg",
  "detected_at": "2026-07-05T09:40:12Z"
}
```

### 4.2 AlertDetail（详情）

```json
{
  "id": 8801, "alert_no": "...",
  "camera": { "id":12, "name":"东区围墙-12", "status":"online" },
  "region": { "id":7, "name":"东区" },
  "behavior_type": "fence_climb", "severity": "high", "status": "pending",
  "confidence": 0.92, "merged_count": 3,
  "snapshot_url": ".../snap_8801.jpg",
  "video_clip_url": ".../clip_8801.mp4",
  "person_count": 1,
  "detected_at": "2026-07-05T09:40:12Z",
  "acked_by": null, "acked_at": null,
  "handle_type": null, "handling_note": null, "handled_by": null, "handled_at": null,
  "escalated_at": null, "escalated_by": null,
  "version": 5,
  "status_logs": [
    { "event":"created", "from_status":null, "to_status":"pending", "created_at":"2026-07-05T09:40:12Z" }
  ]
}
```

### 4.3 StatsOverview

```json
{
  "total_alerts": 128, "pending": 3, "handling": 5, "closed": 110,
  "false_alarm_rate": 0.08,
  "avg_ack_seconds": 18.4, "avg_handle_seconds": 312.0, "closed_rate": 0.86,
  "by_behavior": [ {"behavior_type":"fight","count":22}, {"behavior_type":"fence_climb","count":40} ],
  "by_severity": { "high":30, "medium":70, "low":28 }
}
```

---

## 5. 实时通道 WebSocket

`WS /ws/v1/realtime`（JWT 鉴权，按 region_scope 订阅）

| 事件 event | data | 用途 |
|---|---|---|
| `alert.created` | AlertListItem | 新预警 → 列表插入 + 强提醒 |
| `alert.updated` | { id, status, severity, version, ... } | 状态变更 → 列表/详情刷新 |
| `alert.escalated` | { id } | 升级 → 二次提醒管理者 |
| `stats.tick` | — | 看板刷新触发（可选） |

---

## 6. 枚举汇总（给 Codex / 前端）

- `role`: `guard` / `manager` / `admin`
- `severity`: `high` / `important` / `medium` / `low`（一/二/三/四级，对齐 Web 红橙黄紫）
- `status`: `pending` / `handling` / `closed` / `false_alarm` / `escalated` / `archived`
- `behavior_type`: `fight` / `fence_climb` / `dangerous_climb` / `fire_smoke` / `crowd_gather` / `abnormal_loiter` / `restricted_zone` / `water_zone` / `intrusion`（+ reserved）
- `handle_type`: `dispatched` / `verbal_warn` / `reported_110` / `fire_extinguish` / `crowd_disperse` / `other`
- `camera.status`: `online` / `offline` / `maintenance`

---

**文档结束** —— 下游：《App 页面与路由清单》。
