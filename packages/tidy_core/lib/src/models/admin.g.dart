// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => _AdminStats(
  bookings: (json['bookings'] as num).toInt(),
  revenue: (json['revenue'] as num).toInt(),
  cleanersOnline: (json['cleaners_online'] as num).toInt(),
  pendingApprovals: (json['pending_approvals'] as num).toInt(),
);

Map<String, dynamic> _$AdminStatsToJson(_AdminStats instance) =>
    <String, dynamic>{
      'bookings': instance.bookings,
      'revenue': instance.revenue,
      'cleaners_online': instance.cleanersOnline,
      'pending_approvals': instance.pendingApprovals,
    };
