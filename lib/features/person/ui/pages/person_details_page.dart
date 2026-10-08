import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/routing/app_router.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/core/ui/error_view.dart';
import 'package:filmania/ui/core/ui/glassmorphic_app_bar.dart';
import 'package:filmania/ui/core/ui/skeleton.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/domain/models/person.dart';
import 'package:filmania/domain/models/person_credit.dart';
import 'package:filmania/data/repositories/person/person_providers.dart';

class PersonDetailsPage extends ConsumerWidget {
  final int personId;

  const PersonDetailsPage({super.key, required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personAsync = ref.watch(personDetailsProvider(personId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
      body: personAsync.when(
        data: (person) => _PersonDetailsContent(person: person),
        loading: () => const PersonDetailsSkeleton(),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(personDetailsProvider(personId)),
        ),
      ),
    );
  }
}

class _PersonDetailsContent extends StatelessWidget {
  final Person person;

  const _PersonDetailsContent({required this.person});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
        SliverToBoxAdapter(child: _PersonHeader(person: person)),
        SliverToBoxAdapter(
          child: _PersonFilmographySection(personId: person.id),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
      ],
    );
  }
}

class _PersonHeader extends StatelessWidget {
  final Person person;

  const _PersonHeader({required this.person});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: person.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: person.fullProfileUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 320,
                      errorWidget: (context, url, error) => Icon(
                        Icons.person_rounded,
                        size: 64,
                        color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              person.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurfacePrimary,
              ),
            ),
          ),
          if (person.birthday != null || person.placeOfBirth != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                [
                  if (person.birthday != null)
                    l10n.mediumDate(person.birthday!),
                  if (person.placeOfBirth != null) person.placeOfBirth!,
                ].join(' · '),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.biographyTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            person.biography.isNotEmpty ? person.biography : l10n.noBiography,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonFilmographySection extends ConsumerWidget {
  final int personId;

  const _PersonFilmographySection({required this.personId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmographyAsync = ref.watch(personFilmographyProvider(personId));

    return filmographyAsync.when(
      data: (credits) {
        if (credits.isEmpty) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context)!;
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.filmographyTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: credits.length,
                itemBuilder: (context, index) =>
                    _FilmographyCard(credit: credits[index]),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _FilmographyCard extends StatelessWidget {
  final PersonCredit credit;

  const _FilmographyCard({required this.credit});

  @override
  Widget build(BuildContext context) {
    return MediaGridCard(
      mediaId: credit.mediaId,
      title: credit.title,
      posterUrl: credit.fullPosterUrl,
      posterPath: credit.posterPath,
      releaseYear: credit.releaseYear?.toString(),
      voteAverage: credit.voteAverage,
      mediaType: credit.mediaType,
      onTap: () => context.push(
        credit.mediaType == MediaType.movie
            ? AppRoutes.movieDetails.replaceAll(
                ':id',
                credit.mediaId.toString(),
              )
            : AppRoutes.tvDetails.replaceAll(':id', credit.mediaId.toString()),
      ),
    );
  }
}
