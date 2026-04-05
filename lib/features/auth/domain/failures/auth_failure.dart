sealed class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials([super.message = 'Credenziali non valide. Riprova.']);
}

class NetworkError extends AuthFailure {
  const NetworkError([super.message = 'Errore di rete. Controlla la tua connessione.']);
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([super.message = 'Si è verificato un errore imprevisto durante l\'autenticazione.']);
}
