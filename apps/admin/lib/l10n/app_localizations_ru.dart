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
  String get retry => 'Повторить';

  @override
  String get refresh => 'Обновить';

  @override
  String get loading => 'Загрузка';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get back => 'Назад';

  @override
  String get save => 'Сохранить';

  @override
  String get signOut => 'Выйти';

  @override
  String get accountMenu => 'Меню аккаунта';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String get errorSlotTaken =>
      'У этого клинера уже есть заказ на это время. Выберите другого.';

  @override
  String get errorInvalidTransition =>
      'Статус заказа уже не позволяет это сделать.';

  @override
  String get errorUnauthorized => 'Сессия истекла. Войдите снова.';

  @override
  String get errorForbidden => 'Нет прав для этого действия.';

  @override
  String get errorNotFound => 'Элемент больше не существует.';

  @override
  String get errorTooManyRequests =>
      'Слишком много попыток. Подождите минуту и повторите.';

  @override
  String get errorNetwork => 'Нет связи с сервером. Проверьте подключение.';

  @override
  String get errorServer => 'Ошибка на сервере. Повторите чуть позже.';

  @override
  String get errorUnknown => 'Произошла непредвиденная ошибка.';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginPhoneSubtitle => 'Введите номер телефона администратора.';

  @override
  String loginCodeSubtitle(String phone) {
    return 'Мы отправили 6-значный код на $phone.';
  }

  @override
  String get loginPhoneLabel => 'Номер телефона';

  @override
  String get loginPhoneInvalid =>
      'Используйте международный формат, например +447700900001.';

  @override
  String get loginCodeLabel => 'Код подтверждения';

  @override
  String get loginCodeInvalid => 'Введите 6-значный код.';

  @override
  String get loginSendCode => 'Отправить код';

  @override
  String get loginSignIn => 'Войти';

  @override
  String get loginChangeNumber => 'Другой номер';

  @override
  String get loginNoAdminAccess =>
      'У этого аккаунта нет доступа администратора.';

  @override
  String get navBookings => 'Заказы';

  @override
  String get navCleaners => 'Клинеры';

  @override
  String get navServices => 'Услуги и цены';

  @override
  String get navMenu => 'Открыть меню';

  @override
  String get navExpand => 'Развернуть меню';

  @override
  String get navCollapse => 'Свернуть меню';

  @override
  String get statBookingsToday => 'Заказов сегодня';

  @override
  String get statRevenueToday => 'Выручка сегодня';

  @override
  String get statCleanersOnline => 'Клинеров онлайн';

  @override
  String get statAwaitingApproval => 'Ждут одобрения';

  @override
  String get searchBookingsHint => 'Поиск по ID, клиенту или клинеру';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get filterAll => 'Все';

  @override
  String get statusPending => 'Ожидает';

  @override
  String get statusConfirmed => 'Подтверждён';

  @override
  String get statusAssigned => 'Назначен';

  @override
  String get statusOnTheWay => 'В пути';

  @override
  String get statusInProgress => 'В работе';

  @override
  String get statusCompleted => 'Завершён';

  @override
  String get statusCancelled => 'Отменён';

  @override
  String get frequencyOnce => 'Разово';

  @override
  String get frequencyWeekly => 'Каждую неделю';

  @override
  String get frequencyFortnightly => 'Раз в две недели';

  @override
  String get columnId => 'ID';

  @override
  String get columnCustomer => 'Клиент';

  @override
  String get columnService => 'Услуга';

  @override
  String get columnTime => 'Время';

  @override
  String get columnCleaner => 'Клинер';

  @override
  String get columnStatus => 'Статус';

  @override
  String get columnAmount => 'Сумма';

  @override
  String get bookingsEmptyTitle => 'Заказов не найдено';

  @override
  String get bookingsEmpty =>
      'Заказы появятся здесь, когда клиенты их оформят.';

  @override
  String get bookingsEmptyFiltered => 'Ничего не подходит под фильтры.';

  @override
  String get clearFilters => 'Сбросить фильтры';

  @override
  String get loadMore => 'Показать ещё';

  @override
  String get bookingDetails => 'Заказ';

  @override
  String get sectionVisit => 'Визит';

  @override
  String get sectionCustomer => 'Клиент';

  @override
  String get sectionAddress => 'Адрес';

  @override
  String get sectionCleaner => 'Клинер';

  @override
  String get sectionPayment => 'Оплата';

  @override
  String get sectionReview => 'Отзыв';

  @override
  String get sectionTimeline => 'История';

  @override
  String get fieldService => 'Услуга';

  @override
  String get fieldWhen => 'Когда';

  @override
  String get fieldRooms => 'Комнаты';

  @override
  String get fieldFrequency => 'Периодичность';

  @override
  String get fieldName => 'Имя';

  @override
  String get fieldPhone => 'Телефон';

  @override
  String get fieldSubtotal => 'Подытог';

  @override
  String get fieldDiscount => 'Скидка';

  @override
  String get fieldTotal => 'Итого';

  @override
  String get fieldCleanerPayout => 'Выплата клинеру';

  @override
  String get notAssigned => 'Клинер ещё не назначен.';

  @override
  String get timelineEmpty => 'Событий пока нет.';

  @override
  String get assignCleaner => 'Назначить клинера';

  @override
  String get reassignCleaner => 'Сменить клинера';

  @override
  String get reassignTitle => 'Сменить клинера';

  @override
  String get reassignHint =>
      'Выберите одобренного клинера. Он сразу получит уведомление.';

  @override
  String get reassignConfirm => 'Назначить';

  @override
  String get noApprovedCleaners => 'Других одобренных клинеров нет.';

  @override
  String get cleanerReassigned => 'Клинер изменён.';

  @override
  String get cancelBooking => 'Отменить заказ';

  @override
  String cancelBookingTitle(String code) {
    return 'Отменить заказ $code?';
  }

  @override
  String get cancelBookingBody =>
      'Клиенту вернут всю сумму, клинер получит уведомление. Это нельзя отменить.';

  @override
  String get keepBooking => 'Оставить заказ';

  @override
  String get bookingCancelled => 'Заказ отменён.';

  @override
  String roomsValue(int bedrooms, int bathrooms) {
    return '$bedrooms спал., $bathrooms ванн.';
  }

  @override
  String ratingSummary(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$rating ($_temp0)';
  }

  @override
  String reviewRating(int rating) {
    return 'Оценка $rating из 5';
  }

  @override
  String get tabPending => 'На рассмотрении';

  @override
  String get tabApproved => 'Одобренные';

  @override
  String get tabSuspended => 'Заблокированные';

  @override
  String get noPendingCleaners => 'Нет клинеров, ожидающих одобрения.';

  @override
  String get noApprovedCleanersTab => 'Одобренных клинеров пока нет.';

  @override
  String get noSuspendedCleaners => 'Нет заблокированных клинеров.';

  @override
  String get approve => 'Одобрить';

  @override
  String get reject => 'Отклонить';

  @override
  String get suspend => 'Заблокировать';

  @override
  String get reinstate => 'Вернуть';

  @override
  String get online => 'Онлайн';

  @override
  String get offline => 'Офлайн';

  @override
  String get noRatingsYet => 'Оценок пока нет';

  @override
  String cleanerApproved(String name) {
    return '$name одобрен(а).';
  }

  @override
  String cleanerSuspended(String name) {
    return '$name заблокирован(а).';
  }

  @override
  String get cleanerUpdateFailed => 'Не удалось обновить клинера.';

  @override
  String get servicesIntro =>
      'Цены в фунтах. Изменения сразу действуют для новых расчётов.';

  @override
  String get noServices => 'Услуг пока нет.';

  @override
  String get columnPerBedroom => 'За спальню';

  @override
  String get columnPerBathroom => 'За ванную';

  @override
  String get columnDuration => 'Длительность';

  @override
  String get columnActive => 'Активна';

  @override
  String durationSummary(int base, int perRoom) {
    return '$base мин + $perRoom за комнату';
  }

  @override
  String get editService => 'Изменить услугу';

  @override
  String get fieldServiceName => 'Название';

  @override
  String get fieldBasePrice => 'Базовая цена';

  @override
  String get fieldPerBedroom => 'За каждую доп. спальню';

  @override
  String get fieldPerBathroom => 'За каждую доп. ванную';

  @override
  String get fieldBaseMinutes => 'Базовая длительность';

  @override
  String get fieldMinutesPerRoom => 'Доп. время за комнату';

  @override
  String get minutesSuffix => 'мин';

  @override
  String get fieldActive => 'Активна';

  @override
  String get fieldActiveHint => 'Неактивные услуги нельзя заказать.';

  @override
  String get validationTitle => 'Введите название до 80 символов.';

  @override
  String get validationPrice =>
      'Введите сумму в фунтах, например 68 или 68.50.';

  @override
  String get validationPricePositive => 'Цена должна быть больше £0.';

  @override
  String get validationPriceTooHigh => 'Максимум — £10 000.';

  @override
  String validationMinutes(int min, int max) {
    return 'Введите целое число минут от $min до $max.';
  }

  @override
  String get serviceSaved => 'Услуга сохранена.';

  @override
  String get serviceUpdateFailed => 'Не удалось обновить услугу.';
}
