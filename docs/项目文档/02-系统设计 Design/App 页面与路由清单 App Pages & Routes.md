# App 页面与路由清单 App Pages & Routes

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---|---|
| 文档版本 Version | v0.1.0 |
| 创建日期 Created | 2026-07-05 |
| 作者 Author | Claude（思维逻辑层） |
| 客户端 Client | Flutter（Riverpod 状态管理 · go_router 路由） |
| 上游 Depends | 《预警状态机与业务规则》《数据模型与 API 契约》 |
| 下游 Downstream | Codex（页面视觉与信息架构）、Flutter 路由实现 |

---

## 1. 角色与导航架构

### 1.1 角色 Roles

| role | 中文 | 主场景 |
|---|---|---|
| `guard` | 安保 | 接警、现场处置、反馈 |
| `manager` | 管理者 | 督战、介入指派、看统计 |
| `admin` | 系统管理员 | 设备/区域/规则/账号管理 |

### 1.2 底部导航 Bottom Nav（4 tab）

| # | tab | 路由 | guard | manager | admin |
|---|---|---|:---:|:---:|:---:|
| 0 | 预警 | `/alerts` | ✅默认首页 | ✅（全部） | ✅ |
| 1 | 监控 | `/monitor` | ✅（本区域） | ✅（所辖） | ✅（全部） |
| 2 | 统计 | `/stats` | ✅（简版） | ✅（全量） | ✅（全量） |
| 3 | 我的 | `/profile` | ✅ | ✅ | ✅（+ 管理入口） |

> 管理类页面（设备/区域/规则/账号）从「我的」进入，admin 专属。

---

## 2. 路由表 Route Table（go_router）

| path | name | 角色范围 | 需登录 | tab | 说明 |
|---|---|---|:---:|:---:|---|
| `/splash` | splash | 公开 | — | — | 启动 / 鉴权判定 |
| `/login` | login | 公开 | — | — | 登录 |
| `/alerts` | alerts | all | ✅ | 0 | 预警列表（首页） |
| `/alerts/:id` | alertDetail | all | ✅ | — | 预警详情 |
| `/monitor` | monitor | all | ✅ | 1 | 监控（设备/区域） |
| `/cameras/:id` | cameraDetail | all | ✅ | — | 设备详情 |
| `/stats` | stats | all | ✅ | 2 | 统计看板 |
| `/profile` | profile | all | ✅ | 3 | 我的 |
| `/profile/settings` | settings | all | ✅ | — | 设置 |
| `/admin/cameras` | adminCameras | admin | ✅ | — | 设备管理 |
| `/admin/regions` | adminRegions | admin | ✅ | — | 区域管理 |
| `/admin/rules` | adminRules | admin | ✅ | — | 预警规则管理 |
| `/admin/users` | adminUsers | admin | ✅ | — | 账号管理 |

**重定向 Redirect**：未登录访问受保护页 → `/login`；已登录访问 `/login` → `/alerts`；非 admin 访问 `/admin/*` → 403 页。

---

## 3. 页面清单 Page Specs

> 每页标注：数据来源（API / WebSocket）、核心状态、操作。状态徽章/色条见《预警状态机》§7。

### P-01 /login 登录
- **数据**：`POST /auth/login`
- **状态**：空表单 / 提交中 / 错误（凭证错、账号禁用 10101）
- **操作**：登录、忘记密码（占位）

### P-02 /alerts 预警列表（首页）★
- **数据**：`GET /alerts`（默认 `status≠archived`）+ WS `alert.created` / `alert.updated`
- **顶部筛选**：状态（全部/待处置/处置中/已闭环/误报/已升级）、级别、行为类型、区域
- **排序**：`pending` → `escalated` → 按 `severity` → 按 `detected_at` desc
- **列表项 `AlertListItem`**：抓拍缩略图 · 左侧 severity 色条 · status 徽章 · 行为中文名 · camera/region · 相对时间 · `merged_count` 角标
- **强提醒**：`pending` + `high` 全屏置顶卡 + 强震动（具体样式 Codex 定）
- **状态**：空（"暂无待处置预警"安心态）/ 加载 / 错误 / 离线横幅
- **操作**：点击进详情、下拉刷新、上拉分页

