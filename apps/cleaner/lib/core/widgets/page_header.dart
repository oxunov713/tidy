import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// White top bar of the detail screens: square back button, title, subtitle.
class PageHeader extends StatelessWidget {
  const PageHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 16,
        20,
        16,
      ),
      decoration: const BoxDecoration(
        color: TidyColors.white,
        border: Border(bottom: BorderSide(color: TidyColors.line)),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: MaterialLocalizations.of(context).backButtonTooltip,
            child: Material(
              color: TidyColors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: TidyRadii.controlBorder,
                side: BorderSide(color: TidyColors.line),
              ),
              child: InkWell(
                key: const Key('back'),
                customBorder: const RoundedRectangleBorder(
                  borderRadius: TidyRadii.controlBorder,
                ),
                onTap: () => context.canPop() ? context.pop() : null,
                child: const SizedBox.square(
                  dimension: 44,
                  child: Icon(Icons.chevron_left, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: TidySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge?.copyWith(fontSize: 18),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                      fontSize: 13,
                      color: TidyColors.muted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
