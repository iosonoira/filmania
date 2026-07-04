# Prompt per Claude Code — Modifiche UI/UX Filmania

Ho una lista di 19 richieste di modifica per l'app Filmania (Flutter, Clean Architecture, vedi CLAUDE.md e DESIGN.md). Le ho già analizzate nel codice e sotto trovi, per ognuna, cosa c'è oggi (con file e riga) e cosa cambiare. Segui CLAUDE.md/DESIGN.md per stile, Riverpod, naming, RLS ecc. Non introdurre nulla in contrasto con quelle regole.

Lavora per sezioni (A→K), in ordine, e dopo ogni sezione: `dart run build_runner build --delete-conflicting-outputs` se hai toccato Freezed/Riverpod, poi `dart analyze`. Alla fine `flutter test`. Non fare commit automatici, lasciami rivedere il diff.

---

## A. Top bar (`lib/core/widgets/glassmorphic_app_bar.dart`)

Oggi la barra mostra: logo "Filmania" + avatar profilo (a sinistra, righe 49-74, senza `onTap`) + toggle tema (a destra, righe 90-107).

1. **Rimuovi il toggle tema rapido** (righe 90-107, l'`IconButton` con `themeModeProvider`). Il selettore tema completo in `settings_page.dart` (Chiaro/Scuro/Michele) resta invariato — non toccare quello.
2. **Sposta l'icona/avatar profilo sulla destra** (dove prima c'era il toggle tema) e **rendila cliccabile**: `onTap` deve fare `context.push(AppRoutes.profile)` (import da `core/router/app_router.dart`).
3. Aggiungi un parametro tipo `showProfileIcon` (default `true`) al widget. In `profile_page.dart` (riga 32, dove viene istanziato `GlassmorphicAppBar`) passa `showProfileIcon: false`, perché in quella pagina l'avatar è già mostrato in grande da `_ProfileHero` (riga 105) — non ha senso duplicarlo.
4. Aggiungi un parametro tipo `minimal: bool` (default `false`): quando `true`, l'app bar mostra **solo** il pulsante indietro (se `showBackButton`), nascondendo completamente logo, avatar profilo e qualsiasi altro elemento. Usa `minimal: true` in:
   - `features/movies/ui/pages/movie_details_page.dart` (riga 29)
   - `features/tv_series/ui/pages/tv_episode_details_page.dart` (riga 37)
   
   Le altre pagine che usano `showBackButton: true` (trending_movies_page.dart, trending_tv_series_page.dart, settings_page.dart, tv_series_details_page.dart, watchlist_detail_page.dart) restano come sono ora — la richiesta riguarda solo le pagine di dettaglio film/episodio, non le pagine di serie TV, watchlist o impostazioni.

---

## B. Impostazioni (`lib/features/settings/ui/pages/settings_page.dart`)

