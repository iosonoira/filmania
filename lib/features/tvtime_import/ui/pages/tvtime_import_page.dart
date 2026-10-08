import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/core/ui/glassmorphic_app_bar.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/utils/logger.dart';
import 'package:filmania/features/tvtime_import/ui/providers/tvtime_import_notifier.dart';
import 'package:filmania/features/tvtime_import/ui/providers/tvtime_import_state.dart';
import 'package:filmania/domain/models/tvtime_import_phase.dart';
import 'package:filmania/domain/models/tvtime_import_progress.dart';
import 'package:filmania/domain/models/tvtime_matched_data.dart';

class TvTimeImportPage extends ConsumerWidget {
  const TvTimeImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tvTimeImportProvider);
    final l10n = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: switch (state) {
            TvTimeImportIdle() => _IdleView(
              l10n: l10n,
              onPick: () => _pickAndProcess(context, ref),
            ),
            TvTimeImportProcessing(:final progress) => _ProgressView(
              l10n: l10n,
              progress: progress,
            ),
            TvTimeImportReady(:final matchResult) => _PreviewView(
              l10n: l10n,
              matchResult: matchResult,
              onConfirm: () =>
                  ref.read(tvTimeImportProvider.notifier).confirmImport(),
            ),
            TvTimeImportWriting(:final progress) => _ProgressView(
              l10n: l10n,
              progress: progress,
            ),
            TvTimeImportDone(:final matchResult) => _DoneView(
              l10n: l10n,
              matchResult: matchResult,
            ),
            TvTimeImportError(:final failure) => _ErrorView(
              l10n: l10n,
              message: failure.message,
              onRetry: () => ref.read(tvTimeImportProvider.notifier).reset(),
            ),
          },
        ),
      ),
    );
  }

  Future<void> _pickAndProcess(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;
    if (!context.mounted) return;
    await ref
        .read(tvTimeImportProvider.notifier)
        .processZip(result.files.single.bytes!);
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.l10n, required this.onPick});
  final dynamic l10n;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.importTvTimeTitle,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.importTvTimeInstructions,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton(
          onPressed: onPick,
          child: Text(l10n.importTvTimePickButton),
        ),
      ],
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.l10n, required this.progress});
  final dynamic l10n;
  final TvTimeImportProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = progress.total == 0 ? 0.0 : progress.current / progress.total;
    final phaseLabel = switch (progress.phase) {
      TvTimeImportPhase.parsingArchive => l10n.importTvTimeParsing as String,
      TvTimeImportPhase.matchingMovies =>
        '${l10n.importTvTimeMatchingMovies} ${progress.current}/${progress.total}',
      TvTimeImportPhase.matchingSeries =>
        '${l10n.importTvTimeMatchingSeries} ${progress.current}/${progress.total}',
      TvTimeImportPhase.fetchingRuntimes =>
        '${l10n.importTvTimeFetchingRuntimes} ${progress.current}/${progress.total}',
      TvTimeImportPhase.writingData =>
        '${l10n.importTvTimeWriting} ${progress.current}/${progress.total}',
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          phaseLabel,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        LinearProgressIndicator(value: progress.total == 0 ? null : pct),
      ],
    );
  }
}

class _PreviewView extends StatelessWidget {
  const _PreviewView({
    required this.l10n,
    required this.matchResult,
    required this.onConfirm,
  });
  final dynamic l10n;
  final TvTimeMatchResult matchResult;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalListItems = matchResult.lists.fold<int>(
      0,
      (sum, list) => sum + list.items.length,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.importTvTimePreviewTitle,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CountCard(
            label: l10n.importTvTimeCountMovies,
            count: matchResult.movies.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountEpisodes,
            count: matchResult.episodes.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountLists,
            count: matchResult.lists.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountListItems,
            count: totalListItems,
          ),
          if (matchResult.unmatched.isNotEmpty)
            _UnmatchedExpansion(l10n: l10n, unmatched: matchResult.unmatched),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: onConfirm,
            child: Text(l10n.importTvTimeConfirm),
          ),
        ],
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.l10n, required this.matchResult});
  final dynamic l10n;
  final TvTimeMatchResult matchResult;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final totalListItems = matchResult.lists.fold<int>(
      0,
      (sum, list) => sum + list.items.length,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle, size: 64, color: colors.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.importTvTimeDone,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CountCard(
            label: l10n.importTvTimeCountMoviesImported,
            count: matchResult.movies.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountEpisodesImported,
            count: matchResult.episodes.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountListsImported,
            count: matchResult.lists.length,
          ),
          _CountCard(
            label: l10n.importTvTimeCountListItemsImported,
            count: totalListItems,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: Text(l10n.importTvTimeBackToSettings),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.l10n,
    required this.message,
    required this.onRetry,
  });
  final dynamic l10n;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.error, size: 64, color: colors.error),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.importTvTimeErrorTitle,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        ElevatedButton(onPressed: onRetry, child: Text(l10n.importTvTimeRetry)),
      ],
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.label, required this.count});
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    return Card(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(count.toString(), style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

class _UnmatchedExpansion extends StatelessWidget {
  const _UnmatchedExpansion({required this.l10n, required this.unmatched});
  final dynamic l10n;
  final List<UnmatchedTvTimeItem> unmatched;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        l10n.importTvTimeUnmatchedCount(unmatched.length) as String,
        style: theme.textTheme.bodyMedium,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _downloadUnmatchedCsv(unmatched),
              icon: const Icon(Icons.download),
              label: Text(l10n.importTvTimeDownloadUnmatched as String),
            ),
          ),
        ),
        for (final item in unmatched)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.type}: ${item.title}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '${l10n.importTvTimeUnmatchedReason}: ${item.reason}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Genera un CSV (tipo, titolo, motivo, tmdb_id vuoto) con gli item non
  /// trovati su TMDB e apre il dialog di salvataggio del sistema operativo.
  /// La colonna `tmdb_id` è lasciata vuota apposta: pensata per essere
  /// compilata a mano in un secondo momento. Nessun re-import automatico da
  /// questo CSV oggi — solo consultazione/compilazione manuale, fuori scope.
  Future<void> _downloadUnmatchedCsv(List<UnmatchedTvTimeItem> items) async {
    try {
      final rows = <List>[
        ['tipo', 'titolo', 'motivo', 'tmdb_id'],
        for (final item in items) [item.type, item.title, item.reason, ''],
      ];
      final csvString = const ListToCsvConverter().convert(rows);
      final bytes = Uint8List.fromList(utf8.encode(csvString));
      await FilePicker.platform.saveFile(
        fileName: 'tvtime_import_non_trovati.csv',
        bytes: bytes,
      );
    } catch (e) {
      AppLogger.error(
        'TvTime unmatched CSV download failed',
        tag: 'TvTimeImportPage',
        exception: e,
      );
    }
  }
}
