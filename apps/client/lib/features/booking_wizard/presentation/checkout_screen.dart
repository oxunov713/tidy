import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/providers/map_factory.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/wizard_header.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_client/features/booking_wizard/presentation/last_cleaner_provider.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/wizard_bottom_bar.dart';
import 'package:tidy_client/features/payment/domain/payment_sheet.dart';
import 'package:tidy_client/features/payment/presentation/payment_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Step 3: address, access notes, price breakdown and payment.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final TextEditingController _notes = TextEditingController(
    text: ref.read(bookingWizardProvider).accessNotes,
  );

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _changeAddress() async {
    await context.push('${Routes.addresses}?pick=1');
    if (!mounted) return;
    final chosen = ref.read(currentAddressProvider);
    if (chosen == null) return;
    ref.read(bookingWizardProvider.notifier).setAddress(chosen);
    _notes.text = chosen.accessNotes;
  }

  void _snack(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _book() async {
    final l10n = AppLocalizations.of(context);
    final result = await ref.read(bookingWizardProvider.notifier).submit();
    if (!mounted) return;

    switch (result) {
      case BookingSlotTaken():
        // The wizard already refreshed the times; Schedule shows them.
        _snack(l10n.slotTakenSnack);
        context.pop();
      case BookingSubmitFailed(:final error):
        _snack(errorMessage(context, error));
      case BookingSubmitted(:final created):
        await _pay(created);
    }
  }

  Future<void> _pay(BookingCreated created) async {
    final l10n = AppLocalizations.of(context);
    final booking = created.booking;
    final PaymentOutcome outcome;
    try {
      outcome = await ref
          .read(paymentSheetProvider)
          .present(
            context,
            PaymentRequest(
              clientSecret: created.payment.clientSecret,
              amountPence: booking.total,
              bookingCode: booking.code,
              kind: created.payment.kind,
            ),
          );
    } on PaymentFailure catch (failure) {
      if (!mounted) return;
      _snack(failure.message.isEmpty ? l10n.paymentFailed : failure.message);
      context.go(Routes.bookings);
      return;
    }
    if (!mounted) return;

    switch (outcome) {
      case PaymentOutcome.paid when created.payment.kind == PaymentKind.setup:
        // The card is saved; the booking stays pending until it is charged,
        // 48 hours before the visit.
        _snack(l10n.cardSaved);
        context.go(Routes.bookings);
      case PaymentOutcome.paid:
        context.go(Routes.home);
        unawaited(context.push(Routes.track(booking.id)));
      case PaymentOutcome.cancelled:
        // The booking exists but is unpaid; it shows up as pending.
        _snack(l10n.paymentCancelled);
        context.go(Routes.bookings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(bookingWizardProvider);
    final quote = state.quote;
    final address = state.address;

    return Scaffold(
      body: Column(
        children: [
          WizardHeader(
            step: 3,
            title: l10n.confirmAndPay,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              children: [
                if (address != null)
                  _AddressCard(
                    address: address,
                    notes: _notes,
                    onNotesChanged: ref
                        .read(bookingWizardProvider.notifier)
                        .setAccessNotes,
                    onChange: _changeAddress,
                  ),
                const SizedBox(height: 14),
                if (quote != null) _SummaryCard(state: state, quote: quote),
                const SizedBox(height: 14),
                const _PaymentCard(),
              ],
            ),
          ),
          WizardBottomBar(
            child: SizedBox(
              height: 56,
              child: TidyButton(
                label: quote == null
                    ? l10n.book
                    : l10n.bookFor(PriceText.format(quote.total)),
                isLoading: state.submitting,
                onPressed: state.canCheckout ? _book : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: TidyColors.white,
        borderRadius: TidyRadii.cardBorder,
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({
    required this.address,
    required this.notes,
    required this.onNotesChanged,
    required this.onChange,
  });

  final Address address;
  final TextEditingController notes;
  final ValueChanged<String> onNotesChanged;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final map = ref.watch(mapFactoryProvider)(zoom: 16);
    final point = GeoPoint(lat: address.lat, lng: address.lng);
    final line = [
      address.line1,
      if (address.line2.isNotEmpty) address.line2,
    ].join(', ');

    return ClipRRect(
      borderRadius: TidyRadii.cardBorder,
      child: ColoredBox(
        color: TidyColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              // A preview only: panning it would fight with the list scroll.
              child: IgnorePointer(
                child: map.buildMap(
                  center: point,
                  markers: [MapMarker(id: 'home', position: point)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line,
                              style: text.titleSmall?.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${address.city} ${address.postcode}',
                              style: text.bodySmall?.copyWith(
                                color: TidyColors.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: onChange,
                        child: Text(l10n.change),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.accessNotes,
                    style: text.labelLarge?.copyWith(color: TidyColors.muted),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notes,
                    onChanged: onNotesChanged,
                    textInputAction: TextInputAction.done,
                    style: text.bodyMedium,
                    decoration: InputDecoration(
                      hintText: l10n.accessNotesHint,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.state, required this.quote});

  final BookingWizardState state;
  final Quote quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final slot = state.slot;
    final lastCleaner = ref.watch(lastCleanerProvider).value;
    final cleanerName = lastCleaner != null && lastCleaner.id == state.cleanerId
        ? lastCleaner.fullName
        : l10n.anyCleaner;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.summary, style: text.titleSmall?.copyWith(fontSize: 15)),
          const SizedBox(height: 10),
          for (final line in quote.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      line.label,
                      style: text.bodyMedium?.copyWith(
                        color: line.amount < 0 ? TidyColors.primary : null,
                        fontWeight: line.amount < 0 ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                  PriceText(
                    line.amount,
                    style: text.bodyMedium?.copyWith(
                      color: line.amount < 0 ? TidyColors.primary : null,
                      fontWeight: line.amount < 0 ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
          if (slot != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${TidyDates.dayShort(slot, locale)} · ${TidyDates.clock(slot)}',
                    style: text.bodyMedium?.copyWith(color: TidyColors.muted),
                  ),
                ),
                Text(
                  cleanerName,
                  style: text.bodyMedium?.copyWith(color: TidyColors.muted),
                ),
              ],
            ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text(l10n.total, style: text.titleSmall)),
              PriceText(
                quote.total,
                style: text.titleLarge?.copyWith(fontSize: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends ConsumerWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final isMock = ref.watch(paymentSheetProvider).isMock;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.payment, style: text.titleSmall?.copyWith(fontSize: 15)),
          const SizedBox(height: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: TidyColors.primary, width: 2),
              borderRadius: TidyRadii.controlBorder,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: TidyColors.ink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CARD',
                      style: TextStyle(
                        color: TidyColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMock ? '•••• 4242' : l10n.payByCard,
                          style: text.titleSmall?.copyWith(fontSize: 14),
                        ),
                        Text(
                          isMock ? l10n.testMode : l10n.securePaymentStripe,
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check, color: TidyColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 14, color: TidyColors.muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.chargedAfterClean,
                  style: text.bodySmall?.copyWith(color: TidyColors.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
