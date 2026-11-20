import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidy_cleaner/core/alerts/offer_alerts.dart';
import 'package:tidy_cleaner/core/clock.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/core/storage/preferences.dart';
import 'package:tidy_cleaner/features/auth/presentation/session_controller.dart';
import 'package:tidy_cleaner/features/chat/data/api_chat_repository.dart';
import 'package:tidy_cleaner/features/earnings/data/api_earnings_repository.dart';
import 'package:tidy_cleaner/features/jobs/data/cleaner_repositories.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

import 'fakes.dart';
import 'fixtures.dart' as fx;

class FakeSession extends SessionController {
  FakeSession(this._user);

  final User? _user;

  @override
  Future<User?> build() async => _user;
}

/// Every dependency of the controllers as a fake, wired into providers.
class Harness {
  Harness({User? signedIn, DateTime Function()? clock})
    : user = signedIn ?? fx.user(),
      clock = clock ?? (() => fx.now);

  final User user;
  final DateTime Function() clock;
  final gateway = FakeRealtimeClient();
  final location = FakeLocation();
  final alerts = FakeAlerts();
  final offersRepo = FakeOffersRepository();
  final jobsRepo = FakeJobsRepository();
  final presence = FakePresence();
  final earningsRepo = FakeEarningsRepository(fx.earnings());
  final chatRepo = FakeChatRepository();

  List<Override> get overrides => [
    sessionControllerProvider.overrideWith(() => FakeSession(user)),
    realtimeClientProvider.overrideWithValue(gateway),
    locationServiceProvider.overrideWithValue(location),
    offerAlertsProvider.overrideWithValue(alerts),
    offersRepositoryProvider.overrideWithValue(offersRepo),
    jobsRepositoryProvider.overrideWithValue(jobsRepo),
    presenceRepositoryProvider.overrideWithValue(presence),
    earningsRepositoryProvider.overrideWithValue(earningsRepo),
    chatRepositoryProvider.overrideWithValue(chatRepo),
    clockProvider.overrideWithValue(clock),
  ];

  /// Starts with an empty preferences store; the job store needs one.
  Future<ProviderContainer> container({
    Map<String, Object> prefs = const {},
  }) async {
    // The lifecycle provider needs a binding even in plain unit tests.
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(prefs);
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        ...overrides,
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
    );
    // The session is async; wait so currentUserId has a value.
    await container.read(sessionControllerProvider.future);
    return container;
  }
}
