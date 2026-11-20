import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Saved addresses. With [pick] set, tapping one chooses it and closes the
/// screen; otherwise tapping only marks it as the default.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({this.pick = false, super.key});

  final bool pick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final addresses = ref.watch(addressesProvider);
    final current = ref.watch(currentAddressProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    pick ? l10n.chooseAddress : l10n.myAddresses,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncValueView<List<Address>>(
                value: addresses,
                onRetry: () => ref.invalidate(addressesProvider),
                loading: (_) => const _AddressesSkeleton(),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.location_on_outlined,
                        title: l10n.noAddressesTitle,
                        message: l10n.noAddressesBody,
                        actionLabel: l10n.addAddress,
                        onAction: () => context.push(Routes.addAddress),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.refresh(addressesProvider.future),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          itemCount: list.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final address = list[index];
                            return _AddressTile(
                              address: address,
                              selected: address.id == current?.id,
                              onTap: () {
                                ref
                                    .read(selectedAddressIdProvider.notifier)
                                    .select(address.id);
                                if (pick) context.pop();
                              },
                            );
                          },
                        ),
                      ),
              ),
            ),
            if (addresses.hasValue && addresses.value!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: TidyButton(
                  label: l10n.addAddress,
                  icon: Icons.add,
                  variant: TidyButtonVariant.secondary,
                  onPressed: () => context.push(Routes.addAddress),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddressTile extends ConsumerWidget {
  const _AddressTile({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final Address address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final line = [
      address.line1,
      if (address.line2.isNotEmpty) address.line2,
    ].join(', ');
    return TidyCard(
      highlighted: selected,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.location_on_outlined,
            color: selected ? TidyColors.primary : TidyColors.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line, style: text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${address.city} ${address.postcode}',
                  style: text.bodyMedium?.copyWith(color: TidyColors.muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.deleteAddress,
            icon: const Icon(Icons.delete_outline, color: TidyColors.muted),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAddressTitle),
        content: Text(address.line1),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
            child: Text(l10n.deleteAddress),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(addressesProvider.notifier).remove(address.id);
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
      }
    }
  }
}

class _AddressesSkeleton extends StatelessWidget {
  const _AddressesSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          children: [
            SkeletonBox(height: 72, radius: 20),
            SizedBox(height: 12),
            SkeletonBox(height: 72, radius: 20),
          ],
        ),
      ),
    );
  }
}
