# Filmania — Task list divisa (12 prompt indipendenti)

Ogni blocco sotto è un prompt autonomo da incollare in una sessione Claude Code separata (il repo ha già CLAUDE.md/DESIGN.md, non serve reincollarli). Ordine consigliato: 1→7 in qualunque ordine tra loro (indipendenti), poi 8 prima di 9/10b/11 (dipendenza esplicita).

Dopo ogni task: `dart run build_runner build --delete-conflicting-outputs` (se toccati Freezed/Riverpod) → `dart analyze` → `flutter test`. Nessun commit automatico, review manuale del diff.

---

## Task 1 — Top bar: rimuovi toggle tema, sposta avatar, aggiungi modalità minimal

File: `lib/core/widgets/glassmorphic_app_bar.dart`, `profile_page.dart`, `movie_details_page.dart`, `tv_episode_details_page.dart`.

Oggi la barra mostra: logo "Filmania" + avatar profilo (a sinistra, righe 49-74, senza `onTap`) + toggle tema (a destra, righe 90-107).

1. Rimuovi il toggle tema rapido (righe 90-107, l'`IconButton` con `themeModeProvider`). Il selettore tema completo in `settings_page.dart` (Chiaro/Scuro/Michele) resta invariato — non toccarlo.
2. Sposta l'icona/avatar profilo sulla destra (dove prima c'era il toggle tema) e rendila cliccabile: `onTap` deve fare `context.push(AppRoutes.profile)` (import da `core/router/app_router.dart`).
3. Aggiungi un parametro `showProfileIcon` (default `true`). In `profile_page.dart` (riga 32, istanziazione di `GlassmorphicAppBar`) passa `showProfileIcon: false`, perché lì l'avatar è già mostrato in grande da `_ProfileHero` (riga 105) — non duplicarlo.
4. Aggiungi un parametro `minimal: bool` (default `false`): quando `true`, l'app bar mostra solo il pulsante indietro (se `showBackButton`), nascondendo logo, avatar e ogni altro elemento. Usa `minimal: true` in:
   - `features/movies/ui/pages/movie_details_page.dart` (riga 29)
   - `features/tv_series/ui/pages/tv_episode_details_page.dart` (riga 37)

   Le altre pagine con `showBackButton: true` (trending_movies_page.dart, trending_tv_series_page.dart, settings_page.dart, tv_series_details_page.dart, watchlist_detail_page.dart) restano invariate.

---

## Task 2 — Settings: sposta il pulsante "Esci"

File: `lib/features/settings/ui/pages/settings_page.dart`, `profile_page.dart`.

Sposta il pulsante "Esci" da `profile_page.dart` (righe 73-86, `OutlinedButton` con `ref.read(authProvider.notifier).logout()` e testo `l10n.signOut`) a `settings_page.dart`, in fondo, come sezione a parte (stile `_SettingsSection`/`_SettingsTile` già presente). Rimuovi completamente il bottone da `profile_page.dart`.

*(Indipendente da Task 1, ma stesso file `profile_page.dart` — se esegui entrambi in sessioni separate, fai Task 1 e poi Task 2 per evitare conflitti sullo stesso diff.)*

---

## Task 3 — Fix testi minori

File: `lib/features/home/ui/widgets/home_widgets.dart`, `lib/features/discover/ui/pages/discover_page.dart`.

1. "Profile" → "Profilo": riga 1053 di `home_widgets.dart`, `_NavBarItem(icon: Icons.person_outline_rounded, label: 'Profile', ...)`. Stringa letterale `'Profilo'`, stesso pattern hardcoded delle altre voci (Home, Scopri, Watchlist) — non serve l10n qui.
2. "movie" → "film": riga 204 di `discover_page.dart`, hint text `'Cerca movie, attori, registi...'` → `'Cerca film, attori, registi...'`.

---

## Task 4 — Rimuovi il voto dagli episodi

File: `lib/features/tv_series/ui/widgets/tv_series_widgets.dart`.

In `_EpisodeCardNumberRow`, righe 471-482, rimuovi il blocco `if (episode.voteAverage > 0) ...` (icona stella + voto). Non toccare l'entity `TVEpisode` — il campo resta, solo non va più mostrato in UI.

*(Task piccolissimo, puoi unirlo mentalmente al Task 3 se preferisci una sola sessione per entrambi.)*

---

## Task 5 — Discover: filtri genere/anno funzionanti

File: `lib/features/discover/ui/pages/discover_page.dart`, `discover_providers.dart`, datasource TMDB movies/tv.

L'icona filtri esiste ma è morta: `Icon(Icons.tune_rounded, ...)` a riga 218 di `discover_page.dart`, senza `onTap`/`onPressed`.

