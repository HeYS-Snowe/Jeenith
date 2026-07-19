// Copyright (c) 2026 Qore
import 'najia_data.dart';

/// 京房八宫：八个本宫卦（八纯卦）。宫序按传统乾→坎→艮→震→巽→离→坤→兑。
const bagongBenGong = ['乾', '坎', '艮', '震', '巽', '离', '坤', '兑'];

/// 宫内序号名称：0 本宫，1-5 一~五世，6 游魂，7 归魂。
const gongSeqName = ['本宫', '一世', '二世', '三世', '四世', '五世', '游魂', '归魂'];

/// 各宫序的世爻位（0=初爻 … 5=上爻）。应爻位 = (世+3) % 6。
const shiPosBySeq = [5, 0, 1, 2, 3, 4, 3, 2];

/// 由本宫卦 6 爻 bits 与宫内序号生成该宫该序卦的 bits。
///
/// 推导：本宫卦 P（上下皆本宫）。1~5 世逐爻自下而变；
/// 游魂（序6）= 五世基础上四爻回（变 bit 0,1,2,4）；
/// 归魂（序7）= 游魂上卦 + 本宫下卦。
int _genBagongBits(int benBits, int seq) {
  switch (seq) {
    case 0:
      return benBits;
    case 1:
      return benBits ^ 1; // bit0 初爻
    case 2:
      return benBits ^ 3; // bit0,1 初二
    case 3:
      return benBits ^ 7; // bit0,1,2 初二三
    case 4:
      return benBits ^ 15; // bit0,1,2,3 初二三四
    case 5:
      return benBits ^ 31; // bit0,1,2,3,4 初二三四五
    case 6: // 游魂：变 bit0,1,2,4（四爻回）= 1+2+4+16
      return benBits ^ 23;
    case 7: // 归魂：游魂上卦 + 本宫下卦
      final youhun = benBits ^ 23;
      final upper = (youhun >> 3) & 7;
      final lower = benBits & 7;
      return (upper << 3) | lower;
    default:
      return benBits;
  }
}

/// 八宫定位结果。
class BagongLoc {
  final String gong; // 宫名（八纯卦名）
  final int seq; // 宫内序号 0-7
  final int shi; // 世爻位 0-5
  final int ying; // 应爻位 0-5
  const BagongLoc({
    required this.gong,
    required this.seq,
    required this.shi,
    required this.ying,
  });
  String get seqName => gongSeqName[seq];
}

/// 给定 6 爻 bits，返回其八宫归属、宫序与世应位。
///
/// 64 卦必落入八宫之一（京房八宫划分恰为 8×8 全覆盖），故无 fallback。
BagongLoc locateBagong(int bits) {
  for (final gong in bagongBenGong) {
    final b8 = nameToBin8[gong]!; // 八纯卦 = 上下皆本宫
    final benBits = (b8 << 3) | b8;
    for (var seq = 0; seq < 8; seq++) {
      if (_genBagongBits(benBits, seq) == bits) {
        final shi = shiPosBySeq[seq];
        return BagongLoc(gong: gong, seq: seq, shi: shi, ying: (shi + 3) % 6);
      }
    }
  }
  throw StateError('卦未落入八宫: bits=$bits');
}
