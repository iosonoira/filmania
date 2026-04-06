// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$moviesRepositoryHash() => r'e323448b2499075b34d51bad16e145a283906b06';
