import 'package:flutter/material.dart';
import 'package:filmania/core/theme/app_theme.dart';

class RecommendationsSection extends StatelessWidget {
  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const RecommendationsSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
