import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tmdb_find_datasource.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tvtime_match_service.dart';
import 'package:filmania/features/tvtime_import/domain/entities/tvtime_raw_export.dart';

class _FakeAdapter implements HttpClientAdapter {
  int callCount = 0;
  final Map<String, int> callCountByPath = {};

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final path = options.path;
    callCountByPath[path] = (callCountByPath[path] ?? 0) + 1;

    // Simula un 429 alla prima chiamata per '429test', poi 200.
    if (path.contains('429test') && callCountByPath[path] == 1) {
      return ResponseBody.fromString(
        '{}',
        429,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    // Default: returning TV series result
    return ResponseBody.fromString(
      '{"tv_results":[{"id":81189,"name":"Breaking Bad","poster_path":"/x.jpg"}],"movie_results":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _EmptyAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"tv_results":[],"movie_results":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  group('TmdbFindDataSource', () {
    test('ritenta su 429 e alla fine ottiene un match', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbFindDataSource(dio);

      final result = await ds.findSeries(tvdbId: '429test');

      expect(result, isNotNull);
      expect(result!.tmdbId, 81189);
      expect(result.title, 'Breaking Bad');
    });
  });

  group('TvTimeMatchService', () {
    test(
      'raggruppa episodi per series: una sola chiamata TMDB per serie',
      () async {
        final adapter = _FakeAdapter();
        final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
        dio.httpClientAdapter = adapter;
        final ds = TmdbFindDataSource(dio);
        final service = TvTimeMatchService(ds);

        // Raw export: 3 episodi della stessa serie (tvdb_id 81189)
        final raw = TvTimeRawExport(
          movies: [],
          episodes: [
            TvTimeRawEpisodeRow(
              seriesTvdbId: '81189',
              seriesTitleHint: 'Breaking Bad',
              season: 1,
              episode: 1,
              isWatched: true,
            ),
            TvTimeRawEpisodeRow(
              seriesTvdbId: '81189',
              seriesTitleHint: 'Breaking Bad',
              season: 1,
              episode: 2,
              isWatched: true,
            ),
            TvTimeRawEpisodeRow(
              seriesTvdbId: '81189',
              seriesTitleHint: 'Breaking Bad',
              season: 2,
              episode: 1,
              isWatched: true,
            ),
          ],
          lists: [],
        );

        final result = await service.matchAll(raw, onProgress: (_) {});

        // Deve trovare tutti e 3 gli episodi
        expect(result.episodes, hasLength(3));
        expect(result.episodes.first.seriesTmdbId, 81189);
        expect(result.episodes.first.seasonNumber, 1);
        expect(result.episodes.first.episodeNumber, 1);

        // TMDB deve essere stato chiamato UNA SOLA VOLTA per la serie
        // (le richieste per gli episodi sono raggruppate)
        expect(
          adapter.callCountByPath.entries.where((e) => e.key.contains('find')),
          hasLength(1), // Una sola chiamata find per la serie
        );
      },
    );

    test('skippa episodi non watched', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbFindDataSource(dio);
      final service = TvTimeMatchService(ds);

      final raw = TvTimeRawExport(
        movies: [],
        episodes: [
          TvTimeRawEpisodeRow(
            seriesTvdbId: '81189',
            seriesTitleHint: 'Breaking Bad',
            season: 1,
            episode: 1,
            isWatched: true,
          ),
          TvTimeRawEpisodeRow(
            seriesTvdbId: '81189',
            seriesTitleHint: 'Breaking Bad',
            season: 1,
            episode: 2,
            isWatched: false, // Non watched
          ),
        ],
        lists: [],
      );

      final result = await service.matchAll(raw, onProgress: (_) {});

      // Solo l'episodio watched deve essere matchato
      expect(result.episodes, hasLength(1));
      expect(result.episodes.first.episodeNumber, 1);
    });

    test('gestisce episodi senza match come unmatched', () async {
      // Adapter che ritorna sempre risultati vuoti
      final badAdapter = _EmptyAdapter();

      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = badAdapter;
      final ds = TmdbFindDataSource(dio);
      final service = TvTimeMatchService(ds);

      final raw = TvTimeRawExport(
        movies: [],
        episodes: [
          TvTimeRawEpisodeRow(
            seriesTvdbId: 'unknown999',
            seriesTitleHint: 'Unknown Series',
            season: 1,
            episode: 1,
            isWatched: true,
          ),
        ],
        lists: [],
      );

      final result = await service.matchAll(raw, onProgress: (_) {});

      // Nessun episodio matchato
      expect(result.episodes, isEmpty);
      // Ma uno non-matchato registrato
      expect(result.unmatched, isNotEmpty);
      expect(result.unmatched.first.type, 'series');
      expect(result.unmatched.first.title, 'Unknown Series');
    });
  });
}
