import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Three cards: one-off, weekly, fortnightly.
class FrequencyPicker extends StatelessWidget {
  const FrequencyPicker({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Frequency selected;
  final ValueChanged<Frequency> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = [
      (Frequency.once, l10n.frequencyOnce, l10n.frequencyOnceNote),
      (Frequency.weekly, l10n.frequencyWeekly, l10n.frequencyWeeklyNote),
      (
        Frequency.fortnightly,
        l10n.frequencyFortnightly,
        l10n.frequencyFortnightlyNote,
      ),
    ];
    return Row(
      children: [
        for (final (index, (value, label, note)) in options.indexed) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: _FrequencyCard(
              label: label,
              note: note,
              selected: value == selected,
              onTap: () => onChanged(value),
            ),
          ),
        ],
      ],
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({
    required this.label,
    required this.note,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String note;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? TidyColors.primary : TidyColors.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $note',
      child: Material(
        color: selected ? TidyColors.primarySoft : TidyColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
          side: BorderSide(
            color: selected ? TidyColors.primary : TidyColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: TidyRadii.controlBorder,
          ),
          onTap: onTap,
          child: ExcludeSemantics(
            child: SizedBox(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? TidyColors.primary : TidyColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
