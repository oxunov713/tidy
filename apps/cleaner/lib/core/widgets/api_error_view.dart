import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Error for a screen or a card: the app's translated words on the shared
/// [ErrorState] layout, with a retry button.
class ApiErrorView extends StatelessWidget {
  const ApiErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ErrorState(
      title: l10n.errorTitle,
      message: errorText(l10n, error),
      retryLabel: l10n.retry,
      onRetry: onRetry,
    );
  }
}
