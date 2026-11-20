import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// Turns anything thrown by the API layer into a sentence for the admin.
String describeError(Object error, AppLocalizations l10n) => switch (error) {
  SlotTakenException() => l10n.errorSlotTaken,
  InvalidTransitionException() => l10n.errorInvalidTransition,
  UnauthorizedException() => l10n.errorUnauthorized,
  ForbiddenException() => l10n.errorForbidden,
  NotFoundException() => l10n.errorNotFound,
  TooManyRequestsException() => l10n.errorTooManyRequests,
  NetworkException() => l10n.errorNetwork,
  ServerException() => l10n.errorServer,
  ApiException(:final message) => message,
  _ => l10n.errorUnknown,
};
