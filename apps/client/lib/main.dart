import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_client/app.dart';
import 'package:tidy_client/core/providers/preferences.dart';
import 'package:tidy_client/features/payment/presentation/payment_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  if (stripePublishableKey.isNotEmpty) {
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.applySettings();
  }
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // A failed provider should show its error and wait for the user's retry
      // button, not hit the API again on its own.
      retry: (_, _) => null,
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const TidyClientApp(),
    ),
  );
}
