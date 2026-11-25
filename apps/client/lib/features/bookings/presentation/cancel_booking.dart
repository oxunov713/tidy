import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/plans/presentation/plans_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Cancellation is free until this long before the start.
const freeCancellationWindow = Duration(hours: 24);

/// Asks for confirmation, cancels, and tells the user whether they were
/// refunded or charged. Returns true when the booking was cancelled.
Future<bool> cancelBooking(
  BuildContext context,
  WidgetRef ref,
  Booking booking,
) async {
  final l10n = AppLocalizations.of(context);
  final now = ref.read(clockProvider)();
  final isFree = booking.start.difference(now) > freeCancellationWindow;
  final price = PriceText.format(booking.total);

  final scope = await showDialog<CancelScope>(
    context: context,
    builder: (context) => _CancelDialog(
      body: isFree ? l10n.cancelFreeBody : l10n.cancelLateBody(price),
      recurring: booking.planId != null,
    ),
  );
  if (scope == null || !context.mounted) return false;

  final messenger = ScaffoldMessenger.of(context);
  try {
    final result = await ref
        .read(bookingRepositoryProvider)
        .cancel(booking.id, scope: scope);
    ref
      ..invalidate(bookingsListProvider(BookingScope.upcoming))
      ..invalidate(bookingsListProvider(BookingScope.past))
      ..invalidate(bookingDetailsProvider(booking.id))
      ..invalidate(plansProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          [
            if (result.refunded)
              l10n.cancelledRefunded(price)
            else
              l10n.cancelledCharged(price),
            if (result.planEnded) l10n.cancelledSeriesEnded,
          ].join(' '),
        ),
      ),
    );
    return true;
  } on Object catch (e) {
    if (context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
    }
    return false;
  }
}

/// Confirms a cancellation. A booking that belongs to a recurring plan also
/// asks whether to cancel only this visit or the whole series. Pops the
/// chosen [CancelScope], or null when the user keeps the booking.
class _CancelDialog extends StatefulWidget {
  const _CancelDialog({required this.body, required this.recurring});

  final String body;
  final bool recurring;

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  CancelScope _scope = CancelScope.visit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.cancelBookingTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.body),
            if (widget.recurring) ...[
              const SizedBox(height: 16),
              Text(
                l10n.cancelScopeTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              RadioGroup<CancelScope>(
                groupValue: _scope,
                onChanged: (value) =>
                    setState(() => _scope = value ?? CancelScope.visit),
                child: Column(
                  children: [
                    RadioListTile<CancelScope>(
                      key: const Key('cancelScopeVisit'),
                      contentPadding: EdgeInsets.zero,
                      value: CancelScope.visit,
                      title: Text(l10n.cancelThisVisit),
                    ),
                    RadioListTile<CancelScope>(
                      key: const Key('cancelScopeSeries'),
                      contentPadding: EdgeInsets.zero,
                      value: CancelScope.series,
                      title: Text(l10n.cancelWholeSeries),
                    ),
                  ],
                ),
              ),
              if (_scope == CancelScope.series)
                Text(
                  l10n.cancelSeriesHint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TidyColors.muted,
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.keepBooking),
        ),
        TextButton(
          key: const Key('confirmCancel'),
          onPressed: () => Navigator.pop(context, _scope),
          style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
          child: Text(l10n.cancelBooking),
        ),
      ],
    );
  }
}
