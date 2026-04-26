import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_stats.dart';

part 'user_stats_dto.freezed.dart';
part 'user_stats_dto.g.dart';

@freezed
abstract class UserStatsDto with _$UserStatsDto {
  const factory UserStatsDto({
    @JsonKey(name: 'movies_watched_count') required int moviesWatchedCount,
    @JsonKey(name: 'tv_series_watched_count') required int tvSeriesWatchedCount,
    @JsonKey(name: 'episodes_watched_count') required int episodesWatchedCount,
    @JsonKey(name: 'total_watch_time_minutes') required int totalWatchTimeMinutes,
    @JsonKey(name: 'movies_watch_time_minutes') required int moviesWatchTimeMinutes,
    @JsonKey(name: 'tv_watch_time_minutes') required int tvWatchTimeMinutes,
    @JsonKey(name: 'last_updated_at') DateTime? lastUpdatedAt,
  }) = _UserStatsDto;

  const UserStatsDto._();

  factory UserStatsDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatsDtoFromJson(json);

  UserStats toEntity() => UserStats(
        moviesWatchedCount: moviesWatchedCount,
        tvSeriesWatchedCount: tvSeriesWatchedCount,
        episodesWatchedCount: episodesWatchedCount,
        totalWatchTimeMinutes: totalWatchTimeMinutes,
        moviesWatchTimeMinutes: moviesWatchTimeMinutes,
        tvWatchTimeMinutes: tvWatchTimeMinutes,
        lastUpdatedAt: lastUpdatedAt,
      );
}
