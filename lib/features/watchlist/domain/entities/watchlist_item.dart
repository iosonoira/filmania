import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../discover/ui/providers/discover_providers.dart';

part 'watchlist_item.freezed.dart';

@freezed
abstract class WatchlistItem with _$WatchlistItem {
  const factory WatchlistItem({
    required String id,
    required String userId,
    required int mediaId,
    required String title,
    required DiscoverMediaType mediaType,
    required String? posterPath,
    required DateTime addedAt,
  }) = _WatchlistItem;

  const WatchlistItem._();

  String get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';
}
