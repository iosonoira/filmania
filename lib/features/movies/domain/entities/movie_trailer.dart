import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_trailer.freezed.dart';

@freezed
abstract class MovieTrailer with _$MovieTrailer {
  const factory MovieTrailer({
    required String key,
    required String site,
    required String type,
  }) = _MovieTrailer;

  const MovieTrailer._();

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}
