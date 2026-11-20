import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Times come from the API in UTC; the panel shows them in the admin's zone.
String formatDateTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.MMMd(locale).add_Hm().format(value.toLocal());
}

String formatTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.Hm(locale).format(value.toLocal());
}

String formatLongDate(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.MMMMEEEEd(locale).format(value.toLocal());
}

/// Accounts created straight from a phone number have no name yet.
String nameOrPhone(String name, String phone) =>
    name.trim().isEmpty ? phone : name;
