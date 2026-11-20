// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Tidy';

  @override
  String get back => 'Orqaga';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get save => 'Saqlash';

  @override
  String get close => 'Yopish';

  @override
  String get errorTitle => 'Xatolik yuz berdi';

  @override
  String get errorNetwork =>
      'Aloqa yo‘q. Internetni tekshirib, qayta urinib ko‘ring.';

  @override
  String get errorSlotTaken => 'Bu vaqtni hozirgina boshqa mijoz band qildi.';

  @override
  String get errorTooManyRequests => 'Urinishlar juda ko‘p. Biroz kuting.';

  @override
  String get errorSessionExpired => 'Seans tugadi. Qaytadan kiring.';

  @override
  String get errorServer =>
      'Serverda muammo bor. Birozdan so‘ng qayta urinib ko‘ring.';

  @override
  String get errorGeneric => 'Kutilmagan xatolik. Qayta urinib ko‘ring.';

  @override
  String stepOf(int step, int total) {
    return '$step-qadam, jami $total';
  }

  @override
  String get navHome => 'Bosh sahifa';

  @override
  String get navBookings => 'Buyurtmalar';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profil';

  @override
  String get welcomeTitle => 'Toza uy — bir daqiqada buyurtma qiling.';

  @override
  String get welcomeSubtitle =>
      'Tekshirilgan yaqin atrofdagi tozalovchilar, qat’iy narxlar va buyurtmadan tugaguncha jonli kuzatuv.';

  @override
  String get phoneNumber => 'Telefon raqami';

  @override
  String get phoneInvalid => 'To‘g‘ri telefon raqamini kiriting';

  @override
  String get sendCode => 'Kod yuborish';

  @override
  String get continueWithGoogle => 'Google orqali davom etish';

  @override
  String get googleSoon =>
      'Google orqali kirish tez orada qo‘shiladi. Hozircha telefon raqamidan foydalaning.';

  @override
  String get termsNotice =>
      'Davom etish orqali siz Shartlar va Maxfiylik siyosatiga rozilik bildirasiz.';

  @override
  String get selectCountry => 'Mamlakatni tanlang';

  @override
  String get otpTitle => 'Kodni kiriting';

  @override
  String otpSubtitle(String phone) {
    return '$phone raqamiga 6 xonali kod yubordik.';
  }

  @override
  String resendIn(int seconds) {
    return 'Kodni $seconds soniyadan so‘ng qayta yuborish';
  }

  @override
  String get resendCode => 'Kodni qayta yuborish';

  @override
  String get codeSent => 'Yangi kod yuborildi.';
}
