// Copyright (c) 2026 Qore. All rights reserved.

/// 签等级。
enum StickGrade {
  shangShang, // 上上
  shang,      // 上
  zhong,      // 中
  xia,        // 下
  xiaXia,     // 下下
}

extension StickGradeX on StickGrade {
  String get label => switch (this) {
        StickGrade.shangShang => '上上签',
        StickGrade.shang => '上签',
        StickGrade.zhong => '中签',
        StickGrade.xia => '下签',
        StickGrade.xiaXia => '下下签',
      };

  /// 吉凶倾向（用于颜色映射）：1 上上 → -2 下下，区间 [-2, 1]。
  int get luckScore => switch (this) {
        StickGrade.shangShang => 2,
        StickGrade.shang => 1,
        StickGrade.zhong => 0,
        StickGrade.xia => -1,
        StickGrade.xiaXia => -2,
      };
}

/// 单签数据：签题/级别/签诗/解曰。
class ChouqianStick {
  final int number;
  final String title;
  final StickGrade grade;
  final String poem;        // 四句签诗
  final String interpretation; // 解曰
  final String detail;      // 详注（财运/事业/姻缘等简要）

  const ChouqianStick({
    required this.number,
    required this.title,
    required this.grade,
    required this.poem,
    required this.interpretation,
    required this.detail,
  });
}

/// 一次抽签结果。
class ChouqianResult {
  final ChouqianStick stick;
  final DateTime time;

  const ChouqianResult({required this.stick, required this.time});
}

