import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations_provider.dart';
import 'app_toast.dart';
import 'selection/selection_scope.dart';

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
void handleBulkSelectionResult<T>(
  BuildContext context,
  WidgetRef ref, {
  required int? failureCount,
}) {
  if (failureCount == null || !context.mounted) return;

  final l10n = ref.read(appLocalizationsProvider);
  AppToast.show(
    context,
    failureCount > 0
        ? l10n.selectionActionPartialFailure(failureCount)
        : l10n.selectionActionDone,
  );

  SelectionScope.controllerOf<T>(context, listen: false).clear();
}
