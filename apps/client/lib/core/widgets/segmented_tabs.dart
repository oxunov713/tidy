import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Two or more equal tabs in a grey track, the selected one white. Used for
/// Upcoming / Past.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: TidyColors.line,
        borderRadius: TidyRadii.controlBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (final (index, label) in labels.indexed)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: index == selectedIndex,
                  label: label,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? TidyColors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: ExcludeSemantics(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: index == selectedIndex
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: index == selectedIndex
                                ? TidyColors.ink
                                : TidyColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
