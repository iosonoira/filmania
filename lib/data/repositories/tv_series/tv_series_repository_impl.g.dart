// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tvSeriesRemoteDataSource)
final tvSeriesRemoteDataSourceProvider = TvSeriesRemoteDataSourceProvider._();

final class TvSeriesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ITVSeriesRemoteDataSource,
          ITVSeriesRemoteDataSource,
          ITVSeriesRemoteDataSource
        >
    with $Provider<ITVSeriesRemoteDataSource> {
  TvSeriesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvSeriesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvSeriesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ITVSeriesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITVSeriesRemoteDataSource create(Ref ref) {
    return tvSeriesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITVSeriesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITVSeriesRemoteDataSource>(value),
    );
  }
}

String _$tvSeriesRemoteDataSourceHash() =>
    r'7ebf3da5fb2919afaeb43d02fc28af87b8649751';

@ProviderFor(tvSeriesRepository)
final tvSeriesRepositoryProvider = TvSeriesRepositoryProvider._();

final class TvSeriesRepositoryProvider
    extends
        $FunctionalProvider<
          ITVSeriesRepository,
          ITVSeriesRepository,
          ITVSeriesRepository
        >
    with $Provider<ITVSeriesRepository> {
  TvSeriesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvSeriesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvSeriesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITVSeriesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITVSeriesRepository create(Ref ref) {
    return tvSeriesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITVSeriesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITVSeriesRepository>(value),
    );
  }
}

String _$tvSeriesRepositoryHash() =>
    r'a41433c4fe7d1398d6107b67428b644d58d890b7';
