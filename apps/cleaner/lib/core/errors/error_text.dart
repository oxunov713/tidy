import 'package:tidy_cleaner/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// The cleaner app's wording for [describeError].
ErrorStrings errorStrings(AppLocalizations l10n) => ErrorStrings(
  network: l10n.errorOffline,
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

/// A sentence a cleaner can act on, for any error from the API client.
String errorText(AppLocalizations l10n, Object error) =>
    error is FormatException
    ? l10n.errorPhoneInvalid
    : describeError(error, errorStrings(l10n));
