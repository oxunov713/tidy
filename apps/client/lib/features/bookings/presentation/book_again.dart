import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/features/booking_wizard/presentation/start_booking.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// Opens the booking wizard with the same service, rooms, extras, frequency
/// and cleaner as [booking].
Future<void> bookAgain(
  BuildContext context,
  WidgetRef ref,
  Booking booking,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  try {
    final services = await ref.read(servicesProvider.future);
    final service = services
        .where((s) => s.id == booking.serviceId)
        .firstOrNull;
    if (!context.mounted) return;
    if (service == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.serviceUnavailable)));
      return;
    }
    await startBooking(context, ref, service, from: booking);
  } on Object catch (e) {
    if (context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
    }
  }
}
