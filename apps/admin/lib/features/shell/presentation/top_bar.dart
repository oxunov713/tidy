import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

class TopBar extends ConsumerWidget {
  const TopBar({required this.title, this.onMenu, super.key});

  final String title;

  /// Opens the drawer; only set on phones.
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).value;
    final wide = MediaQuery.sizeOf(context).width >= 600;
    return Material(
      color: TidyColors.surface,
      child: SizedBox(
        height: 68,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? TidySpacing.xxl : TidySpacing.sm,
          ),
          child: Row(
            children: [
              if (onMenu != null)
                IconButton(
                  tooltip: l10n.navMenu,
                  onPressed: onMenu,
                  icon: const Icon(Icons.menu),
                ),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (user != null)
                PopupMenuButton<void>(
                  tooltip: l10n.accountMenu,
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    PopupMenuItem<void>(
                      enabled: false,
                      child: Text(user.phone),
                    ),
                    PopupMenuItem<void>(
                      onTap: () =>
                          ref.read(authControllerProvider.notifier).signOut(),
                      child: Row(
                        children: [
                          const Icon(Icons.logout, size: 18),
                          const SizedBox(width: TidySpacing.sm),
                          Text(l10n.signOut),
                        ],
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(TidySpacing.xs),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Avatar(
                          name: user.fullName,
                          imageUrl: user.avatarUrl,
                          size: 36,
                        ),
                        if (wide) ...[
                          const SizedBox(width: TidySpacing.sm),
                          Text(
                            user.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Icon(Icons.expand_more, size: 20),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
