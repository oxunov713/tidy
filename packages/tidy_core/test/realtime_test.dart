import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidy_core/tidy_core.dart';

import 'support/fake_channel.dart';

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
          'booking': {
            'id': 'b1',
            'status': 'confirmed',
            'start': '2026-12-03T08:00:00Z',
          },
          'expires_at': '2026-12-03T07:01:00Z',
        }),
      );
      expect(offer, isA<OfferReceived>());
      expect((offer! as OfferReceived).offer.booking.id, 'b1');

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

    test('backoff grows and is capped at about 30 seconds', () {
      final delays = [for (var i = 0; i < 12; i++) defaultBackoff(i)];
      expect(delays.first.inMilliseconds, inInclusiveRange(400, 600));
      expect(delays[3].inMilliseconds, greaterThan(delays[0].inMilliseconds));
      expect(delays.last.inMilliseconds, lessThanOrEqualTo(36000));
    });
  });
}
