// Copyright (c) 2026 Qore
import 'package:shared_preferences/shared_preferences.dart';

import '../history/history_store.dart';

/// 应用持久化数据的集中清除入口（v2.11.0）。
///
/// SharedPreferences 中的 key 分两类：
/// - **设置**（showDetails / useOnline / animationsEnabled / themeMode /
///   anim_*）：由 `ConfigNotifier.resetSettings` 负责。
/// - **数据**（divination_history 卜算历史 / tech_guide_* 各术引导 /
///   hasSeenGuide 首页引导）：由本类负责。
///
/// 「清除数据」按类型选择性清除；「归零重始」清除全部数据。
class AppData {
  static const _guidePrefix = 'tech_guide_';
  static const _hasSeenGuideKey = 'hasSeenGuide';

  /// 当前卜算历史记录条数（清除数据弹窗展示用）。
  static Future<int> historyCount() async => (await HistoryStore.load()).length;

  /// 已触发过的首次使用引导数量（首页 + 各术）。
  static Future<int> guideFlagCount() async {
    final prefs = await SharedPreferences.getInstance();
    var n = 0;
    if (prefs.getBool(_hasSeenGuideKey) ?? false) n++;
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_guidePrefix) && (prefs.getBool(key) ?? false)) n++;
    }
    return n;
  }

  /// 清除卜算历史记录。
  static Future<void> clearHistory() => HistoryStore.clear();

  /// 清除全部使用指引标记（首页 + 各术），清除后相关引导将重新弹出。
  static Future<void> clearGuideFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSeenGuideKey);
    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith(_guidePrefix)) await prefs.remove(key);
    }
  }

  /// 清除全部用户数据（卜算历史 + 引导标记），不动设置。
  static Future<void> clearAllData() async {
    await clearHistory();
    await clearGuideFlags();
  }
}
