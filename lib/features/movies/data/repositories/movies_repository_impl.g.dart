// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moviesRemoteDataSource)
final moviesRemoteDataSourceProvider = MoviesRemoteDataSourceProvider._();

final class MoviesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IMoviesRemoteDataSource,
          IMoviesRemoteDataSource,
          IMoviesRemoteDataSource
        >
    with $Provider<IMoviesRemoteDataSource> {
  MoviesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IMoviesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IMoviesRemoteDataSource create(Ref ref) {
    return moviesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMoviesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMoviesRemoteDataSource>(value),
    );
  }
}

String _$moviesRemoteDataSourceHash() =>
    r'9a0360ae6b78a68e5209b94e1050805d1c8c405a';

@ProviderFor(moviesRepository)
final moviesRepositoryProvider = MoviesRepositoryProvider._();

final class MoviesRepositoryProvider
    extends
        $FunctionalProvider<
          IMoviesRepository,
          IMoviesRepository,
          IMoviesRepository
        >
    with $Provider<IMoviesRepository> {
  MoviesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesRepositoryHash();

  @$internal
  @override
  $ProviderElement<IMoviesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IMoviesRepository create(Ref ref) {
    return moviesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMoviesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMoviesRepository>(value),
    );
  }
}

String _$moviesRepositoryHash() => r'f548d28e7b7e1a6ea2744743b6473600e4c228eb';