1. Wrappala in `GestureDetector`/`IconButton` che apre una bottom sheet filtri (stile `_showThemePicker`/`_showLanguagePicker` di `settings_page.dart`: `showModalBottomSheet` con `AppColors.of(context).background`, `BorderRadius.vertical(top: Radius.circular(AppSpacing.radius))`).
2. Filtri: genere (endpoint TMDB `genre/movie/list` e `genre/tv/list` — aggiungi i metodi mancanti a `IMoviesRemoteDataSource`/`ITVSeriesRemoteDataSource`) e anno/periodo di uscita (range o anno singolo).
3. I filtri selezionati devono modificare la query verso `discoverMoviesProvider`/`discoverTVSeriesProvider` (in `discover_providers.dart`) passando `with_genres` e `primary_release_year`/`first_air_date_year` (o `year`) — verifica i nomi esatti dei parametri su `discover/movie` e `discover/tv`.
4. Badge/indicatore quando ci sono filtri attivi (es. pallino colorato sull'icona).

---

## Task 6 — Fix bug icona watchlist in MediaGridCard

File: `lib/features/discover/ui/widgets/discover_widgets.dart`.

In `MediaGridCard` (usato in Home, Discover, ovunque ci siano griglie di poster), l'icona bookmark a riga 178 è statica: `Icon(Icons.bookmark_add_outlined, ...)`, non riflette mai lo stato reale.

Fix: come già fa `_WatchlistButton` in `movie_details_page.dart`/`tv_series_details_page.dart`, wrappa con `ref.watch(isMediaInWatchlistProvider(mediaId, mediaType))` e mostra `Icons.bookmark_rounded` (pieno, colore primario) quando `isIn == true`, altrimenti `Icons.bookmark_add_outlined`.

---

## Task 7 — Cast e Staff (crew)

File: `lib/core/widgets/cast_section.dart`, `core/domain/entities/cast_member.dart`, `core/data/models/cast_member_dto.dart`, `movies_remote_datasource_impl.dart` (~riga 67), `tv_series_remote_datasource_impl.dart`, `movie_details_page.dart`, `tv_series_details_page.dart`.

Oggi viene mostrato solo il cast (attori): `getMovieCredits`/`getTVSeriesCredits` leggono solo `response.data['cast']`, ignorando `response.data['crew']`.

1. Crea `CrewMemberDto`/`CrewMember` (analogo a `CastMemberDto`/`CastMember` ma con `job`/`department` al posto di `character`) in `core/data/models/` e `core/domain/entities/`.
2. Estendi `getMovieCredits`/`getTVSeriesCredits` (datasource → repository → provider) per restituire anche la crew — es. tipo `Credits { List<CastMember> cast; List<CrewMember> crew; }`, oppure due liste separate; mantieni la firma coerente col resto del layer (vedi `i_movies_repository.dart`, `movies_provider.dart`).
3. Nuova sezione UI (accanto a `CastSection`, stesso stile a lista orizzontale scrollabile) che mostra la crew completa restituita da TMDB (non solo i ruoli chiave), con nome e `job`.
4. Usala in `movie_details_page.dart` (`_MovieCastSection`) e `tv_series_details_page.dart` (`_TVSeriesCastSection`).
5. **Pagina dettaglio persona (attore/membro crew)**: oggi `_CastCard` (`cast_section.dart`, righe 57-126) non ha `onTap` e non esiste alcuna pagina/rotta persona nel progetto — è una feature nuova, non un semplice collegamento.
   - Crea una feature leggera `features/person/` (domain: `Person` entity Freezed con bio/data e luogo di nascita/foto/eventuale filmografia; data: `PersonDto`, datasource TMDB `person/{id}` + `person/{id}/combined_credits` per la filmografia; repository + provider) — stesso pattern di `features/movies/`, ma più semplice (sola lettura, nessun dato Supabase).
   - Aggiungi la rotta `AppRoutes.personDetails = '/person/:id'` in `app_router.dart` (segui il pattern di `movieDetails` riga 35).
   - Crea `PersonDetailsPage` (foto grande, nome, bio, data/luogo di nascita, lista filmografia riusando `MediaGridCard` in griglia o lista orizzontale).
   - Rendi cliccabili sia `_CastCard` (cast) sia la nuova card crew (punto 3): wrappa con `GestureDetector`/`InkWell` sull'immagine (o l'intera card, per coerenza tocco 48x48 minimo) con `onTap: () => context.push(AppRoutes.personDetails.replaceAll(':id', member.id.toString()))`.

---

