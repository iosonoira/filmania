import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_dto.freezed.dart';
part 'watchlist_dto.g.dart';

@freezed
abstract class WatchlistDto with _$WatchlistDto {
  const factory WatchlistDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WatchlistDto;

  const WatchlistDto._();

  factory WatchlistDto.fromJson(Map<String, dynamic> json) =>
      _$WatchlistDtoFromJson(json);

  Map<String, dynamic> toInsertJson() => {
        'user_id': userId,
        'name': name,
      };
}
