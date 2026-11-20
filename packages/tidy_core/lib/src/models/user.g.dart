// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String? ?? '',
  fullName: json['full_name'] as String? ?? '',
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  cleaner: json['cleaner'] == null
      ? null
      : Cleaner.fromJson(json['cleaner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'role': _$UserRoleEnumMap[instance.role]!,
  'phone': instance.phone,
  'full_name': instance.fullName,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'cleaner': instance.cleaner?.toJson(),
};

const _$UserRoleEnumMap = {
  UserRole.client: 'client',
  UserRole.cleaner: 'cleaner',
  UserRole.admin: 'admin',
};

_Cleaner _$CleanerFromJson(Map<String, dynamic> json) => _Cleaner(
  id: json['id'] as String,
  fullName: json['full_name'] as String? ?? '',
  phone: json['phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  status:
      $enumDecodeNullable(_$CleanerStatusEnumMap, json['status']) ??
      CleanerStatus.approved,
  bio: json['bio'] as String? ?? '',
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  online: json['online'] as bool? ?? false,
);

Map<String, dynamic> _$CleanerToJson(_Cleaner instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'avatar_url': instance.avatarUrl,
  'status': _$CleanerStatusEnumMap[instance.status]!,
  'bio': instance.bio,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
  'online': instance.online,
};

const _$CleanerStatusEnumMap = {
  CleanerStatus.pending: 'pending',
  CleanerStatus.approved: 'approved',
  CleanerStatus.suspended: 'suspended',
};

_ClientSummary _$ClientSummaryFromJson(Map<String, dynamic> json) =>
    _ClientSummary(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ClientSummaryToJson(_ClientSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
    };
