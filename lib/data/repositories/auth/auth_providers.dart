import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/auth_user.dart';
import 'package:filmania/data/repositories/auth/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
Stream<AuthUser?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).watchAuthState();
}
