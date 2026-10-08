// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_remote_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchedRemoteDataSource)
final watchedRemoteDataSourceProvider = WatchedRemoteDataSourceProvider._();

final class WatchedRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IWatchedRemoteDataSource,
          IWatchedRemoteDataSource,
          IWatchedRemoteDataSource
        >
    with $Provider<IWatchedRemoteDataSource> {
  WatchedRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchedRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchedRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IWatchedRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWatchedRemoteDataSource create(Ref ref) {
    return watchedRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWatchedRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWatchedRemoteDataSource>(value),
    );
  }
}

String _$watchedRemoteDataSourceHash() =>
    r'8e9a406aea36eba7ab63564392e171e03875f14c';
