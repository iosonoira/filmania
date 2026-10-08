import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/data/repositories/auth/auth_repository.dart';

part 'settings_view_model.g.dart';

/// Settings signs out through its own view model instead of reaching into
/// the auth feature: in the Flutter architecture guide every feature has its
/// own view model, while repositories are shared by all of them.
@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  FutureOr<void> build() => null;

  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
    if (ref.mounted) {
      state = result;
    }
  }
}
