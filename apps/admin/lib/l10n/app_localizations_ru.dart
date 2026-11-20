// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tidy Admin';

  @override
  String get homePlaceholderTitle => 'Скоро здесь появится';

  @override
  String get homePlaceholderBody => 'Здесь будут заказы и одобрение клинеров.';
}
