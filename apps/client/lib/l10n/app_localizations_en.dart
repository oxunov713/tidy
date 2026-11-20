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
}
