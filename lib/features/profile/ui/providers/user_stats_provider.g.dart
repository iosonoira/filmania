// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userStats)
final userStatsProvider = UserStatsProvider._();

final class UserStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStats?>,
          UserStats?,
          FutureOr<UserStats?>
        >
    with $FutureModifier<UserStats?>, $FutureProvider<UserStats?> {
  UserStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStatsHash();

  @$internal
  @override
  $FutureProviderElement<UserStats?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserStats?> create(Ref ref) {
    return userStats(ref);
  }
}

String _$userStatsHash() => r'e20e3cc7176b4e864088b82cfe97a0f3c7beeb38';
