import 'dart:convert';

import 'package:tidy_core/src/models/models.dart';

/// Server-to-client WebSocket messages, see "WebSocket" in API.md.
sealed class RealtimeEvent {
  const RealtimeEvent();

  /// Parses one text frame. Returns null for frames that are not valid JSON
  /// objects with a `type`; unknown types become [UnknownRealtimeEvent] so a
  /// newer server never breaks an older app.
  static RealtimeEvent? parse(String frame) {
    final Object? decoded;
    try {
      decoded = jsonDecode(frame);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;
    final json = decoded;
    final type = json['type'];
    if (type is! String) return null;

    try {
      return switch (type) {
        'booking.status' => BookingStatusChanged(
          bookingId: json['booking_id'] as String,
          status: BookingStatus.values.firstWhere(
            (s) => s.wireName == json['status'],
          ),
          at: DateTime.parse(json['at'] as String),
        ),
        'cleaner.location' => CleanerLocationUpdated(
          bookingId: json['booking_id'] as String,
          lat: (json['lat'] as num).toDouble(),
          lng: (json['lng'] as num).toDouble(),
          etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
        ),
        'offer.new' => OfferReceived(
          Offer(
            booking: Booking.fromJson(
              json['booking'] as Map<String, dynamic>,
            ),
            expiresAt: DateTime.parse(json['expires_at'] as String),
          ),
        ),
        'offer.gone' => OfferWithdrawn(json['booking_id'] as String),
        'message.new' => MessageReceived(
          bookingId: json['booking_id'] as String,
          message: Message.fromJson(
            json['message'] as Map<String, dynamic>,
          ),
        ),
        _ => UnknownRealtimeEvent(type, json),
      };
    } on Object {
      // A known type with a body we cannot read: drop it rather than crash
      // the stream.
      return null;
    }
  }
}

/// `booking.status`
final class BookingStatusChanged extends RealtimeEvent {
  const BookingStatusChanged({
    required this.bookingId,
    required this.status,
    required this.at,
  });

  final String bookingId;
  final BookingStatus status;
  final DateTime at;
}

/// `cleaner.location`
final class CleanerLocationUpdated extends RealtimeEvent {
  const CleanerLocationUpdated({
    required this.bookingId,
    required this.lat,
    required this.lng,
    this.etaMinutes,
  });

  final String bookingId;
  final double lat;
  final double lng;
  final int? etaMinutes;
}

/// `offer.new`, cleaners only.
final class OfferReceived extends RealtimeEvent {
  const OfferReceived(this.offer);

  final Offer offer;
}

/// `offer.gone`: the offer was taken by someone else or expired.
final class OfferWithdrawn extends RealtimeEvent {
  const OfferWithdrawn(this.bookingId);

  final String bookingId;
}

/// `message.new`
final class MessageReceived extends RealtimeEvent {
  const MessageReceived({required this.bookingId, required this.message});

  final String bookingId;
  final Message message;
}

final class UnknownRealtimeEvent extends RealtimeEvent {
  const UnknownRealtimeEvent(this.type, this.raw);

  final String type;
  final Map<String, dynamic> raw;
}
