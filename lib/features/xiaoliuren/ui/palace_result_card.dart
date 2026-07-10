// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/divination/divination_result.dart';

/// 落宫结果卡（序号 + 宫名 + 五行六神 + 吉凶徽章 + 诗诀 + 含义 + 七维断辞）。
class PalaceResultCard extends StatelessWidget {
  final ResultCardData data;
  const PalaceResultCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(212, 168, 87, 0.35)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(212, 168, 87, 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('第${data.order}宫',
                  style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Text(data.title,
                style: TextStyle(
                    color: data.accentColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(
                child: Text(data.subtitle ?? '',
                    style: const TextStyle(
                        color: AppColors.textMeta, fontSize: 11),
                    overflow: TextOverflow.ellipsis)),
            if (data.badge != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: data.badgeColor ?? AppColors.gold, width: 0.8),
                ),
                child: Text(data.badge!,
                    style: TextStyle(
                        color: data.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
          ]),
          if (data.poem != null) ...[
            const SizedBox(height: 6),
            Text('「 ${data.poem} 」',
                style: const TextStyle(
                    color: AppColors.goldBright,
                    fontSize: 13,
                    fontStyle: FontStyle.italic)),
          ],
          if (data.meaning != null) ...[
            const SizedBox(height: 4),
            Text(data.meaning!,
                style:
                    const TextStyle(color: AppColors.textBody, fontSize: 12, height: 1.5)),
          ],
          if (data.details != null && data.details!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: data.details!
                  .map((d) => _chip(d.label, d.content))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(212, 168, 87, 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label：$content',
          style: const TextStyle(color: AppColors.textMeta, fontSize: 11)),
    );
  }
}
