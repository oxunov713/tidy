import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tidy_admin/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dates are printed in ru and uz too, which need their symbols loaded.
  await initializeDateFormatting();
  runApp(
    // A failed request should show its error at once, not retry in silence.
    ProviderScope(retry: (_, _) => null, child: const TidyAdminApp()),
  );
}
