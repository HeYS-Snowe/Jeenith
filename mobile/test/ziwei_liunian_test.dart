// Copyright (c) 2026 Qore
import 'package:flutter_test/flutter_test.dart';
import 'package:jeenith/features/ziwei/algorithm/liu_nian.dart';
import 'package:jeenith/features/ziwei/data/stars.dart';

void main() {
  group('computeLiuNian 干支', () {
    test('2026 = 丙午', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 2026);
      expect(ln.ganZhi, '丙午');
      expect(ln.ganIdx, 2); // 丙
      expect(ln.zhiIdx, 6); // 午 = 流年命宫
    });

    test('1984 = 甲子', () {
      final ln = computeLiuNian(birthYear: 1980, liuNianYear: 1984);
      expect(ln.ganZhi, '甲子');
      expect(ln.zhiIdx, 0);
    });
  });

  group('虚岁', () {
    test('虚岁 = 流年 - 生年 + 1', () {
      expect(computeLiuNian(birthYear: 1990, liuNianYear: 2026).xuSui, 37);
      expect(computeLiuNian(birthYear: 2000, liuNianYear: 2026).xuSui, 27);
    });
  });

  group('小限（生年支起一岁顺行）', () {
    test('1990 午年生，2026 虚岁37，顺行36步回午', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 2026);
      expect(ln.xuSui, 37);
      expect(ln.xiaoXianZhi, 6); // 午
    });

    test('1990→1991 虚岁2，小限走未', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 1991);
      expect(ln.xuSui, 2);
      expect(ln.xiaoXianZhi, 7); // 未
    });
  });

  group('三方四正（命/财/官/迁）', () {
    test('流年命宫午 → 财寅 官戌 迁子', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 2026);
      expect(ln.sanFangZhi, [6, 2, 10, 0]);
    });
  });

  group('流年四化随天干', () {
    test('丙年四化：天同禄 / 天机权 / 文昌科 / 廉贞忌', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 2026);
      expect(ln.sihua.lu, '天同');
      expect(ln.sihua.quan, '天机');
      expect(ln.sihua.ke, '文昌');
      expect(ln.sihua.ji, '廉贞');
    });

    test('sihuaOf 查某星流年化', () {
      final ln = computeLiuNian(birthYear: 1990, liuNianYear: 2026);
      expect(ln.sihuaOf('天同'), SiHua.lu);
      expect(ln.sihuaOf('廉贞'), SiHua.ji);
      expect(ln.sihuaOf('紫微'), isNull);
    });
  });
}
