import 'package:material_ui/material_ui.dart';
import 'package:tidy_ui/src/tokens/colors.dart';
import 'package:tidy_ui/src/tokens/radii.dart';
import 'package:tidy_ui/src/tokens/spacing.dart';
import 'package:tidy_ui/src/widgets/empty_state.dart';

/// Full-area error with an optional retry button. The words come from the
/// app, so they can be translated and can name the actual problem.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.title,
    required this.message,
    this.retryLabel,
    this.onRetry,
    super.key,
  });

  final String title;
  final String message;

  /// Label of the retry button; shown only together with [onRetry].
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final canRetry = onRetry != null && retryLabel != null;
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      title: title,
      message: message,
      actionLabel: canRetry ? retryLabel : null,
      onAction: canRetry ? onRetry : null,
    );
  }
}

/// Inline error inside a form or dialog.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: TidyColors.dangerSoft,
          borderRadius: TidyRadii.controlBorder,
        ),
        child: Padding(
          padding: const EdgeInsets.all(TidySpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline,
                size: 20,
                color: TidyColors.danger,
              ),
              const SizedBox(width: TidySpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: TidyColors.danger),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
