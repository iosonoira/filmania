import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:filmania/core/env/env.dart';
import 'tmdb_auth_interceptor.dart';

part 'tmdb_client.g.dart';

@Riverpod(keepAlive: true)
Dio tmdbClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    TmdbAuthInterceptor(apiToken: Env.tmdbApiKey),
  );

  return dio;
}
