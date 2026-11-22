import 'package:material_ui/material_ui.dart';
import 'package:tidy_core/tidy_core.dart';

/// Times come from the API in UTC; the panel shows them in the business
/// zone (see `BusinessTime`), not in the zone of the admin's computer.
String formatDateTime(BuildContext context, DateTime value) =>
    TidyDates.dateTime(value, Localizations.localeOf(context).toString());

String formatTime(BuildContext context, DateTime value) =>
    TidyDates.clock(value, Localizations.localeOf(context).toString());

String formatLongDate(BuildContext context, DateTime value) =>
    TidyDates.dayFull(value, Localizations.localeOf(context).toString());

/// Accounts created straight from a phone number have no name yet.
String nameOrPhone(String name, String phone) =>
    name.trim().isEmpty ? phone : name;
