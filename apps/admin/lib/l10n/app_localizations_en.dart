// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tidy Admin';

  @override
  String get retry => 'Try again';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get signOut => 'Sign out';

  @override
  String get accountMenu => 'Account menu';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorSlotTaken =>
      'This cleaner already has a job at that time. Pick someone else.';

  @override
  String get errorInvalidTransition =>
      'The booking is in a state where this is not possible any more.';

  @override
  String get errorUnauthorized => 'Your session has expired. Sign in again.';

  @override
  String get errorForbidden => 'You do not have permission to do that.';

  @override
  String get errorNotFound => 'That item no longer exists.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Wait a minute and try again.';

  @override
  String get errorNetwork => 'Cannot reach the server. Check your connection.';

  @override
  String get errorServer => 'The server had a problem. Try again in a moment.';

  @override
  String get errorUnknown => 'Something unexpected happened.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginPhoneSubtitle =>
      'Enter the phone number of your admin account.';

  @override
  String loginCodeSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String get loginPhoneLabel => 'Phone number';

  @override
  String get loginPhoneInvalid =>
      'Use the international format, for example +447700900001.';

  @override
  String get loginCodeLabel => 'Verification code';

  @override
  String get loginCodeInvalid => 'Enter the 6-digit code.';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginChangeNumber => 'Use a different number';

  @override
  String get loginNoAdminAccess => 'This account has no admin access.';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navCleaners => 'Cleaners';

  @override
  String get navServices => 'Services and prices';

  @override
  String get navMenu => 'Open menu';

  @override
  String get navExpand => 'Expand menu';

  @override
  String get navCollapse => 'Collapse menu';

  @override
  String get statBookingsToday => 'Bookings today';

  @override
  String get statRevenueToday => 'Revenue today';

  @override
  String get statCleanersOnline => 'Cleaners online';

  @override
  String get statAwaitingApproval => 'Awaiting approval';

  @override
  String get searchBookingsHint => 'Search by ID, customer or cleaner';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get filterAll => 'All';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusAssigned => 'Assigned';

  @override
  String get statusOnTheWay => 'On the way';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get frequencyOnce => 'One-off';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyFortnightly => 'Fortnightly';

  @override
  String get columnId => 'ID';

  @override
  String get columnCustomer => 'Customer';

  @override
  String get columnService => 'Service';

  @override
  String get columnTime => 'Time';

  @override
  String get columnCleaner => 'Cleaner';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnAmount => 'Amount';

  @override
  String get bookingsEmptyTitle => 'No bookings found';

  @override
  String get bookingsEmpty =>
      'Bookings will show up here as customers place them.';

  @override
  String get bookingsEmptyFiltered => 'Nothing matches these filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get loadMore => 'Load more';

  @override
  String get bookingDetails => 'Booking';

  @override
  String get sectionVisit => 'Visit';

  @override
  String get sectionCustomer => 'Customer';

  @override
  String get sectionAddress => 'Address';

  @override
  String get sectionCleaner => 'Cleaner';

  @override
  String get sectionPayment => 'Payment';

  @override
  String get sectionReview => 'Review';

  @override
  String get sectionTimeline => 'Timeline';

  @override
  String get fieldService => 'Service';

  @override
  String get fieldWhen => 'When';

  @override
  String get fieldRooms => 'Rooms';

  @override
  String get fieldFrequency => 'Frequency';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldSubtotal => 'Subtotal';

  @override
  String get fieldDiscount => 'Discount';

  @override
  String get fieldTotal => 'Total';

  @override
  String get fieldCleanerPayout => 'Cleaner payout';

  @override
  String get notAssigned => 'No cleaner assigned yet.';

  @override
  String get timelineEmpty => 'No events yet.';

  @override
  String get assignCleaner => 'Assign a cleaner';

  @override
  String get reassignCleaner => 'Reassign cleaner';

  @override
  String get reassignTitle => 'Reassign cleaner';

  @override
  String get reassignHint =>
      'Pick an approved cleaner. They are told about the job straight away.';

  @override
  String get reassignConfirm => 'Reassign';

  @override
  String get noApprovedCleaners => 'There are no other approved cleaners.';

  @override
  String get cleanerReassigned => 'Cleaner reassigned.';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String cancelBookingTitle(String code) {
    return 'Cancel booking $code?';
  }

  @override
  String get cancelBookingBody =>
      'The customer is refunded in full and the cleaner is told. This cannot be undone.';

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get bookingCancelled => 'Booking cancelled.';

  @override
  String roomsValue(int bedrooms, int bathrooms) {
    return '$bedrooms bed, $bathrooms bath';
  }

  @override
  String ratingSummary(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$rating ($_temp0)';
  }

  @override
  String reviewRating(int rating) {
    return 'Rated $rating out of 5';
  }

  @override
  String get tabPending => 'Pending';

  @override
  String get tabApproved => 'Approved';

  @override
  String get tabSuspended => 'Suspended';

  @override
  String get noPendingCleaners => 'No cleaners waiting for approval.';

  @override
  String get noApprovedCleanersTab => 'No approved cleaners yet.';

  @override
  String get noSuspendedCleaners => 'No suspended cleaners.';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get suspend => 'Suspend';

  @override
  String get reinstate => 'Reinstate';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String cleanerApproved(String name) {
    return '$name approved.';
  }

  @override
  String cleanerSuspended(String name) {
    return '$name suspended.';
  }

  @override
  String get cleanerUpdateFailed => 'Could not update the cleaner.';

  @override
  String get servicesIntro =>
      'Prices are in pounds. Changes apply to new quotes straight away.';

  @override
  String get noServices => 'No services yet.';

  @override
  String get columnPerBedroom => 'Per bedroom';

  @override
  String get columnPerBathroom => 'Per bathroom';

  @override
  String get columnDuration => 'Duration';

  @override
  String get columnActive => 'Active';

  @override
  String durationSummary(int base, int perRoom) {
    return '$base min + $perRoom per room';
  }

  @override
  String get editService => 'Edit service';

  @override
  String get fieldServiceName => 'Name';

  @override
  String get fieldBasePrice => 'Base price';

  @override
  String get fieldPerBedroom => 'Per extra bedroom';

  @override
  String get fieldPerBathroom => 'Per extra bathroom';

  @override
  String get fieldBaseMinutes => 'Base duration';

  @override
  String get fieldMinutesPerRoom => 'Extra time per extra room';

  @override
  String get minutesSuffix => 'min';

  @override
  String get fieldActive => 'Active';

  @override
  String get fieldActiveHint => 'Inactive services cannot be booked.';

  @override
  String get validationTitle => 'Enter a name of up to 80 characters.';

  @override
  String get validationPrice => 'Enter an amount in pounds, like 68 or 68.50.';

  @override
  String get validationPricePositive => 'The price must be more than £0.';

  @override
  String get validationPriceTooHigh => 'The most you can enter is £10,000.';

  @override
  String validationMinutes(int min, int max) {
    return 'Enter whole minutes from $min to $max.';
  }

  @override
  String get serviceSaved => 'Service saved.';

  @override
  String get serviceUpdateFailed => 'Could not update the service.';
}
