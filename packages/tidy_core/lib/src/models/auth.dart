// `includeIfNull` has to sit on the factory; freezed forwards it.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/src/models/enums.dart';
import 'package:tidy_core/src/models/user.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}

@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required String refreshToken,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}

/// Body of `POST /auth/verify`.
///
/// [role] (`client` or `cleaner`) only matters when the phone number signs in
/// for the first time. Leave it out for existing accounts; admins sign in
/// without it, the server rejects `admin`.
@freezed
abstract class VerifyRequest with _$VerifyRequest {
  @JsonSerializable(includeIfNull: false)
  const factory VerifyRequest({
    required String phone,
    required String code,
    UserRole? role,
  }) = _VerifyRequest;

  factory VerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyRequestFromJson(json);
}
