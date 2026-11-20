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

  @override
  String get fieldRequired => 'Majburiy maydon';

  @override
  String get dropPinFirst => 'Avval xaritada uyingizni belgilang.';

  @override
  String get pinDropped => 'Belgi qo‘yildi. Ko‘chirish uchun bosing.';

  @override
  String get tapToDropPin => 'Belgi qo‘yish uchun xaritani bosing';

  @override
  String get addAddressTitle => 'Qayerda tozalaymiz?';

  @override
  String get addressLine1 => 'Manzil';

  @override
  String get addressLine2 => 'Xonadon, qavat (ixtiyoriy)';

  @override
  String get city => 'Shahar';

  @override
  String get postcode => 'Pochta indeksi';

  @override
  String get accessNotes => 'Kirish bo‘yicha izoh';

  @override
  String get accessNotesHint =>
      'Kalit qutida, yuqoridagi qo‘ng‘iroqni bosing...';

  @override
  String get saveAddress => 'Manzilni saqlash';

  @override
  String get chooseAddress => 'Manzilni tanlang';

  @override
  String get myAddresses => 'Manzillarim';

  @override
  String get noAddressesTitle => 'Hozircha manzil yo‘q';

  @override
  String get noAddressesBody =>
      'Tozalanadigan manzilni qo‘shing va tozalovchi topishi uchun xaritada belgilang.';

  @override
  String get addAddress => 'Manzil qo‘shish';

  @override
  String get deleteAddress => 'O‘chirish';

  @override
  String get deleteAddressTitle => 'Bu manzil o‘chirilsinmi?';

  @override
  String homeGreeting(String name) {
    return 'Salom, $name! Bugun nimani tozalaymiz?';
  }

  @override
  String get homeGreetingAnonymous => 'Salom! Bugun nimani tozalaymiz?';

  @override
  String get cleaningAt => 'Tozalash manzili';

  @override
  String get addYourAddress => 'Manzilingizni qo‘shing';

  @override
  String get notifications => 'Bildirishnomalar';

  @override
  String get noNotifications => 'Yangi bildirishnomalar yo‘q.';

  @override
  String get promoBadge => '20% CHEGIRMA';

  @override
  String get promoTitle => 'Birinchi chuqur tozalashingiz';

  @override
  String get promoCode => 'To‘lovda TIDY20 kodidan foydalaning';

  @override
  String get servicesTitle => 'Xizmatlar';

  @override
  String get seeAll => 'Barchasi';

  @override
  String get noServicesTitle => 'Xizmatlar mavjud emas';

  @override
  String get noServicesBody =>
      'Yaqinda qaytib keling, yangilarini qo‘shyapmiz.';

  @override
  String get badgeMostBooked => 'ENG KO‘P BUYURTMA';

  @override
  String get badgePremium => 'PREMIUM';

  @override
  String hoursUnit(String value) {
    return '$value soat';
  }

  @override
  String get fromLabel => 'DAN';

  @override
  String serviceCardSemantics(String title, String price) {
    return '$title, $price dan';
  }

  @override
  String cleanerOnTheWay(String name) {
    return '$name yo‘lda';
  }

  @override
  String cleanerCleaning(String name) {
    return '$name tozalayapti';
  }

  @override
  String cleanerBooked(String name) {
    return '$name buyurtmangizga tayinlandi';
  }

  @override
  String get yourCleanerOnTheWay => 'Tozalovchingiz yo‘lda';

  @override
  String get yourCleanerCleaning => 'Tozalovchingiz tozalayapti';

  @override
  String get yourCleanerBooked => 'Buyurtmangizga tozalovchi tayinlandi';

  @override
  String get cardDetailInvalid => 'Maydonni tekshiring';

  @override
  String payAmount(String amount) {
    return '$amount to‘lash';
  }

  @override
  String get testMode => 'Test rejimi';

  @override
  String get testModeNotice =>
      'Haqiqiy to‘lov amalga oshirilmaydi. Istalgan karta ma’lumotlarini kiriting.';

  @override
  String get cardNumber => 'Karta raqami';

  @override
  String get cardExpiry => 'OO/YY';

  @override
  String get cardCvc => 'CVC';

  @override
  String get chooseServiceFirst => 'Buyurtma boshlash uchun xizmatni tanlang.';

  @override
  String get sizeOfHome => 'Uy hajmi';

  @override
  String get bedrooms => 'Yotoq xonalar';

  @override
  String get bedroomsHint => 'Mehmonxona kiritilgan';

  @override
  String get bathrooms => 'Hammomlar';

  @override
  String get bathroomsHint => 'Hojatxona, dush yoki vanna';

  @override
  String get addBedroom => 'Yotoq xona qo‘shish';

  @override
  String get removeBedroom => 'Yotoq xonani olib tashlash';

  @override
  String get addBathroom => 'Hammom qo‘shish';

  @override
  String get removeBathroom => 'Hammomni olib tashlash';

  @override
  String get extras => 'Qo‘shimchalar';

  @override
  String get howOften => 'Qanchalik tez-tez?';

  @override
  String get frequencyOnce => 'Bir martalik';

  @override
  String get frequencyOnceNote => 'Chegirmasiz';

  @override
  String get frequencyWeekly => 'Haftalik';

  @override
  String get frequencyWeeklyNote => '15% chegirma';

  @override
  String get frequencyFortnightly => 'Ikki haftalik';

  @override
  String get frequencyFortnightlyNote => '10% chegirma';

  @override
  String get chooseTime => 'Vaqtni tanlash';

  @override
  String get total => 'Jami';

  @override
  String totalWithHours(String hours) {
    return 'Jami · $hours soat';
  }

  @override
  String get whenShouldWeCome => 'Qachon kelaylik?';

  @override
  String get nextSevenDays => 'Keyingi 7 kun';

  @override
  String get startTime => 'Boshlanish vaqti';

  @override
  String get takenTimesNote =>
      'Kulrang vaqtlarni atrofdagi barcha tozalovchilar band qilgan.';

  @override
  String get noTimesThatDay =>
      'Bu kunga bo‘sh vaqt qolmadi. Boshqa kunni tanlang.';

  @override
  String get cleaner => 'Tozalovchi';

  @override
  String get anyCleaner => 'Istalgan bo‘sh tozalovchi';

  @override
  String get anyCleanerNote =>
      'Atrofdagi eng yaxshi bo‘sh tozalovchini tanlab beramiz.';

  @override
  String yourLastCleaner(String name) {
    return '$name · oxirgi tozalovchingiz';
  }

  @override
  String ratingAndReviews(String rating, int count) {
    return 'Reyting $rating · $count ta sharh';
  }

  @override
  String get continueToPayment => 'To‘lovga o‘tish';

  @override
  String get pickATime => 'Kun va boshlanish vaqtini tanlang';

  @override
  String scheduleSummary(String day, String time, String hours) {
    return '$day · $time da boshlanadi · taxminan $hours soat';
  }

  @override
  String scheduleSummaryShort(String day, String time) {
    return '$day · $time da boshlanadi';
  }

  @override
  String get confirmAndPay => 'Tasdiqlash va to‘lash';

  @override
  String get change => 'O‘zgartirish';

  @override
  String get summary => 'Buyurtma tafsilotlari';

  @override
  String get payment => 'To‘lov';

  @override
  String get payByCard => 'Karta orqali to‘lash';

  @override
  String get securePaymentStripe => 'Stripe orqali xavfsiz to‘lov';

  @override
  String get chargedAfterClean => 'Pul faqat tozalash tugagach yechiladi.';

  @override
  String get book => 'Buyurtma berish';

  @override
  String bookFor(String price) {
    return '$price ga buyurtma berish';
  }

  @override
  String get slotTakenSnack =>
      'Bu vaqt hozirgina band bo‘ldi. Bo‘sh vaqtlar yangilandi.';

  @override
  String get paymentFailed => 'To‘lov amalga oshmadi. Qayta urinib ko‘ring.';

  @override
  String get paymentCancelled =>
      'To‘lov yakunlanmadi. Buyurtma to‘lovni kutmoqda.';

  @override
  String get statusPending => 'To‘lov kutilmoqda';

  @override
  String get statusConfirmed => 'Tasdiqlangan';

  @override
  String get statusAssigned => 'Tozalovchi tayinlandi';

  @override
  String get statusOnTheWay => 'Yo‘lda';

  @override
  String get statusInProgress => 'Jarayonda';

  @override
  String get statusCompleted => 'Bajarildi';

  @override
  String get statusCancelled => 'Bekor qilindi';

  @override
  String get cancelBookingTitle => 'Buyurtma bekor qilinsinmi?';

  @override
  String get cancelFreeBody =>
      'Hozir bekor qilish bepul. Pul to‘liq qaytariladi.';

  @override
  String cancelLateBody(String price) {
    return 'Tozalashga 24 soatdan kam qoldi, shuning uchun bekor qilsangiz to‘liq narx ($price) yechiladi.';
  }

  @override
  String get keepBooking => 'Buyurtmani qoldirish';

  @override
  String get cancelBooking => 'Buyurtmani bekor qilish';

  @override
  String cancelledRefunded(String price) {
    return 'Buyurtma bekor qilindi. $price qaytariladi.';
  }

  @override
  String cancelledCharged(String price) {
    return 'Buyurtma bekor qilindi. Boshlanishiga 24 soatdan kam qolgani uchun $price yechildi.';
  }

  @override
  String get serviceUnavailable => 'Bu xizmat endi mavjud emas.';

  @override
  String get findingCleaner => 'Tozalovchi qidirilmoqda';

  @override
  String get noCleaner => 'Tozalovchi yo‘q';

  @override
  String todayAt(String time) {
    return 'Bugun · $time';
  }

  @override
  String get track => 'Kuzatish';

  @override
  String get rate => 'Baholash';

  @override
  String get bookAgain => 'Qayta buyurtma';

  @override
  String get details => 'Tafsilotlar';

  @override
  String get upcoming => 'Kutilayotgan';

  @override
  String get past => 'O‘tgan';

  @override
  String get noUpcomingTitle => 'Hozircha buyurtma yo‘q';

  @override
  String get noUpcomingBody =>
      'Birinchi tozalashni bir daqiqada buyurtma qiling.';

  @override
  String get bookAClean => 'Tozalash buyurtma qilish';

  @override
  String get noPastTitle => 'O‘tgan tozalashlar yo‘q';

  @override
  String get noPastBody =>
      'Bajarilgan va bekor qilingan buyurtmalar shu yerda ko‘rinadi.';

  @override
  String get couldNotLoadMore =>
      'Yana yuklab bo‘lmadi. Qayta urinish uchun bosing.';

  @override
  String get bookingDetails => 'Buyurtma tafsilotlari';

  @override
  String bookingNumber(String code) {
    return 'Buyurtma №$code';
  }

  @override
  String roomsSummary(int bedrooms, int bathrooms) {
    return '$bedrooms yotoq xona, $bathrooms hammom';
  }

  @override
  String messageCleaner(String name) {
    return '$name ga yozish';
  }

  @override
  String get discount => 'Chegirma';

  @override
  String get trackCleaner => 'Tozalovchini kuzatish';

  @override
  String get rateYourClean => 'Tozalashni baholash';

  @override
  String get yourReview => 'Sizning sharhingiz';

  @override
  String tipAmount(String amount) {
    return 'Choychaqa $amount';
  }

  @override
  String get timeline => 'Tarix';

  @override
  String get stepConfirmed => 'Tasdiqlandi';

  @override
  String get stepOnTheWay => 'Yo‘lda';

  @override
  String get stepCleaning => 'Tozalash';

  @override
  String get stepDone => 'Tayyor';

  @override
  String get arrivingIn => 'Yetib keladi';

  @override
  String minutesShort(int minutes) {
    return '$minutes daqiqa';
  }

  @override
  String get onTheWayHeadline => 'Yo‘lda';

  @override
  String get startsAt => 'Boshlanishi';

  @override
  String get rightNow => 'Hozir';

  @override
  String get cleaningHeadline => 'Tozalanmoqda';

  @override
  String get finished => 'Yakunlandi';

  @override
  String get allDone => 'Hammasi tayyor';

  @override
  String get bookingLabel => 'Buyurtma';

  @override
  String get needToChange => 'Nimanidir o‘zgartirish kerakmi?';

  @override
  String callCleaner(String name) {
    return '$name ga qo‘ng‘iroq qilish';
  }

  @override
  String get callUnavailable =>
      'Qo‘ng‘iroq hozircha mavjud emas. Xabar yozing.';
}
