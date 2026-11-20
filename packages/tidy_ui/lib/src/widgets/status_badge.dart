import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';

/// Booking states, using the same wire names as the API.
enum TidyStatus {
  pending('pending', 'Pending'),
  confirmed('confirmed', 'Confirmed'),
  assigned('assigned', 'Assigned'),
  onTheWay('on_the_way', 'On the way'),
  inProgress('in_progress', 'In progress'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const TidyStatus(this.wireName, this.label);

  final String wireName;
  final String label;

  /// Falls back to [pending] for unknown values so a new server status never
  /// crashes the UI.
  static TidyStatus fromWire(String value) => TidyStatus.values.firstWhere(
    (s) => s.wireName == value,
    orElse: () => TidyStatus.pending,
  );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, this.label, super.key});

  StatusBadge.fromWire(String status, {String? label, Key? key})
    : this(status: TidyStatus.fromWire(status), label: label, key: key);

  final TidyStatus status;

  /// Overrides the English label, for localised apps.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      TidyStatus.pending => (TidyColors.accentSoft, const Color(0xFF8A5A00)),
      TidyStatus.confirmed => (TidyColors.infoSoft, TidyColors.info),
      TidyStatus.assigned => (TidyColors.primarySoft, TidyColors.primary),
      TidyStatus.onTheWay => (TidyColors.primary, TidyColors.white),
      TidyStatus.inProgress => (TidyColors.primary, TidyColors.white),
      TidyStatus.completed => (TidyColors.surface, TidyColors.muted),
      TidyStatus.cancelled => (TidyColors.dangerSoft, TidyColors.danger),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: TidyRadii.pillBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label ?? status.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
