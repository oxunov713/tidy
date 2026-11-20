import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/core/errors/error_text.dart';
import 'package:tidy_cleaner/core/locale/locale_controller.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Who the cleaner is in the app, the language and sign-out.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _rename(BuildContext context, WidgetRef ref, User user) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final controller = TextEditingController(text: user.fullName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editName),
        content: TextField(
          key: const Key('nameField'),
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.fullName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const Key('saveName'),
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == user.fullName) return;
    try {
      await ref.read(sessionControllerProvider.notifier).rename(name);
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, e))));
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirmTitle),
        content: Text(l10n.signOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const Key('confirmSignOut'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(sessionControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final user = ref.watch(sessionControllerProvider).value;
    final locale = ref.watch(localeControllerProvider);
    if (user == null) return const SizedBox.shrink();
    final cleaner = user.cleaner;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          Text(l10n.profileTitle, style: text.headlineLarge),
          const SizedBox(height: 16),
          TidyCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Avatar(
                      name: user.fullName,
                      imageUrl: user.avatarUrl,
                      size: 64,
                    ),
                    const SizedBox(width: TidySpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            key: const Key('profileName'),
                            style: text.titleLarge,
                          ),
                          if (cleaner != null && cleaner.ratingCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 18,
                                    color: TidyColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.profileRating(
                                      cleaner.rating.toStringAsFixed(1),
                                      cleaner.ratingCount,
                                    ),
                                    style: text.bodySmall?.copyWith(
                                      color: TidyColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const Key('editName'),
                      tooltip: l10n.editName,
                      onPressed: () => _rename(context, ref, user),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                const Divider(height: 28),
                _Row(label: l10n.profilePhone, value: user.phone),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TidyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileBio,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: TidySpacing.sm),
                Text(
                  (cleaner?.bio ?? '').isEmpty
                      ? l10n.profileNoBio
                      : cleaner!.bio,
                  style: text.bodyMedium?.copyWith(
                    color: TidyColors.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TidyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileLanguage,
                  style: text.titleSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: TidySpacing.md),
                Wrap(
                  spacing: TidySpacing.sm,
                  runSpacing: TidySpacing.sm,
                  children: [
                    TidyChip(
                      key: const Key('lang_system'),
                      label: l10n.languageSystem,
                      selected: locale == null,
                      onSelected: (_) =>
                          ref.read(localeControllerProvider.notifier).set(null),
                    ),
                    for (final (code, name) in const [
                      ('en', 'English'),
                      ('ru', 'Русский'),
                      ('uz', "O'zbekcha"),
                    ])
                      TidyChip(
                        key: Key('lang_$code'),
                        label: name,
                        selected: locale?.languageCode == code,
                        onSelected: (_) => ref
                            .read(localeControllerProvider.notifier)
                            .set(Locale(code)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TidyButton(
            key: const Key('signOut'),
            label: l10n.signOut,
            icon: Icons.logout,
            variant: TidyButtonVariant.ghost,
            onPressed: () => _signOut(context, ref),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: TidyColors.muted)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
