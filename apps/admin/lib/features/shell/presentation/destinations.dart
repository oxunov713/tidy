import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';

enum AdminDestination {
  bookings('/bookings', Icons.event_note_outlined, Icons.event_note),
  cleaners('/cleaners', Icons.groups_outlined, Icons.groups),
  services('/services', Icons.sell_outlined, Icons.sell);

  const AdminDestination(this.path, this.icon, this.selectedIcon);

  final String path;
  final IconData icon;
  final IconData selectedIcon;

  String label(AppLocalizations l10n) => switch (this) {
    bookings => l10n.navBookings,
    cleaners => l10n.navCleaners,
    services => l10n.navServices,
  };

  /// The destination a location like `/bookings/42` belongs to.
  static AdminDestination fromLocation(String location) => values.firstWhere(
    (d) => location == d.path || location.startsWith('${d.path}/'),
    orElse: () => bookings,
  );
}
