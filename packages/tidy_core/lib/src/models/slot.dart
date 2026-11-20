import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

@freezed
abstract class Slot with _$Slot {
  const factory Slot({
    /// Start time, UTC.
    required DateTime start,
    required bool available,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}

/// Response of `GET /slots`.
@freezed
abstract class SlotsResponse with _$SlotsResponse {
  const factory SlotsResponse({
    /// Day in `yyyy-MM-dd` form, as sent.
    required String date,
    @Default(<Slot>[]) List<Slot> slots,
  }) = _SlotsResponse;

  factory SlotsResponse.fromJson(Map<String, dynamic> json) =>
      _$SlotsResponseFromJson(json);
}
