// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tidy Pro';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorOffline =>
      'No connection. Check your internet and try again.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Wait a minute and try again.';

  @override
  String get errorSessionExpired =>
      'Your session expired. Please sign in again.';

  @override
  String get errorForbidden => 'You are not allowed to do that.';

  @override
  String get errorServer => 'Our servers had a problem. Try again in a moment.';

  @override
  String get errorGeneric => 'That did not work. Please try again.';

  @override
  String get errorPhoneInvalid => 'Enter a valid phone number.';

  @override
  String get errorWrongRole =>
      'This number belongs to a customer account. Use the Tidy customer app instead.';

  @override
  String get signInTitle => 'Your next job is one tap away.';

  @override
  String get signInSubtitle =>
      'Accept cleaning jobs near you, follow your day and watch your earnings grow.';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify and continue';

  @override
  String get changeNumber => 'Use a different number';

  @override
  String get verificationCode => '6-digit code';

  @override
  String codeSentTo(String phone) {
    return 'We sent a code to $phone';
  }

  @override
  String get signInTerms =>
      'By continuing you agree to the Terms and Privacy Policy.';

  @override
  String get pendingTitle => 'Your profile is being reviewed';

  @override
  String get pendingBody =>
      'Thanks for signing up! Our team checks every new cleaner, which usually takes a day. You will be able to go online as soon as you are approved.';

  @override
  String get pullToRefresh => 'Pull down to check again';

  @override
  String get suspendedTitle => 'Your account is suspended';

  @override
  String get suspendedBody =>
      'You cannot take new jobs right now. Please contact Tidy support if you think this is a mistake.';

  @override
  String get signOut => 'Sign out';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get navProfile => 'Profile';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get goOnline => 'Go online';

  @override
  String get statToday => 'Today';

  @override
  String get statJobs => 'Jobs';

  @override
  String get statRating => 'Rating';

  @override
  String jobsDoneOfTotal(int done, int total) {
    return '$done of $total';
  }

  @override
  String get newRequest => 'NEW REQUEST';

  @override
  String expiresIn(String time) {
    return 'Expires in $time';
  }

  @override
  String get yourPayout => 'your payout';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get later => 'Later';

  @override
  String bedBath(int bedrooms, int bathrooms) {
    return '$bedrooms bed · $bathrooms bath';
  }

  @override
  String offerPlaceDistance(String place, String km) {
    return '$place · $km km from you';
  }

  @override
  String get offerPlaceLoading => 'Area shown after you accept';

  @override
  String get offlineTitle => 'You are offline';

  @override
  String get offlineBody => 'Go online to start getting jobs near you.';

  @override
  String get waitingTitle => 'Waiting for requests';

  @override
  String get waitingBody => 'You will hear a sound the moment a job comes in.';

  @override
  String get nextUp => 'Next up';

  @override
  String get noUpcomingTitle => 'No upcoming jobs';

  @override
  String get noUpcomingBody => 'Accepted jobs will show up here.';

  @override
  String get todayLower => 'today';

  @override
  String get tomorrowLower => 'tomorrow';

  @override
  String payoutAmount(String amount) {
    return '$amount payout';
  }

  @override
  String get noticeOfferTaken => 'Too late, another cleaner took that job.';

  @override
  String get noticeOfferExpired => 'That request expired.';

  @override
  String get noticeSlotTaken =>
      'You already have a job at that time, so it was not accepted.';

  @override
  String get noticeOnlineFailed =>
      'Could not change your status. Please try again.';

  @override
  String get noticeLocationUnavailable =>
      'We could not find your position. Move to an open area and try again.';

  @override
  String get noticeLocationOff => 'Turn on location services to go online.';

  @override
  String get permissionTitle => 'Share your location while you work';

  @override
  String get permissionBullet1 => 'Get job offers close to where you are';

  @override
  String get permissionBullet2 =>
      'Let customers follow you live while you are on the way';

  @override
  String get permissionBullet3 =>
      'Only while the app is open, never in the background';

  @override
  String get permissionAllow => 'Allow location';

  @override
  String get permissionNotNow => 'Not now';

  @override
  String get permissionBlockedTitle => 'Location is turned off for Tidy Pro';

  @override
  String get permissionBlockedBody =>
      'Allow location in your phone settings to go online.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get permissionLocationOff =>
      'Location services are switched off on this phone. Turn them on, then try again.';

  @override
  String get newRequestTitle => 'New request';

  @override
  String jobTitleMeta(String code, String when, String payout) {
    return '#$code · $when · $payout payout';
  }

  @override
  String get jobNotFound => 'We could not find this job';

  @override
  String get jobNotFoundBody => 'It may have been cancelled or moved.';

  @override
  String messageClient(String name) {
    return 'Message $name';
  }

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get mapsFailed => 'No maps app could open this address.';

  @override
  String get progress => 'Progress';

  @override
  String get stepAccepted => 'Job accepted';

  @override
  String get stepOnTheWay => 'On the way';

  @override
  String get stepCleaning => 'Cleaning';

  @override
  String get stepFinished => 'Finished';

  @override
  String get checklist => 'Checklist';

  @override
  String get taskKitchen => 'Kitchen surfaces and sink';

  @override
  String get taskBathroom => 'Bathroom and toilet';

  @override
  String get taskFloors => 'Vacuum and mop floors';

  @override
  String taskExtra(String title) {
    return '$title (extra)';
  }

  @override
  String get ctaOnMyWay => 'I am on my way';

  @override
  String get ctaStart => 'I have arrived, start cleaning';

  @override
  String get ctaFinish => 'Finish job';

  @override
  String get ctaDone => 'Job complete';

  @override
  String get hintThreeHours =>
      'You can set off up to 3 hours before the start time.';

  @override
  String sharingLocation(String name) {
    return 'Sharing your live location with $name';
  }

  @override
  String get tooEarlyTitle => 'A little too early';

  @override
  String tooEarlyBody(String time) {
    return 'You can tap “I am on my way” from 3 hours before the start, which is $time for this job.';
  }

  @override
  String get transitionOutOfSync =>
      'This job changed in the meantime. We refreshed it.';

  @override
  String get ok => 'OK';

  @override
  String get finishConfirmTitle => 'Finish this job?';

  @override
  String get finishConfirmBody =>
      'The customer will be charged and asked for a review. Check that everything on the list is done.';

  @override
  String get finishConfirmAction => 'Finish job';

  @override
  String chatTitle(String name) {
    return 'Chat with $name';
  }

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String chatEmptyBody(String name) {
    return 'Say hello and let $name know when you are close.';
  }

  @override
  String get chatHint => 'Write a message';

  @override
  String get chatSend => 'Send';

  @override
  String get chatSendFailed => 'Message not sent. Try again.';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get workingDays => 'Working days';

  @override
  String get tapToSwitch => 'Tap to switch';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get saveHours => 'Save working hours';

  @override
  String get hoursSaved => 'Working hours saved';

  @override
  String get hoursInvalid => 'The end time must be after the start time.';

  @override
  String get weekdayMon => 'Monday';

  @override
  String get weekdayTue => 'Tuesday';

  @override
  String get weekdayWed => 'Wednesday';

  @override
  String get weekdayThu => 'Thursday';

  @override
  String get weekdayFri => 'Friday';

  @override
  String get weekdaySat => 'Saturday';

  @override
  String get weekdaySun => 'Sunday';

  @override
  String get weekdayShortMon => 'M';

  @override
  String get weekdayShortTue => 'T';

  @override
  String get weekdayShortWed => 'W';

  @override
  String get weekdayShortThu => 'T';

  @override
  String get weekdayShortFri => 'F';

  @override
  String get weekdayShortSat => 'S';

  @override
  String get weekdayShortSun => 'S';

  @override
  String get timelineFree => 'Free';

  @override
  String timelineBuffer(int minutes) {
    return 'Travel buffer · $minutes min';
  }

  @override
  String get timelineDayOff => 'No jobs and not a working day';

  @override
  String timelineNoJobs(String from, String to) {
    return 'No jobs this day. You are free from $from to $to.';
  }

  @override
  String timelineJobLine(String range, String place, String payout) {
    return '$range · $place · $payout';
  }

  @override
  String get earningsTitle => 'Earnings';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String jobsAndHours(int jobs, String hours) {
    String _temp0 = intl.Intl.pluralLogic(
      jobs,
      locale: localeName,
      other: '$jobs jobs',
      one: '1 job',
    );
    return '$_temp0 · $hours h';
  }

  @override
  String get payoutDay => 'Payout Mon';

  @override
  String get tips => 'Tips';

  @override
  String get avgPerHour => 'Avg per hour';

  @override
  String get recent => 'Recent';

  @override
  String get recentEmptyTitle => 'No finished jobs yet';

  @override
  String get recentEmptyBody => 'Completed jobs and tips will show up here.';

  @override
  String recentTip(String date, String tip) {
    return '$date · tip $tip';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileBio => 'About you';

  @override
  String get profileNoBio => 'No bio yet. Ask support to add one.';

  @override
  String profileRating(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$rating · $_temp0';
  }

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileLanguage => 'Language';

  @override
  String get languageSystem => 'Phone default';

  @override
  String get editName => 'Edit name';

  @override
  String get fullName => 'Full name';

  @override
  String get save => 'Save';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody =>
      'You will stop receiving job offers on this phone.';

  @override
  String get profileSaved => 'Profile updated';
}
