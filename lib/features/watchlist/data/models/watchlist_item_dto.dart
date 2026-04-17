import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../domain/entities/watchlist_item.dart';

part 'watchlist_item_dto.freezed.dart';
part 'watchlist_item_dto.g.dart';

@freezed
abstract class WatchlistItemDto with _$WatchlistItemDto {
  const factory WatchlistItemDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'movie_id') required int mediaId,
    @JsonKey(name: 'movie_title') required String title,
    @JsonKey(name: 'media_type') @Default(MediaType.movie) MediaType mediaType,
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
      mediaId: mediaId,
      title: title,
      mediaType: mediaType,
      posterPath: posterPath,
      addedAt: addedAt,
    );
  }

  factory WatchlistItemDto.fromEntity(WatchlistItem entity) {
    return WatchlistItemDto(
      id: entity.id,
      userId: entity.userId,
      mediaId: entity.mediaId,
      title: entity.title,
      mediaType: entity.mediaType,
      posterPath: entity.posterPath,
      addedAt: entity.addedAt,
    );
  }
}
