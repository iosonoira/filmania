import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../data/models/user_stats_dto.dart';
import '../../domain/entities/user_stats.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/utils/logger.dart';
import '../../../watched/ui/providers/watched_providers.dart';

part 'user_stats_provider.g.dart';

@riverpod
Future<UserStats?> userStats(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;

  // React to changes in the watched lists to trigger a re-fetch of stats
  ref.watch(watchedItemsProvider(MediaType.movie));
  ref.watch(watchedItemsProvider(MediaType.tv));

  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.rpc(
    'get_user_stats',
    params: {'p_user_id': user.id},
  );

  // Utilizzo il logger di sistema del progetto
  AppLogger.debug('Stats response: $response', tag: 'UserStats');

  if (response == null) return null;

  Map<String, dynamic> data;
  if (response is List) {
    if (response.isEmpty) return null;
    data = response.first as Map<String, dynamic>;
  } else {
    data = response as Map<String, dynamic>;
  }

  final dto = UserStatsDto.fromJson(data);
  return dto.toEntity();
}
