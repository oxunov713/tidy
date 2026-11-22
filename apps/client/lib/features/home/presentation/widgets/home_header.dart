import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "Cleaning at 14 Baker Street" with the notifications button.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final addresses = ref.watch(addressesProvider);
    final address = ref.watch(currentAddressProvider);

    final Widget line;
    if (addresses.isLoading && !addresses.hasValue) {
      line = const Shimmer(child: SkeletonBox(width: 170, height: 20));
    } else if (address == null) {
      line = Text(
        l10n.addYourAddress,
        style: text.titleMedium?.copyWith(color: TidyColors.primary),
      );
    } else {
      line = Text(
        '${address.line1}, ${address.city}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.titleMedium,
      );
    }

    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => address == null
                ? context.push(Routes.addAddress)
                : context.push('${Routes.addresses}?pick=1'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cleaningAt,
                  style: text.bodySmall?.copyWith(
                    color: TidyColors.muted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: TidyColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(child: line),
                    const Icon(
                      Icons.expand_more,
                      size: 18,
                      color: TidyColors.muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        RoundIconButton(
          icon: Icons.notifications_none,
          tooltip: l10n.notifications,
          filled: true,
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noNotifications)),
          ),
        ),
      ],
    );
  }
}
