import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/data/services/network_failure.dart';
import 'package:filmania/domain/failures/auth_failure.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/l10n/auth_failure_l10n.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';

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
    final l10n = ref.watch(appLocalizationsProvider);
    final (icon, title, subtitle) = _resolveErrorData(l10n);

    if (compact) {
      return _CompactErrorView(
        icon: icon,
        message: title,
        retryLabel: l10n.retryBtn,
        onRetry: onRetry,
      );
    }

    return _FullErrorView(
      icon: icon,
      title: title,
      subtitle: subtitle,
      retryLabel: l10n.retryBtn,
      onRetry: onRetry,
    );
  }

  (IconData, String, String) _resolveErrorData(AppLocalizations l10n) {
    // ClientException (from Supabase/http) often means connection issues on Web
    if (error.toString().contains('ClientException') ||
        error.toString().contains('Failed to fetch')) {
      return (
        Icons.signal_wifi_off_rounded,
        l10n.errorNoConnectionTitle,
        l10n.errorNoConnectionDesc,
      );
    }

    return switch (error) {
      final NetworkFailure failure => switch (failure) {
        TimeoutFailure() => (
          Icons.wifi_off_rounded,
          l10n.errorSlowConnectionTitle,
          l10n.errorSlowConnectionDesc,
        ),
        ConnectionFailure() => (
          Icons.signal_wifi_off_rounded,
          l10n.errorNoConnectionTitle,
          l10n.errorNoConnectionDesc,
        ),
        ServerFailure(:final statusCode) =>
          statusCode == 404
              ? (
                  Icons.search_off_rounded,
                  l10n.errorNotFoundTitle,
                  l10n.errorNotFoundDesc,
                )
              : (
                  Icons.cloud_off_rounded,
                  l10n.errorServerTitle,
                  l10n.errorServerDesc,
                ),
        UnauthorizedFailure() => (
          Icons.lock_outline_rounded,
          l10n.errorSessionExpiredTitle,
          l10n.errorSessionExpiredDesc,
        ),
        _ => (
          Icons.error_outline_rounded,
          l10n.errorNetworkGenericTitle,
          l10n.errorNetworkGenericDesc,
        ),
      },
      final AuthFailure failure => (
        Icons.person_outline_rounded,
        l10n.errorAuthTitle,
        authFailureMessage(failure, l10n),
      ),
      _ => (
        Icons.error_outline_rounded,
        l10n.errorUnexpectedTitle,
        l10n.errorUnexpectedDesc,
      ),
    };
  }
}

class _FullErrorView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String retryLabel;
  final VoidCallback? onRetry;

  const _FullErrorView({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.retryLabel,
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
          Icon(icon, size: 64, color: colors.primary.withValues(alpha: 0.6)),
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
            OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ],
      ),
    );
  }
}

class _CompactErrorView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String retryLabel;
  final VoidCallback? onRetry;

  const _CompactErrorView({
    required this.icon,
    required this.message,
    required this.retryLabel,
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
            tooltip: retryLabel,
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: colors.primary,
          ),
      ],
    );
  }
}
