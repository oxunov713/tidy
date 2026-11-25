import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/features/active_job/domain/job_transitions.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Four-step timeline: accepted, on the way, cleaning, finished.
class ProgressCard extends StatelessWidget {
  const ProgressCard({required this.status, required this.times, super.key});

  final BookingStatus status;

  /// When each status was reached, as far as the phone knows.
  final Map<BookingStatus, DateTime> times;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final step = progressStep(status);
    final steps = [
      (l10n.stepAccepted, BookingStatus.assigned),
      (l10n.stepOnTheWay, BookingStatus.onTheWay),
      (l10n.stepCleaning, BookingStatus.inProgress),
      (l10n.stepFinished, BookingStatus.completed),
    ];

    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.progress, style: text.titleSmall?.copyWith(fontSize: 15)),
          const SizedBox(height: 10),
          for (final (i, (label, at)) in steps.indexed)
            Semantics(
              container: true,
              label: label,
              selected: i == step,
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    _Dot(done: i < step, current: i == step),
                    const SizedBox(width: 12),
                    ExcludeSemantics(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: i <= step
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: i <= step ? TidyColors.ink : TidyColors.muted,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (i <= step && times[at] != null)
                      Text(
                        TidyDates.clock(times[at]!, locale),
                        style: text.bodySmall?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.done, required this.current});

  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) => Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: done
          ? TidyColors.primary
          : current
          ? TidyColors.white
          : TidyColors.line,
      border: current ? Border.all(color: TidyColors.primary, width: 4) : null,
    ),
  );
}
