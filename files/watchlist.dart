import 'package:freezed_annotation/freezed_annotation.dart';
import 'watchlist_item.dart';

part 'watchlist.freezed.dart';

@freezed
abstract class Watchlist with _$Watchlist {
  const factory Watchlist({
    required String id,
    required String userId,
    required String name,
    required DateTime createdAt,
    @Default([]) List<WatchlistItem> items,
  }) = _Watchlist;

  const Watchlist._();

  int get itemCount => items.length;

  /// Returns first poster URL of items, used as cover.
  String? get coverPosterUrl =>
      items.where((i) => i.fullPosterUrl != null).map((i) => i.fullPosterUrl).firstOrNull;
}
