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
  String get dropped => 'Interrotte';

  @override
  String get watchLater => 'Guarda più tardi';

  @override
  String genericError(String error) {
    return 'Errore: $error';
  }

  @override
  String get emptyWatching =>
      'Niente in corso. Inizia una serie per vederla qui.';

  @override
  String get emptyUpToDate => 'Sei in pari con tutto qui.';

  @override
  String get emptyWatchLater => 'Non hai ancora salvato nulla per dopo.';

  @override
  String get emptyCompleted => 'Nessuna serie completata.';

  @override
  String get emptyDropped => 'Non hai interrotto nessuna serie.';

  @override
  String get emptyWatchedMovies =>
      'Nessun film visto. Segnane uno dalla sua pagina dettaglio.';

  @override
  String get networkErrorDesc => 'Controlla la tua connessione internet.';

  @override
  String get genericErrorDesc => 'Si è verificato un errore. Riprova.';

  @override
  String get errorNoConnectionTitle => 'Nessuna connessione.';

  @override
  String get errorNoConnectionDesc => 'Controlla il tuo Wi-Fi o i dati mobili.';

  @override
  String get errorSlowConnectionTitle => 'Connessione lenta.';

  @override
  String get errorSlowConnectionDesc => 'Riprova tra poco.';

  @override
  String get errorNotFoundTitle => 'Non trovato.';

  @override
  String get errorNotFoundDesc => 'Il contenuto richiesto non esiste.';

  @override
  String get errorServerTitle => 'Errore server.';

  @override
  String get errorServerDesc => 'Qualcosa è andato storto lato server.';

  @override
  String get errorSessionExpiredTitle => 'Sessione scaduta.';

  @override
  String get errorSessionExpiredDesc => 'Effettua di nuovo il login.';

  @override
  String get errorNetworkGenericTitle => 'Errore di rete.';

  @override
  String get errorNetworkGenericDesc => 'Riprova più tardi.';

  @override
  String get errorAuthTitle => 'Errore Autenticazione';

  @override
  String get errorUnexpectedTitle => 'Errore imprevisto.';

  @override
  String get errorUnexpectedDesc => 'Si è verificato un errore inaspettato.';

  @override
  String get authInvalidCredentials => 'Credenziali non valide. Riprova.';

  @override
  String get authEmailAlreadyInUse =>
      'Questo indirizzo email è già in uso da un altro account.';

  @override
  String get authRateLimitExceeded =>
      'Troppi tentativi. Riprova tra qualche minuto.';

  @override
  String get authNotSignedIn => 'Devi effettuare l\'accesso per farlo.';

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
  String get errorUpdating =>
      'Impossibile aggiornare. Controlla la connessione e riprova.';

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
  String get accountSection => 'Account';

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
  String get crewTitle => 'Staff';

  @override
  String get recommendedMoviesTitle => 'Consigliati per te';

  @override
  String get recommendedSeriesTitle => 'Ti potrebbe piacere anche';

  @override
  String get biographyTitle => 'Biografia';

  @override
  String get filmographyTitle => 'Filmografia';

  @override
  String get noBiography => 'Nessuna biografia disponibile.';

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
  String get favoritesTitle => 'Preferiti';

  @override
  String get noFavorites => 'Nessun preferito';

  @override
  String get noFavoritesDescription =>
      'Aggiungi un film o una serie dalla pagina dettaglio per vederlo qui.';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String uploadError(String error) {
    return 'Errore upload: $error';
  }

  @override
  String get closeSelection => 'Chiudi selezione';

  @override
  String get addToListAction => 'Aggiungi a lista';

  @override
  String get toggleWatchedAction => 'Segna come visto/non visto';

  @override
  String get markAsUnwatchedAction => 'Segna come non visto';

  @override
  String get dropSeriesAction => 'Interrompi';

  @override
  String get watchLaterAction => 'Guarda più tardi';

  @override
  String get markSelectedEpisodesWatchedAction => 'Segna come visti';

  @override
  String get removeFromThisList => 'Rimuovi dalla lista';

  @override
  String get noWatchlistsAvailableHint =>
      'Nessuna lista disponibile. Creane una dal dettaglio di un titolo.';

  @override
  String get selectionActionDone => 'Aggiornato';

  @override
  String selectionActionPartialFailure(int count) {
    return '$count elementi non aggiornati. Riprova.';
  }

  @override
  String get confirm => 'Conferma';

  @override
  String get markUnwatchedConfirmTitle => 'Segnare come non visti?';

  @override
  String markUnwatchedConfirmMessage(int count) {
    return '$count elementi verranno rimossi dalla cronologia visti.';
  }

  @override
  String get dropSeriesConfirmTitle => 'Interrompere la serie?';

  @override
  String dropSeriesConfirmMessage(int count) {
    return '$count serie verranno segnate come interrotte.';
  }

  @override
  String get watchLaterConfirmTitle => 'Spostare in Guarda più tardi?';

  @override
  String watchLaterConfirmMessage(int count) {
    return '$count serie verranno spostate in Guarda più tardi.';
  }

  @override
  String get watchedButtonLabelWatched => 'Visto';

  @override
  String get watchedButtonLabelUnwatched => 'Segna come Visto';

  @override
  String get undoAction => 'Annulla';

  @override
  String get unwatchedSnackbarMessage => 'Rimosso dalla cronologia visti.';

  @override
  String get dataSection => 'Dati';

  @override
  String get importTvTimeTitle => 'Importa da TV Time';

  @override
  String get importTvTimeSubtitle =>
      'Porta la cronologia visti e le liste dentro Filmania';

  @override
  String get importTvTimeInstructions =>
      'Esporta i tuoi dati da TV Time e seleziona qui sotto il file .zip.';

  @override
  String get importTvTimePickButton => 'Seleziona file zip';

  @override
  String get importTvTimeParsing => 'Estrazione file...';

  @override
  String get importTvTimeMatchingMovies => 'Matching film su TMDB...';

  @override
  String get importTvTimeMatchingSeries => 'Matching serie TV su TMDB...';

  @override
  String get importTvTimeFetchingRuntimes => 'Recupero durate...';

  @override
  String get importTvTimeWriting => 'Salvataggio dati...';

  @override
  String get importTvTimeConfirm => 'Conferma e importa';

  @override
  String get importTvTimeUnmatchedTitle => 'Non trovati su TMDB';

  @override
  String get importTvTimeRetry => 'Riprova';

  @override
  String get importTvTimeDone => 'Import completato';

  @override
  String get importTvTimePreviewTitle => 'Anteprima import';

  @override
  String get importTvTimeCountMovies => 'Film';

  @override
  String get importTvTimeCountEpisodes => 'Episodi';

  @override
  String get importTvTimeCountLists => 'Liste';

  @override
  String get importTvTimeCountListItems => 'Item liste';

  @override
  String get importTvTimeCountMoviesImported => 'Film importati';

  @override
  String get importTvTimeCountEpisodesImported => 'Episodi importati';

  @override
  String get importTvTimeCountListsImported => 'Liste importate';

  @override
  String get importTvTimeCountListItemsImported => 'Item liste importati';

  @override
  String get importTvTimeBackToSettings => 'Torna alle impostazioni';

  @override
  String get importTvTimeErrorTitle => 'Errore durante l\'import';

  @override
  String get importTvTimeUnmatchedReason => 'Motivo';

  @override
  String importTvTimeUnmatchedCount(int count) {
    return '$count elementi non trovati su TMDB';
  }

  @override
  String get importTvTimeDownloadUnmatched => 'Scarica lista (CSV)';
}
