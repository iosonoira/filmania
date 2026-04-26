// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TrendingMovies)
final trendingMoviesProvider = TrendingMoviesFamily._();

final class TrendingMoviesProvider
    extends $AsyncNotifierProvider<TrendingMovies, List<Movie>> {
  TrendingMoviesProvider._({
    required TrendingMoviesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'trendingMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trendingMoviesHash();

  @override
  String toString() {
    return r'trendingMoviesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TrendingMovies create() => TrendingMovies();

  @override
  bool operator ==(Object other) {
    return other is TrendingMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trendingMoviesHash() => r'7c29a4c52dc04a2d8b018d505be98d5809842d35';

final class TrendingMoviesFamily extends $Family
    with
        $ClassFamilyOverride<
          TrendingMovies,
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>,
          int
        > {
  TrendingMoviesFamily._()
    : super(
        retry: null,
        name: r'trendingMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrendingMoviesProvider call({int page = 1}) =>
      TrendingMoviesProvider._(argument: page, from: this);

  @override
  String toString() => r'trendingMoviesProvider';
}

abstract class _$TrendingMovies extends $AsyncNotifier<List<Movie>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<List<Movie>> build({int page = 1});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Movie>>, List<Movie>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Movie>>, List<Movie>>,
              AsyncValue<List<Movie>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(page: _$args));
  }
}

@ProviderFor(DiscoverMovies)
final discoverMoviesProvider = DiscoverMoviesFamily._();

final class DiscoverMoviesProvider
    extends $AsyncNotifierProvider<DiscoverMovies, List<Movie>> {
  DiscoverMoviesProvider._({
    required DiscoverMoviesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'discoverMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$discoverMoviesHash();

  @override
  String toString() {
    return r'discoverMoviesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiscoverMovies create() => DiscoverMovies();

  @override
  bool operator ==(Object other) {
    return other is DiscoverMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverMoviesHash() => r'436758a7cdc26c31e3101a0b1af3331b898f5c16';

final class DiscoverMoviesFamily extends $Family
    with
        $ClassFamilyOverride<
          DiscoverMovies,
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>,
          int
        > {
  DiscoverMoviesFamily._()
    : super(
        retry: null,
        name: r'discoverMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiscoverMoviesProvider call({int page = 1}) =>
      DiscoverMoviesProvider._(argument: page, from: this);

  @override
  String toString() => r'discoverMoviesProvider';
}

abstract class _$DiscoverMovies extends $AsyncNotifier<List<Movie>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<List<Movie>> build({int page = 1});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Movie>>, List<Movie>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Movie>>, List<Movie>>,
              AsyncValue<List<Movie>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(page: _$args));
  }
}

@ProviderFor(movieDetails)
final movieDetailsProvider = MovieDetailsFamily._();

final class MovieDetailsProvider
    extends $FunctionalProvider<AsyncValue<Movie>, Movie, FutureOr<Movie>>
    with $FutureModifier<Movie>, $FutureProvider<Movie> {
  MovieDetailsProvider._({
    required MovieDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'movieDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movieDetailsHash();

  @override
  String toString() {
    return r'movieDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Movie> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Movie> create(Ref ref) {
    final argument = this.argument as int;
    return movieDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movieDetailsHash() => r'114a96b846ac0eccbe46b557e771f5e256deec51';

final class MovieDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Movie>, int> {
  MovieDetailsFamily._()
    : super(
        retry: null,
        name: r'movieDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovieDetailsProvider call(int movieId) =>
      MovieDetailsProvider._(argument: movieId, from: this);

  @override
  String toString() => r'movieDetailsProvider';
}

@ProviderFor(searchMovies)
final searchMoviesProvider = SearchMoviesFamily._();

final class SearchMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Movie>>,
          List<Movie>,
          FutureOr<List<Movie>>
        >
    with $FutureModifier<List<Movie>>, $FutureProvider<List<Movie>> {
  SearchMoviesProvider._({
    required SearchMoviesFamily super.from,
    required (String, {int page}) super.argument,
  }) : super(
         retry: null,
         name: r'searchMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchMoviesHash();

  @override
  String toString() {
    return r'searchMoviesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Movie>> create(Ref ref) {
    final argument = this.argument as (String, {int page});
    return searchMovies(ref, argument.$1, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchMoviesHash() => r'd6205146a917a4324ad36ca171406bde9d6d558a';

final class SearchMoviesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<Movie>>, (String, {int page})> {
  SearchMoviesFamily._()
    : super(
        retry: null,
        name: r'searchMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchMoviesProvider call(String query, {int page = 1}) =>
      SearchMoviesProvider._(argument: (query, page: page), from: this);

  @override
  String toString() => r'searchMoviesProvider';
}

@ProviderFor(movieCredits)
final movieCreditsProvider = MovieCreditsFamily._();

final class MovieCreditsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CastMember>>,
          List<CastMember>,
          FutureOr<List<CastMember>>
        >
    with $FutureModifier<List<CastMember>>, $FutureProvider<List<CastMember>> {
  MovieCreditsProvider._({
    required MovieCreditsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'movieCreditsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movieCreditsHash();

  @override
  String toString() {
    return r'movieCreditsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CastMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CastMember>> create(Ref ref) {
    final argument = this.argument as int;
    return movieCredits(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieCreditsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movieCreditsHash() => r'e480a3631048a9e7d9530dff0e691cfc6b256248';

final class MovieCreditsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CastMember>>, int> {
  MovieCreditsFamily._()
    : super(
        retry: null,
        name: r'movieCreditsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovieCreditsProvider call(int movieId) =>
      MovieCreditsProvider._(argument: movieId, from: this);

  @override
  String toString() => r'movieCreditsProvider';
}
