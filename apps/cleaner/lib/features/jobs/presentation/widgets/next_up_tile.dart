import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// One upcoming job: start time, client and place, payout.
class NextUpTile extends StatelessWidget {
  const NextUpTile({
    required this.job,
    required this.now,
    required this.onTap,
    super.key,
  });

  final Job job;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final booking = job.booking;
    final start = booking.start.toLocal();
    final dayLabel = Fmt.sameDay(start, now)
        ? l10n.todayLower
        : Fmt.sameDay(start, now.add(const Duration(days: 1)))
        ? l10n.tomorrowLower
        : Fmt.shortDate(booking.start, locale);

    return TidyCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Text(
                  Fmt.time(booking.start, locale),
                  style: text.titleLarge?.copyWith(fontSize: 18),
                ),
                Text(
                  dayLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(color: TidyColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 36, color: TidyColors.line),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${job.clientName} · ${booking.serviceTitle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  '${job.address.line1} · '
                  '${l10n.payoutAmount(Fmt.payout(booking.cleanerPayout))}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall?.copyWith(
                    fontSize: 13,
                    color: TidyColors.muted,
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

/// Jobs the Next up list shows, soonest first.
List<Job> nextUp(List<Job> jobs, DateTime now) {
  final open = jobs.where(
    (j) => switch (j.booking.status) {
      BookingStatus.onTheWay || BookingStatus.inProgress => true,
      BookingStatus.assigned => j.booking.end.isAfter(now),
      _ => false,
    },
  );
  return open.toList()
    ..sort((a, b) => a.booking.start.compareTo(b.booking.start));
}
