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
  /// **'Tidy Admin'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @accountMenu.
  ///
  /// In en, this message translates to:
  /// **'Account menu'**
  String get accountMenu;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorSlotTaken.
  ///
  /// In en, this message translates to:
  /// **'This cleaner already has a job at that time. Pick someone else.'**
  String get errorSlotTaken;

  /// No description provided for @errorInvalidTransition.
  ///
  /// In en, this message translates to:
  /// **'The booking is in a state where this is not possible any more.'**
  String get errorInvalidTransition;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do that.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'That item no longer exists.'**
  String get errorNotFound;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a minute and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. Try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened.'**
  String get errorUnknown;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number of your admin account.'**
  String get loginPhoneSubtitle;

  /// No description provided for @loginCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String loginCodeSubtitle(String phone);

  /// No description provided for @loginPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use the international format, for example +447700900001.'**
  String get loginPhoneInvalid;

  /// No description provided for @loginCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get loginCodeLabel;

  /// No description provided for @loginCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get loginCodeInvalid;

  /// No description provided for @loginSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get loginSendCode;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// No description provided for @loginChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Use a different number'**
  String get loginChangeNumber;

  /// No description provided for @loginNoAdminAccess.
  ///
  /// In en, this message translates to:
  /// **'This account has no admin access.'**
  String get loginNoAdminAccess;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navCleaners.
  ///
  /// In en, this message translates to:
  /// **'Cleaners'**
  String get navCleaners;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get navServices;

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get navMenu;

  /// No description provided for @navExpand.
  ///
  /// In en, this message translates to:
  /// **'Expand menu'**
  String get navExpand;

  /// No description provided for @navCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse menu'**
  String get navCollapse;

  /// No description provided for @statBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'Bookings today'**
  String get statBookingsToday;

  /// No description provided for @statRevenueToday.
  ///
  /// In en, this message translates to:
  /// **'Revenue today'**
  String get statRevenueToday;

  /// No description provided for @statCleanersOnline.
  ///
  /// In en, this message translates to:
  /// **'Cleaners online'**
  String get statCleanersOnline;

  /// No description provided for @statAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get statAwaitingApproval;

  /// No description provided for @searchBookingsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by ID, customer or cleaner'**
  String get searchBookingsHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
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
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @frequencyOnce.
  ///
  /// In en, this message translates to:
  /// **'One-off'**
  String get frequencyOnce;

  /// No description provided for @frequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// No description provided for @frequencyFortnightly.
  ///
  /// In en, this message translates to:
  /// **'Fortnightly'**
  String get frequencyFortnightly;

  /// No description provided for @columnId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get columnId;

  /// No description provided for @columnCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get columnCustomer;

  /// No description provided for @columnService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get columnService;

  /// No description provided for @columnTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get columnTime;

  /// No description provided for @columnCleaner.
  ///
  /// In en, this message translates to:
  /// **'Cleaner'**
  String get columnCleaner;

  /// No description provided for @columnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get columnStatus;

  /// No description provided for @columnAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get columnAmount;

  /// No description provided for @bookingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get bookingsEmptyTitle;

  /// No description provided for @bookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Bookings will show up here as customers place them.'**
  String get bookingsEmpty;

  /// No description provided for @bookingsEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters.'**
  String get bookingsEmptyFiltered;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingDetails;

  /// No description provided for @sectionVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get sectionVisit;

  /// No description provided for @sectionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get sectionCustomer;

  /// No description provided for @sectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get sectionAddress;

  /// No description provided for @sectionCleaner.
  ///
  /// In en, this message translates to:
  /// **'Cleaner'**
  String get sectionCleaner;

  /// No description provided for @sectionPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get sectionPayment;

  /// No description provided for @sectionReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get sectionReview;

  /// No description provided for @sectionTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get sectionTimeline;

  /// No description provided for @fieldService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get fieldService;

  /// No description provided for @fieldWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get fieldWhen;

  /// No description provided for @fieldRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get fieldRooms;

  /// No description provided for @fieldFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get fieldFrequency;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @fieldSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get fieldSubtotal;

  /// No description provided for @fieldDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get fieldDiscount;

  /// No description provided for @fieldTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get fieldTotal;

  /// No description provided for @fieldCleanerPayout.
  ///
  /// In en, this message translates to:
  /// **'Cleaner payout'**
  String get fieldCleanerPayout;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'No cleaner assigned yet.'**
  String get notAssigned;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get timelineEmpty;

  /// No description provided for @assignCleaner.
  ///
  /// In en, this message translates to:
  /// **'Assign a cleaner'**
  String get assignCleaner;

  /// No description provided for @reassignCleaner.
  ///
  /// In en, this message translates to:
  /// **'Reassign cleaner'**
  String get reassignCleaner;

  /// No description provided for @reassignTitle.
  ///
  /// In en, this message translates to:
  /// **'Reassign cleaner'**
  String get reassignTitle;

  /// No description provided for @reassignHint.
  ///
  /// In en, this message translates to:
  /// **'Pick an approved cleaner. They are told about the job straight away.'**
  String get reassignHint;

  /// No description provided for @reassignConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reassign'**
  String get reassignConfirm;

  /// No description provided for @noApprovedCleaners.
  ///
  /// In en, this message translates to:
  /// **'There are no other approved cleaners.'**
  String get noApprovedCleaners;

  /// No description provided for @cleanerReassigned.
  ///
  /// In en, this message translates to:
  /// **'Cleaner reassigned.'**
  String get cleanerReassigned;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking {code}?'**
  String cancelBookingTitle(String code);

  /// No description provided for @cancelBookingBody.
  ///
  /// In en, this message translates to:
  /// **'The customer is refunded in full and the cleaner is told. This cannot be undone.'**
  String get cancelBookingBody;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get keepBooking;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelled;

  /// No description provided for @roomsValue.
  ///
  /// In en, this message translates to:
  /// **'{bedrooms} bed, {bathrooms} bath'**
  String roomsValue(int bedrooms, int bathrooms);

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({count, plural, =1{1 review} other{{count} reviews}})'**
  String ratingSummary(String rating, int count);

  /// No description provided for @reviewRating.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 5'**
  String reviewRating(int rating);

  /// No description provided for @tabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tabPending;

  /// No description provided for @tabApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get tabApproved;

  /// No description provided for @tabSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get tabSuspended;

  /// No description provided for @noPendingCleaners.
  ///
  /// In en, this message translates to:
  /// **'No cleaners waiting for approval.'**
  String get noPendingCleaners;

  /// No description provided for @noApprovedCleanersTab.
  ///
  /// In en, this message translates to:
  /// **'No approved cleaners yet.'**
  String get noApprovedCleanersTab;

  /// No description provided for @noSuspendedCleaners.
  ///
  /// In en, this message translates to:
  /// **'No suspended cleaners.'**
  String get noSuspendedCleaners;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// No description provided for @reinstate.
  ///
  /// In en, this message translates to:
  /// **'Reinstate'**
  String get reinstate;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @cleanerApproved.
  ///
  /// In en, this message translates to:
  /// **'{name} approved.'**
  String cleanerApproved(String name);

  /// No description provided for @cleanerSuspended.
  ///
  /// In en, this message translates to:
  /// **'{name} suspended.'**
  String cleanerSuspended(String name);

  /// No description provided for @cleanerUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the cleaner.'**
  String get cleanerUpdateFailed;

  /// No description provided for @servicesIntro.
  ///
  /// In en, this message translates to:
  /// **'Prices are in pounds. Changes apply to new quotes straight away.'**
  String get servicesIntro;

  /// No description provided for @noServices.
  ///
  /// In en, this message translates to:
  /// **'No services yet.'**
  String get noServices;

  /// No description provided for @columnPerBedroom.
  ///
  /// In en, this message translates to:
  /// **'Per bedroom'**
  String get columnPerBedroom;

  /// No description provided for @columnPerBathroom.
  ///
  /// In en, this message translates to:
  /// **'Per bathroom'**
  String get columnPerBathroom;

  /// No description provided for @columnDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get columnDuration;

  /// No description provided for @columnActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get columnActive;

  /// No description provided for @durationSummary.
  ///
  /// In en, this message translates to:
  /// **'{base} min + {perRoom} per room'**
  String durationSummary(int base, int perRoom);

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get editService;

  /// No description provided for @fieldServiceName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldServiceName;

  /// No description provided for @fieldBasePrice.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get fieldBasePrice;

  /// No description provided for @fieldPerBedroom.
  ///
  /// In en, this message translates to:
  /// **'Per extra bedroom'**
  String get fieldPerBedroom;

  /// No description provided for @fieldPerBathroom.
  ///
  /// In en, this message translates to:
  /// **'Per extra bathroom'**
  String get fieldPerBathroom;

  /// No description provided for @fieldBaseMinutes.
  ///
  /// In en, this message translates to:
  /// **'Base duration'**
  String get fieldBaseMinutes;

  /// No description provided for @fieldMinutesPerRoom.
  ///
  /// In en, this message translates to:
  /// **'Extra time per extra room'**
  String get fieldMinutesPerRoom;

  /// No description provided for @minutesSuffix.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesSuffix;

  /// No description provided for @fieldActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get fieldActive;

  /// No description provided for @fieldActiveHint.
  ///
  /// In en, this message translates to:
  /// **'Inactive services cannot be booked.'**
  String get fieldActiveHint;

  /// No description provided for @validationTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a name of up to 80 characters.'**
  String get validationTitle;

  /// No description provided for @validationPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount in pounds, like 68 or 68.50.'**
  String get validationPrice;

  /// No description provided for @validationPricePositive.
  ///
  /// In en, this message translates to:
  /// **'The price must be more than £0.'**
  String get validationPricePositive;

  /// No description provided for @validationPriceTooHigh.
  ///
  /// In en, this message translates to:
  /// **'The most you can enter is £10,000.'**
  String get validationPriceTooHigh;

  /// No description provided for @validationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Enter whole minutes from {min} to {max}.'**
  String validationMinutes(int min, int max);

  /// No description provided for @serviceSaved.
  ///
  /// In en, this message translates to:
  /// **'Service saved.'**
  String get serviceSaved;

  /// No description provided for @serviceUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the service.'**
  String get serviceUpdateFailed;
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
