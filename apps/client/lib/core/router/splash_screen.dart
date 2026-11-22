import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/widgets/api_error_view.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Shown while the stored session is checked. If that fails (offline, server
/// down) it offers a retry instead of dropping the user to the sign in screen.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: TidyColors.white,
      body: auth.hasError
          ? ApiErrorView(
              error: auth.error!,
              onRetry: () => ref.invalidate(authControllerProvider),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: TidyColors.accent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'tidy',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
    );
  }
}
