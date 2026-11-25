import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/widgets/api_error_view.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_controller.dart';
import 'package:tidy_cleaner/features/schedule/domain/availability.dart';
import 'package:tidy_cleaner/features/schedule/domain/day_timeline.dart';
import 'package:tidy_cleaner/features/schedule/presentation/availability_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_cleaner/router.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Working days and hours on top, the timeline of the chosen day below.
class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final today = BusinessTime.today(ref.watch(clockProvider)());
    final selected = _selected ?? today;
    final monday = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );
    final availability = ref.watch(availabilityControllerProvider);
    final jobs = ref.watch(jobsControllerProvider);

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(availabilityControllerProvider);
          await ref
              .read(jobsControllerProvider.notifier)
              .refresh()
              .onError<Object>((_, _) {});
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.scheduleTitle, style: text.headlineLarge),
                Text(
                  TidyDates.dayRangeOf(
                    monday,
                    DateTime(monday.year, monday.month, monday.day + 6),
                    locale,
                  ),
                  style: text.labelLarge?.copyWith(color: TidyColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 16),
            switch (availability) {
              AsyncData(:final value) => _HoursCard(state: value),
              AsyncError(:final error) => ApiErrorView(
                error: error,
                onRetry: () => ref.invalidate(availabilityControllerProvider),
              ),
              _ => const Shimmer(
                child: SkeletonBox(height: 190, radius: TidyRadii.card),
              ),
            },
            const SizedBox(height: 16),
            _DayStrip(
              today: today,
              selected: selected,
              jobs: jobs.value ?? const [],
              onSelect: (day) => setState(() => _selected = day),
            ),
            const SizedBox(height: 14),
            Text(
              TidyDates.dayLongOf(selected, locale),
              style: text.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            switch (jobs) {
              AsyncData(:final value) => _Timeline(
                day: selected,
                jobs: [
                  for (final job in value)
                    if (job.booking.status != BookingStatus.cancelled &&
                        BusinessTime.isOnDay(job.booking.start, selected))
                      job,
                ],
                window: availability.value?.saved,
              ),
              AsyncError(:final error) => ApiErrorView(
                error: error,
                onRetry: () => ref.invalidate(jobsControllerProvider),
              ),
              _ => SkeletonList(
                count: 2,
                height: 90,
                semanticLabel: AppLocalizations.of(context).loading,
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _HoursCard extends ConsumerWidget {
  const _HoursCard({required this.state});

  final AvailabilityState state;

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref, {
    required bool from,
  }) async {
    final minutes = from ? state.draft.fromMinutes : state.draft.toMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    final value = picked.hour * 60 + picked.minute;
    final controller = ref.read(availabilityControllerProvider.notifier);
    if (from) {
      controller.setFrom(value);
    } else {
      controller.setTo(value);
    }
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(availabilityControllerProvider.notifier).save();
      messenger.showSnackBar(SnackBar(content: Text(l10n.hoursSaved)));
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final controller = ref.read(availabilityControllerProvider.notifier);
    final names = [
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
      l10n.weekdaySun,
    ];
    final shorts = [
      l10n.weekdayShortMon,
      l10n.weekdayShortTue,
      l10n.weekdayShortWed,
      l10n.weekdayShortThu,
      l10n.weekdayShortFri,
      l10n.weekdayShortSat,
      l10n.weekdayShortSun,
    ];

    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.workingDays,
                style: text.titleSmall?.copyWith(fontSize: 15),
              ),
              Text(
                l10n.tapToSwitch,
                style: text.bodySmall?.copyWith(color: TidyColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 7; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _DayToggle(
                    key: Key('weekday_$i'),
                    label: shorts[i],
                    semanticLabel: names[i],
                    on: state.draft.weekdays.contains(i),
                    onTap: () => controller.toggleDay(i),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TimeField(
                  key: const Key('fromField'),
                  label: l10n.from,
                  minutes: state.draft.fromMinutes,
                  onTap: () => _pick(context, ref, from: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimeField(
                  key: const Key('toField'),
                  label: l10n.to,
                  minutes: state.draft.toMinutes,
                  onTap: () => _pick(context, ref, from: false),
                ),
              ),
            ],
          ),
          if (!state.draft.isValid) ...[
            const SizedBox(height: TidySpacing.sm),
            Text(
              l10n.hoursInvalid,
              style: text.bodySmall?.copyWith(color: TidyColors.danger),
            ),
          ],
          if (state.dirty) ...[
            const SizedBox(height: 14),
            TidyButton(
              key: const Key('saveHours'),
              label: l10n.saveHours,
              isLoading: state.saving,
              onPressed: state.draft.isValid ? () => _save(context, ref) : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _DayToggle extends StatelessWidget {
  const _DayToggle({
    required this.label,
    required this.semanticLabel,
    required this.on,
    required this.onTap,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      label: semanticLabel,
      child: Material(
        color: on ? TidyColors.primary : TidyColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: on ? BorderSide.none : const BorderSide(color: TidyColors.line),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Center(
              child: ExcludeSemantics(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w600,
                    color: on ? TidyColors.white : TidyColors.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.minutes,
    required this.onTap,
    super.key,
  });

  final String label;
  final int minutes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: TidyColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: TidyColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: TidyColors.line),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: onTap,
            child: Container(
              height: 44,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                AvailabilityDraft.formatMinutes(minutes),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Next 14 days as small date tiles; a dot marks a day with jobs.
class _DayStrip extends StatelessWidget {
  const _DayStrip({
    required this.today,
    required this.selected,
    required this.jobs,
    required this.onSelect,
  });

  final DateTime today;
  final DateTime selected;
  final List<Job> jobs;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = DateTime(today.year, today.month, today.day + i);
          final isSelected = day == selected;
          final busy = jobs.any(
            (j) =>
                j.booking.status != BookingStatus.cancelled &&
                BusinessTime.isOnDay(j.booking.start, day),
          );
          return TidyChip(
            label: '${TidyDates.weekdayShortOf(day, locale)} ${day.day}',
            selected: isSelected,
            icon: busy ? Icons.circle : null,
            onSelected: (_) => onSelect(day),
          );
        },
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.day,
    required this.jobs,
    required this.window,
  });

  final DateTime day;
  final List<Job> jobs;
  final AvailabilityDraft? window;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final working = window?.weekdays.contains(day.weekday - 1) ?? false;
    final workStart = working
        ? BusinessTime.instantAt(
            day,
            hour: window!.fromMinutes ~/ 60,
            minute: window!.fromMinutes % 60,
          )
        : null;
    final entries = buildTimeline(jobs: jobs, workStart: workStart);

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TidySpacing.lg),
        decoration: const BoxDecoration(
          color: TidyColors.white,
          borderRadius: TidyRadii.cardBorder,
        ),
        child: Text(
          l10n.timelineDayOff,
          style: text.bodyMedium?.copyWith(color: TidyColors.muted),
        ),
      );
    }

    return Column(
      children: [for (final entry in entries) _TimelineRow(entry: entry)],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry});

  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;

    final content = switch (entry) {
      TimelineJob(:final job) => _JobBlock(job: job),
      TimelineFree() => _Gap(label: l10n.timelineFree),
      TimelineBuffer(:final minutes) => _Gap(
        label: l10n.timelineBuffer(minutes),
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                TidyDates.clock(entry.at, locale),
                style: text.bodySmall?.copyWith(color: TidyColors.muted),
              ),
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    padding: const EdgeInsets.only(top: 8),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: TidyColors.dash)),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 13,
        color: TidyColors.muted,
      ),
    ),
  );
}

class _JobBlock extends StatelessWidget {
  const _JobBlock({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final booking = job.booking;
    final live =
        booking.status == BookingStatus.onTheWay ||
        booking.status == BookingStatus.inProgress;
    final done = booking.status == BookingStatus.completed;
    final background = live
        ? TidyColors.primary
        : done
        ? TidyColors.white
        : TidyColors.primarySoft;
    final title = live ? TidyColors.white : TidyColors.ink;
    final detail = live
        ? TidyColors.white.withValues(alpha: 0.85)
        : done
        ? TidyColors.muted
        : TidyColors.onPrimarySoft;

    // Taller blocks for longer visits, so the day reads like a timeline.
    final minutes = booking.end.difference(booking.start).inMinutes;
    final height = (minutes * 0.45).clamp(84, 150).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
          side: done
              ? const BorderSide(color: TidyColors.line)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: TidyRadii.controlBorder,
          ),
          onTap: () => context.push(Routes.job(booking.id)),
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking.serviceTitle} · ${job.clientName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: title,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.timelineJobLine(
                    TidyDates.timeRange(booking.start, booking.end, locale),
                    job.address.line1,
                    TidyFormat.payout(booking.cleanerPayout),
                  ),
                  style: TextStyle(fontSize: 13, color: detail),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
