import 'package:tidy_cleaner/features/auth/domain/auth_repository.dart';
import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// A sentence a cleaner can act on, for any error from the API client.
String errorText(AppLocalizations l10n, Object error) => switch (error) {
  FormatException() => l10n.errorPhoneInvalid,
  WrongRoleException() => l10n.errorWrongRole,
  NetworkException() => l10n.errorOffline,
  TooManyRequestsException() => l10n.errorTooManyRequests,
  UnauthorizedException() => l10n.errorSessionExpired,
  ForbiddenException() => l10n.errorForbidden,
  ServerException() => l10n.errorServer,
  InvalidRequestException(:final message) => message,
  _ => l10n.errorGeneric,
};
