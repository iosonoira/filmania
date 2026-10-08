import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    required int moviesWatchedCount,
    required int tvSeriesWatchedCount,
    required int episodesWatchedCount,
    required int totalWatchTimeMinutes,
    required int moviesWatchTimeMinutes,
    required int tvWatchTimeMinutes,
    required DateTime? lastUpdatedAt,
  }) = _UserStats;
}
