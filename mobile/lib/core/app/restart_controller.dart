// Copyright (c) 2026 Qore
import 'package:flutter/foundation.dart';

/// 应用级重启控制器（v2.11.0）。
///
/// 「清除数据 / 归零重始 / 还原初设」执行完毕后调用 [restart]，会使根
/// widget 以新 key 重建 [ProviderScope]，所有 Riverpod 状态从已更新的
/// SharedPreferences 重新初始化——等价于"重启应用"。
///
/// 仅重建 widget 树，不重新执行 main()（64 卦预加载等一次性初始化无需重复）。
class RestartController extends ValueNotifier<int> {
  RestartController._() : super(0);
  static final RestartController instance = RestartController._();

  /// 触发一次应用级重启（重建 ProviderScope）。
  void restart() => value++;
}
