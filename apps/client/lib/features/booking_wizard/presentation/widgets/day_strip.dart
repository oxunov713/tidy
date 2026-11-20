import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Seven days starting today; tap one to choose it.
class DayStrip extends StatelessWidget {
  const DayStrip({
    required this.today,
    required this.selected,
    required this.locale,
    required this.onSelected,
    this.days = 7,
    super.key,
  });

  final DateTime today;
  final DateTime? selected;
  final String locale;
  final ValueChanged<DateTime> onSelected;
  final int days;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < days; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(child: _tile(today.add(Duration(days: i)))),
        ],
      ],
    );
  }

  Widget _tile(DateTime day) {
    final isSelected = selected != null && isSameDay(day, selected!);
    final foreground = isSelected ? TidyColors.white : TidyColors.ink;
    return Semantics(
      button: true,
      selected: isSelected,
      label: formatDayLong(day, locale),
      child: Material(
        color: isSelected ? TidyColors.primary : TidyColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: TidyRadii.controlBorder,
          side: isSelected
              ? BorderSide.none
              : const BorderSide(color: TidyColors.line),
        ),
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: TidyRadii.controlBorder,
          ),
          onTap: () => onSelected(day),
          child: ExcludeSemantics(
            child: SizedBox(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatWeekdayShort(day, locale),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: foreground,
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
