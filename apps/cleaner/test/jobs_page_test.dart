import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/features/jobs/presentation/jobs_page.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';
import 'support/pump_app.dart';

void main() {
  testWidgets('offline: shows the offline card, no offer', (tester) async {
    final h = Harness()..offersRepo.open_ = [fx.offer()];
    await pumpApp(tester, h, const JobsPage());

    expect(find.text('You are offline'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('NEW REQUEST'), findsNothing);
  });

  testWidgets('the switch goes online with the current position', (
    tester,
  ) async {
    final h = Harness();
    await pumpApp(tester, h, const JobsPage());

    await tester.tap(find.byKey(const Key('onlineSwitch')));
    await settle(tester);

    expect(h.presence.calls, hasLength(1));
    expect(h.presence.calls.single.$1, isTrue);
    expect(h.presence.calls.single.$2, h.location.fix);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Waiting for requests'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onlineSwitch')));
    await settle(tester);
    expect(h.presence.calls.last.$1, isFalse);
    expect(find.text('You are offline'), findsOneWidget);
  });

  testWidgets('without location permission it stays offline', (tester) async {
    final h = Harness();
    h.location.accessResult = LocationAccess.deniedForever;
    await pumpApp(tester, h, const JobsPage());

    await tester.tap(find.byKey(const Key('onlineSwitch')));
    await settle(tester);

    expect(h.presence.calls, isEmpty);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('online: shows the offer with countdown and payout', (
    tester,
  ) async {
    final h = Harness(signedIn: fx.user(online: true))
      ..offersRepo.open_ = [fx.offer()];
    await pumpApp(tester, h, const JobsPage());

    expect(find.text('NEW REQUEST'), findsOneWidget);
    expect(find.text('Deep clean'), findsOneWidget);
    expect(find.text('3 bed · 2 bath · inside fridge'), findsOneWidget);
    expect(find.text('£84'), findsOneWidget);
    expect(find.text('Camden, NW1 · 2.4 km from you'), findsOneWidget);
    expect(find.textContaining('Expires in'), findsOneWidget);
  });

  testWidgets('an offer arriving over the socket appears and can be accepted', (
    tester,
  ) async {
    final h = Harness(signedIn: fx.user(online: true))
      ..offersRepo.acceptResult = fx.booking(id: 'o1');
    await pumpApp(tester, h, const JobsPage());
    expect(find.text('NEW REQUEST'), findsNothing);

    h.gateway.emit(
      OfferReceived(
        booking: fx.offer().booking,
        expiresAt: fx.now.add(const Duration(seconds: 60)),
      ),
    );
    await settle(tester);
    expect(find.text('NEW REQUEST'), findsOneWidget);

    await tester.tap(find.byKey(const Key('acceptOffer')));
    await settle(tester);

    expect(h.offersRepo.accepted, ['o1']);
    expect(find.text('NEW REQUEST'), findsNothing);
  });

  testWidgets('decline removes the offer', (tester) async {
    final h = Harness(signedIn: fx.user(online: true))
      ..offersRepo.open_ = [fx.offer()];
    await pumpApp(tester, h, const JobsPage());

    await tester.tap(find.byKey(const Key('declineOffer')));
    await settle(tester);

    expect(h.offersRepo.declined, ['o1']);
    expect(find.text('NEW REQUEST'), findsNothing);
  });

  testWidgets('header shows the numbers of the day and the next job', (
    tester,
  ) async {
    final h = Harness();
    h.jobsRepo.jobs_ = [
      fx.job(status: BookingStatus.completed, start: fx.now),
      fx.job(id: 'b2', start: fx.now.add(const Duration(hours: 1))),
    ];
    await pumpApp(tester, h, const JobsPage());

    expect(find.text('£96'), findsOneWidget);
    expect(find.text('1 of 2'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('Emma W. · Standard clean'), findsOneWidget);
    expect(find.text('14 Baker Street · £58 payout'), findsOneWidget);
  });

  testWidgets('shows a friendly empty state without jobs', (tester) async {
    final h = Harness();
    await pumpApp(tester, h, const JobsPage());
    expect(find.text('No upcoming jobs'), findsOneWidget);
  });
}
