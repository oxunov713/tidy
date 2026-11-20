import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

String statusLabel(AppLocalizations l10n, BookingStatus status) =>
    switch (status) {
      BookingStatus.pending => l10n.statusPending,
      BookingStatus.confirmed => l10n.statusConfirmed,
      BookingStatus.assigned => l10n.statusAssigned,
      BookingStatus.onTheWay => l10n.statusOnTheWay,
      BookingStatus.inProgress => l10n.statusInProgress,
      BookingStatus.completed => l10n.statusCompleted,
      BookingStatus.cancelled => l10n.statusCancelled,
    };

String frequencyLabel(AppLocalizations l10n, Frequency frequency) =>
    switch (frequency) {
      Frequency.once => l10n.frequencyOnce,
      Frequency.weekly => l10n.frequencyWeekly,
      Frequency.fortnightly => l10n.frequencyFortnightly,
    };
