import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/watchlist.dart';
import '../providers/watchlist_providers.dart';
import '../../../../core/widgets/app_toast.dart';

/// Opens the WatchlistPickerSheet and handles result.
/// Call from movie/tv detail pages instead of toggling directly.
Future<void> showWatchlistPicker(
  BuildContext context,
  WidgetRef ref, {
  required int mediaId,
  required String mediaTitle,
  required MediaType mediaType,
  required String? posterPath,
  Object? movieOrSeries, // Movie or TVSeries, passed for convenience
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (_) => WatchlistPickerSheet(
      mediaId: mediaId,
      mediaTitle: mediaTitle,
      mediaType: mediaType,
      posterPath: posterPath,
    ),
  );
}

class WatchlistPickerSheet extends ConsumerStatefulWidget {
  final int mediaId;
  final String mediaTitle;
  final MediaType mediaType;
  final String? posterPath;

  const WatchlistPickerSheet({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    required this.posterPath,
  });

  @override
  ConsumerState<WatchlistPickerSheet> createState() =>
      _WatchlistPickerSheetState();
}

class _WatchlistPickerSheetState extends ConsumerState<WatchlistPickerSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _showCreateField = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createAndAdd() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final notifier = ref.read(watchlistProvider.notifier);
    final created = await notifier.createWatchlist(name);
    if (created == null || !mounted) return;

    await _addToWatchlist(created.id);

    if (mounted) {
      setState(() {
        _showCreateField = false;
        _nameController.clear();
      });
    }
  }

  Future<void> _addToWatchlist(String watchlistId) async {
    final notifier = ref.read(watchlistProvider.notifier);
    await notifier.addItem(
      watchlistId: watchlistId,
      id: widget.mediaId,
      title: widget.mediaTitle,
      posterPath: widget.posterPath,
      type: widget.mediaType,
    );
    if (mounted) {
      _showSuccessSnack();
    }
  }

  Future<void> _removeFromWatchlist(String watchlistId) async {
    await ref.read(watchlistProvider.notifier).removeItemFromWatchlist(
          watchlistId: watchlistId,
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
        );
  }

  void _showSuccessSnack() {
    AppToast.show(context, 'Aggiunto alla watchlist!');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final watchlistsAsync = ref.watch(userWatchlistsProvider);
    final containingIdsAsync = ref.watch(
      watchlistIdsContainingMediaProvider(widget.mediaId, widget.mediaType),
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aggiungi alla Watchlist',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfacePrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.mediaTitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Watchlist list
          watchlistsAsync.when(
            data: (watchlists) {
              final containingIds =
                  containingIdsAsync.value ?? <String>{};

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (watchlists.isEmpty && !_showCreateField)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: _EmptyWatchlistsHint(colors: colors, textTheme: textTheme),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md),
                        itemCount: watchlists.length,
                        itemBuilder: (_, i) {
                          final wl = watchlists[i];
                          final isIn = containingIds.contains(wl.id);
                          return _WatchlistPickerTile(
                            watchlist: wl,
                            isAdded: isIn,
                            onTap: isIn
                                ? () => _removeFromWatchlist(wl.id)
                                : () => _addToWatchlist(wl.id),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          // Create new field or button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _showCreateField
                ? _CreateWatchlistField(
                    controller: _nameController,
                    onConfirm: _createAndAdd,
                    onCancel: () => setState(() {
                      _showCreateField = false;
                      _nameController.clear();
                    }),
                    colors: colors,
                    textTheme: textTheme,
                  )
                : _NewWatchlistButton(
                    colors: colors,
                    textTheme: textTheme,
                    onTap: () => setState(() => _showCreateField = true),
                  ),
          ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _WatchlistPickerTile extends ConsumerWidget {
  final Watchlist watchlist;
  final bool isAdded;
  final VoidCallback onTap;

  const _WatchlistPickerTile({
    required this.watchlist,
    required this.isAdded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final itemsAsync = ref.watch(watchlistItemsProvider(watchlist.id));
    final count = itemsAsync.value?.length ?? watchlist.items.length;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isAdded
              ? colors.primary.withValues(alpha: 0.12)
              : colors.background.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isAdded
                    ? colors.primary
                    : colors.onSurfacePrimary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isAdded
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_outline_rounded,
                color: isAdded ? Colors.white : colors.onSurfaceSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    watchlist.name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isAdded
                          ? colors.primary
                          : colors.onSurfacePrimary,
                    ),
                  ),
                  Text(
                    '$count titoli',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isAdded)
              Icon(Icons.check_circle_rounded,
                  color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NewWatchlistButton extends StatelessWidget {
  final AppColorScheme colors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _NewWatchlistButton({
    required this.colors,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: colors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Crea nuova watchlist',
              style: textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateWatchlistField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final AppColorScheme colors;
  final TextTheme textTheme;

  const _CreateWatchlistField({
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Nome della watchlist…',
            hintStyle: TextStyle(color: colors.onSurfaceSecondary),
          ),
          onSubmitted: (_) => onConfirm(),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  side: BorderSide(
                    color: colors.onSurfaceSecondary.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                  foregroundColor: colors.onSurfaceSecondary,
                ),
                child: const Text('Annulla'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                    ),
                  ),
                  child: const Text('Crea'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyWatchlistsHint extends StatelessWidget {
  final AppColorScheme colors;
  final TextTheme textTheme;

  const _EmptyWatchlistsHint({
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          color: colors.onSurfaceSecondary,
          size: 16,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'Non hai ancora nessuna watchlist. Creane una!',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
