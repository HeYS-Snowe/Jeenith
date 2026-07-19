// Copyright (c) 2026 Qore

import 'divine.dart';

/// 奇门格局（吉格 / 凶格）。
class QimenGeju {
  final String name;
  final bool auspicious; // true=吉格，false=凶格
  final int palace;      // 落宫 1-9
  final String text;     // 断辞
  const QimenGeju(this.name, this.auspicious, this.palace, this.text);
}

/// 八门 → 五行。
const _menWuxing = <String, String>{
  '开门': '金', '休门': '水', '生门': '土',
  '伤门': '木', '杜门': '木', '景门': '火',
  '死门': '土', '惊门': '金',
};

/// 洛书宫（1-9）→ 五行。
const _gongWuxing = <int, String>{
  1: '水', 2: '土', 3: '木', 4: '木', 5: '土',
  6: '金', 7: '金', 8: '土', 9: '火',
};

/// 五行相克关系。
const _keMap = <String, String>{
  '金': '木', '木': '土', '土': '水', '水': '火', '火': '金',
};

bool _ke(String a, String b) => _keMap[a] == b;

const _sanQi = {'乙', '丙', '丁'};
const _jiMen = {'开门', '休门', '生门'};
const _jiShen = {'太阴', '六合', '九天'};

/// 识别奇门格局：遍历九宫四盘，匹配吉格（青龙返首/飞鸟跌穴/玉女守门/三诈）
/// 与凶格（青龙逃走/白虎猖狂/朱雀投江/腾蛇妖娇/太白入荧/荧入太白/三奇入墓/门迫）。
///
/// 返回结果按「吉格在前、凶格在后」排序，同名同宫去重。
List<QimenGeju> identifyGeju(QimenPlate p) {
  final out = <QimenGeju>[];

  for (var i = 0; i < 9; i++) {
    final palace = i + 1;
    final tGan = p.tianPanGan[i]; // 天盘干
    final dGan = p.diPanGan[i];   // 地盘干
    final xing = p.tianPanXing[i];
    final men = p.renPanMen[i];
    final shen = p.shenPanShen[i];

    // === 吉格 ===
    // 青龙返首：天盘戊加临值符星（值符回归本位）
    if (tGan == '戊' && xing == p.zhiFu) {
      out.add(const QimenGeju('青龙返首', true, -1, '六仪戊加值符，回首如意，百谋皆成，大吉之格。'));
    }
    // 飞鸟跌穴：天盘乙加临值符星
    if (tGan == '乙' && xing == p.zhiFu) {
      out.add(const QimenGeju('飞鸟跌穴', true, -1, '乙奇得使，如鸟归巢，进取有功，谋为可成。'));
    }
    // 玉女守门：丁奇加临值使门所在宫
    if (tGan == '丁' && palace == p.zhiShiGong) {
      out.add(QimenGeju('玉女守门', true, palace, '丁奇守值使之门，私密和合，婚姻信音吉。'));
    }
    // 三诈格：三奇 + 三吉门 + 三吉神会聚一宫
    if (_sanQi.contains(tGan) && _jiMen.contains(men) && _jiShen.contains(shen)) {
      out.add(QimenGeju('三诈格', true, palace, '奇、门、神三吉会聚，宜谋为、藏匿、祈愿、求仙。'));
    }

    // === 凶格（干组合）===
    if (tGan == '乙' && dGan == '辛') {
      out.add(const QimenGeju('青龙逃走', false, -1, '乙加辛，木受金克，财利破散，谋为虚耗。'));
    }
    if (tGan == '辛' && dGan == '乙') {
      out.add(const QimenGeju('白虎猖狂', false, -1, '辛加乙，金克木，主惊恐、官非、损伤。'));
    }
    if (tGan == '丁' && dGan == '癸') {
      out.add(const QimenGeju('朱雀投江', false, -1, '丁加癸，火入水，文书口舌失，音信受阻。'));
    }
    if (tGan == '癸' && dGan == '丁') {
      out.add(const QimenGeju('腾蛇妖娇', false, -1, '癸加丁，水入火，妖邪是非，谋为诡变。'));
    }
    if (tGan == '庚' && dGan == '丙') {
      out.add(const QimenGeju('太白入荧', false, -1, '庚加丙，贼来客强，宜防盗敌、坚壁固守。'));
    }
    if (tGan == '丙' && dGan == '庚') {
      out.add(const QimenGeju('荧入太白', false, -1, '丙加庚，贼去主进，宜进讨、可破敌立功。'));
    }

    // === 三奇入墓 ===
    if (tGan == '乙' && palace == 2) {
      out.add(const QimenGeju('乙奇入墓', false, 2, '乙奇墓于坤宫，谋为受困，宜静不宜动。'));
    }
    if (tGan == '丙' && palace == 6) {
      out.add(const QimenGeju('丙奇入墓', false, 6, '丙奇墓于乾宫，光明受阻，事宜缓图。'));
    }
    if (tGan == '丁' && palace == 8) {
      out.add(const QimenGeju('丁奇入墓', false, 8, '丁奇墓于艮宫，机谋难展，宜守拙养晦。'));
    }

    // === 门迫：门五行克宫五行，吉门受制 ===
    if (men.isNotEmpty && _ke(_menWuxing[men]!, _gongWuxing[palace]!)) {
      out.add(QimenGeju('门迫·$men迫${palaceNames[palace - 1]}宫', false, palace,
          '$men（${_menWuxing[men]}）克${palaceNames[palace - 1]}宫（${_gongWuxing[palace]}），门受宫制，谋为减力。'));
    }
  }

  // 同名去重（青龙返首等全局格局可能在多宫误匹配，取首个；带宫号的不去重）
  final seen = <String>{};
  final dedup = <QimenGeju>[];
  for (final g in out) {
    final key = g.palace < 0 ? g.name : '${g.name}|${g.palace}';
    if (seen.add(key)) dedup.add(g);
  }
  // 吉格在前、凶格在后
  dedup.sort((a, b) => a.auspicious == b.auspicious
      ? 0
      : (a.auspicious ? -1 : 1));
  return dedup;
}
