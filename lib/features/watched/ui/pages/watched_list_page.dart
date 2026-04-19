import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/watched_providers.dart';

class WatchedListPage extends ConsumerWidget {
  final MediaType mediaType;

  const WatchedListPage({super.key, required this.mediaType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final asyncItems = ref.watch(watchedItemsProvider(mediaType));

    final title = mediaType == MediaType.movie ? 'Film Visti' : 'Serie TV Viste';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurfacePrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncItems.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Nessun elemento segnato come visto.',
                style: textTheme.bodyLarge?.copyWith(color: colors.onSurfaceSecondary),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                child: item.posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w200${item.posterPath}',
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colors.surface,
                        child: Center(
                          child: Icon(Icons.movie, color: colors.onSurfaceSecondary),
                        ),
                      ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }
}
