import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_core/tidy_core.dart';

abstract interface class OffersRepository {
  Future<List<IncomingOffer>> open();

  /// Throws `SlotTakenException` or `OfferGoneException`.
  Future<Booking> accept(String bookingId);

  Future<void> decline(String bookingId);
}
