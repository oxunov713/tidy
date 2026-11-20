import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Shown while an admin has not approved the profile yet. Pull down to check
/// again; the router moves on by itself once the status is `approved`.
class PendingReviewPage extends ConsumerWidget {
  const PendingReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _StatusScaffold(
      icon: Icons.hourglass_top_rounded,
      title: l10n.pendingTitle,
      message: l10n.pendingBody,
      hint: l10n.pullToRefresh,
    );
  }
}

class SuspendedPage extends ConsumerWidget {
  const SuspendedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return _StatusScaffold(
      icon: Icons.pause_circle_outline_rounded,
      title: l10n.suspendedTitle,
      message: l10n.suspendedBody,
    );
  }
}

class _StatusScaffold extends ConsumerWidget {
  const _StatusScaffold({
    required this.icon,
    required this.title,
    required this.message,
    this.hint,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? hint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    Future<void> refresh() async {
      try {
        await ref.read(sessionControllerProvider.notifier).refresh();
      } on Object catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorText(l10n, e))),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: LayoutBuilder(
            builder: (context, constraints) => ListView(
              // Always scrollable so the pull gesture works on tall screens.
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyState(icon: icon, title: title, message: message),
                      if (hint != null)
                        Text(
                          hint!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: TidyColors.muted),
                        ),
                      const SizedBox(height: TidySpacing.xl),
                      TidyButton(
                        label: l10n.signOut,
                        variant: TidyButtonVariant.ghost,
                        expand: false,
                        onPressed: () => ref
                            .read(sessionControllerProvider.notifier)
                            .signOut(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
