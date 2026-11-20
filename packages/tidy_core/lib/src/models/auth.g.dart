// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user.toJson(),
    };

_TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => _TokenPair(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
);

Map<String, dynamic> _$TokenPairToJson(_TokenPair instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

_VerifyRequest _$VerifyRequestFromJson(Map<String, dynamic> json) =>
    _VerifyRequest(
      phone: json['phone'] as String,
      code: json['code'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$VerifyRequestToJson(_VerifyRequest instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'code': instance.code,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.client: 'client',
  UserRole.cleaner: 'cleaner',
  UserRole.admin: 'admin',
};
