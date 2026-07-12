// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

final configProvider =
    AsyncNotifierProvider<ConfigNotifier, AppConfig>(ConfigNotifier.new);

class ConfigNotifier extends AsyncNotifier<AppConfig> {
  @override
  Future<AppConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppConfig(
      showDetails: prefs.getBool('showDetails') ?? true,
      useOnline: prefs.getBool('useOnline') ?? true,
      xiaoliurenCinematic: prefs.getBool('xiaoliurenCinematic') ?? true,
    );
  }

  Future<void> setShowDetails(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDetails', v);
    final current = await future;
    state = AsyncData(current.copyWith(showDetails: v));
  }

  Future<void> setUseOnline(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useOnline', v);
    final current = await future;
    state = AsyncData(current.copyWith(useOnline: v));
  }

  Future<void> setXiaoliurenCinematic(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('xiaoliurenCinematic', v);
    final current = await future;
    state = AsyncData(current.copyWith(xiaoliurenCinematic: v));
  }
}
