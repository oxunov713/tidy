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
          booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
          expiresAt: DateTime.parse(json['expires_at'] as String),
        ),
        'offer.gone' => OfferWithdrawn(json['booking_id'] as String),
        'message.new' => MessageReceived(
          bookingId: json['booking_id'] as String,
          message: Message.fromJson(
            json['message'] as Map<String, dynamic>,
          ),
        ),
        'subscribed' => RoomSubscribed(json['room'] as String),
        'unsubscribed' => RoomUnsubscribed(
          json['room'] as String,
          reason: json['reason'] as String?,
        ),
        'error' => RealtimeError(
          code: json['code'] as String,
          message: json['message'] as String,
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

/// `offer.new`, cleaners only, in the `cleaner:offers` room. The street
/// address is not part of it; call `GET /cleaner/offers` for distance and
/// area.
final class OfferReceived extends RealtimeEvent {
  const OfferReceived({required this.booking, required this.expiresAt});

  final Booking booking;
  final DateTime expiresAt;
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

/// `subscribed`: the server accepted a `subscribe` for [room].
final class RoomSubscribed extends RealtimeEvent {
  const RoomSubscribed(this.room);

  final String room;
}

/// `unsubscribed`: answer to `unsubscribe`, sent even if the room was not
/// joined. The server also sends it on its own, with [reason]
/// `access_revoked`, when the user loses access to the room (the booking was
/// reassigned or cancelled, the cleaner was suspended). `RealtimeClient`
/// has already dropped the room by the time this event is delivered.
final class RoomUnsubscribed extends RealtimeEvent {
  const RoomUnsubscribed(this.room, {this.reason});

  static const accessRevokedReason = 'access_revoked';

  final String room;

  /// Set when the server ended the subscription, not the client.
  final String? reason;

  bool get accessRevoked => reason == accessRevokedReason;
}

/// Not a server message: the socket is back after it was lost (or after the
/// first attempt failed) and the rooms are joined again. Anything that
/// happened in the meantime was missed, so refetch what the screen shows.
final class Reconnected extends RealtimeEvent {
  const Reconnected();
}

/// `error`: the server refused a message, for example a `subscribe` to
/// someone else's booking (`forbidden`) or a `location` while the booking is
/// neither assigned nor on the way (`invalid_transition`). The socket stays
/// open.
final class RealtimeError extends RealtimeEvent {
  const RealtimeError({required this.code, required this.message});

  /// Same codes as the REST errors, e.g. `forbidden`, `invalid_request`.
  final String code;
  final String message;
}

final class UnknownRealtimeEvent extends RealtimeEvent {
  const UnknownRealtimeEvent(this.type, this.raw);

  final String type;
  final Map<String, dynamic> raw;
}
