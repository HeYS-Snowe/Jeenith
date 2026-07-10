// Copyright (c) 2026 Qore. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/branding.dart';
import '../../core/constants/app_colors.dart';
import '../../core/divination/divination_registry.dart';

/// 首页：选术卡片 grid。读 [visibleTechsProvider]，新术自动出现。
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techs = ref.watch(visibleTechsProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 44),
            Text(
              Branding.appName,
              style: const TextStyle(
                color: AppColors.goldBright,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Branding.tagline,
              style: const TextStyle(
                color: AppColors.textSubtitle,
                fontSize: 12,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.86,
                children: techs.map((t) {
                  final meta = t.meta;
                  return GestureDetector(
                    onTap: () => context.go('/tech/${meta.id}'),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            meta.accentColor.withValues(alpha: 0.22),
                            AppColors.card,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: meta.accentColor.withValues(alpha: 0.5)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: meta.accentColor.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.auto_awesome,
                                color: meta.accentColor),
                          ),
                          const Spacer(),
                          Text(
                            meta.displayName,
                            style: TextStyle(
                              color: meta.accentColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            meta.subtitle,
                            style: const TextStyle(
                              color: AppColors.textSubtitle,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            meta.description,
                            style: const TextStyle(
                              color: AppColors.textBody,
                              fontSize: 11,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                Branding.copyright,
                style: const TextStyle(color: AppColors.textHint, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
