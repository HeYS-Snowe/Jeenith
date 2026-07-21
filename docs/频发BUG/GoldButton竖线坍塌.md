# 频发 BUG · GoldButton 竖线坍塌

> **类型**：UI 渲染 / 约束坍塌
> **严重等级**：P0（阻断核心功能）
> **首次出现**：v2.3.0
> **最新一次修复**：v2.10.3（2026-07-22，第五次根治，布局重构 + 防御层）
> **复用次数**：5 次（v2.3.1 / v2.7.1 / v2.10.0 / v2.10.1 / v2.10.3）

## 一、现象

周易卜算术页面（`features/zhouyi/ui/zhouyi_page.dart`）的「起卦」按钮在 SliverPersistentHeader + DraggableScrollableSheet 嵌套场景下偶发"坍塌为一条竖线"：

- 按钮宽度坍塌为 1-2px，文字被截断不可见
- 高度方向正常，按钮看似"一条竖线"
- 主要在周易页面出现，但任何使用 GoldButton + Expanded + SliverPersistentHeader 组合的页面都有风险

**v2.10.0 引入新现象**：按钮不再坍塌为竖线，而是反向"撑满整个 Row 剩余宽度"，导致 Row 后续按钮（DarkButton / CopyResultButton / ShareResultButton）无空间而全部消失；DarkButton 在 Wrap 中同样失去宽度约束，撑满整行。详见第三节 v2.10.0 / v2.10.1 修正历史。

**v2.10.1 后第 5 次复发（v2.10.3 修复）**：v2.10.1 的 `ConstrainedBox(minWidth:88)` 单层结构在 tight(W<88) 矛盾约束场景下仍会坍塌为竖线。根因是周易 _buildActionBar 单行 4 按钮的总 minWidth（404px）在 320-411px 屏幕超过可用宽度，Expanded 给 GoldButton 的 width < 88 触发矛盾约束。详见第三节 v2.10.3 修复历史。

## 二、根因

### 表层根因
GoldButton 内部使用 `Transform.scale` 包裹子节点以实现按压缩放动画。`RenderTransform` 在测量阶段不改变传入约束，但在某些 loose 约束场景下（尤其是 `SliverPersistentHeader` 内嵌 `DraggableScrollableSheet`），父级会传入 `BoxConstraints(minWidth: 0, maxWidth: infinity)` 形式的 loose 约束，导致子节点 intrinsic width = 0，进而坍塌为竖线。

### 深层根因
1. **Expanded 不传递 tight 约束到 SliverPersistentHeader**
   `SliverPersistentHeader` 的 delegate 通过 `_PinHeaderDelegate.minExtent/maxExtent` 提供 extent，但 delegate 内 child 拿到的是 `BoxConstraints.tight(height)` + `BoxConstraints.loose(width)` 的混合约束。
2. **Transform.scale 不参与 intrinsic 计算**
   RenderTransform 在 performLayout 中将传入 constraints 直接转发给 child，但 child 的 intrinsic 计算依赖外部 Expanded 传递的 tight 宽度。当上层是 loose 约束时，Transform.scale 不主动撑满。
3. **SizedBox(width: double.infinity) 在 loose 约束下也失效**
   v2.7.1 尝试用 `SizedBox(width: double.infinity, child: box)` 想在 tight 约束下撑满父级。但 `SizedBox(width: double.infinity)` 在 loose(maxWidth: inf, minWidth: 0) 约束下会试图强制 child width = inf，导致 panic 或 fallback 到 0。
4. **v2.10.0 错误：ConstrainedBox + SizedBox(width:inf) 双层嵌套反向放大 BUG**
   `ConstrainedBox(minWidth:88, maxWidth:inf) + SizedBox(width:inf)` 在 loose(maxWidth=W) 下：
   - ConstrainedBox enforce 后传给 child (minWidth:88, maxWidth:W)
   - SizedBox(width:inf) 收到 (minWidth:88, maxWidth:W) → enforce → minWidth=clamp(88, inf, inf)=inf, maxWidth=clamp(W, inf, inf)=inf（W < inf 返回 lower=inf）→ child 收到 tight(inf)
   - box.size = (inf, h)，SizedBox.size = (inf, h)
   - ConstrainedBox.size = clamp(inf, 0, W) = W → **强制撑满整个 Row 剩余宽度**
   - 结果：Row 后续按钮无空间，全部消失；DarkButton 在 Wrap 中同样撑满整行