## Task 8 — Sezione "Consigliati"

File: `movie_details_page.dart`, `tv_series_details_page.dart`, datasource/repository/provider movies e tv_series.

Aggiungi una sezione "Consigliati"/"Ti potrebbe piacere" usando `movie/{id}/recommendations` e `tv/{id}/recommendations`.

1. Aggiungi `getMovieRecommendations`/`getTVSeriesRecommendations` a `IMoviesRemoteDataSource`/`ITVSeriesRemoteDataSource` (+ implementazioni, repository, provider — stesso pattern di `getMovieCredits`).
2. UI: riusa/adatta `MediaGridCard` in una lista orizzontale scrollabile (stile coerente con `CastSection`), posizionata dopo la sezione cast/staff, prima o dopo la sezione episodi (per le serie TV).

---

## Task 9 — Selezione multipla: componente condiviso (fondamenta)

**Da eseguire prima dei Task 10, 11b e 12** (introducono azioni che dipendono da questo).

Si applica a: Home (`home_widgets.dart`: `WatchingCard`, `_FeaturedBentoCard`, `_SecondaryBentoCard`, card della `CuratedSection`), Discover (`MediaGridCard` in `discover_widgets.dart`), Watchlist (`WatchlistMediaCard` in `watchlist_widgets.dart`), Visti (`watched_list_page.dart`, `_buildGrid`, righe 121-167).

1. Estrai un widget/mixin riutilizzabile in `core/widgets/` (regola DRY): pressione lunga su una card entra in "modalità selezione" (card marcata selezionata, es. overlay/checkmark) e mostra una action bar contestuale in alto. In modalità selezione, un tap su un'altra card ne fa il toggle invece di aprirla. Tap su indietro/chiudi della action bar, o deselezione dell'ultimo elemento, esce dalla modalità e ripristina tap = apri dettaglio.
2. Applica questo widget/mixin in tutti i punti sopra elencati.
3. Azioni della action bar da collegare **ora** (già esistenti nel codice):
   - "Aggiungi a una lista" → `showWatchlistPicker` (`watchlist_picker_sheet.dart`).
   - "Segna come visto / non visto" → `WatchedButton`/logica di `watched_providers.dart`.
   - Multi-selezione: stesse azioni in blocco su tutti gli elementi selezionati (es. rimuovi tutti dalla watchlist corrente, segna tutti come visti).
4. Lascia un placeholder/TODO esplicito nella action bar per "Interrompi" (Task 10) e "Preferiti" (Task 11) — verranno agganciati dopo.

---

## Task 10 — Sezione "Interrotte" (stato persistito) — dipende da Task 9

File: Supabase migration, `watched_repository_impl.dart`, `i_watched_remote_datasource.dart`, `categorized_tv_series_provider.dart`, `watched_list_page.dart`, `app_it.arb`/`app_en.arb`.

Oggi `TvSeriesWatchStatus` (`watching`/`upToDate`/`completed`) è calcolato al volo dal numero di episodi visti — nessun campo salvato, quindi "interrotta" va persistito.

1. **Migrazione Supabase — nessuna nuova RLS, solo colonna da aggiungere manualmente (Matteo, non Claude Code).** Verificato il 2026-07-03: la tabella `watched_items` ha già una policy `ALL` ("Users can manage their own watched items", `qual = auth.uid() = user_id`) più una policy `UPDATE` dedicata — `UPDATE` è già coperto, non serve nessuna nuova policy RLS. Le policy esistenti non seguono la convenzione di naming `[table]_[role]_[action]` di CLAUDE.md, ma sono preesistenti: non rinominarle/toccarle.

   Matteo esegue manualmente nello SQL Editor Supabase (Claude Code non deve scrivere né applicare nulla su questo):
   `ALTER TABLE watched_items ADD COLUMN is_dropped boolean NOT NULL DEFAULT false;`

   **Claude Code**: non toccare Supabase per questo task, non scrivere file di migrazione — dai per scontato che la colonna esista già quando esegui i punti 2-5 sotto (verrà applicata prima di far girare questo task).
2. Repository/datasource: `markSeriesAsDropped(seriesId, isDropped)` in `IWatchedRepository`/`WatchedRepositoryImpl` e nel datasource.
3. Provider: aggiungi `TvSeriesWatchStatus.dropped` all'enum in `categorized_tv_series_provider.dart`. Nella funzione `categorizedTvSeries`, se `is_dropped == true`, assegna `status = dropped` a prescindere dal conteggio episodi (priorità sul calcolo automatico).
4. UI: in `watched_list_page.dart`, `_buildTvSeriesScaffold` (righe 58-110), aggiungi un quarto `Tab` "Interrotte", filtra `items.where((e) => e.status == TvSeriesWatchStatus.dropped)`, aggiorna `DefaultTabController(length: 3, ...)` → `length: 4`. Aggiungi la chiave l10n mancante accanto a `watching`/`upToDate`/`completed`.
5. Collega l'azione "Interrompi" (placeholder lasciato nel Task 9) a `markSeriesAsDropped`.

