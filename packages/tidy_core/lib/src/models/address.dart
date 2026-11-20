import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    required String line1,
    required String city,
    required String postcode,
    required double lat,
    required double lng,
    required String line2,
    required String accessNotes,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

/// Body of `POST /me/addresses`.
@freezed
abstract class AddressInput with _$AddressInput {
  const factory AddressInput({
    required String line1,
    required String city,
    required String postcode,
    required double lat,
    required double lng,
    @Default('') String line2,
    @Default('') String accessNotes,
  }) = _AddressInput;

  factory AddressInput.fromJson(Map<String, dynamic> json) =>
      _$AddressInputFromJson(json);
}
