import 'package:filmania/features/movies/domain/entities/movie_trailer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_trailer_dto.freezed.dart';
part 'movie_trailer_dto.g.dart';

@freezed
abstract class MovieTrailerDto with _$MovieTrailerDto {
  const factory MovieTrailerDto({
    required String key,
    required String site,
    required String type,
  }) = _MovieTrailerDto;

  factory MovieTrailerDto.fromJson(Map<String, dynamic> json) => _$MovieTrailerDtoFromJson(json);

  const MovieTrailerDto._();

  MovieTrailer toEntity() {
    return MovieTrailer(
      key: key,
      site: site,
      type: type,
    );
  }
}
