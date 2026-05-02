// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get helloWorld => 'Ciao Mondo!';

  @override
  String get networkError => 'Si è verificato un errore di rete. Riprova.';

  @override
  String get watchedMovies => 'Film Visti';

  @override
  String get watchedTvSeries => 'Serie TV Viste';

  @override
  String get watching => 'In visione';

  @override
  String get upToDate => 'In pari';

  @override
  String get completed => 'Terminate';

  @override
  String genericError(String error) {
    return 'Errore: $error';
  }

  @override
  String get emptySection => 'Nessun elemento presente in questa sezione.';

  @override
  String get networkErrorDesc => 'Controlla la tua connessione internet.';

  @override
  String get genericErrorDesc => 'Si è verificato un errore. Riprova.';

  @override
  String get emailAddress => 'Indirizzo Email';

  @override
  String get enterValidEmail => 'Inserisci una email valida';

  @override
  String get username => 'Nome utente';

  @override
  String get min3Chars => 'Minimo 3 caratteri';

  @override
  String get password => 'Password';

  @override
  String get min6Chars => 'Minimo 6 caratteri';

  @override
  String get confirmPassword => 'Conferma Password';

  @override
  String get passwordsMismatch => 'Le password non coincidono';

  @override
  String get createYourPass => 'Crea il tuo pass';

  @override
  String get alreadyHavePass => 'Hai già un pass?';

  @override
  String get signIn => 'Entra';

  @override
  String get notifications => 'Notifiche';

  @override
  String get enterCinema => 'Entra nel Cinema';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get dontHavePass => 'Non hai un pass?';

  @override
  String get requestItHere => 'Richiedilo qui';

  @override
  String get cancel => 'Annulla';

  @override
  String get create => 'Crea';

  @override
  String get deleteWatchlist => 'Elimina watchlist';

  @override
  String deleteWatchlistConfirm(String name) {
    return 'Vuoi eliminare \"$name\"? Questa azione è irreversibile.';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get inYourWatchlists => 'Nelle tue Watchlist';

  @override
  String get addToWatchlist => 'Aggiungi alla Watchlist';

  @override
  String get errorUpdating => 'Errore durante l\'aggiornamento.';

  @override
  String get signOut => 'Esci';

  @override
  String get retryBtn => 'Riprova';

  @override
  String get pageNotFound => 'Pagina non trovata';

  @override
  String get addedToWatchlist => 'Aggiunto alla watchlist!';

  @override
  String get createNewWatchlist => 'Crea nuova watchlist';

  @override
  String get watchlistNameHint => 'Nome della watchlist…';

  @override
  String get noWatchlistsYet => 'Non hai ancora nessuna watchlist. Creane una!';

  @override
  String get emptyList => 'Lista vuota';

  @override
  String get addMoviesFromDetails =>
      'Aggiungi film e serie dalla loro pagina dettaglio.';

  @override
  String get toggleTheme => 'Cambia Tema';

  @override
  String get trendingMoviesTitle => 'Film del Momento';

  @override
  String get trendingTvTitle => 'Serie TV del Momento';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get appSection => 'Applicazione';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get infoSection => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get dataSource => 'Dati forniti da';

  @override
  String get chooseLanguage => 'Scegli Lingua';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeMichele => 'Per Michele';

  @override
  String get chooseTheme => 'Scegli Tema';

  @override
  String get overviewTitle => 'Trama';

  @override
  String get castTitle => 'Cast';

  @override
  String get episodesTitle => 'Episodi';

  @override
  String get noEpisodesAvailable => 'Nessun episodio disponibile';

  @override
  String get noDescription => 'Nessuna descrizione disponibile.';

  @override
  String get season => 'Stagione';

  @override
  String get episode => 'Episodio';

  @override
  String get totalWatchTime => 'Tempo Totale';

  @override
  String get hoursUnit => 'ore';

  @override
  String get moviesTitle => 'Film';

  @override
  String get tvSeriesTitle => 'Serie TV';

  @override
  String get recentActivity => 'Attività Recente';

  @override
  String get noRecentActivity => 'Nessuna attività recente';

  @override
  String uploadError(String error) {
    return 'Errore upload: $error';
  }
}
