import 'package:tidy_core/src/api/api_exception.dart';
import 'package:tidy_core/src/session/session_repository.dart';

/// The sentences [describeError] chooses from. Every app fills this from its
/// own translations, so the mapping from exception to message lives here once
/// while the words stay in the app's ARB files.
class ErrorStrings {
  const ErrorStrings({
    required this.network,
    required this.server,
    required this.tooManyRequests,
    required this.sessionExpired,
    required this.slotTaken,
    required this.forbidden,
    required this.notFound,
    required this.invalidTransition,
    required this.wrongRole,
    required this.generic,
  });

  final String network;
  final String server;
  final String tooManyRequests;
  final String sessionExpired;
  final String slotTaken;
  final String forbidden;
  final String notFound;

  /// Used only when the server sent no message of its own.
  final String invalidTransition;

  /// "This number belongs to a cleaner account. Use the Tidy Pro app."
  final String wrongRole;
  final String generic;
}

/// Turns whatever an API call or a repository threw into a sentence a person
/// can act on.
///
/// The server's own message wins where it is specific and already written for
/// people: validation problems name the field, `invalid_transition` names the
/// current status ("A completed booking can't be cancelled.") and `forbidden`
/// carries the role mismatch ("This number is registered as a cleaner.").
String describeError(Object error, ErrorStrings strings) {
  String orElse(String message, String fallback) =>
      message.trim().isEmpty ? fallback : message;

  return switch (error) {
    WrongRoleException() => strings.wrongRole,
    NetworkException() => strings.network,
    SlotTakenException() => strings.slotTaken,
    TooManyRequestsException() => strings.tooManyRequests,
    UnauthorizedException() => strings.sessionExpired,
    InvalidTransitionException(:final message) => orElse(
      message,
      strings.invalidTransition,
    ),
    ForbiddenException(:final message) => orElse(message, strings.forbidden),
    NotFoundException() => strings.notFound,
    ServerException() => strings.server,
    ApiException(:final message) => orElse(message, strings.generic),
    _ => strings.generic,
  };
}
