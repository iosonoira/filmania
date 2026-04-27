// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get networkError => 'A network error occurred. Please try again.';

  @override
  String get watchedMovies => 'Watched Movies';

  @override
  String get watchedTvSeries => 'Watched TV Series';

  @override
  String get watching => 'Watching';

  @override
  String get upToDate => 'Up to date';

  @override
  String get completed => 'Completed';

  @override
  String genericError(String error) {
    return 'Error: $error';
  }

  @override
  String get emptySection => 'No items in this section.';

  @override
  String get networkErrorDesc => 'Check your internet connection.';

  @override
  String get genericErrorDesc => 'An error occurred. Please try again.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get username => 'Username';

  @override
  String get min3Chars => 'Minimum 3 characters';

  @override
  String get password => 'Password';

  @override
  String get min6Chars => 'Minimum 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsMismatch => 'Passwords do not match';

  @override
  String get createYourPass => 'Create your pass';

  @override
  String get alreadyHavePass => 'Already have a pass?';

  @override
  String get signIn => 'Sign In';

  @override
  String get notifications => 'Notifications';

  @override
  String get enterCinema => 'Enter the Cinema';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHavePass => 'Don\'t have a pass?';

  @override
  String get requestItHere => 'Request it here';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get deleteWatchlist => 'Delete watchlist';

  @override
  String deleteWatchlistConfirm(String name) {
    return 'Do you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get inYourWatchlists => 'In your Watchlists';

  @override
  String get addToWatchlist => 'Add to Watchlist';

  @override
  String get errorUpdating => 'Error during update.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get retryBtn => 'Retry';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get addedToWatchlist => 'Added to watchlist!';

  @override
  String get createNewWatchlist => 'Create new watchlist';

  @override
  String get watchlistNameHint => 'Watchlist name…';

  @override
  String get noWatchlistsYet =>
      'You don\'t have any watchlist yet. Create one!';

  @override
  String get emptyList => 'Empty list';

  @override
  String get addMoviesFromDetails =>
      'Add movies and series from their details page.';

  @override
  String get toggleTheme => 'Toggle Theme';
}
