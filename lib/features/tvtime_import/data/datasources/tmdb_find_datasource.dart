import 'dart:async';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/network/tmdb_client.dart';

part 'tmdb_find_datasource.g.dart';

class TmdbFindResult {
  final int tmdbId;
  final String title;
  final String? posterPath;
  const TmdbFindResult({required this.tmdbId, required this.title, this.posterPath});
}

/// Chiama GET /find/{external_id}?external_source=imdb_id|tvdb_id.
/// Gestisce da sola il retry sui 429 (rate limit TMDB) con backoff
/// esponenziale, perché l'interceptor globale del Dio condiviso NON
/// ritenta le risposte 4xx/5xx (solo timeout/connection error).
class TmdbFindDataSource {
  final Dio _dio;
  TmdbFindDataSource(this._dio);

  Future<TmdbFindResult?> findMovie({required String imdbId, required String tvdbId}) async {
    if (imdbId.isNotEmpty) {
      final r = await _find(imdbId, 'imdb_id');
      final results = r?['movie_results'] as List?;
      if (results != null && results.isNotEmpty) return _toResult(results.first as Map<String, dynamic>, 'title');
    }
    if (tvdbId.isNotEmpty) {
      final r = await _find(tvdbId, 'tvdb_id');
      final results = r?['movie_results'] as List?;
      if (results != null && results.isNotEmpty) return _toResult(results.first as Map<String, dynamic>, 'title');
    }
    return null;
  }

  Future<TmdbFindResult?> findSeries({required String tvdbId}) async {
    if (tvdbId.isEmpty) return null;
    final r = await _find(tvdbId, 'tvdb_id');
    final results = r?['tv_results'] as List?;
    if (results == null || results.isEmpty) return null;
    return _toResult(results.first as Map<String, dynamic>, 'name');
  }

  TmdbFindResult _toResult(Map<String, dynamic> json, String titleField) {
    return TmdbFindResult(
      tmdbId: json['id'] as int,
      title: (json[titleField] ?? '') as String,
      posterPath: json['poster_path'] as String?,
    );
  }

  Future<Map<String, dynamic>?> _find(String externalId, String source, {int attempt = 0}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'find/$externalId',
        queryParameters: {'external_source': source},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 && attempt < 3) {
        final delayMs = 1000 * (1 << attempt); // 1s, 2s, 4s
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        return _find(externalId, source, attempt: attempt + 1);
      }
      return null; // dopo i retry, o su altri errori: nessun match, gestito a monte come "unmatched"
    }
  }
}

@riverpod
TmdbFindDataSource tmdbFindDataSource(Ref ref) {
  return TmdbFindDataSource(ref.watch(tmdbClientProvider));
}
