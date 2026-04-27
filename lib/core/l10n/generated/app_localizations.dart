import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericError(String error);

  /// No description provided for @emptySection.
  ///
  /// In en, this message translates to:
  /// **'No items in this section.'**
  String get emptySection;

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
  /// **'Error during update.'**
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
