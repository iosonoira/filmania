import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/tv_series.dart';
import 'tv_season_dto.dart';

part 'tv_series_dto.freezed.dart';
part 'tv_series_dto.g.dart';

@freezed
abstract class TVSeriesDto with _$TVSeriesDto {
  const factory TVSeriesDto({
    required int id,
    required String name,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @Default([]) List<TVSeasonDto> seasons,
  }) = _TVSeriesDto;

  factory TVSeriesDto.fromJson(Map<String, dynamic> json) =>
      _$TVSeriesDtoFromJson(json);

  const TVSeriesDto._();

  TVSeries toEntity() => TVSeries(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    firstAirDate: firstAirDate != null
        ? DateTime.tryParse(firstAirDate!)
        : null,
    voteAverage: voteAverage ?? 0.0,
    seasons: seasons.map((s) => s.toEntity()).toList(),
  );
}
