// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingEvent _$BookingEventFromJson(Map<String, dynamic> json) =>
    _BookingEvent(
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      at: DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$BookingEventToJson(_BookingEvent instance) =>
    <String, dynamic>{
      'status': _$BookingStatusEnumMap[instance.status]!,
      'at': instance.at.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.assigned: 'assigned',
  BookingStatus.onTheWay: 'on_the_way',
  BookingStatus.inProgress: 'in_progress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

_CleanerLocation _$CleanerLocationFromJson(Map<String, dynamic> json) =>
    _CleanerLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
      at: json['at'] == null ? null : DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$CleanerLocationToJson(_CleanerLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'eta_minutes': instance.etaMinutes,
      'at': instance.at?.toIso8601String(),
    };

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  start: DateTime.parse(json['start'] as String),
  code: json['code'] as String? ?? '',
  serviceId: json['service_id'] as String? ?? '',
  serviceTitle: json['service_title'] as String? ?? '',
  bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 1,
  bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 1,
  frequency:
      $enumDecodeNullable(_$FrequencyEnumMap, json['frequency']) ??
      Frequency.once,
  end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
  minutes: (json['minutes'] as num?)?.toInt() ?? 0,
  subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
  discount: (json['discount'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  extras:
      (json['extras'] as List<dynamic>?)
          ?.map((e) => Extra.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Extra>[],
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
  cleaner: json['cleaner'] == null
      ? null
      : Cleaner.fromJson(json['cleaner'] as Map<String, dynamic>),
  client: json['client'] == null
      ? null
      : ClientSummary.fromJson(json['client'] as Map<String, dynamic>),
  cleanerLocation: json['cleaner_location'] == null
      ? null
      : CleanerLocation.fromJson(
          json['cleaner_location'] as Map<String, dynamic>,
        ),
  events:
      (json['events'] as List<dynamic>?)
          ?.map((e) => BookingEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BookingEvent>[],
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'start': instance.start.toIso8601String(),
  'code': instance.code,
  'service_id': instance.serviceId,
  'service_title': instance.serviceTitle,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'end': instance.end?.toIso8601String(),
  'minutes': instance.minutes,
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'total': instance.total,
  'extras': instance.extras.map((e) => e.toJson()).toList(),
  'address': instance.address?.toJson(),
  'cleaner': instance.cleaner?.toJson(),
  'client': instance.client?.toJson(),
  'cleaner_location': instance.cleanerLocation?.toJson(),
  'events': instance.events.map((e) => e.toJson()).toList(),
};

const _$FrequencyEnumMap = {
  Frequency.once: 'once',
  Frequency.weekly: 'weekly',
  Frequency.fortnightly: 'fortnightly',
};

_BookingPage _$BookingPageFromJson(Map<String, dynamic> json) => _BookingPage(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Booking>[],
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$BookingPageToJson(_BookingPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_CreateBookingRequest _$CreateBookingRequestFromJson(
  Map<String, dynamic> json,
) => _CreateBookingRequest(
  serviceId: json['service_id'] as String,
  bedrooms: (json['bedrooms'] as num).toInt(),
  bathrooms: (json['bathrooms'] as num).toInt(),
  addressId: json['address_id'] as String,
  start: DateTime.parse(json['start'] as String),
  extraIds:
      (json['extra_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  frequency:
      $enumDecodeNullable(_$FrequencyEnumMap, json['frequency']) ??
      Frequency.once,
  cleanerId: json['cleaner_id'] as String?,
);

Map<String, dynamic> _$CreateBookingRequestToJson(
  _CreateBookingRequest instance,
) => <String, dynamic>{
  'service_id': instance.serviceId,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'address_id': instance.addressId,
  'start': instance.start.toIso8601String(),
  'extra_ids': instance.extraIds,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'cleaner_id': instance.cleanerId,
};

_PaymentIntentInfo _$PaymentIntentInfoFromJson(Map<String, dynamic> json) =>
    _PaymentIntentInfo(clientSecret: json['client_secret'] as String);

Map<String, dynamic> _$PaymentIntentInfoToJson(_PaymentIntentInfo instance) =>
    <String, dynamic>{'client_secret': instance.clientSecret};

_BookingCreated _$BookingCreatedFromJson(Map<String, dynamic> json) =>
    _BookingCreated(
      booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
      payment: PaymentIntentInfo.fromJson(
        json['payment'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BookingCreatedToJson(_BookingCreated instance) =>
    <String, dynamic>{
      'booking': instance.booking.toJson(),
      'payment': instance.payment.toJson(),
    };

_ReviewRequest _$ReviewRequestFromJson(Map<String, dynamic> json) =>
    _ReviewRequest(
      rating: (json['rating'] as num).toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      comment: json['comment'] as String? ?? '',
      tip: (json['tip'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReviewRequestToJson(_ReviewRequest instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'tags': instance.tags,
      'comment': instance.comment,
      'tip': instance.tip,
    };

_AdminBookingPatch _$AdminBookingPatchFromJson(Map<String, dynamic> json) =>
    _AdminBookingPatch(
      cleanerId: json['cleaner_id'] as String?,
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AdminBookingPatchToJson(_AdminBookingPatch instance) =>
    <String, dynamic>{
      'cleaner_id': instance.cleanerId,
      'status': _$BookingStatusEnumMap[instance.status],
    };
