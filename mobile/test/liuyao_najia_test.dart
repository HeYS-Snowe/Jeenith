// Copyright (c) 2026 Qore
import 'package:flutter_test/flutter_test.dart';
import 'package:jeenith/features/liuyao/algorithm/divine.dart';
import 'package:jeenith/features/liuyao/data/najia_data.dart';

/// 六爻纳甲核心验证：以乾宫八卦与经典卦例校对纳甲/六亲/世应/八宫/变卦/六神。
void main() {
  group('六爻纳甲', () {
    test('乾为天（本宫）：世六应三 + 纳甲六亲', () {
      final raw = [for (var i = 0; i < 6; i++) (yang: true, changing: false)];
      final r = divine(yongShen: '妻财', rawLines: raw);
      expect(r.benName, '乾');
      expect(r.lowerName, '乾');
      expect(r.upperName, '乾');
      expect(r.bagong.gong, '乾');
      expect(r.bagong.seq, 0);
      expect(r.bagong.shi, 5);
      expect(r.bagong.ying, 2);
      expect(r.gongWuxing, '金');
      // 纳甲六亲：子子孙 / 妻财寅 / 父母辰 / 官鬼午 / 兄弟申 / 父母戌
      void y(int i, String g, String z, String l) {
        expect(r.lines[i].gan, g, reason: '爻$i 天干');
        expect(r.lines[i].zhi, z, reason: '爻$i 地支');
        expect(r.lines[i].liuqin, l, reason: '爻$i 六亲');
      }

      y(0, '甲', '子', '子孙');
      y(1, '甲', '寅', '妻财');
      y(2, '甲', '辰', '父母');
      y(3, '壬', '午', '官鬼');
      y(4, '壬', '申', '兄弟');
      y(5, '壬', '戌', '父母');
      // 用神妻财在二爻（不持世、不动 → 首个匹配）
      expect(r.yongPos, 1);
      expect(r.bianName, isNull);
    });

    test('天风姤（一世）：世初应四 + 下卦巽纳甲', () {
      final raw = [
        (yang: false, changing: false),
        for (var i = 1; i < 6; i++) (yang: true, changing: false),
      ];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '姤');
      expect(r.bagong.gong, '乾');
      expect(r.bagong.seq, 1);
      expect(r.bagong.shi, 0);
      expect(r.bagong.ying, 3);
      // 下卦巽：初辛丑（金宫·土生金=父母）
      expect(r.lines[0].gan, '辛');
      expect(r.lines[0].zhi, '丑');
      expect(r.lines[0].liuqin, '父母');
    });

    test('天地否（三世）：世三应六', () {
      // 乾上坤下 = bit3,4,5 阳
      final raw = [
        for (var i = 0; i < 6; i++) (yang: i >= 3, changing: false),
      ];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '否');
      expect(r.bagong.gong, '乾');
      expect(r.bagong.seq, 3);
      expect(r.bagong.shi, 2);
      expect(r.bagong.ying, 5);
    });

    test('火地晋（乾宫游魂）：世四应初', () {
      // 离上坤下 = bit3,5 阳
      final raw = [
        for (var i = 0; i < 6; i++)
          (yang: i == 3 || i == 5, changing: false),
      ];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '晋');
      expect(r.bagong.gong, '乾');
      expect(r.bagong.seq, 6);
      expect(r.bagong.shi, 3);
      expect(r.bagong.ying, 0);
    });

    test('火天大有（乾宫归魂）：世三应六', () {
      // 离上乾下 = 除五爻（i=4）外皆阳
      final raw = [
        for (var i = 0; i < 6; i++) (yang: i != 4, changing: false),
      ];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '大有');
      expect(r.bagong.gong, '乾');
      expect(r.bagong.seq, 7);
      expect(r.bagong.shi, 2);
      expect(r.bagong.ying, 5);
    });

    test('变卦：初爻老阳动 → 乾变姤', () {
      final raw = [
        (yang: true, changing: true),
        for (var i = 1; i < 6; i++) (yang: true, changing: false),
      ];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '乾');
      expect(r.bianName, '姤');
      expect(r.bianLines, isNotNull);
      expect(r.bianLines!.length, 6);
      // 变卦初爻翻为阴
      expect(r.bianLines![0].yang, false);
    });

    test('八宫全覆盖：64 卦皆可定位', () {
      for (var bits = 0; bits < 64; bits++) {
        final raw = [
          for (var i = 0; i < 6; i++)
            (yang: ((bits >> i) & 1) == 1, changing: false),
        ];
        final r = divine(yongShen: '官鬼', rawLines: raw);
        expect(r.bagong.gong, isNotEmpty, reason: 'bits=$bits 定位失败');
        expect(r.benName, isNotEmpty, reason: 'bits=$bits 卦名缺失');
      }
    });

    test('六神按日干顺布', () {
      final raw = [for (var i = 0; i < 6; i++) (yang: true, changing: false)];
      final r = divine(
        yongShen: '官鬼',
        rawLines: raw,
        now: DateTime(2024, 1, 1, 12),
      );
      // 初爻六神 == 日干所起，其后顺布 liushenOrder。
      final start = dayGanLiuShenStart[r.dayGan]!;
      for (var i = 0; i < 6; i++) {
        expect(r.lines[i].shenshou, liushenOrder[(start + i) % 6],
            reason: '爻$i 六神，日干${r.dayGan}');
      }
    });

    test('断辞：用神不上卦时给出伏藏提示', () {
      // 天风姤（乾宫金）：六爻地支 丑亥酉·午申戌，五行 土水金·火金土，无木 → 妻财不上卦。
      final raw = [
        (yang: false, changing: false),
        for (var i = 1; i < 6; i++) (yang: true, changing: false),
      ];
      final r = divine(yongShen: '妻财', rawLines: raw);
      expect(r.benName, '姤');
      expect(r.yongPos, isNull);
      expect(r.points.first, contains('不上卦'));
    });

    test('六冲卦：乾为天（八纯卦）六冲', () {
      // 乾卦六爻 子寅辰·午申戌：初子冲四午、二寅冲五申、三辰冲上戌
      final raw = [for (var i = 0; i < 6; i++) (yang: true, changing: false)];
      final r = divine(yongShen: '妻财', rawLines: raw);
      expect(r.benName, '乾');
      expect(r.isLiuChong, isTrue);
      expect(r.isLiuHe, isFalse);
    });

    test('六合卦：天地否六合', () {
      // 否卦 坤下乾上：初未合四午、二巳合五申、三卯合上戌
      final raw = [for (var i = 0; i < 6; i++) (yang: i >= 3, changing: false)];
      final r = divine(yongShen: '官鬼', rawLines: raw);
      expect(r.benName, '否');
      expect(r.isLiuHe, isTrue);
      expect(r.isLiuChong, isFalse);
    });

    test('旬空：甲子日空戌亥', () {
      // 2024-01-01 为甲子日，甲子旬空戌亥
      final raw = [for (var i = 0; i < 6; i++) (yang: true, changing: false)];
      final r = divine(
          yongShen: '官鬼', rawLines: raw, now: DateTime(2024, 1, 1, 12));
      expect(r.dayGan, '甲');
      expect(r.dayZhi, '子');
      expect(r.dayKong, equals(['戌', '亥']));
    });

    test('飞伏：天风姤测妻财，伏神寅伏于飞神亥之下', () {
      // 姤（乾宫）六爻无木 → 妻财不上卦；本宫乾二爻寅木为伏神，姤二爻亥水为飞神
      final raw = [
        (yang: false, changing: false),
        for (var i = 1; i < 6; i++) (yang: true, changing: false),
      ];
      final r = divine(yongShen: '妻财', rawLines: raw);
      expect(r.benName, '姤');
      expect(r.yongPos, isNull);
      final fuFeiPt = r.points.firstWhere((p) => p.contains('伏神'));
      expect(fuFeiPt, contains('寅')); // 伏神寅
      expect(fuFeiPt, contains('二爻')); // fuPos=1
      expect(fuFeiPt, contains('亥')); // 飞神亥
    });
  });
}