5. **v2.10.1 盲点：tight(W<88) 矛盾约束场景**（v2.10.3 第 5 次复发根因）
   v2.10.1 的 `ConstrainedBox(minWidth:88)` 单层结构在以下场景失效：
   - 父级 Expanded 在窄屏给 GoldButton 的 width = 可用宽度 - 其他按钮 minWidth 之和 < 88
   - 周易 _buildActionBar 4 按钮单行排列，非弹性子节点 minWidth 之和（重置82 + 复制105 + 分享105 + 3×SizedBox24 ≈ 316px）在 320px 屏（可用 288px）已溢出，Expanded 拿到 freeSpace = 288 - 316 = -28，clamp 为 0
   - GoldButton 内 `ConstrainedBox(minWidth:88).enforce(tight(0))`：
     - child 收到 `tight(clamp(0,88,inf)=88)` —— child 渲染 88 宽
     - 但 `ConstrainedBox.size = constraints.constrainDimensions(88,h) = clamp(88,0,0) = 0`
     - ConstrainedBox 向 Expanded 汇报 size=0，但 child 实际 paint 88 宽 → painting 与 layout 不一致
     - release 模式 assert 跳过，最终 paint 被父级 clip/降级为竖线
   - **结论**：v2.10.1 的 minWidth 兜底在矛盾约束下反而加剧坍塌，因为 enforce 把 child 撑到 88 但 size 被 parent clamp 回 0，造成 size=0 / child=88 的撕裂

## 三、五次"根治"历史

### v2.3.1 · 局部修复（小六壬）
- **方案**：`SizedBox(width: 88, child: GoldButton(...))` 强制宽度
- **效果**：小六壬页面修好，但其他页面仍可能出现
- **不足**：每个调用点都要手动加 SizedBox，治标不治本

### v2.7.1 · 全局"根治"
- **方案**：在 GoldButton 内部统一加 `SizedBox(width: double.infinity, child: box)`
- **效果**：在 tight 约束下（Row + Expanded）撑满父级
- **不足**：在 loose 约束下（SliverPersistentHeader + DraggableScrollableSheet）仍会坍塌

### v2.10.0 · 错误方案（ConstrainedBox 三重防护，引发新 BUG）
- **方案**：
  ```dart
  final expandedBox = ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 88, maxWidth: double.infinity),
    child: SizedBox(width: double.infinity, child: box),
  );
  ```
- **预期三层防护**：tight 下撑满 / loose 下 minWidth 兜底 / unbounded 下取 88
- **实际效果**：v2.10.0 发布后用户反馈周易所有按钮消失，小六壬 DarkButton 失去宽度约束
- **根因**：见第二节深层根因 4。ConstrainedBox + SizedBox(width:inf) 双层嵌套在 loose(maxWidth=W) 下让 box.size=inf，外层 ConstrainedBox.size=clamp(inf, 0, W)=W，强制撑满 Row 剩余宽度
- **教训**：双层嵌套约束叠加反而放大 BUG，不是越复杂越保险

### v2.10.1 · 简化方案（仅 ConstrainedBox(minWidth)）
- **方案**：
  ```dart
  final expandedBox = ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 88),  // 不带 maxWidth，不带 SizedBox
    child: box,
  );
  ```
- **三场景验证**：
  1. **tight(W) 下**（Row + Expanded / SizedBox(width:88) 包裹）：ConstrainedBox enforce → tight(W)，box 撑满 W ✓
  2. **loose(maxWidth=W) 下**（Wrap / Row 非 Expanded 子节点）：ConstrainedBox enforce → (minWidth:88, maxWidth:W)，box 按 intrinsic 测量，minWidth 兜底 ✓
  3. **loose unbounded(maxWidth=inf) 下**（SliverPersistentHeader + DraggableScrollableSheet）：ConstrainedBox enforce → (minWidth:88, maxWidth:inf)，box 按 intrinsic 测量，minWidth 兜底，不再坍塌为竖线 ✓
- **关键差异**：去掉 `maxWidth:double.infinity`（避免与 SizedBox(width:inf) 叠加放大 BUG），去掉 `SizedBox(width:inf)`（避免在 loose 下强制 child=inf）
- **验证**：flutter analyze 0 issue
- **盲点**：三场景验证遗漏了 tight(W<88) 矛盾约束场景（见第二节深层根因 5）

