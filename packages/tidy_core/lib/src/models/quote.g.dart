// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuoteRequest _$QuoteRequestFromJson(Map<String, dynamic> json) =>
    _QuoteRequest(
      serviceId: json['service_id'] as String,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      extraIds:
          (json['extra_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      frequency:
          $enumDecodeNullable(_$FrequencyEnumMap, json['frequency']) ??
          Frequency.once,
    );

Map<String, dynamic> _$QuoteRequestToJson(_QuoteRequest instance) =>
    <String, dynamic>{
      'service_id': instance.serviceId,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'extra_ids': instance.extraIds,
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
    };

const _$FrequencyEnumMap = {
  Frequency.once: 'once',
  Frequency.weekly: 'weekly',
  Frequency.fortnightly: 'fortnightly',
};

_QuoteLine _$QuoteLineFromJson(Map<String, dynamic> json) => _QuoteLine(
  label: json['label'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$QuoteLineToJson(_QuoteLine instance) =>
    <String, dynamic>{'label': instance.label, 'amount': instance.amount};

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  subtotal: (json['subtotal'] as num).toInt(),
  discount: (json['discount'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  minutes: (json['minutes'] as num).toInt(),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => QuoteLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuoteLine>[],
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'subtotal': instance.subtotal,
  'discount': instance.discount,
  'total': instance.total,
  'minutes': instance.minutes,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
};
