// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Tidy Pro';

  @override
  String get loading => 'Yuklanmoqda';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get errorTitle => 'Nimadir xato ketdi';

  @override
  String get errorOffline =>
      'Aloqa yo\'q. Internetni tekshirib, qayta urinib ko\'ring.';

  @override
  String get errorTooManyRequests =>
      'Urinishlar juda ko\'p. Bir daqiqa kutib turing.';

  @override
  String get errorSlotTaken => 'Bu vaqtda sizda boshqa buyurtma bor.';

  @override
  String get errorNotFound => 'Topilmadi.';

  @override
  String get errorInvalidTransition => 'Bu buyurtma uchun endi bu mumkin emas.';

  @override
  String get errorSessionExpired => 'Seans tugadi. Qaytadan kiring.';

  @override
  String get errorForbidden => 'Bunga ruxsatingiz yo\'q.';

  @override
  String get errorServer =>
      'Serverda muammo bor. Birozdan so\'ng qayta urinib ko\'ring.';

  @override
  String get errorGeneric => 'Bajarilmadi. Qayta urinib ko\'ring.';

  @override
  String get errorPhoneInvalid => 'To\'g\'ri telefon raqamini kiriting.';

  @override
  String get errorWrongRole =>
      'Bu raqam mijoz hisobiga tegishli. Mijozlar uchun Tidy ilovasidan foydalaning.';

  @override
  String get signInTitle => 'Keyingi buyurtma bir bosishda.';

  @override
  String get signInSubtitle =>
      'Yaqin atrofdagi tozalash buyurtmalarini qabul qiling, kuningizni rejalang va daromadingizni kuzating.';

  @override
  String get phoneNumber => 'Telefon raqami';

  @override
  String get sendCode => 'Kod yuborish';

  @override
  String get verifyCode => 'Tasdiqlash';

  @override
  String get changeNumber => 'Boshqa raqam';

  @override
  String get verificationCode => '6 xonali kod';

  @override
  String codeSentTo(String phone) {
    return 'Kod $phone raqamiga yuborildi';
  }

  @override
  String get signInTerms =>
      'Davom etib, Foydalanish shartlari va Maxfiylik siyosatiga rozilik bildirasiz.';

  @override
  String get pendingTitle => 'Profilingiz ko\'rib chiqilmoqda';

  @override
  String get pendingBody =>
      'Ro\'yxatdan o\'tganingiz uchun rahmat! Har bir yangi tozalovchi tekshiriladi, bu odatda bir kun oladi. Tasdiqlangach, onlayn bo\'lishingiz mumkin.';

  @override
  String get pullToRefresh => 'Yangilash uchun pastga torting';

  @override
  String get suspendedTitle => 'Hisobingiz to\'xtatilgan';

  @override
  String get suspendedBody =>
      'Hozir yangi buyurtma qabul qila olmaysiz. Xato deb o\'ylasangiz, Tidy yordam xizmatiga murojaat qiling.';

  @override
  String get signOut => 'Chiqish';

  @override
  String get navJobs => 'Buyurtmalar';

  @override
  String get navSchedule => 'Jadval';

  @override
  String get navEarnings => 'Daromad';

  @override
  String get navProfile => 'Profil';

  @override
  String get online => 'Onlayn';

  @override
  String get offline => 'Oflayn';

  @override
  String get goOnline => 'Onlayn bo\'lish';

  @override
  String get statToday => 'Bugun';

  @override
  String get statJobs => 'Buyurtma';

  @override
  String get statRating => 'Reyting';

  @override
  String jobsDoneOfTotal(int done, int total) {
    return '$done / $total';
  }

  @override
  String get newRequest => 'YANGI BUYURTMA';

  @override
  String expiresIn(String time) {
    return '$time dan so\'ng tugaydi';
  }

  @override
  String get yourPayout => 'sizning haqingiz';

  @override
  String get decline => 'Rad etish';

  @override
  String get accept => 'Qabul qilish';

  @override
  String get later => 'Keyinroq';

  @override
  String bedBath(int bedrooms, int bathrooms) {
    return '$bedrooms yotoqxona · $bathrooms hammom';
  }

  @override
  String offerPlaceDistance(String place, String km) {
    return '$place · sizdan $km km';
  }

  @override
  String get offerPlaceLoading => 'Manzil qabul qilgandan so\'ng ko\'rinadi';

  @override
  String get offlineTitle => 'Siz oflaynsiz';

  @override
  String get offlineBody =>
      'Yaqin atrofdagi buyurtmalarni olish uchun onlayn bo\'ling.';

  @override
  String get waitingTitle => 'Yangi buyurtmalar kutilmoqda';

  @override
  String get waitingBody => 'Buyurtma kelishi bilan signal eshitasiz.';

  @override
  String get nextUp => 'Keyingilari';

  @override
  String get noUpcomingTitle => 'Kelgusi buyurtmalar yo\'q';

  @override
  String get noUpcomingBody =>
      'Qabul qilingan buyurtmalar shu yerda ko\'rinadi.';

  @override
  String get todayLower => 'bugun';

  @override
  String get tomorrowLower => 'ertaga';

  @override
  String payoutAmount(String amount) {
    return 'haq: $amount';
  }

  @override
  String get noticeOfferTaken =>
      'Kech qoldingiz, buyurtmani boshqa tozalovchi oldi.';

  @override
  String get noticeOfferExpired => 'Buyurtma muddati tugadi.';

  @override
  String get noticeSlotTaken =>
      'Bu vaqtda sizda boshqa buyurtma bor, shuning uchun qabul qilinmadi.';

  @override
  String get noticeOnlineFailed =>
      'Holatni o\'zgartirib bo\'lmadi. Qayta urinib ko\'ring.';

  @override
  String get noticeLocationUnavailable =>
      'Joylashuvingiz aniqlanmadi. Ochiq joyga chiqib, qayta urinib ko\'ring.';

  @override
  String get noticeLocationOff =>
      'Onlayn bo\'lish uchun geolokatsiyani yoqing.';

  @override
  String get permissionTitle => 'Ish paytida joylashuvingizni ulashing';

  @override
  String get permissionBullet1 => 'O\'zingizga yaqin buyurtmalarni oling';

  @override
  String get permissionBullet2 =>
      'Mijoz yo\'lda ekaningizda sizni kuzata oladi';

  @override
  String get permissionBullet3 =>
      'Faqat ilova ochiq paytda, hech qachon fonda emas';

  @override
  String get permissionAllow => 'Joylashuvga ruxsat berish';

  @override
  String get permissionNotNow => 'Hozir emas';

  @override
  String get permissionBlockedTitle => 'Tidy Pro uchun joylashuv o\'chirilgan';

  @override
  String get permissionBlockedBody =>
      'Onlayn bo\'lish uchun telefon sozlamalarida joylashuvga ruxsat bering.';

  @override
  String get openSettings => 'Sozlamalarni ochish';

  @override
  String get permissionLocationOff =>
      'Telefonda joylashuv xizmati o\'chiq. Uni yoqib, qayta urinib ko\'ring.';

  @override
  String get newRequestTitle => 'Yangi buyurtma';

  @override
  String jobTitleMeta(String code, String when, String payout) {
    return '#$code · $when · haq: $payout';
  }

  @override
  String get jobNotFound => 'Buyurtma topilmadi';

  @override
  String get jobNotFoundBody =>
      'U bekor qilingan yoki ko\'chirilgan bo\'lishi mumkin.';

  @override
  String messageClient(String name) {
    return '$name ga yozish';
  }

  @override
  String get openInMaps => 'Xaritada ochish';

  @override
  String get mapsFailed => 'Bu manzilni ochadigan xarita ilovasi topilmadi.';

  @override
  String get progress => 'Jarayon';

  @override
  String get stepAccepted => 'Buyurtma qabul qilindi';

  @override
  String get stepOnTheWay => 'Yo\'lda';

  @override
  String get stepCleaning => 'Tozalash';

  @override
  String get stepFinished => 'Yakunlandi';

  @override
  String get checklist => 'Tekshiruv ro\'yxati';

  @override
  String get taskKitchen => 'Oshxona sirtlari va rakovina';

  @override
  String get taskBathroom => 'Hammom va hojatxona';

  @override
  String get taskFloors => 'Changyutish va polni yuvish';

  @override
  String taskExtra(String title) {
    return '$title (qo\'shimcha)';
  }

  @override
  String get ctaOnMyWay => 'Yo\'lga chiqdim';

  @override
  String get ctaStart => 'Yetib keldim, tozalashni boshlash';

  @override
  String get ctaFinish => 'Buyurtmani yakunlash';

  @override
  String get ctaDone => 'Buyurtma bajarildi';

  @override
  String get hintThreeHours =>
      'Boshlanishidan 3 soat oldindan yo\'lga chiqish mumkin.';

  @override
  String sharingLocation(String name) {
    return '$name joylashuvingizni ko\'rmoqda';
  }

  @override
  String get tooEarlyTitle => 'Hali erta';

  @override
  String tooEarlyBody(String time) {
    return '«Yo\'lga chiqdim» tugmasini boshlanishdan 3 soat oldin, bu buyurtma uchun $time dan bosish mumkin.';
  }

  @override
  String get transitionOutOfSync =>
      'Buyurtma o\'zgargan. Ma\'lumotlar yangilandi.';

  @override
  String get ok => 'Tushunarli';

  @override
  String get finishConfirmTitle => 'Buyurtmani yakunlaysizmi?';

  @override
  String get finishConfirmBody =>
      'Mijozdan to\'lov olinadi va unga sharh qoldirish taklif qilinadi. Ro\'yxatdagi hamma ishlar bajarilganini tekshiring.';

  @override
  String get finishConfirmAction => 'Yakunlash';

  @override
  String chatTitle(String name) {
    return '$name bilan chat';
  }

  @override
  String get chatEmptyTitle => 'Hozircha xabarlar yo\'q';

  @override
  String chatEmptyBody(String name) {
    return 'Salom yozing va yaqinlashganingizda $name ga xabar bering.';
  }

  @override
  String get chatHint => 'Xabar yozing';

  @override
  String get chatSend => 'Yuborish';

  @override
  String get chatSendFailed => 'Xabar yuborilmadi. Qayta urinib ko\'ring.';

  @override
  String get scheduleTitle => 'Jadval';

  @override
  String get workingDays => 'Ish kunlari';

  @override
  String get tapToSwitch => 'O\'zgartirish uchun bosing';

  @override
  String get from => 'Dan';

  @override
  String get to => 'Gacha';

  @override
  String get saveHours => 'Ish vaqtini saqlash';

  @override
  String get hoursSaved => 'Ish vaqti saqlandi';

  @override
  String get hoursInvalid =>
      'Tugash vaqti boshlanish vaqtidan keyin bo\'lishi kerak.';

  @override
  String get weekdayMon => 'Dushanba';

  @override
  String get weekdayTue => 'Seshanba';

  @override
  String get weekdayWed => 'Chorshanba';

  @override
  String get weekdayThu => 'Payshanba';

  @override
  String get weekdayFri => 'Juma';

  @override
  String get weekdaySat => 'Shanba';

  @override
  String get weekdaySun => 'Yakshanba';

  @override
  String get weekdayShortMon => 'D';

  @override
  String get weekdayShortTue => 'S';

  @override
  String get weekdayShortWed => 'Ch';

  @override
  String get weekdayShortThu => 'P';

  @override
  String get weekdayShortFri => 'J';

  @override
  String get weekdayShortSat => 'Sh';

  @override
  String get weekdayShortSun => 'Y';

  @override
  String get timelineFree => 'Bo\'sh';

  @override
  String timelineBuffer(int minutes) {
    return 'Yo\'l vaqti · $minutes daq';
  }

  @override
  String get timelineDayOff => 'Buyurtma yo\'q, dam olish kuni';

  @override
  String timelineNoJobs(String from, String to) {
    return 'Bu kunda buyurtma yo\'q. Siz $from dan $to gacha bo\'shsiz.';
  }

  @override
  String timelineJobLine(String range, String place, String payout) {
    return '$range · $place · $payout';
  }

  @override
  String get earningsTitle => 'Daromad';

  @override
  String get periodWeek => 'Hafta';

  @override
  String get periodMonth => 'Oy';

  @override
  String get thisWeek => 'Shu hafta';

  @override
  String get thisMonth => 'Shu oy';

  @override
  String jobsAndHours(int jobs, String hours) {
    return '$jobs ta buyurtma · $hours soat';
  }

  @override
  String get payoutDay => 'To\'lov: dush';

  @override
  String get tips => 'Choy puli';

  @override
  String get avgPerHour => 'Soatiga o\'rtacha';

  @override
  String get recent => 'So\'nggilari';

  @override
  String get recentEmptyTitle => 'Yakunlangan buyurtmalar hali yo\'q';

  @override
  String get recentEmptyBody =>
      'Bajarilgan buyurtmalar va choy puli shu yerda ko\'rinadi.';

  @override
  String recentTip(String date, String tip) {
    return '$date · choy puli $tip';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileBio => 'Siz haqingizda';

  @override
  String get profileNoBio =>
      'Hozircha ma\'lumot yo\'q. Qo\'shishni yordam xizmatidan so\'rang.';

  @override
  String profileRating(String rating, int count) {
    return '$rating · $count ta sharh';
  }

  @override
  String get profilePhone => 'Telefon';

  @override
  String get profileLanguage => 'Til';

  @override
  String get languageSystem => 'Telefon tili';

  @override
  String get editName => 'Ismni o\'zgartirish';

  @override
  String get fullName => 'To\'liq ism';

  @override
  String get save => 'Saqlash';

  @override
  String get signOutConfirmTitle => 'Chiqasizmi?';

  @override
  String get signOutConfirmBody =>
      'Bu telefonda buyurtmalar kelishi to\'xtaydi.';

  @override
  String get profileSaved => 'Profil yangilandi';

  @override
  String get chatClosed => 'Bu suhbat yopilgan.';
}
