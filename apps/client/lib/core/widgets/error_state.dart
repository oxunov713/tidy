import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Full-area error with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      title: l10n.errorTitle,
      message: errorMessage(context, error),
      actionLabel: onRetry == null ? null : l10n.retry,
      onAction: onRetry,
    );
  }
}
