// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingEvent _$BookingEventFromJson(Map<String, dynamic> json) =>
    _BookingEvent(
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      at: DateTime.parse(json['at'] as String),
      actorId: json['actor_id'] as String?,
    );

Map<String, dynamic> _$BookingEventToJson(_BookingEvent instance) =>
    <String, dynamic>{
      'status': _$BookingStatusEnumMap[instance.status]!,
      'at': instance.at.toIso8601String(),
      'actor_id': instance.actorId,
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
      at: DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$CleanerLocationToJson(_CleanerLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'at': instance.at.toIso8601String(),
    };

_BookingExtra _$BookingExtraFromJson(Map<String, dynamic> json) =>
    _BookingExtra(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$BookingExtraToJson(_BookingExtra instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
    };

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  code: json['code'] as String,
  clientId: json['client_id'] as String,
  serviceId: json['service_id'] as String,
  serviceTitle: json['service_title'] as String,
  addressId: json['address_id'] as String,
  bedrooms: (json['bedrooms'] as num).toInt(),
  bathrooms: (json['bathrooms'] as num).toInt(),
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  subtotal: (json['subtotal'] as num).toInt(),
  discount: (json['discount'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  cleanerPayout: (json['cleaner_payout'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  cleanerId: json['cleaner_id'] as String?,
  requestedCleanerId: json['requested_cleaner_id'] as String?,
  planId: json['plan_id'] as String?,
  extras:
      (json['extras'] as List<dynamic>?)
          ?.map((e) => BookingExtra.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BookingExtra>[],
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'client_id': instance.clientId,
  'service_id': instance.serviceId,
  'service_title': instance.serviceTitle,
  'address_id': instance.addressId,
  'bedrooms': instance.bedrooms,
  'bathrooms': instance.bathrooms,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'status': _$BookingStatusEnumMap[instance.status]!,
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'total': instance.total,
  'cleaner_payout': instance.cleanerPayout,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'cleaner_id': instance.cleanerId,
  'requested_cleaner_id': instance.requestedCleanerId,
  'plan_id': instance.planId,
  'extras': instance.extras.map((e) => e.toJson()).toList(),
};

const _$FrequencyEnumMap = {
  Frequency.once: 'once',
  Frequency.weekly: 'weekly',
  Frequency.fortnightly: 'fortnightly',
};

_CleanerCard _$CleanerCardFromJson(Map<String, dynamic> json) => _CleanerCard(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  rating: (json['rating'] as num).toDouble(),
  ratingCount: (json['rating_count'] as num).toInt(),
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$CleanerCardToJson(_CleanerCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'avatar_url': instance.avatarUrl,
    };

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  bookingId: json['booking_id'] as String,
  cleanerId: json['cleaner_id'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  tip: (json['tip'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'booking_id': instance.bookingId,
  'cleaner_id': instance.cleanerId,
  'rating': instance.rating,
  'comment': instance.comment,
  'tip': instance.tip,
  'created_at': instance.createdAt.toIso8601String(),
  'tags': instance.tags,
};

_BookingPage _$BookingPageFromJson(Map<String, dynamic> json) => _BookingPage(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Booking>[],
  nextCursor: json['next_cursor'] as String? ?? '',
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
  'start': _utc(instance.start),
  'extra_ids': instance.extraIds,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'cleaner_id': ?instance.cleanerId,
};

_PaymentIntentInfo _$PaymentIntentInfoFromJson(Map<String, dynamic> json) =>
    _PaymentIntentInfo(
      clientSecret: json['client_secret'] as String,
      kind:
          $enumDecodeNullable(_$PaymentKindEnumMap, json['kind']) ??
          PaymentKind.payment,
    );

Map<String, dynamic> _$PaymentIntentInfoToJson(_PaymentIntentInfo instance) =>
    <String, dynamic>{
      'client_secret': instance.clientSecret,
      'kind': _$PaymentKindEnumMap[instance.kind]!,
    };

const _$PaymentKindEnumMap = {
  PaymentKind.payment: 'payment',
  PaymentKind.setup: 'setup',
};

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

_Cancellation _$CancellationFromJson(Map<String, dynamic> json) =>
    _Cancellation(
      booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
      refunded: json['refunded'] as bool,
      planEnded: json['plan_ended'] as bool? ?? false,
    );

Map<String, dynamic> _$CancellationToJson(_Cancellation instance) =>
    <String, dynamic>{
      'booking': instance.booking.toJson(),
      'refunded': instance.refunded,
      'plan_ended': instance.planEnded,
    };

_Plan _$PlanFromJson(Map<String, dynamic> json) => _Plan(
  id: json['id'] as String,
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
  nextRunOn: _day(json['next_run_on'] as String),
  serviceTitle: json['service_title'] as String,
  startTime: json['start_time'] as String,
  addressId: json['address_id'] as String,
);

Map<String, dynamic> _$PlanToJson(_Plan instance) => <String, dynamic>{
  'id': instance.id,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'next_run_on': _dayToJson(instance.nextRunOn),
  'service_title': instance.serviceTitle,
  'start_time': instance.startTime,
  'address_id': instance.addressId,
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
      'cleaner_id': ?instance.cleanerId,
      'status': ?_$BookingStatusEnumMap[instance.status],
    };
