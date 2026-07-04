// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tvtime_import_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tvTimeImportRepository)
final tvTimeImportRepositoryProvider = TvTimeImportRepositoryProvider._();

final class TvTimeImportRepositoryProvider
    extends
        $FunctionalProvider<
          ITvTimeImportRepository,
          ITvTimeImportRepository,
          ITvTimeImportRepository
        >
    with $Provider<ITvTimeImportRepository> {
  TvTimeImportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvTimeImportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvTimeImportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITvTimeImportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITvTimeImportRepository create(Ref ref) {
    return tvTimeImportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITvTimeImportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITvTimeImportRepository>(value),
    );
  }
}

String _$tvTimeImportRepositoryHash() =>
    r'7dde9564ca62374e7c36e05be8c588c315bef942';
