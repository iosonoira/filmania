// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:filmania/core/l10n/generated/app_localizations.dart';

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
  String get watchLater => 'Watch later';

  @override
  String genericError(String error) {
    return 'Error: $error';
  }

  @override
  String get emptyWatching =>
      'Nothing in progress. Start a series to see it here.';

  @override
  String get emptyUpToDate => 'You\'re all caught up here.';

  @override
  String get emptyWatchLater => 'Nothing saved for later yet.';

  @override
  String get emptyCompleted => 'No completed series yet.';

  @override
  String get emptyDropped => 'You haven\'t dropped any series.';

  @override
  String get emptyWatchedMovies =>
      'No watched movies yet. Mark one from its details page.';

  @override
  String get networkErrorDesc => 'Check your internet connection.';

  @override
  String get genericErrorDesc => 'An error occurred. Please try again.';

  @override
  String get errorNoConnectionTitle => 'No connection.';

  @override
  String get errorNoConnectionDesc => 'Check your Wi-Fi or mobile data.';

  @override
  String get errorSlowConnectionTitle => 'Slow connection.';

  @override
  String get errorSlowConnectionDesc => 'Try again shortly.';

  @override
  String get errorNotFoundTitle => 'Not found.';

  @override
  String get errorNotFoundDesc => 'The requested content doesn\'t exist.';

  @override
  String get errorServerTitle => 'Server error.';

  @override
  String get errorServerDesc => 'Something went wrong on our end.';

  @override
  String get errorSessionExpiredTitle => 'Session expired.';

  @override
  String get errorSessionExpiredDesc => 'Please log in again.';

  @override
  String get errorNetworkGenericTitle => 'Network error.';

  @override
  String get errorNetworkGenericDesc => 'Try again later.';

  @override
  String get errorAuthTitle => 'Authentication error';

  @override
  String get errorUnexpectedTitle => 'Unexpected error.';

  @override
  String get errorUnexpectedDesc => 'Something unexpected happened.';

  @override
  String get authInvalidCredentials => 'Invalid credentials. Please try again.';

  @override
  String get authEmailAlreadyInUse =>
      'This email address is already in use by another account.';

  @override
  String get authRateLimitExceeded =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get authNotSignedIn => 'You need to be signed in to do that.';

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
  String get errorUpdating =>
      'Couldn\'t update. Check your connection and try again.';

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
  String get watchLaterAction => 'Watch later';

  @override
  String get markSelectedEpisodesWatchedAction => 'Mark as watched';

  @override
  String get removeFromThisList => 'Remove from this list';

  @override
  String get noWatchlistsAvailableHint =>
      'No watchlist available. Create one from a title\'s details page.';

  @override
  String get selectionActionDone => 'Updated';

  @override
  String selectionActionPartialFailure(int count) {
    return '$count items couldn\'t be updated. Try again.';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get markUnwatchedConfirmTitle => 'Mark as unwatched?';

  @override
  String markUnwatchedConfirmMessage(int count) {
    return '$count items will be removed from your watched history.';
  }

  @override
  String get dropSeriesConfirmTitle => 'Drop series?';

  @override
  String dropSeriesConfirmMessage(int count) {
    return '$count series will be marked as dropped.';
  }

  @override
  String get watchLaterConfirmTitle => 'Move to Watch Later?';

  @override
  String watchLaterConfirmMessage(int count) {
    return '$count series will be moved to Watch Later.';
  }

  @override
  String get watchedButtonLabelWatched => 'Watched';

  @override
  String get watchedButtonLabelUnwatched => 'Mark as Watched';

  @override
  String get undoAction => 'Undo';

  @override
  String get unwatchedSnackbarMessage => 'Removed from your watched history.';

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
  String get importTvTimeFetchingRuntimes => 'Fetching runtime details...';

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

  @override
  String get importTvTimeDownloadUnmatched => 'Download list (CSV)';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navWatchlist => 'Watchlist';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTagline =>
      'Curate your personal gallery\nof cinematic works.';

  @override
  String get registerTagline =>
      'Create your entry pass\nto the world of cinema.';

  @override
  String get searchMoviesHint => 'Search movies, actors, directors...';

  @override
  String get searchTvHint => 'Search TV series...';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get genresLoadError => 'Couldn\'t load genres.';

  @override
  String get releaseYearLabel => 'Release year';

  @override
  String get anyPeriod => 'Any period';

  @override
  String get noResultsTitle => 'No results found';

  @override
  String get noResultsHint => 'Try different keywords.';

  @override
  String mediaCardSemantics(String title, String rating) {
    return 'Media: $title, rated $rating';
  }

  @override
  String get seeAll => 'See all';

  @override
  String ratingLabel(String rating) {
    return 'Rating: $rating';
  }

  @override
  String get trendingTitle => 'Trending';

  @override
  String get newThisWeek => 'New this week';

  @override
  String get topRatedTitle => 'Top Rated';

  @override
  String get timelessClassics => 'Timeless classics';

  @override
  String get curatedForYou => 'Picked for You';

  @override
  String watchCardSemantics(String title, String subtitle) {
    return 'Watch $title, $subtitle';
  }

  @override
  String episodeSemantics(int number, String name) {
    return 'Episode $number: $name';
  }

  @override
  String get watchlistStatusError => 'Couldn\'t load watchlist status';

  @override
  String get noWatchlistsTitle => 'No watchlists';

  @override
  String get noWatchlistsDescription =>
      'Add a movie or a series from its details page to create your first watchlist!';

  @override
  String titlesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '1 title',
    );
    return '$_temp0';
  }

  @override
  String removeFromWatchlistSemantics(String title) {
    return 'Remove $title from the watchlist';
  }

  @override
  String addedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Added $dateString';
  }

  @override
  String mediumDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get genreLabel => 'Genre';

  @override
  String get movieTag => 'Movie';

  @override
  String get myWatchlistsTitle => 'My Watchlists';

  @override
  String get myWatchlistsSubtitle =>
      'Organize movies and series in your personal lists.';

  @override
  String watchlistItemSemantics(String title, DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Media: $title, added $dateString';
  }
}
