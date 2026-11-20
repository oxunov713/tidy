import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/bookings/presentation/status_labels.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// One row of the bookings list: service, status, when, who, price and the
/// actions that make sense for the status.
class BookingCard extends ConsumerWidget {
  const BookingCard({
    required this.booking,
    required this.onOpen,
    required this.onTrack,
    required this.onRate,
    required this.onBookAgain,
    required this.onCancel,
    super.key,
  });

  final Booking booking;
  final VoidCallback onOpen;
  final VoidCallback onTrack;
  final VoidCallback onRate;
  final VoidCallback onBookAgain;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final now = ref.watch(clockProvider)();

    // The list does not carry the cleaner's name, so it is fetched per card as
    // it scrolls into view and cached.
    final cleaner = booking.cleanerId == null
        ? null
        : ref.watch(bookingDetailsProvider(booking.id)).value?.cleaner;
    final who = cleaner != null
        ? cleaner.fullName
        : booking.cleanerId != null
        ? '…'
        : (booking.status.isCancellable ? l10n.findingCleaner : l10n.noCleaner);

    final when = isSameDay(booking.start, now)
        ? l10n.todayAt(formatClock(booking.start))
        : '${formatDayShort(booking.start, locale)} · ${formatClock(booking.start)}';

    final (primaryLabel, primaryAction) = switch (booking.status) {
      BookingStatus.assigned ||
      BookingStatus.onTheWay ||
      BookingStatus.inProgress => (l10n.track, onTrack),
      BookingStatus.completed => (l10n.rate, onRate),
      BookingStatus.cancelled => (l10n.bookAgain, onBookAgain),
      BookingStatus.pending || BookingStatus.confirmed => (
        l10n.details,
        onOpen,
      ),
    };
    final showBookAgain = booking.status == BookingStatus.completed;
    final showCancel = booking.status.isCancellable;

    return TidyCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.serviceTitle,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
              ),
              StatusBadge(
                status: booking.status.tidyStatus,
                label: booking.status.label(l10n),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DefaultTextStyle.merge(
            style: text.bodySmall?.copyWith(
              color: TidyColors.muted,
              fontSize: 13,
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text(when),
                Text(who),
                if (booking.frequency != Frequency.once)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.repeat, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        booking.frequency == Frequency.weekly
                            ? l10n.frequencyWeekly
                            : l10n.frequencyFortnightly,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PriceText(
                booking.total,
                style: text.titleLarge?.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 8),
              // Wraps instead of overflowing when labels are long (Russian,
              // large text sizes).
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (showCancel)
                      TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: TidyColors.danger,
                        ),
                        child: Text(l10n.cancel),
                      ),
                    if (showBookAgain)
                      TextButton(
                        onPressed: onBookAgain,
                        child: Text(l10n.bookAgain),
                      ),
                    _ActionButton(
                      label: primaryLabel,
                      onPressed: primaryAction,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: TidyColors.primarySoft,
        foregroundColor: TidyColors.primary,
        minimumSize: const Size(64, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}

class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 140, height: 18),
          SizedBox(height: 14),
          SkeletonBox(width: 200, height: 14),
          SizedBox(height: 14),
          SkeletonBox(width: 80, height: 22),
        ],
      ),
    );
  }
}
