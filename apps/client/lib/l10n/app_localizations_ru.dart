// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tidy';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get close => 'Закрыть';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String get errorNetwork => 'Нет соединения. Проверьте интернет и повторите.';

  @override
  String get errorSlotTaken => 'Это время только что занял другой клиент.';

  @override
  String get errorTooManyRequests =>
      'Слишком много попыток. Подождите немного.';

  @override
  String get errorSessionExpired => 'Сессия истекла. Войдите снова.';

  @override
  String get errorServer => 'Проблема на сервере. Повторите чуть позже.';

  @override
  String get errorGeneric =>
      'Произошла непредвиденная ошибка. Повторите попытку.';

  @override
  String stepOf(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String get navHome => 'Главная';

  @override
  String get navBookings => 'Заказы';

  @override
  String get navChat => 'Чат';

  @override
  String get navProfile => 'Профиль';

  @override
  String get welcomeTitle => 'Чистый дом — за одну минуту.';

  @override
  String get welcomeSubtitle =>
      'Проверенные клинеры рядом, фиксированные цены и отслеживание от заказа до конца уборки.';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get phoneInvalid => 'Введите корректный номер телефона';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get continueWithGoogle => 'Продолжить через Google';

  @override
  String get googleSoon =>
      'Вход через Google скоро появится. Пока используйте номер телефона.';

  @override
  String get termsNotice =>
      'Продолжая, вы принимаете Условия и Политику конфиденциальности.';

  @override
  String get selectCountry => 'Выберите страну';

  @override
  String get otpTitle => 'Введите код';

  @override
  String otpSubtitle(String phone) {
    return 'Мы отправили 6-значный код на $phone.';
  }

  @override
  String resendIn(int seconds) {
    return 'Отправить повторно через $seconds с';
  }

  @override
  String get resendCode => 'Отправить код ещё раз';

  @override
  String get codeSent => 'Новый код отправлен.';

  @override
  String get fieldRequired => 'Обязательное поле';

  @override
  String get dropPinFirst => 'Сначала отметьте дом на карте.';

  @override
  String get pinDropped => 'Метка поставлена. Нажмите, чтобы переместить.';

  @override
  String get tapToDropPin => 'Нажмите на карту, чтобы поставить метку';

  @override
  String get addAddressTitle => 'Где нужно убрать?';

  @override
  String get addressLine1 => 'Адрес';

  @override
  String get addressLine2 => 'Квартира, этаж (необязательно)';

  @override
  String get city => 'Город';

  @override
  String get postcode => 'Индекс';

  @override
  String get accessNotes => 'Как попасть внутрь';

  @override
  String get accessNotesHint => 'Ключ в сейфе, позвоните в верхний звонок...';

  @override
  String get saveAddress => 'Сохранить адрес';

  @override
  String get chooseAddress => 'Выберите адрес';

  @override
  String get myAddresses => 'Мои адреса';

  @override
  String get noAddressesTitle => 'Адресов пока нет';

  @override
  String get noAddressesBody =>
      'Добавьте адрес уборки и поставьте метку на карте, чтобы клинер нашёл вас.';

  @override
  String get addAddress => 'Добавить адрес';

  @override
  String get deleteAddress => 'Удалить';

  @override
  String get deleteAddressTitle => 'Удалить этот адрес?';
}
