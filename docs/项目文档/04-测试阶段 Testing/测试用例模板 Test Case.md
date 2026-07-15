# 测试用例模板 Test Case Template

## 文档信息 Document Information

| 项目 Item | 内容 Content |
|---------|-------------|
| 项目名称 Project | 志极 Jeenith |
| 当前版本 Current Version | 2.3.3+23 |
| 文档版本 Document Version | v1.0.0 |
| 创建日期 Created Date | 2026-07-15 |
| 适用范围 Scope | 12 种卜算术 + 真随机引擎 + 动效体系 + 跨平台 |

---

## 一、用例编号规则 Naming Convention

```
TC-{模块}-{3 位序号}
```

| 模块代码 Module | 模块名称 |
|---------------|---------|
| XLR | 小六壬 Xiaoliuren |
| ZY  | 周易 Zhouyi |
| MH  | 梅花易数 Meihua |
| JB  | 掷筊 Jiaobei |
| ZW  | 紫微斗数 Ziwei |
| QM  | 奇门遁甲 Qimen |
| CQ  | 抽签 Chouqian |
| CZ  | 测字 Cezi |
| DLR | 大六壬 Daliuren |
| LP  | 风水罗盘 Luopan |
| BZ  | 八字推演 Bazi |
| NT  | 测名字 NameTest |
| RNG | 真随机引擎 TrueRandom |
| ANI | 动效体系 Animation |
| UX  | 跨平台与共享组件 |
| HIST | 历史 HistoryStore |
| CFG | 配置 AppConfig |

---

## 二、用例字段定义 Field Definition

| 字段 Field | 说明 Description |
|-----------|----------------|
| 用例编号 ID | 唯一标识，遵循命名规则 |
| 用例标题 Title | 简明描述被测行为 |
| 优先级 Priority | P0（阻塞）/ P1（关键）/ P2（一般）/ P3（次要） |
| 模块 Module | 见上表 |
| 前置条件 Precondition | 用例执行前必须满足的条件 |
| 测试步骤 Steps | 编号步骤，可复现 |
| 预期结果 Expected | 每步对应的预期行为 |
| 测试数据 Test Data | 输入数据（如生辰、字、签号） |
| 平台 Platform | Android / Windows / Both |
| 类型 Type | 功能 / 性能 / 兼容 / 安全 / 探索 |
| 状态 Status | Not Run / Pass / Fail / Blocked |
| 实际结果 Actual | 执行后填写 |
| 执行人 Executor | 姓名或 ID |
| 执行日期 Date | YYYY-MM-DD |
| 关联 Bug | BUG-NNN（如有） |

---

## 三、模板 Template

### TC-{MODULE}-001 | {Title}

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-{MODULE}-001 |
| 优先级 Priority | P0 |
| 模块 Module | — |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | App 已启动到首页 |
| 测试数据 Test Data | — |
| 测试步骤 Steps | 1. ...<br>2. ...<br>3. ... |
| 预期结果 Expected | 1. ...<br>2. ...<br>3. ... |
| 状态 Status | Not Run |
| 实际结果 Actual | |
| 执行人 Executor | |
| 执行日期 Date | |
| 关联 Bug | |

---

## 四、示例用例 Sample Cases

### TC-RNG-001 | 多源 SHA256 混合输出范围 [1, 9] 边界

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-RNG-001 |
| 优先级 Priority | P0 |
| 模块 Module | RNG |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 网络可达 random.org；App 配置 useOnline=true，showDetails=true |
| 测试数据 Test Data | count=3, vmax=9 |
| 测试步骤 Steps | 1. 进入小六壬页面<br>2. 触发起卦（输入 3 个时辰）<br>3. 展开采样详情面板 |
| 预期结果 Expected | 1. 起卦按钮响应<br>2. 仪式动画播放后展示 3 个数字<br>3. 三个数字均在 [1, 9] 范围内；详情面板列出 3 个熵源（系统熵 / 触摸轨迹 / random.org）的 display 文本与 succeeded 标记 |
| 状态 Status | Not Run |
| 实际结果 Actual | |
| 执行人 Executor | |
| 执行日期 Date | |
| 关联 Bug | |

---

### TC-RNG-002 | 在线熵源不可用时降级到系统熵+触摸

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-RNG-002 |
| 优先级 Priority | P0 |
| 模块 Module | RNG |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 断开网络（飞行模式）；useOnline=true |
| 测试数据 Test Data | 任意起卦 |
| 测试步骤 Steps | 1. 进入周易页面<br>2. 触发起卦<br>3. 查看采样详情 |
| 预期结果 Expected | 1. random.org 源显示「采样失败」或「未启用 / 不可用」，succeeded=false<br>2. 系统熵 + 触摸轨迹 succeeded=true<br>3. 起卦仍能完成，结果在合法范围内<br>4. 不抛未捕获异常 |
| 状态 Status | Not Run |

---