/// 签样数据集（30 签，覆盖五等级）。
///
/// 签诗为传统四句体裁，按数序排列。等级分布：
/// - 上上：5 签（1, 7, 13, 19, 25）
/// - 上：5 签（2, 8, 14, 20, 26）
/// - 中：10 签（3, 9, 15, 21, 27, 4, 10, 16, 22, 28）
/// - 下：5 签（5, 11, 17, 23, 29）
/// - 下下：5 签（6, 12, 18, 24, 30）
const List<ChouqianStick> sticks = [
  ChouqianStick(
    number: 1,
    title: '紫气东来',
    grade: StickGrade.shangShang,
    poem: '紫气东来祥云开，\n金乌展翅照楼台。\n贵人扶持登高位，\n一帆风顺自天来。',
    interpretation: '大吉之兆，贵人相扶，所求皆顺，宜进取不宜迟疑。',
    detail: '财运：亨通　事业：升迁　姻缘：良配　健康：康宁',
  ),
  ChouqianStick(
    number: 2,
    title: '春风得意',
    grade: StickGrade.shang,
    poem: '春风得意马蹄疾，\n一夜看尽长安花。\n前路坦荡无阻碍，\n把握良机莫蹉跎。',
    interpretation: '小吉之兆，前路通畅，把握时机，可获丰果。',
    detail: '财运：渐旺　事业：顺遂　姻缘：可成　健康：平顺',
  ),
  ChouqianStick(
    number: 3,
    title: '平湖秋月',
    grade: StickGrade.zhong,
    poem: '平湖秋月映波光，\n远山如黛水如霜。\n心事悠悠未分明，\n且待时日自呈详。',
    interpretation: '中平之兆，事未明朗，宜守不宜进，静待时机。',
    detail: '财运：平稳　事业：守成　姻缘：待时　健康：无碍',
  ),
  ChouqianStick(
    number: 4,
    title: '云开见日',
    grade: StickGrade.zhong,
    poem: '云开雾散见晴空，\n日照山河万里红。\n先前困厄今消解，\n且行且进渐亨通。',
    interpretation: '中吉之兆，前困将解，渐入佳境，宜缓图不宜急。',
    detail: '财运：渐增　事业：转机　姻缘：和解　健康：渐愈',
  ),
  ChouqianStick(
    number: 5,
    title: '逆水行舟',
    grade: StickGrade.xia,
    poem: '逆水行舟用力难，\n中流砥柱自支撑。\n前路崎岖多阻碍，\n忍耐方能有出头。',
    interpretation: '小凶之兆，前路多艰，宜忍耐守拙，不宜强求。',
    detail: '财运：阻滞　事业：多艰　姻缘：多磨　健康：留意',
  ),
  ChouqianStick(
    number: 6,
    title: '黑云压城',
    grade: StickGrade.xiaXia,
    poem: '黑云压城城欲摧，\n风急雨骤人难回。\n所求之事多不顺，\n宜守宜静待春来。',
    interpretation: '大凶之兆，事多不顺，宜守不宜进，静待转机。',
    detail: '财运：破耗　事业：受阻　姻缘：难成　健康：防疾',
  ),
  ChouqianStick(
    number: 7,
    title: '鸿鹄高飞',
    grade: StickGrade.shangShang,
    poem: '鸿鹄高飞入云端，\n一览山河万里宽。\n志向远大终有成，\n功名富贵自天还。',
    interpretation: '大吉之兆，志向远大，终必有成，宜奋发有为。',
    detail: '财运：大旺　事业：腾达　姻缘：天成　健康：强健',
  ),
  ChouqianStick(
    number: 8,
    title: '柳暗花明',
    grade: StickGrade.shang,
    poem: '山重水复疑无路，\n柳暗花明又一村。\n转机就在前头处，\n莫因眼前失希望。',
    interpretation: '吉兆，看似无路实有路，转机将至，宜坚持。',
    detail: '财运：转旺　事业：转机　姻缘：复合　健康：转好',
  ),
  ChouqianStick(
    number: 9,
    title: '秋水长天',
    grade: StickGrade.zhong,
    poem: '秋水共长天一色，\n落霞与孤鹜齐飞。\n所求之事如秋水，\n清而未决待深思。',
    interpretation: '中平之兆，事如秋水清澈但未决，宜深思慎行。',
    detail: '财运：平平　事业：守常　姻缘：暧昧　健康：调和',
  ),
  ChouqianStick(
    number: 10,
    title: '日中则昃',
    grade: StickGrade.zhong,
    poem: '日中则昃月盈亏，\n水满则溢理自然。\n盛极而衰宜知止，\n见好就收保平安。',
    interpretation: '中平之兆，盛极必衰，宜知止知足，见好就收。',
    detail: '财运：守成　事业：慎进　姻缘：知足　健康：调养',
  ),
  ChouqianStick(
    number: 11,
    title: '风雨飘摇',
    grade: StickGrade.xia,
    poem: '风雨飘摇舟欲倾，\n波涛汹涌路难行。\n此刻宜守不宜进，\n静待风息浪自平。',
    interpretation: '小凶之兆，风雨飘摇，宜守不宜进，静待时局稳定。',
    detail: '财运：损耗　事业：动荡　姻缘：不稳　健康：注意',
  ),
  ChouqianStick(
    number: 12,
    title: '寒冬腊月',
    grade: StickGrade.xiaXia,
    poem: '寒冬腊月雪漫漫，\n万物萧条生意残。\n所求之事如冰封，\n宜静不宜动如山。',
    interpretation: '大凶之兆，万物萧条，宜静守不宜动，待春暖花开。',
    detail: '财运：冰封　事业：停滞　姻缘：冷淡　健康：防寒',
  ),
  ChouqianStick(
    number: 13,
    title: '鲤鱼化龙',
    grade: StickGrade.shangShang,
    poem: '鲤鱼跃过龙门去，\n化作真龙腾九天。\n功名成就惊天下，\n荣华富贵万千年。',
    interpretation: '大吉之兆，跃过难关即化龙，功名成就，富贵绵长。',
    detail: '财运：暴发　事业：腾飞　姻缘：天定　健康：旺盛',
  ),
  ChouqianStick(
    number: 14,
    title: '芝兰玉树',
    grade: StickGrade.shang,
    poem: '芝兰玉树生庭阶，\n子孙昌盛世代兴。\n家门和顺福自至，\n积善之家必有余。',
    interpretation: '吉兆，家门和顺，子孙昌盛，积善有余庆。',
    detail: '财运：渐旺　事业：稳步　姻缘：和谐　健康：安康',
  ),
  ChouqianStick(
    number: 15,
    title: '日月如梭',
    grade: StickGrade.zhong,
    poem: '日月如梭转眼过，\n光阴似箭不可留。\n所求之事需时日，\n莫因急躁失良谋。',
    interpretation: '中平之兆，事需时日，宜耐心等待，莫急躁。',
    detail: '财运：缓增　事业：缓进　姻缘：需时　健康：平稳',
  ),
  ChouqianStick(
    number: 16,
    title: '潮起潮落',
    grade: StickGrade.zhong,
    poem: '潮起潮落自有时，\n月圆月缺理自然。\n所求之事如潮汐，\n把握涨潮好良机。',
    interpretation: '中平之兆，事如潮汐有涨落，宜把握时机，顺势而为。',
    detail: '财运：起伏　事业：顺势　姻缘：有时　健康：调和',
  ),
  ChouqianStick(
    number: 17,
    title: '迷途羔羊',
    grade: StickGrade.xia,
    poem: '迷途羔羊不知归，\n前路茫茫无方向。\n宜停宜思莫盲进，\n静心明志待天光。',
    interpretation: '小凶之兆，迷失方向，宜停下思量，莫盲目前行。',
    detail: '财运：迷茫　事业：无向　姻缘：未明　健康：心烦',
  ),
  ChouqianStick(
    number: 18,
    title: '泥足深陷',
    grade: StickGrade.xiaXia,
    poem: '泥足深陷难自拔，\n越挣越陷越艰难。\n此刻宜求贵人助，\n莫要独自硬撑担。',
    interpretation: '大凶之兆，深陷难拔，宜求贵人相助，莫独自硬撑。',
    detail: '财运：深陷　事业：困顿　姻缘：纠缠　健康：沉重',
  ),
  ChouqianStick(
    number: 19,
    title: '金榜题名',
    grade: StickGrade.shangShang,
    poem: '金榜题名天下知，\n一举成名天下闻。\n十年寒窗无人问，\n一举成名天下闻。',
    interpretation: '大吉之兆，苦尽甘来，功名成就，所求必应。',
    detail: '财运：丰收　事业：成名　姻缘：良缘　健康：康健',
  ),
  ChouqianStick(
    number: 20,
    title: '破茧成蝶',
    grade: StickGrade.shang,
    poem: '破茧成蝶展新翅，\n重获新生舞春风。\n前困今解新境开，\n展翅高飞任翱翔。',
    interpretation: '吉兆，前困今解，新境将开，宜展翅高飞。',
    detail: '财运：新生　事业：突破　姻缘：新生　健康：转佳',
  ),
  ChouqianStick(
    number: 21,
    title: '中庸之道',
    grade: StickGrade.zhong,
    poem: '中庸之道不偏倚，\n过犹不及皆非宜。\n所求之事宜中和，\n执两用中自得宜。',
    interpretation: '中平之兆，事宜中和，过犹不及，宜执两用中。',
    detail: '财运：中和　事业：中庸　姻缘：调和　健康：平衡',
  ),
  ChouqianStick(
    number: 22,
    title: '铜钱两面',
    grade: StickGrade.zhong,
    poem: '铜钱有两面，\n吉凶未可知。\n所求事未定，\n宜再思三思。',
    interpretation: '中平之兆，吉凶未定，宜三思而后行，不可轻决。',
    detail: '财运：未定　事业：待决　姻缘：未明　健康：留意',
  ),
  ChouqianStick(
    number: 23,
    title: '逆风飞翔',
    grade: StickGrade.xia,
    poem: '逆风飞翔翅难展，\n阻力重重路难前。\n此刻宜养不宜飞，\n待风顺时再腾骞。',
    interpretation: '小凶之兆，逆风难飞，宜养精蓄锐，待风顺时再起。',
    detail: '财运：阻滞　事业：受阻　姻缘：难成　健康：调养',
  ),
  ChouqianStick(
    number: 24,
    title: '四面楚歌',
    grade: StickGrade.xiaXia,
    poem: '四面楚歌声声急，\n十面埋伏步步难。\n此刻宜守不宜战，\n静待援兵解危艰。',
    interpretation: '大凶之兆，四面受敌，宜守不宜战，静待转机。',
    detail: '财运：困窘　事业：受困　姻缘：多难　健康：危重',
  ),
  ChouqianStick(
    number: 25,
    title: '旭日东升',
    grade: StickGrade.shangShang,
    poem: '旭日东升照山河，\n万象更新气象和。\n所求之事如朝阳，\n蒸蒸日上无所遮。',
    interpretation: '大吉之兆，如旭日东升，蒸蒸日上，所求皆顺。',
    detail: '财运：日增　事业：上升　姻缘：明朗　健康：旺盛',
  ),
  ChouqianStick(
    number: 26,
    title: '渐入佳境',
    grade: StickGrade.shang,
    poem: '渐入佳境味渐浓，\n愈行愈远愈通融。\n所求之事渐明朗，\n持之以恒必有功。',
    interpretation: '吉兆，渐入佳境，持之以恒必有功，宜坚持。',
    detail: '财运：渐增　事业：渐顺　姻缘：渐浓　健康：渐佳',
  ),
  ChouqianStick(
    number: 27,
    title: '行云流水',
    grade: StickGrade.zhong,
    poem: '行云流水自天然，\n不强不强自安然。\n所求之事宜自然，\n莫强莫求顺因缘。',
    interpretation: '中平之兆，事宜自然，莫强莫求，顺因缘而行。',
    detail: '财运：自然　事业：随缘　姻缘：随化　健康：平和',
  ),
  ChouqianStick(
    number: 28,
    title: '半途而废',
    grade: StickGrade.zhong,
    poem: '半途而废前功弃，\n行百里者半九十。\n所求之事需坚持，\n莫因近终失耐力。',
    interpretation: '中平之兆，事需坚持到底，莫半途而废，宜恒心。',
    detail: '财运：守成　事业：坚持　姻缘：需恒　健康：坚持',
  ),
  ChouqianStick(
    number: 29,
    title: '阴霾笼罩',
    grade: StickGrade.xia,
    poem: '阴霾笼罩日无光，\n前路昏暗难寻方。\n此刻宜守不宜进，\n静待云开见太阳。',
    interpretation: '小凶之兆，阴霾笼罩，宜守不宜进，静待云开。',
    detail: '财运：晦暗　事业：不明　姻缘：暗淡　健康：留意',
  ),
  ChouqianStick(
    number: 30,
    title: '万事皆休',
    grade: StickGrade.xiaXia,
    poem: '万事皆休一场空，\n所求之事皆无踪。\n此刻宜止不宜求，\n静待时运再转通。',
    interpretation: '大凶之兆，万事皆休，宜止不宜求，静待时运转换。',
    detail: '财运：破败　事业：止步　姻缘：终结　健康：危殆',
  ),
];

/// 签总数。
const int stickCount = 30;

/// 抽签：根据签号取签。
///
/// [stickNumber] 应在 [1, stickCount] 区间；越界则按取模回绕。
ChouqianResult divine(int stickNumber, {DateTime? time}) {
  final n = ((stickNumber - 1) % stickCount + stickCount) % stickCount + 1;
  final stick = sticks.firstWhere((s) => s.number == n);
  return ChouqianResult(stick: stick, time: time ?? DateTime.now());
}
