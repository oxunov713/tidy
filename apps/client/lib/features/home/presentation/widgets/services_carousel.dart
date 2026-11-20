import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/error/error_text.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/features/catalog/presentation/widgets/service_card.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The hero of Home: a horizontal carousel of service cards from
/// `GET /services`.
class ServicesCarousel extends ConsumerWidget {
  const ServicesCarousel({required this.onSelected, super.key});

  static const double height = 290;

  final ValueChanged<Service> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final services = ref.watch(servicesProvider);
    return SizedBox(
      height: height,
      child: services.when(
        skipLoadingOnReload: true,
        loading: () => const Shimmer(
          child: _CarouselList(
            children: [
              ServiceCardSkeleton(),
              ServiceCardSkeleton(),
            ],
          ),
        ),
        error: (error, _) => _CompactMessage(
          icon: Icons.cloud_off_outlined,
          title: l10n.errorTitle,
          message: errorMessage(context, error),
          actionLabel: l10n.retry,
          onAction: () => ref.invalidate(servicesProvider),
        ),
        data: (list) => list.isEmpty
            ? _CompactMessage(
                icon: Icons.cleaning_services_outlined,
                title: l10n.noServicesTitle,
                message: l10n.noServicesBody,
              )
            : _CarouselList(
                children: [
                  for (final service in list)
                    ServiceCard(
                      service: service,
                      onTap: () => onSelected(service),
                    ),
                ],
              ),
      ),
    );
  }
}

class _CarouselList extends StatelessWidget {
  const _CarouselList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 12),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (_, index) => children[index],
    );
  }
}

/// Like `EmptyState`, but small enough to fit the carousel's height.
class _CompactMessage extends StatelessWidget {
  const _CompactMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: TidyColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: TidyColors.primary),
            ),
            const SizedBox(height: 12),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(color: TidyColors.muted),
            ),
            if (actionLabel != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ),
      ),
    );
  }
}