---

## Task 11a — "Preferiti": backend (Supabase + domain/data/repository/provider)

Segui la skill di progetto `generate_feature` se presente (`.claude/skills/` o equivalente), riferimento più vicino: `features/watchlist/`.

1. **Supabase — GIÀ FATTO manualmente da Matteo, non toccare.** Tabella `favorites` già creata e verificata il 2026-07-03:
   - Colonne: `id` (uuid, PK, `gen_random_uuid()`), `user_id` (uuid, not null, `references auth.users(id) on delete cascade`), `media_id` (integer, not null), `media_type` (text, not null — `'movie' | 'tv'`), `media_title` (text, not null), `poster_path` (text, nullable), `created_at` (timestamptz, default `now()`).
   - `UNIQUE(user_id, media_id, media_type)` (constraint `favorites_user_id_media_id_media_type_key`).
   - RLS abilitata, 3 policy verificate: `favorites_owner_select` (SELECT), `favorites_owner_insert` (INSERT), `favorites_owner_delete` (DELETE) — tutte `auth.uid() = user_id`. Nessuna policy UPDATE (il toggle preferito è insert/delete, stesso pattern di `watchlist_items` — non serve).

   **Claude Code**: non toccare Supabase per questo task, non scrivere file di migrazione — la tabella esiste già, parti direttamente dal codice Dart (punti 2-3 sotto).
2. Domain/data/repository: `FavoriteItem` entity (Freezed), `FavoriteItemDto`, `IFavoritesRepository`/`FavoritesRepositoryImpl`, datasource — stesso pattern di `features/watchlist/`.
3. Provider: `favoritesProvider` (lista preferiti utente) e `isMediaFavoriteProvider(mediaId, mediaType)` (per icone reattive), stile `watchlist_providers.dart`.

---

## Task 11b — "Preferiti": UI e collegamenti — dipende da Task 9 e 11a

1. Pagina "Preferiti" (griglia poster, stile `watched_list_page.dart`/`watchlist_page.dart`), raggiungibile da un punto coerente con la nav esistente (proponi l'opzione migliore: es. voce in profilo, dato che la bottom nav ha già Home/Scopri/Watchlist/Profilo — evita di aggiungere un quinto tab).
2. Collega l'azione "Aggiungi/rimuovi dai preferiti" (placeholder lasciato nel Task 9) a questa feature.
3. Icona cuore reattiva nelle pagine dettaglio film/serie (stesso pattern del bookmark in `_WatchlistButton`).

---

## Task 12 — Episodi: segna più insieme — dipende da Task 9

File: `tv_series_widgets.dart` (`EpisodesSection`/`_EpisodesList`/`EpisodeCard`, `WatchedEpisodeButton` riga 296), `watched_episode_button.dart` (righe 69-85), `watched_repository_impl.dart`.

Il bottone icona di `WatchedEpisodeButton` già segna un singolo episodio come visto senza aprirlo. Aggiungi selezione multipla per episodi usando l'infrastruttura del Task 9, con un'azione nella action bar:

- Opzione A (pattern "segna visti fino a qui"): dato un episodio selezionato, marca come visti tutti gli episodi della stagione fino a quello incluso.
- Opzione B (più semplice): selezione multipla libera + azione "Segna selezionati come visti" che chiama in batch `markEpisodeAsWatched` per ciascuno (via `watched_repository_impl.dart`), poi invalida gli stessi provider già invalidati oggi in `watched_episode_button.dart`.

Scegli l'opzione più semplice da integrare con l'infrastruttura già scritta nel Task 9.

---

## Note generali

- Ogni task presuppone che tu apra una sessione Claude Code nella root del progetto (CLAUDE.md/DESIGN.md già letti automaticamente).
- Task 9 è un prerequisito hard per 10, 11b, 12 — eseguilo e fai review del diff prima di procedere con quelli.
- Task 10 e 11a toccano Supabase: se Claude Code non ha le credenziali/accesso al progetto Supabase, si fermerà con lo SQL pronto in `supabase/migrations/` invece di indovinare lo schema — applica tu la migrazione prima di far girare 10/11b sul codice Dart che dipende dalle nuove colonne/tabelle.
- Nessun task fa