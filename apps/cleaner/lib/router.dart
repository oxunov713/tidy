import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_cleaner/features/auth/presentation/account_status_pages.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/auth/presentation/sign_in_page.dart';
import 'package:tidy_core/tidy_core.dart';

part 'router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const pending = '/pending';
  static const suspended = '/suspended';
  static const jobs = '/jobs';
}

/// Where a user with this session belongs. Pure so it can be tested.
String? redirectFor({
  required AsyncValue<User?> session,
  required String location,
}) {
  if (session.isLoading && !session.hasValue) {
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
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
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
      GoRoute(
        path: Routes.jobs,
        builder: (context, state) => const Scaffold(),
      ),
    ],
  );
}
