import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

/// Generic yes/no confirmation dialog for destructive actions (e.g. bulk
/// "mark unwatched" or "drop series"), following the same `AlertDialog`
/// shape as the delete-watchlist confirm. Returns `true` only if the user
/// tapped the destructive action; `false` on cancel, dismiss, or if the
/// dialog is torn down before resolving (route popped, widget disposed).
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => ctx.pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => ctx.pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
