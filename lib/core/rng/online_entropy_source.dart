// Copyright (c) 2026 Qore. All rights reserved.
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'entropy_source.dart';

/// 在线大气噪声熵源 —— random.org 真随机（可配置，失败回退本地源）。
class OnlineEntropySource implements EntropyCollector {
  final bool enabled;
  OnlineEntropySource(this.enabled);

  @override
  String get name => '在线大气噪声 random.org';

  @override
  bool get isAvailable => enabled;

  @override
  Future<({String display, Uint8List bytes})> sample() async {
    try {
      final res = await http
          .get(Uri.parse(
            'https://www.random.org/integers/?num=6&min=1&max=9'
            '&col=1&base=10&format=plain&rnd=new',
          ))
          .timeout(const Duration(seconds: 3));
      final vals = RegExp(r'\d+')
          .allMatches(res.body)
          .map((m) => m.group(0)!)
          .take(6)
          .join(',');
      return (
        display: vals,
        bytes: Uint8List.fromList(utf8.encode(res.body)),
      );
    } catch (_) {
      return (display: '超时/不可用', bytes: Uint8List(0));
    }
  }
}
