import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/widgets/error_state.dart';
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
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(servicesProvider),
        ),
        data: (list) => list.isEmpty
            ? EmptyState(
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
