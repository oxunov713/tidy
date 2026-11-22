import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Bars for `Earnings.days` on the dark card: one per day, the highlighted day
/// in mint. Touch a bar to see its amount.
class EarningsChart extends StatelessWidget {
  const EarningsChart({
    required this.days,
    required this.highlight,
    required this.compact,
    super.key,
  });

  final List<EarningsDay> days;

  /// `yyyy-MM-dd` of the bar drawn in mint (today).
  final String highlight;

  /// Month view: thinner bars and a label only on every fifth day.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final maxAmount = days.fold<int>(0, (m, d) => d.amount > m ? d.amount : m);
    final dates = [for (final d in days) BusinessTime.parseDay(d.date)];

    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          maxY: maxAmount == 0 ? 1 : maxAmount * 1.08,
          alignment: BarChartAlignment.spaceBetween,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= dates.length) return const SizedBox();
                  if (compact && i % 5 != 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      compact
                          ? '${dates[i].day}'
                          : TidyDates.weekdayNarrowOf(dates[i], locale),
                      style: const TextStyle(
                        fontSize: 11,
                        color: TidyColors.onInkMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => TidyColors.white,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                  BarTooltipItem(
                    TidyFormat.pounds(days[groupIndex].amount),
                    const TextStyle(
                      color: TidyColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
            ),
          ),
          barGroups: [
            for (final (i, day) in days.indexed)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: day.amount == 0
                        ? maxAmount * 0.04
                        : day.amount.toDouble(),
                    width: compact ? 5 : 22,
                    borderRadius: BorderRadius.circular(compact ? 3 : 6),
                    color: day.date == highlight
                        ? TidyColors.mint
                        : TidyColors.white.withValues(alpha: 0.22),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
