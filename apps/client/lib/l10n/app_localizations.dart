import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tidy'**
  String get appTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get errorNetwork;

  /// No description provided for @errorSlotTaken.
  ///
  /// In en, this message translates to:
  /// **'That time was just booked by someone else.'**
  String get errorSlotTaken;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get errorTooManyRequests;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Our servers are having trouble. Please try again soon.'**
  String get errorServer;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Please try again.'**
  String get errorGeneric;

  /// Wizard progress caption
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOf(int step, int total);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'A spotless home, booked in a minute.'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vetted local cleaners, fixed prices, and live tracking from booking to done.'**
  String get welcomeSubtitle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @googleSoon.
  ///
  /// In en, this message translates to:
  /// **'Google sign in is coming soon. Use your phone number for now.'**
  String get googleSoon;

  /// No description provided for @termsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms and Privacy Policy.'**
  String get termsNotice;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String otpSubtitle(String phone);

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get codeSent;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @dropPinFirst.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to drop a pin on your home first.'**
  String get dropPinFirst;

  /// No description provided for @pinDropped.
  ///
  /// In en, this message translates to:
  /// **'Pin placed. Tap to move it.'**
  String get pinDropped;

  /// No description provided for @tapToDropPin.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to drop a pin'**
  String get tapToDropPin;

  /// No description provided for @addAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Where should we clean?'**
  String get addAddressTitle;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address line 1'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Flat, floor (optional)'**
  String get addressLine2;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @postcode.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get postcode;

  /// No description provided for @accessNotes.
  ///
  /// In en, this message translates to:
  /// **'Access notes for the cleaner'**
  String get accessNotes;

  /// No description provided for @accessNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Key in the lockbox, ring the top bell...'**
  String get accessNotesHint;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get saveAddress;

  /// No description provided for @chooseAddress.
  ///
  /// In en, this message translates to:
  /// **'Choose address'**
  String get chooseAddress;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My addresses'**
  String get myAddresses;

  /// No description provided for @noAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'No addresses yet'**
  String get noAddressesTitle;

  /// No description provided for @noAddressesBody.
  ///
  /// In en, this message translates to:
  /// **'Add the place you want cleaned and drop a pin so cleaners can find it.'**
  String get noAddressesBody;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAddress;

  /// No description provided for @deleteAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get deleteAddressTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, what needs a clean today?'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Hi, what needs a clean today?'**
  String get homeGreetingAnonymous;

  /// No description provided for @cleaningAt.
  ///
  /// In en, this message translates to:
  /// **'Cleaning at'**
  String get cleaningAt;

  /// No description provided for @addYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Add your address'**
  String get addYourAddress;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up.'**
  String get noNotifications;

  /// No description provided for @promoBadge.
  ///
  /// In en, this message translates to:
  /// **'20% OFF'**
  String get promoBadge;

  /// No description provided for @promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first deep clean'**
  String get promoTitle;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Code TIDY20 at checkout'**
  String get promoCode;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesTitle;

  /// No description provided for @noServicesBody.
  ///
  /// In en, this message translates to:
  /// **'Check back soon, we are adding more.'**
  String get noServicesBody;

  /// No description provided for @badgeMostBooked.
  ///
  /// In en, this message translates to:
  /// **'MOST BOOKED'**
  String get badgeMostBooked;

  /// No description provided for @badgePremium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get badgePremium;

  /// No description provided for @hoursUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} h'**
  String hoursUnit(String value);

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'FROM'**
  String get fromLabel;

  /// No description provided for @serviceCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'{title}, from {price}'**
  String serviceCardSemantics(String title, String price);

  /// No description provided for @cleanerOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'{name} is on the way'**
  String cleanerOnTheWay(String name);

  /// No description provided for @cleanerCleaning.
  ///
  /// In en, this message translates to:
  /// **'{name} is cleaning'**
  String cleanerCleaning(String name);

  /// No description provided for @cleanerBooked.
  ///
  /// In en, this message translates to:
  /// **'{name} is booked for you'**
  String cleanerBooked(String name);

  /// No description provided for @yourCleanerOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Your cleaner is on the way'**
  String get yourCleanerOnTheWay;

  /// No description provided for @yourCleanerCleaning.
  ///
  /// In en, this message translates to:
  /// **'Your cleaner is cleaning'**
  String get yourCleanerCleaning;

  /// No description provided for @yourCleanerBooked.
  ///
  /// In en, this message translates to:
  /// **'A cleaner is booked for you'**
  String get yourCleanerBooked;

  /// No description provided for @cardDetailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check this field'**
  String get cardDetailInvalid;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// No description provided for @testMode.
  ///
  /// In en, this message translates to:
  /// **'Test mode'**
  String get testMode;

  /// No description provided for @testModeNotice.
  ///
  /// In en, this message translates to:
  /// **'No real payment is made. Use any card details.'**
  String get testModeNotice;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @cardExpiry.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get cardExpiry;

  /// No description provided for @cardCvc.
  ///
  /// In en, this message translates to:
  /// **'CVC'**
  String get cardCvc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
