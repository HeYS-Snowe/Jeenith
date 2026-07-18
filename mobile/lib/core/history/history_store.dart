// Copyright (c) 2026 Qore
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 一条卜算历史记录。
class HistoryEntry {
  final String id;
  final String techId;
  final String techName;
  final DateTime time;
  final String summary;  // 摘要（卦名/落宫等，列表展示）
  final String detail;   // 详细文本（复制用，同 _buildCopyText）
  final String? note;    // 用户备注
  /// 结构化恢复数据（v2.4.3）：用于「预览」重建卦象。各术自行约定 schema
  /// （如 xiaoliuren {'nums':[2,8,9]}、cezi {'char':'字'}）。
  /// v2.4.3 之前的旧历史无此字段，历史页预览按钮将置灰。
  final Map<String, dynamic>? extra;

  const HistoryEntry({
    required this.id,
    required this.techId,
    required this.techName,
    required this.time,
    required this.summary,
    required this.detail,
    this.note,
    this.extra,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'techId': techId,
        'techName': techName,
        'time': time.toIso8601String(),
        'summary': summary,
        'detail': detail,
        'note': note,
        if (extra != null) 'extra': extra,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        id: j['id'] as String,
        techId: j['techId'] as String,
        techName: j['techName'] as String,
        time: DateTime.parse(j['time'] as String),
        summary: j['summary'] as String,
        detail: j['detail'] as String,
        note: j['note'] as String?,
        extra: (j['extra'] as Map<String, dynamic>?)?.cast<String, dynamic>(),
      );

  HistoryEntry copyWith({
    String? note,
    Map<String, dynamic>? extra,
  }) =>
      HistoryEntry(
        id: id, techId: techId, techName: techName, time: time,
        summary: summary, detail: detail,
        note: note ?? this.note,
        extra: extra ?? this.extra,
      );
}

/// 历史记录存储（SharedPreferences JSON）。静态方法，各术可直接调用 add。
///
/// 所有写操作走 [_serialize] 串行化，避免 load→modify→save 之间的竞态
/// 导致同一次 add/updateNote/remove 互相覆盖。
class HistoryStore {
  static const _key = 'divination_history';
  static Future<void> _chain = Future.value();

  /// 生成单调递增的唯一 ID（基于当前时间 + 自增计数，避免 microsecondsSinceEpoch
  /// 在同一帧多次调用时碰撞）。
  static int _counter = 0;
  static String generateId() {
    final now = DateTime.now();
    _counter = (_counter + 1) & 0xFFFF;
    return '${now.microsecondsSinceEpoch}-${_counter.toRadixString(16).padLeft(4, '0')}';
  }

  static Future<List<HistoryEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s == null) return <HistoryEntry>[];
    try {
      final list = jsonDecode(s) as List;
      return list.map((j) => HistoryEntry.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      return <HistoryEntry>[];
    }
  }

  /// 串行化所有写操作，避免并发 load/save 竞态。
  static Future<T> _serialize<T>(Future<T> Function() task) {
    final prev = _chain;
    final completer = Completer<T>();
    _chain = prev.then((_) => task()).then(completer.complete, onError: completer.completeError);
    return completer.future;
  }

  static Future<void> add(HistoryEntry e) => _serialize(() async {
        final list = await load();
        list.insert(0, e); // 最新的在前
        await _save(list);
      });

  static Future<void> updateNote(String id, String? note) => _serialize(() async {
        final list = await load();
        for (var i = 0; i < list.length; i++) {
          if (list[i].id == id) {
            list[i] = list[i].copyWith(note: note);
            break;
          }
        }
        await _save(list);
      });

  static Future<void> remove(String id) => _serialize(() async {
        final list = await load();
        list.removeWhere((e) => e.id == id);
        await _save(list);
      });

  static Future<void> clear() => _serialize(() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_key);
      });

  static Future<void> _save(List<HistoryEntry> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}
