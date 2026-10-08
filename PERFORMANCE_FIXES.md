# Filmania — Performance: problemi noti e interventi

Colli di bottiglia di rendering trovati nell'app e come risolverli. Ogni raccomandazione rimanda alla documentazione ufficiale Flutter da cui deriva; dove la documentazione non si esprime, è scritto esplicitamente.

> **Ultima verifica sul codice: 2026-10-07** (Flutter 3.41.7). Nessuno degli interventi sotto è ancora stato applicato. I numeri di riga si riferiscono a quella data. Il 2026-10-08 i file sono stati spostati nella nuova struttura (`ui/core/ui/`, `ui/<feature>/widgets/`): i nomi citati restano validi tranne `discover_widgets.dart`, diventato `ui/core/ui/media_grid_card.dart` (righe aggiornate).

---

## 1. `BackdropFilter` (sfocatura glass) su elementi piccoli e ripetuti

### Cosa dice la documentazione
Dalla [pagina API di `BackdropFilter`](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html): l'effetto è "relatively expensive, especially if the filter is non-local, such as a blur". Più filtri che condividono un `BackdropKey` (tramite `BackdropGroup` e il costruttore `BackdropFilter.grouped`) vengono combinati dal motore in un'unica operazione. I filtri che si sovrappongono non devono condividere la stessa chiave.

### Dove si trova nel codice
Tutta la sfocatura passa da `GlassOverlay` (`ui/core/ui/glass_overlay.dart`), che avvolge un `BackdropFilter` in un `RepaintBoundary`.

Elementi piccoli ripetuti in griglie e liste (i casi peggiori):
- `MediaGridCard`: **due** bottoni sfocati per card (`media_grid_card.dart:140`, `:165`). In una griglia con 8 card visibili sono 16 sfocature durante lo scroll.
- `_FavoriteCard`: badge cuore (`favorites_page.dart:197`).
- `_WatchlistCard`: badge segnalibro (`watchlist_page.dart:231`).
- `WatchlistMediaCard`: bottone rimuovi (`watchlist_widgets.dart:99`).
- `_WatchingCardBadge`: badge testuale nelle card della home (`home_widgets.dart:315`).

Elementi singoli, sempre visibili:
- `GlassmorphicAppBar` (`glassmorphic_app_bar.dart:29`).
- `FloatingBottomNavBar`, sigma 24 (`home_widgets.dart:1009`).
- Barra di ricerca di Discover (`discover_page.dart:292`).

Stati vuoti (impatto trascurabile, una sola istanza): `_FavoritesEmptyState` (`favorites_page.dart:251`), `_WatchlistEmptyState` (`watchlist_page.dart:285`).

### Soluzione
1. **Elementi piccoli ripetuti**: togliere la sfocatura e usare un colore semitrasparente come sfondo (es. `Colors.black.withValues(alpha: 0.5)` o il token di `AppColors` già usato come `color`).
2. **Se si vuole tenere la sfocatura** in una lista: raggruppare i filtri con `BackdropGroup` + `BackdropFilter.grouped`, come nell'esempio della pagina API.
3. **AppBar e NavBar**: tenerle, ma misurare con DevTools in profile mode prima di decidere se servono interventi.

---

## 2. Widget `Opacity`

