import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'package:filmania/core/l10n/generated/app_localizations_en.dart';
import 'package:filmania/core/l10n/generated/app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please try again.'**
  String get networkError;

  /// No description provided for @watchedMovies.
  ///
  /// In en, this message translates to:
  /// **'Watched Movies'**
  String get watchedMovies;

  /// No description provided for @watchedTvSeries.
  ///
  /// In en, this message translates to:
  /// **'Watched TV Series'**
  String get watchedTvSeries;

  /// No description provided for @watching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watching;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get upToDate;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @dropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get dropped;

  /// No description provided for @watchLater.
  ///
  /// In en, this message translates to:
  /// **'Watch later'**
  String get watchLater;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericError(String error);

  /// No description provided for @emptyWatching.
  ///
  /// In en, this message translates to:
  /// **'Nothing in progress. Start a series to see it here.'**
  String get emptyWatching;

  /// No description provided for @emptyUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up here.'**
  String get emptyUpToDate;

  /// No description provided for @emptyWatchLater.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved for later yet.'**
  String get emptyWatchLater;

  /// No description provided for @emptyCompleted.
  ///
  /// In en, this message translates to:
  /// **'No completed series yet.'**
  String get emptyCompleted;

  /// No description provided for @emptyDropped.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t dropped any series.'**
  String get emptyDropped;

  /// No description provided for @emptyWatchedMovies.
  ///
  /// In en, this message translates to:
  /// **'No watched movies yet. Mark one from its details page.'**
  String get emptyWatchedMovies;

  /// No description provided for @networkErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection.'**
  String get networkErrorDesc;

  /// No description provided for @genericErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericErrorDesc;

  /// No description provided for @errorNoConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No connection.'**
  String get errorNoConnectionTitle;

  /// No description provided for @errorNoConnectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your Wi-Fi or mobile data.'**
  String get errorNoConnectionDesc;

  /// No description provided for @errorSlowConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Slow connection.'**
  String get errorSlowConnectionTitle;

  /// No description provided for @errorSlowConnectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Try again shortly.'**
  String get errorSlowConnectionDesc;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get errorNotFoundTitle;

  /// No description provided for @errorNotFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'The requested content doesn\'t exist.'**
  String get errorNotFoundDesc;

  /// No description provided for @errorServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Server error.'**
  String get errorServerTitle;

  /// No description provided for @errorServerDesc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end.'**
  String get errorServerDesc;

  /// No description provided for @errorSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expired.'**
  String get errorSessionExpiredTitle;

  /// No description provided for @errorSessionExpiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Please log in again.'**
  String get errorSessionExpiredDesc;

  /// No description provided for @errorNetworkGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Network error.'**
  String get errorNetworkGenericTitle;

  /// No description provided for @errorNetworkGenericDesc.
  ///
  /// In en, this message translates to:
  /// **'Try again later.'**
  String get errorNetworkGenericDesc;

  /// No description provided for @errorAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get errorAuthTitle;

  /// No description provided for @errorUnexpectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error.'**
  String get errorUnexpectedTitle;

  /// No description provided for @errorUnexpectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened.'**
  String get errorUnexpectedDesc;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use by another account.'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in a few minutes.'**
  String get authRateLimitExceeded;

  /// No description provided for @authNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to do that.'**
  String get authNotSignedIn;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @min3Chars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 3 characters'**
  String get min3Chars;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @min6Chars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get min6Chars;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsMismatch;

  /// No description provided for @createYourPass.
  ///
  /// In en, this message translates to:
  /// **'Create your pass'**
  String get createYourPass;

  /// No description provided for @alreadyHavePass.
  ///
  /// In en, this message translates to:
  /// **'Already have a pass?'**
  String get alreadyHavePass;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enterCinema.
  ///
  /// In en, this message translates to:
  /// **'Enter the Cinema'**
  String get enterCinema;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHavePass.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a pass?'**
  String get dontHavePass;

  /// No description provided for @requestItHere.
  ///
  /// In en, this message translates to:
  /// **'Request it here'**
  String get requestItHere;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @deleteWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Delete watchlist'**
  String get deleteWatchlist;

  /// No description provided for @deleteWatchlistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteWatchlistConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @inYourWatchlists.
  ///
  /// In en, this message translates to:
  /// **'In your Watchlists'**
  String get inYourWatchlists;

  /// No description provided for @addToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get addToWatchlist;

  /// No description provided for @errorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update. Check your connection and try again.'**
  String get errorUpdating;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @retryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryBtn;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @addedToWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Added to watchlist!'**
  String get addedToWatchlist;

  /// No description provided for @createNewWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Create new watchlist'**
  String get createNewWatchlist;

  /// No description provided for @watchlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'Watchlist name…'**
  String get watchlistNameHint;

  /// No description provided for @noWatchlistsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any watchlist yet. Create one!'**
  String get noWatchlistsYet;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptyList;

  /// No description provided for @addMoviesFromDetails.
  ///
  /// In en, this message translates to:
  /// **'Add movies and series from their details page.'**
  String get addMoviesFromDetails;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @trendingMoviesTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending Movies'**
  String get trendingMoviesTitle;

  /// No description provided for @trendingTvTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending TV Series'**
  String get trendingTvTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get appSection;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @infoSection.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get infoSection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data provided by'**
  String get dataSource;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeMichele.
  ///
  /// In en, this message translates to:
  /// **'For Michele'**
  String get themeMichele;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @castTitle.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get castTitle;

  /// No description provided for @crewTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crewTitle;

  /// No description provided for @recommendedMoviesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedMoviesTitle;

  /// No description provided for @recommendedSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'You might also like'**
  String get recommendedSeriesTitle;

  /// No description provided for @biographyTitle.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biographyTitle;

  /// No description provided for @filmographyTitle.
  ///
  /// In en, this message translates to:
  /// **'Filmography'**
  String get filmographyTitle;

  /// No description provided for @noBiography.
  ///
  /// In en, this message translates to:
  /// **'No biography available.'**
  String get noBiography;

  /// No description provided for @episodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodesTitle;

  /// No description provided for @noEpisodesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No episodes available'**
  String get noEpisodesAvailable;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescription;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'Episode'**
  String get episode;

  /// No description provided for @totalWatchTime.
  ///
  /// In en, this message translates to:
  /// **'Total Watch Time'**
  String get totalWatchTime;

  /// No description provided for @hoursUnit.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hoursUnit;

  /// No description provided for @moviesTitle.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get moviesTitle;

  /// No description provided for @tvSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'TV Series'**
  String get tvSeriesTitle;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get noFavorites;

  /// No description provided for @noFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a movie or TV series from its detail page to see it here.'**
  String get noFavoritesDescription;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload error: {error}'**
  String uploadError(String error);

  /// No description provided for @closeSelection.
  ///
  /// In en, this message translates to:
  /// **'Close selection'**
  String get closeSelection;

  /// No description provided for @addToListAction.
  ///
  /// In en, this message translates to:
  /// **'Add to list'**
  String get addToListAction;

  /// No description provided for @toggleWatchedAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as watched/unwatched'**
  String get toggleWatchedAction;

  /// No description provided for @markAsUnwatchedAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as unwatched'**
  String get markAsUnwatchedAction;

  /// No description provided for @dropSeriesAction.
  ///
  /// In en, this message translates to:
  /// **'Drop series'**
  String get dropSeriesAction;

  /// No description provided for @watchLaterAction.
  ///
  /// In en, this message translates to:
  /// **'Watch later'**
  String get watchLaterAction;

  /// No description provided for @markSelectedEpisodesWatchedAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as watched'**
  String get markSelectedEpisodesWatchedAction;

  /// No description provided for @removeFromThisList.
  ///
  /// In en, this message translates to:
  /// **'Remove from this list'**
  String get removeFromThisList;

  /// No description provided for @noWatchlistsAvailableHint.
  ///
  /// In en, this message translates to:
  /// **'No watchlist available. Create one from a title\'s details page.'**
  String get noWatchlistsAvailableHint;

  /// No description provided for @selectionActionDone.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get selectionActionDone;

  /// No description provided for @selectionActionPartialFailure.
  ///
  /// In en, this message translates to:
  /// **'{count} items couldn\'t be updated. Try again.'**
  String selectionActionPartialFailure(int count);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @markUnwatchedConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as unwatched?'**
  String get markUnwatchedConfirmTitle;

  /// No description provided for @markUnwatchedConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} items will be removed from your watched history.'**
  String markUnwatchedConfirmMessage(int count);

  /// No description provided for @dropSeriesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop series?'**
  String get dropSeriesConfirmTitle;

  /// No description provided for @dropSeriesConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} series will be marked as dropped.'**
  String dropSeriesConfirmMessage(int count);

  /// No description provided for @watchLaterConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to Watch Later?'**
  String get watchLaterConfirmTitle;

  /// No description provided for @watchLaterConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} series will be moved to Watch Later.'**
  String watchLaterConfirmMessage(int count);

  /// No description provided for @watchedButtonLabelWatched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watchedButtonLabelWatched;

  /// No description provided for @watchedButtonLabelUnwatched.
  ///
  /// In en, this message translates to:
  /// **'Mark as Watched'**
  String get watchedButtonLabelUnwatched;

  /// No description provided for @undoAction.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoAction;

  /// No description provided for @unwatchedSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'Removed from your watched history.'**
  String get unwatchedSnackbarMessage;

  /// No description provided for @dataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSection;

  /// No description provided for @importTvTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from TV Time'**
  String get importTvTimeTitle;

  /// No description provided for @importTvTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring your watched history and lists into Filmania'**
  String get importTvTimeSubtitle;

  /// No description provided for @importTvTimeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Export your data from TV Time and select the .zip file below.'**
  String get importTvTimeInstructions;

  /// No description provided for @importTvTimePickButton.
  ///
  /// In en, this message translates to:
  /// **'Select zip file'**
  String get importTvTimePickButton;

  /// No description provided for @importTvTimeParsing.
  ///
  /// In en, this message translates to:
  /// **'Extracting file...'**
  String get importTvTimeParsing;

  /// No description provided for @importTvTimeMatchingMovies.
  ///
  /// In en, this message translates to:
  /// **'Matching movies on TMDB...'**
  String get importTvTimeMatchingMovies;

  /// No description provided for @importTvTimeMatchingSeries.
  ///
  /// In en, this message translates to:
  /// **'Matching TV series on TMDB...'**
  String get importTvTimeMatchingSeries;

  /// No description provided for @importTvTimeFetchingRuntimes.
  ///
  /// In en, this message translates to:
  /// **'Fetching runtime details...'**
  String get importTvTimeFetchingRuntimes;

  /// No description provided for @importTvTimeWriting.
  ///
  /// In en, this message translates to:
  /// **'Saving your data...'**
  String get importTvTimeWriting;

  /// No description provided for @importTvTimeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm and import'**
  String get importTvTimeConfirm;

  /// No description provided for @importTvTimeUnmatchedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not found on TMDB'**
  String get importTvTimeUnmatchedTitle;

  /// No description provided for @importTvTimeRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get importTvTimeRetry;

  /// No description provided for @importTvTimeDone.
  ///
  /// In en, this message translates to:
  /// **'Import completed'**
  String get importTvTimeDone;

  /// No description provided for @importTvTimePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Import preview'**
  String get importTvTimePreviewTitle;

  /// No description provided for @importTvTimeCountMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get importTvTimeCountMovies;

  /// No description provided for @importTvTimeCountEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get importTvTimeCountEpisodes;

  /// No description provided for @importTvTimeCountLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get importTvTimeCountLists;

  /// No description provided for @importTvTimeCountListItems.
  ///
  /// In en, this message translates to:
  /// **'List items'**
  String get importTvTimeCountListItems;

  /// No description provided for @importTvTimeCountMoviesImported.
  ///
  /// In en, this message translates to:
  /// **'Movies imported'**
  String get importTvTimeCountMoviesImported;

  /// No description provided for @importTvTimeCountEpisodesImported.
  ///
  /// In en, this message translates to:
  /// **'Episodes imported'**
  String get importTvTimeCountEpisodesImported;

  /// No description provided for @importTvTimeCountListsImported.
  ///
  /// In en, this message translates to:
  /// **'Lists imported'**
  String get importTvTimeCountListsImported;

  /// No description provided for @importTvTimeCountListItemsImported.
  ///
  /// In en, this message translates to:
  /// **'List items imported'**
  String get importTvTimeCountListItemsImported;

  /// No description provided for @importTvTimeBackToSettings.
  ///
  /// In en, this message translates to:
  /// **'Back to Settings'**
  String get importTvTimeBackToSettings;

  /// No description provided for @importTvTimeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error during import'**
  String get importTvTimeErrorTitle;

  /// No description provided for @importTvTimeUnmatchedReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get importTvTimeUnmatchedReason;

  /// No description provided for @importTvTimeUnmatchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items not found on TMDB'**
  String importTvTimeUnmatchedCount(int count);

  /// No description provided for @importTvTimeDownloadUnmatched.
  ///
  /// In en, this message translates to:
  /// **'Download list (CSV)'**
  String get importTvTimeDownloadUnmatched;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get navWatchlist;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Curate your personal gallery\nof cinematic works.'**
  String get loginTagline;

  /// No description provided for @registerTagline.
  ///
  /// In en, this message translates to:
  /// **'Create your entry pass\nto the world of cinema.'**
  String get registerTagline;

  /// No description provided for @searchMoviesHint.
  ///
  /// In en, this message translates to:
  /// **'Search movies, actors, directors...'**
  String get searchMoviesHint;

  /// No description provided for @searchTvHint.
  ///
  /// In en, this message translates to:
  /// **'Search TV series...'**
  String get searchTvHint;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @genresLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load genres.'**
  String get genresLoadError;

  /// No description provided for @releaseYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Release year'**
  String get releaseYearLabel;

  /// No description provided for @anyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Any period'**
  String get anyPeriod;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsTitle;

  /// No description provided for @noResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords.'**
  String get noResultsHint;

  /// No description provided for @mediaCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'Media: {title}, rated {rating}'**
  String mediaCardSemantics(String title, String rating);

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating: {rating}'**
  String ratingLabel(String rating);

  /// No description provided for @trendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trendingTitle;

  /// No description provided for @newThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New this week'**
  String get newThisWeek;

  /// No description provided for @topRatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRatedTitle;

  /// No description provided for @timelessClassics.
  ///
  /// In en, this message translates to:
  /// **'Timeless classics'**
  String get timelessClassics;

  /// No description provided for @curatedForYou.
  ///
  /// In en, this message translates to:
  /// **'Picked for You'**
  String get curatedForYou;

  /// No description provided for @watchCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'Watch {title}, {subtitle}'**
  String watchCardSemantics(String title, String subtitle);

  /// No description provided for @episodeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Episode {number}: {name}'**
  String episodeSemantics(int number, String name);

  /// No description provided for @watchlistStatusError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load watchlist status'**
  String get watchlistStatusError;

  /// No description provided for @noWatchlistsTitle.
  ///
  /// In en, this message translates to:
  /// **'No watchlists'**
  String get noWatchlistsTitle;

  /// No description provided for @noWatchlistsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a movie or a series from its details page to create your first watchlist!'**
  String get noWatchlistsDescription;

  /// No description provided for @titlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 title} other{{count} titles}}'**
  String titlesCount(int count);

  /// No description provided for @removeFromWatchlistSemantics.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from the watchlist'**
  String removeFromWatchlistSemantics(String title);

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String addedOn(DateTime date);

  /// A date on its own, formatted for the current locale (e.g. a person's birthday).
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String mediumDate(DateTime date);

  /// No description provided for @genreLabel.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genreLabel;

  /// No description provided for @movieTag.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movieTag;

  /// No description provided for @myWatchlistsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Watchlists'**
  String get myWatchlistsTitle;

  /// No description provided for @myWatchlistsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize movies and series in your personal lists.'**
  String get myWatchlistsSubtitle;

  /// No description provided for @watchlistItemSemantics.
  ///
  /// In en, this message translates to:
  /// **'Media: {title}, added {date}'**
  String watchlistItemSemantics(String title, DateTime date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
