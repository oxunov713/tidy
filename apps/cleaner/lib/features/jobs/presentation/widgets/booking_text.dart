import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// "3 bed · 2 bath · inside fridge"
String bookingSummary(AppLocalizations l10n, Booking booking) => [
  l10n.bedBath(booking.bedrooms, booking.bathrooms),
  for (final extra in booking.extras) extra.title.toLowerCase(),
].join(' · ');

/// Statuses that still need the cleaner's attention.
bool isOpenJob(Booking booking) => switch (booking.status) {
  BookingStatus.assigned ||
  BookingStatus.onTheWay ||
  BookingStatus.inProgress => true,
  _ => false,
};
