// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tmdbClient)
final tmdbClientProvider = TmdbClientProvider._();

final class TmdbClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
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

String _$tmdbClientHash() => r'6750dda0720347eddbfde594e3ff8175144d579f';
