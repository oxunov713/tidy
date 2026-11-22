import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/format/formatters.dart';
import 'package:tidy_client/features/catalog/presentation/service_style.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The premium card of the Home carousel: tinted art area with two blobs and a
/// white icon tile, badge, duration and rating, price and a round arrow.
class ServiceCard extends StatelessWidget {
  const ServiceCard({required this.service, required this.onTap, super.key});

  static const double width = 232;

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final style = ServiceStyle.forSlug(service.slug);
    final badge = switch (style.badge) {
      ServiceBadge.mostBooked => l10n.badgeMostBooked,
      ServiceBadge.premium => l10n.badgePremium,
      null => null,
    };

    return Semantics(
      button: true,
      label: l10n.serviceCardSemantics(
        service.title,
        PriceText.format(service.fromPrice),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: TidyColors.white,
          borderRadius: BorderRadius.circular(26),
          border: style.featured
              ? Border.all(color: TidyColors.primary, width: 2)
              : null,
          boxShadow: [
            const BoxShadow(color: TidyColors.line, offset: Offset(0, 1)),
            BoxShadow(
              color: TidyColors.ink.withValues(alpha: 0.07),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Art(style: style, badge: badge),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.titleLarge?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          DefaultTextStyle.merge(
                            style: text.bodySmall?.copyWith(
                              color: TidyColors.muted,
                              fontSize: 13,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 14,
                                  color: TidyColors.muted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.hoursUnit(hoursRange(service.minutes)),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.star_rounded,
                                  size: 15,
                                  color: TidyColors.accent,
                                ),
                                const SizedBox(width: 2),
                                Text(style.rating),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.fromLabel,
                                style: text.labelSmall?.copyWith(
                                  color: TidyColors.muted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Text(
                                PriceText.format(service.fromPrice),
                                style: text.titleLarge?.copyWith(fontSize: 22),
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: TidyColors.ink,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: TidyColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art({required this.style, required this.badge});

  final ServiceStyle style;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
        color: style.tint,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: style.deep,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -36,
            child: Transform.rotate(
              angle: 18 * math.pi / 180,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: style.deep.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: TidyColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: TidyColors.ink.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(style.icon, size: 36, color: style.ink),
            ),
          ),
          if (badge != null)
            Positioned(
              left: 12,
              top: 12,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: TidyColors.ink,
                  borderRadius: TidyRadii.pillBorder,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: TidyColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Placeholder with the same footprint while the services load.
class ServiceCardSkeleton extends StatelessWidget {
  const ServiceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ServiceCard.width,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
      decoration: BoxDecoration(
        color: TidyColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: TidyColors.line),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 136, radius: 20),
          SizedBox(height: 16),
          SkeletonBox(width: 120, height: 18),
          SizedBox(height: 10),
          SkeletonBox(width: 80, height: 13),
          Spacer(),
          SkeletonBox(width: 90, height: 24),
        ],
      ),
    );
  }
}
