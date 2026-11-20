// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaner_work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  distanceKm: (json['distance_km'] as num).toDouble(),
  postcode: json['postcode'] as String,
  city: json['city'] as String,
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'booking': instance.booking.toJson(),
  'expires_at': instance.expiresAt.toIso8601String(),
  'distance_km': instance.distanceKm,
  'postcode': instance.postcode,
  'city': instance.city,
};

_AvailabilityWindow _$AvailabilityWindowFromJson(Map<String, dynamic> json) =>
    _AvailabilityWindow(
      weekday: (json['weekday'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );

Map<String, dynamic> _$AvailabilityWindowToJson(_AvailabilityWindow instance) =>
    <String, dynamic>{
      'weekday': instance.weekday,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };

_EarningsDay _$EarningsDayFromJson(Map<String, dynamic> json) => _EarningsDay(
  date: json['date'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$EarningsDayToJson(_EarningsDay instance) =>
    <String, dynamic>{'date': instance.date, 'amount': instance.amount};

_EarningsJob _$EarningsJobFromJson(Map<String, dynamic> json) => _EarningsJob(
  bookingId: json['booking_id'] as String,
  code: json['code'] as String,
  serviceTitle: json['service_title'] as String,
  start: DateTime.parse(json['start'] as String),
  minutes: (json['minutes'] as num).toInt(),
  amount: (json['amount'] as num).toInt(),
  tip: (json['tip'] as num).toInt(),
);

Map<String, dynamic> _$EarningsJobToJson(_EarningsJob instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'code': instance.code,
      'service_title': instance.serviceTitle,
      'start': instance.start.toIso8601String(),
      'minutes': instance.minutes,
      'amount': instance.amount,
      'tip': instance.tip,
    };

_Earnings _$EarningsFromJson(Map<String, dynamic> json) => _Earnings(
  period: json['period'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  total: (json['total'] as num).toInt(),
  tips: (json['tips'] as num).toInt(),
  jobs: (json['jobs'] as num).toInt(),
  minutes: (json['minutes'] as num).toInt(),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => EarningsDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EarningsDay>[],
  recent:
      (json['recent'] as List<dynamic>?)
          ?.map((e) => EarningsJob.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EarningsJob>[],
);

Map<String, dynamic> _$EarningsToJson(_Earnings instance) => <String, dynamic>{
  'period': instance.period,
  'from': instance.from,
  'to': instance.to,
  'total': instance.total,
  'tips': instance.tips,
  'jobs': instance.jobs,
  'minutes': instance.minutes,
  'days': instance.days.map((e) => e.toJson()).toList(),
  'recent': instance.recent.map((e) => e.toJson()).toList(),
};
