// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  phone: json['phone'] as String,
  fullName: json['full_name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  createdAt: DateTime.parse(json['created_at'] as String),
  email: json['email'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  cleaner: json['cleaner'] == null
      ? null
      : Cleaner.fromJson(json['cleaner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'full_name': instance.fullName,
  'role': _$UserRoleEnumMap[instance.role]!,
  'created_at': instance.createdAt.toIso8601String(),
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
  userId: json['user_id'] as String,
  status: $enumDecode(_$CleanerStatusEnumMap, json['status']),
  bio: json['bio'] as String,
  rating: (json['rating'] as num).toDouble(),
  ratingCount: (json['rating_count'] as num).toInt(),
  isOnline: json['is_online'] as bool,
  lastLat: (json['last_lat'] as num?)?.toDouble(),
  lastLng: (json['last_lng'] as num?)?.toDouble(),
  lastSeenAt: json['last_seen_at'] == null
      ? null
      : DateTime.parse(json['last_seen_at'] as String),
);

Map<String, dynamic> _$CleanerToJson(_Cleaner instance) => <String, dynamic>{
  'user_id': instance.userId,
  'status': _$CleanerStatusEnumMap[instance.status]!,
  'bio': instance.bio,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
  'is_online': instance.isOnline,
  'last_lat': instance.lastLat,
  'last_lng': instance.lastLng,
  'last_seen_at': instance.lastSeenAt?.toIso8601String(),
};

const _$CleanerStatusEnumMap = {
  CleanerStatus.pending: 'pending',
  CleanerStatus.approved: 'approved',
  CleanerStatus.suspended: 'suspended',
};
