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
