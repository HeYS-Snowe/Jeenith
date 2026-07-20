# 频发 BUG · GoldButton 竖线坍塌

> **类型**：UI 渲染 / 约束坍塌
> **严重等级**：P0（阻断核心功能）
> **首次出现**：v2.3.0
> **最新一次修复**：v2.10.0（2026-07-20，第三次"根治"）
> **复用次数**：3 次（v2.3.1 / v2.7.1 / v2.10.0）

## 一、现象

周易卜算术页面（`features/zhouyi/ui/zhouyi_page.dart`）的「起卦」按钮在 SliverPersistentHeader + DraggableScrollableSheet 嵌套场景下偶发"坍塌为一条竖线"：

- 按钮宽度坍塌为 1-2px，文字被截断不可见
- 高度方向正常，按钮看似"一条竖线"
- 主要在周易页面出现，但任何使用 GoldButton + Expanded + SliverPersistentHeader 组合的页面都有风险

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

## 三、三次"根治"历史

### v2.3.1 · 局部修复（小六壬）
- **方案**：`SizedBox(width: 88, child: GoldButton(...))` 强制宽度
- **效果**：小六壬页面修好，但其他页面仍可能出现
- **不足**：每个调用点都要手动加 SizedBox，治标不治本

### v2.7.1 · 全局"根治"
- **方案**：在 GoldButton 内部统一加 `SizedBox(width: double.infinity, child: box)`
- **效果**：在 tight 约束下（Row + Expanded）撑满父级
- **不足**：在 loose 约束下（SliverPersistentHeader + DraggableScrollableSheet）仍会坍塌

### v2.10.0 · 终极方案（ConstrainedBox 三重防护）
- **方案**：
  ```dart
  final expandedBox = ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 88, maxWidth: double.infinity),
    child: SizedBox(width: double.infinity, child: box),
  );
  ```
- **三层防护**：
  1. **tight 约束下**（Row + Expanded）：SizedBox(width: double.infinity) 撑满父级宽度
  2. **loose 约束下**（SliverPersistentHeader）：ConstrainedBox 强制 minWidth=88
  3. **unbounded 约束下**：fallback 到 minWidth=88，避免 panic
- **验证**：flutter analyze 0 issue，周易/小六壬/所有页面起卦按钮正常

## 四、复用排查清单

当再次出现"按钮变竖线"类问题时，按以下顺序排查：

1. **检查 GoldButton/DarkButton 内部约束**
   - 确认 `ConstrainedBox(minWidth: 88/72, maxWidth: double.infinity)` 仍在
   - 确认 `SizedBox(width: double.infinity, child: box)` 仍在
   - 没有被某次重构误删

2. **检查调用点约束链**
   - 父级是否是 `Expanded` / `Flexible`（提供 tight 约束）
   - 是否在 `SliverPersistentHeader` 内（loose 约束）
   - 是否在 `DraggableScrollableSheet` 内（loose 约束）
   - 是否在 `ListView` / `Column` 的非 Expanded 子节点中（unbounded）

3. **检查 _PinHeaderDelegate extent 一致性**
   - `minExtent == maxExtent == child minHeight`
   - 否则 paintExtent < layoutExtent 会导致 viewport paint 空指针崩溃（这是另一个高频 BUG，已通过 minHeight = 90 / 200 解决）

4. **Transform.scale 是否包裹了 ConstrainedBox**
   - 必须是 `Transform.scale(child: ConstrainedBox(...))` 而非 `ConstrainedBox(child: Transform.scale(...))`
   - 顺序错误会导致 ConstrainedBox 的 minWidth 在 Transform.scale 测量阶段被忽略

## 五、相关代码位置

- GoldButton：[mobile/lib/shared/widgets/gold_button.dart](../../mobile/lib/shared/widgets/gold_button.dart)
- DarkButton：[mobile/lib/shared/widgets/dark_button.dart](../../mobile/lib/shared/widgets/dark_button.dart)
- 触发页面：[mobile/lib/features/zhouyi/ui/zhouyi_page.dart](../../mobile/lib/features/zhouyi/ui/zhouyi_page.dart) `_buildActionBar`
- 触发页面：[mobile/lib/features/xiaoliuren/ui/xiaoliuren_page.dart](../../mobile/lib/features/xiaoliuren/ui/xiaoliuren_page.dart) `_buildActionBar`

## 六、预防措施

1. **新增按钮组件时**：
   - 必须在内部包裹 `ConstrainedBox(constraints: BoxConstraints(minWidth: 72-88, maxWidth: double.infinity), child: SizedBox(width: double.infinity, child: ...))`
   - 不可仅依赖 `SizedBox(width: double.infinity)` 单层防护

2. **新增使用 SliverPersistentHeader 的页面时**：
   - `_PinHeaderDelegate` 的 `minExtent == maxExtent == child minHeight`
   - 不要在 delegate child 内嵌 DraggableScrollableSheet（这是已知 loose 约束来源）

3. **代码审查重点**：
   - 任何对 GoldButton / DarkButton 的内部结构修改必须保留 ConstrainedBox + SizedBox 双层防护
   - 任何对 Transform.scale 的包裹顺序修改必须经人工验证周易/小六壬起卦按钮在两种主题模式下均正常

## 七、版本演进时间线

| 版本 | 日期 | 修复策略 | 效果 |
|------|------|----------|------|
| v2.3.0 | 2026-07-13 | （首次出现） | BUG 出现 |
| v2.3.1 | 2026-07-14 | 小六壬局部 SizedBox(width: 88) | 仅小六壬修好 |
| v2.7.1 | 2026-07-17 | 全局 SizedBox(width: double.infinity) | 短期修好，再次复发 |
| v2.10.0 | 2026-07-20 | ConstrainedBox 三重防护 | 终极方案，预期不再复发 |

---

**最后一次更新**：2026-07-20
**维护人**：Trae
