import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/bookings/presentation/book_again.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/bookings/presentation/cancel_booking.dart';
import 'package:tidy_client/features/bookings/presentation/status_labels.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Everything about one booking: status, cleaner, address, price lines, the
/// event timeline and the actions that apply.
class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final details = ref.watch(bookingDetailsProvider(bookingId));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.chevron_left,
                    tooltip: l10n.back,
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      details.value == null
                          ? l10n.bookingDetails
                          : l10n.bookingNumber(details.value!.booking.code),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncValueView<BookingDetails>(
                value: details,
                onRetry: () =>
                    ref.invalidate(bookingDetailsProvider(bookingId)),
                loading: (_) => const Shimmer(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SkeletonBox(height: 110, radius: 20),
                        SizedBox(height: 14),
                        SkeletonBox(height: 90, radius: 20),
                        SizedBox(height: 14),
                        SkeletonBox(height: 160, radius: 20),
                      ],
                    ),
                  ),
                ),
                data: (d) => _Content(details: d),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.details});

  final BookingDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final booking = details.booking;
    final cleaner = details.cleaner;
    final address = details.address;
    final extrasTotal = booking.extras.fold<int>(0, (sum, e) => sum + e.price);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(bookingDetailsProvider(booking.id).future),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          TidyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.serviceTitle,
                        style: text.titleLarge,
                      ),
                    ),
                    StatusBadge(
                      status: booking.status.tidyStatus,
                      label: booking.status.label(l10n),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.event_outlined,
                  text:
                      '${TidyDates.dayLong(booking.start, locale)} · ${TidyDates.clock(booking.start)}–${TidyDates.clock(booking.end)}',
                ),
                _InfoRow(
                  icon: Icons.bed_outlined,
                  text: l10n.roomsSummary(booking.bedrooms, booking.bathrooms),
                ),
                if (booking.frequency != Frequency.once)
                  _InfoRow(
                    icon: Icons.repeat,
                    text: booking.frequency == Frequency.weekly
                        ? l10n.frequencyWeekly
                        : l10n.frequencyFortnightly,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (cleaner != null) ...[
            TidyCard(
              child: Row(
                children: [
                  CleanerAvatar(
                    name: cleaner.fullName,
                    imageUrl: cleaner.avatarUrl,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cleaner.fullName,
                          style: text.titleSmall?.copyWith(fontSize: 15),
                        ),
                        Text(
                          l10n.ratingAndReviews(
                            cleaner.rating.toStringAsFixed(1),
                            cleaner.ratingCount,
                          ),
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (booking.status != BookingStatus.cancelled)
                    RoundIconButton(
                      icon: Icons.chat_bubble_outline,
                      tooltip: l10n.messageCleaner(cleaner.fullName),
                      onPressed: () =>
                          context.push(Routes.bookingChat(booking.id)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          TidyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: [
                    address.line1,
                    if (address.line2.isNotEmpty) address.line2,
                    '${address.city} ${address.postcode}',
                  ].join(', '),
                ),
                if (address.accessNotes.isNotEmpty)
                  _InfoRow(
                    icon: Icons.key_outlined,
                    text: address.accessNotes,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TidyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.summary, style: text.titleSmall),
                const SizedBox(height: 10),
                _PriceRow(
                  label:
                      '${booking.serviceTitle} · ${l10n.roomsSummary(booking.bedrooms, booking.bathrooms)}',
                  pence: booking.subtotal - extrasTotal,
                ),
                for (final extra in booking.extras)
                  _PriceRow(label: extra.title, pence: extra.price),
                if (booking.discount > 0)
                  _PriceRow(
                    label: l10n.discount,
                    pence: -booking.discount,
                    highlight: true,
                  ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(child: Text(l10n.total, style: text.titleSmall)),
                    PriceText(
                      booking.total,
                      style: text.titleLarge?.copyWith(fontSize: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (details.review != null) ...[
            const SizedBox(height: 14),
            _ReviewCard(review: details.review!),
          ],
          const SizedBox(height: 14),
          _Timeline(events: details.events),
          const SizedBox(height: 20),
          _Actions(details: details),
        ],
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({required this.details});

  final BookingDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final booking = details.booking;
    final status = booking.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status.isTrackable)
          TidyButton(
            label: l10n.trackCleaner,
            icon: Icons.near_me_outlined,
            onPressed: () => context.push(Routes.track(booking.id)),
          ),
        if (status == BookingStatus.completed && details.review == null)
          TidyButton(
            label: l10n.rateYourClean,
            icon: Icons.star_outline,
            onPressed: () => context.push(Routes.review(booking.id)),
          ),
        if (status == BookingStatus.completed ||
            status == BookingStatus.cancelled) ...[
          const SizedBox(height: 10),
          TidyButton(
            label: l10n.bookAgain,
            icon: Icons.replay,
            variant: TidyButtonVariant.secondary,
            onPressed: () => bookAgain(context, ref, booking),
          ),
        ],
        if (status.canCancel) ...[
          const SizedBox(height: 10),
          TidyButton(
            label: l10n.cancelBooking,
            variant: TidyButtonVariant.ghost,
            onPressed: () async {
              final cancelled = await cancelBooking(context, ref, booking);
              if (cancelled && context.mounted) context.pop();
            },
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: TidyColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.pence,
    this.highlight = false,
  });

  final String label;
  final int pence;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: highlight ? TidyColors.primary : null,
      fontWeight: highlight ? FontWeight.w600 : null,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          PriceText(pence, style: style),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.yourReview, style: text.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: TidyColors.accent,
                  size: 22,
                ),
              if (review.tip > 0) ...[
                const Spacer(),
                Text(
                  l10n.tipAmount(PriceText.format(review.tip)),
                  style: text.bodySmall?.copyWith(color: TidyColors.muted),
                ),
              ],
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.comment, style: text.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.events});

  final List<BookingEvent> events;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    if (events.isEmpty) return const SizedBox.shrink();
    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.timeline, style: text.titleSmall),
          const SizedBox(height: 12),
          for (final (index, event) in events.indexed)
            _TimelineRow(
              label: event.status.label(l10n),
              time:
                  '${TidyDates.dayShort(event.at, locale)} · ${TidyDates.clock(event.at)}',
              isFirst: index == 0,
              isLast: index == events.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.time,
    required this.isFirst,
    required this.isLast,
  });

  final String label;
  final String time;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 6,
                  color: isFirst ? Colors.transparent : TidyColors.line,
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLast ? TidyColors.primary : TidyColors.line,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : TidyColors.line,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.titleSmall?.copyWith(fontSize: 14)),
                  Text(
                    time,
                    style: text.bodySmall?.copyWith(color: TidyColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
