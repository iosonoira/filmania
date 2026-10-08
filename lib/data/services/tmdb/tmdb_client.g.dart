// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Singleton Dio client pre-configured for the TMDB API.
///
/// Interceptor order (mandatory per networking rules):
/// 1. [TmdbAuthInterceptor]  — injects Bearer token on every request
/// 2. [PrettyDioLogger]      — logs requests/responses in debug mode only
/// 3. [TmdbRetryInterceptor] — retries idempotent GET requests (max 3, exponential back-off)

@ProviderFor(tmdbClient)
final tmdbClientProvider = TmdbClientProvider._();

/// Singleton Dio client pre-configured for the TMDB API.
///
/// Interceptor order (mandatory per networking rules):
/// 1. [TmdbAuthInterceptor]  — injects Bearer token on every request
/// 2. [PrettyDioLogger]      — logs requests/responses in debug mode only
/// 3. [TmdbRetryInterceptor] — retries idempotent GET requests (max 3, exponential back-off)

final class TmdbClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Singleton Dio client pre-configured for the TMDB API.
  ///
  /// Interceptor order (mandatory per networking rules):
  /// 1. [TmdbAuthInterceptor]  — injects Bearer token on every request
  /// 2. [PrettyDioLogger]      — logs requests/responses in debug mode only
  /// 3. [TmdbRetryInterceptor] — retries idempotent GET requests (max 3, exponential back-off)
  TmdbClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return tmdbClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$tmdbClientHash() => r'10486e6fbc40f421bab45da432bbf0b8990a983c';
