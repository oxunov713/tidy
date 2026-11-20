import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider);
    final locale = ref.watch(localeControllerProvider);
    final name = user?.fullName.trim() ?? '';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          Text(
            l10n.navProfile,
            style: text.headlineMedium?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),
          TidyCard(
            child: Row(
              children: [
                Avatar(
                  name: name.isEmpty ? (user?.phone ?? '') : name,
                  size: 56,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? l10n.addYourName : name,
                        style: text.titleMedium,
                      ),
                      Text(
                        user?.phone ?? '',
                        style: text.bodySmall?.copyWith(
                          color: TidyColors.muted,
                        ),
                      ),
                      if (user?.email != null && user!.email!.isNotEmpty)
                        Text(
                          user.email!,
                          style: text.bodySmall?.copyWith(
                            color: TidyColors.muted,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.editProfile,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editProfile(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.location_on_outlined,
            label: l10n.myAddresses,
            onTap: () => context.push(Routes.addresses),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.language,
            label: l10n.language,
            trailing: _languageName(l10n, locale?.languageCode),
            onTap: () => _pickLanguage(context, ref),
          ),
          const SizedBox(height: 12),
          _Tile(
            icon: Icons.logout,
            label: l10n.logout,
            danger: true,
            onTap: () => _logout(context, ref),
          ),
        ],
      ),
    );
  }

  static String _languageName(AppLocalizations l10n, String? code) =>
      switch (code) {
        'en' => 'English',
        'ru' => 'Русский',
        'uz' => 'Oʻzbekcha',
        _ => l10n.systemDefault,
      };

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TidyColors.danger),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(authControllerProvider.notifier).logout();
  }

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: TidyColors.white,
      builder: (sheetContext) => SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final current = ref.watch(localeControllerProvider)?.languageCode;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final code in [null, ...supportedLanguageCodes])
                  ListTile(
                    title: Text(_languageName(l10n, code)),
                    trailing: current == code
                        ? const Icon(Icons.check, color: TidyColors.primary)
                        : null,
                    onTap: () {
                      unawaited(
                        ref
                            .read(localeControllerProvider.notifier)
                            .select(code == null ? null : Locale(code)),
                      );
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: TidyColors.white,
      builder: (_) => const _EditProfileSheet(),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final String? trailing;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger ? TidyColors.danger : TidyColors.ink;
    return TidyCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: color),
            ),
          ),
          if (trailing != null)
            Text(trailing!, style: const TextStyle(color: TidyColors.muted)),
          if (!danger) const Icon(Icons.chevron_right, color: TidyColors.muted),
        ],
      ),
    );
  }
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet();

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final _name = TextEditingController(
    text: ref.read(currentUserProvider)?.fullName,
  );
  late final _email = TextEditingController(
    text: ref.read(currentUserProvider)?.email,
  );
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updateProfile(
            fullName: _name.text.trim(),
            email: _email.text.trim(),
          );
      if (mounted) Navigator.of(context).pop();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editProfile,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.fullName),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.email),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return null;
                return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                    ? null
                    : l10n.emailInvalid;
              },
            ),
            const SizedBox(height: 20),
            TidyButton(
              label: l10n.save,
              isLoading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
