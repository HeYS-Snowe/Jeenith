// Copyright (c) 2026 Qore
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Per-tech route transition builders.
///
/// v2.2.0: each divination tech has its own visual language on page entry.
/// All transitions share FadeTransition as the base, then add a signature
/// motion (scale / rotate / slide) that hints at the tech's identity.
///
/// Controlled by `AppConfig.transitionsEnabled`. When disabled, the router
/// falls back to a plain FadeTransition (350ms) for all techs.
class TechTransition {
  TechTransition._();

  /// Build a [CustomTransitionPage] for `/tech/:id` with the tech's signature
  /// transition. Pass [transitionsEnabled] = false to use the fallback fade.
  static CustomTransitionPage build({
    required LocalKey key,
    required Widget child,
    required String techId,
    bool transitionsEnabled = true,
  }) {
    if (!transitionsEnabled) {
      return _fade(key: key, child: child, durationMs: 350);
    }
    return _pick(techId, key, child);
  }

  /// Fade-only fallback (matches the pre-v2.2.0 behavior).
  static CustomTransitionPage _fade({
    required LocalKey key,
    required Widget child,
    required int durationMs,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: Duration(milliseconds: durationMs),
      reverseTransitionDuration: Duration(milliseconds: (durationMs * 0.8).round()),
      transitionsBuilder: (context, animation, secondary, c) {
        final curved = CurvedAnimation(
            parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: curved, child: c);
      },
    );
  }

  /// Pick the signature transition by tech id.
  static CustomTransitionPage _pick(
      String id, LocalKey key, Widget child) {
    switch (id) {
      case 'xiaoliuren':
        // Taiji spin-in: scale 0.5→1 + rotate 90°→0
        return _custom(
          key: key,
          child: child,
          durationMs: 480,
          beginScale: 0.5,
          beginRotation: 0.25, // 1/4 turn
          curve: Curves.easeOutCubic,
        );
      case 'zhouyi':
        // Hexagram stack: slide up + scale Y
        return _custom(
          key: key,
          child: child,
          durationMs: 420,
          beginScale: 0.92,
          beginOffsetY: 32,
          curve: Curves.easeOutCubic,
        );
      case 'meihua':
        // Two-numbers merge: slide from left + scale 0.85
        return _custom(
          key: key,
          child: child,
          durationMs: 420,
          beginScale: 0.85,
          beginOffsetX: -28,
          curve: Curves.easeOutBack,
        );
      case 'jiaobei':
        // Jiaobei parabola: slide from top + slight scale
        return _custom(
          key: key,
          child: child,
          durationMs: 380,
          beginScale: 0.9,
          beginOffsetY: -36,
          curve: Curves.easeOutCubic,
        );
      case 'ziwei':
        // Chart radiate: scale 0.5→1 + rotate -30°→0
        return _custom(
          key: key,
          child: child,
          durationMs: 520,
          beginScale: 0.5,
          beginRotation: -1 / 12, // -30°
          curve: Curves.easeOutCubic,
        );
      case 'qimen':
        // Nine-grid block: scale 0.8 + slight rotation
        return _custom(
          key: key,
          child: child,
          durationMs: 440,
          beginScale: 0.8,
          beginRotation: 0.08,
          curve: Curves.easeOutCubic,
        );
      case 'chouqian':
        // Scroll unfold: scale Y from 0.3 (width stays)
        return _custom(
          key: key,
          child: child,
          durationMs: 480,
          beginScale: 0.88,
          beginOffsetY: 24,
          curve: Curves.easeInOutCubic,
        );
      case 'cezi':
        // Character emerge: scale 0.6→1 with easeOutBack
        return _custom(
          key: key,
          child: child,
          durationMs: 460,
          beginScale: 0.6,
          curve: Curves.easeOutBack,
        );
      case 'daliuren':
        // Double-plate rotate: scale 0.7 + rotate 60°
        return _custom(
          key: key,
          child: child,
          durationMs: 480,
          beginScale: 0.7,
          beginRotation: 1 / 6, // 60°
          curve: Curves.easeOutCubic,
        );
      case 'luopan':
        // Compass needle scan: rotate -45°→0 + scale 0.85
        return _custom(
          key: key,
          child: child,
          durationMs: 440,
          beginScale: 0.85,
          beginRotation: -1 / 8, // -45°
          curve: Curves.easeOutCubic,
        );
      default:
        return _fade(key: key, child: child, durationMs: 350);
    }
  }

  /// Generic transition builder that combines fade + scale + rotate + slide.
  static CustomTransitionPage _custom({
    required LocalKey key,
    required Widget child,
    required int durationMs,
    double beginScale = 1.0,
    double beginRotation = 0.0,
    double beginOffsetX = 0.0,
    double beginOffsetY = 0.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: Duration(milliseconds: durationMs),
      reverseTransitionDuration:
          Duration(milliseconds: (durationMs * 0.8).round()),
      transitionsBuilder: (context, animation, secondary, c) {
        final curved = CurvedAnimation(parent: animation, curve: curve);
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              beginOffsetX * (1 - curved.value),
              beginOffsetY * (1 - curved.value),
            ),
            child: Transform.scale(
              scale: beginScale + (1.0 - beginScale) * curved.value,
              child: Transform.rotate(
                angle: beginRotation * (1 - curved.value) * 2 * 3.14159265,
                child: c,
              ),
            ),
          ),
        );
      },
    );
  }
}
