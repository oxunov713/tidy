import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Confirmed, On the way, Cleaning, Done: a bar and a label each, filled up to
/// the current status.
class ProgressSteps extends StatelessWidget {
  const ProgressSteps({required this.status, super.key});

  final BookingStatus status;

  /// How many of the four steps are reached.
  static int stepsReached(BookingStatus status) => switch (status) {
    BookingStatus.pending || BookingStatus.cancelled => 0,
    BookingStatus.confirmed || BookingStatus.assigned => 1,
    BookingStatus.onTheWay => 2,
    BookingStatus.inProgress => 3,
    BookingStatus.completed => 4,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reached = stepsReached(status);
    final labels = [
      l10n.stepConfirmed,
      l10n.stepOnTheWay,
      l10n.stepCleaning,
      l10n.stepDone,
    ];
    return Row(
      children: [
        for (final (index, label) in labels.indexed) ...[
          if (index > 0) const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index < reached
                        ? TidyColors.primary
                        : TidyColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: index < reached
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: index < reached ? TidyColors.ink : TidyColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
