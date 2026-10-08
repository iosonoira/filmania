import 'dart:math' show min;

import 'package:dio/dio.dart';

/// Retries idempotent GET requests on timeout or connection errors.
///
/// Rules:
/// - Max [maxRetries] attempts (default: 3).
/// - Only retries GET requests — never POST, PUT, DELETE, PATCH.
/// - Only retries on [DioExceptionType.connectionTimeout],
///   [DioExceptionType.receiveTimeout], [DioExceptionType.connectionError].
/// - Uses exponential back-off: 500ms * 2^attempt (capped at 8s).
/// - Never retries on 4xx or 5xx HTTP errors.
class TmdbRetryInterceptor extends Interceptor {
  TmdbRetryInterceptor({required this.dio, this.maxRetries = 3});

  final Dio dio;
  final int maxRetries;

  static const _retryableTypes = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.connectionError,
  };

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    if (options.method.toUpperCase() != 'GET') {
      return handler.next(err);
    }

    if (!_retryableTypes.contains(err.type)) {
      return handler.next(err);
    }

    final attempt = (options.extra['_retryCount'] as int?) ?? 0;

    if (attempt >= maxRetries) {
      return handler.next(err);
    }

    final delayMs = min(500 * (1 << attempt), 8000);
    await Future<void>.delayed(Duration(milliseconds: delayMs));

    options.extra['_retryCount'] = attempt + 1;

    try {
      final response = await dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }
}
