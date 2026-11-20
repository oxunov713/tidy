import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/widgets/round_icon_button.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Back button, "STEP n OF 3" caption, title and progress bar shared by the
/// three booking steps.
class WizardHeader extends StatelessWidget {
  const WizardHeader({
    required this.step,
    required this.title,
    required this.onBack,
    this.steps = 3,
    this.background = TidyColors.white,
    super.key,
  });

  final int step;
  final int steps;
  final String title;
  final VoidCallback onBack;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return ColoredBox(
      color: background,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RoundIconButton(
                    icon: Icons.chevron_left,
                    tooltip: l10n.back,
                    onPressed: onBack,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.stepOf(step, steps).toUpperCase(),
                          style: text.labelMedium?.copyWith(
                            color: TidyColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: text.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: step / steps,
                  minHeight: 4,
                  backgroundColor: TidyColors.line,
                  color: TidyColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
