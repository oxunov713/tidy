// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: (json['id'] as num).toInt(),
  bookingId: json['booking_id'] as String,
  senderId: json['sender_id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'booking_id': instance.bookingId,
  'sender_id': instance.senderId,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
};