### TC-RNG-003 | χ² 均匀性检验（N=10000）

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-RNG-003 |
| 优先级 Priority | P1 |
| 模块 Module | RNG |
| 类型 Type | 性能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 单元测试环境 |
| 测试数据 Test Data | count=1, vmax=9，循环 10000 次 |
| 测试步骤 Steps | 1. 调用 TrueRandom.generate 10000 次<br>2. 统计 1-9 各值频次<br>3. 计算 χ² 统计量，自由度 8 |
| 预期结果 Expected | 1. 总样本数 = 10000<br>2. 每个值频次在 [1000 ± 200] 区间内<br>3. χ² < 15.51（p > 0.05，0.05 显著性水平下接受均匀分布假设） |
| 状态 Status | Not Run |

---

### TC-ZY-001 | 周易 64 卦生成与卦辞匹配

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-ZY-001 |
| 优先级 Priority | P0 |
| 模块 Module | ZY |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 周易数据文件 `data/yijing/` 已加载 |
| 测试数据 Test Data | 三次摇卦模拟输入：[6,7,8,9,7,8] |
| 测试步骤 Steps | 1. 进入周易页面<br>2. 触发起卦（使用固定输入）<br>3. 查看本卦、变卦、卦辞、动爻爻辞 |
| 预期结果 Expected | 1. 本卦 = 第 X 卦（按固定输入手工核对）<br>2. 动爻数量正确（9 老阳为动，6 老阴为动）<br>3. 卦辞与 `data/yijing/` 数据一致<br>4. 动爻爻辞匹配 |
| 状态 Status | Not Run |

---

### TC-XLR-001 | 小六壬六宫映射正确

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-XLR-001 |
| 优先级 Priority | P0 |
| 模块 Module | XLR |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 测试数据 Test Data | 月=3, 日=15, 时=7（辰时） |
| 测试步骤 Steps | 1. 进入小六壬页面<br>2. 输入月、日、时<br>3. 触发起卦<br>4. 查看落宫 |
| 预期结果 Expected | 落宫 = 大安/留连/速喜/赤口/小吉/空亡 六宫之一，计算路径与 `features/xiaoliuren/algorithm/divine.dart` 一致 |
| 状态 Status | Not Run |

---

### TC-ZW-001 | 紫微斗数命盘安星

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-ZW-001 |
| 优先级 Priority | P0 |
| 模块 Module | ZW |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 测试数据 Test Data | 农历 1990-05-15 子时 男 |
| 测试步骤 Steps | 1. 进入紫微页面<br>2. 输入生辰<br>3. 触发起卦<br>4. 检查 12 宫、紫微星系、天府星系位置 |
| 预期结果 Expected | 1. 命宫位置正确（用 lunar 库校验）<br>2. 紫微星定位与经典公式一致<br>3. 主副煞星无遗漏<br>4. StarChartPainter 渲染无报错 |
| 状态 Status | Not Run |

---

### TC-LP-001 | 风水罗盘磁力计方位角

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-LP-001 |
| 优先级 Priority | P0 |
| 模块 Module | LP |
| 类型 Type | 功能 |
| 平台 Platform | Android |
| 前置条件 Precondition | 真机有磁力计；权限已授予 |
| 测试步骤 Steps | 1. 进入风水罗盘页面<br>2. 缓慢旋转设备 360°<br>3. 观察罗盘指针响应<br>4. 比对与外部指南针读数 |
| 预期结果 Expected | 1. 指针平滑跟随设备朝向<br>2. 24 山向映射正确<br>3. 偏差 ≤ ±5°（与外部指南针比对）<br>4. 退出页面后传感器流关闭（无后台耗电） |
| 状态 Status | Not Run |

---

### TC-LP-002 | Windows 桌面无磁力计时罗盘降级

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-LP-002 |
| 优先级 Priority | P1 |
| 模块 Module | LP |
| 类型 Type | 兼容 |
| 平台 Platform | Windows |
| 前置条件 Precondition | Windows 桌面无磁力计硬件 |
| 测试步骤 Steps | 1. 进入风水罗盘页面 |
| 预期结果 Expected | 1. 不崩溃<br>2. 显示提示「设备无磁力计，请使用 Android 真机」或允许手动拖动罗盘<br>3. 退出无残留 |
| 状态 Status | Not Run |

---

### TC-ANI-001 | AnimationKind.entrance 开关独立生效

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-ANI-001 |
| 优先级 Priority | P1 |
| 模块 Module | ANI |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 设置页可访问 |
| 测试步骤 Steps | 1. 进入设置页<br>2. 将「入场仪式」entrance 开关关闭，其它 3 类保持开启<br>3. 进入周易起卦<br>4. 观察仪式动画与结果揭示动画 |
| 预期结果 Expected | 1. 入场仪式动画不播放，直接进入结果阶段<br>2. 结果揭示（reveal）动画仍正常播放<br>3. AppConfig 持久化生效，重启 App 后状态保留 |
| 状态 Status | Not Run |

---

