import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// White bar at the bottom of a wizard step: an optional info block on the
/// left and the primary action.
class WizardBottomBar extends StatelessWidget {
  const WizardBottomBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: TidyColors.white,
        border: Border(top: BorderSide(color: TidyColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: child,
        ),
      ),
    );
  }
}
