import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/error_state.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/core/widgets/wizard_header.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_controller.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/cleaner_choice.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/day_strip.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/slot_grid.dart';
import 'package:tidy_client/features/booking_wizard/presentation/widgets/wizard_bottom_bar.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Step 2: day, start time and (optionally) a cleaner. Times come from
/// `GET /slots` and are reloaded whenever the day or the cleaner changes.
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    // Providers must not change while the tree is building.
    unawaited(
      Future.microtask(() async {
        if (mounted) await ref.read(bookingWizardProvider.notifier).loadSlots();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final state = ref.watch(bookingWizardProvider);
    final wizard = ref.read(bookingWizardProvider.notifier);
    final now = ref.watch(clockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    final date = state.date ?? today;

    return Scaffold(
      backgroundColor: TidyColors.white,
      body: Column(
        children: [
          WizardHeader(
            step: 2,
            title: l10n.whenShouldWeCome,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatMonthYear(date, locale),
                        style: text.titleSmall?.copyWith(fontSize: 15),
                      ),
                    ),
                    Text(
                      l10n.nextSevenDays,
                      style: text.bodySmall?.copyWith(
                        color: TidyColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DayStrip(
                  today: today,
                  selected: date,
                  locale: locale,
                  onSelected: wizard.selectDate,
                ),
                const SizedBox(height: 22),
                Text(
                  l10n.startTime,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                _Slots(state: state, onRetry: wizard.loadSlots),
                const SizedBox(height: 22),
                Text(
                  l10n.cleaner,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 10),
                CleanerChoice(
                  selectedCleanerId: state.cleanerId,
                  onSelected: wizard.selectCleaner,
                ),
              ],
            ),
          ),
          WizardBottomBar(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _summary(l10n, locale, state),
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: TidyColors.muted),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 56,
                  child: TidyButton(
                    label: l10n.continueToPayment,
                    onPressed: state.slot == null
                        ? null
                        : () => context.push(Routes.checkout),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _summary(
    AppLocalizations l10n,
    String locale,
    BookingWizardState state,
  ) {
    final slot = state.slot;
    if (slot == null) return l10n.pickATime;
    final minutes = state.quote?.minutes;
    final day = formatDayLong(slot, locale);
    return minutes == null
        ? l10n.scheduleSummaryShort(day, formatClock(slot))
        : l10n.scheduleSummary(day, formatClock(slot), hoursValue(minutes));
  }
}

class _Slots extends ConsumerWidget {
  const _Slots({required this.state, required this.onRetry});

  final BookingWizardState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    if (state.slotsError != null && !state.slotsLoading) {
      return SizedBox(
        height: 220,
        child: ErrorState(error: state.slotsError!, onRetry: onRetry),
      );
    }
    if (state.slotsLoading && state.slots.isEmpty) {
      return Shimmer(
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.3,
          children: List.generate(
            9,
            (_) => const SkeletonBox(radius: 12, height: 48),
          ),
        ),
      );
    }
    if (state.slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            l10n.noTimesThatDay,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: TidyColors.muted),
          ),
        ),
      );
    }
    final wizard = ref.read(bookingWizardProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: state.slotsLoading ? 0.5 : 1,
          child: SlotGrid(
            slots: state.slots,
            selected: state.slot,
            onSelected: wizard.selectSlot,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.takenTimesNote,
          style: text.bodySmall?.copyWith(color: TidyColors.muted),
        ),
      ],
    );
  }
}
