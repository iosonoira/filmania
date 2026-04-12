import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/watchlist_item.dart';

part 'watchlist_item_dto.freezed.dart';
part 'watchlist_item_dto.g.dart';

@freezed
abstract class WatchlistItemDto with _$WatchlistItemDto {
  const factory WatchlistItemDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'movie_id') required int movieId,
    @JsonKey(name: 'movie_title') required String movieTitle,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'added_at') required DateTime addedAt,
  }) = _WatchlistItemDto;

  const WatchlistItemDto._();

  factory WatchlistItemDto.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemDtoFromJson(json);

  WatchlistItem toEntity() {
    return WatchlistItem(
      id: id,
      userId: userId,
      movieId: movieId,
      movieTitle: movieTitle,
      posterPath: posterPath,
      addedAt: addedAt,
    );
  }

  factory WatchlistItemDto.fromEntity(WatchlistItem entity) {
    return WatchlistItemDto(
      id: entity.id,
      userId: entity.userId,
      movieId: entity.movieId,
      movieTitle: entity.movieTitle,
      posterPath: entity.posterPath,
      addedAt: entity.addedAt,
    );
  }
}
