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

  /// No description provided for @trackingEnded.
  ///
  /// In en, this message translates to:
  /// **'Live updates for this visit have ended.'**
  String get trackingEnded;

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

  /// No description provided for @errorWrongRole.
  ///
  /// In en, this message translates to:
  /// **'This number belongs to a cleaner account. Use the Tidy Pro app instead.'**
  String get errorWrongRole;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do that.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find that.'**
  String get errorNotFound;

  /// No description provided for @errorInvalidTransition.
  ///
  /// In en, this message translates to:
  /// **'That is not possible for this booking any more.'**
  String get errorInvalidTransition;

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

  /// No description provided for @chooseServiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a service to start a booking.'**
  String get chooseServiceFirst;

  /// No description provided for @sizeOfHome.
  ///
  /// In en, this message translates to:
  /// **'Size of your home'**
  String get sizeOfHome;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @bedroomsHint.
  ///
  /// In en, this message translates to:
  /// **'Living room included'**
  String get bedroomsHint;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @bathroomsHint.
  ///
  /// In en, this message translates to:
  /// **'Toilet, shower or bath'**
  String get bathroomsHint;

  /// No description provided for @addBedroom.
  ///
  /// In en, this message translates to:
  /// **'Add bedroom'**
  String get addBedroom;

  /// No description provided for @removeBedroom.
  ///
  /// In en, this message translates to:
  /// **'Remove bedroom'**
  String get removeBedroom;

  /// No description provided for @addBathroom.
  ///
  /// In en, this message translates to:
  /// **'Add bathroom'**
  String get addBathroom;

  /// No description provided for @removeBathroom.
  ///
  /// In en, this message translates to:
  /// **'Remove bathroom'**
  String get removeBathroom;

  /// No description provided for @extras.
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get extras;

  /// No description provided for @howOften.
  ///
  /// In en, this message translates to:
  /// **'How often?'**
  String get howOften;

  /// No description provided for @frequencyOnce.
  ///
  /// In en, this message translates to:
  /// **'One-off'**
  String get frequencyOnce;

  /// No description provided for @frequencyOnceNote.
  ///
  /// In en, this message translates to:
  /// **'No discount'**
  String get frequencyOnceNote;

  /// No description provided for @frequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// No description provided for @frequencyWeeklyNote.
  ///
  /// In en, this message translates to:
  /// **'15% off'**
  String get frequencyWeeklyNote;

  /// No description provided for @frequencyFortnightly.
  ///
  /// In en, this message translates to:
  /// **'Fortnightly'**
  String get frequencyFortnightly;

  /// No description provided for @frequencyFortnightlyNote.
  ///
  /// In en, this message translates to:
  /// **'10% off'**
  String get frequencyFortnightlyNote;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose time'**
  String get chooseTime;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalWithHours.
  ///
  /// In en, this message translates to:
  /// **'Total · {hours} h'**
  String totalWithHours(String hours);

  /// No description provided for @whenShouldWeCome.
  ///
  /// In en, this message translates to:
  /// **'When should we come?'**
  String get whenShouldWeCome;

  /// No description provided for @nextSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get nextSevenDays;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @takenTimesNote.
  ///
  /// In en, this message translates to:
  /// **'Greyed-out times are already booked by all nearby cleaners.'**
  String get takenTimesNote;

  /// No description provided for @noTimesThatDay.
  ///
  /// In en, this message translates to:
  /// **'No times left on this day. Try another day.'**
  String get noTimesThatDay;

  /// No description provided for @cleaner.
  ///
  /// In en, this message translates to:
  /// **'Cleaner'**
  String get cleaner;

  /// No description provided for @anyCleaner.
  ///
  /// In en, this message translates to:
  /// **'Any available cleaner'**
  String get anyCleaner;

  /// No description provided for @anyCleanerNote.
  ///
  /// In en, this message translates to:
  /// **'We will match you with the best available cleaner nearby.'**
  String get anyCleanerNote;

  /// No description provided for @yourLastCleaner.
  ///
  /// In en, this message translates to:
  /// **'{name} · your last cleaner'**
  String yourLastCleaner(String name);

  /// No description provided for @ratingAndReviews.
  ///
  /// In en, this message translates to:
  /// **'{rating} rating · {count} reviews'**
  String ratingAndReviews(String rating, int count);

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get continueToPayment;

  /// No description provided for @pickATime.
  ///
  /// In en, this message translates to:
  /// **'Pick a day and a start time'**
  String get pickATime;

  /// No description provided for @scheduleSummary.
  ///
  /// In en, this message translates to:
  /// **'{day} · {time} start · about {hours} h'**
  String scheduleSummary(String day, String time, String hours);

  /// No description provided for @scheduleSummaryShort.
  ///
  /// In en, this message translates to:
  /// **'{day} · {time} start'**
  String scheduleSummaryShort(String day, String time);

  /// No description provided for @confirmAndPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm and pay'**
  String get confirmAndPay;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payByCard.
  ///
  /// In en, this message translates to:
  /// **'Pay by card'**
  String get payByCard;

  /// No description provided for @securePaymentStripe.
  ///
  /// In en, this message translates to:
  /// **'Secure payment with Stripe'**
  String get securePaymentStripe;

  /// No description provided for @chargedAfterClean.
  ///
  /// In en, this message translates to:
  /// **'Card is charged only after the clean is finished.'**
  String get chargedAfterClean;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @bookFor.
  ///
  /// In en, this message translates to:
  /// **'Book for {price}'**
  String bookFor(String price);

  /// No description provided for @slotTakenSnack.
  ///
  /// In en, this message translates to:
  /// **'That time was just taken. Here are the times still free.'**
  String get slotTakenSnack;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'The payment did not go through. Please try again.'**
  String get paymentFailed;

  /// No description provided for @paymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed. Your booking is waiting for payment.'**
  String get paymentCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Cleaner assigned'**
  String get statusAssigned;

  /// No description provided for @statusOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get statusOnTheWay;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelFreeBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelling now is free. You will be refunded in full.'**
  String get cancelFreeBody;

  /// No description provided for @cancelLateBody.
  ///
  /// In en, this message translates to:
  /// **'The visit starts in less than 24 hours, so cancelling now means you are charged the full price ({price}).'**
  String cancelLateBody(String price);

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get keepBooking;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelledRefunded.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled. {price} will be refunded.'**
  String cancelledRefunded(String price);

  /// No description provided for @cancelledCharged.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled. {price} was charged because it was less than 24 hours before the start.'**
  String cancelledCharged(String price);

  /// No description provided for @serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This service is no longer available.'**
  String get serviceUnavailable;

  /// No description provided for @findingCleaner.
  ///
  /// In en, this message translates to:
  /// **'Finding your cleaner'**
  String get findingCleaner;

  /// No description provided for @noCleaner.
  ///
  /// In en, this message translates to:
  /// **'No cleaner'**
  String get noCleaner;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today · {time}'**
  String todayAt(String time);

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @bookAgain.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get bookAgain;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing booked yet'**
  String get noUpcomingTitle;

  /// No description provided for @noUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'Book your first clean in about a minute.'**
  String get noUpcomingBody;

  /// No description provided for @bookAClean.
  ///
  /// In en, this message translates to:
  /// **'Book a clean'**
  String get bookAClean;

  /// No description provided for @noPastTitle.
  ///
  /// In en, this message translates to:
  /// **'No past cleans'**
  String get noPastTitle;

  /// No description provided for @noPastBody.
  ///
  /// In en, this message translates to:
  /// **'Finished and cancelled bookings will show up here.'**
  String get noPastBody;

  /// No description provided for @couldNotLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Could not load more. Tap to retry.'**
  String get couldNotLoadMore;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetails;

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking #{code}'**
  String bookingNumber(String code);

  /// No description provided for @roomsSummary.
  ///
  /// In en, this message translates to:
  /// **'{bedrooms} bed, {bathrooms} bath'**
  String roomsSummary(int bedrooms, int bathrooms);

  /// No description provided for @messageCleaner.
  ///
  /// In en, this message translates to:
  /// **'Message {name}'**
  String messageCleaner(String name);

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @trackCleaner.
  ///
  /// In en, this message translates to:
  /// **'Track your cleaner'**
  String get trackCleaner;

  /// No description provided for @rateYourClean.
  ///
  /// In en, this message translates to:
  /// **'Rate your clean'**
  String get rateYourClean;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get yourReview;

  /// No description provided for @tipAmount.
  ///
  /// In en, this message translates to:
  /// **'Tip {amount}'**
  String tipAmount(String amount);

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @stepConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get stepConfirmed;

  /// No description provided for @stepOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get stepOnTheWay;

  /// No description provided for @stepCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get stepCleaning;

  /// No description provided for @stepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepDone;

  /// No description provided for @arrivingIn.
  ///
  /// In en, this message translates to:
  /// **'Arriving in'**
  String get arrivingIn;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @onTheWayHeadline.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWayHeadline;

  /// No description provided for @startsAt.
  ///
  /// In en, this message translates to:
  /// **'Starts at'**
  String get startsAt;

  /// No description provided for @rightNow.
  ///
  /// In en, this message translates to:
  /// **'Right now'**
  String get rightNow;

  /// No description provided for @cleaningHeadline.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaningHeadline;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get allDone;

  /// No description provided for @bookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingLabel;

  /// No description provided for @needToChange.
  ///
  /// In en, this message translates to:
  /// **'Need to change something?'**
  String get needToChange;

  /// No description provided for @callCleaner.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callCleaner(String name);

  /// No description provided for @callUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Calling is not available yet. Send a message instead.'**
  String get callUnavailable;

  /// No description provided for @howWasYourClean.
  ///
  /// In en, this message translates to:
  /// **'How was your clean?'**
  String get howWasYourClean;

  /// No description provided for @starsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} star'**
  String starsLabel(int count);

  /// No description provided for @ratingNotGreat.
  ///
  /// In en, this message translates to:
  /// **'Not great'**
  String get ratingNotGreat;

  /// No description provided for @ratingCouldBeBetter.
  ///
  /// In en, this message translates to:
  /// **'Could be better'**
  String get ratingCouldBeBetter;

  /// No description provided for @ratingOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get ratingOkay;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// No description provided for @tagSpotless.
  ///
  /// In en, this message translates to:
  /// **'Spotless'**
  String get tagSpotless;

  /// No description provided for @tagPunctual.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get tagPunctual;

  /// No description provided for @tagFriendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get tagFriendly;

  /// No description provided for @tagDetail.
  ///
  /// In en, this message translates to:
  /// **'Great attention to detail'**
  String get tagDetail;

  /// No description provided for @tagEco.
  ///
  /// In en, this message translates to:
  /// **'Used my products'**
  String get tagEco;

  /// No description provided for @anythingElse.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (optional)'**
  String get anythingElse;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Tell {name} what they did well'**
  String commentHint(String name);

  /// No description provided for @addTip.
  ///
  /// In en, this message translates to:
  /// **'Add a tip'**
  String get addTip;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get submitReview;

  /// No description provided for @reviewThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your review!'**
  String get reviewThanks;

  /// No description provided for @alreadyReviewed.
  ///
  /// In en, this message translates to:
  /// **'You have already reviewed this clean.'**
  String get alreadyReviewed;

  /// No description provided for @noMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesTitle;

  /// No description provided for @noMessagesBody.
  ///
  /// In en, this message translates to:
  /// **'Say hello to your cleaner.'**
  String get noMessagesBody;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noChatsTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noChatsTitle;

  /// No description provided for @noChatsBody.
  ///
  /// In en, this message translates to:
  /// **'Once a cleaner accepts your booking you can chat here.'**
  String get noChatsBody;

  /// No description provided for @addYourName.
  ///
  /// In en, this message translates to:
  /// **'Add your name'**
  String get addYourName;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of Tidy?'**
  String get logoutTitle;

  /// No description provided for @chatClosed.
  ///
  /// In en, this message translates to:
  /// **'This conversation is closed.'**
  String get chatClosed;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @cancelScopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel which visits?'**
  String get cancelScopeTitle;

  /// No description provided for @cancelThisVisit.
  ///
  /// In en, this message translates to:
  /// **'This visit only'**
  String get cancelThisVisit;

  /// No description provided for @cancelWholeSeries.
  ///
  /// In en, this message translates to:
  /// **'The whole series'**
  String get cancelWholeSeries;

  /// No description provided for @cancelSeriesHint.
  ///
  /// In en, this message translates to:
  /// **'Future visits without a cleaner are cancelled and refunded, and no new visits are booked.'**
  String get cancelSeriesHint;

  /// No description provided for @cancelledSeriesEnded.
  ///
  /// In en, this message translates to:
  /// **'Cancelled. Your recurring clean has ended.'**
  String get cancelledSeriesEnded;

  /// No description provided for @managePlans.
  ///
  /// In en, this message translates to:
  /// **'Manage recurring cleans'**
  String get managePlans;

  /// No description provided for @plansEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recurring cleans'**
  String get plansEmptyTitle;

  /// No description provided for @plansEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Book a weekly or fortnightly clean and it will show up here.'**
  String get plansEmptyBody;

  /// No description provided for @planNextVisit.
  ///
  /// In en, this message translates to:
  /// **'Next visit {date} at {time}'**
  String planNextVisit(String date, String time);

  /// No description provided for @stopSeries.
  ///
  /// In en, this message translates to:
  /// **'Stop series'**
  String get stopSeries;

  /// No description provided for @stopSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop this series?'**
  String get stopSeriesTitle;

  /// No description provided for @stopSeriesBody.
  ///
  /// In en, this message translates to:
  /// **'Future visits that have no cleaner yet are cancelled and refunded. No new visits will be booked.'**
  String get stopSeriesBody;

  /// No description provided for @seriesStopped.
  ///
  /// In en, this message translates to:
  /// **'The series has ended.'**
  String get seriesStopped;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save card'**
  String get saveCard;

  /// No description provided for @saveCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your card'**
  String get saveCardTitle;

  /// No description provided for @setupNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be charged 48 h before the visit.'**
  String get setupNotice;

  /// No description provided for @cardSaved.
  ///
  /// In en, this message translates to:
  /// **'Card saved. You\'ll be charged 48 h before the visit.'**
  String get cardSaved;

  /// No description provided for @cardDeclined.
  ///
  /// In en, this message translates to:
  /// **'Your card was declined. Check the details or try another card.'**
  String get cardDeclined;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @payNowHint.
  ///
  /// In en, this message translates to:
  /// **'Pay within 30 minutes or the booking is cancelled.'**
  String get payNowHint;

  /// No description provided for @cancelledUnpaid.
  ///
  /// In en, this message translates to:
  /// **'This booking was cancelled because it wasn\'t paid within 30 minutes.'**
  String get cancelledUnpaid;

  /// No description provided for @cancelledNoCleaner.
  ///
  /// In en, this message translates to:
  /// **'This booking was cancelled and refunded because no cleaner could take it. We cancel 2 hours before the start when nobody is assigned.'**
  String get cancelledNoCleaner;
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
