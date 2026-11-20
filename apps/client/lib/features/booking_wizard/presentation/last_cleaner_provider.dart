import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_core/tidy_core.dart';

part 'last_cleaner_provider.g.dart';

/// The cleaner of the user's most recent completed booking, for "book Sarah
/// again". Null for someone who has not had a clean yet.
@riverpod
Future<CleanerCard?> lastCleaner(Ref ref) async {
  final past = await ref.watch(
    bookingsListProvider(BookingScope.past).future,
  );
  final last = past.items
      .where((b) => b.cleanerId != null && b.status == BookingStatus.completed)
      .firstOrNull;
  if (last == null) return null;
  final details = await ref.watch(bookingDetailsProvider(last.id).future);
  return details.cleaner;
}
