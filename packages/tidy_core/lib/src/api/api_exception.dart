import 'package:dio/dio.dart';
import 'package:tidy_core/src/models/api_error.dart';

/// Every failure a call to the Tidy API can end in.
///
/// Switch over the subtypes to handle the cases the UI cares about:
///
/// ```dart
/// try {
///   await api.bookings.create(request);
/// } on SlotTakenException {
///   // show the slot picker again
/// } on ApiException catch (e) {
///   showError(e.message);
/// }
/// ```
sealed class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  /// Maps a failed dio call to the right subtype using the error envelope
  /// (`{ "error": { "code", "message" } }`), falling back to the HTTP status.
  factory ApiException.fromDio(DioException error) {
    if (error.error is ApiException) return error.error! as ApiException;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const UnknownApiException(message: 'Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        break;
    }

    final response = error.response;
    if (response == null) {
      // Dio reports a dropped socket as "unknown" with an IO error inside.
      return NetworkException(message: error.message ?? 'No connection');
    }

    final status = response.statusCode ?? 0;
    final envelope = ApiError.fromEnvelope(response.data);
    final code = envelope?.code;
    final message = envelope?.message ?? 'Request failed ($status)';

    switch (code) {
      case 'invalid_request':
        return InvalidRequestException(
          message: message,
          statusCode: status,
          details: envelope?.details,
        );
      case 'unauthorized':
        return UnauthorizedException(message: message, statusCode: status);
      case 'forbidden':
        return ForbiddenException(message: message, statusCode: status);
      case 'not_found':
        return NotFoundException(message: message, statusCode: status);
      case 'slot_taken':
        return SlotTakenException(message: message, statusCode: status);
      case 'invalid_transition':
        return InvalidTransitionException(message: message, statusCode: status);
      case 'too_many_requests':
        return TooManyRequestsException(message: message, statusCode: status);
    }

    // No (known) code: decide by status so a proxy error page still maps well.
    return switch (status) {
      400 => InvalidRequestException(message: message, statusCode: status),
      401 => UnauthorizedException(message: message, statusCode: status),
      403 => ForbiddenException(message: message, statusCode: status),
      404 => NotFoundException(message: message, statusCode: status),
      429 => TooManyRequestsException(message: message, statusCode: status),
      >= 500 => ServerException(
        message: message,
        code: code,
        statusCode: status,
      ),
      _ => UnknownApiException(
        message: message,
        code: code,
        statusCode: status,
        details: envelope?.details,
      ),
    };
  }

  final String message;

  /// The `code` from the error envelope, when there was one.
  final String? code;
  final int? statusCode;
  final Object? details;

  @override
  String toString() => 'ApiException($code, $statusCode): $message';
}

/// 400 `invalid_request`. [details] lists the offending fields.
final class InvalidRequestException extends ApiException {
  const InvalidRequestException({
    required super.message,
    super.statusCode = 400,
    super.details,
  }) : super(code: 'invalid_request');
}

/// 401. Raised after a refresh attempt has already failed, so the user has to
/// sign in again.
final class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    required super.message,
    super.statusCode = 401,
  }) : super(code: 'unauthorized');
}

/// 403: wrong role, or not your booking.
final class ForbiddenException extends ApiException {
  const ForbiddenException({required super.message, super.statusCode = 403})
    : super(code: 'forbidden');
}

final class NotFoundException extends ApiException {
  const NotFoundException({required super.message, super.statusCode = 404})
    : super(code: 'not_found');
}

/// 409: the cleaner was booked at that time.
final class SlotTakenException extends ApiException {
  const SlotTakenException({required super.message, super.statusCode = 409})
    : super(code: 'slot_taken');
}

/// 409: e.g. finishing a booking that has not started.
final class InvalidTransitionException extends ApiException {
  const InvalidTransitionException({
    required super.message,
    super.statusCode = 409,
  }) : super(code: 'invalid_transition');
}

/// 429: OTP or login rate limit.
final class TooManyRequestsException extends ApiException {
  const TooManyRequestsException({
    required super.message,
    super.statusCode = 429,
  }) : super(code: 'too_many_requests');
}

/// 5xx.
final class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.code,
    super.statusCode,
  });
}

/// No response at all: offline, DNS failure, timeout.
final class NetworkException extends ApiException {
  const NetworkException({super.message = 'No connection'});
}

/// Anything that does not fit above, e.g. an unexpected 4xx code.
final class UnknownApiException extends ApiException {
  const UnknownApiException({
    required super.message,
    super.code,
    super.statusCode,
    super.details,
  });
}
