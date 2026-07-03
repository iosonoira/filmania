// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_remote_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoritesRemoteDataSource)
final favoritesRemoteDataSourceProvider = FavoritesRemoteDataSourceProvider._();

final class FavoritesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IFavoritesRemoteDataSource,
          IFavoritesRemoteDataSource,
          IFavoritesRemoteDataSource
        >
    with $Provider<IFavoritesRemoteDataSource> {
  FavoritesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IFavoritesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IFavoritesRemoteDataSource create(Ref ref) {
    return favoritesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IFavoritesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IFavoritesRemoteDataSource>(value),
    );
  }
}

String _$favoritesRemoteDataSourceHash() =>
    r'dd879c11ab79fda12522e15981e21ae8411bfe4e';
