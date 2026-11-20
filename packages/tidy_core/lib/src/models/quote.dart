import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/enums.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

/// Body of `POST /quotes`. Also the base of a booking request.
@freezed
abstract class QuoteRequest with _$QuoteRequest {
  const factory QuoteRequest({
    required String serviceId,
    required int bedrooms,
    required int bathrooms,
    @Default(<String>[]) List<String> extraIds,
    @Default(Frequency.once) Frequency frequency,
  }) = _QuoteRequest;

  factory QuoteRequest.fromJson(Map<String, dynamic> json) =>
      _$QuoteRequestFromJson(json);
}

@freezed
abstract class QuoteLine with _$QuoteLine {
  const factory QuoteLine({
    required String label,

    /// Pence; negative for discounts.
    required int amount,
  }) = _QuoteLine;

  factory QuoteLine.fromJson(Map<String, dynamic> json) =>
      _$QuoteLineFromJson(json);
}

/// Server-calculated price. All amounts in pence.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required int subtotal,
    required int discount,
    required int total,
    required int minutes,
    @Default(<QuoteLine>[]) List<QuoteLine> lines,
  }) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
