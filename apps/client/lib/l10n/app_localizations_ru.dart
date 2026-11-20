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

  @override
  String homeGreeting(String name) {
    return 'Привет, $name! Что нужно убрать сегодня?';
  }

  @override
  String get homeGreetingAnonymous => 'Привет! Что нужно убрать сегодня?';

  @override
  String get cleaningAt => 'Уборка по адресу';

  @override
  String get addYourAddress => 'Добавьте адрес';

  @override
  String get notifications => 'Уведомления';

  @override
  String get noNotifications => 'Новых уведомлений нет.';

  @override
  String get promoBadge => 'СКИДКА 20%';

  @override
  String get promoTitle => 'Ваша первая генеральная уборка';

  @override
  String get promoCode => 'Промокод TIDY20 при оплате';

  @override
  String get servicesTitle => 'Услуги';

  @override
  String get seeAll => 'Все';

  @override
  String get noServicesTitle => 'Услуг пока нет';

  @override
  String get noServicesBody => 'Загляните позже, мы добавляем новые.';

  @override
  String get badgeMostBooked => 'ПОПУЛЯРНОЕ';

  @override
  String get badgePremium => 'ПРЕМИУМ';

  @override
  String hoursUnit(String value) {
    return '$value ч';
  }

  @override
  String get fromLabel => 'ОТ';

  @override
  String serviceCardSemantics(String title, String price) {
    return '$title, от $price';
  }

  @override
  String cleanerOnTheWay(String name) {
    return '$name уже в пути';
  }

  @override
  String cleanerCleaning(String name) {
    return '$name убирает';
  }

  @override
  String cleanerBooked(String name) {
    return '$name назначен на ваш заказ';
  }

  @override
  String get yourCleanerOnTheWay => 'Ваш клинер в пути';

  @override
  String get yourCleanerCleaning => 'Ваш клинер убирает';

  @override
  String get yourCleanerBooked => 'Клинер назначен на ваш заказ';

  @override
  String get cardDetailInvalid => 'Проверьте поле';

  @override
  String payAmount(String amount) {
    return 'Оплатить $amount';
  }

  @override
  String get testMode => 'Тестовый режим';

  @override
  String get testModeNotice =>
      'Реальная оплата не выполняется. Подойдут любые данные карты.';

  @override
  String get cardNumber => 'Номер карты';

  @override
  String get cardExpiry => 'ММ/ГГ';

  @override
  String get cardCvc => 'CVC';
}
