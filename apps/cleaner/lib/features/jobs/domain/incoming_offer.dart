import 'package:tidy_core/tidy_core.dart';

/// A job offered to this cleaner. The WebSocket only carries the booking and
/// the expiry; distance and area come from `GET /cleaner/offers`, so they are
/// null until that has loaded.
class IncomingOffer {
  const IncomingOffer({
    required this.booking,
    required this.expiresAt,
    this.distanceKm,
    this.postcode,
    this.city,
  });

  factory IncomingOffer.fromApi(Offer offer) => IncomingOffer(
    booking: offer.booking,
    expiresAt: offer.expiresAt,
    distanceKm: offer.distanceKm,
    postcode: offer.postcode,
    city: offer.city,
  );

  final Booking booking;
  final DateTime expiresAt;
  final double? distanceKm;
  final String? postcode;
  final String? city;

  String get id => booking.id;

  bool isExpired(DateTime now) => !expiresAt.isAfter(now);

  /// Fills in what [other] knows and this offer does not.
  IncomingOffer mergedWith(IncomingOffer other) => IncomingOffer(
    booking: other.booking,
    expiresAt: other.expiresAt,
    distanceKm: other.distanceKm ?? distanceKm,
    postcode: other.postcode ?? postcode,
    city: other.city ?? city,
  );
}
