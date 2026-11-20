import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Stripe's own payment sheet, driven by the intent's client secret.
///
/// Needs `Stripe.publishableKey` set before use; `main` does that when
/// `STRIPE_PUBLISHABLE_KEY` is defined.
class StripePaymentSheet implements PaymentSheet {
  const StripePaymentSheet();

  @override
  bool get isMock => false;

  @override
  Future<PaymentOutcome> present(
    BuildContext context,
    PaymentRequest request,
  ) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: request.clientSecret,
          merchantDisplayName: 'Tidy',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(primary: TidyColors.primary),
          ),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return PaymentOutcome.paid;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentOutcome.cancelled;
      }
      throw PaymentFailure(e.error.localizedMessage ?? e.error.message ?? '');
    }
  }
}
