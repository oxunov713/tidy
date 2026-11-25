import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/payment_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// The server cancels a booking that stays unpaid for this long once the
/// client was asked to pay.
const unpaidBookingTimeout = Duration(minutes: 30);

/// The server tries the saved card this long before the visit; a booking
/// still pending inside that window is waiting for the customer.
const _authorisationLead = Duration(hours: 48);

/// Whether to tell the customer that a pending booking is about to be
/// cancelled if it is not paid.
///
/// A booking with a saved card waiting for its 48 hour charge does not time
/// out, so the warning is only right when the payment was asked for recently
/// (a new booking) or the charge window has begun (the saved card was
/// declined, or the visit is close).
bool unpaidBookingExpires(Booking booking, DateTime now) =>
    booking.status == BookingStatus.pending &&
    (now.difference(booking.createdAt) <= unpaidBookingTimeout ||
        booking.start.difference(now) <= _authorisationLead);

/// "Pay now" for a booking that is still pending: asks the server for a new
/// payment and collects it in the payment sheet. Returns true when paid.
///
/// A declined card does not cancel the booking: the sheet reports it and
/// stays open for another try, and a closed sheet leaves the booking pending.
Future<bool> payForBooking(
  BuildContext context,
  WidgetRef ref,
  Booking booking,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    final intent = await ref.read(bookingRepositoryProvider).pay(booking.id);
    if (!context.mounted) return false;
    final outcome = await ref
        .read(paymentSheetProvider)
        .present(
          context,
          PaymentRequest(
            clientSecret: intent.clientSecret,
            amountPence: booking.total,
            bookingCode: booking.code,
            kind: intent.kind,
          ),
        );
    if (outcome != PaymentOutcome.paid) return false;
    ref
      ..invalidate(bookingsListProvider(BookingScope.upcoming))
      ..invalidate(bookingsListProvider(BookingScope.past))
      ..invalidate(bookingDetailsProvider(booking.id));
    return true;
  } on PaymentFailure catch (failure) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          failure.message.isEmpty ? l10n.paymentFailed : failure.message,
        ),
      ),
    );
    return false;
  } on Object catch (e) {
    if (context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
    }
    return false;
  }
}
