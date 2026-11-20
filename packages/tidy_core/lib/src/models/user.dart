import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required UserRole role,
    @Default('') String phone,
    @Default('') String fullName,
    String? email,
    String? avatarUrl,

    /// Present for cleaners on `GET /me`.
    Cleaner? cleaner,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// A cleaner profile. Embedded in bookings (name, photo, rating), in `/me` and
/// in the admin list.
@freezed
abstract class Cleaner with _$Cleaner {
  const factory Cleaner({
    required String id,
    @Default('') String fullName,
    String? phone,
    String? avatarUrl,
    @Default(CleanerStatus.approved) CleanerStatus status,
    @Default('') String bio,
    @Default(0.0) double rating,
    @Default(0) int ratingCount,
    @Default(false) bool online,
  }) = _Cleaner;

  factory Cleaner.fromJson(Map<String, dynamic> json) =>
      _$CleanerFromJson(json);
}

/// Client details shown to cleaners and admins on a booking.
@freezed
abstract class ClientSummary with _$ClientSummary {
  const factory ClientSummary({
    required String id,
    @Default('') String fullName,
    String? phone,
    String? avatarUrl,
  }) = _ClientSummary;

  factory ClientSummary.fromJson(Map<String, dynamic> json) =>
      _$ClientSummaryFromJson(json);
}