### v2.10.3 · 布局重构 + 防御层（第五次根治）
- **方案**：双层修复
  1. **布局层（周易 _buildActionBar）**：单行 4 按钮改为「FittedBox(scaleDown) + 居中」
     - 弃用 `Expanded(GoldButton)`（这是 v2.10.1 矛盾约束的直接来源）
     - 4 按钮（摇卦 / 重置 / 复制 / 分享）按 intrinsic 宽度并排（`Row(mainAxisSize: min)`），外层 `Center + FittedBox(fit: scaleDown, alignment: center)`：
       - 大屏（≥480px）：4 按钮 intrinsic 总宽 < 可用宽，原尺寸居中，左右留白
       - 小屏（<480px）：4 按钮 intrinsic 总宽 > 可用宽，整体等比缩小到一行容纳，无溢出
     - **不用 `SingleChildScrollView` 横向滚动**：嵌套 viewport（`_RenderSingleChildViewport`）放在 `pinned SliverPersistentHeader` 内会导致 hit test 时 `sliver.geometry` 为 null，抛 `Null check operator used on a null value` 崩溃（viewport.dart:886）
     - 参照 meihua/jiaobei 的 GoldButton 直接调用模式（不包 Expanded）
     - 同步 _PinHeaderDelegate extent 90 → 104 → 90（最终单行），Container minHeight 90
  2. **防御层（GoldButton 内部）**：LayoutBuilder 检测 tight(maxWidth<88) 矛盾约束
     ```dart
     final expandedBox = LayoutBuilder(
       builder: (context, constraints) {
         final isContradiction = constraints.maxWidth.isFinite &&
             constraints.maxWidth < 88 &&
             constraints.minWidth == constraints.maxWidth; // tight 约束
         if (isContradiction) {
           // 降级：放弃 minWidth:88 强制，按可用宽度渲染 box
           return box;
         }
         return ConstrainedBox(
           constraints: const BoxConstraints(minWidth: 88),
           child: box,
         );
       },
     );
     ```
     - 矛盾时放弃 minWidth:88 强制，直接按可用宽度渲染 box
     - 按钮文字可能裁剪，但按钮本体可见可点击，不再坍塌为竖线
     - 仅矛盾约束触发，其他 14 个调用点行为不变（tight≥88 / loose / unbounded 均走原 ConstrainedBox 分支）
- **DarkButton 不动**：v2.10.2 AnimatedSwitcher 文字过渡动画保持
- **桌面端**：_buildActionBar 移动/桌面共用，单行居中布局在 ≥600px 窗口视觉正常
- **验证**：flutter analyze 0 issue

## 四、复用排查清单

当再次出现"按钮变竖线"或"按钮撑满 Row"类问题时，按以下顺序排查：

1. **检查 GoldButton/DarkButton 内部约束**
   - 确认是 `LayoutBuilder(builder: ...)` 包裹的防御层结构（v2.10.3+）
   - LayoutBuilder 内部对非矛盾约束走 `ConstrainedBox(constraints: BoxConstraints(minWidth: 88/72), child: box)` 单层结构
   - **不应有** `maxWidth: double.infinity`（v2.10.0 错误方案）
   - **不应有** `SizedBox(width: double.infinity, child: box)` 包裹（v2.7.1 / v2.10.0 错误方案）

2. **检查调用点约束链**
   - 父级是否是 `Expanded` / `Flexible`（提供 tight 约束）
   - 是否在 `SliverPersistentHeader` 内（loose 约束）
   - 是否在 `DraggableScrollableSheet` 内（loose 约束）
   - 是否在 `ListView` / `Column` 的非 Expanded 子节点中（unbounded）
   - **关键**：单行 Row 中所有非弹性子节点 minWidth 之和 + GoldButton(88) 是否超过最小目标屏可用宽度（320-32=288px）

3. **检查 _PinHeaderDelegate extent 一致性**
   - `minExtent == maxExtent == child minHeight`
   - v2.10.3 后周易 extent=90（单行按钮高度）
   - 否则 paintExtent < layoutExtent 会导致 viewport paint 空指针崩溃

4. **Transform.scale 是否包裹了 ConstrainedBox**
   - 必须是 `Transform.scale(child: LayoutBuilder(...))` 而非 `LayoutBuilder(child: Transform.scale(...))`
   - 顺序错误会导致 LayoutBuilder 拿不到正确的 parent constraints

## 五、相关代码位置

