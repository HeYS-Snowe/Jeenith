# 工作任务单 Work Order

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 任务单编号 Work Order ID | WO-YYYYMMDD-XXX |
| 创建日期 Created Date | YYYY-MM-DD |
| 项目名称 Project Name | 志极 Jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 开发者 Developer | HeYS-Snowe |

---

## 基本信息 Basic Information

| 字段 Field | 内容 Content |
|----------|-----------|
| **任务名称 Task Name** | |
| **任务编号 Task ID** | |
| **负责人 Owner** | HeYS-Snowe |
| **优先级 Priority** | □ P0-紧急 □ P1-高 □ P2-中 □ P3-低 |
| **任务类型 Type** | □ 新术数 □ 新功能 □ 优化 □ Bug修复 □ 文档 □ 其他 |
| **关联版本 Target Version** | vX.Y.Z |
| **预估工时 Estimate** | 小时/天 |
| **实际工时 Actual** | 小时/天 |

---

## 任务描述 Task Description

### 背景与目标 Background & Goal

> 描述任务背景、要解决的问题或要实现的功能。

### 验收标准 Acceptance Criteria

- [ ] 功能实现完整，符合需求描述
- [ ] `flutter analyze` 为 0 issue
- [ ] CustomPainter 中 TextPainter 显式 dispose（若涉及）
- [ ] AnimationController 显式 dispose（若涉及）
- [ ] HistoryStore 操作使用原子读-改-写（若涉及）
- [ ] 身份信息不硬编码（通过 Branding 类引用）
- [ ] 构建归档完成（若需发布）

---

## 技术方案 Technical Approach

### 涉及文件 Affected Files

| 文件路径 File Path | 修改类型 Change Type | 说明 Description |
|----------------|-------------------|----------------|
| | □ 新增 □ 修改 □ 删除 | |
| | □ 新增 □ 修改 □ 删除 | |
| | □ 新增 □ 修改 □ 删除 | |

### 实现思路 Implementation Notes

> 描述技术实现方案、算法逻辑、UI 交互等。

### 框架约定 Framework Conventions

> 若为新术数，确认以下框架约定：
> - [ ] 新建 `features/<tech_id>/` 目录
> - [ ] 实现 `DivinationTech` 接口（id / meta / buildPage）
> - [ ] 在 `divination_registry.dart` 注册一行
> - [ ] TechMeta 含 sortOrder / accentColor / displayName 等

---

## 任务分解 Task Breakdown

| 子任务 Sub-task | 描述 Description | 预估 Estimate | 状态 Status |
|---------------|---------------|--------------|-----------|
| 1 | | | □ 待开始 |
| 2 | | | □ 待开始 |
| 3 | | | □ 待开始 |

---

## 测试与验证 Testing & Verification

### 自测清单 Self-test Checklist

- [ ] Android 端功能验证
- [ ] Windows 桌面端功能验证（若适用）
- [ ] 深色/浅色主题切换验证
- [ ] 动效开关关闭后功能正常
- [ ] 历史记录写入/读取正常（若涉及）

### 已知问题 Known Issues

| 问题 Issue | 影响 Impact | 后续计划 Plan |
|----------|-----------|------------|
| | | |

---

## 完成确认 Completion Confirmation

| 字段 Field | 内容 Content |
|----------|-----------|
| **完成日期 Completion Date** | YYYY-MM-DD |
| **实际工时 Actual Effort** | 小时/天 |
| **构建版本 Build Version** | vX.Y.Z+NN |
| **commit hash** | |
| **flutter analyze** | □ 0 issue |
| **产物归档 Archived** | □ APK □ Windows ZIP |

---

## 备注 Notes

> 其他需要说明的事项。

---

**任务单结束 End of Work Order**

志极 Jeenith · 志于本心，知于极处
