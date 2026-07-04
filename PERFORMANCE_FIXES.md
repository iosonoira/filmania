# 🚀 Filmania Performance Optimization Guide

Questo documento delinea i principali colli di bottiglia riscontrati nell'applicazione e le strategie tecniche per risolverli, garantendo un framerate stabile a 60/120fps anche in modalità release.

---

## 1. Abuso di `BackdropFilter` (Glassmorphism)

### Il Problema
L'effetto "Glass" (sfocatura) è ottenuto tramite il widget `BackdropFilter`. Questo widget è uno dei più costosi in Flutter perché richiede che la GPU legga il buffer dei pixel già renderizzati sotto l'elemento, applichi un algoritmo di blur e lo riscriva.
Nell'app attuale:
- `GlassmorphicAppBar` e `FloatingBottomNavBar` sono sempre attivi.
- Ogni `MediaGridCard` nella grid Discover usa **due** filtri di blur per i piccoli bottoni in alto a destra. In una grid con 8 card visibili, ci sono 16 filtri attivi simultaneamente durante lo scroll.

### La Soluzione
1.  **Eliminazione selettiva**: Rimuovere il blur dai componenti piccoli o ripetitivi (come i bottoni nelle card). Usare un semplice `Colors.black.withValues(alpha: 0.5)` per lo sfondo dei bottoni.
2.  **Ottimizzazione AppBar/NavBar**: Mantenere il blur solo se strettamente necessario. In alternativa, usare un gradiente solido che sfuma verso il nero/sfondo.
3.  **Static Blur**: Per elementi che non cambiano frequentemente lo sfondo sotto di essi, considerare l'uso di un'immagine offuscata pre-generata (non applicabile a liste a scorrimento).

---

## 2. Widget `Opacity` vs `color.withOpacity`

### Il Problema
Il widget `Opacity` crea un layer separato nel motore di rendering di Skia/Impeller. Per ogni frame, Flutter deve renderizzare il widget in un buffer temporaneo e poi applicare l'opacità.
Esempio critico: `_FeaturedBentoCard` (`home_widgets.dart:649`).

### La Soluzione
Sostituire il widget `Opacity` con metodi che non richiedono layer extra:
- Invece di `Opacity(opacity: 0.6, child: Container(color: Colors.black))`, usare `Container(color: Colors.black.withValues(alpha: 0.6))`.
- Per le immagini, usare la proprietà `color` e `colorBlendMode` di `Image` o `CachedNetworkImage` (es: `color: Colors.white.withOpacity(0.6), colorBlendMode: BlendMode.modulate`).

---

## 3. Ombre e Overdraw (Sovrapposizione)

### Il Problema
Le ombre molto ampie (`blurRadius: 40`) e i molteplici gradienti sovrapposti aumentano il carico di lavoro della GPU per pixel (Overdraw). Disegnare un pixel 4-5 volte nello stesso frame riduce drasticamente le prestazioni.

### La Soluzione
1.  **Riduzione Ombre**: Portare il `blurRadius` a valori più moderati (es. `12` o `15`) nelle liste a scorrimento veloce. Un'ombra molto ampia in una lista che si muove a 60fps è quasi indistinguibile da un'ombra più piccola ma richiede molta più potenza di calcolo.
2.  **Semplificazione Layer**: Verificare se è possibile unificare più gradienti in uno solo o usare un'immagine di sfondo già scurita.

---

## 4. Clipping Antialias

### Il Problema
L'uso di `Clip.antiAlias` (specialmente in `MediaGridCard` e `CastSection`) è costoso durante lo scroll perché forza il calcolo dei sub-pixel sui bordi curvi.

### La Soluzione
1.  **Cambio Strategia**: Passare a `Clip.hardEdge` quando il contrasto tra l'elemento e lo sfondo è basso (la differenza visiva sarà minima).
2.  **Evitare il Clip**: Se possibile, arrotondare le immagini tramite `BoxDecoration` invece di avvolgerle in un `ClipRRect`.

---

## 5. Casi di Memory Cache mancanti

### Il Problema
In alcune pagine dettagli (`movie_details_page.dart:124`), le immagini vengono caricate senza limiti alla cache di memoria (`memCacheWidth` / `memCacheHeight`).

### La Soluzione
Aggiungere sempre `memCacheWidth` o `memCacheHeight` a tutti i widget `CachedNetworkImage`. Questo assicura che Flutter decodifichi l'immagine alla dimensione esatta di visualizzazione (es. 200-400px) invece di occupare megabyte di RAM per una risoluzione 4K che poi viene scalata via software.

---

## 6. Shader Compilation Jank

### Il Problema
Al primo avvio o dopo una build (`--obfuscate` può leggermente influire sui tempi di caricamento delle classi), Flutter deve compilare gli shader per gli effetti complessi (blur, gradienti).

### La Soluzione
1.  **Impeller**: Assicurarsi che su iOS sia attivo (default) e monitorare il supporto su Android.
2.  **Warm-up**: Se il problema persiste, si può generare un file di shader warm-up, anche se con Impeller questa pratica sta diventando obsoleta.

---

## Riassunto Interventi Prioritari
| Posizione | Intervento | Impatto |
| :--- | :--- | :--- |
| `MediaGridCard` | Rimuovere `GlassOverlay` dai bottoni | ⭐⭐⭐⭐⭐ |
| `home_widgets.dart` | Sostituire `Opacity` widget con `color.withOpacity` | ⭐⭐⭐ |
| Generale | Ridurre `blurRadius` delle ombre nelle liste | ⭐⭐⭐ |
| `MovieDetailsPage` | Aggiungere `memCacheWidth` all'immagine di testata | ⭐⭐ |
