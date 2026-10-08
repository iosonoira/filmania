// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tvtime_import_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TvTimeImportNotifier)
final tvTimeImportProvider = TvTimeImportNotifierProvider._();

final class TvTimeImportNotifierProvider
    extends $NotifierProvider<TvTimeImportNotifier, TvTimeImportState> {
  TvTimeImportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvTimeImportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvTimeImportNotifierHash();

  @$internal
  @override
  TvTimeImportNotifier create() => TvTimeImportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TvTimeImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TvTimeImportState>(value),
    );
  }
}

String _$tvTimeImportNotifierHash() =>
    r'1bd1b1d0f061131b12fb2b571f97fd7ae36a4dfc';

abstract class _$TvTimeImportNotifier extends $Notifier<TvTimeImportState> {
  TvTimeImportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TvTimeImportState, TvTimeImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TvTimeImportState, TvTimeImportState>,
              TvTimeImportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
