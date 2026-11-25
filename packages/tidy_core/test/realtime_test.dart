import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'support/fake_channel.dart';
import 'support/fixtures.dart';

String _frame(Map<String, Object?> json) => jsonEncode(json);

void main() {
  group('RealtimeEvent.parse', () {
    test('booking.status', () {
      final event = RealtimeEvent.parse(
        _frame({
          'type': 'booking.status',
          'booking_id': 'b1',
          'status': 'on_the_way',
          'at': '2026-12-03T08:00:00Z',
        }),
      );
      expect(event, isA<BookingStatusChanged>());
      final e = event! as BookingStatusChanged;
      expect(e.bookingId, 'b1');
      expect(e.status, BookingStatus.onTheWay);
      expect(e.at, DateTime.utc(2026, 12, 3, 8));
    });

    test('cleaner.location with and without eta', () {
      final withEta =
          RealtimeEvent.parse(
                _frame({
                  'type': 'cleaner.location',
                  'booking_id': 'b1',
                  'lat': 51.52,
                  'lng': -0.15,
                  'eta_minutes': 12,
                }),
              )!
              as CleanerLocationUpdated;
      expect(withEta.lat, 51.52);
      expect(withEta.etaMinutes, 12);

      final without =
          RealtimeEvent.parse(
                _frame({
                  'type': 'cleaner.location',
                  'booking_id': 'b1',
                  'lat': 51,
                  'lng': 0,
                }),
              )!
              as CleanerLocationUpdated;
      expect(without.lat, 51.0);
      expect(without.etaMinutes, isNull);
    });

    test('offer.new, offer.gone and message.new', () {
      final offer = RealtimeEvent.parse(
        _frame({
          'type': 'offer.new',
          'booking': bookingJson(status: 'confirmed'),
          'expires_at': '2026-12-03T07:01:00Z',
        }),
      );
      expect(offer, isA<OfferReceived>());
      final received = offer! as OfferReceived;
      expect(received.booking.code, 'TD-1000');
      expect(received.booking.status, BookingStatus.confirmed);
      expect(received.expiresAt, DateTime.utc(2026, 12, 3, 7, 1));

      expect(
        RealtimeEvent.parse(_frame({'type': 'offer.gone', 'booking_id': 'b1'})),
        isA<OfferWithdrawn>(),
      );

      final message =
          RealtimeEvent.parse(
                _frame({
                  'type': 'message.new',
                  'booking_id': 'b1',
                  'message': {
                    'id': 7,
                    'booking_id': 'b1',
                    'sender_id': 'u1',
                    'body': 'On my way',
                    'created_at': '2026-12-03T07:50:00Z',
                  },
                }),
              )!
              as MessageReceived;
      expect(message.message.body, 'On my way');
    });

    test('unsubscribed with a reason', () {
      final revoked =
          RealtimeEvent.parse(
                _frame({
                  'type': 'unsubscribed',
                  'room': 'booking:b1',
                  'reason': 'access_revoked',
                }),
              )!
              as RoomUnsubscribed;
      expect(revoked.accessRevoked, isTrue);
      expect(revoked.room, 'booking:b1');

      final plain =
          RealtimeEvent.parse(
                _frame({'type': 'unsubscribed', 'room': 'booking:b1'}),
              )!
              as RoomUnsubscribed;
      expect(plain.accessRevoked, isFalse);
    });

    test('subscribed, unsubscribed and error', () {
      final subscribed =
          RealtimeEvent.parse(
                _frame({'type': 'subscribed', 'room': 'booking:b1'}),
              )!
              as RoomSubscribed;
      expect(subscribed.room, 'booking:b1');

      final unsubscribed =
          RealtimeEvent.parse(
                _frame({'type': 'unsubscribed', 'room': 'booking:b1'}),
              )!
              as RoomUnsubscribed;
      expect(unsubscribed.room, 'booking:b1');

      final error =
          RealtimeEvent.parse(
                _frame({
                  'type': 'error',
                  'code': 'forbidden',
                  'message':
                      'Only the client and the assigned cleaner can '
                      'follow this booking.',
                }),
              )!
              as RealtimeError;
      expect(error.code, 'forbidden');
    });

    test('unknown types are kept, garbage is dropped', () {
      expect(
        RealtimeEvent.parse(_frame({'type': 'something.new'})),
        isA<UnknownRealtimeEvent>(),
      );
      expect(RealtimeEvent.parse('not json'), isNull);
      expect(RealtimeEvent.parse('[1,2]'), isNull);
      expect(RealtimeEvent.parse(_frame({'no': 'type'})), isNull);
      // Known type, broken body.
      expect(
        RealtimeEvent.parse(_frame({'type': 'booking.status'})),
        isNull,
      );
    });
  });

  group('RealtimeClient', () {
    late InMemoryTokenStorage storage;
    late List<FakeChannel> channels;
    late List<Uri> uris;
    late RealtimeClient client;

    RealtimeClient build({
      bool Function(int index)? failHandshake,
      Future<void> Function()? onHandshakeFailed,
    }) {
      channels = [];
      uris = [];
      return RealtimeClient(
        config: const ApiConfig(baseUrl: 'https://tidy.test'),
        tokenStorage: storage,
        onHandshakeFailed: onHandshakeFailed,
        backoff: (_) => const Duration(milliseconds: 5),
        connector: (uri) {
          uris.add(uri);
          final channel = FakeChannel(
            failHandshake: failHandshake?.call(channels.length) ?? false,
          );
          channels.add(channel);
          return channel;
        },
      );
    }

    Future<void> settle([int ms = 40]) =>
        Future<void>.delayed(Duration(milliseconds: ms));

    setUp(() {
      storage = InMemoryTokenStorage(
        const TokenPair(accessToken: 'tok', refreshToken: 'ref'),
      );
    });

    tearDown(() => client.dispose());

    test('connects with the token in the query string over wss', () async {
      client = build();
      await client.connect();
      expect(uris.single.scheme, 'wss');
      expect(uris.single.path, '/api/v1/ws');
      expect(uris.single.queryParameters, {'token': 'tok'});
      expect(client.state, RealtimeConnectionState.connected);
    });

    test('subscribe and location frames use the documented format', () async {
      client = build();
      await client.connect();
      client
        ..subscribe(Rooms.booking('b1'))
        ..sendLocation(bookingId: 'b1', lat: 51.52, lng: -0.15)
        ..unsubscribe(Rooms.booking('b1'));
      expect(channels.single.sent.map(jsonDecode), [
        {'type': 'subscribe', 'room': 'booking:b1'},
        {'type': 'location', 'booking_id': 'b1', 'lat': 51.52, 'lng': -0.15},
        {'type': 'unsubscribe', 'room': 'booking:b1'},
      ]);
    });

    test('emits typed events from server frames', () async {
      client = build();
      final events = <RealtimeEvent>[];
      client.events.listen(events.add);
      await client.connect();
      channels.single.serverSend(
        _frame({'type': 'offer.gone', 'booking_id': 'b9'}),
      );
      await settle(5);
      expect(events.single, isA<OfferWithdrawn>());
    });

    test('reconnects after a drop and re-subscribes to every room', () async {
      client = build();
      await client.connect();
      client
        ..subscribe(Rooms.booking('b1'))
        ..subscribe(Rooms.cleanerOffers);

      await channels.first.serverClose();
      await settle();

      expect(channels, hasLength(2));
      expect(client.state, RealtimeConnectionState.connected);
      expect(
        channels.last.sent.map(jsonDecode),
        unorderedEquals([
          {'type': 'subscribe', 'room': 'booking:b1'},
          {'type': 'subscribe', 'room': 'cleaner:offers'},
        ]),
      );
    });

    test('rooms joined while offline are sent once connected', () async {
      client = build(failHandshake: (i) => i == 0)
        ..subscribe(Rooms.booking('b2'));
      await client.connect();
      expect(client.state, RealtimeConnectionState.connecting);
      await settle();

      expect(channels, hasLength(2));
      expect(client.state, RealtimeConnectionState.connected);
      expect(channels.last.sent.map(jsonDecode), [
        {'type': 'subscribe', 'room': 'booking:b2'},
      ]);
    });

    test(
      'a failed handshake runs the hook and uses the stored token',
      () async {
        var hookCalls = 0;
        client = build(
          failHandshake: (i) => i == 0,
          onHandshakeFailed: () async {
            hookCalls++;
            await storage.write(
              const TokenPair(accessToken: 'fresh', refreshToken: 'ref2'),
            );
          },
        );
        await client.connect();
        await settle();

        expect(hookCalls, 1);
        expect(uris.map((u) => u.queryParameters['token']), ['tok', 'fresh']);
      },
    );

    test('disconnect stops reconnecting', () async {
      client = build();
      await client.connect();
      await client.disconnect();
      await settle();
      expect(channels, hasLength(1));
      expect(client.state, RealtimeConnectionState.disconnected);
    });

    test('does not connect without tokens', () async {
      storage = InMemoryTokenStorage();
      client = build();
      await client.connect();
      expect(channels, isEmpty);
      expect(client.state, RealtimeConnectionState.disconnected);
    });

    group('reference counted rooms', () {
      Iterable<Object?> sent() => channels.single.sent.map(jsonDecode);

      test('two screens share one room: one subscribe frame', () async {
        client = build();
        await client.connect();
        client
          ..subscribe(Rooms.booking('b1'))
          ..subscribe(Rooms.booking('b1'));
        expect(sent(), [
          {'type': 'subscribe', 'room': 'booking:b1'},
        ]);
      });

      test('closing one screen keeps the room for the other', () async {
        client = build();
        await client.connect();
        client
          ..subscribe(Rooms.booking('b1')) // tracking
          ..subscribe(Rooms.booking('b1')) // chat
          ..unsubscribe(Rooms.booking('b1')); // chat closed
        expect(client.rooms, {'booking:b1'});
        expect(sent(), [
          {'type': 'subscribe', 'room': 'booking:b1'},
        ]);

        client.unsubscribe(Rooms.booking('b1')); // tracking closed
        expect(client.rooms, isEmpty);
        expect(sent().last, {'type': 'unsubscribe', 'room': 'booking:b1'});
      });

      test('an unmatched unsubscribe is ignored', () async {
        client = build();
        await client.connect();
        client.unsubscribe(Rooms.booking('nope'));
        expect(sent(), isEmpty);
        client
          ..subscribe(Rooms.booking('b1'))
          ..unsubscribe(Rooms.booking('b1'))
          ..unsubscribe(Rooms.booking('b1'));
        expect(sent(), hasLength(2));
      });

      test('a reconnect joins a shared room once', () async {
        client = build();
        await client.connect();
        client
          ..subscribe(Rooms.booking('b1'))
          ..subscribe(Rooms.booking('b1'));
        await channels.first.serverClose();
        await settle();
        expect(channels.last.sent.map(jsonDecode), [
          {'type': 'subscribe', 'room': 'booking:b1'},
        ]);
      });

      test('disconnect forgets the rooms', () async {
        client = build();
        await client.connect();
        client.subscribe(Rooms.booking('b1'));
        await client.disconnect();
        expect(client.rooms, isEmpty);
        client.unsubscribe(Rooms.booking('b1'));
      });
    });

    group('access_revoked', () {
      test('drops the room, is delivered, and is not rejoined', () async {
        client = build();
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        client
          ..subscribe(Rooms.booking('b1'))
          ..subscribe(Rooms.booking('b1'));

        channels.single.serverSend(
          _frame({
            'type': 'unsubscribed',
            'room': 'booking:b1',
            'reason': 'access_revoked',
          }),
        );
        await settle(5);

        expect(client.rooms, isEmpty);
        final revoked = events.whereType<RoomUnsubscribed>().single;
        expect(revoked.accessRevoked, isTrue);

        // The screens let go later; that must not send anything.
        client
          ..unsubscribe(Rooms.booking('b1'))
          ..unsubscribe(Rooms.booking('b1'));
        expect(channels.single.sent.map(jsonDecode), [
          {'type': 'subscribe', 'room': 'booking:b1'},
        ]);

        await channels.first.serverClose();
        await settle();
        expect(channels.last.sent, isEmpty);
      });

      test('other rooms stay joined', () async {
        client = build();
        await client.connect();
        client
          ..subscribe(Rooms.booking('b1'))
          ..subscribe(Rooms.booking('b2'));
        channels.single.serverSend(
          _frame({
            'type': 'unsubscribed',
            'room': 'booking:b1',
            'reason': 'access_revoked',
          }),
        );
        await settle(5);
        expect(client.rooms, {'booking:b2'});
      });
    });

    group('Reconnected', () {
      test('is not emitted for the first connection', () async {
        client = build();
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        await settle(5);
        expect(events.whereType<Reconnected>(), isEmpty);
      });

      test('is emitted after a drop, once the rooms are rejoined', () async {
        client = build();
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        client.subscribe(Rooms.booking('b1'));

        await channels.first.serverClose();
        await settle();

        expect(events.whereType<Reconnected>(), hasLength(1));
        expect(channels.last.sent, isNotEmpty);
      });

      test('is emitted when the first attempt failed', () async {
        client = build(failHandshake: (i) => i == 0);
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        await settle();
        expect(events.whereType<Reconnected>(), hasLength(1));
      });

      test('a second drop emits a second event', () async {
        client = build();
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        await channels.first.serverClose();
        await settle();
        await channels[1].serverClose();
        await settle();
        expect(events.whereType<Reconnected>(), hasLength(2));
      });

      test('a new session starts without one', () async {
        client = build();
        final events = <RealtimeEvent>[];
        client.events.listen(events.add);
        await client.connect();
        await channels.first.serverClose();
        await client.disconnect();
        await client.connect();
        await settle();
        expect(events.whereType<Reconnected>(), isEmpty);
      });
    });

    group('sign-out then sign-in while connecting', () {
      test('a socket opened for the previous user is dropped', () async {
        final gate = Completer<void>();
        channels = [];
        uris = [];
        client = RealtimeClient(
          config: const ApiConfig(baseUrl: 'https://tidy.test'),
          tokenStorage: storage,
          backoff: (_) => const Duration(milliseconds: 5),
          connector: (uri) {
            uris.add(uri);
            // The first handshake hangs until the gate opens.
            final channel = FakeChannel(
              readyWhen: channels.isEmpty ? gate.future : null,
            );
            channels.add(channel);
            return channel;
          },
        );

        // User A starts connecting and the handshake stalls.
        final first = client.connect();
        await settle(5);
        expect(uris.single.queryParameters['token'], 'tok');

        // A signs out, B signs in: new token, new connect().
        await client.disconnect();
        await storage.write(
          const TokenPair(accessToken: 'token-b', refreshToken: 'ref-b'),
        );
        await client.connect();
        expect(uris.last.queryParameters['token'], 'token-b');

        // A's handshake finally completes.
        gate.complete();
        await first;
        await settle();

        expect(channels.first.closed, isTrue, reason: 'A socket is closed');
        expect(channels, hasLength(2));
        expect(client.state, RealtimeConnectionState.connected);
        client.subscribe(Rooms.booking('b1'));
        expect(channels.first.sent, isEmpty);
        expect(channels.last.sent.map(jsonDecode), [
          {'type': 'subscribe', 'room': 'booking:b1'},
        ]);
      });

      test('a failed attempt of the old session does not reconnect', () async {
        final gate = Completer<void>();
        channels = [];
        uris = [];
        client = RealtimeClient(
          config: const ApiConfig(baseUrl: 'https://tidy.test'),
          tokenStorage: storage,
          backoff: (_) => const Duration(milliseconds: 5),
          connector: (uri) {
            uris.add(uri);
            final channel = FakeChannel(
              readyWhen: channels.isEmpty
                  ? gate.future.then<void>(
                      (_) => throw WebSocketChannelException('late'),
                    )
                  : null,
            );
            channels.add(channel);
            return channel;
          },
        );

        final first = client.connect();
        await settle(5);
        await client.disconnect();
        await client.connect();
        gate.complete();
        await first;
        await settle();

        // One socket for A (failed) and exactly one for B.
        expect(channels, hasLength(2));
        expect(client.state, RealtimeConnectionState.connected);
      });
    });

    test('backoff grows and is capped at about 30 seconds', () {
      final delays = [for (var i = 0; i < 12; i++) defaultBackoff(i)];
      expect(delays.first.inMilliseconds, inInclusiveRange(400, 600));
      expect(delays[3].inMilliseconds, greaterThan(delays[0].inMilliseconds));
      expect(delays.last.inMilliseconds, lessThanOrEqualTo(36000));
    });
  });
}
