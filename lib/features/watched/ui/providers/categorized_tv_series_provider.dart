import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/utils/concurrency.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/watched_item.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import 'watched_providers.dart';

part 'categorized_tv_series_provider.g.dart';

enum TvSeriesWatchStatus {
  watching, // "In visione"
  upToDate, // "In pari"
  watchLater, // "Guarda più tardi"
  completed, // "Terminate"
  dropped, // "Interrotte"
}

class CategorizedTvSeries {
  final WatchedItem series;
  final TvSeriesWatchStatus status;

  CategorizedTvSeries({required this.series, required this.status});
}

@riverpod
Future<List<CategorizedTvSeries>> categorizedTvSeries(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];

  final watchedItemsAsync = ref.watch(watchedItemsProvider(MediaType.tv));

  if (watchedItemsAsync.isLoading || !watchedItemsAsync.hasValue) {
    return [];
  }

  final watchedItems = watchedItemsAsync.value!;
  final repo = ref.watch(watchedRepositoryProvider);

  final List<CategorizedTvSeries> result = [];

  // Le serie già marcate "interrotta" hanno priorità assoluta sul calcolo
  // automatico e non richiedono nessuna chiamata di rete: separate subito
  // dalle altre, che invece vanno arricchite con conteggio episodi + dettagli TMDB.
  // Le serie "guarda più tardi" hanno la stessa ottimizzazione e la priorità
  // subito dopo isDropped: l'utente ha scelto esplicitamente di rimandarle,
  // il calcolo automatico non deve sovrascrivere questa scelta.
  final droppedItems = [];
  final watchLaterItems = [];
  final activeItems = [];
  for (final item in watchedItems) {
    if (item.isDropped) {
      droppedItems.add(item);
    } else if (item.isWatchLater) {
      watchLaterItems.add(item);
    } else {
      activeItems.add(item);
    }
  }

  for (final item in droppedItems) {
    result.add(
      CategorizedTvSeries(series: item, status: TvSeriesWatchStatus.dropped),
    );
  }

  for (final item in watchLaterItems) {
    result.add(
      CategorizedTvSeries(
        series: item,
        status: TvSeriesWatchStatus.watchLater,
      ),
    );
  }

  if (activeItems.isEmpty) {
    return result;
  }

  // Fix 1/2: una sola query Supabase per il conteggio episodi visti di
  // TUTTE le serie attive, invece di una query per serie (era il primo
  // N+1 di questo provider). Se la query fallisce, si ricade su una mappa
  // vuota: ogni serie verrà trattata come "in visione" (watchedCount 0
  // totalEpisodes) — stesso fallback conservativo già usato in precedenza
  // per gli errori per-singola-serie, solo applicato qui a tutto il batch.
  Map<int, int> watchedCounts;
  try {
    watchedCounts = await repo.getWatchedEpisodesCountsForSeries(
      userId: user.id,
      seriesIds: activeItems.map((i) => i.mediaId).toList().cast<int>(),
    );
  } catch (e) {
    watchedCounts = {};
  }

  // Fix 2/2: fetch dei dettagli TMDB in parallelo con concorrenza limitata
  // (5, stessa convenzione già usata in tvtime_match_service.dart) invece
  // di un `for` con `await` sequenziale — era il secondo N+1 di questo
  // provider ed è quello che pesa di più (chiamata di rete esterna).
  final categorized = await mapWithConcurrency(
    activeItems,
    5,
    (item) async {
      try {
        final watchedCount = watchedCounts[item.mediaId] ?? 0;

        final seriesDetails = await ref.watch(
          tvSeriesDetailsProvider(item.mediaId).future,
        );
        final totalEpisodes = seriesDetails.seasons
            .where((s) => s.seasonNumber > 0)
            .fold(0, (sum, s) => sum + s.episodeCount);

        TvSeriesWatchStatus status;
        if (watchedCount < totalEpisodes) {
          status = TvSeriesWatchStatus.watching;
        } else {
          if (seriesDetails.status.toLowerCase() == 'ended' ||
              seriesDetails.status.toLowerCase() == 'canceled') {
            status = TvSeriesWatchStatus.completed;
          } else {
            status = TvSeriesWatchStatus.upToDate;
          }
        }

        return CategorizedTvSeries(series: item, status: status);
      } catch (e) {
        return CategorizedTvSeries(
          series: item,
          status: TvSeriesWatchStatus.watching,
        );
      }
    },
  );

  result.addAll(categorized);
  return result;
}
