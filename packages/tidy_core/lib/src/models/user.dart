import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// A user as the API returns it: `/auth/verify`, `/me` and every row of
/// `/admin/cleaners`.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String phone,
    required String fullName,
    required UserRole role,
    required DateTime createdAt,
    String? email,
    String? avatarUrl,

    /// The cleaner profile. Sent by `GET /me` for cleaners and in the admin
    /// cleaner list; absent for clients and admins and in `/auth/verify`.
    Cleaner? cleaner,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// The cleaner-specific part of a [User].
@freezed
abstract class Cleaner with _$Cleaner {
  const factory Cleaner({
    /// Same as the id of the [User] it belongs to.
    required String userId,
    required CleanerStatus status,
    required String bio,
    required double rating,
    required int ratingCount,
    required bool isOnline,
    double? lastLat,
    double? lastLng,
    DateTime? lastSeenAt,
  }) = _Cleaner;

  factory Cleaner.fromJson(Map<String, dynamic> json) =>
      _$CleanerFromJson(json);
}
