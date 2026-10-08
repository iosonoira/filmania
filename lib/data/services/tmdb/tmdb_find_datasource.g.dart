// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_find_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tmdbFindDataSource)
final tmdbFindDataSourceProvider = TmdbFindDataSourceProvider._();

final class TmdbFindDataSourceProvider
    extends
        $FunctionalProvider<
          TmdbFindDataSource,
          TmdbFindDataSource,
          TmdbFindDataSource
        >
    with $Provider<TmdbFindDataSource> {
  TmdbFindDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tmdbFindDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tmdbFindDataSourceHash();

  @$internal
  @override
  $ProviderElement<TmdbFindDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TmdbFindDataSource create(Ref ref) {
    return tmdbFindDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TmdbFindDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TmdbFindDataSource>(value),
    );
  }
}

String _$tmdbFindDataSourceHash() =>
    r'951738f4b10f85509ee9dbc276f4753ce299ad37';
