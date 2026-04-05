import '../entities/auth_user.dart';

abstract interface class IAuthRepository {
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  Future<void> signOut();

  Stream<AuthUser?> watchAuthState();
}
