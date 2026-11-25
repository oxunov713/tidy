import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Full-area error for a failed call: the app's words (translated, naming
/// the actual problem) on the shared [ApiErrorView] layout.
class ApiErrorView extends StatelessWidget {
  const ApiErrorView({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ErrorState(
      title: l10n.errorTitle,
      message: errorMessage(context, error),
      retryLabel: l10n.retry,
      onRetry: onRetry,
    );
  }
}
