import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Small green (online) or grey (offline) status dot.
class OnlineDot extends StatelessWidget {
  const OnlineDot({required this.online, this.size = 10, super.key});

  final bool online;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: online ? TidyColors.primary : TidyColors.line,
        shape: BoxShape.circle,
        border: Border.all(color: TidyColors.white, width: 1.5),
      ),
    );
  }
}
