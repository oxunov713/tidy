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

  @override
  String get chooseServiceFirst => 'Выберите услугу, чтобы начать заказ.';

  @override
  String get sizeOfHome => 'Размер жилья';

  @override
  String get bedrooms => 'Спальни';

  @override
  String get bedroomsHint => 'Гостиная включена';

  @override
  String get bathrooms => 'Ванные';

  @override
  String get bathroomsHint => 'Туалет, душ или ванна';

  @override
  String get addBedroom => 'Добавить спальню';

  @override
  String get removeBedroom => 'Убрать спальню';

  @override
  String get addBathroom => 'Добавить ванную';

  @override
  String get removeBathroom => 'Убрать ванную';

  @override
  String get extras => 'Дополнительно';

  @override
  String get howOften => 'Как часто?';

  @override
  String get frequencyOnce => 'Разово';

  @override
  String get frequencyOnceNote => 'Без скидки';

  @override
  String get frequencyWeekly => 'Каждую неделю';

  @override
  String get frequencyWeeklyNote => 'скидка 15%';

  @override
  String get frequencyFortnightly => 'Раз в 2 недели';

  @override
  String get frequencyFortnightlyNote => 'скидка 10%';

  @override
  String get chooseTime => 'Выбрать время';

  @override
  String get total => 'Итого';

  @override
  String totalWithHours(String hours) {
    return 'Итого · $hours ч';
  }

  @override
  String get whenShouldWeCome => 'Когда приехать?';

  @override
  String get nextSevenDays => 'Ближайшие 7 дней';

  @override
  String get startTime => 'Время начала';

  @override
  String get takenTimesNote =>
      'Серым отмечено время, занятое всеми клинерами поблизости.';

  @override
  String get noTimesThatDay =>
      'На этот день времени не осталось. Выберите другой день.';

  @override
  String get cleaner => 'Клинер';

  @override
  String get anyCleaner => 'Любой свободный клинер';

  @override
  String get anyCleanerNote =>
      'Мы подберём лучшего свободного клинера поблизости.';

  @override
  String yourLastCleaner(String name) {
    return '$name · ваш прошлый клинер';
  }

  @override
  String ratingAndReviews(String rating, int count) {
    return 'Рейтинг $rating · отзывов: $count';
  }

  @override
  String get continueToPayment => 'Перейти к оплате';

  @override
  String get pickATime => 'Выберите день и время начала';

  @override
  String scheduleSummary(String day, String time, String hours) {
    return '$day · начало в $time · около $hours ч';
  }

  @override
  String scheduleSummaryShort(String day, String time) {
    return '$day · начало в $time';
  }

  @override
  String get confirmAndPay => 'Подтверждение и оплата';

  @override
  String get change => 'Изменить';

  @override
  String get summary => 'Детали заказа';

  @override
  String get payment => 'Оплата';

  @override
  String get payByCard => 'Оплата картой';

  @override
  String get securePaymentStripe => 'Безопасная оплата через Stripe';

  @override
  String get chargedAfterClean =>
      'Деньги списываются только после завершения уборки.';

  @override
  String get book => 'Заказать';

  @override
  String bookFor(String price) {
    return 'Заказать за $price';
  }

  @override
  String get slotTakenSnack =>
      'Это время только что заняли. Вот свободные варианты.';

  @override
  String get paymentFailed => 'Оплата не прошла. Попробуйте ещё раз.';

  @override
  String get paymentCancelled => 'Оплата не завершена. Заказ ожидает оплаты.';

  @override
  String get statusPending => 'Ожидает оплаты';

  @override
  String get statusConfirmed => 'Подтверждён';

  @override
  String get statusAssigned => 'Клинер назначен';

  @override
  String get statusOnTheWay => 'В пути';

  @override
  String get statusInProgress => 'Идёт уборка';

  @override
  String get statusCompleted => 'Завершён';

  @override
  String get statusCancelled => 'Отменён';

  @override
  String get cancelBookingTitle => 'Отменить заказ?';

  @override
  String get cancelFreeBody =>
      'Сейчас отмена бесплатна. Деньги вернутся полностью.';

  @override
  String cancelLateBody(String price) {
    return 'До уборки меньше 24 часов, поэтому при отмене будет списана полная стоимость ($price).';
  }

  @override
  String get keepBooking => 'Оставить заказ';

  @override
  String get cancelBooking => 'Отменить заказ';

  @override
  String cancelledRefunded(String price) {
    return 'Заказ отменён. Вернём $price.';
  }

  @override
  String cancelledCharged(String price) {
    return 'Заказ отменён. Списано $price: до начала оставалось меньше 24 часов.';
  }

  @override
  String get serviceUnavailable => 'Эта услуга больше недоступна.';

  @override
  String get findingCleaner => 'Подбираем клинера';

  @override
  String get noCleaner => 'Клинер не назначен';

  @override
  String todayAt(String time) {
    return 'Сегодня · $time';
  }

  @override
  String get track => 'Следить';

  @override
  String get rate => 'Оценить';

  @override
  String get bookAgain => 'Заказать снова';

  @override
  String get details => 'Детали';

  @override
  String get upcoming => 'Предстоящие';

  @override
  String get past => 'Прошедшие';

  @override
  String get noUpcomingTitle => 'Пока ничего не заказано';

  @override
  String get noUpcomingBody => 'Закажите первую уборку за минуту.';

  @override
  String get bookAClean => 'Заказать уборку';

  @override
  String get noPastTitle => 'Прошедших уборок нет';

  @override
  String get noPastBody => 'Здесь появятся завершённые и отменённые заказы.';

  @override
  String get couldNotLoadMore =>
      'Не удалось загрузить ещё. Нажмите, чтобы повторить.';

  @override
  String get bookingDetails => 'Детали заказа';

  @override
  String bookingNumber(String code) {
    return 'Заказ №$code';
  }

  @override
  String roomsSummary(int bedrooms, int bathrooms) {
    return 'Спален: $bedrooms, ванных: $bathrooms';
  }

  @override
  String messageCleaner(String name) {
    return 'Написать: $name';
  }

  @override
  String get discount => 'Скидка';

  @override
  String get trackCleaner => 'Следить за клинером';

  @override
  String get rateYourClean => 'Оценить уборку';

  @override
  String get yourReview => 'Ваш отзыв';

  @override
  String tipAmount(String amount) {
    return 'Чаевые $amount';
  }

  @override
  String get timeline => 'История';

  @override
  String get stepConfirmed => 'Принят';

  @override
  String get stepOnTheWay => 'В пути';

  @override
  String get stepCleaning => 'Уборка';

  @override
  String get stepDone => 'Готово';

  @override
  String get arrivingIn => 'Приедет через';

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String get onTheWayHeadline => 'В пути';

  @override
  String get startsAt => 'Начало в';

  @override
  String get rightNow => 'Сейчас';

  @override
  String get cleaningHeadline => 'Идёт уборка';

  @override
  String get finished => 'Завершено';

  @override
  String get allDone => 'Всё готово';

  @override
  String get bookingLabel => 'Заказ';

  @override
  String get needToChange => 'Нужно что-то изменить?';

  @override
  String callCleaner(String name) {
    return 'Позвонить: $name';
  }

  @override
  String get callUnavailable => 'Звонки пока недоступны. Напишите сообщение.';

  @override
  String get howWasYourClean => 'Как прошла уборка?';

  @override
  String starsLabel(int count) {
    return 'Звёзд: $count';
  }

  @override
  String get ratingNotGreat => 'Плохо';

  @override
  String get ratingCouldBeBetter => 'Могло быть лучше';

  @override
  String get ratingOkay => 'Нормально';

  @override
  String get ratingGood => 'Хорошо';

  @override
  String get ratingExcellent => 'Отлично';

  @override
  String get tagSpotless => 'Безупречно';

  @override
  String get tagPunctual => 'Пунктуальность';

  @override
  String get tagFriendly => 'Приветливость';

  @override
  String get tagDetail => 'Внимание к деталям';

  @override
  String get tagEco => 'Мои средства';

  @override
  String get anythingElse => 'Что-то ещё? (необязательно)';

  @override
  String commentHint(String name) {
    return 'Расскажите, что получилось хорошо';
  }

  @override
  String get addTip => 'Добавить чаевые';

  @override
  String get submitReview => 'Отправить отзыв';

  @override
  String get reviewThanks => 'Спасибо за отзыв!';

  @override
  String get alreadyReviewed => 'Вы уже оставили отзыв об этой уборке.';

  @override
  String get noMessagesTitle => 'Сообщений пока нет';

  @override
  String get noMessagesBody => 'Поздоровайтесь с вашим клинером.';

  @override
  String get messageHint => 'Сообщение';

  @override
  String get send => 'Отправить';

  @override
  String get noChatsTitle => 'Диалогов пока нет';

  @override
  String get noChatsBody =>
      'Когда клинер примет заказ, здесь можно будет написать ему.';

  @override
  String get addYourName => 'Добавьте имя';

  @override
  String get editProfile => 'Изменить профиль';

  @override
  String get fullName => 'Имя и фамилия';

  @override
  String get email => 'Эл. почта (необязательно)';

  @override
  String get emailInvalid => 'Введите корректный email';

  @override
  String get language => 'Язык';

  @override
  String get systemDefault => 'Как в системе';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutTitle => 'Выйти из Tidy?';
}
