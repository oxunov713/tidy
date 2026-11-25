import 'package:material_ui/material_ui.dart';
import 'package:tidy_core/tidy_core.dart';

/// What the sheet needs to collect a payment for a booking that was just
/// created.
class PaymentRequest {
  const PaymentRequest({
    required this.clientSecret,
    required this.amountPence,
    required this.bookingCode,
    this.kind = PaymentKind.payment,
  });

  /// From `POST /bookings`. A placeholder in mock mode.
  final String clientSecret;
  final int amountPence;
  final String bookingCode;

  /// [PaymentKind.payment] authorises the price now; [PaymentKind.setup] only
  /// saves the card, and it is charged 48 hours before the visit.
  final PaymentKind kind;
}

/// [paid] also means 'card saved' for a setup request.
enum PaymentOutcome { paid, cancelled }

/// The payment failed (card declined, network). [message] can be shown as is.
class PaymentFailure implements Exception {
  const PaymentFailure(this.message);

  final String message;

  @override
  String toString() => 'PaymentFailure: $message';
}

/// Collects the card details and confirms the payment. The checkout screen
/// only knows this interface; the mock and the Stripe implementation are
/// swapped with `--dart-define=STRIPE_PUBLISHABLE_KEY`.
abstract interface class PaymentSheet {
  /// Resolves to [PaymentOutcome.cancelled] when the user closes the sheet and
  /// throws [PaymentFailure] when the payment fails for a reason the sheet
  /// cannot show itself. A declined card is shown inside the sheet, which
  /// stays open so the customer can fix the details or try another card.
  Future<PaymentOutcome> present(BuildContext context, PaymentRequest request);

  /// Whether payments are real (Stripe test or live) or simulated.
  bool get isMock;
}
