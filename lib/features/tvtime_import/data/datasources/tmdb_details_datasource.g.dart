// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_details_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tmdbDetailsDataSource)
final tmdbDetailsDataSourceProvider = TmdbDetailsDataSourceProvider._();

final class TmdbDetailsDataSourceProvider
    extends
        $FunctionalProvider<
          TmdbDetailsDataSource,
          TmdbDetailsDataSource,
          TmdbDetailsDataSource
        >
    with $Provider<TmdbDetailsDataSource> {
  TmdbDetailsDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbDetailsDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbDetailsDataSourceHash();

  @$internal
  @override
  $ProviderElement<TmdbDetailsDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TmdbDetailsDataSource create(Ref ref) {
    return tmdbDetailsDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TmdbDetailsDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TmdbDetailsDataSource>(value),
    );
  }
}

String _$tmdbDetailsDataSourceHash() =>
    r'4b37570b4a60ea4ade83e7b7a3e11947b1603326';
