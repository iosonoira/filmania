import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glassmorphic_app_bar.dart';
import '../providers/tvtime_import_notifier.dart';
import '../providers/tvtime_import_state.dart';
import '../../domain/enums/tvtime_import_phase.dart';

class TvTimeImportPage extends ConsumerWidget {
  const TvTimeImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tvTimeImportProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: switch (state) {
            TvTimeImportIdle() => _IdleView(
              onPick: () => _pickAndProcess(context, ref),
            ),
            TvTimeImportProcessing(:final progress) => _ProgressView(
              progress: progress,
            ),
            TvTimeImportReady(:final matchResult) => _PreviewView(
              matchResult: matchResult,
              onConfirm: () =>
                  ref.read(tvTimeImportProvider.notifier).confirmImport(),
            ),
            TvTimeImportWriting(:final progress) => _ProgressView(
              progress: progress,
            ),
            TvTimeImportDone(:final matchResult) => _DoneView(
              matchResult: matchResult,
            ),
            TvTimeImportError(:final failure) => _ErrorView(
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
  const _IdleView({required this.onPick});
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Importa da TV Time',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Esporta i tuoi dati da TV Time e seleziona il file .zip',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton(
          onPressed: onPick,
          child: const Text('Seleziona file zip'),
        ),
      ],
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.progress});
  final dynamic progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = progress.total == 0 ? 0.0 : progress.current / progress.total;
    final phaseLabel = switch (progress.phase) {
      TvTimeImportPhase.parsingArchive => 'Estrazione file...',
      TvTimeImportPhase.matchingMovies =>
        'Matching film TMDB... ${progress.current}/${progress.total}',
      TvTimeImportPhase.matchingSeries =>
        'Matching serie TMDB... ${progress.current}/${progress.total}',
      TvTimeImportPhase.writingData =>
        'Scrittura dati... ${progress.current}/${progress.total}',
      _ => 'Processamento...',
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
  const _PreviewView({required this.matchResult, required this.onConfirm});
  final dynamic matchResult;
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
            'Anteprima import',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CountCard(label: 'Film', count: matchResult.movies.length),
          _CountCard(label: 'Episodi', count: matchResult.episodes.length),
          _CountCard(label: 'Liste', count: matchResult.lists.length),
          _CountCard(label: 'Item liste', count: totalListItems),
          if (matchResult.unmatched.isNotEmpty)
            _UnmatchedExpansion(unmatched: matchResult.unmatched),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Conferma e importa'),
          ),
        ],
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.matchResult});
  final dynamic matchResult;

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
            'Import completato',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CountCard(label: 'Film importati', count: matchResult.movies.length),
          _CountCard(
            label: 'Episodi importati',
            count: matchResult.episodes.length,
          ),
          _CountCard(label: 'Liste importate', count: matchResult.lists.length),
          _CountCard(label: 'Item liste importati', count: totalListItems),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Torna alle impostazioni'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
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
          'Errore durante l\'import',
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
        ElevatedButton(onPressed: onRetry, child: const Text('Riprova')),
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
  const _UnmatchedExpansion({required this.unmatched});
  final List<dynamic> unmatched;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Text(
        '${unmatched.length} elementi non trovati su TMDB',
        style: theme.textTheme.bodyMedium,
      ),
      children: [
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
                  'Motivo: ${item.reason}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
