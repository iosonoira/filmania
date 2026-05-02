import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:filmania/core/l10n/generated/app_localizations.dart';

class CastSection extends StatelessWidget {
  final List<CastMember> cast;
  final String? title;

  const CastSection({
    super.key,
    required this.cast,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title ?? l10n.castTitle,
            style: textTheme.titleLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: cast.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => _CastCard(member: cast[index]),
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: member.fullProfileUrl != null
                ? CachedNetworkImage(
                    imageUrl: member.fullProfileUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => _CastFallback(colors: colors),
                  )
                : _CastFallback(colors: colors),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            member.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurfacePrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            member.character,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CastFallback extends StatelessWidget {
  final AppColorScheme colors;

  const _CastFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.person_rounded,
        color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
        size: 40,
      ),
    );
  }
}
