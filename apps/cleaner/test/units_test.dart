import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_cleaner/core/format/formatters.dart';
import 'package:tidy_cleaner/core/maps/maps_launcher.dart';
import 'package:tidy_cleaner/features/auth/presentation/sign_in_controller.dart';
import 'package:tidy_cleaner/features/chat/presentation/chat_controller.dart';
import 'package:tidy_cleaner/features/schedule/domain/availability.dart';
import 'package:tidy_cleaner/features/schedule/domain/day_timeline.dart';
import 'package:tidy_cleaner/router.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fixtures.dart' as fx;
import 'support/harness.dart';

void main() {
  group('redirectFor', () {
    String? go(AsyncValue<User?> s, String at) =>
        redirectFor(session: s, location: at);

    test('waits on the splash while the session loads', () {
      expect(go(const AsyncLoading(), '/jobs'), Routes.splash);
      expect(go(const AsyncLoading(), Routes.splash), isNull);
    });

    test('a failed session check stays on the splash, not on sign-in', () {
      const offline = AsyncError<User?>(NetworkException(), StackTrace.empty);
      expect(go(offline, '/jobs'), Routes.splash);
      expect(go(offline, Routes.signIn), Routes.splash);
      expect(go(offline, Routes.splash), isNull);
    });

    test('signed out users go to sign-in', () {
      expect(go(const AsyncData(null), '/jobs'), Routes.signIn);
      expect(go(const AsyncData(null), Routes.signIn), isNull);
    });

    test('pending cleaners only see the review screen', () {
      final s = AsyncData<User?>(fx.user(status: CleanerStatus.pending));
      expect(go(s, '/jobs'), Routes.pending);
      expect(go(s, Routes.pending), isNull);
    });

    test('suspended cleaners get their own screen', () {
      final s = AsyncData<User?>(fx.user(status: CleanerStatus.suspended));
      expect(go(s, '/jobs'), Routes.suspended);
    });

    test('approved cleaners leave the gate screens', () {
      final s = AsyncData<User?>(fx.user());
      expect(go(s, Routes.signIn), Routes.jobs);
      expect(go(s, Routes.pending), Routes.jobs);
      expect(go(s, '/job/b1'), isNull);
    });
  });

  group('normalizePhone', () {
    test('accepts local formats', () {
      expect(normalizePhone('7700 900123'), '+447700900123');
      expect(normalizePhone('07700 900123'), '+447700900123');
      expect(normalizePhone('+44 7700 900123'), '+447700900123');
    });

    test('rejects too short numbers', () {
      expect(normalizePhone('123'), isNull);
      expect(normalizePhone(''), isNull);
    });
  });

  group('formatters', () {
    test('money drops pence only for whole pounds', () {
      expect(Fmt.payout(8400), '£84');
      expect(Fmt.payout(8450), '£84.50');
      expect(Fmt.poundsShort(9600), '£96');
    });

    test('hours and average per hour use integer rounding', () {
      expect(Fmt.hours(1290), '21.5');
      expect(Fmt.perHour(48600, 1290), 2260);
      expect(Fmt.perHour(100, 0), 0);
    });

    test('countdown', () {
      expect(Fmt.countdown(const Duration(seconds: 42)), '0:42');
      expect(Fmt.countdown(const Duration(seconds: 125)), '2:05');
      expect(Fmt.countdown(const Duration(seconds: -3)), '0:00');
    });
  });

  group('availability', () {
    test('round-trips through API windows', () {
      const draft = AvailabilityDraft(
        weekdays: {0, 2},
        fromMinutes: 510,
        toMinutes: 1020,
      );
      final windows = draft.toWindows();
      expect(windows.map((w) => w.weekday), [0, 2]);
      expect(windows.first.startTime, '08:30');
      expect(windows.first.endTime, '17:00');
      expect(AvailabilityDraft.fromWindows(windows), draft);
    });

    test('end must be after start', () {
      expect(
        AvailabilityDraft.standard.copyWith(toMinutes: 480).isValid,
        isFalse,
      );
      expect(AvailabilityDraft.standard.isValid, isTrue);
    });
  });

  group('day timeline', () {
    Job at(String id, int hour, {int hours = 2}) => Job(
      booking: fx.booking(
        id: id,
        start: DateTime.utc(2026, 12, 3, hour),
        length: Duration(hours: hours),
      ),
      address: fx.address,
      clientName: 'X',
    );

    test('free time before, travel buffer between, free gap when long', () {
      final entries = buildTimeline(
        jobs: [at('a', 10), at('b', 12, hours: 1).copyWith(), at('c', 16)],
        workStart: DateTime.utc(2026, 12, 3, 8).toLocal(),
      );
      expect(entries.map((e) => e.runtimeType.toString()), [
        'TimelineFree',
        'TimelineJob',
        // a ends 12:00 and b starts 12:00: no gap row.
        'TimelineJob',
        'TimelineFree',
        'TimelineJob',
      ]);
    });

    test('a short gap is travel time', () {
      final entries = buildTimeline(
        jobs: [
          at('a', 10),
          Job(
            booking: fx.booking(
              id: 'b',
              start: DateTime.utc(2026, 12, 3, 12, 30),
            ),
            address: fx.address,
            clientName: 'Y',
          ),
        ],
      );
      expect(entries[1], isA<TimelineBuffer>());
      expect((entries[1] as TimelineBuffer).minutes, 30);
    });
  });

  group('maps links', () {
    test('Yandex first, geo: second, website last', () {
      final links = mapLinks(lat: 51.5, lng: -0.1, label: 'Home');
      expect(links[0].scheme, 'yandexmaps');
      expect(links[0].toString(), contains('pt=-0.1,51.5'));
      expect(links[1].scheme, 'geo');
      expect(links[2].scheme, 'https');
    });
  });

  group('chat controller', () {
    test(
      'does not show a message twice when it arrives by both paths',
      () async {
        final h = Harness();
        h.chatRepo.messages = [
          Message(
            id: 1,
            bookingId: 'b1',
            senderId: 'client-1',
            body: 'Hi',
            createdAt: fx.now,
          ),
        ];
        final c = await h.container();
        // Auto-dispose provider: hold it open like a visible screen would.
        c.listen(chatControllerProvider('b1'), (_, _) {});
        await c.read(chatControllerProvider('b1').future);

        await c.read(chatControllerProvider('b1').notifier).send('On my way');
        // The socket echoes the same message (id 101).
        h.gateway.emit(
          MessageReceived(
            bookingId: 'b1',
            message: Message(
              id: 101,
              bookingId: 'b1',
              senderId: 'me',
              body: 'On my way',
              createdAt: fx.now,
            ),
          ),
        );
        h.gateway.emit(
          MessageReceived(
            bookingId: 'other',
            message: Message(
              id: 9,
              bookingId: 'other',
              senderId: 'x',
              body: 'no',
              createdAt: fx.now,
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        final bodies = c
            .read(chatControllerProvider('b1'))
            .value!
            .map((m) => m.body);
        expect(bodies, ['Hi', 'On my way']);
        expect(h.gateway.subscribeCalls, contains(Rooms.booking('b1')));
        c.dispose();
      },
    );
  });
}
