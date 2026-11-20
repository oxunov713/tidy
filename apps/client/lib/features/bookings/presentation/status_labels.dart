import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

StatusLabels statusLabels(AppLocalizations l10n) => StatusLabels(
  pending: l10n.statusPending,
  confirmed: l10n.statusConfirmed,
  assigned: l10n.statusAssigned,
  onTheWay: l10n.statusOnTheWay,
  inProgress: l10n.statusInProgress,
  completed: l10n.statusCompleted,
  cancelled: l10n.statusCancelled,
);

extension BookingStatusLabels on BookingStatus {
  String label(AppLocalizations l10n) => statusLabels(l10n).of(this);

  TidyStatus get tidyStatus => TidyStatus.fromWire(wireName);
}
