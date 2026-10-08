// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_remote_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchlistRemoteDataSource)
final watchlistRemoteDataSourceProvider = WatchlistRemoteDataSourceProvider._();

final class WatchlistRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IWatchlistRemoteDataSource,
          IWatchlistRemoteDataSource,
          IWatchlistRemoteDataSource
        >
    with $Provider<IWatchlistRemoteDataSource> {
  WatchlistRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IWatchlistRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWatchlistRemoteDataSource create(Ref ref) {
    return watchlistRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWatchlistRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWatchlistRemoteDataSource>(value),
    );
  }
}

String _$watchlistRemoteDataSourceHash() =>
    r'015e1ff5c5e17e4142305c1f1e063a318f89fb0e';
