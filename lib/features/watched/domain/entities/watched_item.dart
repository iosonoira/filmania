import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';

part 'watched_item.freezed.dart';

@freezed
abstract class WatchedItem with _$WatchedItem {
  const factory WatchedItem({
    required String id,
    required String userId,
    required int mediaId,
    required String mediaTitle,
    required MediaType mediaType,
    String? posterPath,
    required DateTime watchedAt,
    int? runtimeMinutes,
  }) = _WatchedItem;
}
