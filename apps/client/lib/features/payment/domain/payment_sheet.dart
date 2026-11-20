import 'package:material_ui/material_ui.dart';

/// What the sheet needs to collect a payment for a booking that was just
/// created.
class PaymentRequest {
  const PaymentRequest({
    required this.clientSecret,
    required this.amountPence,
    required this.bookingCode,
  });

  /// From `POST /bookings`. A placeholder in mock mode.
  final String clientSecret;
  final int amountPence;
  final String bookingCode;
}

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
  /// throws [PaymentFailure] when the payment is rejected.
  Future<PaymentOutcome> present(BuildContext context, PaymentRequest request);

  /// Whether payments are real (Stripe test or live) or simulated.
  bool get isMock;
}
