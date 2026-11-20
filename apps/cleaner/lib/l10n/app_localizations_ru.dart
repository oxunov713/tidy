// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tidy Pro';

  @override
  String get loading => 'Загрузка';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String get errorOffline => 'Нет соединения. Проверьте интернет и повторите.';

  @override
  String get errorTooManyRequests => 'Слишком много попыток. Подождите минуту.';

  @override
  String get errorSessionExpired => 'Сессия истекла. Войдите снова.';

  @override
  String get errorForbidden => 'У вас нет на это прав.';

  @override
  String get errorServer => 'Проблема на сервере. Повторите чуть позже.';

  @override
  String get errorGeneric => 'Не получилось. Попробуйте ещё раз.';

  @override
  String get errorPhoneInvalid => 'Введите корректный номер телефона.';

  @override
  String get errorWrongRole =>
      'Этот номер привязан к аккаунту клиента. Используйте приложение Tidy для клиентов.';

  @override
  String get signInTitle => 'Ваш следующий заказ в одно касание.';

  @override
  String get signInSubtitle =>
      'Принимайте заказы на уборку рядом, планируйте день и следите за заработком.';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get verifyCode => 'Подтвердить';

  @override
  String get changeNumber => 'Другой номер';

  @override
  String get verificationCode => 'Код из 6 цифр';

  @override
  String codeSentTo(String phone) {
    return 'Мы отправили код на $phone';
  }

  @override
  String get signInTerms =>
      'Продолжая, вы принимаете Условия и Политику конфиденциальности.';

  @override
  String get pendingTitle => 'Ваш профиль на проверке';

  @override
  String get pendingBody =>
      'Спасибо за регистрацию! Мы проверяем каждого нового клинера, обычно это занимает день. Как только вас одобрят, вы сможете выйти на линию.';

  @override
  String get pullToRefresh => 'Потяните вниз, чтобы обновить';

  @override
  String get suspendedTitle => 'Ваш аккаунт приостановлен';

  @override
  String get suspendedBody =>
      'Сейчас вы не можете принимать новые заказы. Если это ошибка, свяжитесь с поддержкой Tidy.';

  @override
  String get signOut => 'Выйти';
}
