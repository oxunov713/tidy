import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/mock_payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/stripe_payment_sheet.dart';

part 'payment_providers.g.dart';

/// Set with `--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...` to use Stripe.
const stripePublishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');

@Riverpod(keepAlive: true)
PaymentSheet paymentSheet(Ref ref) => stripePublishableKey.isEmpty
    ? const MockPaymentSheet()
    : const StripePaymentSheet();
