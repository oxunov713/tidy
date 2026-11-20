import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/start_booking.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/catalog/presentation/catalog_providers.dart';
import 'package:tidy_client/features/home/presentation/widgets/all_services_sheet.dart';
import 'package:tidy_client/features/home/presentation/widgets/current_booking_card.dart';
import 'package:tidy_client/features/home/presentation/widgets/home_header.dart';
import 'package:tidy_client/features/home/presentation/widgets/promo_banner.dart';
import 'package:tidy_client/features/home/presentation/widgets/services_carousel.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider);
    final active = ref.watch(activeBookingProvider);

    final firstName = user?.fullName.trim().split(RegExp(r'\s+')).first ?? '';
    final greeting = firstName.isEmpty
        ? l10n.homeGreetingAnonymous
        : l10n.homeGreeting(firstName);

    Future<void> refresh() async {
      ref.invalidate(servicesProvider);
      await Future.wait([
        ref.refresh(addressesProvider.future),
        ref
            .read(bookingsListProvider(BookingScope.upcoming).notifier)
            .refresh(),
      ]);
    }

    Future<void> openDeepClean() async {
      final services = await ref.read(servicesProvider.future);
      final deep = services.where((s) => s.slug == 'deep').firstOrNull;
      if (deep != null && context.mounted) {
        await startBooking(context, ref, deep);
      }
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: HomeHeader(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Text(
                greeting,
                style: text.headlineMedium?.copyWith(
                  fontSize: 28,
                  height: 1.15,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: PromoBanner(onTap: openDeepClean),
            ),
            SectionHeader(
              title: l10n.servicesTitle,
              actionLabel: l10n.seeAll,
              onAction: () => showAllServicesSheet(
                context,
                onSelected: (service) => startBooking(context, ref, service),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            ),
            ServicesCarousel(
              onSelected: (service) => startBooking(context, ref, service),
            ),
            if (active != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: CurrentBookingCard(booking: active),
              ),
          ],
        ),
      ),
    );
  }
}