### P-03 /alerts/:id 预警详情 ★
- **数据**：`GET /alerts/{id}` + WS `alert.updated`
- **内容**：大图 / 视频片段 · 行为+级别+置信度 · camera+region+位置 · 检测时间 · `merged_count` · status 徽章 · 处置时间线 `status_logs` · 已处置信息
- **操作按钮组（按 `status` + 角色动态显示）**：

  | 当前 status | guard 可见按钮 | manager 额外 |
  |---|---|---|
  | `pending` | 接警 / 误报 / 升级 | — |
  | `handling` | 提交处置 / 误报 / 请求支援 | — |
  | `escalated` | — | 指派给… / 强制闭环 |
  | `closed` / `false_alarm` / `archived` | 只读 | 只读 |

- **提交处置**：底表/弹窗 → `handle_type` 选择 + `note` + 拍照/选图 → `POST /alerts/{id}/handle`
- **状态**：加载骨架 / 404（预警不存在 10201）/ 409（已被他人接警 10203 → 提示并刷新）/ 422（缺必填 10204）

### P-04 /monitor 监控
- **数据**：`GET /cameras?region_id=`（按角色 region_scope）
- **内容**：本/所辖/全部区域 camera 列表（在线/离线状态、最近预警数）
- **状态**：列表视图（MVP）；地图视图预留
- **操作**：点击 → cameraDetail

### P-05 /cameras/:id 设备详情
- **数据**：`GET /cameras/{id}` + 该设备近期预警
- **admin 额外**：编辑 / 启停（`online`↔`maintenance`）

### P-06 /stats 统计看板
- **数据**：`GET /stats/overview` · `GET /stats/trend`
- **guard**：本区域简版（今日预警数 / 待处置 / 闭环率）
- **manager / admin**：全量 `StatsOverview`（总数、各状态、闭环率、平均接警时长、各行为占比、级别分布）+ 时序图
- **状态**：加载 / 空（无数据）

### P-07 /profile 我的
- **内容**：姓名 / 角色 / 区域 · 我的处置统计（今日接警 / 闭环数）· 设置入口 · 退出登录

### P-08 /admin/* 管理（admin 专属）
- `/admin/cameras` `/admin/regions` `/admin/rules` `/admin/users`：标准 CRUD 列表 + 表单 + 删除确认

---

## 4. 页面通用状态 Common Page States（给 Codex）

| 状态 | 说明 |
|---|---|
| loading | 骨架屏（详情）/ 骨架列表项 |
| empty | 空态（插画 + 文案，预警空态用"安心态"正向表达） |
| error | 错误态 + 重试按钮 |
| offline | 顶部离线横幅，数据展示上次缓存 |
| noPermission | 403 页（区域越权 / 角色不足） |

---

## 5. 关键交互流 Flows

### 5.1 接警 → 处置闭环（核心流）
```
推送/列表点击 → /alerts/:id
  → [接警] (POST ack, 带 version)
    → 409 已被接警? → 提示 + 刷新
    → 成功 status=handling
  → [提交处置] (handle_type + note + photos, POST handle, 带 version)
    → status=closed, 时间线追加 → 返回列表
```

### 5.2 升级流
```
详情 [升级] → status=escalated → manager 收二次推送
  → /alerts/:id → [指派给 guardB] (reassign) 或 [强制闭环] (force_close)
```

---

## 6. 信息架构提示（给 Codex）

- 预警是核心，默认首页；强提醒需可穿透前台（`pending`+`high`）。
- 详情页操作按钮组**按 `status` 动态变化**，与《预警状态机》§3 迁移表一一对应。
- 列表/详情的视觉权重严格按 severity 色条 + status 徽章（见状态机 §7）。
- 时间线（`status_logs`）是详情页的固定区块，呈现处置全过程。

---

**文档结束** —— 三份逻辑契约（状态机 / 数据模型·API / 页面·路由）已交付完毕。
