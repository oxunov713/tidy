import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_cleaner/features/active_job/presentation/checklist_controller.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Tasks for a visit: three fixed ones plus one per booked extra. Ticks are
/// kept on the phone.
class ChecklistCard extends ConsumerWidget {
  const ChecklistCard({required this.booking, super.key});

  final Booking booking;

  static List<(String, String)> items(AppLocalizations l10n, Booking booking) =>
      [
        ('kitchen', l10n.taskKitchen),
        ('bath', l10n.taskBathroom),
        ('floors', l10n.taskFloors),
        for (final extra in booking.extras)
          ('extra:${extra.id}', l10n.taskExtra(extra.title)),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final checked = ref.watch(checklistControllerProvider(booking.id));

    return TidyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checklist,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: TidySpacing.sm),
          for (final (id, label) in items(l10n, booking))
            InkWell(
              onTap: () => ref
                  .read(checklistControllerProvider(booking.id).notifier)
                  .toggle(id),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 24,
                      child: Checkbox(
                        key: Key('check_$id'),
                        value: checked.contains(id),
                        activeColor: TidyColors.primary,
                        onChanged: (_) => ref
                            .read(
                              checklistControllerProvider(booking.id).notifier,
                            )
                            .toggle(id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(label, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
