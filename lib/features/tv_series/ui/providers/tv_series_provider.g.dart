// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TrendingTVSeries)
final trendingTVSeriesProvider = TrendingTVSeriesFamily._();

final class TrendingTVSeriesProvider
    extends $AsyncNotifierProvider<TrendingTVSeries, List<TVSeries>> {
  TrendingTVSeriesProvider._({
    required TrendingTVSeriesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'trendingTVSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trendingTVSeriesHash();

  @override
  String toString() {
    return r'trendingTVSeriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TrendingTVSeries create() => TrendingTVSeries();

  @override
  bool operator ==(Object other) {
    return other is TrendingTVSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trendingTVSeriesHash() => r'7accc7dabb0b6fb8d854cdd509bff191292ac452';

final class TrendingTVSeriesFamily extends $Family
    with
        $ClassFamilyOverride<
          TrendingTVSeries,
          AsyncValue<List<TVSeries>>,
          List<TVSeries>,
          FutureOr<List<TVSeries>>,
          int
        > {
  TrendingTVSeriesFamily._()
    : super(
        retry: null,
        name: r'trendingTVSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrendingTVSeriesProvider call({int page = 1}) =>
      TrendingTVSeriesProvider._(argument: page, from: this);

  @override
  String toString() => r'trendingTVSeriesProvider';
}

abstract class _$TrendingTVSeries extends $AsyncNotifier<List<TVSeries>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<List<TVSeries>> build({int page = 1});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<TVSeries>>, List<TVSeries>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TVSeries>>, List<TVSeries>>,
              AsyncValue<List<TVSeries>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(page: _$args));
  }
}

@ProviderFor(DiscoverTVSeries)
final discoverTVSeriesProvider = DiscoverTVSeriesFamily._();

final class DiscoverTVSeriesProvider
    extends $AsyncNotifierProvider<DiscoverTVSeries, List<TVSeries>> {
  DiscoverTVSeriesProvider._({
    required DiscoverTVSeriesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'discoverTVSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$discoverTVSeriesHash();

  @override
  String toString() {
    return r'discoverTVSeriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiscoverTVSeries create() => DiscoverTVSeries();

  @override
  bool operator ==(Object other) {
    return other is DiscoverTVSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverTVSeriesHash() => r'713a8f24f5e927326e3f8eb1b48d033d478cf025';

final class DiscoverTVSeriesFamily extends $Family
    with
        $ClassFamilyOverride<
          DiscoverTVSeries,
          AsyncValue<List<TVSeries>>,
          List<TVSeries>,
          FutureOr<List<TVSeries>>,
          int
        > {
  DiscoverTVSeriesFamily._()
    : super(
        retry: null,
        name: r'discoverTVSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiscoverTVSeriesProvider call({int page = 1}) =>
      DiscoverTVSeriesProvider._(argument: page, from: this);

  @override
  String toString() => r'discoverTVSeriesProvider';
}

abstract class _$DiscoverTVSeries extends $AsyncNotifier<List<TVSeries>> {
  late final _$args = ref.$arg as int;
  int get page => _$args;

  FutureOr<List<TVSeries>> build({int page = 1});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<TVSeries>>, List<TVSeries>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TVSeries>>, List<TVSeries>>,
              AsyncValue<List<TVSeries>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(page: _$args));
  }
}

@ProviderFor(tvSeriesDetails)
final tvSeriesDetailsProvider = TvSeriesDetailsFamily._();

final class TvSeriesDetailsProvider
    extends
        $FunctionalProvider<AsyncValue<TVSeries>, TVSeries, FutureOr<TVSeries>>
    with $FutureModifier<TVSeries>, $FutureProvider<TVSeries> {
  TvSeriesDetailsProvider._({
    required TvSeriesDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'tvSeriesDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tvSeriesDetailsHash();

  @override
  String toString() {
    return r'tvSeriesDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TVSeries> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TVSeries> create(Ref ref) {
    final argument = this.argument as int;
    return tvSeriesDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TvSeriesDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tvSeriesDetailsHash() => r'3437f346d7448e761bc483e343542e2f6ab23ae7';

final class TvSeriesDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TVSeries>, int> {
  TvSeriesDetailsFamily._()
    : super(
        retry: null,
        name: r'tvSeriesDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TvSeriesDetailsProvider call(int tvId) =>
      TvSeriesDetailsProvider._(argument: tvId, from: this);

  @override
  String toString() => r'tvSeriesDetailsProvider';
}

@ProviderFor(searchTVSeries)
final searchTVSeriesProvider = SearchTVSeriesFamily._();

final class SearchTVSeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TVSeries>>,
          List<TVSeries>,
          FutureOr<List<TVSeries>>
        >
    with $FutureModifier<List<TVSeries>>, $FutureProvider<List<TVSeries>> {
  SearchTVSeriesProvider._({
    required SearchTVSeriesFamily super.from,
    required (String, {int page}) super.argument,
  }) : super(
         retry: null,
         name: r'searchTVSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchTVSeriesHash();

  @override
  String toString() {
    return r'searchTVSeriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TVSeries>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TVSeries>> create(Ref ref) {
    final argument = this.argument as (String, {int page});
    return searchTVSeries(ref, argument.$1, page: argument.page);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchTVSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchTVSeriesHash() => r'e3b240bbf7284b1a2d9a6296108ca9c100793785';

final class SearchTVSeriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TVSeries>>,
          (String, {int page})
        > {
  SearchTVSeriesFamily._()
    : super(
        retry: null,
        name: r'searchTVSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchTVSeriesProvider call(String query, {int page = 1}) =>
      SearchTVSeriesProvider._(argument: (query, page: page), from: this);

  @override
  String toString() => r'searchTVSeriesProvider';
}

@ProviderFor(seasonEpisodes)
final seasonEpisodesProvider = SeasonEpisodesFamily._();

final class SeasonEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TVEpisode>>,
          List<TVEpisode>,
          FutureOr<List<TVEpisode>>
        >
    with $FutureModifier<List<TVEpisode>>, $FutureProvider<List<TVEpisode>> {
  SeasonEpisodesProvider._({
    required SeasonEpisodesFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'seasonEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seasonEpisodesHash();

  @override
  String toString() {
    return r'seasonEpisodesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TVEpisode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TVEpisode>> create(Ref ref) {
    final argument = this.argument as (int, int);
    return seasonEpisodes(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SeasonEpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seasonEpisodesHash() => r'6cb93d3492859dbc48612a4eb0d3a0e751f749f6';

final class SeasonEpisodesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TVEpisode>>, (int, int)> {
  SeasonEpisodesFamily._()
    : super(
        retry: null,
        name: r'seasonEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeasonEpisodesProvider call(int tvId, int seasonNumber) =>
      SeasonEpisodesProvider._(argument: (tvId, seasonNumber), from: this);

  @override
  String toString() => r'seasonEpisodesProvider';
}

@ProviderFor(SelectedSeason)
final selectedSeasonProvider = SelectedSeasonFamily._();

final class SelectedSeasonProvider
    extends $NotifierProvider<SelectedSeason, int> {
  SelectedSeasonProvider._({
    required SelectedSeasonFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'selectedSeasonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedSeasonHash();

  @override
  String toString() {
    return r'selectedSeasonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedSeason create() => SelectedSeason();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedSeasonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedSeasonHash() => r'c3a26691cc07453a83274926d6fa310785be48ea';

final class SelectedSeasonFamily extends $Family
    with $ClassFamilyOverride<SelectedSeason, int, int, int, int> {
  SelectedSeasonFamily._()
    : super(
        retry: null,
        name: r'selectedSeasonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SelectedSeasonProvider call(int tvId) =>
      SelectedSeasonProvider._(argument: tvId, from: this);

  @override
  String toString() => r'selectedSeasonProvider';
}

abstract class _$SelectedSeason extends $Notifier<int> {
  late final _$args = ref.$arg as int;
  int get tvId => _$args;

  int build(int tvId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
