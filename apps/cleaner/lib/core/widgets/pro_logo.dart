import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The "tidy pro" wordmark. Use [onDark] on the ink header.
class ProLogo extends StatelessWidget {
  const ProLogo({this.onDark = false, this.size = 20, super.key});

  final bool onDark;
  final double size;

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleLarge!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 1.3,
          height: size * 1.3,
          decoration: BoxDecoration(
            color: TidyColors.primary,
            borderRadius: BorderRadius.circular(size * 0.4),
          ),
        ),
        const SizedBox(width: TidySpacing.sm),
        Text.rich(
          TextSpan(
            text: 'tidy ',
            children: [
              TextSpan(
                text: 'pro',
                style: TextStyle(
                  color: onDark ? TidyColors.mint : TidyColors.primary,
                ),
              ),
            ],
          ),
          style: heading.copyWith(
            fontSize: size,
            color: onDark ? TidyColors.white : TidyColors.ink,
          ),
        ),
      ],
    );
  }
}
