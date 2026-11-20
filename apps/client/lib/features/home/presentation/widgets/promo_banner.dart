import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_ui/tidy_ui.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Material(
      color: TidyColors.primary,
      borderRadius: TidyRadii.cardBorder,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: TidyColors.accent,
                        borderRadius: TidyRadii.pillBorder,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          l10n.promoBadge,
                          style: const TextStyle(
                            color: TidyColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.promoTitle,
                      style: text.titleLarge?.copyWith(
                        color: TidyColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.promoCode,
                      style: text.bodySmall?.copyWith(
                        color: TidyColors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.auto_awesome_outlined,
                size: 52,
                color: TidyColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
