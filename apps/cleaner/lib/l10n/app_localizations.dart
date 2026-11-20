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
  /// **'Tidy Pro'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

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

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get errorOffline;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a minute and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do that.'**
  String get errorForbidden;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Our servers had a problem. Try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get errorPhoneInvalid;

  /// No description provided for @errorWrongRole.
  ///
  /// In en, this message translates to:
  /// **'This number belongs to a customer account. Use the Tidy customer app instead.'**
  String get errorWrongRole;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Your next job is one tap away.'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accept cleaning jobs near you, follow your day and watch your earnings grow.'**
  String get signInSubtitle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get verifyCode;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Use a different number'**
  String get changeNumber;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get verificationCode;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {phone}'**
  String codeSentTo(String phone);

  /// No description provided for @signInTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the Terms and Privacy Policy.'**
  String get signInTerms;

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is being reviewed'**
  String get pendingTitle;

  /// No description provided for @pendingBody.
  ///
  /// In en, this message translates to:
  /// **'Thanks for signing up! Our team checks every new cleaner, which usually takes a day. You will be able to go online as soon as you are approved.'**
  String get pendingBody;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to check again'**
  String get pullToRefresh;

  /// No description provided for @suspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended'**
  String get suspendedTitle;

  /// No description provided for @suspendedBody.
  ///
  /// In en, this message translates to:
  /// **'You cannot take new jobs right now. Please contact Tidy support if you think this is a mistake.'**
  String get suspendedBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

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

  /// No description provided for @goOnline.
  ///
  /// In en, this message translates to:
  /// **'Go online'**
  String get goOnline;

  /// No description provided for @statToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statToday;

  /// No description provided for @statJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get statJobs;

  /// No description provided for @statRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get statRating;

  /// No description provided for @jobsDoneOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String jobsDoneOfTotal(int done, int total);

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'NEW REQUEST'**
  String get newRequest;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in {time}'**
  String expiresIn(String time);

  /// No description provided for @yourPayout.
  ///
  /// In en, this message translates to:
  /// **'your payout'**
  String get yourPayout;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @bedBath.
  ///
  /// In en, this message translates to:
  /// **'{bedrooms} bed · {bathrooms} bath'**
  String bedBath(int bedrooms, int bathrooms);

  /// No description provided for @offerPlaceDistance.
  ///
  /// In en, this message translates to:
  /// **'{place} · {km} km from you'**
  String offerPlaceDistance(String place, String km);

  /// No description provided for @offerPlaceLoading.
  ///
  /// In en, this message translates to:
  /// **'Area shown after you accept'**
  String get offerPlaceLoading;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineTitle;

  /// No description provided for @offlineBody.
  ///
  /// In en, this message translates to:
  /// **'Go online to start getting jobs near you.'**
  String get offlineBody;

  /// No description provided for @waitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for requests'**
  String get waitingTitle;

  /// No description provided for @waitingBody.
  ///
  /// In en, this message translates to:
  /// **'You will hear a sound the moment a job comes in.'**
  String get waitingBody;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextUp;

  /// No description provided for @noUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming jobs'**
  String get noUpcomingTitle;

  /// No description provided for @noUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'Accepted jobs will show up here.'**
  String get noUpcomingBody;

  /// No description provided for @todayLower.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get todayLower;

  /// No description provided for @tomorrowLower.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrowLower;

  /// No description provided for @payoutAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} payout'**
  String payoutAmount(String amount);

  /// No description provided for @noticeOfferTaken.
  ///
  /// In en, this message translates to:
  /// **'Too late, another cleaner took that job.'**
  String get noticeOfferTaken;

  /// No description provided for @noticeOfferExpired.
  ///
  /// In en, this message translates to:
  /// **'That request expired.'**
  String get noticeOfferExpired;

  /// No description provided for @noticeSlotTaken.
  ///
  /// In en, this message translates to:
  /// **'You already have a job at that time, so it was not accepted.'**
  String get noticeSlotTaken;

  /// No description provided for @noticeOnlineFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not change your status. Please try again.'**
  String get noticeOnlineFailed;

  /// No description provided for @noticeLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We could not find your position. Move to an open area and try again.'**
  String get noticeLocationUnavailable;

  /// No description provided for @noticeLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services to go online.'**
  String get noticeLocationOff;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your location while you work'**
  String get permissionTitle;

  /// No description provided for @permissionBullet1.
  ///
  /// In en, this message translates to:
  /// **'Get job offers close to where you are'**
  String get permissionBullet1;

  /// No description provided for @permissionBullet2.
  ///
  /// In en, this message translates to:
  /// **'Let customers follow you live while you are on the way'**
  String get permissionBullet2;

  /// No description provided for @permissionBullet3.
  ///
  /// In en, this message translates to:
  /// **'Only while the app is open, never in the background'**
  String get permissionBullet3;

  /// No description provided for @permissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get permissionAllow;

  /// No description provided for @permissionNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get permissionNotNow;

  /// No description provided for @permissionBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off for Tidy Pro'**
  String get permissionBlockedTitle;

  /// No description provided for @permissionBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Allow location in your phone settings to go online.'**
  String get permissionBlockedBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @permissionLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are switched off on this phone. Turn them on, then try again.'**
  String get permissionLocationOff;

  /// No description provided for @newRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get newRequestTitle;

  /// No description provided for @jobTitleMeta.
  ///
  /// In en, this message translates to:
  /// **'#{code} · {when} · {payout} payout'**
  String jobTitleMeta(String code, String when, String payout);

  /// No description provided for @jobNotFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find this job'**
  String get jobNotFound;

  /// No description provided for @jobNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been cancelled or moved.'**
  String get jobNotFoundBody;

  /// No description provided for @messageClient.
  ///
  /// In en, this message translates to:
  /// **'Message {name}'**
  String messageClient(String name);

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @mapsFailed.
  ///
  /// In en, this message translates to:
  /// **'No maps app could open this address.'**
  String get mapsFailed;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @stepAccepted.
  ///
  /// In en, this message translates to:
  /// **'Job accepted'**
  String get stepAccepted;

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

  /// No description provided for @stepFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get stepFinished;

  /// No description provided for @checklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @taskKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen surfaces and sink'**
  String get taskKitchen;

  /// No description provided for @taskBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom and toilet'**
  String get taskBathroom;

  /// No description provided for @taskFloors.
  ///
  /// In en, this message translates to:
  /// **'Vacuum and mop floors'**
  String get taskFloors;

  /// No description provided for @taskExtra.
  ///
  /// In en, this message translates to:
  /// **'{title} (extra)'**
  String taskExtra(String title);

  /// No description provided for @ctaOnMyWay.
  ///
  /// In en, this message translates to:
  /// **'I am on my way'**
  String get ctaOnMyWay;

  /// No description provided for @ctaStart.
  ///
  /// In en, this message translates to:
  /// **'I have arrived, start cleaning'**
  String get ctaStart;

  /// No description provided for @ctaFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish job'**
  String get ctaFinish;

  /// No description provided for @ctaDone.
  ///
  /// In en, this message translates to:
  /// **'Job complete'**
  String get ctaDone;

  /// No description provided for @hintThreeHours.
  ///
  /// In en, this message translates to:
  /// **'You can set off up to 3 hours before the start time.'**
  String get hintThreeHours;

  /// No description provided for @sharingLocation.
  ///
  /// In en, this message translates to:
  /// **'Sharing your live location with {name}'**
  String sharingLocation(String name);

  /// No description provided for @tooEarlyTitle.
  ///
  /// In en, this message translates to:
  /// **'A little too early'**
  String get tooEarlyTitle;

  /// No description provided for @tooEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'You can tap “I am on my way” from 3 hours before the start, which is {time} for this job.'**
  String tooEarlyBody(String time);

  /// No description provided for @transitionOutOfSync.
  ///
  /// In en, this message translates to:
  /// **'This job changed in the meantime. We refreshed it.'**
  String get transitionOutOfSync;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @finishConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish this job?'**
  String get finishConfirmTitle;

  /// No description provided for @finishConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The customer will be charged and asked for a review. Check that everything on the list is done.'**
  String get finishConfirmBody;

  /// No description provided for @finishConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Finish job'**
  String get finishConfirmAction;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatTitle(String name);

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Say hello and let {name} know when you are close.'**
  String chatEmptyBody(String name);

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get chatHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Message not sent. Try again.'**
  String get chatSendFailed;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get workingDays;

  /// No description provided for @tapToSwitch.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch'**
  String get tapToSwitch;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @saveHours.
  ///
  /// In en, this message translates to:
  /// **'Save working hours'**
  String get saveHours;

  /// No description provided for @hoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Working hours saved'**
  String get hoursSaved;

  /// No description provided for @hoursInvalid.
  ///
  /// In en, this message translates to:
  /// **'The end time must be after the start time.'**
  String get hoursInvalid;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySun;

  /// No description provided for @weekdayShortMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get weekdayShortSun;

  /// No description provided for @timelineFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get timelineFree;

  /// No description provided for @timelineBuffer.
  ///
  /// In en, this message translates to:
  /// **'Travel buffer · {minutes} min'**
  String timelineBuffer(int minutes);

  /// No description provided for @timelineDayOff.
  ///
  /// In en, this message translates to:
  /// **'No jobs and not a working day'**
  String get timelineDayOff;

  /// No description provided for @timelineNoJobs.
  ///
  /// In en, this message translates to:
  /// **'No jobs this day. You are free from {from} to {to}.'**
  String timelineNoJobs(String from, String to);

  /// No description provided for @timelineJobLine.
  ///
  /// In en, this message translates to:
  /// **'{range} · {place} · {payout}'**
  String timelineJobLine(String range, String place, String payout);

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsTitle;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @jobsAndHours.
  ///
  /// In en, this message translates to:
  /// **'{jobs, plural, =1{1 job} other{{jobs} jobs}} · {hours} h'**
  String jobsAndHours(int jobs, String hours);

  /// No description provided for @payoutDay.
  ///
  /// In en, this message translates to:
  /// **'Payout Mon'**
  String get payoutDay;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @avgPerHour.
  ///
  /// In en, this message translates to:
  /// **'Avg per hour'**
  String get avgPerHour;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @recentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No finished jobs yet'**
  String get recentEmptyTitle;

  /// No description provided for @recentEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Completed jobs and tips will show up here.'**
  String get recentEmptyBody;

  /// No description provided for @recentTip.
  ///
  /// In en, this message translates to:
  /// **'{date} · tip {tip}'**
  String recentTip(String date, String tip);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileBio.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get profileBio;

  /// No description provided for @profileNoBio.
  ///
  /// In en, this message translates to:
  /// **'No bio yet. Ask support to add one.'**
  String get profileNoBio;

  /// No description provided for @profileRating.
  ///
  /// In en, this message translates to:
  /// **'{rating} · {count, plural, =1{1 review} other{{count} reviews}}'**
  String profileRating(String rating, int count);

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone default'**
  String get languageSystem;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will stop receiving job offers on this phone.'**
  String get signOutConfirmBody;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileSaved;
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
