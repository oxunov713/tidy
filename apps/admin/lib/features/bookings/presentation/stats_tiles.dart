import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/widgets/skeleton.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Four KPI tiles from `/admin/stats/today`, refreshed every 30 seconds.
class StatsTiles extends ConsumerWidget {
  const StatsTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(statsControllerProvider);
    final data = stats.value;
    final loading = data == null && !stats.hasError;

    Widget value(String Function() format) => loading
        ? const Skeleton(width: 72, height: 30)
        : Text(
            data == null ? '—' : format(),
            style: Theme.of(context).textTheme.headlineLarge,
          );

    final pending = data?.pendingApprovals ?? 0;
    final tiles = [
      _Tile(
        label: l10n.statBookingsToday,
        child: value(() => '${data!.bookings}'),
      ),
      _Tile(
        label: l10n.statRevenueToday,
        child: value(() => PriceText.format(data!.revenue)),
      ),
      _Tile(
        label: l10n.statCleanersOnline,
        child: value(() => '${data!.cleanersOnline}'),
      ),
      _Tile(
        label: l10n.statAwaitingApproval,
        highlighted: pending > 0,
        onTap: () => context.go('/cleaners'),
        child: value(() => '$pending'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 4 : 2;
        const gap = TidySpacing.lg;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final t in tiles) SizedBox(width: width, child: t)],
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.child,
    this.highlighted = false,
    this.onTap,
  });

  final String label;
  final Widget child;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? TidyColors.accentSoft : TidyColors.white,
      borderRadius: TidyRadii.cardBorder,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: TidyColors.muted),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 34,
                child: Align(alignment: Alignment.centerLeft, child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
