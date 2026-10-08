import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/l10n/app_localizations_provider.dart';
import 'package:filmania/core/widgets/app_toast.dart';
import 'package:filmania/core/widgets/selection/selection_scope.dart';

/// Shared after-bulk-action UX for every multi-select action bar wiring
/// site: shows a success/failure toast depending on [failureCount], then
/// clears the [SelectionScope]`<T>` so the bar collapses back to normal
/// tap-to-navigate.
///
/// This lives in `core/widgets/` rather than `core/widgets/selection/`
/// because it depends on `core/l10n/` for the toast copy — the plan's
/// Global Constraints keep the `selection/` subfolder itself framework-only
/// (Flutter SDK + `MediaType`), so this cross-cutting glue is kept one
/// level up instead of inside it.
///
/// Pass `failureCount: null` when the bulk action was never attempted
/// (e.g. the user cancelled a picker sheet) — no toast is shown and the
/// selection is left intact so the user can retry.
///
/// Pass [onUndo] to offer an "Undo" action on the success toast, reversing
/// the bulk action just performed. Only offered on a clean success
/// (`failureCount == 0`) — a partial failure already needs a retry of the
/// failed subset, and undoing a mixed batch would silently re-toggle items
/// that never changed in the first place.
void handleBulkSelectionResult<T>(
  BuildContext context,
  WidgetRef ref, {
  required int? failureCount,
  Future<void> Function()? onUndo,
}) {
  if (failureCount == null || !context.mounted) return;

  final l10n = ref.read(appLocalizationsProvider);
  final offerUndo = failureCount == 0 && onUndo != null;
  AppToast.show(
    context,
    failureCount > 0
        ? l10n.selectionActionPartialFailure(failureCount)
        : l10n.selectionActionDone,
    actionLabel: offerUndo ? l10n.undoAction : null,
    onAction: offerUndo
        ? () async {
            try {
              await onUndo();
            } catch (_) {
              if (context.mounted) {
                AppToast.show(context, l10n.errorUpdating);
              }
            }
          }
        : null,
  );

  SelectionScope.controllerOf<T>(context, listen: false).clear();
}
