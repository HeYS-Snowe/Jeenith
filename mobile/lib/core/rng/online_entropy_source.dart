// Copyright (c) 2026 Qore
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
          .timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) {
        return (display: '超时/不可用', bytes: Uint8List(0));
      }
      // random.org format=plain 返回 6 行 1-9 的数字。严格校验整体格式，
      // 避免错误页/HTML 中提取到数字被误当作熵源。
      final body = res.body.trim();
      final lines = const LineSplitter().convert(body);
      final nums = <int>[];
      for (final line in lines) {
        final n = int.tryParse(line.trim());
        if (n == null || n < 1 || n > 9) {
          return (display: '超时/不可用', bytes: Uint8List(0));
        }
        nums.add(n);
        if (nums.length == 6) break;
      }
      if (nums.length != 6) {
        return (display: '超时/不可用', bytes: Uint8List(0));
      }
      final vals = nums.join(',');
      return (
        display: vals,
        bytes: Uint8List.fromList(utf8.encode(vals)),
      );
    } catch (_) {
      return (display: '超时/不可用', bytes: Uint8List(0));
    }
  }
}
