import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/widgets/api_error_view.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';

/// Shown while the stored session is checked. When that fails (the phone is
/// offline, the server is down) it says so and offers a retry, instead of
/// sending a signed-in cleaner to the sign-in screen.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final error = session.hasValue ? null : session.error;
    return Scaffold(
      body: error != null
          ? SafeArea(
              child: ApiErrorView(
                error: error,
                onRetry: () => ref.invalidate(sessionControllerProvider),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
