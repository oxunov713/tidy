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
}
