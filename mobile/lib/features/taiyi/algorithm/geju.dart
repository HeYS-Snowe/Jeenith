// Copyright (c) 2026 Qore

import 'divine.dart';
import '../data/taiyi_data.dart';

/// 太乙格局（迫 / 格 / 杜塞 / 囚 / 关）。
class TaiyiGeju {
  final String name;
  final String text;
  const TaiyiGeju(this.name, this.text);
}

/// 识别太乙格局。
///
/// 判据（《太乙金镜式经》+ 教程 2024/2025 案例验证）：
/// - **迫**：文昌与太乙不同宫，按行宫序文昌在太乙前(外)/后(内)。
/// - **格**：始击/客大将/客参将宫与太乙宫相对（宫数和 = 10）。
/// - **杜塞**：主或客算尾数为 5，落中宫隔绝太乙。
/// - **囚**：主客大将/参将落入太乙宫。
/// - **关**：两将同处一宫（中宫除外）。
List<TaiyiGeju> identifyGeju(TaiyiResult r) {
  final out = <TaiyiGeju>[];

  // 迫
  final taiyiOrderIdx = taiyiGongOrder.indexOf(r.taiyiGong);
  final wenchangGong = taiyiGongOfJianchen[r.wenchangJc];
  final wenchangOrderIdx = taiyiGongOrder.indexOf(wenchangGong);
  if (wenchangGong != r.taiyiGong) {
    if (wenchangOrderIdx > taiyiOrderIdx) {
      out.add(const TaiyiGeju('外宫迫', '文昌在太乙顺行前方之宫，外来压迫，灾重且迅猛。'));
    } else {
      out.add(const TaiyiGeju('内宫迫', '文昌在太乙顺行后方之宫，内起压力，进程受阻。'));
    }
  }

  // 格（与太乙相对：宫数和 = 10）
  bool opposite(int g) => g + r.taiyiGong == 10;
  if (opposite(taiyiGongOfJianchen[r.shijiJc]) ||
      opposite(r.guestDajiang) ||
      opposite(r.guestCanjiang)) {
    out.add(const TaiyiGeju('格', '始击或客将与太乙相对，主变革、争斗、动荡。'));
  }

  // 杜塞（主/客算尾数 5 落中宫）
  if (r.mainSuan % 10 == 5 || r.guestSuan % 10 == 5) {
    out.add(const TaiyiGeju('杜塞', '主或客算尾数五落中宫，隔绝太乙，不宜出兵，只宜坚守。'));
  }

  // 囚 / 关
  final generals = <(String, int)>[
    ('主大将', r.mainDajiang),
    ('主参将', r.mainCanjiang),
    ('客大将', r.guestDajiang),
    ('客参将', r.guestCanjiang),
  ];
  for (final (name, g) in generals) {
    if (g == r.taiyiGong) {
      out.add(TaiyiGeju('囚（$name）', '$name入太乙宫，自身困窘、纠缠阻隔、寸步难行。'));
    }
  }
  for (var i = 0; i < generals.length; i++) {
    for (var j = i + 1; j < generals.length; j++) {
      if (generals[i].$2 == generals[j].$2 && generals[i].$2 != 5) {
        out.add(TaiyiGeju(
            '关（${generals[i].$1}/${generals[j].$1}）',
            '${generals[i].$1}与${generals[j].$1}同宫，一山二虎，主不睦、纷争。'));
      }
    }
  }

  return out;
}
