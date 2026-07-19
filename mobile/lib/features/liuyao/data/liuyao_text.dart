// Copyright (c) 2026 Qore

/// 六亲名（以卦宫五行为「我」）。
const liuqinNames = ['父母', '兄弟', '子孙', '妻财', '官鬼'];

/// 六亲含义。
const liuqinMeaning = <String, String>{
  '父母': '生我者。主文书、契约、长辈、辛劳、房屋、舟车。',
  '兄弟': '同我者。主竞争、劫耗、同辈、合伙、阻力。',
  '子孙': '我生者。主福德、喜悦、子嗣、医药、解忧、避险。',
  '妻财': '我克者。主钱财、妻室、财利、收获、奴仆。',
  '官鬼': '克我者。主功名、官职、疾病、灾祸、忧患、丈夫（女测）。',
};

/// 测事主题。
class Topic {
  final String label;
  final String yongShenMale; // 男测用神
  final String? yongShenFemale; // 女测用神（默认同男测）
  const Topic(this.label, this.yongShenMale, [this.yongShenFemale]);

  String yongShen(bool isMale) => isMale ? yongShenMale : (yongShenFemale ?? yongShenMale);
}

/// 主题列表（首页芯片）。
const topics = <Topic>[
  Topic('求财谋利', '妻财'),
  Topic('经营生意', '妻财'),
  Topic('姻缘婚姻', '妻财', '官鬼'), // 男测妻财、女测官鬼
  Topic('功名事业', '官鬼'),
  Topic('求官求职', '官鬼'),
  Topic('考试升学', '官鬼'),
  Topic('疾病健康', '官鬼'),
  Topic('官非诉讼', '官鬼'),
  Topic('出行谋事', '父母'),
  Topic('寻人失物', '妻财'),
  Topic('孕育子女', '子孙'),
  Topic('求医问药', '子孙'),
  Topic('房屋文书', '父母'),
  Topic('合伙交友', '兄弟'),
  Topic('长辈事宜', '父母'),
];