- GoldButton：[mobile/lib/shared/widgets/gold_button.dart](../../mobile/lib/shared/widgets/gold_button.dart)
- DarkButton：[mobile/lib/shared/widgets/dark_button.dart](../../mobile/lib/shared/widgets/dark_button.dart)
- 触发页面：[mobile/lib/features/zhouyi/ui/zhouyi_page.dart](../../mobile/lib/features/zhouyi/ui/zhouyi_page.dart) `_buildActionBar`
- 参考布局：[mobile/lib/features/meihua/ui/meihua_page.dart](../../mobile/lib/features/meihua/ui/meihua_page.dart) CopyResultButton + ShareResultButton 两 Expanded 并排
- 参考布局：[mobile/lib/features/jiaobei/ui/jiaobei_page.dart](../../mobile/lib/features/jiaobei/ui/jiaobei_page.dart) 同上

## 六、预防措施

1. **新增按钮组件时**：
   - 内部包裹 `LayoutBuilder(builder: ...)` 防御层 + `ConstrainedBox(constraints: BoxConstraints(minWidth: 72-88), child: box)` 单层结构
   - **不要**叠加 `maxWidth: double.infinity`
   - **不要**叠加 `SizedBox(width: double.infinity, child: box)`
   - 双层嵌套（v2.10.0 方案）反而放大 BUG

2. **新增使用 SliverPersistentHeader 的页面时**：
   - `_PinHeaderDelegate` 的 `minExtent == maxExtent == child minHeight`
   - 不要在 delegate child 内嵌 DraggableScrollableSheet（这是已知 loose 约束来源）

3. **代码审查重点**：
   - 任何对 GoldButton / DarkButton 的内部结构修改必须保留 LayoutBuilder 防御层 + ConstrainedBox(minWidth) 单层防护
   - 任何对 Transform.scale 的包裹顺序修改必须经人工验证周易/小六壬起卦按钮在两种主题模式下均正常
   - **警惕"加层"思维**：不是越多约束越好，多余的 maxWidth/双层嵌套会反向放大 BUG

4. **周易类多按钮 ActionBar 布局原则**（v2.10.3 教训）
   - 单行非弹性子节点 minWidth 之和必须 < 最小目标屏可用宽度（320-32=288px）
   - 超出时优先用「`FittedBox(fit: scaleDown)` + 居中」方案：大屏原尺寸居中留白、小屏整体等比缩放到一行容纳，不触发矛盾约束
   - **不要**用 `Expanded(GoldButton)`：Expanded 在窄屏会给 GoldButton 传 tight(W<88) 矛盾约束
   - **不要**在 `pinned SliverPersistentHeader` 内嵌 `SingleChildScrollView`（任意轴向）：嵌套 viewport 会导致 hit test 时 `sliver.geometry` 为 null，抛 `Null check operator used on a null value` 崩溃（viewport.dart:886）
   - _PinHeaderDelegate extent 必须同步 child minHeight（单行≈90）

5. **GoldButton 防御层不可移除**
   - LayoutBuilder 矛盾检测是第 5 次复发的教训，移除后任何误用 Expanded(GoldButton) 都会复发竖线
   - 即使所有现有调用点都正确（如 v2.10.3 后周易已改单行 + FittedBox 缩放），防御层仍需保留作为未来误用的兜底

## 七、版本演进时间线

| 版本 | 日期 | 修复策略 | 效果 |
|------|------|----------|------|
| v2.3.0 | 2026-07-13 | （首次出现） | BUG 出现 |
| v2.3.1 | 2026-07-14 | 小六壬局部 SizedBox(width: 88) | 仅小六壬修好 |
| v2.7.1 | 2026-07-17 | 全局 SizedBox(width: double.infinity) | 短期修好，再次复发 |
| v2.10.0 | 2026-07-20 | ConstrainedBox 三重防护（错误方案） | 反向放大：按钮撑满 Row，周易所有按钮消失 |
| v2.10.1 | 2026-07-21 | 简化方案：仅 ConstrainedBox(minWidth: 88) | 修正 v2.10.0 错误，但遗漏 tight(W<88) 矛盾约束场景 |
| v2.10.3 | 2026-07-22 | 布局重构（单行 + FittedBox 缩放）+ GoldButton LayoutBuilder 矛盾防御 | 周易 320px 不再坍塌；防御层防未来复发 |

---

**最后一次更新**：2026-07-22
**维护人**：Trae
