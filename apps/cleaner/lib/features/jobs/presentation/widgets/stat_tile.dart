import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Translucent tile on a dark background: a small label over a big number.
class StatTile extends StatelessWidget {
  const StatTile({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label $value',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(TidySpacing.md),
          decoration: BoxDecoration(
            color: TidyColors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: TidyColors.onInkMuted,
                ),
              ),
              const SizedBox(height: TidySpacing.xs),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: TidyColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
