import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

/// The `error` object inside the error envelope
/// `{ "error": { "code", "message", "details" } }`.
@freezed
abstract class ApiError with _$ApiError {
  const factory ApiError({
    required String code,
    required String message,

    /// Field name to problem, for `invalid_request`.
    Map<String, String>? details,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  /// Reads the whole envelope; returns null when [body] is not one.
  static ApiError? fromEnvelope(Object? body) {
    if (body is Map<String, dynamic> && body['error'] is Map<String, dynamic>) {
      final error = body['error'] as Map<String, dynamic>;
      if (error['code'] is String && error['message'] is String) {
        return ApiError.fromJson(error);
      }
    }
    return null;
  }
}
