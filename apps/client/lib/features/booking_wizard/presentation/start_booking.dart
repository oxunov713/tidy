import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_core/tidy_core.dart';

/// Resets the wizard for [service] and opens the first step. [from] repeats an
/// earlier booking.
Future<void> startBooking(
  BuildContext context,
  WidgetRef ref,
  Service service, {
  Booking? from,
}) {
  ref.read(bookingWizardProvider.notifier).start(service, from: from);
  return context.push(Routes.configure);
}
