import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/widgets/api_error_view.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Shown while the stored session is checked, or when that check failed.
class SplashPage extends StatelessWidget {
  const SplashPage({this.error, this.onRetry, super.key});

  final Object? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    return Scaffold(
      backgroundColor: TidyColors.surface,
      body: error != null && onRetry != null
          ? ApiErrorView(error: error, onRetry: onRetry!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
