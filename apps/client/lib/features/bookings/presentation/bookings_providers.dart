import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/bookings/data/booking_repository_impl.dart';
import 'package:tidy_client/features/bookings/domain/booking_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'bookings_providers.freezed.dart';
part 'bookings_providers.g.dart';

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(Ref ref) =>
    BookingRepositoryImpl(api: ref.watch(bookingApiProvider));

/// The pages of one list loaded so far.
@freezed
abstract class PagedBookings with _$PagedBookings {
  const factory PagedBookings({
    @Default(<Booking>[]) List<Booking> items,

    /// Empty on the last page.
    @Default('') String nextCursor,
    @Default(false) bool loadingMore,

    /// Set when fetching the next page failed; the loaded items stay.
    Object? loadMoreError,
  }) = _PagedBookings;

  const PagedBookings._();

  bool get hasMore => nextCursor.isNotEmpty;
}

/// Upcoming or past bookings, fetched page by page with the server's cursor.
@Riverpod(keepAlive: true)
class BookingsList extends _$BookingsList {
  @override
  Future<PagedBookings> build(BookingScope scope) async {
    ref.watch(currentUserIdProvider);
    final page = await ref.watch(bookingRepositoryProvider).list(scope: scope);
    return PagedBookings(items: page.items, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(
      current.copyWith(loadingMore: true, loadMoreError: null),
    );
    try {
      final page = await ref
          .read(bookingRepositoryProvider)
          .list(scope: scope, cursor: current.nextCursor);
      state = AsyncData(
        PagedBookings(
          items: [...current.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
      );
    } on Object catch (error) {
      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
  }

  /// Reloads from the first page; the old list stays visible meanwhile.
  Future<void> refresh() => ref.refresh(bookingsListProvider(scope).future);

  /// Swaps in a booking that changed (cancelled, status update).
  void replace(Booking booking) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [
          for (final b in current.items)
            if (b.id == booking.id) booking else b,
        ],
      ),
    );
  }
}

/// One booking with its address, cleaner, events and review.
@riverpod
Future<BookingDetails> bookingDetails(Ref ref, String id) =>
    ref.watch(bookingRepositoryProvider).details(id);

/// The booking to show on Home as "current": a cleaner is on the way, working,
/// or has accepted. Null when there is none.
@riverpod
Booking? activeBooking(Ref ref) {
  final upcoming = ref.watch(bookingsListProvider(BookingScope.upcoming)).value;
  if (upcoming == null) return null;
  const rank = {
    BookingStatus.onTheWay: 0,
    BookingStatus.inProgress: 1,
    BookingStatus.assigned: 2,
  };
  final candidates =
      upcoming.items.where((b) => rank.containsKey(b.status)).toList()
        ..sort((a, b) {
          final byStatus = rank[a.status]!.compareTo(rank[b.status]!);
          return byStatus != 0 ? byStatus : a.start.compareTo(b.start);
        });
  return candidates.firstOrNull;
}