5. **Sposta il pulsante "Esci"** da `profile_page.dart` (righe 73-86, l'`OutlinedButton` con `ref.read(authProvider.notifier).logout()` e testo `l10n.signOut`) a `settings_page.dart`, in fondo, come sezione a parte (coerente con lo stile `_SettingsSection`/`_SettingsTile` già presente). Rimuovi completamente il bottone da `profile_page.dart`.

---

## C. Testi (label)

6. **"Profile" → "Profilo"**: `lib/features/home/ui/widgets/home_widgets.dart`, riga 1053, `_NavBarItem(icon: Icons.person_outline_rounded, label: 'Profile', ...)`. È l'unica occorrenza hardcoded in inglese nella bottom nav (le altre voci — Home, Scopri, Watchlist — sono già in italiano hardcoded nello stesso stile: usa lo stesso pattern, stringa letterale `'Profilo'`, non serve introdurre l10n qui per coerenza col resto del file).
7. **"movie" → "film" nella barra di ricerca**: `lib/features/discover/ui/pages/discover_page.dart`, riga 204, hint text `'Cerca movie, attori, registi...'` → `'Cerca film, attori, registi...'`.

---

## D. Filtri Discover (`lib/features/discover/ui/pages/discover_page.dart`, `discover_providers.dart`)

8. L'icona filtri esiste già ma è **morta**: `Icon(Icons.tune_rounded, ...)` a riga 218 di `discover_page.dart`, senza `onTap`/`onPressed`. Rendila funzionante:
   - Wrappala in un `GestureDetector`/`IconButton` che apre una bottom sheet di filtri (stile coerente con `_showThemePicker`/`_showLanguagePicker` di `settings_page.dart`: `showModalBottomSheet` con `AppColors.of(context).background`, `BorderRadius.vertical(top: Radius.circular(AppSpacing.radius))`).
   - Filtri richiesti: **genere** (usa l'endpoint TMDB `genre/movie/list` e `genre/tv/list` — aggiungi i metodi necessari a `IMoviesRemoteDataSource`/`ITVSeriesRemoteDataSource` se non esistono) e **anno/periodo di uscita** (range o anno singolo).
   - I filtri selezionati devono modificare la query verso `discoverMoviesProvider`/`discoverTVSeriesProvider` (in `discover_providers.dart`) passando `with_genres` e `primary_release_year`/`first_air_date_year` (o `year`) come query params TMDB — verifica i nomi esatti dei parametri sull'endpoint `discover/movie` e `discover/tv`.
   - Mostra un badge/indicatore quando ci sono filtri attivi (es. pallino colorato sull'icona).

---

## E. Bug icona watchlist (`lib/features/discover/ui/widgets/discover_widgets.dart`)

9. In `MediaGridCard` (usato in Home, Discover, ovunque si vedano griglie di poster), l'icona bookmark a riga 178 è **statica**: `Icon(Icons.bookmark_add_outlined, ...)`, non riflette mai lo stato reale. Fix: come già fa `_WatchlistButton` in `movie_details_page.dart`/`tv_series_details_page.dart`, wrappa con `ref.watch(isMediaInWatchlistProvider(mediaId, mediaType))` e mostra `Icons.bookmark_rounded` (pieno, es. colore primario) quando `isIn == true`, altrimenti l'icona attuale `Icons.bookmark_add_outlined`.

---

## F. Cast e Staff (`lib/core/widgets/cast_section.dart`, `core/domain/entities/cast_member.dart`, `core/data/models/cast_member_dto.dart`, datasource TMDB)

10. Oggi viene mostrato solo il **cast** (attori), non lo staff. Le chiamate `getMovieCredits`/`getTVSeriesCredits` (in `movies_remote_datasource_impl.dart` riga ~67 e `tv_series_remote_datasource_impl.dart`) leggono solo `response.data['cast']`, ignorando `response.data['crew']`.
   - Crea un nuovo modello `CrewMemberDto`/`CrewMember` (analogo a `CastMemberDto`/`CastMember` ma con `job`/`department` al posto di `character`) in `core/data/models/` e `core/domain/entities/`.
   - Estendi i metodi `getMovieCredits`/`getTVSeriesCredits` (datasource → repository → provider) per restituire anche la crew, es. un tipo `Credits { List<CastMember> cast; List<CrewMember> crew; }`, oppure due liste separate — mantieni la firma coerente col resto del layer (vedi `i_movies_repository.dart`, `movies_provider.dart`).
   - Aggiungi una nuova sezione UI (accanto a `CastSection`, stesso stile a lista orizzontale scrollabile) che mostra la **crew completa** restituita da TMDB (non solo i ruoli chiave), con nome e `job`.
   - Usala in `movie_details_page.dart` (`_MovieCastSection`) e `tv_series_details_page.dart` (`_TVSeriesCastSection`).

---

## G. Consigliati (nuova feature)

11. Aggiungi una sezione "Consigliati"/"Ti potrebbe piacere" nelle pagine `movie_details_page.dart` e `tv_series_details_page.dart`, usando gli endpoint TMDB `movie/{id}/recommendations` e `tv/{id}/recommendations`.
   - Aggiungi `getMovieRecommendations`/`getTVSeriesRecommendations` a `IMoviesRemoteDataSource`/`ITVSeriesRemoteDataSource` (e relative implementazioni, repository, provider — stesso pattern di `getMovieCredits`).
   - UI: riusa/adatta `MediaGridCard` in una lista orizzontale scrollabile (stile coerente con `CastSection`), posizionata dopo la sezione cast/staff, prima o dopo la sezione episodi (per le serie TV).

---

## H. Voti episodi (`lib/features/tv_series/ui/widgets/tv_series_widgets.dart`)

12. Rimuovi il voto dagli episodi: in `_EpisodeCardNumberRow`, righe 471-482, rimuovi il blocco `if (episode.voteAverage > 0) ...` (icona stella + numero voto). Non serve toccare l'entity `TVEpisode` (il campo può restare, semplicemente non va più mostrato in UI).

---

## I. Selezione multipla e menu a pressione lunga

Si applica a **tutte** le griglie/liste di film e serie TV cliccabili: Home (`home_widgets.dart`: `WatchingCard`, `_FeaturedBentoCard`, `_SecondaryBentoCard`, e le card della `CuratedSection`), Discover (`MediaGridCard` in `discover_widgets.dart`), Watchlist (`WatchlistMediaCard` in `watchlist_widgets.dart`), liste "Visti" (`watched_list_page.dart`, griglia in `_buildGrid`, righe 121-167).

13. **Pattern UX consigliato** (standard Material, applicalo per coerenza in tutti i punti sopra): pressione lunga su una card entra in "modalità selezione" (quella card si marca come selezionata, es. con overlay/checkmark) e mostra una action bar contestuale in alto con le azioni disponibili (vedi punto 14). Mentre si è in modalità selezione, un **singolo tap** su un'altra card ne fa il toggle della selezione invece di aprirla (questo copre "selezionare più elementi con un singolo tap"). Un tap sul pulsante indietro/chiudi della action bar, o deselezionare l'ultimo elemento, esce dalla modalità selezione e ripristina il comportamento normale (tap = apri dettaglio).
   - Estrai questa logica in un widget/mixin riutilizzabile condiviso (es. `core/widgets/`) invece di duplicarla in ognuno dei posti sopra (regola DRY di CLAUDE.md).
14. **Azioni della action bar contestuale / menu a pressione lunga su singolo elemento**: riusa dove possibile funzionalità già esistenti:
    - "Aggiungi a una lista" → riusa `showWatchlistPicker` (già in `watchlist_picker_sheet.dart`).
    - "Segna come visto / non visto" → riusa `WatchedButton`/logica di `watched_providers.dart`.
    - "Interrompi" → nuova azione, vedi sezione J.
    - "Aggiungi/rimuovi dai preferiti" → nuova azione, vedi sezione K.
    - Per multi-selezione: le stesse azioni applicate in blocco a tutti gli elementi selezionati (es. rimuovi tutti dalla watchlist corrente, segna tutti come visti).

---

## J. Sezione "Interrotte" (nuovo stato persistito)

Oggi lo stato delle serie TV (`TvSeriesWatchStatus` in `categorized_tv_series_provider.dart`: `watching`/`upToDate`/`completed`) è **calcolato al volo** dal numero di episodi visti — non esiste alcun campo salvato, quindi "interrotta" non può essere dedotto automaticamente e va per forza persistito.

15. **Schema Supabase**: aggiungi una colonna (es. `is_dropped boolean not null default false`) alla tabella che memorizza gli item visti (verifica il nome esatto tabella guardando `watched_repository_impl.dart`/`i_watched_remote_datasource.dart`, presumibilmente `watched_items`). Segui la convenzione RLS di CLAUDE.md (`[table]_[role]_[action]`) per eventuali nuove policy necessarie — se la tabella ha già RLS per l'utente proprietario sulle altre colonne, la modifica non dovrebbe richiedere nuove policy, solo verificare che l'update della colonna sia coperto dalla policy di `update` esistente.
16. **Repository/datasource**: aggiungi un metodo tipo `markSeriesAsDropped(seriesId, isDropped)` in `IWatchedRepository`/`WatchedRepositoryImpl` e nel datasource.
17. **Provider**: in `categorized_tv_series_provider.dart`, aggiungi `TvSeriesWatchStatus.dropped` all'enum. Nella funzione `categorizedTvSeries`, se il flag `is_dropped` è `true` per un item, assegna `status = dropped` **indipendentemente** dal conteggio episodi (il flag manuale ha priorità sul calcolo automatico).
18. **UI**: in `watched_list_page.dart`, `_buildTvSeriesScaffold` (righe 58-110), aggiungi un quarto `Tab` "Interrotte" e filtra `items.where((e) => e.status == TvSeriesWatchStatus.dropped)`. Aggiorna `DefaultTabController(length: 3, ...)` a `length: 4`. Aggiungi la chiave l10n mancante (vedi `core/l10n/arb/app_it.arb`/`app_en.arb`, accanto a `watching`/`upToDate`/`completed`).
19. Collega l'azione "Interrompi" del menu a pressione lunga (sezione I) a questo nuovo metodo repository.

---

## K. "Preferiti" (nuova feature completa)

Nessuna traccia di "favorites" nel codice attuale: è una feature nuova a tutti gli effetti. Segui la skill di progetto `generate_feature` (in `.claude/skills/` o `.agents/skills/`, a seconda di come si è concluso il cleanup del CLAUDE.md — se esiste, usala) per creare una nuova feature `features/favorites/` con la struttura Clean Architecture standard (vedi es. `features/watchlist/` come riferimento più vicino per forma):

20. **Supabase**: nuova tabella `favorites` (colonne tipo: `id`, `user_id`, `media_id`, `media_type`, `media_title`, `poster_path`, `created_at`), con RLS abilitata e policy nominate secondo la convenzione `[table]_[role]_[action]` (es. `favorites_owner_select`, `favorites_owner_insert`, `favorites_owner_delete`).
21. **Domain/data/repository**: `FavoriteItem` entity (Freezed), `FavoriteItemDto`, `IFavoritesRepository`/`FavoritesRepositoryImpl`, datasource — stesso pattern di `features/watchlist/`.
22. **Provider**: `favoritesProvider` (lista preferiti utente) e `isMediaFavoriteProvider(mediaId, mediaType)` (per icone reattive), stile `watchlist_providers.dart`.
23. **UI**: una pagina "Preferiti" (griglia poster, stesso stile di `watched_list_page.dart`/`watchlist_page.dart`), raggiungibile da un punto di ingresso a tua scelta coerente con la navigazione esistente (es. una nuova voce/tab in profilo, o un pulsante in home — proponi tu l'opzione più coerente con l'architettura a 4 tab esistente, dato che la bottom nav ha già Home/Scopri/Watchlist/Profilo).
24. Collega l'azione "Aggiungi/rimuovi dai preferiti" del menu a pressione lunga (sezione I) a questa feature. Valuta anche un'icona cuore reattiva nelle pagine dettaglio film/serie (stesso pattern del bookmark in `_WatchlistButton`).

---

## L. Episodi: segna più episodi insieme

25. Nella pagina serie TV, `EpisodesSection`/`_EpisodesList`/`EpisodeCard` (`tv_series_widgets.dart`), il bottone icona di `WatchedEpisodeButton` (riga 296) già segna un singolo episodio come visto senza aprirlo. Aggiungi la possibilità di segnare **più episodi insieme senza aprirli**: nella action bar di selezione multipla introdotta al punto I (che qui si applica anche alla lista episodi di una stagione), aggiungi un'azione "Segna come visti" che, dato un episodio selezionato, marca come visti **tutti gli episodi della stagione fino a quello incluso** (pattern comune "segna visti fino a qui"), oppure — se preferisci un'interazione più semplice — permetti la selezione multipla libera di episodi e un'azione "Segna selezionati come visti" che chiama in batch `markEpisodeAsWatched` per ciascuno (via `watched_repository_impl.dart`), poi invalida gli stessi provider già invalidati oggi in `watched_episode_button.dart` (righe 69-85).

---

Al termine di ogni sezione, verifica manualmente su un emulatore/dispositivo che il flusso funzioni (in particolare i punti E, F, G, J, K che toccano rete/DB) prima di passare alla sezione successiva. Se una sezione richiede una migrazione Supabase (J, K) e non hai accesso diretto al progetto Supabase per applicarla, scrivi lo SQL necessario in un file (es. `supabase/migrations/`) e segnalamelo esplicitamente invece di procedere a scrivere codice Dart che dipende da colonne/tabelle non ancora esistenti.
