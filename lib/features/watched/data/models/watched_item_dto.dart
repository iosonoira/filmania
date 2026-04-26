import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../domain/entities/watched_item.dart';

part 'watched_item_dto.freezed.dart';
part 'watched_item_dto.g.dart';

@freezed
abstract class WatchedItemDto with _$WatchedItemDto {
  const WatchedItemDto._();

  const factory WatchedItemDto({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'media_id') required int mediaId,
    @JsonKey(name: 'media_title') required String mediaTitle,
    @JsonKey(name: 'media_type') required String mediaType,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'watched_at') DateTime? watchedAt,
    @JsonKey(name: 'runtime_minutes') int? runtimeMinutes,
  }) = _WatchedItemDto;

  factory WatchedItemDto.fromJson(Map<String, dynamic> json) =>
      _$WatchedItemDtoFromJson(json);

  WatchedItem toEntity() {
    return WatchedItem(
      id: id,
      userId: userId,
      mediaId: mediaId,
      mediaTitle: mediaTitle,
      mediaType: MediaType.values.firstWhere(
        (e) => e.name == mediaType,
        orElse: () => MediaType.movie,
      ),
      posterPath: posterPath,
      watchedAt: watchedAt ?? DateTime.now(),
      runtimeMinutes: runtimeMinutes,
    );
  }

  factory WatchedItemDto.fromEntity(WatchedItem entity) {
    return WatchedItemDto(
      id: entity.id,
      userId: entity.userId,
      mediaId: entity.mediaId,
      mediaTitle: entity.mediaTitle,
      mediaType: entity.mediaType.name,
      posterPath: entity.posterPath,
      watchedAt: entity.watchedAt,
      runtimeMinutes: entity.runtimeMinutes,
    );
  }
}
