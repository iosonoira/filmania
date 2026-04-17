import '../entities/auth_user.dart';

abstract interface class IAuthRepository {
  /// Signs in a user with email and password.
  ///
  /// Returns the authenticated [AuthUser] on success.
  /// Throws [InvalidCredentials] if credentials are wrong.
  /// Throws [NetworkError] on connectivity issues.
  Future<AuthUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with email, password, and username.
  ///
  /// Throws [EmailAlreadyInUse] if the email is already registered.
  /// Throws [RateLimitExceeded] if too many signup attempts occur.
  Future<AuthUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });

  /// Signs out the currently authenticated user.
  Future<void> signOut();

  /// Emits the current [AuthUser] whenever auth state changes.
  /// Emits `null` when the user signs out.
  Stream<AuthUser?> watchAuthState();
}
