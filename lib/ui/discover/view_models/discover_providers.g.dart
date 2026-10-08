// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedMediaType)
final selectedMediaTypeProvider = SelectedMediaTypeProvider._();

final class SelectedMediaTypeProvider
    extends $NotifierProvider<SelectedMediaType, DiscoverMediaType> {
  SelectedMediaTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMediaTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMediaTypeHash();

  @$internal
  @override
  SelectedMediaType create() => SelectedMediaType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverMediaType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverMediaType>(value),
    );
  }
}

String _$selectedMediaTypeHash() => r'145baaf7274239b43236906e337ccb2e044981bb';

abstract class _$SelectedMediaType extends $Notifier<DiscoverMediaType> {
  DiscoverMediaType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoverMediaType, DiscoverMediaType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverMediaType, DiscoverMediaType>,
              DiscoverMediaType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MovieSearchQuery)
final movieSearchQueryProvider = MovieSearchQueryProvider._();

final class MovieSearchQueryProvider
    extends $NotifierProvider<MovieSearchQuery, String> {
  MovieSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieSearchQueryHash();

  @$internal
  @override
  MovieSearchQuery create() => MovieSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$movieSearchQueryHash() => r'229f264a4e2919a734e3e981a5d3f0a87ae3357e';

abstract class _$MovieSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DebouncedSearchQuery)
final debouncedSearchQueryProvider = DebouncedSearchQueryProvider._();

final class DebouncedSearchQueryProvider
    extends $NotifierProvider<DebouncedSearchQuery, String> {
  DebouncedSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debouncedSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debouncedSearchQueryHash();

  @$internal
  @override
  DebouncedSearchQuery create() => DebouncedSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$debouncedSearchQueryHash() =>
    r'd18c2a4626905a86f41344668d38c5502b5b78b3';

abstract class _$DebouncedSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MovieDiscoverFilters)
final movieDiscoverFiltersProvider = MovieDiscoverFiltersProvider._();

final class MovieDiscoverFiltersProvider
    extends $NotifierProvider<MovieDiscoverFilters, DiscoverFilters> {
  MovieDiscoverFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieDiscoverFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieDiscoverFiltersHash();

  @$internal
  @override
  MovieDiscoverFilters create() => MovieDiscoverFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverFilters>(value),
    );
  }
}

String _$movieDiscoverFiltersHash() =>
    r'321c697f2dfa0908797b5377496e626acbd9d1e3';

abstract class _$MovieDiscoverFilters extends $Notifier<DiscoverFilters> {
  DiscoverFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoverFilters, DiscoverFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverFilters, DiscoverFilters>,
              DiscoverFilters,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(TvDiscoverFilters)
final tvDiscoverFiltersProvider = TvDiscoverFiltersProvider._();

final class TvDiscoverFiltersProvider
    extends $NotifierProvider<TvDiscoverFilters, DiscoverFilters> {
  TvDiscoverFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvDiscoverFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvDiscoverFiltersHash();

  @$internal
  @override
  TvDiscoverFilters create() => TvDiscoverFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverFilters>(value),
    );
  }
}

String _$tvDiscoverFiltersHash() => r'ba748d43a1e3d587c051eb531d3e0879a4d69b2a';

abstract class _$TvDiscoverFilters extends $Notifier<DiscoverFilters> {
  DiscoverFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DiscoverFilters, DiscoverFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverFilters, DiscoverFilters>,
              DiscoverFilters,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
