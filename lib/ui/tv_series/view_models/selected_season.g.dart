// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_season.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
         isAutoDispose: false,
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

String _$selectedSeasonHash() => r'8e44cf5f878c0a786ffaee7dc6c4f24d8f10d8fc';

final class SelectedSeasonFamily extends $Family
    with $ClassFamilyOverride<SelectedSeason, int, int, int, int> {
  SelectedSeasonFamily._()
    : super(
        retry: null,
        name: r'selectedSeasonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
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
