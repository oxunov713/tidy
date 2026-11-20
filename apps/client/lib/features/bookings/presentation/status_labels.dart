import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

extension BookingStatusLabels on BookingStatus {
  String label(AppLocalizations l10n) => switch (this) {
    BookingStatus.pending => l10n.statusPending,
    BookingStatus.confirmed => l10n.statusConfirmed,
    BookingStatus.assigned => l10n.statusAssigned,
    BookingStatus.onTheWay => l10n.statusOnTheWay,
    BookingStatus.inProgress => l10n.statusInProgress,
    BookingStatus.completed => l10n.statusCompleted,
    BookingStatus.cancelled => l10n.statusCancelled,
  };

  TidyStatus get tidyStatus => TidyStatus.fromWire(wireName);

  /// Pending, confirmed and assigned bookings can still be cancelled.
  bool get isCancellable =>
      this == BookingStatus.pending ||
      this == BookingStatus.confirmed ||
      this == BookingStatus.assigned;

  /// A cleaner has been assigned and the visit is not over.
  bool get isTrackable =>
      this == BookingStatus.assigned ||
      this == BookingStatus.onTheWay ||
      this == BookingStatus.inProgress;
}
