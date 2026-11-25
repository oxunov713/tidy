import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

StatusLabels statusLabels(AppLocalizations l10n) => StatusLabels(
  pending: l10n.statusPending,
  confirmed: l10n.statusConfirmed,
  assigned: l10n.statusAssigned,
  onTheWay: l10n.statusOnTheWay,
  inProgress: l10n.statusInProgress,
  completed: l10n.statusCompleted,
  cancelled: l10n.statusCancelled,
);

String statusLabel(AppLocalizations l10n, BookingStatus status) =>
    statusLabels(l10n).of(status);

String frequencyLabel(AppLocalizations l10n, Frequency frequency) =>
    switch (frequency) {
      Frequency.once => l10n.frequencyOnce,
      Frequency.weekly => l10n.frequencyWeekly,
      Frequency.fortnightly => l10n.frequencyFortnightly,
    };
