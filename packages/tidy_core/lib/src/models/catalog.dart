import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

@freezed
abstract class Service with _$Service {
  const factory Service({
    required String id,
    required String slug,
    required String title,

    /// Starting price in pence.
    required int fromPrice,

    /// Shortest visit length in minutes.
    required int minutes,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

@freezed
abstract class Extra with _$Extra {
  const factory Extra({
    required String id,
    required String slug,
    required String title,

    /// Price in pence.
    required int price,
  }) = _Extra;

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
}

/// Body of `PUT /admin/services/{id}`. Column names follow the `services`
/// table, since API.md only says "prices and duration".
@freezed
abstract class ServiceUpdate with _$ServiceUpdate {
  const factory ServiceUpdate({
    required int basePrice,
    required int perBedroom,
    required int perBathroom,
    required int baseMinutes,
    required int minutesPerRoom,
  }) = _ServiceUpdate;

  factory ServiceUpdate.fromJson(Map<String, dynamic> json) =>
      _$ServiceUpdateFromJson(json);
}
