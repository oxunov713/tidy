// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  fromPrice: (json['from_price'] as num).toInt(),
  minutes: (json['minutes'] as num).toInt(),
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'title': instance.title,
  'from_price': instance.fromPrice,
  'minutes': instance.minutes,
};

_Extra _$ExtraFromJson(Map<String, dynamic> json) => _Extra(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$ExtraToJson(_Extra instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'title': instance.title,
  'price': instance.price,
};

_AdminService _$AdminServiceFromJson(Map<String, dynamic> json) =>
    _AdminService(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      basePrice: (json['base_price'] as num).toInt(),
      perBedroom: (json['per_bedroom'] as num).toInt(),
      perBathroom: (json['per_bathroom'] as num).toInt(),
      baseMinutes: (json['base_minutes'] as num).toInt(),
      minutesPerRoom: (json['minutes_per_room'] as num).toInt(),
      isActive: json['is_active'] as bool,
      sortOrder: (json['sort_order'] as num).toInt(),
    );

Map<String, dynamic> _$AdminServiceToJson(_AdminService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'base_price': instance.basePrice,
      'per_bedroom': instance.perBedroom,
      'per_bathroom': instance.perBathroom,
      'base_minutes': instance.baseMinutes,
      'minutes_per_room': instance.minutesPerRoom,
      'is_active': instance.isActive,
      'sort_order': instance.sortOrder,
    };

_ServiceUpdate _$ServiceUpdateFromJson(Map<String, dynamic> json) =>
    _ServiceUpdate(
      title: json['title'] as String,
      basePrice: (json['base_price'] as num).toInt(),
      perBedroom: (json['per_bedroom'] as num).toInt(),
      perBathroom: (json['per_bathroom'] as num).toInt(),
      baseMinutes: (json['base_minutes'] as num).toInt(),
      minutesPerRoom: (json['minutes_per_room'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$ServiceUpdateToJson(_ServiceUpdate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'base_price': instance.basePrice,
      'per_bedroom': instance.perBedroom,
      'per_bathroom': instance.perBathroom,
      'base_minutes': instance.baseMinutes,
      'minutes_per_room': instance.minutesPerRoom,
      'is_active': instance.isActive,
    };
