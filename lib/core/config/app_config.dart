// Copyright (c) 2026 Qore. All rights reserved.

/// 应用配置（真随机熵源开关 + 展示开关）。
class AppConfig {
  final bool showDetails; // 起卦后展示采样详情
  final bool useOnline;   // 在线大气噪声 random.org

  const AppConfig({required this.showDetails, required this.useOnline});

  static const defaults = AppConfig(showDetails: true, useOnline: true);

  AppConfig copyWith({bool? showDetails, bool? useOnline}) => AppConfig(
        showDetails: showDetails ?? this.showDetails,
        useOnline: useOnline ?? this.useOnline,
      );
}
