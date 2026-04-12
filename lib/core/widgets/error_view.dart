import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/network_failure.dart';
import '../../features/auth/domain/failures/auth_failure.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AppErrorView extends ConsumerWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final bool compact;

  const AppErrorView({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, title, subtitle) = _resolveErrorData();

    if (compact) {
      return _CompactErrorView(
        icon: icon,
        message: title,
        onRetry: onRetry,
      );
    }

    return _FullErrorView(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onRetry: onRetry,
    );
  }

  (IconData, String, String) _resolveErrorData() {
    // ClientException (from Supabase/http) often means connection issues on Web
    if (error.toString().contains('ClientException') || 
        error.toString().contains('Failed to fetch')) {
      return (
        Icons.signal_wifi_off_rounded,
        'Nessuna connessione.',
        'Controlla il tuo Wi-Fi o i dati mobili.'
      );
    }

    return switch (error) {
      final NetworkFailure failure => switch (failure) {
          TimeoutFailure() => (
              Icons.wifi_off_rounded,
              'Connessione lenta.',
              'Riprova tra poco.'
            ),
          ConnectionFailure() => (
              Icons.signal_wifi_off_rounded,
              'Nessuna connessione.',
              'Controlla il tuo Wi-Fi o i dati mobili.'
            ),
          ServerFailure(:final statusCode) => statusCode == 404
              ? (Icons.search_off_rounded, 'Non trovato.', 'Il contenuto richiesto non esiste.')
              : (Icons.cloud_off_rounded, 'Errore server.', 'Qualcosa è andato storto lato server.'),
          UnauthorizedFailure() => (
              Icons.lock_outline_rounded,
              'Sessione scaduta.',
              'Effettua di nuovo il login.'
            ),
          _ => (Icons.error_outline_rounded, 'Errore di rete.', 'Riprova più tardi.'),
        },
      final AuthFailure failure => (
          Icons.person_outline_rounded,
          'Errore Autenticazione',
          failure.message
        ),
      _ => (
          Icons.error_outline_rounded,
          'Errore imprevisto.',
          'Si è verificato un errore inaspettato.'
        ),
    };
  }
}

class _FullErrorView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const _FullErrorView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: colors.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurfacePrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Riprova'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactErrorView extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const _CompactErrorView({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: colors.error),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: textTheme.bodySmall?.copyWith(color: colors.error),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onRetry != null)
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: colors.primary,
          ),
      ],
    );
  }
}
