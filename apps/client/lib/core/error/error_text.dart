import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// Turns whatever a repository threw into something a person can read.
///
/// The server's own message is used for validation problems, because it names
/// the field; everything else gets a localised sentence.
String errorMessage(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context);
  return switch (error) {
    WrongRoleException() => l10n.errorWrongRole,
    NetworkException() => l10n.errorNetwork,
    SlotTakenException() => l10n.errorSlotTaken,
    TooManyRequestsException() => l10n.errorTooManyRequests,
    UnauthorizedException() => l10n.errorSessionExpired,
    InvalidRequestException(:final message) => message,
    ServerException() => l10n.errorServer,
    ApiException(:final message) => message,
    _ => l10n.errorGeneric,
  };
}
