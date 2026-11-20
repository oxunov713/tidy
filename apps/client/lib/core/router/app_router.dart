import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/core/router/main_shell.dart';
import 'package:tidy_client/core/router/routes.dart';
import 'package:tidy_client/core/router/splash_screen.dart';
import 'package:tidy_client/features/addresses/presentation/add_address_screen.dart';
import 'package:tidy_client/features/addresses/presentation/addresses_screen.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/auth/presentation/otp_screen.dart';
import 'package:tidy_client/features/auth/presentation/welcome_screen.dart';
import 'package:tidy_client/features/booking_wizard/presentation/checkout_screen.dart';
import 'package:tidy_client/features/booking_wizard/presentation/configure_screen.dart';
import 'package:tidy_client/features/booking_wizard/presentation/schedule_screen.dart';
import 'package:tidy_client/features/bookings/presentation/booking_details_screen.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_screen.dart';
import 'package:tidy_client/features/home/presentation/home_screen.dart';
import 'package:tidy_client/features/tracking/presentation/tracking_screen.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

const Set<String> _publicRoutes = {Routes.splash, Routes.welcome, Routes.otp};

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Tells go_router to run `redirect` again when the auth state changes.
  final authChanges = ValueNotifier<int>(0);
  ref
    ..listen(authControllerProvider, (_, _) => authChanges.value++)
    ..onDispose(authChanges.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = ref.read(authControllerProvider);
    final location = state.matchedLocation;

    // Still restoring the session, or it could not be restored (offline):
    // the splash screen shows a spinner or a retry button.
    if (auth.isLoading && !auth.hasValue || auth.hasError) {
      return location == Routes.splash ? null : Routes.splash;
    }
    final signedIn = auth.value != null;
    if (!signedIn) {
      return location == Routes.welcome || location == Routes.otp
          ? null
          : Routes.welcome;
    }
    return _publicRoutes.contains(location) ? Routes.home : null;
  }

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: authChanges,
    redirect: redirect,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.otp,
        builder: (context, state) => OtpScreen(phone: state.extra! as String),
      ),
      GoRoute(
        path: Routes.addresses,
        builder: (context, state) => AddressesScreen(
          pick: state.uri.queryParameters['pick'] == '1',
        ),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const AddAddressScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.configure,
        builder: (context, state) => const ConfigureScreen(),
      ),
      GoRoute(
        path: Routes.schedule,
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: Routes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (context, state) =>
            BookingDetailsScreen(bookingId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'track',
            builder: (context, state) =>
                TrackingScreen(bookingId: state.pathParameters['id']!),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.bookings,
                builder: (context, state) => const BookingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.chat,
                builder: (context, state) => const SizedBox.shrink(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
