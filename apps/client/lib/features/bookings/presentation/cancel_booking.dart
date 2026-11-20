import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/providers/clock.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Cancellation is free until this long before the start.
const freeCancellationWindow = Duration(hours: 24);

/// Asks for confirmation, cancels, and tells the user whether they were
/// refunded or charged. Returns true when the booking was cancelled.
Future<bool> cancelBooking(
  BuildContext context,
  WidgetRef ref,
  Booking booking,
) async {
  final l10n = AppLocalizations.of(context);
  final now = ref.read(clockProvider)();
  final isFree = booking.start.difference(now) > freeCancellationWindow;
  final price = PriceText.format(booking.total);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.cancelBookingTitle),
      content: Text(
        isFree ? l10n.cancelFreeBody : l10n.cancelLateBody(price),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.keepBooking),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
          child: Text(l10n.cancelBooking),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  final messenger = ScaffoldMessenger.of(context);
  try {
    final result = await ref.read(bookingRepositoryProvider).cancel(booking.id);
    ref
      ..invalidate(bookingsListProvider(BookingScope.upcoming))
      ..invalidate(bookingsListProvider(BookingScope.past))
      ..invalidate(bookingDetailsProvider(booking.id));
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.refunded
              ? l10n.cancelledRefunded(price)
              : l10n.cancelledCharged(price),
        ),
      ),
    );
    return true;
  } on Object catch (e) {
    if (context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
    }
    return false;
  }
}
