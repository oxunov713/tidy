/// Every path in the app, in one place.
abstract final class Routes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const otp = '/otp';

  static const home = '/home';
  static const bookings = '/bookings';
  static const chat = '/chat';
  static const profile = '/profile';

  static const addresses = '/addresses';
  static const addAddress = '/addresses/new';

  static const configure = '/book/configure';
  static const schedule = '/book/schedule';
  static const checkout = '/book/checkout';

  static String booking(String id) => '/booking/$id';
  static String track(String id) => '/booking/$id/track';
  static String review(String id) => '/booking/$id/review';
  static String bookingChat(String id) => '/booking/$id/chat';
}
