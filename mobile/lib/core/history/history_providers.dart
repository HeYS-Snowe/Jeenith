// Copyright (c) 2026 Qore
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'history_store.dart';

/// 待恢复的历史记录（v2.4.3「预览恢复卦象」功能）。
///
/// 历史页「恢复」按钮设置此项后跳转到对应术 page；该 page 在 initState
/// 读取并消费（按 [HistoryEntry.extra] 预填输入 + 重建卦象展示，不重新入历史），
/// 随后清空为 null。
///
/// 各术 page 消费约定：仅在 `entry.techId == 本术 id` 且 extra schema 匹配时恢复。
final pendingRestoreProvider = StateProvider<HistoryEntry?>((ref) => null);
