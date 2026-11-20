import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/bookings/data/api_bookings_repository.dart';
import 'package:tidy_admin/features/bookings/domain/bookings_repository.dart';
import 'package:tidy_core/tidy_core.dart';

part 'bookings_providers.g.dart';

@Riverpod(keepAlive: true)
BookingsRepository bookingsRepository(Ref ref) {
  // A new admin signing in must not see the previous one's cached lists.
  ref.watch(currentAdminIdProvider);
  return ApiBookingsRepository(
    admin: ref.watch(adminApiProvider),
    bookings: ref.watch(bookingApiProvider),
  );
}

/// How often the KPI tiles refresh. A provider so tests can shorten it.
@Riverpod(keepAlive: true)
Duration statsRefreshInterval(Ref ref) => const Duration(seconds: 30);

@Riverpod(keepAlive: true)
class StatsController extends _$StatsController {
  @override
  Future<AdminStats> build() {
    final timer = Timer.periodic(
      ref.watch(statsRefreshIntervalProvider),
      // Invalidating keeps the old numbers on screen while the new ones load.
      (_) => ref.invalidateSelf(),
    );
    ref.onDispose(timer.cancel);
    return ref.watch(bookingsRepositoryProvider).stats();
  }
}

@immutable
class BookingFilter {
  const BookingFilter({this.status, this.query = ''});

  final BookingStatus? status;
  final String query;

  @override
  bool operator ==(Object other) =>
      other is BookingFilter && other.status == status && other.query == query;

  @override
  int get hashCode => Object.hash(status, query);
}

@Riverpod(keepAlive: true)
class BookingFilterController extends _$BookingFilterController {
  @override
  BookingFilter build() => const BookingFilter();

  /// Null shows every status.
  void setStatus(BookingStatus? status) =>
      state = BookingFilter(status: status, query: state.query);

  void setQuery(String query) =>
      state = BookingFilter(status: state.status, query: query.trim());
}

class BookingsState {
  const BookingsState({
    required this.items,
    required this.nextCursor,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<AdminBooking> items;
  final String nextCursor;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasMore => nextCursor.isNotEmpty;

  BookingsState copyWith({
    List<AdminBooking>? items,
    String? nextCursor,
    bool? loadingMore,
    Object? loadMoreError,
    bool clearError = false,
  }) => BookingsState(
    items: items ?? this.items,
    nextCursor: nextCursor ?? this.nextCursor,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: clearError ? null : (loadMoreError ?? this.loadMoreError),
  );
}

/// The first page for the current filter, plus whatever "load more" added.
@Riverpod(keepAlive: true)
class BookingsController extends _$BookingsController {
  @override
  Future<BookingsState> build() async {
    final filter = ref.watch(bookingFilterControllerProvider);
    final page = await ref
        .watch(bookingsRepositoryProvider)
        .list(status: filter.status, query: filter.query);
    return BookingsState(items: page.items, nextCursor: page.nextCursor);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    final filter = ref.read(bookingFilterControllerProvider);
    state = AsyncData(current.copyWith(loadingMore: true, clearError: true));
    try {
      final page = await ref
          .read(bookingsRepositoryProvider)
          .list(
            status: filter.status,
            query: filter.query,
            cursor: current.nextCursor,
          );
      // The filter changed while this was in flight: build() already started
      // over, and this page belongs to the old list.
      if (!ref.mounted || ref.read(bookingFilterControllerProvider) != filter) {
        return;
      }
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          items: [...latest.items, ...page.items],
          nextCursor: page.nextCursor,
          loadingMore: false,
        ),
      );
    } on ApiException catch (e) {
      if (!ref.mounted || ref.read(bookingFilterControllerProvider) != filter) {
        return;
      }
      state = AsyncData(
        (state.value ?? current).copyWith(loadingMore: false, loadMoreError: e),
      );
    }
  }

  /// Patches one row after an admin action, so the list does not jump back
  /// to its first page.
  void applyUpdate(Booking updated, {String? cleanerName}) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        items: [
          for (final row in current.items)
            if (row.booking.id == updated.id)
              AdminBooking(
                booking: updated,
                clientName: row.clientName,
                clientPhone: row.clientPhone,
                cleanerName: cleanerName ?? row.cleanerName,
              )
            else
              row,
        ],
      ),
    );
  }
}

@riverpod
class BookingDetailController extends _$BookingDetailController {
  @override
  Future<BookingDetails> build(String id) =>
      ref.watch(bookingsRepositoryProvider).details(id);

  /// Throws the `ApiException` (for example `SlotTakenException`) so the
  /// dialog can show it inline.
  Future<void> reassign({
    required String cleanerId,
    required String cleanerName,
  }) async {
    final updated = await ref
        .read(bookingsRepositoryProvider)
        .reassign(id, cleanerId);
    _afterChange(updated, cleanerName: cleanerName);
  }

  Future<void> cancel() async {
    final updated = await ref.read(bookingsRepositoryProvider).cancel(id);
    _afterChange(updated);
  }

  void _afterChange(Booking updated, {String? cleanerName}) {
    ref
        .read(bookingsControllerProvider.notifier)
        .applyUpdate(
          updated,
          cleanerName: cleanerName,
        );
    ref
      ..invalidate(statsControllerProvider)
      ..invalidateSelf();
  }
}
