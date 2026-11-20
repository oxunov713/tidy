import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tidy_admin/core/api_errors.dart';
import 'package:tidy_admin/core/formatting.dart';
import 'package:tidy_admin/core/labels.dart';
import 'package:tidy_admin/core/responsive.dart';
import 'package:tidy_admin/core/widgets/error_view.dart';
import 'package:tidy_admin/core/widgets/skeleton.dart';
import 'package:tidy_admin/features/bookings/presentation/booking_detail_view.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_table.dart';
import 'package:tidy_admin/features/bookings/presentation/stats_tiles.dart';
import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:tidy_ui/tidy_ui.dart';

/// Width from which a selected booking opens beside the list instead of
/// replacing it.
const double _splitMinWidth = 1360;
const double _panelWidth = 400;

class BookingsPage extends StatelessWidget {
  const BookingsPage({this.selectedId, super.key});

  /// The booking in the URL (`/bookings/:id`), if any.
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final id = selectedId;
    final width = MediaQuery.sizeOf(context).width;
    void close() => context.go('/bookings');

    if (id == null) return const BookingsList();
    if (width < _splitMinWidth) {
      return BookingDetailView(key: ValueKey(id), id: id, onClose: close);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: BookingsList(selectedId: id, compact: true)),
        SizedBox(
          width: _panelWidth + 32,
          child: Padding(
            padding: const EdgeInsets.only(right: 32, bottom: 32, top: 12),
            child: BookingDetailView(
              key: ValueKey(id),
              id: id,
              onClose: close,
              panel: true,
            ),
          ),
        ),
      ],
    );
  }
}

class BookingsList extends ConsumerStatefulWidget {
  const BookingsList({this.selectedId, this.compact = false, super.key});

  final String? selectedId;

  /// The details panel is open beside the list, so rows become cards.
  final bool compact;

  @override
  ConsumerState<BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends ConsumerState<BookingsList> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(bookingFilterControllerProvider).query;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    setState(() {});
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(bookingFilterControllerProvider.notifier).setQuery(value);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _search.clear();
    ref.read(bookingFilterControllerProvider.notifier).setQuery('');
    setState(() {});
  }

  void _refresh() {
    ref
      ..invalidate(bookingsControllerProvider)
      ..invalidate(statsControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filter = ref.watch(bookingFilterControllerProvider);
    final bookings = ref.watch(bookingsControllerProvider);
    final compact = ScreenSize.of(context) == ScreenSize.phone;

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        final data = bookings.value;
        if (n.metrics.axis == Axis.vertical &&
            n.metrics.extentAfter < 240 &&
            data != null &&
            data.hasMore &&
            data.loadMoreError == null) {
          unawaited(ref.read(bookingsControllerProvider.notifier).loadMore());
        }
        return false;
      },
      child: ListView(
        padding: pagePadding(context),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatLongDate(context, DateTime.now()),
                  style: const TextStyle(color: TidyColors.muted),
                ),
              ),
              IconButton(
                tooltip: l10n.refresh,
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: TidySpacing.md),
          const StatsTiles(),
          const SizedBox(height: TidySpacing.xl),
          TidyCard(
            padding: EdgeInsets.all(compact ? TidySpacing.md : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('booking-search'),
                  controller: _search,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchBookingsHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.clearSearch,
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                const SizedBox(height: TidySpacing.md),
                _StatusChips(selected: filter.status),
                const SizedBox(height: TidySpacing.sm),
                _Results(
                  bookings: bookings,
                  filtered: filter.status != null || filter.query.isNotEmpty,
                  selectedId: widget.selectedId,
                  compact: widget.compact,
                  onClearFilters: _clearSearch,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChips extends ConsumerWidget {
  const _StatusChips({required this.selected});

  final BookingStatus? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    void pick(BookingStatus? status) =>
        ref.read(bookingFilterControllerProvider.notifier).setStatus(status);
    return Wrap(
      spacing: TidySpacing.sm,
      runSpacing: TidySpacing.sm,
      children: [
        TidyChip(
          label: l10n.filterAll,
          selected: selected == null,
          onSelected: (_) => pick(null),
        ),
        for (final status in BookingStatus.values)
          TidyChip(
            label: statusLabel(l10n, status),
            selected: selected == status,
            onSelected: (_) => pick(selected == status ? null : status),
          ),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({
    required this.bookings,
    required this.filtered,
    required this.selectedId,
    required this.compact,
    required this.onClearFilters,
  });

  final AsyncValue<BookingsState> bookings;
  final bool filtered;
  final String? selectedId;
  final bool compact;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(bookingsControllerProvider.notifier);

    if (bookings.hasError && !bookings.isLoading) {
      return ErrorView(
        error: bookings.error!,
        onRetry: () => ref.invalidate(bookingsControllerProvider),
      );
    }
    final data = bookings.value;
    if (data == null) return const _LoadingRows();

    if (data.items.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_outlined,
        title: l10n.bookingsEmptyTitle,
        message: filtered ? l10n.bookingsEmptyFiltered : l10n.bookingsEmpty,
        actionLabel: filtered ? l10n.clearFilters : null,
        onAction: filtered
            ? () {
                ref.read(bookingFilterControllerProvider.notifier)
                  ..setStatus(null)
                  ..setQuery('');
                onClearFilters();
              }
            : null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // A refetch (filter change, refresh) keeps the old rows on screen.
        SizedBox(
          height: 3,
          child: bookings.isLoading
              ? const LinearProgressIndicator(minHeight: 3)
              : null,
        ),
        BookingsTable(
          items: data.items,
          selectedId: selectedId,
          forceCards: compact,
          onSelect: (row) => context.go('/bookings/${row.booking.id}'),
        ),
        _LoadMoreFooter(
          state: data,
          onLoadMore: controller.loadMore,
        ),
      ],
    );
  }
}

/// "Load more" button, with the error from the last attempt. Scrolling near
/// the end of the page loads the next page by itself (see [BookingsList]).
class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.state, required this.onLoadMore});

  final BookingsState state;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!state.hasMore) return const SizedBox(height: TidySpacing.sm);

    final error = state.loadMoreError;
    return Padding(
      padding: const EdgeInsets.only(top: TidySpacing.md),
      child: Column(
        children: [
          if (error != null) ...[
            ErrorBanner(message: errorText(l10n, error)),
            const SizedBox(height: TidySpacing.sm),
          ],
          if (state.loadingMore)
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else
            TidyButton(
              label: error != null ? l10n.retry : l10n.loadMore,
              variant: TidyButtonVariant.ghost,
              expand: false,
              onPressed: () => unawaited(onLoadMore()),
            ),
        ],
      ),
    );
  }
}

class _LoadingRows extends StatelessWidget {
  const _LoadingRows();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).loading,
      child: Column(
        children: [
          for (var i = 0; i < 6; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Row(
                children: [
                  Skeleton(width: 64),
                  SizedBox(width: 24),
                  Expanded(child: Skeleton()),
                  SizedBox(width: 24),
                  Expanded(child: Skeleton()),
                  SizedBox(width: 24),
                  Skeleton(width: 70),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
