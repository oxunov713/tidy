// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaner_work.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'booking': instance.booking.toJson(),
  'expires_at': instance.expiresAt.toIso8601String(),
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
  amount: (json['amount'] as num).toInt(),
  code: json['code'] as String? ?? '',
  serviceTitle: json['service_title'] as String? ?? '',
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
);

Map<String, dynamic> _$EarningsJobToJson(_EarningsJob instance) =>
    <String, dynamic>{
      'booking_id': instance.bookingId,
      'amount': instance.amount,
      'code': instance.code,
      'service_title': instance.serviceTitle,
      'completed_at': instance.completedAt?.toIso8601String(),
    };

_Earnings _$EarningsFromJson(Map<String, dynamic> json) => _Earnings(
  total: (json['total'] as num).toInt(),
  jobs: (json['jobs'] as num?)?.toInt() ?? 0,
  tips: (json['tips'] as num?)?.toInt() ?? 0,
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
  'total': instance.total,
  'jobs': instance.jobs,
  'tips': instance.tips,
  'days': instance.days.map((e) => e.toJson()).toList(),
  'recent': instance.recent.map((e) => e.toJson()).toList(),
};
