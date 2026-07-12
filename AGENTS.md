# AGENTS.md — 志极 Jeenith

> 与 CLAUDE.md 同步。身份信息以 `D:\Code\.Rules\OrganizationAndUser.md` 为准。

## 项目

- 中文名/英文名：志极 / Jeenith
- 组织：Qore（叩心）· 包名 `com.qore.jeenith`
- 类型：Flutter 移动 App（Android + Windows 桌面）
- 定位：卜算合集（小六壬/周易/梅花/掷筊/紫微/奇门），可扩展框架
- 位置：`D:\Code\Project\Qore\Jeenith`

## 结构

`mobile/`（Flutter）+ `backend/`（占位）+ `design/`（占位）+ `docs/` + `tools/`（占位）+ `builds/`（归档）。mobile/lib：app.dart + core/ + data/ + features/ + providers/ + router/ + shared/。

## 构建

```bash
cd mobile
flutter pub get && flutter analyze
pwsh -File scripts/build_apk.ps1 -Status release
```

## 规则

- 先看再改
- 身份信息不硬编码（以 OrganizationAndUser.md 为准）
- 加新卜算术 = 新建 features/xxx/ + 实现 DivinationTech + registry 注册
- 构建归档规范见 docs/FLUTTER_APK_BUILD_PIPELINE.md
