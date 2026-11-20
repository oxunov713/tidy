import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/testing.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_channel.dart';

void main() {
  group('bookingEvents on a real RealtimeClient', () {
    late FakeChannel channel;
    late RealtimeClient client;

    setUp(() async {
      channel = FakeChannel();
      client = RealtimeClient(
        config: const ApiConfig(baseUrl: 'https://tidy.test'),
        tokenStorage: InMemoryTokenStorage(
          const TokenPair(accessToken: 't', refreshToken: 'r'),
        ),
        connector: (_) => channel,
      );
      await client.connect();
    });

    tearDown(() => client.dispose());

    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 5));

    String status(String id) => jsonEncode({
      'type': 'booking.status',
      'booking_id': id,
      'status': 'on_the_way',
      'at': '2026-12-03T08:00:00Z',
    });

    test('closing the chat keeps tracking alive on the shared room', () async {
      final tracking = <RealtimeEvent>[];
      final chat = <RealtimeEvent>[];
      final trackingSub = client.bookingEvents('b1').listen(tracking.add);
      final chatSub = client.bookingEvents('b1').listen(chat.add);

      // One subscribe frame for two listeners.
      expect(channel.sent.map(jsonDecode), [
        {'type': 'subscribe', 'room': 'booking:b1'},
      ]);

      await chatSub.cancel(); // the chat screen is closed
      expect(channel.sent, hasLength(1), reason: 'room is not left');

      channel.serverSend(status('b1'));
      await settle();
      expect(tracking.whereType<BookingStatusChanged>(), hasLength(1));
      expect(chat, isEmpty);

      await trackingSub.cancel();
      expect(channel.sent.map(jsonDecode).last, {
        'type': 'unsubscribe',
        'room': 'booking:b1',
      });
    });

    test('only this booking, Reconnected and its own revoke arrive', () async {
      final seen = <RealtimeEvent>[];
      final sub = client.bookingEvents('b1').listen(seen.add);

      channel
        ..serverSend(status('b2'))
        ..serverSend(status('b1'))
        ..serverSend(
          jsonEncode({
            'type': 'unsubscribed',
            'room': 'booking:b2',
            'reason': 'access_revoked',
          }),
        )
        ..serverSend(
          jsonEncode({
            'type': 'unsubscribed',
            'room': 'booking:b1',
            'reason': 'access_revoked',
          }),
        );
      await settle();

      expect(seen, [
        isA<BookingStatusChanged>(),
        isA<RoomUnsubscribed>().having((e) => e.room, 'room', 'booking:b1'),
      ]);
      await sub.cancel();
    });
  });

  group('RoomAccessRevoked', () {
    test('turns true for its own room only', () async {
      final realtime = FakeRealtimeClient();
      final container = ProviderContainer(
        overrides: [realtimeClientProvider.overrideWithValue(realtime)],
      );
      addTearDown(container.dispose);

      final b1 = container.listen(
        roomAccessRevokedProvider('booking:b1'),
        (_, _) {},
      );
      final b2 = container.listen(
        roomAccessRevokedProvider('booking:b2'),
        (_, _) {},
      );
      expect(b1.read(), isFalse);

      realtime.emit(
        const RoomUnsubscribed('booking:b1', reason: 'access_revoked'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(b1.read(), isTrue);
      expect(b2.read(), isFalse);
    });

    test('a plain unsubscribe is not a revoke', () async {
      final realtime = FakeRealtimeClient();
      final container = ProviderContainer(
        overrides: [realtimeClientProvider.overrideWithValue(realtime)],
      );
      addTearDown(container.dispose);
      final sub = container.listen(
        roomAccessRevokedProvider('booking:b1'),
        (_, _) {},
      );
      realtime.emit(const RoomUnsubscribed('booking:b1'));
      await Future<void>.delayed(Duration.zero);
      expect(sub.read(), isFalse);
    });
  });

  group('FakeRealtimeClient', () {
    test('counts rooms like the real client', () {
      final fake = FakeRealtimeClient()
        ..subscribe('booking:b1')
        ..subscribe('booking:b1')
        ..unsubscribe('booking:b1');
      expect(fake.rooms, {'booking:b1'});
      fake.unsubscribe('booking:b1');
      expect(fake.rooms, isEmpty);
    });
  });
}
