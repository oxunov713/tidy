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

    /// Visit length in minutes for one bedroom and one bathroom, extras not
    /// included.
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

/// A service with every price field, from `GET /admin/services`. Inactive
/// services are included.
@freezed
abstract class AdminService with _$AdminService {
  const factory AdminService({
    required String id,
    required String slug,
    required String title,

    /// Price in pence for one bedroom and one bathroom.
    required int basePrice,
    required int perBedroom,
    required int perBathroom,

    /// Minutes for one bedroom and one bathroom.
    required int baseMinutes,
    required int minutesPerRoom,
    required bool isActive,
    required int sortOrder,
  }) = _AdminService;

  factory AdminService.fromJson(Map<String, dynamic> json) =>
      _$AdminServiceFromJson(json);
}

/// Body of `PUT /admin/services/{id}`. The server replaces every field and
/// rejects a body with one missing, so send the whole thing, `is_active`
/// included.
@freezed
abstract class ServiceUpdate with _$ServiceUpdate {
  const factory ServiceUpdate({
    required String title,
    required int basePrice,
    required int perBedroom,
    required int perBathroom,
    required int baseMinutes,
    required int minutesPerRoom,
    required bool isActive,
  }) = _ServiceUpdate;

  factory ServiceUpdate.fromJson(Map<String, dynamic> json) =>
      _$ServiceUpdateFromJson(json);
}
