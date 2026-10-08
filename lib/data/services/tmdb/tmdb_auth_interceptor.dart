import 'package:dio/dio.dart';

/// Injects TMDB Bearer token into every request.
///
/// Token injected at construction time via [apiToken] so the interceptor
/// stays testable and never reads secrets inline.
class TmdbAuthInterceptor extends Interceptor {
  const TmdbAuthInterceptor({required this.apiToken});

  final String apiToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $apiToken';
    }
    handler.next(options);
  }
}
