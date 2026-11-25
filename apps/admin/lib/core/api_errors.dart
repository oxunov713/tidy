import 'package:tidy_admin/l10n/app_localizations.dart';
import 'package:tidy_core/tidy_core.dart';

/// The admin panel's wording for [describeError].
ErrorStrings errorStrings(AppLocalizations l10n) => ErrorStrings(
  network: l10n.errorNetwork,
  server: l10n.errorServer,
  tooManyRequests: l10n.errorTooManyRequests,
  sessionExpired: l10n.errorUnauthorized,
  slotTaken: l10n.errorSlotTaken,
  forbidden: l10n.errorForbidden,
  notFound: l10n.errorNotFound,
  invalidTransition: l10n.errorInvalidTransition,
  wrongRole: l10n.loginNoAdminAccess,
  generic: l10n.errorUnknown,
);

/// Turns anything thrown by the API layer into a sentence for the admin.
String errorText(AppLocalizations l10n, Object error) =>
    describeError(error, errorStrings(l10n));
