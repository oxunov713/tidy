import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_admin/core/labels.dart';
import 'package:tidy_admin/core/responsive.dart';
import 'package:tidy_admin/core/widgets/error_view.dart';
import 'package:tidy_admin/core/widgets/skeleton.dart';
import 'package:tidy_admin/features/bookings/presentation/booking_actions.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// One booking: summary, customer, address, cleaner, price, the events
/// timeline and the admin actions. Shown beside the list ([panel]) or as a
/// page of its own on narrower screens.
class BookingDetailView extends ConsumerWidget {
  const BookingDetailView({
    required this.id,
    required this.onClose,
    this.panel = false,
    super.key,
  });

  final String id;
  final VoidCallback onClose;
  final bool panel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final details = ref.watch(bookingDetailControllerProvider(id));

    final Widget body;
    if (details.hasError && !details.isLoading) {
      body = ErrorView(
        error: details.error!,
        onRetry: () => ref.invalidate(bookingDetailControllerProvider(id)),
      );
    } else if (details.value == null) {
      body = const _DetailSkeleton();
    } else {
      body = _DetailBody(id: id, details: details.value!);
    }

    final header = Row(
      children: [
        IconButton(
          tooltip: panel ? l10n.close : l10n.back,
          onPressed: onClose,
          icon: Icon(panel ? Icons.close : Icons.arrow_back),
        ),
        Expanded(
          child: Text(
            details.value?.booking.code ?? l10n.bookingDetails,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (details.value != null)
          StatusBadge.fromWire(
            details.value!.booking.status.wireName,
            label: statusLabel(l10n, details.value!.booking.status),
          ),
      ],
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        const SizedBox(height: TidySpacing.md),
        body,
      ],
    );

    if (panel) {
      return SingleChildScrollView(
        child: TidyCard(
          child: content,
        ),
      );
    }
    return ListView(
      padding: pagePadding(context),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: TidyCard(
              child: content,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.id, required this.details});

  final String id;
  final BookingDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final booking = details.booking;
    final address = details.address;
    final cleaner = details.cleaner;

    // The customer's name is on the list row, not in the booking itself.
    final row = ref
        .watch(bookingsControllerProvider)
        .value
        ?.items
        .where((r) => r.booking.id == id)
        .firstOrNull;

    final addressLines = [
      address.line1,
      if (address.line2.isNotEmpty) address.line2,
      '${address.city} ${address.postcode}',
    ].join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Section(
          title: l10n.sectionVisit,
          children: [
            _Field(l10n.fieldService, booking.serviceTitle),
            _Field(
              l10n.fieldWhen,
              '${formatDateTime(context, booking.start)} – ${formatTime(context, booking.end)}',
            ),
            _Field(
              l10n.fieldRooms,
              l10n.roomsValue(booking.bedrooms, booking.bathrooms),
            ),
            _Field(
              l10n.fieldFrequency,
              frequencyLabel(l10n, booking.frequency),
            ),
            for (final extra in booking.extras)
              _Field(extra.title, PriceText.format(extra.price)),
          ],
        ),
        if (row != null)
          _Section(
            title: l10n.sectionCustomer,
            children: [
              _Field(
                l10n.fieldName,
                nameOrPhone(row.clientName, row.clientPhone),
              ),
              _Field(l10n.fieldPhone, row.clientPhone),
            ],
          ),
        _Section(
          title: l10n.sectionAddress,
          children: [
            Text(addressLines),
            if (address.accessNotes.isNotEmpty) ...[
              const SizedBox(height: TidySpacing.xs),
              Text(
                address.accessNotes,
                style: const TextStyle(color: TidyColors.muted),
              ),
            ],
          ],
        ),
        _Section(
          title: l10n.sectionCleaner,
          children: [
            if (cleaner == null)
              Text(
                l10n.notAssigned,
                style: const TextStyle(color: TidyColors.muted),
              )
            else
              Row(
                children: [
                  Avatar(
                    name: cleaner.fullName,
                    imageUrl: cleaner.avatarUrl,
                    size: 40,
                  ),
                  const SizedBox(width: TidySpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameOrPhone(cleaner.fullName, '—'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          l10n.ratingSummary(
                            cleaner.rating.toStringAsFixed(1),
                            cleaner.ratingCount,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: TidyColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        _Section(
          title: l10n.sectionPayment,
          children: [
            _Field(l10n.fieldSubtotal, PriceText.format(booking.subtotal)),
            if (booking.discount != 0)
              _Field(
                l10n.fieldDiscount,
                PriceText.format(-booking.discount.abs()),
              ),
            _Field(
              l10n.fieldTotal,
              PriceText.format(booking.total),
              bold: true,
            ),
            _Field(
              l10n.fieldCleanerPayout,
              PriceText.format(booking.cleanerPayout),
            ),
          ],
        ),
        if (details.review != null)
          _Section(
            title: l10n.sectionReview,
            children: [
              Text(l10n.reviewRating(details.review!.rating)),
              if (details.review!.comment.isNotEmpty)
                Text(
                  details.review!.comment,
                  style: const TextStyle(color: TidyColors.muted),
                ),
            ],
          ),
        _Section(
          title: l10n.sectionTimeline,
          children: [_Timeline(events: details.events)],
        ),
        // The server refuses a reassign or a cancel in any other status with
        // 409 invalid_transition, so those buttons only show where it works.
        if (booking.status.canReassign || booking.status.canCancel)
          const SizedBox(height: TidySpacing.sm),
        if (booking.status.canReassign)
          TidyButton(
            label: booking.cleanerId == null
                ? l10n.assignCleaner
                : l10n.reassignCleaner,
            icon: Icons.swap_horiz,
            variant: TidyButtonVariant.secondary,
            onPressed: () => showReassignDialog(
              context,
              bookingId: id,
              currentCleanerId: booking.cleanerId,
            ),
          ),
        if (booking.status.canReassign && booking.status.canCancel)
          const SizedBox(height: TidySpacing.sm),
        if (booking.status.canCancel)
          TidyButton(
            label: l10n.cancelBooking,
            icon: Icons.event_busy_outlined,
            variant: TidyButtonVariant.ghost,
            onPressed: () => showCancelBookingDialog(
              context,
              bookingId: id,
              code: booking.code,
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TidySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: TidyColors.muted,
            ),
          ),
          const SizedBox(height: TidySpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: TidyColors.muted)),
          ),
          const SizedBox(width: TidySpacing.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
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
    if (events.isEmpty) {
      return Text(
        l10n.timelineEmpty,
        style: const TextStyle(color: TidyColors.muted),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < events.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 20,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == events.length - 1
                              ? TidyColors.primary
                              : TidyColors.line,
                        ),
                      ),
                      if (i != events.length - 1)
                        const Expanded(
                          child: VerticalDivider(width: 1, thickness: 1),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: TidySpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            statusLabel(l10n, events[i].status),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          formatDateTime(context, events[i].at),
                          style: const TextStyle(
                            fontSize: 13,
                            color: TidyColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: 90, height: 12),
          SizedBox(height: 12),
          Skeleton(),
          SizedBox(height: 8),
          Skeleton(),
          SizedBox(height: 8),
          Skeleton(width: 180),
          SizedBox(height: 28),
          Skeleton(width: 90, height: 12),
          SizedBox(height: 12),
          Skeleton(),
          SizedBox(height: 8),
          Skeleton(width: 140),
        ],
      ),
    );
  }
}
