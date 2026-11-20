import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/theme/pro_colors.dart';
import 'package:tidy_cleaner/core/widgets/async_states.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_controller.dart';
import 'package:tidy_cleaner/features/earnings/presentation/widgets/earnings_chart.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Total, bar chart per day, tips, average per hour and the latest jobs.
class EarningsPage extends ConsumerWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final period = ref.watch(selectedPeriodProvider);
    final earnings = ref.watch(earningsProvider(period));

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(earningsProvider(period).future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.earningsTitle, style: text.headlineLarge),
                ),
                TidyChip(
                  key: const Key('periodWeek'),
                  label: l10n.periodWeek,
                  selected: period == EarningsPeriod.week,
                  onSelected: (_) => ref
                      .read(selectedPeriodProvider.notifier)
                      .select(EarningsPeriod.week),
                ),
                const SizedBox(width: TidySpacing.sm),
                TidyChip(
                  key: const Key('periodMonth'),
                  label: l10n.periodMonth,
                  selected: period == EarningsPeriod.month,
                  onSelected: (_) => ref
                      .read(selectedPeriodProvider.notifier)
                      .select(EarningsPeriod.month),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...switch (earnings) {
              AsyncData(:final value) => _content(context, ref, value),
              AsyncError(:final error) => [
                ErrorState(
                  error: error,
                  onRetry: () => ref.invalidate(earningsProvider(period)),
                ),
              ],
              _ => const [
                SkeletonBox(height: 250, radius: 24),
                SizedBox(height: 16),
                SkeletonBox(height: 80),
              ],
            },
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, Earnings data) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final today = Fmt.isoDay(ref.watch(clockProvider)());
    final isWeek = data.period == 'week';
    final perHour = data.minutes > 0
        ? Fmt.pounds(Fmt.perHour(data.total, data.minutes))
        : '–';

    return [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: TidyColors.ink,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isWeek ? l10n.thisWeek : l10n.thisMonth,
                        style: const TextStyle(
                          fontSize: 13,
                          color: ProColors.onInkMuted,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.xs),
                      Text(
                        Fmt.pounds(data.total),
                        key: const Key('earningsTotal'),
                        style: text.headlineLarge?.copyWith(
                          fontSize: 34,
                          color: TidyColors.white,
                        ),
                      ),
                      const SizedBox(height: TidySpacing.xs),
                      Text(
                        l10n.jobsAndHours(data.jobs, Fmt.hours(data.minutes)),
                        style: const TextStyle(
                          fontSize: 13,
                          color: ProColors.mint,
                        ),
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: TidyColors.white.withValues(alpha: 0.1),
                    borderRadius: TidyRadii.pillBorder,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      l10n.payoutDay,
                      style: const TextStyle(
                        color: TidyColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            EarningsChart(days: data.days, highlight: today, compact: !isWeek),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _Tile(label: l10n.tips, value: Fmt.pounds(data.tips)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Tile(
              key: const Key('avgPerHour'),
              label: l10n.avgPerHour,
              value: perHour,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Text(l10n.recent, style: text.titleLarge?.copyWith(fontSize: 18)),
      const SizedBox(height: 12),
      if (data.recent.isEmpty)
        EmptyState(
          icon: Icons.receipt_long_outlined,
          title: l10n.recentEmptyTitle,
          message: l10n.recentEmptyBody,
        )
      else
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: const BoxDecoration(
            color: TidyColors.white,
            borderRadius: TidyRadii.cardBorder,
          ),
          child: Column(
            children: [
              for (final (i, job) in data.recent.indexed)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: i == data.recent.length - 1
                        ? null
                        : const Border(
                            bottom: BorderSide(color: TidyColors.line),
                          ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${job.serviceTitle} · ${job.code}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleSmall?.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              job.tip > 0
                                  ? l10n.recentTip(
                                      Fmt.shortDate(job.start, locale),
                                      Fmt.payout(job.tip),
                                    )
                                  : Fmt.shortDate(job.start, locale),
                              style: text.bodySmall?.copyWith(
                                color: TidyColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Fmt.pounds(job.amount + job.tip),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
    ];
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: TidyColors.white,
        borderRadius: TidyRadii.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text.bodySmall?.copyWith(
              fontSize: 13,
              color: TidyColors.muted,
            ),
          ),
          const SizedBox(height: TidySpacing.xs),
          Text(value, style: text.titleLarge),
        ],
      ),
    );
  }
}
