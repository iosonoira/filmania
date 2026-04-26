import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:filmania/core/env/env.dart';
import 'tmdb_auth_interceptor.dart';
import 'tmdb_retry_interceptor.dart';

part 'tmdb_client.g.dart';

/// Singleton Dio client pre-configured for the TMDB API.
///
/// Interceptor order (mandatory per networking rules):
/// 1. [TmdbAuthInterceptor]  — injects Bearer token on every request
/// 2. [PrettyDioLogger]      — logs requests/responses in debug mode only
/// 3. [TmdbRetryInterceptor] — retries idempotent GET requests (max 3, exponential back-off)
@Riverpod(keepAlive: true)
Dio tmdbClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.addAll([
    TmdbAuthInterceptor(apiToken: Env.tmdbApiKey),
    if (kDebugMode)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    TmdbRetryInterceptor(dio: dio, maxRetries: 3),
  ]);

  return dio;
}