### Cosa dice la documentazione
Dalla pagina [Performance best practices](https://docs.flutter.dev/perf/best-practices): usare `Opacity` "only when necessary". Per forme semplici o testo conviene disegnare direttamente con un colore semitrasparente. Per le immagini, applicare l'opacità all'immagine stessa è più veloce (sezione "Transparent image" della [pagina API di `Opacity`](https://api.flutter.dev/flutter/widgets/Opacity-class.html)). Nelle animazioni evitare `Opacity` e usare `AnimatedOpacity` o `FadeInImage`.

### Dove si trova nel codice
- `_FeaturedBentoCard`: `Opacity(opacity: 0.6)` intorno a un `CachedNetworkImage` (`home_widgets.dart:676`). **Il caso più importante.**
- `app_toast.dart:46`: `Opacity` dentro un `TweenAnimationBuilder`, cioè in un'animazione.
- `tv_series_widgets.dart:350`: `Opacity` sul bottone episodio quando la selezione multipla è attiva (statico, impatto basso).

### Soluzione
- Immagine della bento card: applicare l'opacità all'immagine (`color` + `colorBlendMode` di `CachedNetworkImage`) invece di usare il widget `Opacity`.
- Toast: sostituire con una transizione di opacità animata, come indicato dalla documentazione.
- Per i colori usare sempre `withValues(alpha:)`: `withOpacity` è deprecato e nel codice non è più usato.

---

## 3. Ombre molto ampie

### Cosa dice la documentazione
La documentazione ufficiale **non** indica un costo specifico per `blurRadius` delle ombre. La raccomandazione sotto è un'ipotesi da verificare con DevTools, non una regola documentata.

### Dove si trova nel codice
`blurRadius` ≥ 30 su card dentro liste o griglie:
- `WatchingCard`: 30 (`home_widgets.dart:173`).
- `_FeaturedBentoCard`: 40 (`home_widgets.dart:667`).
- `_BentoCard`: 40 (`profile_page.dart:374`).
- `_WatchedGridCard`: 40 (`watched_list_page.dart:609`).

`login_form.dart:125` e `register_form.dart:183` (32) sono su card singole, non in liste.

### Soluzione
Misurare in profile mode con DevTools lo scroll delle schermate coinvolte. Ridurre il `blurRadius` solo se i dati mostrano un problema.

---

## 4. Clipping

### Cosa dice la documentazione
Dalla [pagina API di `Clip`](https://api.flutter.dev/flutter/dart-ui/Clip.html): `hardEdge` è il più veloce tra i clip; `antiAlias` è più lento di `hardEdge` ma molto più veloce di `antiAliasWithSaveLayer`. Dalle [best practices](https://docs.flutter.dev/perf/best-practices): il clipping "is still costly, so use with caution"; per gli angoli arrotondati conviene usare la proprietà `borderRadius` dei widget invece di un clip; evitare il clipping nelle animazioni.

### Dove si trova nel codice
15 usi di `Clip.antiAlias`, 1 solo di `Clip.hardEdge`. Quelli in liste e griglie scorrevoli:
- `MediaGridCard` (`media_grid_card.dart:88`).
- `cast_section.dart:88`, `crew_section.dart:88`.
- `favorites_page.dart:147`, `watchlist_page.dart:162`, `watchlist_widgets.dart:43`.
- `home_widgets.dart:178`, `:672`; `profile_page.dart:563`, `:574`; `tv_series_widgets.dart:342`.

### Soluzione
1. Dove possibile, arrotondare con `borderRadius` invece di clippare.
2. Dove il clip serve, nelle liste passare a `Clip.hardEdge` e controllare a occhio che i bordi restino accettabili.

---

## 5. Immagini senza limite di cache in memoria

### Cosa dice la documentazione
`memCacheWidth` / `memCacheHeight` sono parametri del package [`cached_network_image`](https://pub.dev/packages/cached_network_image) (non di Flutter): fanno decodificare l'immagine alla dimensione indicata invece che a piena risoluzione.

### Dove si trova nel codice
17 `CachedNetworkImage` su 21 li impostano già. Mancano in:
- `movie_details_page.dart:144`: backdrop in testata.
- `tv_series_details_page.dart:86`: backdrop in testata.
- `tv_episode_details_page.dart:114`: immagine dell'episodio.
- `profile_page.dart:142`: foto profilo.

### Soluzione
Aggiungere `memCacheWidth` o `memCacheHeight` in base alla dimensione reale a schermo.

---

## 6. Compilazione degli shader

### Cosa dice la documentazione
Dalla pagina [Impeller](https://docs.flutter.dev/perf/impeller): dalla 3.27 Impeller è il motore di default su iOS (unico supportato) e su Android API 29+. Sui dispositivi Android con API più bassa o senza Vulkan si torna al vecchio renderer OpenGL. Impeller precompila gli shader al build del motore, quindi non vengono compilati a runtime.

### Situazione
Il progetto usa Flutter 3.41.7, quindi Impeller è già attivo. **Nessun intervento necessario.** Lo shader warm-up non serve più.

---

## Interventi prioritari

| Dove | Intervento | Impatto atteso |
| :--- | :--- | :--- |
| `MediaGridCard` e badge delle card (Preferiti, Watchlist, home) | Togliere `GlassOverlay` dagli elementi piccoli ripetuti, oppure raggrupparli con `BackdropGroup` | Alto |
| `_FeaturedBentoCard` | Opacità applicata all'immagine invece del widget `Opacity` | Medio |
| Card in liste e griglie | `borderRadius` o `Clip.hardEdge` al posto di `Clip.antiAlias` | Medio |
| Testate dei dettagli film, serie ed episodio, foto profilo | Aggiungere `memCacheWidth`/`memCacheHeight` | Basso-medio |
| Card con ombra 30–40 | Ridurre il `blurRadius` solo se DevTools lo conferma | Da misurare |
