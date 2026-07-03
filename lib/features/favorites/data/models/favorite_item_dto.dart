import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../domain/entities/favorite_item.dart';

part 'favorite_item_dto.freezed.dart';
part 'favorite_item_dto.g.dart';

@freezed
abstract class FavoriteItemDto with _$FavoriteItemDto {
  const FavoriteItemDto._();

  const factory FavoriteItemDto({
    @JsonKey(name: 'id') @Default('') String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'media_id') required int mediaId,
    @JsonKey(name: 'media_title') required String mediaTitle,
    @JsonKey(name: 'media_type') required String mediaType,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FavoriteItemDto;

  factory FavoriteItemDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemDtoFromJson(json);

  FavoriteItem toEntity() {
    return FavoriteItem(
      id: id,
      userId: userId,
      mediaId: mediaId,
      mediaTitle: mediaTitle,
      mediaType: MediaType.values.firstWhere(
        (e) => e.name == mediaType,
        orElse: () => MediaType.movie,
      ),
      posterPath: posterPath,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory FavoriteItemDto.fromEntity(FavoriteItem entity) {
    return FavoriteItemDto(
      id: entity.id,
      userId: entity.userId,
      mediaId: entity.mediaId,
      mediaTitle: entity.mediaTitle,
      mediaType: entity.mediaType.name,
      posterPath: entity.posterPath,
      createdAt: entity.createdAt,
    );
  }
}
