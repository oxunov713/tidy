// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Tidy Admin';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get refresh => 'Yangilash';

  @override
  String get loading => 'Yuklanmoqda';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get close => 'Yopish';

  @override
  String get back => 'Orqaga';

  @override
  String get save => 'Saqlash';

  @override
  String get signOut => 'Chiqish';

  @override
  String get accountMenu => 'Hisob menyusi';

  @override
  String get errorTitle => 'Xatolik yuz berdi';

  @override
  String get errorSlotTaken =>
      'Bu tozalovchining shu vaqtda boshqa buyurtmasi bor. Boshqasini tanlang.';

  @override
  String get errorInvalidTransition =>
      'Buyurtma holati bu amalga endi ruxsat bermaydi.';

  @override
  String get errorUnauthorized => 'Sessiya tugadi. Qaytadan kiring.';

  @override
  String get errorForbidden => 'Bu amal uchun ruxsat yo‘q.';

  @override
  String get errorNotFound => 'Bunday element mavjud emas.';

  @override
  String get errorTooManyRequests =>
      'Urinishlar juda ko‘p. Bir daqiqadan so‘ng qayta urining.';

  @override
  String get errorNetwork => 'Serverga ulanib bo‘lmadi. Internetni tekshiring.';

  @override
  String get errorServer =>
      'Serverda muammo yuz berdi. Birozdan so‘ng qayta urining.';

  @override
  String get errorUnknown => 'Kutilmagan xatolik yuz berdi.';

  @override
  String get loginTitle => 'Kirish';

  @override
  String get loginPhoneSubtitle => 'Administrator telefon raqamini kiriting.';

  @override
  String loginCodeSubtitle(String phone) {
    return '$phone raqamiga 6 xonali kod yubordik.';
  }

  @override
  String get loginPhoneLabel => 'Telefon raqami';

  @override
  String get loginPhoneInvalid =>
      'Xalqaro formatdan foydalaning, masalan +447700900001.';

  @override
  String get loginCodeLabel => 'Tasdiqlash kodi';

  @override
  String get loginCodeInvalid => '6 xonali kodni kiriting.';

  @override
  String get loginSendCode => 'Kod yuborish';

  @override
  String get loginSignIn => 'Kirish';

  @override
  String get loginChangeNumber => 'Boshqa raqam';

  @override
  String get loginNoAdminAccess => 'Bu hisobda administrator huquqi yo‘q.';

  @override
  String get navBookings => 'Buyurtmalar';

  @override
  String get navCleaners => 'Tozalovchilar';

  @override
  String get navServices => 'Xizmatlar va narxlar';

  @override
  String get navMenu => 'Menyuni ochish';

  @override
  String get navExpand => 'Menyuni yoyish';

  @override
  String get navCollapse => 'Menyuni yig‘ish';

  @override
  String get statBookingsToday => 'Bugungi buyurtmalar';

  @override
  String get statRevenueToday => 'Bugungi tushum';

  @override
  String get statCleanersOnline => 'Onlayn tozalovchilar';

  @override
  String get statAwaitingApproval => 'Tasdiq kutmoqda';

  @override
  String get searchBookingsHint =>
      'ID, mijoz yoki tozalovchi bo‘yicha qidirish';

  @override
  String get clearSearch => 'Qidiruvni tozalash';

  @override
  String get filterAll => 'Hammasi';

  @override
  String get statusPending => 'Kutilmoqda';

  @override
  String get statusConfirmed => 'Tasdiqlangan';

  @override
  String get statusAssigned => 'Tayinlangan';

  @override
  String get statusOnTheWay => 'Yo‘lda';

  @override
  String get statusInProgress => 'Bajarilmoqda';

  @override
  String get statusCompleted => 'Yakunlangan';

  @override
  String get statusCancelled => 'Bekor qilingan';

  @override
  String get frequencyOnce => 'Bir martalik';

  @override
  String get frequencyWeekly => 'Har hafta';

  @override
  String get frequencyFortnightly => 'Ikki haftada bir';

  @override
  String get columnId => 'ID';

  @override
  String get columnCustomer => 'Mijoz';

  @override
  String get columnService => 'Xizmat';

  @override
  String get columnTime => 'Vaqt';

  @override
  String get columnCleaner => 'Tozalovchi';

  @override
  String get columnStatus => 'Holat';

  @override
  String get columnAmount => 'Summa';

  @override
  String get bookingsEmptyTitle => 'Buyurtmalar topilmadi';

  @override
  String get bookingsEmpty =>
      'Mijozlar buyurtma bergach, ular shu yerda ko‘rinadi.';

  @override
  String get bookingsEmptyFiltered => 'Filtrlarga mos narsa topilmadi.';

  @override
  String get clearFilters => 'Filtrlarni tozalash';

  @override
  String get loadMore => 'Yana yuklash';

  @override
  String get bookingDetails => 'Buyurtma';

  @override
  String get sectionVisit => 'Tashrif';

  @override
  String get sectionCustomer => 'Mijoz';

  @override
  String get sectionAddress => 'Manzil';

  @override
  String get sectionCleaner => 'Tozalovchi';

  @override
  String get sectionPayment => 'To‘lov';

  @override
  String get sectionReview => 'Sharh';

  @override
  String get sectionTimeline => 'Tarix';

  @override
  String get fieldService => 'Xizmat';

  @override
  String get fieldWhen => 'Qachon';

  @override
  String get fieldRooms => 'Xonalar';

  @override
  String get fieldFrequency => 'Takrorlanish';

  @override
  String get fieldName => 'Ism';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldSubtotal => 'Oraliq summa';

  @override
  String get fieldDiscount => 'Chegirma';

  @override
  String get fieldTotal => 'Jami';

  @override
  String get fieldCleanerPayout => 'Tozalovchi haqi';

  @override
  String get notAssigned => 'Tozalovchi hali tayinlanmagan.';

  @override
  String get timelineEmpty => 'Hozircha voqealar yo‘q.';

  @override
  String get assignCleaner => 'Tozalovchi tayinlash';

  @override
  String get reassignCleaner => 'Tozalovchini almashtirish';

  @override
  String get reassignTitle => 'Tozalovchini almashtirish';

  @override
  String get reassignHint =>
      'Tasdiqlangan tozalovchini tanlang. Unga darhol xabar yuboriladi.';

  @override
  String get reassignConfirm => 'Tayinlash';

  @override
  String get noApprovedCleaners => 'Boshqa tasdiqlangan tozalovchilar yo‘q.';

  @override
  String get cleanerReassigned => 'Tozalovchi almashtirildi.';

  @override
  String get cancelBooking => 'Buyurtmani bekor qilish';

  @override
  String cancelBookingTitle(String code) {
    return '$code buyurtmasi bekor qilinsinmi?';
  }

  @override
  String get cancelBookingBody =>
      'Mijozga to‘liq pul qaytariladi, tozalovchiga xabar beriladi. Buni ortga qaytarib bo‘lmaydi.';

  @override
  String get keepBooking => 'Buyurtmani saqlash';

  @override
  String get bookingCancelled => 'Buyurtma bekor qilindi.';

  @override
  String roomsValue(int bedrooms, int bathrooms) {
    return '$bedrooms yotoq, $bathrooms hammom';
  }

  @override
  String ratingSummary(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta sharh',
      one: '1 ta sharh',
    );
    return '$rating ($_temp0)';
  }

  @override
  String reviewRating(int rating) {
    return 'Baho: 5 dan $rating';
  }

  @override
  String get tabPending => 'Ko‘rib chiqilmoqda';

  @override
  String get tabApproved => 'Tasdiqlangan';

  @override
  String get tabSuspended => 'To‘xtatilgan';

  @override
  String get noPendingCleaners => 'Tasdiq kutayotgan tozalovchilar yo‘q.';

  @override
  String get noApprovedCleanersTab => 'Tasdiqlangan tozalovchilar hali yo‘q.';

  @override
  String get noSuspendedCleaners => 'To‘xtatilgan tozalovchilar yo‘q.';

  @override
  String get approve => 'Tasdiqlash';

  @override
  String get reject => 'Rad etish';

  @override
  String get suspend => 'To‘xtatish';

  @override
  String get reinstate => 'Qayta tiklash';

  @override
  String get online => 'Onlayn';

  @override
  String get offline => 'Oflayn';

  @override
  String get noRatingsYet => 'Baholar hali yo‘q';

  @override
  String cleanerApproved(String name) {
    return '$name tasdiqlandi.';
  }

  @override
  String cleanerSuspended(String name) {
    return '$name to‘xtatildi.';
  }

  @override
  String get cleanerUpdateFailed => 'Tozalovchini yangilab bo‘lmadi.';

  @override
  String get servicesIntro =>
      'Narxlar funtda. O‘zgarishlar yangi hisob-kitoblarda darhol kuchga kiradi.';

  @override
  String get noServices => 'Xizmatlar hali yo‘q.';

  @override
  String get columnPerBedroom => 'Yotoq xonasi uchun';

  @override
  String get columnPerBathroom => 'Hammom uchun';

  @override
  String get columnDuration => 'Davomiyligi';

  @override
  String get columnActive => 'Faol';

  @override
  String durationSummary(int base, int perRoom) {
    return '$base daq + xona uchun $perRoom';
  }

  @override
  String get editService => 'Xizmatni tahrirlash';

  @override
  String get fieldServiceName => 'Nomi';

  @override
  String get fieldBasePrice => 'Asosiy narx';

  @override
  String get fieldPerBedroom => 'Har qo‘shimcha yotoq xonasi uchun';

  @override
  String get fieldPerBathroom => 'Har qo‘shimcha hammom uchun';

  @override
  String get fieldBaseMinutes => 'Asosiy davomiylik';

  @override
  String get fieldMinutesPerRoom => 'Qo‘shimcha xona uchun vaqt';

  @override
  String get minutesSuffix => 'daq';

  @override
  String get fieldActive => 'Faol';

  @override
  String get fieldActiveHint =>
      'Faol bo‘lmagan xizmatni buyurtma qilib bo‘lmaydi.';

  @override
  String get validationTitle => '80 belgigacha nom kiriting.';

  @override
  String get validationPrice => 'Funtda summa kiriting, masalan 68 yoki 68.50.';

  @override
  String get validationPricePositive => 'Narx £0 dan katta bo‘lishi kerak.';

  @override
  String get validationPriceTooHigh => 'Eng ko‘pi £10 000.';

  @override
  String validationMinutes(int min, int max) {
    return '$min dan $max gacha butun daqiqa kiriting.';
  }

  @override
  String get serviceSaved => 'Xizmat saqlandi.';

  @override
  String get serviceUpdateFailed => 'Xizmatni yangilab bo‘lmadi.';
}
