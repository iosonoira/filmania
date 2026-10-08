import 'package:filmania/features/auth/domain/failures/auth_failure.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

/// Maps each [AuthFailure] subtype to its localized message. Centralized
/// here (rather than duplicated per call site) so a new failure subtype
/// can't be added to `auth_failure.dart` without the compiler flagging
/// every consumer of this exhaustive switch.
String authFailureMessage(AuthFailure failure, AppLocalizations l10n) {
  return switch (failure) {
    InvalidCredentials() => l10n.authInvalidCredentials,
    EmailAlreadyInUse() => l10n.authEmailAlreadyInUse,
    RateLimitExceeded() => l10n.authRateLimitExceeded,
    NotSignedIn() => l10n.authNotSignedIn,
    NetworkError() => l10n.networkErrorDesc,
    UnknownAuthFailure() => l10n.genericErrorDesc,
  };
}
