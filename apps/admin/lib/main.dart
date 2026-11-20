import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tidy_admin/app.dart';

void main() {
  runApp(
    // A failed request should show its error at once, not retry in silence.
    ProviderScope(retry: (_, _) => null, child: const TidyAdminApp()),
  );
}
