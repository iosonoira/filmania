import 'dart:async';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/data/services/tmdb/tmdb_client.dart';

part 'tmdb_details_datasource.g.dart';

/// Recupera il runtime (minuti) da TMDB per film e serie, usato solo
/// durante l'import TV Time per popolare `runtime_minutes` — il
/// matching (`TmdbFindDataSource`) usa `/find` che non lo restituisce.
/// Stesso pattern di `TmdbFindDataSource`: retry manuale sui 429, perché
/// l'interceptor globale del Dio condiviso non ritenta 4xx/5xx.
class TmdbDetailsDataSource {
  final Dio _dio;
  TmdbDetailsDataSource(this._dio);

  Future<int?> getMovieRuntime(int movieId) async {
    final data = await _get('movie/$movieId');
    final runtime = data?['runtime'];
    return runtime is int ? runtime : null;
  }

  Future<int?> getSeriesEpisodeRuntime(int seriesId) async {
    final data = await _get('tv/$seriesId');
    final runtimes = data?['episode_run_time'] as List?;
    if (runtimes == null || runtimes.isEmpty) return null;
    final first = runtimes.first;
    return first is int ? first : null;
  }

  Future<Map<String, dynamic>?> _get(String path, {int attempt = 0}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 && attempt < 3) {
        final delayMs = 1000 * (1 << attempt); // 1s, 2s, 4s
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        return _get(path, attempt: attempt + 1);
      }
      return null; // dopo i retry, o su altri errori: runtime non disponibile
    }
  }
}

@riverpod
TmdbDetailsDataSource tmdbDetailsDataSource(Ref ref) {
  return TmdbDetailsDataSource(ref.watch(tmdbClientProvider));
}
