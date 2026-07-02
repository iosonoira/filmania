import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmania/core/domain/entities/crew_member.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:filmania/core/l10n/generated/app_localizations.dart';

class CrewSection extends StatelessWidget {
  final List<CrewMember> crew;
  final String? title;

  const CrewSection({
    super.key,
    required this.crew,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (crew.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title ?? l10n.crewTitle,
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
            itemCount: crew.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => _CrewCard(member: crew[index]),
          ),
        ),
      ],
    );
  }
}

class _CrewCard extends StatelessWidget {
  final CrewMember member;

  const _CrewCard({required this.member});

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
                    memCacheWidth: 200,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => _CrewFallback(colors: colors),
                  )
                : _CrewFallback(colors: colors),
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
            member.job,
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

class _CrewFallback extends StatelessWidget {
  final AppColorScheme colors;

  const _CrewFallback({required this.colors});

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
