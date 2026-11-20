import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "Sarah is on the way", shown on Home while a booking is under way. Taps
/// open live tracking.
class CurrentBookingCard extends ConsumerWidget {
  const CurrentBookingCard({required this.booking, super.key});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final cleaner = ref
        .watch(bookingDetailsProvider(booking.id))
        .value
        ?.cleaner;
    final firstName = cleaner?.fullName.split(' ').first;

    final title = switch ((booking.status, firstName)) {
      (BookingStatus.onTheWay, final String name) => l10n.cleanerOnTheWay(name),
      (BookingStatus.inProgress, final String name) => l10n.cleanerCleaning(
        name,
      ),
      (BookingStatus.onTheWay, _) => l10n.yourCleanerOnTheWay,
      (BookingStatus.inProgress, _) => l10n.yourCleanerCleaning,
      (_, final String name) => l10n.cleanerBooked(name),
      _ => l10n.yourCleanerBooked,
    };

    return TidyCard(
      onTap: () => context.push(Routes.track(booking.id)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CleanerAvatar(
            name: cleaner?.fullName ?? '',
            imageUrl: cleaner?.avatarUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleSmall?.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  '${booking.serviceTitle} · ${formatClock(booking.start)}',
                  style: text.bodySmall?.copyWith(
                    color: TidyColors.muted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: TidyColors.muted),
        ],
      ),
    );
  }
}
