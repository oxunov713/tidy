import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Full-area error with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      title: l10n.errorTitle,
      message: describeError(error, l10n),
      actionLabel: l10n.retry,
      onAction: onRetry,
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
