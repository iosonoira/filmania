import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/auth_user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_notifier.g.dart';

@riverpod
Stream<AuthUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).watchAuthState();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    // Rule: Use AsyncValue.guard() for safe async operations (Rule 9/156 State Management)
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });

    if (ref.mounted) {
      state = result;
    }
  }

  Future<void> register(String email, String password, String username) async {
    state = const AsyncLoading();
    
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );
    });

    if (ref.mounted) {
      state = result;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signOut());
    if (ref.mounted) {
      state = result;
    }
  }
}