### TC-ANI-002 | animationsEnabled 总开关优先级

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-ANI-002 |
| 优先级 Priority | P1 |
| 模块 Module | ANI |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 测试步骤 Steps | 1. 总开关关闭<br>2. 各分项开关保持开启<br>3. 触发任意起卦 + 路由跳转 |
| 预期结果 Expected | 1. 所有动效（入场/转场/绘制/揭示）全部不播放<br>2. App 仍可正常使用<br>3. 设置页总开关 UI 与持久化状态一致 |
| 状态 Status | Not Run |

---

### TC-UX-001 | 跨平台起卦 UX 一致性

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-UX-001 |
| 优先级 Priority | P1 |
| 模块 Module | UX |
| 类型 Type | 兼容 |
| 平台 Platform | Both |
| 测试步骤 Steps | 1. Android 真机起卦一次（触摸）<br>2. Windows 桌面起卦一次（鼠标）<br>3. 对比结果页布局、按钮位置、文字截断 |
| 预期结果 Expected | 1. 两端布局一致，无错位<br>2. Windows 窗口最小尺寸下不出现文字溢出<br>3. 触摸/鼠标交互均能正确触发 RNG 采样 |
| 状态 Status | Not Run |

---

### TC-HIST-001 | HistoryStore 原子读-改-写

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-HIST-001 |
| 优先级 Priority | P0 |
| 模块 Module | HIST |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 前置条件 Precondition | 历史已有 N 条记录 |
| 测试步骤 Steps | 1. 同时触发 5 次连续起卦（短时间内）<br>2. 进入历史页查看记录数 |
| 预期结果 Expected | 1. 历史记录数 = N + 5（无丢失）<br>2. 每条记录时间戳唯一<br>3. 无 JSON 损坏 |
| 状态 Status | Not Run |

---

### TC-CFG-001 | AppConfig 持久化

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-CFG-001 |
| 优先级 Priority | P1 |
| 模块 Module | CFG |
| 类型 Type | 功能 |
| 平台 Platform | Both |
| 测试步骤 Steps | 1. 修改主题为 light<br>2. 关闭 useOnline<br>3. 关闭某术的 painter 动画<br>4. 杀进程重启 App |
| 预期结果 Expected | 1. 重启后主题为 light<br>2. useOnline=false 保留<br>3. 该术的 painter 动画仍为关闭<br>4. shared_preferences 读取无异常 |
| 状态 Status | Not Run |

---

### TC-NT-001 | 测名字五格剖象计算

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-NT-001 |
| 优先级 Priority | P0 |
| 模块 Module | NT |
| 类型 Type | 功能 |
| 测试数据 Test Data | 姓名 = "张三" |
| 测试步骤 Steps | 1. 进入测名字页面<br>2. 输入姓名<br>3. 触发计算<br>4. 检查五格数值 |
| 预期结果 Expected | 1. 天格 / 人格 / 地格 / 外格 / 总格 数值与手工笔画计算一致<br>2. 三才五行匹配正确<br>3. 笔画数据来自 `strokes_data.dart` |
| 状态 Status | Not Run |

---

### TC-BZ-001 | 八字四柱与大运

| 字段 Field | 内容 Content |
|-----------|-------------|
| 用例编号 ID | TC-BZ-001 |
| 优先级 Priority | P0 |
| 模块 Module | BZ |
| 类型 Type | 功能 |
| 测试数据 Test Data | 公历 1990-07-15 14:30 男 |
| 测试步骤 Steps | 1. 进入八字页面<br>2. 输入生辰<br>3. 触发推演<br>4. 检查四柱、十神、大运 |
| 预期结果 Expected | 1. 年柱 / 月柱 / 日柱 / 时柱与 lunar 库计算一致<br>2. 大运起运岁数正确（阳男阴女顺排）<br>3. 十神映射正确 |
| 状态 Status | Not Run |

---

## 五、用例统计汇总 Summary

| 优先级 Priority | 计划数 Planned | 通过 Pass | 失败 Fail | 阻塞 Blocked | 未执行 Not Run |
|---------------|--------------|----------|----------|------------|-------------|
| P0 | — | — | — | — | — |
| P1 | — | — | — | — | — |
| P2 | — | — | — | — | — |
| P3 | — | — | — | — | — |
| **合计 Total** | — | — | — | — | — |

---

## 六、使用说明 Usage Notes

1. **每条用例独立执行**：禁止合并步骤执行，否则定位困难。
2. **失败用例必须挂 BUG**：用例 fail 后，先在 `Bug报告模板 Bug Report.md` 创建 BUG-NNN，再回填到「关联 Bug」字段。
3. **真随机用例不可重复**：由于 RNG 是真随机，结果数值本身不可重现，验证重点是范围、采样源、降级路径，而非具体数值。
4. **传感器用例需真机**：TC-LP-* 必须在带磁力计的 Android 真机执行。
5. **跨平台用例两端都跑**：标 Platform=Both 的用例必须在 Android + Windows 双端各执行一次。
