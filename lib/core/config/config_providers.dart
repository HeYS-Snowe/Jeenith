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
    );
  }

  Future<void> setShowDetails(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDetails', v);
    state = AsyncData(state.valueOrNull!.copyWith(showDetails: v));
  }

  Future<void> setUseOnline(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useOnline', v);
    state = AsyncData(state.valueOrNull!.copyWith(useOnline: v));
  }
}
