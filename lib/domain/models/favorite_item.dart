import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';

part 'favorite_item.freezed.dart';

@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required String id,
    required String userId,
    required int mediaId,
    required String mediaTitle,
    required MediaType mediaType,
    String? posterPath,
    required DateTime createdAt,
  }) = _FavoriteItem;
}
