// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Address _$AddressFromJson(Map<String, dynamic> json) => _Address(
  id: json['id'] as String,
  line1: json['line1'] as String,
  city: json['city'] as String,
  postcode: json['postcode'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  line2: json['line2'] as String? ?? '',
  accessNotes: json['access_notes'] as String? ?? '',
);

Map<String, dynamic> _$AddressToJson(_Address instance) => <String, dynamic>{
  'id': instance.id,
  'line1': instance.line1,
  'city': instance.city,
  'postcode': instance.postcode,
  'lat': instance.lat,
  'lng': instance.lng,
  'line2': instance.line2,
  'access_notes': instance.accessNotes,
};

_AddressInput _$AddressInputFromJson(Map<String, dynamic> json) =>
    _AddressInput(
      line1: json['line1'] as String,
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      line2: json['line2'] as String? ?? '',
      accessNotes: json['access_notes'] as String? ?? '',
    );

Map<String, dynamic> _$AddressInputToJson(_AddressInput instance) =>
    <String, dynamic>{
      'line1': instance.line1,
      'city': instance.city,
      'postcode': instance.postcode,
      'lat': instance.lat,
      'lng': instance.lng,
      'line2': instance.line2,
      'access_notes': instance.accessNotes,
    };
