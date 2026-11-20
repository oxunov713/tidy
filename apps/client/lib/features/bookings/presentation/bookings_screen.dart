import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/widgets/async_value_view.dart';
import 'package:tidy_client/core/widgets/segmented_tabs.dart';
import 'package:tidy_client/core/widgets/shimmer.dart';
import 'package:tidy_client/features/bookings/presentation/book_again.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_client/features/bookings/presentation/cancel_booking.dart';
import 'package:tidy_client/features/bookings/presentation/widgets/booking_card.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// The Bookings tab: Upcoming and Past, loaded page by page.
class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  BookingScope _scope = BookingScope.upcoming;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.navBookings,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 16),
            SegmentedTabs(
              labels: [l10n.upcoming, l10n.past],
              selectedIndex: _scope.index,
              onChanged: (i) => setState(() => _scope = BookingScope.values[i]),
            ),
            const SizedBox(height: 16),
            Expanded(child: BookingsListView(scope: _scope)),
          ],
        ),
      ),
    );
  }
}

/// One scope's list with pull to refresh, pagination, and the loading, empty
/// and error states.
class BookingsListView extends ConsumerWidget {
  const BookingsListView({required this.scope, super.key});

  final BookingScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = bookingsListProvider(scope);
    final value = ref.watch(provider);

    return AsyncValueView<PagedBookings>(
      value: value,
      onRetry: () => ref.invalidate(provider),
      loading: (_) => const Shimmer(
        child: Column(
          children: [
            BookingCardSkeleton(),
            SizedBox(height: 12),
            BookingCardSkeleton(),
            SizedBox(height: 12),
            BookingCardSkeleton(),
          ],
        ),
      ),
      data: (paged) {
        if (paged.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: ref.read(provider.notifier).refresh,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: scope == BookingScope.upcoming
                      ? EmptyState(
                          icon: Icons.event_available_outlined,
                          title: l10n.noUpcomingTitle,
                          message: l10n.noUpcomingBody,
                          actionLabel: l10n.bookAClean,
                          onAction: () => context.go(Routes.home),
                        )
                      : EmptyState(
                          icon: Icons.history,
                          title: l10n.noPastTitle,
                          message: l10n.noPastBody,
                        ),
                ),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: ref.read(provider.notifier).refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 320) {
                unawaited(ref.read(provider.notifier).loadMore());
              }
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: paged.items.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == paged.items.length) {
                  return _ListFooter(
                    paged: paged,
                    onRetry: ref.read(provider.notifier).loadMore,
                  );
                }
                final booking = paged.items[index];
                return BookingCard(
                  key: ValueKey(booking.id),
                  booking: booking,
                  onOpen: () => context.push(Routes.booking(booking.id)),
                  onTrack: () => context.push(Routes.track(booking.id)),
                  onRate: () => context.push(Routes.review(booking.id)),
                  onBookAgain: () => bookAgain(context, ref, booking),
                  onCancel: () => cancelBooking(context, ref, booking),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.paged, required this.onRetry});

  final PagedBookings paged;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (paged.loadMoreError != null) {
      return Center(
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.couldNotLoadMore),
        ),
      );
    }
    if (paged.loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: TidyColors.primary,
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 4);
  }
}
