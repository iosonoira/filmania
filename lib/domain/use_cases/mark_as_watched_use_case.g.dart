// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_as_watched_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(markAsWatchedUseCase)
final markAsWatchedUseCaseProvider = MarkAsWatchedUseCaseProvider._();

final class MarkAsWatchedUseCaseProvider
    extends
        $FunctionalProvider<
          MarkAsWatchedUseCase,
          MarkAsWatchedUseCase,
          MarkAsWatchedUseCase
        >
    with $Provider<MarkAsWatchedUseCase> {
  MarkAsWatchedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markAsWatchedUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markAsWatchedUseCaseHash();

  @$internal
  @override
  $ProviderElement<MarkAsWatchedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkAsWatchedUseCase create(Ref ref) {
    return markAsWatchedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkAsWatchedUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkAsWatchedUseCase>(value),
    );
  }
}

String _$markAsWatchedUseCaseHash() =>
    r'639d947e7f1254c09d9462d7914ef96ed9b7cf8c';
