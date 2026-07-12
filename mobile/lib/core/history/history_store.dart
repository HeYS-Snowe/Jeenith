// Copyright (c) 2026 Qore. All rights reserved.
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

  const HistoryEntry({
    required this.id,
    required this.techId,
    required this.techName,
    required this.time,
    required this.summary,
    required this.detail,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'techId': techId,
        'techName': techName,
        'time': time.toIso8601String(),
        'summary': summary,
        'detail': detail,
        'note': note,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> j) => HistoryEntry(
        id: j['id'] as String,
        techId: j['techId'] as String,
        techName: j['techName'] as String,
        time: DateTime.parse(j['time'] as String),
        summary: j['summary'] as String,
        detail: j['detail'] as String,
        note: j['note'] as String?,
      );

  HistoryEntry copyWith({String? note}) => HistoryEntry(
        id: id, techId: techId, techName: techName, time: time,
        summary: summary, detail: detail, note: note ?? this.note,
      );
}

/// 历史记录存储（SharedPreferences JSON）。静态方法，各术可直接调用 add。
class HistoryStore {
  static const _key = 'divination_history';

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

  static Future<void> add(HistoryEntry e) async {
    final list = await load();
    list.insert(0, e); // 最新的在前
    await _save(list);
  }

  static Future<void> updateNote(String id, String? note) async {
    final list = await load();
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        list[i] = list[i].copyWith(note: note);
        break;
      }
    }
    await _save(list);
  }

  static Future<void> remove(String id) async {
    final list = await load();
    list.removeWhere((e) => e.id == id);
    await _save(list);
  }

  static Future<void> _save(List<HistoryEntry> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}
