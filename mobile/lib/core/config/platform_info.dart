// Copyright (c) 2026 Qore
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// 设备大类 —— 决定交互范式（触摸拖拽 / 鼠标滚动）。
enum DeviceFamily { mobile, desktop, web }

/// 平台检测（运行时一次性判定，全 app 共用）。
///
/// 基于 foundation 的 [defaultTargetPlatform] + [kIsWeb]，不依赖 dart:io，
/// 以便未来 Web 端也能复用。功能与参数据此切换：
/// - **mobile**（Android/iOS）：触摸交互、DraggableScrollableSheet 拖拽、触摸轨迹熵源
/// - **desktop**（Windows/macOS/Linux）：鼠标滚轮、分栏布局、鼠标轨迹熵源（hover 采样）
/// - **web**：暂按 mobile 范式（可按需细化）
class PlatformInfo {
  PlatformInfo._();

  /// 设备大类。
  static final DeviceFamily family = _detectFamily();

  /// 细分平台标识（展示用）：Android / iOS / Windows / macOS / Linux / Web。
  static final String label = _detectLabel();

  static bool get isMobile => family == DeviceFamily.mobile;
  static bool get isDesktop => family == DeviceFamily.desktop;
  static bool get isWeb => kIsWeb;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  static DeviceFamily _detectFamily() {
    if (kIsWeb) return DeviceFamily.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return DeviceFamily.mobile;
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        return DeviceFamily.desktop;
    }
  }

  static String _detectLabel() {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }
}
