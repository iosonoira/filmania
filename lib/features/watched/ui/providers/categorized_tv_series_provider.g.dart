// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorized_tv_series_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categorizedTvSeries)
final categorizedTvSeriesProvider = CategorizedTvSeriesProvider._();

final class CategorizedTvSeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategorizedTvSeries>>,
          List<CategorizedTvSeries>,
          FutureOr<List<CategorizedTvSeries>>
        >
    with
        $FutureModifier<List<CategorizedTvSeries>>,
        $FutureProvider<List<CategorizedTvSeries>> {
  CategorizedTvSeriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorizedTvSeriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorizedTvSeriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CategorizedTvSeries>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategorizedTvSeries>> create(Ref ref) {
    return categorizedTvSeries(ref);
  }
}

String _$categorizedTvSeriesHash() =>
    r'a525f3e0cb5fb2c7355dbb9260a74c879532fef4';
