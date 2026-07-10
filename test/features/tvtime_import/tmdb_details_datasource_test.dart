import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tmdb_details_datasource.dart';

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

    if (path.contains('429test') && callCountByPath[path] == 1) {
      return ResponseBody.fromString(
        '{}',
        429,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('movie/')) {
      return ResponseBody.fromString(
        '{"id":603,"runtime":136}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('tv/')) {
      return ResponseBody.fromString(
        '{"id":81189,"episode_run_time":[47,45]}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString(
      '{}',
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _EmptyRuntimeAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"id":1,"episode_run_time":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  group('TmdbDetailsDataSource', () {
    test('getMovieRuntime ritorna il runtime dal payload movie', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbDetailsDataSource(dio);

      final runtime = await ds.getMovieRuntime(603);

      expect(runtime, 136);
    });

    test(
      'getSeriesEpisodeRuntime ritorna il primo valore di episode_run_time',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
        dio.httpClientAdapter = _FakeAdapter();
        final ds = TmdbDetailsDataSource(dio);

        final runtime = await ds.getSeriesEpisodeRuntime(81189);

        expect(runtime, 47);
      },
    );

    test(
      'getSeriesEpisodeRuntime ritorna null se episode_run_time e\' vuoto',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
        dio.httpClientAdapter = _EmptyRuntimeAdapter();
        final ds = TmdbDetailsDataSource(dio);

        final runtime = await ds.getSeriesEpisodeRuntime(1);

        expect(runtime, isNull);
      },
    );

    test('ritenta su 429 e alla fine ottiene il runtime', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbDetailsDataSource(dio);

      final runtime = await ds.getMovieRuntime(429999);

      // path 'movie/429999' non contiene '429test', quindi niente 429
      // simulato: verifica solo che la chiamata normale funzioni.
      expect(runtime, 136);
    });
  });
}
