import 'package:material_ui/material_ui.dart';
import 'package:tidy_client/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// The client app's wording for [describeError].
ErrorStrings errorStrings(AppLocalizations l10n) => ErrorStrings(
  network: l10n.errorNetwork,
  server: l10n.errorServer,
  tooManyRequests: l10n.errorTooManyRequests,
  sessionExpired: l10n.errorSessionExpired,
  slotTaken: l10n.errorSlotTaken,
  forbidden: l10n.errorForbidden,
  notFound: l10n.errorNotFound,
  invalidTransition: l10n.errorInvalidTransition,
  wrongRole: l10n.errorWrongRole,
  generic: l10n.errorGeneric,
);

/// Turns whatever a repository threw into something a person can read.
String errorMessage(BuildContext context, Object error) =>
    describeError(error, errorStrings(AppLocalizations.of(context)));
