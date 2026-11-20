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
  String get errorSlotTaken => 'У вас уже есть заказ на это время.';

  @override
  String get errorNotFound => 'Не удалось найти.';

  @override
  String get errorInvalidTransition => 'Это уже невозможно для этого заказа.';

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

  @override
  String get navJobs => 'Заказы';

  @override
  String get navSchedule => 'Расписание';

  @override
  String get navEarnings => 'Доход';

  @override
  String get navProfile => 'Профиль';

  @override
  String get online => 'На линии';

  @override
  String get offline => 'Не в сети';

  @override
  String get goOnline => 'Выйти на линию';

  @override
  String get statToday => 'Сегодня';

  @override
  String get statJobs => 'Заказы';

  @override
  String get statRating => 'Рейтинг';

  @override
  String jobsDoneOfTotal(int done, int total) {
    return '$done из $total';
  }

  @override
  String get newRequest => 'НОВЫЙ ЗАКАЗ';

  @override
  String expiresIn(String time) {
    return 'Истекает через $time';
  }

  @override
  String get yourPayout => 'ваша выплата';

  @override
  String get decline => 'Отклонить';

  @override
  String get accept => 'Принять';

  @override
  String get later => 'Позже';

  @override
  String bedBath(int bedrooms, int bathrooms) {
    return '$bedrooms сп. · $bathrooms ван.';
  }

  @override
  String offerPlaceDistance(String place, String km) {
    return '$place · $km км от вас';
  }

  @override
  String get offerPlaceLoading => 'Адрес будет виден после принятия';

  @override
  String get offlineTitle => 'Вы не в сети';

  @override
  String get offlineBody => 'Выйдите на линию, чтобы получать заказы рядом.';

  @override
  String get waitingTitle => 'Ждём новые заказы';

  @override
  String get waitingBody => 'Как только появится заказ, вы услышите сигнал.';

  @override
  String get nextUp => 'Ближайшие';

  @override
  String get noUpcomingTitle => 'Нет предстоящих заказов';

  @override
  String get noUpcomingBody => 'Принятые заказы появятся здесь.';

  @override
  String get todayLower => 'сегодня';

  @override
  String get tomorrowLower => 'завтра';

  @override
  String payoutAmount(String amount) {
    return 'выплата $amount';
  }

  @override
  String get noticeOfferTaken => 'Не успели: заказ взял другой клинер.';

  @override
  String get noticeOfferExpired => 'Время на заказ истекло.';

  @override
  String get noticeSlotTaken =>
      'На это время у вас уже есть заказ, поэтому он не принят.';

  @override
  String get noticeOnlineFailed =>
      'Не удалось сменить статус. Повторите попытку.';

  @override
  String get noticeLocationUnavailable =>
      'Не удалось определить местоположение. Выйдите на открытое место и повторите.';

  @override
  String get noticeLocationOff => 'Включите геолокацию, чтобы выйти на линию.';

  @override
  String get permissionTitle => 'Делитесь местоположением во время работы';

  @override
  String get permissionBullet1 => 'Получайте заказы рядом с вами';

  @override
  String get permissionBullet2 => 'Клиент видит, как вы едете к нему';

  @override
  String get permissionBullet3 =>
      'Только пока приложение открыто, никогда в фоне';

  @override
  String get permissionAllow => 'Разрешить геолокацию';

  @override
  String get permissionNotNow => 'Не сейчас';

  @override
  String get permissionBlockedTitle => 'Геолокация для Tidy Pro отключена';

  @override
  String get permissionBlockedBody =>
      'Разрешите геолокацию в настройках телефона, чтобы выйти на линию.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get permissionLocationOff =>
      'Геолокация на телефоне выключена. Включите её и повторите.';

  @override
  String get newRequestTitle => 'Новый заказ';

  @override
  String jobTitleMeta(String code, String when, String payout) {
    return '#$code · $when · выплата $payout';
  }

  @override
  String get jobNotFound => 'Заказ не найден';

  @override
  String get jobNotFoundBody => 'Возможно, он отменён или перенесён.';

  @override
  String messageClient(String name) {
    return 'Написать: $name';
  }

  @override
  String get openInMaps => 'Открыть на карте';

  @override
  String get mapsFailed => 'Не нашлось приложения карт для этого адреса.';

  @override
  String get progress => 'Ход работы';

  @override
  String get stepAccepted => 'Заказ принят';

  @override
  String get stepOnTheWay => 'В пути';

  @override
  String get stepCleaning => 'Уборка';

  @override
  String get stepFinished => 'Завершено';

  @override
  String get checklist => 'Чек-лист';

  @override
  String get taskKitchen => 'Кухонные поверхности и раковина';

  @override
  String get taskBathroom => 'Ванная и туалет';

  @override
  String get taskFloors => 'Пропылесосить и вымыть полы';

  @override
  String taskExtra(String title) {
    return '$title (доп.)';
  }

  @override
  String get ctaOnMyWay => 'Я выезжаю';

  @override
  String get ctaStart => 'Я на месте, начать уборку';

  @override
  String get ctaFinish => 'Завершить заказ';

  @override
  String get ctaDone => 'Заказ выполнен';

  @override
  String get hintThreeHours =>
      'Выезжать можно не раньше чем за 3 часа до начала.';

  @override
  String sharingLocation(String name) {
    return '$name видит ваше местоположение';
  }

  @override
  String get tooEarlyTitle => 'Рановато';

  @override
  String tooEarlyBody(String time) {
    return 'Нажать «Я выезжаю» можно за 3 часа до начала, для этого заказа это $time.';
  }

  @override
  String get transitionOutOfSync => 'Заказ изменился. Мы обновили данные.';

  @override
  String get ok => 'Понятно';

  @override
  String get finishConfirmTitle => 'Завершить заказ?';

  @override
  String get finishConfirmBody =>
      'С клиента спишется оплата, и ему предложат оставить отзыв. Убедитесь, что всё из списка сделано.';

  @override
  String get finishConfirmAction => 'Завершить';

  @override
  String chatTitle(String name) {
    return 'Чат: $name';
  }

  @override
  String get chatEmptyTitle => 'Сообщений пока нет';

  @override
  String chatEmptyBody(String name) {
    return 'Поздоровайтесь и сообщите $name, когда будете рядом.';
  }

  @override
  String get chatHint => 'Напишите сообщение';

  @override
  String get chatSend => 'Отправить';

  @override
  String get chatSendFailed => 'Сообщение не отправлено. Повторите.';

  @override
  String get scheduleTitle => 'Расписание';

  @override
  String get workingDays => 'Рабочие дни';

  @override
  String get tapToSwitch => 'Нажмите, чтобы изменить';

  @override
  String get from => 'С';

  @override
  String get to => 'До';

  @override
  String get saveHours => 'Сохранить часы работы';

  @override
  String get hoursSaved => 'Часы работы сохранены';

  @override
  String get hoursInvalid => 'Время окончания должно быть позже начала.';

  @override
  String get weekdayMon => 'Понедельник';

  @override
  String get weekdayTue => 'Вторник';

  @override
  String get weekdayWed => 'Среда';

  @override
  String get weekdayThu => 'Четверг';

  @override
  String get weekdayFri => 'Пятница';

  @override
  String get weekdaySat => 'Суббота';

  @override
  String get weekdaySun => 'Воскресенье';

  @override
  String get weekdayShortMon => 'П';

  @override
  String get weekdayShortTue => 'В';

  @override
  String get weekdayShortWed => 'С';

  @override
  String get weekdayShortThu => 'Ч';

  @override
  String get weekdayShortFri => 'П';

  @override
  String get weekdayShortSat => 'С';

  @override
  String get weekdayShortSun => 'В';

  @override
  String get timelineFree => 'Свободно';

  @override
  String timelineBuffer(int minutes) {
    return 'Время на дорогу · $minutes мин';
  }

  @override
  String get timelineDayOff => 'Нет заказов, выходной день';

  @override
  String timelineNoJobs(String from, String to) {
    return 'В этот день заказов нет. Вы свободны с $from до $to.';
  }

  @override
  String timelineJobLine(String range, String place, String payout) {
    return '$range · $place · $payout';
  }

  @override
  String get earningsTitle => 'Доход';

  @override
  String get periodWeek => 'Неделя';

  @override
  String get periodMonth => 'Месяц';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String jobsAndHours(int jobs, String hours) {
    String _temp0 = intl.Intl.pluralLogic(
      jobs,
      locale: localeName,
      other: '$jobs заказа',
      many: '$jobs заказов',
      few: '$jobs заказа',
      one: '$jobs заказ',
    );
    return '$_temp0 · $hours ч';
  }

  @override
  String get payoutDay => 'Выплата в пн';

  @override
  String get tips => 'Чаевые';

  @override
  String get avgPerHour => 'В среднем за час';

  @override
  String get recent => 'Недавние';

  @override
  String get recentEmptyTitle => 'Завершённых заказов пока нет';

  @override
  String get recentEmptyBody => 'Выполненные заказы и чаевые появятся здесь.';

  @override
  String recentTip(String date, String tip) {
    return '$date · чаевые $tip';
  }

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileBio => 'О вас';

  @override
  String get profileNoBio =>
      'Описания пока нет. Попросите поддержку добавить его.';

  @override
  String profileRating(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$rating · $_temp0';
  }

  @override
  String get profilePhone => 'Телефон';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get languageSystem => 'Как в телефоне';

  @override
  String get editName => 'Изменить имя';

  @override
  String get fullName => 'Полное имя';

  @override
  String get save => 'Сохранить';

  @override
  String get signOutConfirmTitle => 'Выйти?';

  @override
  String get signOutConfirmBody =>
      'На этом телефоне вы перестанете получать заказы.';

  @override
  String get profileSaved => 'Профиль обновлён';
}
