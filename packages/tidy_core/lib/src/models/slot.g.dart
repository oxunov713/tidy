// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Slot _$SlotFromJson(Map<String, dynamic> json) => _Slot(
  start: DateTime.parse(json['start'] as String),
  available: json['available'] as bool,
);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'available': instance.available,
};

_SlotsResponse _$SlotsResponseFromJson(Map<String, dynamic> json) =>
    _SlotsResponse(
      date: json['date'] as String,
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => Slot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Slot>[],
    );

Map<String, dynamic> _$SlotsResponseToJson(_SlotsResponse instance) =>
    <String, dynamic>{
      'date': instance.date,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };
