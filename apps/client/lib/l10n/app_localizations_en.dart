// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tidy';

  @override
  String get back => 'Back';

  @override
  String get trackingEnded => 'Live updates for this visit have ended.';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get errorSlotTaken => 'That time was just booked by someone else.';

  @override
  String get errorTooManyRequests => 'Too many attempts. Please wait a moment.';

  @override
  String get errorWrongRole =>
      'This number belongs to a cleaner account. Use the Tidy Pro app instead.';

  @override
  String get errorForbidden => 'You do not have permission to do that.';

  @override
  String get errorNotFound => 'We could not find that.';

  @override
  String get errorInvalidTransition =>
      'That is not possible for this booking any more.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorServer =>
      'Our servers are having trouble. Please try again soon.';

  @override
  String get errorGeneric => 'Something unexpected happened. Please try again.';

  @override
  String stepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcomeTitle => 'A spotless home, booked in a minute.';

  @override
  String get welcomeSubtitle =>
      'Vetted local cleaners, fixed prices, and live tracking from booking to done.';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneInvalid => 'Enter a valid phone number';

  @override
  String get sendCode => 'Send code';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSoon =>
      'Google sign in is coming soon. Use your phone number for now.';

  @override
  String get termsNotice =>
      'By continuing you agree to the Terms and Privacy Policy.';

  @override
  String get selectCountry => 'Select country';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String resendIn(int seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String get codeSent => 'A new code is on its way.';

  @override
  String get fieldRequired => 'Required';

  @override
  String get dropPinFirst => 'Tap the map to drop a pin on your home first.';

  @override
  String get pinDropped => 'Pin placed. Tap to move it.';

  @override
  String get tapToDropPin => 'Tap the map to drop a pin';

  @override
  String get addAddressTitle => 'Where should we clean?';

  @override
  String get addressLine1 => 'Address line 1';

  @override
  String get addressLine2 => 'Flat, floor (optional)';

  @override
  String get city => 'City';

  @override
  String get postcode => 'Postcode';

  @override
  String get accessNotes => 'Access notes for the cleaner';

  @override
  String get accessNotesHint => 'Key in the lockbox, ring the top bell...';

  @override
  String get saveAddress => 'Save address';

  @override
  String get chooseAddress => 'Choose address';

  @override
  String get myAddresses => 'My addresses';

  @override
  String get noAddressesTitle => 'No addresses yet';

  @override
  String get noAddressesBody =>
      'Add the place you want cleaned and drop a pin so cleaners can find it.';

  @override
  String get addAddress => 'Add address';

  @override
  String get deleteAddress => 'Delete';

  @override
  String get deleteAddressTitle => 'Delete this address?';

  @override
  String homeGreeting(String name) {
    return 'Hi $name, what needs a clean today?';
  }

  @override
  String get homeGreetingAnonymous => 'Hi, what needs a clean today?';

  @override
  String get cleaningAt => 'Cleaning at';

  @override
  String get addYourAddress => 'Add your address';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'You\'re all caught up.';

  @override
  String get promoBadge => '20% OFF';

  @override
  String get promoTitle => 'Your first deep clean';

  @override
  String get promoCode => 'Code TIDY20 at checkout';

  @override
  String get servicesTitle => 'Services';

  @override
  String get seeAll => 'See all';

  @override
  String get noServicesTitle => 'No services available';

  @override
  String get noServicesBody => 'Check back soon, we are adding more.';

  @override
  String get badgeMostBooked => 'MOST BOOKED';

  @override
  String get badgePremium => 'PREMIUM';

  @override
  String hoursUnit(String value) {
    return '$value h';
  }

  @override
  String get fromLabel => 'FROM';

  @override
  String serviceCardSemantics(String title, String price) {
    return '$title, from $price';
  }

  @override
  String cleanerOnTheWay(String name) {
    return '$name is on the way';
  }

  @override
  String cleanerCleaning(String name) {
    return '$name is cleaning';
  }

  @override
  String cleanerBooked(String name) {
    return '$name is booked for you';
  }

  @override
  String get yourCleanerOnTheWay => 'Your cleaner is on the way';

  @override
  String get yourCleanerCleaning => 'Your cleaner is cleaning';

  @override
  String get yourCleanerBooked => 'A cleaner is booked for you';

  @override
  String get cardDetailInvalid => 'Check this field';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get testMode => 'Test mode';

  @override
  String get testModeNotice => 'No real payment is made. Use any card details.';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardExpiry => 'MM/YY';

  @override
  String get cardCvc => 'CVC';

  @override
  String get chooseServiceFirst => 'Pick a service to start a booking.';

  @override
  String get sizeOfHome => 'Size of your home';

  @override
  String get bedrooms => 'Bedrooms';

  @override
  String get bedroomsHint => 'Living room included';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String get bathroomsHint => 'Toilet, shower or bath';

  @override
  String get addBedroom => 'Add bedroom';

  @override
  String get removeBedroom => 'Remove bedroom';

  @override
  String get addBathroom => 'Add bathroom';

  @override
  String get removeBathroom => 'Remove bathroom';

  @override
  String get extras => 'Extras';

  @override
  String get howOften => 'How often?';

  @override
  String get frequencyOnce => 'One-off';

  @override
  String get frequencyOnceNote => 'No discount';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyWeeklyNote => '15% off';

  @override
  String get frequencyFortnightly => 'Fortnightly';

  @override
  String get frequencyFortnightlyNote => '10% off';

  @override
  String get chooseTime => 'Choose time';

  @override
  String get total => 'Total';

  @override
  String totalWithHours(String hours) {
    return 'Total · $hours h';
  }

  @override
  String get whenShouldWeCome => 'When should we come?';

  @override
  String get nextSevenDays => 'Next 7 days';

  @override
  String get startTime => 'Start time';

  @override
  String get takenTimesNote =>
      'Greyed-out times are already booked by all nearby cleaners.';

  @override
  String get noTimesThatDay => 'No times left on this day. Try another day.';

  @override
  String get cleaner => 'Cleaner';

  @override
  String get anyCleaner => 'Any available cleaner';

  @override
  String get anyCleanerNote =>
      'We will match you with the best available cleaner nearby.';

  @override
  String yourLastCleaner(String name) {
    return '$name · your last cleaner';
  }

  @override
  String ratingAndReviews(String rating, int count) {
    return '$rating rating · $count reviews';
  }

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get pickATime => 'Pick a day and a start time';

  @override
  String scheduleSummary(String day, String time, String hours) {
    return '$day · $time start · about $hours h';
  }

  @override
  String scheduleSummaryShort(String day, String time) {
    return '$day · $time start';
  }

  @override
  String get confirmAndPay => 'Confirm and pay';

  @override
  String get change => 'Change';

  @override
  String get summary => 'Summary';

  @override
  String get payment => 'Payment';

  @override
  String get payByCard => 'Pay by card';

  @override
  String get securePaymentStripe => 'Secure payment with Stripe';

  @override
  String get chargedAfterClean =>
      'Card is charged only after the clean is finished.';

  @override
  String get book => 'Book';

  @override
  String bookFor(String price) {
    return 'Book for $price';
  }

  @override
  String get slotTakenSnack =>
      'That time was just taken. Here are the times still free.';

  @override
  String get paymentFailed =>
      'The payment did not go through. Please try again.';

  @override
  String get paymentCancelled =>
      'Payment was not completed. Your booking is waiting for payment.';

  @override
  String get statusPending => 'Awaiting payment';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusAssigned => 'Cleaner assigned';

  @override
  String get statusOnTheWay => 'On the way';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Done';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get cancelBookingTitle => 'Cancel this booking?';

  @override
  String get cancelFreeBody =>
      'Cancelling now is free. You will be refunded in full.';

  @override
  String cancelLateBody(String price) {
    return 'The visit starts in less than 24 hours, so cancelling now means you are charged the full price ($price).';
  }

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String cancelledRefunded(String price) {
    return 'Booking cancelled. $price will be refunded.';
  }

  @override
  String cancelledCharged(String price) {
    return 'Booking cancelled. $price was charged because it was less than 24 hours before the start.';
  }

  @override
  String get serviceUnavailable => 'This service is no longer available.';

  @override
  String get findingCleaner => 'Finding your cleaner';

  @override
  String get noCleaner => 'No cleaner';

  @override
  String todayAt(String time) {
    return 'Today · $time';
  }

  @override
  String get track => 'Track';

  @override
  String get rate => 'Rate';

  @override
  String get bookAgain => 'Book again';

  @override
  String get details => 'Details';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get noUpcomingTitle => 'Nothing booked yet';

  @override
  String get noUpcomingBody => 'Book your first clean in about a minute.';

  @override
  String get bookAClean => 'Book a clean';

  @override
  String get noPastTitle => 'No past cleans';

  @override
  String get noPastBody => 'Finished and cancelled bookings will show up here.';

  @override
  String get couldNotLoadMore => 'Could not load more. Tap to retry.';

  @override
  String get bookingDetails => 'Booking details';

  @override
  String bookingNumber(String code) {
    return 'Booking #$code';
  }

  @override
  String roomsSummary(int bedrooms, int bathrooms) {
    return '$bedrooms bed, $bathrooms bath';
  }

  @override
  String messageCleaner(String name) {
    return 'Message $name';
  }

  @override
  String get discount => 'Discount';

  @override
  String get trackCleaner => 'Track your cleaner';

  @override
  String get rateYourClean => 'Rate your clean';

  @override
  String get yourReview => 'Your review';

  @override
  String tipAmount(String amount) {
    return 'Tip $amount';
  }

  @override
  String get timeline => 'Timeline';

  @override
  String get stepConfirmed => 'Confirmed';

  @override
  String get stepOnTheWay => 'On the way';

  @override
  String get stepCleaning => 'Cleaning';

  @override
  String get stepDone => 'Done';

  @override
  String get arrivingIn => 'Arriving in';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get onTheWayHeadline => 'On the way';

  @override
  String get startsAt => 'Starts at';

  @override
  String get rightNow => 'Right now';

  @override
  String get cleaningHeadline => 'Cleaning';

  @override
  String get finished => 'Finished';

  @override
  String get allDone => 'All done';

  @override
  String get bookingLabel => 'Booking';

  @override
  String get needToChange => 'Need to change something?';

  @override
  String callCleaner(String name) {
    return 'Call $name';
  }

  @override
  String get callUnavailable =>
      'Calling is not available yet. Send a message instead.';

  @override
  String get howWasYourClean => 'How was your clean?';

  @override
  String starsLabel(int count) {
    return '$count star';
  }

  @override
  String get ratingNotGreat => 'Not great';

  @override
  String get ratingCouldBeBetter => 'Could be better';

  @override
  String get ratingOkay => 'Okay';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingExcellent => 'Excellent';

  @override
  String get tagSpotless => 'Spotless';

  @override
  String get tagPunctual => 'On time';

  @override
  String get tagFriendly => 'Friendly';

  @override
  String get tagDetail => 'Great attention to detail';

  @override
  String get tagEco => 'Used my products';

  @override
  String get anythingElse => 'Anything else? (optional)';

  @override
  String commentHint(String name) {
    return 'Tell $name what they did well';
  }

  @override
  String get addTip => 'Add a tip';

  @override
  String get submitReview => 'Submit review';

  @override
  String get reviewThanks => 'Thanks for your review!';

  @override
  String get alreadyReviewed => 'You have already reviewed this clean.';

  @override
  String get noMessagesTitle => 'No messages yet';

  @override
  String get noMessagesBody => 'Say hello to your cleaner.';

  @override
  String get messageHint => 'Message';

  @override
  String get send => 'Send';

  @override
  String get noChatsTitle => 'No conversations yet';

  @override
  String get noChatsBody =>
      'Once a cleaner accepts your booking you can chat here.';

  @override
  String get addYourName => 'Add your name';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email (optional)';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get logout => 'Log out';

  @override
  String get logoutTitle => 'Log out of Tidy?';

  @override
  String get chatClosed => 'This conversation is closed.';

  @override
  String get loading => 'Loading';

  @override
  String get cancelScopeTitle => 'Cancel which visits?';

  @override
  String get cancelThisVisit => 'This visit only';

  @override
  String get cancelWholeSeries => 'The whole series';

  @override
  String get cancelSeriesHint =>
      'Future visits without a cleaner are cancelled and refunded, and no new visits are booked.';

  @override
  String get cancelledSeriesEnded =>
      'Cancelled. Your recurring clean has ended.';

  @override
  String get managePlans => 'Manage recurring cleans';

  @override
  String get plansEmptyTitle => 'No recurring cleans';

  @override
  String get plansEmptyBody =>
      'Book a weekly or fortnightly clean and it will show up here.';

  @override
  String planNextVisit(String date, String time) {
    return 'Next visit $date at $time';
  }

  @override
  String get stopSeries => 'Stop series';

  @override
  String get stopSeriesTitle => 'Stop this series?';

  @override
  String get stopSeriesBody =>
      'Future visits that have no cleaner yet are cancelled and refunded. No new visits will be booked.';

  @override
  String get seriesStopped => 'The series has ended.';

  @override
  String get saveCard => 'Save card';

  @override
  String get saveCardTitle => 'Save your card';

  @override
  String get setupNotice => 'You\'ll be charged 48 h before the visit.';

  @override
  String get cardSaved =>
      'Card saved. You\'ll be charged 48 h before the visit.';

  @override
  String get cardDeclined =>
      'Your card was declined. Check the details or try another card.';

  @override
  String get payNow => 'Pay now';

  @override
  String get payNowHint => 'Pay within 30 minutes or the booking is cancelled.';

  @override
  String get cancelledUnpaid =>
      'This booking was cancelled because it wasn\'t paid within 30 minutes.';

  @override
  String get cancelledNoCleaner =>
      'This booking was cancelled and refunded because no cleaner could take it. We cancel 2 hours before the start when nobody is assigned.';
}
