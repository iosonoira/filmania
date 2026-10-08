// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Settings signs out through its own view model instead of reaching into
/// the auth feature: in the Flutter architecture guide every feature has its
/// own view model, while repositories are shared by all of them.

@ProviderFor(SettingsViewModel)
final settingsViewModelProvider = SettingsViewModelProvider._();

/// Settings signs out through its own view model instead of reaching into
/// the auth feature: in the Flutter architecture guide every feature has its
/// own view model, while repositories are shared by all of them.
final class SettingsViewModelProvider
    extends $AsyncNotifierProvider<SettingsViewModel, void> {
  /// Settings signs out through its own view model instead of reaching into
  /// the auth feature: in the Flutter architecture guide every feature has its
  /// own view model, while repositories are shared by all of them.
  SettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsViewModelHash();

  @$internal
  @override
  SettingsViewModel create() => SettingsViewModel();
}

String _$settingsViewModelHash() => r'fda3d882b0d40af531bddbb0166d796746c0feee';

/// Settings signs out through its own view model instead of reaching into
/// the auth feature: in the Flutter architecture guide every feature has its
/// own view model, while repositories are shared by all of them.

abstract class _$SettingsViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
