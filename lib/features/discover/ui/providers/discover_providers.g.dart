// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
