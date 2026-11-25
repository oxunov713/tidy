import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/active_job/presentation/active_job_page.dart';
import 'package:tidy_cleaner/features/auth/presentation/account_status_pages.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/auth/presentation/sign_in_page.dart';
import 'package:tidy_cleaner/features/auth/presentation/splash_page.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_page.dart';
import 'package:tidy_cleaner/features/earnings/presentation/earnings_page.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_page.dart';
import 'package:tidy_cleaner/features/permissions/presentation/location_permission_page.dart';
import 'package:tidy_cleaner/features/profile/presentation/profile_page.dart';
import 'package:tidy_cleaner/features/schedule/presentation/schedule_page.dart';
import 'package:tidy_cleaner/features/shell/presentation/shell_page.dart';
import 'package:tidy_core/tidy_core.dart';

part 'router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const pending = '/pending';
  static const suspended = '/suspended';
  static const jobs = '/jobs';
  static const schedule = '/schedule';
  static const earnings = '/earnings';
  static const profile = '/profile';
  static const locationPermission = '/location-permission';

  static String job(String id) => '/job/$id';
  static String chat(String id) => '/job/$id/chat';
}

/// Where a user with this session belongs. Pure so it can be tested.
String? redirectFor({
  required AsyncValue<User?> session,
  required String location,
}) {
  // Still checking the stored session, or the check failed (offline, server
  // down): stay on the splash screen, which offers a retry. A failed check is
  // not a sign-out.
  if ((session.isLoading || session.hasError) && !session.hasValue) {
    return location == Routes.splash ? null : Routes.splash;
  }
  final user = session.value;
  if (user == null) return location == Routes.signIn ? null : Routes.signIn;

  final home = switch (user.cleaner?.status) {
    CleanerStatus.approved => null,
    CleanerStatus.suspended => Routes.suspended,
    CleanerStatus.pending || null => Routes.pending,
  };
  if (home != null) return location == home ? null : home;

  const outsideApp = {
    Routes.splash,
    Routes.signIn,
    Routes.pending,
    Routes.suspended,
  };
  return outsideApp.contains(location) ? Routes.jobs : null;
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(sessionControllerProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(
      session: ref.read(sessionControllerProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: Routes.pending,
        builder: (context, state) => const PendingReviewPage(),
      ),
      GoRoute(
        path: Routes.suspended,
        builder: (context, state) => const SuspendedPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellPage(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.jobs,
                builder: (context, state) => const JobsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.schedule,
                builder: (context, state) => const SchedulePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.earnings,
                builder: (context, state) => const EarningsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/job/:id',
        builder: (context, state) =>
            ActiveJobPage(bookingId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (context, state) =>
                ChatPage(bookingId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.locationPermission,
        builder: (context, state) => const LocationPermissionPage(),
      ),
    ],
  );
}
