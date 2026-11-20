import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_admin/core/widgets/splash_page.dart';
import 'package:tidy_admin/features/auth/presentation/auth_providers.dart';
import 'package:tidy_admin/features/auth/presentation/login_page.dart';
import 'package:tidy_admin/features/bookings/presentation/bookings_page.dart';
import 'package:tidy_admin/features/cleaners/presentation/cleaners_page.dart';
import 'package:tidy_admin/features/services/presentation/services_page.dart';
import 'package:tidy_admin/features/shell/presentation/admin_shell.dart';

part 'router.g.dart';

const _home = '/bookings';

String _withFrom(String path, GoRouterState state) {
  final from = state.uri.toString();
  final skip = from == '/' || from == _home || from.startsWith('/login');
  return skip
      ? path
      : Uri(path: path, queryParameters: {'from': from}).toString();
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..listen(authControllerProvider, (_, _) => refresh.value++)
    ..onDispose(refresh.dispose);

  String? redirect(BuildContext context, GoRouterState state) {
    final auth = ref.read(authControllerProvider);
    final path = state.matchedLocation;
    final from = state.uri.queryParameters['from'];
    final back = from != null && from.startsWith('/') ? from : _home;

    if (auth.isLoading || auth.hasError) {
      return path == '/splash' ? null : _withFrom('/splash', state);
    }
    if (auth.value == null) {
      return path == '/login' ? null : _withFrom('/login', state);
    }
    if (path == '/login' || path == '/splash' || path == '/') return back;
    return null;
  }

  final router = GoRouter(
    initialLocation: _home,
    refreshListenable: refresh,
    redirect: redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) {
            final auth = ref.watch(authControllerProvider);
            return SplashPage(
              error: auth.hasError ? auth.error : null,
              onRetry: ref.read(authControllerProvider.notifier).retry,
            );
          },
        ),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const BookingsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    BookingsPage(selectedId: state.pathParameters['id']),
              ),
            ],
          ),
          GoRoute(
            path: '/cleaners',
            builder: (context, state) => const CleanersPage(),
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => const ServicesPage(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
