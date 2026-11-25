import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/plans/presentation/plans_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "Manage recurring cleans": the client's weekly and fortnightly series,
/// each with a button that ends it.
class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plans = ref.watch(plansProvider);
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
                  Expanded(
                    child: Text(
                      l10n.managePlans,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncValueView<List<Plan>>(
                value: plans,
                onRetry: () => ref.invalidate(plansProvider),
                loading: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: SkeletonList(
                    count: 2,
                    height: 110,
                    semanticLabel: l10n.loading,
                  ),
                ),
                data: (list) => list.isEmpty
                    ? EmptyState(
                        icon: Icons.repeat,
                        title: l10n.plansEmptyTitle,
                        message: l10n.plansEmptyBody,
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.refresh(plansProvider.future),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) => _PlanCard(plan: list[i]),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends ConsumerStatefulWidget {
  const _PlanCard({required this.plan});

  final Plan plan;

  @override
  ConsumerState<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends ConsumerState<_PlanCard> {
  bool _stopping = false;

  Future<void> _stop() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopSeriesTitle),
        content: Text(l10n.stopSeriesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const Key('confirmStopSeries'),
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
            child: Text(l10n.stopSeries),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _stopping = true);
    try {
      await ref.read(bookingRepositoryProvider).endPlan(widget.plan.id);
      ref
        ..invalidate(plansProvider)
        ..invalidate(bookingsListProvider(BookingScope.upcoming))
        ..invalidate(bookingsListProvider(BookingScope.past));
      messenger.showSnackBar(SnackBar(content: Text(l10n.seriesStopped)));
    } on Object catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(errorMessage(context, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final plan = widget.plan;
    final frequency = plan.frequency == Frequency.weekly
        ? l10n.frequencyWeekly
        : l10n.frequencyFortnightly;
    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.repeat, size: 18, color: TidyColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  plan.serviceTitle,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
              ),
              Text(
                frequency,
                style: text.bodySmall?.copyWith(color: TidyColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.planNextVisit(
              TidyDates.dayShortOf(plan.nextRunOn, locale),
              plan.startTime,
            ),
            style: text.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: Key('stopSeries-${plan.id}'),
              onPressed: _stopping ? null : _stop,
              style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
              child: Text(l10n.stopSeries),
            ),
          ),
        ],
      ),
    );
  }
}
