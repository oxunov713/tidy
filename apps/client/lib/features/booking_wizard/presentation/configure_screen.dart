import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/core/widgets/wizard_header.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/count_stepper.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/frequency_picker.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/wizard_bottom_bar.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Step 1: size of the home, extras and how often. The price comes from the
/// server and refreshes (debounced) after every change.
class ConfigureScreen extends ConsumerWidget {
  const ConfigureScreen({super.key});

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    var address =
        ref.read(bookingWizardProvider).address ??
        ref.read(currentAddressProvider);
    if (address == null) {
      // Addresses may still be on their way; wait for them before deciding the
      // user has none.
      try {
        await ref.read(addressesProvider.future);
      } on Object {
        // Falls through to the add-address screen below.
      }
      address = ref.read(currentAddressProvider);
    }
    if (address == null) {
      if (!context.mounted) return;
      await context.push(Routes.addAddress);
      address = ref.read(currentAddressProvider);
      if (address == null) return;
    }
    ref.read(bookingWizardProvider.notifier).setAddress(address);
    if (context.mounted) unawaited(context.push(Routes.schedule));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(bookingWizardProvider);
    final wizard = ref.read(bookingWizardProvider.notifier);
    final service = state.service;

    if (service == null) {
      return Scaffold(
        body: EmptyState(
          title: l10n.chooseServiceFirst,
          actionLabel: l10n.navHome,
          onAction: () => context.go(Routes.home),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TidyColors.white,
      body: Column(
        children: [
          WizardHeader(
            step: 1,
            title: service.title,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _Section(
                  title: l10n.sizeOfHome,
                  child: Column(
                    children: [
                      _RoomRow(
                        label: l10n.bedrooms,
                        hint: l10n.bedroomsHint,
                        stepper: CountStepper(
                          value: state.bedrooms,
                          onChanged: wizard.setBedrooms,
                          decreaseLabel: l10n.removeBedroom,
                          increaseLabel: l10n.addBedroom,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _RoomRow(
                        label: l10n.bathrooms,
                        hint: l10n.bathroomsHint,
                        stepper: CountStepper(
                          value: state.bathrooms,
                          onChanged: wizard.setBathrooms,
                          decreaseLabel: l10n.removeBathroom,
                          increaseLabel: l10n.addBathroom,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _Section(title: l10n.extras, child: const _ExtrasChips()),
                const SizedBox(height: 22),
                _Section(
                  title: l10n.howOften,
                  child: FrequencyPicker(
                    selected: state.frequency,
                    onChanged: wizard.setFrequency,
                  ),
                ),
              ],
            ),
          ),
          WizardBottomBar(
            child: Row(
              children: [
                Expanded(
                  child: _Total(state: state, onRetry: wizard.retryQuote),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: TidyButton(
                      label: l10n.chooseTime,
                      onPressed: state.canChooseTime
                          ? () => _continue(context, ref)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({
    required this.label,
    required this.hint,
    required this.stepper,
  });

  final String label;
  final String hint;
  final Widget stepper;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: TidyColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.titleSmall?.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    hint,
                    style: text.bodySmall?.copyWith(
                      color: TidyColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            stepper,
          ],
        ),
      ),
    );
  }
}

class _ExtrasChips extends ConsumerWidget {
  const _ExtrasChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extras = ref.watch(extrasProvider);
    final selected = ref.watch(
      bookingWizardProvider.select((s) => s.extraIds),
    );
    final wizard = ref.read(bookingWizardProvider.notifier);
    return extras.when(
      skipLoadingOnReload: true,
      loading: () => const Shimmer(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SkeletonBox(width: 130, height: 40, radius: 20),
            SkeletonBox(width: 140, height: 40, radius: 20),
            SkeletonBox(width: 110, height: 40, radius: 20),
          ],
        ),
      ),
      error: (error, _) => Row(
        children: [
          Expanded(
            child: Text(
              errorMessage(context, error),
              style: const TextStyle(color: TidyColors.muted),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(extrasProvider),
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
      data: (list) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final extra in list)
            TidyChip(
              label: '${extra.title} · +${PriceText.format(extra.price)}',
              selected: selected.contains(extra.id),
              onSelected: (_) => wizard.toggleExtra(extra.id),
            ),
        ],
      ),
    );
  }
}

/// "Total · 2.5 h" and the price. The price is a shimmer while a new quote is
/// on its way.
class _Total extends StatelessWidget {
  const _Total({required this.state, required this.onRetry});

  final BookingWizardState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final quote = state.quote;

    final Widget price;
    if (state.quoteError != null && !state.quoteLoading) {
      return InkWell(
        onTap: onRetry,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              errorMessage(context, state.quoteError!),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: TidyColors.danger),
            ),
            Text(
              l10n.retry,
              style: text.labelLarge?.copyWith(color: TidyColors.primary),
            ),
          ],
        ),
      );
    } else if (state.quoteLoading || quote == null) {
      price = const Shimmer(
        key: ValueKey('total-loading'),
        child: SkeletonBox(width: 96, height: 30, radius: 8),
      );
    } else {
      price = PriceText(
        quote.total,
        style: text.headlineSmall?.copyWith(fontSize: 26),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quote == null
              ? l10n.total
              : l10n.totalWithHours(hoursValue(quote.minutes)),
          style: text.bodySmall?.copyWith(
            color: TidyColors.muted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        price,
      ],
    );
  }
}
