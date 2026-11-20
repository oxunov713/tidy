import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/widgets/cleaner_avatar.dart';
import 'package:tidy_client/features/booking_wizard/presentation/last_cleaner_provider.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// "Your last cleaner" and "Any available cleaner". The first only appears for
/// people who have had a clean before.
class CleanerChoice extends ConsumerWidget {
  const CleanerChoice({
    required this.selectedCleanerId,
    required this.onSelected,
    super.key,
  });

  final String? selectedCleanerId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final last = ref.watch(lastCleanerProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (last != null) ...[
          _LastCleanerCard(
            cleaner: last,
            selected: selectedCleanerId == last.id,
            onTap: () => onSelected(last.id),
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          height: 48,
          child: TidyButton(
            label: l10n.anyCleaner,
            variant: selectedCleanerId == null && last != null
                ? TidyButtonVariant.secondary
                : TidyButtonVariant.ghost,
            onPressed: () => onSelected(null),
          ),
        ),
        if (last == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.anyCleanerNote,
              style: text.bodySmall?.copyWith(color: TidyColors.muted),
            ),
          ),
      ],
    );
  }
}

class _LastCleanerCard extends StatelessWidget {
  const _LastCleanerCard({
    required this.cleaner,
    required this.selected,
    required this.onTap,
  });

  final CleanerCard cleaner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Material(
      color: selected ? TidyColors.primarySoft : TidyColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? TidyColors.primary : TidyColors.line,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CleanerAvatar(
                name: cleaner.fullName,
                imageUrl: cleaner.avatarUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourLastCleaner(_shortName(cleaner.fullName)),
                      style: text.titleSmall?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.ratingAndReviews(
                        cleaner.rating.toStringAsFixed(1),
                        cleaner.ratingCount,
                      ),
                      style: text.bodySmall?.copyWith(
                        color: TidyColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check, color: TidyColors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  /// "Sarah Jones" -> "Sarah J."
  static String _shortName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return fullName;
    return '${parts.first} ${parts.last[0]}.';
  }
}
