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
  String get dropped => 'Dropped';

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

  @override
  String get trendingMoviesTitle => 'Trending Movies';

  @override
  String get trendingTvTitle => 'Trending TV Series';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appSection => 'Application';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get infoSection => 'Information';

  @override
  String get accountSection => 'Account';

  @override
  String get version => 'Version';

  @override
  String get dataSource => 'Data provided by';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeMichele => 'For Michele';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get castTitle => 'Cast';

  @override
  String get crewTitle => 'Crew';

  @override
  String get recommendedMoviesTitle => 'Recommended for you';

  @override
  String get recommendedSeriesTitle => 'You might also like';

  @override
  String get biographyTitle => 'Biography';

  @override
  String get filmographyTitle => 'Filmography';

  @override
  String get noBiography => 'No biography available.';

  @override
  String get episodesTitle => 'Episodes';

  @override
  String get noEpisodesAvailable => 'No episodes available';

  @override
  String get noDescription => 'No description available.';

  @override
  String get season => 'Season';

  @override
  String get episode => 'Episode';

  @override
  String get totalWatchTime => 'Total Watch Time';

  @override
  String get hoursUnit => 'hours';

  @override
  String get moviesTitle => 'Movies';

  @override
  String get tvSeriesTitle => 'TV Series';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get noFavorites => 'No favorites';

  @override
  String get noFavoritesDescription =>
      'Add a movie or TV series from its detail page to see it here.';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String uploadError(String error) {
    return 'Upload error: $error';
  }

  @override
  String get closeSelection => 'Close selection';

  @override
  String get addToListAction => 'Add to list';

  @override
  String get toggleWatchedAction => 'Mark as watched/unwatched';

  @override
  String get markAsUnwatchedAction => 'Mark as unwatched';

  @override
  String get dropSeriesAction => 'Drop series';

  @override
  String get markSelectedEpisodesWatchedAction => 'Mark as watched';

  @override
  String get removeFromThisList => 'Remove from this list';

  @override
  String get noWatchlistsAvailableHint =>
      'No watchlist available. Create one from a title\'s details page.';

  @override
  String get selectionActionDone => 'Done';

  @override
  String selectionActionPartialFailure(int count) {
    return '$count items not updated';
  }

  @override
  String get dataSection => 'Data';

  @override
  String get importTvTimeTitle => 'Import from TV Time';

  @override
  String get importTvTimeSubtitle =>
      'Bring your watched history and lists into Filmania';

  @override
  String get importTvTimeInstructions =>
      'Export your data from TV Time and select the .zip file below.';

  @override
  String get importTvTimePickButton => 'Select zip file';

  @override
  String get importTvTimeParsing => 'Extracting file...';

  @override
  String get importTvTimeMatchingMovies => 'Matching movies on TMDB...';

  @override
  String get importTvTimeMatchingSeries => 'Matching TV series on TMDB...';

  @override
  String get importTvTimeWriting => 'Saving your data...';

  @override
  String get importTvTimeConfirm => 'Confirm and import';

  @override
  String get importTvTimeUnmatchedTitle => 'Not found on TMDB';

  @override
  String get importTvTimeRetry => 'Try again';

  @override
  String get importTvTimeDone => 'Import completed';

  @override
  String get importTvTimePreviewTitle => 'Import preview';

  @override
  String get importTvTimeCountMovies => 'Movies';

  @override
  String get importTvTimeCountEpisodes => 'Episodes';

  @override
  String get importTvTimeCountLists => 'Lists';

  @override
  String get importTvTimeCountListItems => 'List items';

  @override
  String get importTvTimeCountMoviesImported => 'Movies imported';

  @override
  String get importTvTimeCountEpisodesImported => 'Episodes imported';

  @override
  String get importTvTimeCountListsImported => 'Lists imported';

  @override
  String get importTvTimeCountListItemsImported => 'List items imported';

  @override
  String get importTvTimeBackToSettings => 'Back to Settings';

  @override
  String get importTvTimeErrorTitle => 'Error during import';

  @override
  String get importTvTimeUnmatchedReason => 'Reason';

  @override
  String importTvTimeUnmatchedCount(int count) {
    return '$count items not found on TMDB';
  }
}
