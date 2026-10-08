/// Esegue N task asincroni con al massimo [concurrency] in volo
/// contemporaneamente, invece di lanciarli tutti insieme o uno alla volta.
///
/// Perché: per chiamate verso API esterne con rate limit (es. TMDB) o verso
/// Supabase, un `for` con `await` sequenziale è troppo lento (1 round-trip
/// alla volta) mentre un `Future.wait` su tutti gli item insieme rischia di
/// sforare i rate limit. La concorrenza limitata è il compromesso standard.
/// Implementazione manuale (niente package esterni, stessa scelta già presa
/// per l'import TV Time): sufficiente per il volume atteso (centinaia di item, non milioni).
Future<List<R>> mapWithConcurrency<T, R>(
  List<T> items,
  int concurrency,
  Future<R> Function(T item) worker, {
  void Function()? onEach,
}) async {
  final results = List<R?>.filled(items.length, null);
  var nextIndex = 0;

  Future<void> runWorker() async {
    while (true) {
      final i = nextIndex;
      if (i >= items.length) return;
      nextIndex++;
      results[i] = await worker(items[i]);
      onEach?.call();
    }
  }

  await Future.wait(List.generate(concurrency, (_) => runWorker()));
  return results.cast<R>();
}
