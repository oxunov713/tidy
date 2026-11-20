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
}
